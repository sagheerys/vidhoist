import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../di.dart';
import 'taskbar_data.dart';

/// "Keep the computer awake while downloading", on unless turned off: a
/// link sent from the phone, or a long playlist, otherwise stops halfway
/// when Windows puts the computer to sleep. The screen still goes dark.
const keepAwakeKey = 'keep_awake_downloading';

final keepAwakeProvider = NotifierProvider<KeepAwakeNotifier, bool>(
  KeepAwakeNotifier.new,
);

class KeepAwakeNotifier extends Notifier<bool> {
  @override
  bool build() {
    ref
        .read(keyValueStoreProvider)
        .getBool(keepAwakeKey)
        .then((saved) => state = saved ?? true, onError: (_) {});
    return true;
  }

  Future<void> set(bool on) {
    state = on;
    return ref
        .read(prefsMutexProvider)
        .run(() => ref.read(keyValueStoreProvider).setBool(keepAwakeKey, on));
  }
}

/// What asks Windows to hold off sleep; Windows' own in main, nothing in
/// tests.
abstract class SleepPort {
  void holdOffSleep(bool on);
}

class NoSleepPort implements SleepPort {
  const NoSleepPort();

  @override
  void holdOffSleep(bool on) {}
}

final sleepPortProvider = Provider<SleepPort>((ref) => const NoSleepPort());

/// Holds off sleep while a download is under way and the setting is on,
/// for the life of the shell; lets go the moment the last one ends.
final keepAwakeWiringProvider = Provider<void>((ref) {
  final port = ref.read(sleepPortProvider);
  ref.listen<bool>(
    keepAwakeWantedProvider,
    (_, on) => port.holdOffSleep(on),
    fireImmediately: true,
  );
  ref.onDispose(() => port.holdOffSleep(false));
});

final keepAwakeWantedProvider = Provider<bool>(
  (ref) =>
      ref.watch(keepAwakeProvider) &&
      ref.watch(taskbarDownloadsProvider.select((d) => d.count > 0)),
);
