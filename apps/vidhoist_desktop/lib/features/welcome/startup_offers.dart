import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../../data/backup_data.dart';
import '../../data/first_start.dart';
import '../../data/update_data.dart';
import '../../di.dart';
import '../settings/updates_pane.dart';
import 'restore_offer.dart';
import 'welcome_dialog.dart';

export '../../data/first_start.dart' show welcomedKey;

/// Whether the welcome opens at a first start: the real app's. Off by
/// default, so a test of the shell sees the shell.
final offerWelcomeProvider = Provider<bool>((ref) => false);

/// **What opens by itself at start, one thing at most.** The first start
/// offers the newest backup when there is one (after a reinstall), and
/// shows the welcome when there is none or it is declined; every later
/// start may show what is new in an update.
Future<void> startupOffers(BuildContext context, WidgetRef ref) async {
  final store = ref.read(keyValueStoreProvider);
  if (ref.read(offerWelcomeProvider) &&
      !(await store.getBool(welcomedKey) ?? false)) {
    final backups = await ref.read(backupsProvider).list();
    if (!context.mounted) return;
    if (backups.isNotEmpty && await offerRestore(context, ref, backups.first)) {
      await store.setBool(welcomedKey, true);
      ref.invalidate(startupBackupProvider);
      return;
    }
    if (!context.mounted) return;
    await showWelcomeDialog(context);
    await store.setBool(welcomedKey, true);
    ref.invalidate(startupBackupProvider);
    return;
  }
  if (ref.read(offerWhatsNewProvider) && context.mounted) {
    await startupNotes(context, ref);
  }
}
