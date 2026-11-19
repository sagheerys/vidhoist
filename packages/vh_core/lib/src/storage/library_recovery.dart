import 'dart:io';

import 'package:vh_ytdlp/vh_ytdlp.dart';

/// One file found in the download folder that the library does not list,
/// with the link it was downloaded from.
class RecoveredFile {
  const RecoveredFile({
    required this.path,
    required this.url,
    required this.title,
    required this.sizeBytes,
    required this.modified,
    this.folder,
    this.uploader,
    this.thumbnail,
    this.infoJsonPath,
  });

  final String path;

  /// The clip's link, the key every index uses: its playlists, tags and
  /// resume positions find it again by this.
  final String url;
  final String title;
  final int sizeBytes;

  /// When the file was last written, which is when it finished.
  final DateTime modified;

  /// The folder below the download folder, as a download records it.
  final String? folder;
  final String? uploader;
  final String? thumbnail;
  final String? infoJsonPath;

  bool get isAudio => LibraryRecovery.audioExtensions.contains(
    LibraryRecovery.extensionOf(path),
  );
}

/// What a scan found.
class RecoveryScan {
  const RecoveryScan({required this.found, required this.unknown});

  /// Files the library lacks whose link is known.
  final List<RecoveredFile> found;

  /// Media files the library lacks whose link cannot be told from what is
  /// on disk: left out, never given an invented one.
  final List<String> unknown;
}

/// **Finds downloads the library has lost track of**: after an uninstall
/// that deleted the app's data, the files were all still in the download
/// folder, but the list pointing at them was gone, and the playlists
/// brought back by an import pointed at nothing.
///
/// The link comes, in this order, from: the `.info.json` yt-dlp wrote
/// beside the file (its `webpage_url`); the person's own records that name
/// the file (a playlist entry keeps both the file's name and its link);
/// and last the id the name template puts at the end of every name
/// (`Title [id].mp4`), which names the clip on its own for YouTube alone.
/// **Nothing is invented**: a file whose link cannot be read stays out of
/// the library and is counted.
class LibraryRecovery {
  const LibraryRecovery._();

  static const videoExtensions = {'mp4', 'mkv', 'webm', 'mov'};
  static const audioExtensions = {
    'm4a',
    'mp3',
    'opus',
    'ogg',
    'aac',
    'flac',
    'wav',
  };

  /// The name template's id, at the very end of the name.
  static final _trailingId = RegExp(r'^(.*?)\s*\[([^\[\]]+)\]$');

  /// A YouTube video id: eleven of these characters, **the last one from
  /// sixteen only**, since the id spells 64 bits and the eleventh character
  /// carries just four of them. An Instagram shortcode is eleven characters
  /// of the same alphabet too (a real folder held two); this tells
  /// three in four of them apart, and [_instagramTitle] most of the rest.
  static final _youtubeId = RegExp(r'^[A-Za-z0-9_-]{10}[AEIMQUYcgkosw048]$');

  /// The title yt-dlp gives an Instagram post with no caption.
  static final _instagramTitle = RegExp(r'^Video by \S+$');

  /// One stream of a merge left behind (`Title [id].f399.mp4`): the merged
  /// file is the clip, this half of it is not.
  static final _formatPart = RegExp(r'\.f\d+$');

  /// Folders the app writes into its download folder that hold no clips.
  static const _ownFolders = {'for the phone', 'backups'};

  /// The media files under [folder] (and its subfolders) whose path is not
  /// in [knownPaths] and whose link is not in [knownUrls]. [linksByName]
  /// gives the link of a file by its name, from the person's own records.
  static Future<RecoveryScan> scan(
    String folder, {
    required Set<String> knownPaths,
    required Set<String> knownUrls,
    Map<String, String> linksByName = const {},
  }) async {
    final root = Directory(folder);
    if (!await root.exists()) {
      return const RecoveryScan(found: [], unknown: []);
    }
    final known = {for (final p in knownPaths) _norm(p)};
    final byName = {
      for (final MapEntry(:key, :value) in linksByName.entries)
        _name(key).toLowerCase(): value,
    };
    final taken = {...knownUrls};
    final found = <RecoveredFile>[];
    final unknown = <String>[];
    await for (final entity in root.list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final path = entity.path;
      if (_insideOwnFolder(root.path, path)) continue;
      final ext = extensionOf(path);
      if (!videoExtensions.contains(ext) && !audioExtensions.contains(ext)) {
        continue;
      }
      final stem = _stem(path);
      if (_formatPart.hasMatch(stem)) continue;
      if (known.contains(_norm(path))) continue;
      final file = await _read(
        entity,
        root.path,
        stem,
        byName[_name(path).toLowerCase()],
      );
      if (file == null) {
        unknown.add(path);
      } else if (taken.add(file.url)) {
        found.add(file);
      }
    }
    found.sort((a, b) => a.modified.compareTo(b.modified));
    return RecoveryScan(found: found, unknown: unknown);
  }

  static Future<RecoveredFile?> _read(
    File file,
    String root,
    String stem,
    String? recorded,
  ) async {
    final stat = await file.stat();
    final infoPath = '${_withoutName(file.path)}$stem.info.json';
    InfoJson? info;
    try {
      final infoFile = File(infoPath);
      if (await infoFile.exists()) {
        info = InfoJson.parse(await infoFile.readAsString());
      }
    } on Object {
      info = null;
    }
    final named = _trailingId.firstMatch(stem);
    final title = info?.title ?? named?.group(1) ?? stem;
    final id = named?.group(2);
    final youtube =
        id != null &&
        _youtubeId.hasMatch(id) &&
        !_instagramTitle.hasMatch(title.trim());
    final url =
        info?.webpageUrl ??
        recorded ??
        (youtube ? 'https://www.youtube.com/watch?v=$id' : null);
    if (url == null) return null;
    return RecoveredFile(
      path: file.path,
      url: url,
      title: title.trim().isEmpty ? stem : title.trim(),
      sizeBytes: stat.size,
      modified: stat.modified,
      folder: _subfolder(root, file.path),
      uploader: info?.uploader,
      thumbnail: info?.thumbnail,
      infoJsonPath: info == null ? null : infoPath,
    );
  }

  static String extensionOf(String path) {
    final name = _name(path);
    final dot = name.lastIndexOf('.');
    return dot <= 0 ? '' : name.substring(dot + 1).toLowerCase();
  }

  static String _name(String path) => path.split(RegExp(r'[\\/]')).last;

  static String _stem(String path) {
    final name = _name(path);
    final dot = name.lastIndexOf('.');
    return dot <= 0 ? name : name.substring(0, dot);
  }

  static String _withoutName(String path) =>
      path.substring(0, path.length - _name(path).length);

  /// The folders between the download folder and the file, or null when
  /// it sits at the top.
  static String? _subfolder(String root, String path) {
    final relative = _relative(root, _withoutName(path));
    return relative.isEmpty ? null : relative;
  }

  static bool _insideOwnFolder(String root, String path) {
    final first = _relative(root, path).split(RegExp(r'[\\/]')).first;
    return _ownFolders.contains(first.toLowerCase());
  }

  static String _relative(String root, String path) {
    final r = _norm(root);
    final p = _norm(path);
    final rest = p.startsWith(r) ? path.substring(r.length) : path;
    return rest.replaceAll(RegExp(r'^[\\/]+|[\\/]+$'), '');
  }

  /// Paths compared as Windows does: either slash, any case.
  static String _norm(String path) =>
      path.replaceAll('\\', '/').replaceAll(RegExp(r'/+$'), '').toLowerCase();
}
