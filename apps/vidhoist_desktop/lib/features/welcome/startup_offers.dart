import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../../data/update_data.dart';
import '../../di.dart';
import '../settings/updates_pane.dart';
import 'welcome_dialog.dart';

/// Set once the welcome has been shown; never renamed, or everyone is
/// welcomed again.
const welcomedKey = 'desktop_welcomed';

/// Whether the welcome opens at a first start: the real app's. Off by
/// default, so a test of the shell sees the shell.
final offerWelcomeProvider = Provider<bool>((ref) => false);

/// **What opens by itself at start, one thing at most.** The first start
/// shows the welcome; every later one may show what is new in an update.
Future<void> startupOffers(BuildContext context, WidgetRef ref) async {
  final store = ref.read(keyValueStoreProvider);
  if (ref.read(offerWelcomeProvider) &&
      !(await store.getBool(welcomedKey) ?? false)) {
    if (!context.mounted) return;
    await showWelcomeDialog(context);
    await store.setBool(welcomedKey, true);
    return;
  }
  if (ref.read(offerWhatsNewProvider) && context.mounted) {
    await startupNotes(context, ref);
  }
}
