/// What the computer tells a paired phone. Plain records with their JSON,
/// so the server and the phone read the same shapes; anything malformed
/// reads as absent rather than throwing, since the other end may be a newer
/// or older version.
library;

import 'pc_addresses.dart';

class PcStatus {
  const PcStatus({
    required this.name,
    required this.version,
    this.active = 0,
    this.addresses = const [],
    this.canDelete = false,
    this.sorts = false,
  });

  final String name;
  final String version;

  /// Downloads under way or waiting their turn.
  final int active;

  /// The user let phones delete clips there (off until turned on); the
  /// phone offers it only then. False from a computer older than that.
  final bool canDelete;

  /// The library can be sorted and filtered, and its search ignores Arabic
  /// marks; the phone offers sorting only then. False from a computer older
  /// than that, which answers newest first whatever is asked.
  final bool sorts;

  /// Where the computer can be reached now, sorted: the phone keeps them
  /// for the user to choose the route, and learns a changed one here.
  final List<PcAddress> addresses;

  Map<String, Object?> toJson() => {
    'name': name,
    'version': version,
    'active': active,
    if (addresses.isNotEmpty)
      'addresses': [for (final a in addresses) a.toJson()],
    if (canDelete) 'canDelete': true,
    if (sorts) 'sorts': true,
  };

  static PcStatus? fromJson(Object? json) {
    if (json is! Map || json['name'] is! String) return null;
    return PcStatus(
      name: json['name'] as String,
      version: json['version'] as String? ?? '',
      active: json['active'] as int? ?? 0,
      addresses: PcAddress.listFromJson(json['addresses']),
      canDelete: json['canDelete'] == true,
      sorts: json['sorts'] == true,
    );
  }
}

/// What became of a clip the phone asked the computer to delete.
enum PcDeleteOutcome {
  /// In the computer's Recycle Bin, where the user can get it back.
  deleted,

  /// The user has not let phones delete there.
  notAllowed,

  /// No such clip there any more.
  missing,

  /// Its drive has no Recycle Bin (a network or some removable drives):
  /// nothing was done, since there it could not be got back.
  noRecycleBin,

  /// Windows refused, as for a file open in another program.
  failed,
}

/// One of the computer's saved lists: its name, how many of its clips are
/// files there, a cover from the first, and, when asked for by its id,
/// those clips in the list's order.
class PcList {
  const PcList({
    required this.id,
    required this.name,
    required this.count,
    this.thumbnail,
    this.coverId,
    this.items = const [],
  });

  final String id;
  final String name;
  final int count;

  /// The first clip's web thumbnail, or [coverId] for a cover the computer
  /// keeps; neither when it has none.
  final String? thumbnail;
  final String? coverId;

  /// Empty in the list of lists; the clips when one list is asked for.
  final List<PcItem> items;

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'count': count,
    'thumbnail': ?thumbnail,
    'cover': ?coverId,
    if (items.isNotEmpty) 'items': [for (final item in items) item.toJson()],
  };

  static PcList? fromJson(Object? json) {
    if (json is! Map || json['id'] is! String || json['name'] is! String) {
      return null;
    }
    final raw = json['items'];
    final items = [
      if (raw is List)
        for (final entry in raw) ?PcItem.fromJson(entry),
    ];
    return PcList(
      id: json['id'] as String,
      name: json['name'] as String,
      count: json['count'] as int? ?? items.length,
      thumbnail: json['thumbnail'] as String?,
      coverId: json['cover'] as String?,
      items: items,
    );
  }
}

/// One download on the computer.
class PcTask {
  const PcTask({
    required this.id,
    required this.url,
    required this.phase,
    this.title,
    this.thumbnail,
    this.progress = 0,
    this.speed,
    this.eta,
    this.quality = 'best',
    this.error,
  });

  final String id;
  final String url;

  /// The engine's phase by name (`queued`, `downloading`, `completed`…).
  final String phase;
  final String? title;

  /// A web address only: a file on the computer is not the phone's to read.
  final String? thumbnail;

  /// 0 to 100.
  final double progress;

