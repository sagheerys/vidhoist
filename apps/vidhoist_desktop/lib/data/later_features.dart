import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';

import '../di.dart';

/// Whether Sync is shown. It was built on the server and waits for the
/// phone app, so it is hidden rather than removed; off unless turned on.
/// Channels were behind it too until 1.2 checked them on this computer.
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
