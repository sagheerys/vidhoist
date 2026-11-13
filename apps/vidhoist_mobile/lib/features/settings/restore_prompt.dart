import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../engine/welcome_screen.dart';
import 'auto_backup.dart';
import 'restore_from_file.dart';

/// Rule 1, step 4: on the first launch after a reinstall, if an
/// automatic backup is found on disk, it offers "restore your previous
/// data?". When none can be listed, as after a reinstall, the user is
/// offered to pick one instead ([maybeOfferPickedRestore]).
///
/// It is offered once only (the `auto_restore_offered` key), so it does not
/// follow the user at every launch after they decline.
Future<void> maybeOfferAutoRestore(BuildContext context, WidgetRef ref) async {
  final store = ref.read(keyValueStoreProvider);
  if (await store.getBool('auto_restore_offered') ?? false) return;
  // A fresh install only, the run that showed the welcome screen: on any
  // later launch the backup on disk is one the app itself just wrote, and
  // offering it is noise. Settings that Google's backup brought back skip
  // the welcome screen, so they are asked nothing.
  if (!ref.read(welcomedThisRunProvider)) {
    if (await store.getBool(restorePickPendingKey) ?? false) {
      if (context.mounted) await maybeOfferPickedRestore(context, ref, store);
    }
    return;
  }

  final backup = ref.read(autoBackupProvider);
  // **The newest copy from the rotation** (decision 2026-09-04): it used to
  // be a single copy in a fixed file, and it could be **orphaned**, because
  // its key died with the reinstall. The copies are plain text now, so none
  // can be orphaned, and dated, so an older one can be reached from the
  // backup screen if the newest is the problem.
  final latest = await backup.latest();
  if (latest == null) {
    // After a reinstall the folder's copies are no longer listed: the user
    // is offered the picker instead, now or on a later start.
    await ref
        .read(prefsMutexProvider)
        .run(() => store.setBool(restorePickPendingKey, true));
    if (context.mounted) await maybeOfferPickedRestore(context, ref, store);
    return;
  }

  await ref
      .read(prefsMutexProvider)
      .run(() => store.setBool('auto_restore_offered', true));
  if (!context.mounted) return;

  final l10n = context.vhl;
  final accepted = await showVhDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.restoreSettings),
      content: Text(l10n.restoreConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(l10n.restoreData),
        ),
      ],
    ),
  );
  if (accepted != true || !context.mounted) return;

  try {
    await backup.restore(latest);
    await refreshAfterRestore(ref);
    if (context.mounted) {
      showVhSnack(context, l10n.autoRestoreSuccess, type: VhSnackType.success);
    }
  } catch (_) {
    if (context.mounted) {
      showVhSnack(context, l10n.restoreFailed, type: VhSnackType.error);
    }
  }
}
