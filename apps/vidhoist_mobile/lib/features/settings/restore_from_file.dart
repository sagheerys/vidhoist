import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../downloads_library/library_providers.dart';
import '../downloads_library/local_item.dart';
import '../playlists/playlists_providers.dart';
import '../storage/media_folder_rename.dart';

/// **Read through the system picker (SAF):** Android 11+ refuses to read
/// a file the app did not create, even in the same folder (`errno 13`),
/// and a migration backup comes from another device by definition. The
/// app's own backups become such files too once it is reinstalled: Android
/// drops their owner, and the app can no longer list them.
Future<String?> pickBackupContents() async {
  final picked = await FilePicker.platform.pickFiles(withData: true);
  final file = picked?.files.singleOrNull;
  if (file == null) return null;
  if (file.bytes case final Uint8List bytes) return utf8.decode(bytes);
  final path = file.path;
  return path == null ? null : File(path).readAsString();
}

/// The picker the offer below opens; a test hands its own file instead.
final backupPickerProvider = Provider<Future<String?> Function()>(
  (ref) => pickBackupContents,
);

/// Set on the welcome run when no backup could be listed, and cleared once
/// the offer is made: the downloads may be hidden on that run for want of
/// the media permission, so the offer waits for a later start.
const restorePickPendingKey = 'restore_pick_pending';

/// Offered once, on a phone holding downloads this install does not know:
/// what a reinstall leaves behind when Google's own backup did not bring
/// the settings back. A phone with none of those is a first install, and
/// is left alone.
///
/// **Why the user picks the file**: after a reinstall every copy in the
/// backups folder has lost its owner and the app cannot list them, but the
/// system picker reaches them because the user chooses one.
Future<void> maybeOfferPickedRestore(
  BuildContext context,
  WidgetRef ref,
  KeyValueStore store,
) async {
  final List<LocalItem> items;
  try {
    items = await ref.read(localMediaProvider.future);
  } on Object {
    return;
  }
  // Files this install downloaded know their link; an earlier install's
  // do not, since its index went with it.
  final orphaned = items.any((item) => item.canonicalUrl == null);
  if (!orphaned || !context.mounted) return;
  await ref.read(prefsMutexProvider).run(() async {
    await store.setBool('auto_restore_offered', true);
    await store.remove(restorePickPendingKey);
  });
  if (!context.mounted) return;
  final l10n = context.vhl;
  final choose = await showVhConfirm(
    context,
    title: l10n.restorePickTitle,
    message: l10n.restorePickBody,
    confirmLabel: l10n.restorePickChoose,
    cancelLabel: l10n.cancel,
  );
  if (!choose) return;
  try {
    final contents = await ref.read(backupPickerProvider)();
    if (contents == null) return;
    await ref.read(backupServiceProvider).importFromString(contents);
    await refreshAfterRestore(ref);
    if (context.mounted) {
      showVhSnack(context, l10n.autoRestoreSuccess, type: VhSnackType.success);
    }
  } on Object {
    if (context.mounted) {
      showVhSnack(context, l10n.restoreFailed, type: VhSnackType.error);
    }
  }
}

/// Everything a restore may have changed, reloaded. A copy written before
/// the folder became `VidHoist` brings the old spelling back, so the paths
/// are fixed again first.
Future<void> refreshAfterRestore(WidgetRef ref) async {
  await rewriteStoredPaths(
    ref.read(keyValueStoreProvider),
    ref.read(prefsMutexProvider),
  );
  await ref.read(settingsProvider.notifier).reloadFromStore();
  ref.invalidate(localMediaProvider);
  ref.invalidate(playlistsProvider);
}
