import 'dart:io';

import 'package:vh_core/vh_core.dart';

/// How old a work file must be before the startup sweep deletes it: days,
/// not hours, because a paused download goes on from its partial file.
const oldPartialAge = Duration(days: 3);

/// Deletes the old work files yt-dlp left in the download folder [root]
/// and the folders just below it (the ones chosen in the add dialog); the
/// number deleted. The library ignores these files on purpose, so without
/// a sweep the space they take is lost unseen, after a crash or a
/// download stopped by closing the app. [engine]'s unfinished tasks keep
/// theirs at any age: those will continue from them.
Future<int> sweepOldPartials(
  String root,
  LocalDownloadEngine engine, {
  Duration olderThan = oldPartialAge,
}) async {
  var removed = await sweepPartialFiles(
    root,
    olderThan: olderThan,
    keep: engine.continuesFrom,
  );
  try {
    await for (final entity in Directory(root).list(followLinks: false)) {
      if (entity is! Directory) continue;
      removed += await sweepPartialFiles(
        entity.path,
        olderThan: olderThan,
        keep: engine.continuesFrom,
      );
    }
  } on FileSystemException {
    // No folder yet, or one this app may not read: nothing to sweep.
  }
  return removed;
}
