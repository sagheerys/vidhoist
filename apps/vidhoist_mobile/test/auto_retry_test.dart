import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/home/network_gate.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';

/// What failed for the network is tried again once it returns.
void main() {
  test('**the guard**: a stretch and the whole video of one link are two '
      'downloads, both tried again, the stretch still a stretch', () async {
    const yt = 'https://www.youtube.com/watch?v=aqz-KE-bpKQ';
    final clip = ClipRange.tryParse('2:00', '5:30');
    final engine = _Engine([
      DownloadTask(
        inputUrl: yt,
        quality: Quality.best,
        phase: TaskPhase.failed,
        error: const NetworkException(),
      ),
      DownloadTask(
        inputUrl: yt,
        quality: Quality.best,
        clip: clip,
        phase: TaskPhase.failed,
        error: const NetworkException(),
      ),
    ]);
    final network = StreamController<List<ConnectivityResult>>.broadcast();
    addTearDown(network.close);
    final gate = NetworkGate(
      changes: network.stream,
      check: () async => [ConnectivityResult.none],
    );
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        initialSettingsProvider.overrideWithValue(const PhoneSettings()),
        networkGateProvider.overrideWithValue(gate),
        downloadEngineProvider.overrideWithValue(engine),
      ],
    );
    addTearDown(c.dispose);
    await gate.start();
    c.read(autoRetryProvider);

    network.add([ConnectivityResult.wifi]);
    await Future<void>.delayed(Duration.zero);
    expect(engine.submitted, [null, clip]);
  });
}

class _Engine implements LocalDownloadEngine {
  _Engine(this.tasks);

  @override
  final List<DownloadTask> tasks;
  final submitted = <ClipRange?>[];

  @override
  DownloadTask submit(
    String text,
    Quality quality, {
    bool isBatchMember = false,
    String? folder,
    ClipRange? clip,
  }) {
    submitted.add(clip);
    return DownloadTask(inputUrl: text, quality: quality, clip: clip);
  }

  @override
  void forget(String id) {}

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}
