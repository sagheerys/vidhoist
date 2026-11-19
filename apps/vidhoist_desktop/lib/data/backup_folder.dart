import 'dart:io';

import '../identity.dart';
import 'folders_data.dart';

/// **Where this computer's backups live: `Downloads\VidHoist\Backups`**,
/// beside the downloads, as the phone keeps its own in its media folder.
///
/// They used to sit in `%APPDATA%\Vidhoist\backup`, inside the app's own
/// data, and the uninstaller's "also delete the app's data" took them with
/// everything they were there to bring back (after a reinstall the library
/// and the followed channels were gone, and no backup was left to restore).
/// Windows' own Downloads folder, not the one chosen in Settings, so the
/// place does not move when that changes.
///
/// Null downloads (no such folder) keeps the old place.
Future<Directory> desktopBackupFolder(
  DesktopFolders folders, {
  required String roaming,
}) async {
  final old = Directory('$roaming/backup');
  final downloads = await folders.downloads();
  if (downloads == null) return old;
  final dir = Directory('$downloads\\${DesktopIdentity.displayName}\\Backups');
  await carryOldBackups(old, dir);
  return dir;
}

/// Moves the backups left in [from] into [to], once: a file already there
/// is not replaced, and [from] goes when it is empty. A failure leaves the
/// files where they were, to be tried again at the next start.
Future<void> carryOldBackups(Directory from, Directory to) async {
  try {
    if (!await from.exists()) return;
    await to.create(recursive: true);
    await for (final entity in from.list()) {
      if (entity is! File) continue;
      final name = entity.uri.pathSegments.last;
      final target = File('${to.path}\\$name');
      if (!await target.exists()) await entity.copy(target.path);
      await entity.delete();
    }
    if (await from.list().isEmpty) await from.delete();
  } on FileSystemException {
    // Tried again at the next start.
  }
}
