import 'package:vh_core/vh_core.dart';

/// The media folder's name, spelled as the app is shown (2026-11-09). It
/// was `Vidhoist` before, and `media_folder_rename.dart` renames it.
const mediaFolderName = 'VidHoist';

/// Where the media folder is wanted on the phone's own storage.
const preferredMediaDir = '/storage/emulated/0/Download/$mediaFolderName';

/// **The media folder as it is spelled on disk** (§5.3, ADR 0002), settled
/// once before runApp by [settlePhoneMediaDir]. Its contents are
/// registered in MediaStore so they appear in the phone's gallery. A
/// folder of its own, so no other app's files mix into the library. A
/// memory card has one of the same name (`phone_volumes.dart`).
///
/// Not a constant, learned on the owner's phone (2026-11-09): Android
/// opens `VidHoist` and `Vidhoist` alike, but lists a folder's files only
/// under its own spelling, so a library scanning `VidHoist` while the
/// disk said `Vidhoist` showed no downloads at all. Android refuses the
/// rename when the folder holds an earlier install's files, so the old
/// spelling can stay for good, and the app follows the disk.
String get phoneMediaDir => _phoneMediaDir;
String _phoneMediaDir = preferredMediaDir;

/// Sets [phoneMediaDir] to the spelling found on disk.
void settlePhoneMediaDir(String path) => _phoneMediaDir = path;

const _audioExtensions = {'mp3', 'm4a', 'aac', 'ogg', 'opus', 'wav', 'flac'};
const _videoExtensions = {'mp4', 'webm', 'mkv', 'mov', 'avi', '3gp', 'm4v'};

/// The media extensions shown in the local library.
bool isMediaFile(String path) {
  final ext = extensionOf(path);
  return _audioExtensions.contains(ext) || _videoExtensions.contains(ext);
}

/// A local library item: **the file on disk is the truth**, and the other
/// fields are enrichment from the indexes.
///
/// **The item key [key]:** the canonicalUrl when known (everything this app
/// downloads knows its URL), otherwise **the absolute path**, so a file
/// copied in by hand still keeps its resume position, playlists and title.
class LocalItem {
  const LocalItem({
    required this.key,
    required this.path,
    required this.title,
    required this.sizeBytes,
    required this.modified,
    this.canonicalUrl,
    this.thumbnail,
    this.favorite = false,
    this.duration,
    this.aspectRatio,
  });

  final String key;
  final String path;
  final String title;
  final int sizeBytes;
  final DateTime modified;

  /// null means a file whose URL we do not know: one copied in by hand.
  final String? canonicalUrl;
  final String? thumbnail;
  final bool favorite;

  /// Clip dimensions from `media_shape_index`, known after the first play.
  final Duration? duration;
  final double? aspectRatio;

  String get filename => path.split(RegExp(r'[/\\]')).last;

  bool get isAudio => _audioExtensions.contains(extensionOf(path));

  MediaPlatform get platform => canonicalUrl == null
      ? MediaPlatform.other
      : MediaPlatform.detect(canonicalUrl!);

  /// A portrait video of three minutes or less is a "short". Unknown is not
  /// short: no guessing.
  bool get isShortForm =>
      !isAudio &&
      duration != null &&
      duration! <= const Duration(minutes: 3) &&
      aspectRatio != null &&
      aspectRatio! < 1;

  /// A file's cover: **one kept on the phone first**, since the online one
  /// it was kept from may be gone (YouTube deletes it with the video);
  /// then the artwork index's, under the item key or the bare path.
  static String? coverOf(
    String key,
    String path, {
    required Map<String, String> kept,
    required Map<String, String> artwork,
  }) => kept[key] ?? artwork[key] ?? artwork[path];

  /// The default title when the title index has none: the filename without
  /// its extension and without the `_HHmmss` time stamp the name builder
  /// adds (§2.4).
  static String titleFromFilename(String filename) {
    final dot = filename.lastIndexOf('.');
    final stem = dot > 0 ? filename.substring(0, dot) : filename;
    return stem.replaceFirst(RegExp(r'_\d{6}$'), '');
  }
}

/// The scope filter: there is no "offline" scope, because everything is
/// local.
enum LocalScope { all, favorites }

enum MediaTypeFilter { all, video, audio, shorts }

/// **The four view modes: one exclusive choice, not overlapping flags.**
///
/// They used to be two flags (`compact` and `grid`) that could be on
/// together meaninglessly, and the fourth mode, cards, would have made them
/// three flags with eight states, half of them impossible. One value
/// eliminates the impossible state at the root.
enum LibraryViewMode {
  /// A row with a thumbnail beside it. The default, and the best fit for
  /// long titles and for audio.
  list,

  /// The same row with a smaller thumbnail and a single title line: more
  /// items on screen.
  compact,

  /// Two columns with a 16:9 cover, for quick visual scanning.
  grid,

  /// **One column with a wide cover** (asked 2026-09-08, the YouTube
  /// pattern): the largest cover possible for the fewest items — for
  /// unhurried browsing, not for searching.
  cards,
}

/// The saved sort options (`video_sort_option`, §5.1).
enum LibrarySort { newest, oldest, nameAZ, nameZA, largest, smallest }

/// Building the view: pure, testable logic (TRD §3.2).
List<LocalItem> buildLocalLibraryView(
  List<LocalItem> items, {
  LocalScope scope = LocalScope.all,
  MediaTypeFilter type = MediaTypeFilter.all,
  String query = '',
  MediaPlatform? platform,
  LibrarySort sort = LibrarySort.newest,
}) {
  final q = query.trim().toLowerCase();
  final filtered = items.where((item) {
    if (scope == LocalScope.favorites && !item.favorite) return false;
    final typeOk = switch (type) {
      MediaTypeFilter.all => true,
      MediaTypeFilter.audio => item.isAudio,
      // Video leaves the shorts to their own chip, so every clip is under
      // one type and video without the shorts can be had (owner's
      // choice, 2026-11-05). A clip of unknown shape stays a video.
      MediaTypeFilter.video => !item.isAudio && !item.isShortForm,
      // Shorts: portrait, short, and only where the dimensions are known.
      MediaTypeFilter.shorts => item.isShortForm,
    };
    if (!typeOk) return false;
    if (platform != null && item.platform != platform) return false;
    if (q.isNotEmpty && !item.title.toLowerCase().contains(q)) return false;
    return true;
  }).toList();

  int byDate(LocalItem a, LocalItem b) => a.modified.compareTo(b.modified);
  int byName(LocalItem a, LocalItem b) =>
      a.title.toLowerCase().compareTo(b.title.toLowerCase());
  int bySize(LocalItem a, LocalItem b) => a.sizeBytes.compareTo(b.sizeBytes);

  filtered.sort(switch (sort) {
    LibrarySort.newest => (a, b) => byDate(b, a),
    LibrarySort.oldest => byDate,
    LibrarySort.nameAZ => byName,
    LibrarySort.nameZA => (a, b) => byName(b, a),
    LibrarySort.largest => (a, b) => bySize(b, a),
    LibrarySort.smallest => bySize,
  });
  return filtered;
}

/// Live platform counters for the filter chips, most first, with the
/// unknown platform last: the one rule every library counts with
/// ([countPlatforms]).
List<MapEntry<MediaPlatform, int>> platformCounts(List<LocalItem> items) =>
    countPlatforms(items, (item) => item.platform);
