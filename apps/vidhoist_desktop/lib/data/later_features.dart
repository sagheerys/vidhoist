import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';

import '../di.dart';

/// Whether Channels and Sync are shown. Both were built on the server
/// (channels need a scheduler here, sync waits for the phone), so 1.0
/// hides them rather than removing them; off unless turned on.
final laterFeaturesProvider = NotifierProvider<LaterFeaturesNotifier, bool>(
  LaterFeaturesNotifier.new,
);

class LaterFeaturesNotifier extends Notifier<bool> {
  static const key = 'desktop_later_features';

  @override
  bool build() {
    ref
        .read(keyValueStoreProvider)
        .getBool(key)
        .then((saved) => state = saved ?? false, onError: (_) {});
    return false;
  }

  Future<void> set(bool on) {
    state = on;
    return ref
        .read(prefsMutexProvider)
        .run(() => ref.read(keyValueStoreProvider).setBool(key, on));
  }
}
