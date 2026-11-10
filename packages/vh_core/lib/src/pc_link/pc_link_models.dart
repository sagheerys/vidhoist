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
  });

  final String name;
  final String version;

  /// Downloads under way or waiting their turn.
  final int active;

  /// Where the computer can be reached now, sorted: the phone keeps them
  /// for the owner to choose the route, and learns a changed one here.
  final List<PcAddress> addresses;

  Map<String, Object?> toJson() => {
    'name': name,
    'version': version,
    'active': active,
    if (addresses.isNotEmpty)
      'addresses': [for (final a in addresses) a.toJson()],
  };

  static PcStatus? fromJson(Object? json) {
    if (json is! Map || json['name'] is! String) return null;
    return PcStatus(
      name: json['name'] as String,
      version: json['version'] as String? ?? '',
      active: json['active'] as int? ?? 0,
      addresses: PcAddress.listFromJson(json['addresses']),
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
  });

  /// Stable for the clip, opaque to the phone.
  final String id;
  final String title;
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
    );
  }
}

/// A page of the library: [total] tells the phone how many there are.
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