  /// Bytes per second.
  final double? speed;

  /// Seconds left.
  final int? eta;
  final String quality;
  final String? error;

  bool get isFinished =>
      phase == 'completed' || phase == 'failed' || phase == 'cancelled';

  Map<String, Object?> toJson() => {
    'id': id,
    'url': url,
    'phase': phase,
    'title': ?title,
    'thumbnail': ?thumbnail,
    'progress': progress,
    'speed': ?speed,
    'eta': ?eta,
    'quality': quality,
    'error': ?error,
  };

  static PcTask? fromJson(Object? json) {
    if (json is! Map || json['id'] is! String || json['url'] is! String) {
      return null;
    }
    return PcTask(
      id: json['id'] as String,
      url: json['url'] as String,
      phase: json['phase'] as String? ?? 'queued',
      title: json['title'] as String?,
      thumbnail: json['thumbnail'] as String?,
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      speed: (json['speed'] as num?)?.toDouble(),
      eta: json['eta'] as int?,
      quality: json['quality'] as String? ?? 'best',
      error: json['error'] as String?,
    );
  }
}

/// One clip in the computer's library.
class PcItem {
  const PcItem({
    required this.id,
    required this.title,
    this.uploader,
    this.thumbnail,
    this.hasCover = false,
    this.duration,
    this.sizeBytes,
    this.added,
    this.isAudio = false,
    this.url,
    this.extension,
  });

  /// Stable for the clip, opaque to the phone.
  final String id;
  final String title;

  /// The clip's web link, the key the phone keeps a resume position and a
  /// copy under, so the same clip on both is one clip. Null from a computer
  /// older than the link's batch B.
  final String? url;

  /// The file's extension (`mp4`, `m4a`), for the name of a copy.
  final String? extension;
  final String? uploader;

  /// A web address the phone loads itself.
  final String? thumbnail;

  /// The computer keeps a cover file the phone fetches through the link.
  final bool hasCover;
  final Duration? duration;
  final int? sizeBytes;
  final DateTime? added;
  final bool isAudio;

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'uploader': ?uploader,
    'thumbnail': ?thumbnail,
    if (hasCover) 'cover': true,
    if (duration != null) 'duration': duration!.inSeconds,
    'size': ?sizeBytes,
    if (added != null) 'added': added!.millisecondsSinceEpoch,
    if (isAudio) 'audio': true,
    'url': ?url,
    'ext': ?extension,
  };

  static PcItem? fromJson(Object? json) {
    if (json is! Map || json['id'] is! String || json['title'] is! String) {
      return null;
    }
    final seconds = json['duration'];
    final added = json['added'];
    return PcItem(
      id: json['id'] as String,
      title: json['title'] as String,
      uploader: json['uploader'] as String?,
      thumbnail: json['thumbnail'] as String?,
      hasCover: json['cover'] == true,
      duration: seconds is int ? Duration(seconds: seconds) : null,
      sizeBytes: json['size'] as int?,
      added: added is int ? DateTime.fromMillisecondsSinceEpoch(added) : null,
      isAudio: json['audio'] == true,
      url: json['url'] as String?,
      extension: json['ext'] as String?,
    );
  }
}

/// A page of the library: [total] tells the phone how many there are.
/// The order the phone asks the computer's library in.
enum PcLibrarySort { newest, oldest, title, size }

/// Which of the computer's clips the phone asks for.
enum PcLibraryKind { all, video, audio }

class PcLibraryPage {
  const PcLibraryPage({required this.items, required this.total});

  final List<PcItem> items;
  final int total;

  Map<String, Object?> toJson() => {
    'items': [for (final item in items) item.toJson()],
    'total': total,
  };

  static PcLibraryPage fromJson(Object? json) {
    if (json is! Map) return const PcLibraryPage(items: [], total: 0);
    final raw = json['items'];
    final items = [
      if (raw is List)
        for (final entry in raw) ?PcItem.fromJson(entry),
    ];
    return PcLibraryPage(
      items: items,
      total: json['total'] as int? ?? items.length,
    );
  }
}
