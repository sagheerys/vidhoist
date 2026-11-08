import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../di.dart';

/// Whether Sync is shown. It waits for the phone app, so it is hidden
/// rather than removed; off unless turned on.
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
