import 'url_kit.dart';

/// **Where a finished file lives below the download directory**, as one
/// string the apps store.
///
/// A history record names a file in two parts: `folder`, the download's own
/// folder below the download directory, and `filename`, relative to that
/// folder, which itself holds subfolders when the output template writes
/// them (`%(channel)s/%(title)s.%(ext)s`). Audio carries a mark of its
/// own, because audio can sit in a different directory.
///
/// The string is the relative path, folder first. An audio download is
/// marked by a leading [_audioMark]: a recorded name is relative and
/// never starts with `/` (the guard refuses it), so the mark cannot be
/// mistaken for a real path. A plain name stored by app versions without
/// folder support still means a file at the top of `download/`.
abstract final class ServerPath {
  static const _audioMark = '/audio_download/';

  /// The stored form of a history item's file, or null without a
  /// filename (one is never invented).
  ///
  /// **A `..` that climbs out of the folder is resolved, not refused.** An
  /// absolute `outtmpl` writes every file to the top of the downloads
  /// whatever folder was asked for, and the file is then named relative to
  /// that folder: `Kids/../clip.webm` for `clip.webm` (measured
  /// 2026-10-22). Resolving it here finds the file where it really is. A
  /// path that would climb above the download directory keeps its `..`
  /// and the guard refuses it.
  static String? of({String? folder, String? filename, bool audio = false}) {
    if (filename == null || filename.isEmpty) return null;
    final segments = <String>[];
    for (final segment in [
      ...(folder ?? '').split('/').where((s) => s.isNotEmpty),
      ...filename.split('/'),
    ]) {
      if (segment == '..' && segments.isNotEmpty && segments.last != '..') {
        segments.removeLast();
      } else {
        segments.add(segment);
      }
    }
    final relative = segments.join('/');
    return audio ? '$_audioMark$relative' : relative;
  }

  /// **A folder name the app will use**, typed or picked: every segment
  /// trimmed, empty, `.` and `..` segments and NUL dropped, a backslash read
  /// as a separator. Empty means the top. Nested folders stay nested
  /// (`Ai/Lessons`), created at any depth.
  static String cleanFolder(String raw) => raw
      .replaceAll('\u0000', '')
      .split(RegExp(r'[/\\]'))
      .map((segment) => segment.trim())
      .where((s) => s.isNotEmpty && s != '.' && s != '..')
      .join('/');

  /// Served from `audio_download/` rather than `download/`.
  static bool isAudio(String path) => path.startsWith(_audioMark);

  /// The path below its route, without the audio mark.
  static String relative(String path) =>
      isAudio(path) ? path.substring(_audioMark.length) : path;

  /// The traversal guard, applied to the path below its route.
  static bool isSafe(String path) =>
      UrlKit.isSafeServerFilename(relative(path));

  /// The file's own name, without any folder.
  static String basename(String path) => relative(path).split('/').last;

  /// The folder the file sits in below its route, empty at the top.
  static String folderOf(String path) {
    final rel = relative(path);
    final slash = rel.lastIndexOf('/');
    return slash < 0 ? '' : rel.substring(0, slash);
  }
}
