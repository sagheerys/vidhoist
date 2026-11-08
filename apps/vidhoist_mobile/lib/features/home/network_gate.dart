import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../../di.dart';

/// The current network state, **synchronously**.
///
/// The engine in vh_core asks the pull gate before fetching any file, and
/// the question is synchronous on purpose: reading state must not
/// introduce a wait into a critical path. So we hold a snapshot kept
/// up to date from `connectivity_plus` rather than querying on every call.
class NetworkGate {
  NetworkGate({
    Stream<List<ConnectivityResult>>? changes,
    Future<List<ConnectivityResult>> Function()? check,
  }) : _changes = changes ?? Connectivity().onConnectivityChanged,
       _check = check ?? Connectivity().checkConnectivity;

  final Stream<List<ConnectivityResult>> _changes;
  final Future<List<ConnectivityResult>> Function() _check;
  StreamSubscription<List<ConnectivityResult>>? _sub;
  final _restored = StreamController<void>.broadcast();
  final _wifi = StreamController<bool>.broadcast();

  // **Pessimistic before the first reading:** starting
  // optimistically at "Wi-Fi" let a pull start on **mobile data** in the
  // first moments of startup, before the first snapshot arrived, which is
  // exactly what the "Wi-Fi only" setting exists to prevent.
  bool _online = true;
  bool _onWifi = false;
  bool _known = false;
  final _firstSnapshot = Completer<void>();

  bool get online => _online;
  bool get onWifi => _onWifi;

  /// Has a real snapshot arrived from the system yet?
  bool get isKnown => _known;

  /// Completes with the first real snapshot, for whoever runs at startup
  /// and would rather wait a moment than read the pessimistic default.
  Future<void> get ready => _firstSnapshot.future;

  /// Broadcast on the **transition** from disconnected to connected, not on
  /// every network event.
  Stream<void> get onRestored => _restored.stream;

  /// Broadcast when Wi-Fi comes or goes, with whether it is there now.
  Stream<bool> get onWifiChanged => _wifi.stream;

  Future<void> start() async {
    _apply(await _check());
    _sub = _changes.listen(_apply);
  }

  void _apply(List<ConnectivityResult> results) {
    final wasOnline = _online;
    final wasOnWifi = _onWifi;
    final wasKnown = _known;
    _known = true;
    if (!_firstSnapshot.isCompleted) _firstSnapshot.complete();
    _onWifi =
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet);
    _online = results.any((r) => r != ConnectivityResult.none);
    if (!wasOnline && _online && !_restored.isClosed) _restored.add(null);
    if (wasKnown && wasOnWifi != _onWifi && !_wifi.isClosed) _wifi.add(_onWifi);
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await _restored.close();
    await _wifi.close();
  }
}

final networkGateProvider = Provider<NetworkGate>((ref) {
  final gate = NetworkGate();
  unawaited(gate.start());
  ref.onDispose(() => unawaited(gate.dispose()));
  return gate;
});

/// The downloads paused because Wi-Fi went away; their cards say they wait
/// for Wi-Fi, not that they were paused by hand.
final wifiPausedProvider = StateProvider<Set<String>>((ref) => const {});

/// **"Wi-Fi only" pauses rather than cancels** (REPORT §5.5): a download
/// that loses Wi-Fi keeps its partial file, and goes on by itself when
/// Wi-Fi comes back. One paused by hand is left as it is.
final wifiPauseProvider = Provider<void>((ref) {
  final gate = ref.watch(networkGateProvider);
  final sub = gate.onWifiChanged.listen((onWifi) {
    final engine = ref.read(downloadEngineProvider);
    if (engine == null) return;
    final paused = ref.read(wifiPausedProvider.notifier);
    if (onWifi) {
      for (final id in paused.state) {
        engine.resume(id);
      }
      paused.state = const {};
      return;
    }
    if (!ref.read(settingsProvider).wifiOnly) return;
    final running = {
      for (final task in engine.tasks)
        if (task.phase == TaskPhase.preparing ||
            task.phase == TaskPhase.downloading)
          task.id,
    };
    for (final id in running) {
      engine.pause(id);
    }
    paused.state = {...paused.state, ...running};
  });
  ref.onDispose(sub.cancel);
});

/// **Retrying when the network returns.**
///
/// Two deliberate decisions:
/// 1. **What the server refused is never retried.**
///    [VhApiException.isRetryable] separates a broken road from a refusal
///    at the destination; repeating a refusal fails and floods the server.
/// 2. **Once per task.** A link that fails twice for network reasons
///    does not have a network problem, and an unbounded retry loop drains
///    the battery and the data plan.
final autoRetryProvider = Provider<void>((ref) {
  final gate = ref.watch(networkGateProvider);
  final retried = <String>{};
  final sub = gate.onRestored.listen((_) {
    if (!ref.read(settingsProvider).autoRetry) return;
    final engine = ref.read(downloadEngineProvider);
    if (engine == null) return;
    for (final task in engine.tasks) {
      if (task.phase != TaskPhase.failed) continue;
      if (!(task.error?.isRetryable ?? false)) continue;
      // The old card was retried, so it does not stay on screen as a second
      // failure.
      if (!retried.add(task.inputUrl)) continue;
      engine.submit(task.inputUrl, task.quality);
      // The old card was retried, so it does not stay on screen as a second
      // failure.
      engine.forget(task.id);
    }
  });
  ref.onDispose(sub.cancel);
});
