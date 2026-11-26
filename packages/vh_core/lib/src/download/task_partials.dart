import 'dart:io';

import 'package:vh_ytdlp/vh_ytdlp.dart' show ClipRange;

import 'partial_sweeper.dart';

/// Whether [path] is one of yt-dlp's work files for the video [mediaId]
/// (and the stretch [clip], when there is one), never a finished file.
///
/// The app's name template ends `[%(id)s]`, then the stretch's tag, then
/// the extension, so the id is matched only where the template puts it: a
/// title that itself holds `[abc]` is followed by the real id's bracket,
/// and is not taken for the video `abc`. A whole video's work files are
/// not a stretch's, and the other way round.
bool isTaskPartial(String path, String mediaId, {ClipRange? clip}) {
  if (mediaId.isEmpty || !isLeftover(path)) return false;
  final name = path.split(RegExp(r'[\\/]')).last;
  final mark = '[$mediaId]';
  final at = name.lastIndexOf(mark);
  if (at < 0) return false;
  final rest = name.substring(at + mark.length);
  final tail = clip == null ? '.' : ' ${clip.fileTag}.';
  return rest.startsWith(tail) && !rest.contains(']');
}

/// Deletes the work files of [mediaId] in [folder] that a cancelled
/// download left; the number deleted. Subtitles, covers and any finished
/// file stay: an earlier download of the same video may own them.
///
/// On Windows a process that is still letting go of a file refuses its
/// deletion for a moment after it was told to stop, so a refused file is
/// tried again [attempts] times, [pause] apart. [stillWanted] is asked
/// before each try: when another download of the same video has started
/// meanwhile, the files are its own and nothing more is deleted.
Future<int> removeTaskPartials(
  String folder,
  String mediaId, {
  ClipRange? clip,
  int attempts = 10,
  Duration pause = const Duration(milliseconds: 300),
  bool Function()? stillWanted,
}) async {
  var removed = 0;
  var left = <File>[];
  try {
    final dir = Directory(folder);
    if (!await dir.exists()) return 0;
    await for (final entity in dir.list(followLinks: false)) {
      if (entity is File && isTaskPartial(entity.path, mediaId, clip: clip)) {
        left.add(entity);
      }
    }
  } on FileSystemException {
    // A folder this app may not read: nothing it could delete either.
    return 0;
  }
  for (var round = 0; round < attempts && left.isNotEmpty; round++) {
    if (round > 0) await Future<void>.delayed(pause);
    if (stillWanted != null && !stillWanted()) return removed;
    final refused = <File>[];
    for (final file in left) {
      try {
        await file.delete();
        removed++;
      } on PathNotFoundException {
        // Gone already: yt-dlp renamed or removed it as it stopped.
      } on FileSystemException {
        refused.add(file);
      }
    }
    left = refused;
  }
  return removed;
}
