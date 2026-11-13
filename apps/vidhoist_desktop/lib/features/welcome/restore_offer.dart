import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/backup_data.dart';

/// **The first start after an install, with a backup waiting** (owner's
/// report 2026-11-12): the library, the followed channels and the settings
/// come back in one answer, instead of a welcome that starts from nothing
/// while the backup sits in `Downloads\VidHoist\Backups` unnoticed. True
/// when [newest] was restored.
Future<bool> offerRestore(
  BuildContext context,
  WidgetRef ref,
  BackupFile newest,
) async {
  final l = context.vhl;
  final sure = await showVhConfirm(
    context,
    title: l.desktopRestoreOfferTitle,
    message: l.desktopRestoreOfferBody(vhTimeAgo(context, newest.at)),
    confirmLabel: l.desktopRestore,
    cancelLabel: l.desktopStartFresh,
  );
  if (!sure) return false;
  await ref.read(backupsProvider).restore(newest);
  if (context.mounted) showVhNotice(context, message: l.desktopRestored);
  return true;
}
