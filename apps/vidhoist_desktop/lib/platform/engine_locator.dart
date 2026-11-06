import 'dart:io';

/// The three programs the engine is made of.
enum EnginePart {
  /// yt-dlp's folder build (`yt-dlp_win.zip`): it starts in about half a
  /// second against 1.75 s for the one-file build (`docs/ENGINE.md`,
  /// finding 6). The installer ships it.
  ytDlp,

  /// Merges video and audio and converts sound; 162 MB, so fetched on
  /// first need rather than shipped (finding 8).
  ffmpeg,

  /// Solves YouTube's challenge in seconds; 94 MB, fetched on first need.
  deno,
}

/// Where each part was found; null where it was not.
class EnginePaths {
  const EnginePaths({this.ytDlp, this.ffmpeg, this.deno, this.managed = false});

  final String? ytDlp;
  final String? ffmpeg;
  final String? deno;

  /// The app's own or the installer's folder build, which the app replaces
  /// to update it; false for a yt-dlp on PATH, which updates itself.
  final bool managed;

  bool get ready => ytDlp != null;

  /// What `--ffmpeg-location` is given: the folder, so ffprobe is found
  /// beside ffmpeg.
  String? get ffmpegDir => switch (ffmpeg) {
    final path? => File(path).parent.path,
    null => null,
  };

  bool has(EnginePart part) => switch (part) {
    EnginePart.ytDlp => ytDlp != null,
    EnginePart.ffmpeg => ffmpeg != null,
    EnginePart.deno => deno != null,
  };
}

/// Finds the engine: the app's own folder under `%APPDATA%\Vidhoist`
/// (what it fetched or updated), then the installer's `tools` folder, then
/// PATH, for someone who already keeps yt-dlp there.
class EngineLocator {
  EngineLocator({
    required this.ownFolder,
    this.installFolder,
    List<String>? pathFolders,
    bool Function(String path)? exists,
  }) : pathFolders =
           pathFolders ?? splitPath(Platform.environment['PATH'] ?? ''),
       _exists = exists ?? ((path) => File(path).existsSync());

  final String ownFolder;

  /// `tools` beside the app's executable; null where there is none.
  final String? installFolder;
  final List<String> pathFolders;
  final bool Function(String path) _exists;

  /// The folder a fetched [part] is installed into.
  String folderFor(EnginePart part) => '$ownFolder\\${_folderName(part)}';

  EnginePaths locate() {
    String? first(EnginePart part, String exe) {
      for (final dir in [ownFolder, ?installFolder]) {
        final path = '$dir\\${_folderName(part)}\\$exe';
        if (_exists(path)) return path;
      }
      return _onPath(exe);
    }

    final ytDlp = first(EnginePart.ytDlp, 'yt-dlp.exe');
    return EnginePaths(
      ytDlp: ytDlp,
      ffmpeg: first(EnginePart.ffmpeg, 'ffmpeg.exe'),
      deno: first(EnginePart.deno, 'deno.exe'),
      managed: ytDlp != null && ytDlp != _onPath('yt-dlp.exe'),
    );
  }

  String? _onPath(String exe) {
    for (final dir in pathFolders) {
      final path = '$dir\\$exe';
      if (_exists(path)) return path;
    }
    return null;
  }

  static String _folderName(EnginePart part) => switch (part) {
    EnginePart.ytDlp => 'yt-dlp',
    EnginePart.ffmpeg => 'ffmpeg',
    EnginePart.deno => 'deno',
  };

  /// The folders of a PATH value, without quotes, blanks or a trailing
  /// backslash.
  static List<String> splitPath(String value) => [
    for (final raw in value.split(';'))
      if (raw.trim().replaceAll('"', '') case final dir when dir.isNotEmpty)
        dir.endsWith(r'\') ? dir.substring(0, dir.length - 1) : dir,
  ];
}
