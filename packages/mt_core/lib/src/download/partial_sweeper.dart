import 'dart:io';

import 'transfer.dart';

/// **Sweeping orphaned partial files.**
///
/// Killing the app in the middle of a large pull leaves `<name>.part` on
/// disk, and the new name after a retry differs because of the `HHmmss`
/// stamp, so nobody ever cleans the old one — and **neither app swept at
/// startup**. The library scan skips `.part` on purpose, so the space is
/// lost without the user ever seeing it.
///
/// yt-dlp leaves more than `.part` behind when it is stopped:
/// [isLeftover] names each kind.
///
/// [olderThan] protects a pull **happening right now** from being swept
/// out from under it.
Future<int> sweepPartialFiles(
  String directoryPath, {
  Duration olderThan = const Duration(hours: 6),
}) async {
  final dir = Directory(directoryPath);
  final cutoff = DateTime.now().subtract(olderThan);
  var removed = 0;
  try {
    // **`exists()` throws rather than answering false** when Android has not
    // granted access to the folder, and this call used to sit outside the
    // guard below — so on a phone that had never been asked for the media
    // permission, the startup sweep threw before the app had drawn anything
    // (field report 2026-09-16).
    if (!await dir.exists()) return 0;
    await for (final entity in dir.list(followLinks: false)) {
      if (entity is! File) continue;
      if (!isLeftover(entity.path)) continue;
      try {
        final stat = await entity.stat();
        if (stat.modified.isAfter(cutoff)) continue;
        await entity.delete();
        removed++;
      } on FileSystemException {
        // A locked file, or one deleted between the listing and here.
        // Nothing to do.
      }
    }
  } on FileSystemException {
    // A folder with no read permission: no sweep, and no crash at startup.
  }
  return removed;
}

/// yt-dlp's work files, none of them a finished download:
/// - `.part`, the file still arriving (the server pull used it too);
/// - `.ytdl`, its note of where a fragmented download stopped;
/// - `.part-Frag12`, one fragment of an HLS or DASH stream;
/// - `[id].f399.mp4`, one stream of a merge that never happened. The `]`
///   before it is the app's own name template (`%(title).80B [%(id)s]`),
///   so a song called "track.f1.mp3" is never taken for one;
/// - `.temp.mp4`, a file ffmpeg was rewriting.
bool isLeftover(String path) =>
    path.endsWith(Transfer.partSuffix) ||
    path.endsWith('.ytdl') ||
    _leftover.hasMatch(path);

final _leftover = RegExp(
  r'(\.part-Frag\d+(\.part)?|\]\.f\d+(-\w+)?\.\w+|\.temp\.\w+)$',
);
