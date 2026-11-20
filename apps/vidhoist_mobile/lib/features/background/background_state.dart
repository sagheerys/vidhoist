import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vh_core/vh_core.dart';

import '../../di.dart';
import 'background_main.dart';
import 'background_status.dart';

/// Between Dart and `BackgroundCheck.kt`: the app turns the schedule on
/// and off, the scheduler's engine says it is done, and the scheduler asks
/// the app's own engine to check when the app is alive out of sight.
const backgroundChannel = 'vidhoist/background';

/// Off until the user turns it on: nothing runs behind their back.
const backgroundChecksKey = 'channels_background';

/// Asked once, the first time a channel is followed.
const backgroundOfferedKey = 'channels_background_offered';

Future<bool> readBackgroundChecks(KeyValueStore store) async =>
    await store.getBool(backgroundChecksKey) ?? false;

String backgroundStatusPath(String supportDir) =>
    '$supportDir/background_check.json';

/// Android's side, behind a provider so tests do without it.
class BackgroundScheduler {
  const BackgroundScheduler();

  static const _channel = MethodChannel(backgroundChannel);

  /// [soon] adds a first check about a quarter of an hour on, when it is
  /// turned on, so the user sees one ran without waiting six hours.
  Future<void> schedule({required bool on, bool soon = false}) async {
    try {
      await _channel.invokeMethod<void>('schedule', {'on': on, 'soon': soon});
    } on Object {
      // No scheduler (a test, an old build): the app's own check goes on.
    }
  }

  /// The scheduler asks the app's engine to check while the app is alive
  /// out of sight, rather than start a second engine beside it.
  void answerRuns() => _channel.setMethodCallHandler((call) async {
    if (call.method == 'run') await runBackgroundCheck(ownEngine: false);
  });
}

final backgroundSchedulerProvider = Provider(
  (ref) => const BackgroundScheduler(),
);

final backgroundChecksProvider =
    NotifierProvider<BackgroundChecksNotifier, bool>(
      BackgroundChecksNotifier.new,
    );

class BackgroundChecksNotifier extends Notifier<bool> {
  KeyValueStore get _store => ref.read(keyValueStoreProvider);

  @override
  bool build() {
    unawaited(_load());
    return false;
  }

  /// Read at start, and the schedule made again if it is on: an update of
  /// the app or a restore can leave Android's side without it.
  Future<void> _load() async {
    final on = await readBackgroundChecks(_store);
    state = on;
    if (on) await ref.read(backgroundSchedulerProvider).schedule(on: true);
  }

  Future<void> set(bool on) async {
    state = on;
    await ref
        .read(prefsMutexProvider)
        .run(() => _store.setBool(backgroundChecksKey, on));
    await ref.read(backgroundSchedulerProvider).schedule(on: on, soon: on);
  }

  /// True once: the first follow asks, and never again.
  Future<bool> takeOffer() async {
    if (state || (await _store.getBool(backgroundOfferedKey) ?? false)) {
      return false;
    }
    await ref
        .read(prefsMutexProvider)
        .run(() => _store.setBool(backgroundOfferedKey, true));
    return true;
  }
}

/// The folder the status file sits in; a provider so tests use their own.
final backgroundSupportDirProvider = FutureProvider<String>(
  (ref) async => (await getApplicationSupportDirectory()).path,
);

/// What the last check while closed did, for the line under the switch.
/// Dropped when the page goes and read again when it comes back: the check
/// writes the file while the page is out of sight, and a kept answer said
/// none had run after one had.
final backgroundStatusProvider = FutureProvider.autoDispose<BackgroundStatus>((
  ref,
) async {
  ref.watch(backgroundChecksProvider);
  final dir = await ref.watch(backgroundSupportDirProvider.future);
  return BackgroundStatusFile(backgroundStatusPath(dir)).read();
});
