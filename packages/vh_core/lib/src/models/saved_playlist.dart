import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// An item inside a saved playlist, keyed by canonicalUrl (entries
/// in `saved_playlists` are `{canonicalUrl, serverFilename, cachedTitle,
/// cachedThumb}`).
class PlaylistEntry {
  const PlaylistEntry({
    required this.canonicalUrl,
    this.serverFilename,
    this.cachedTitle,
    this.cachedThumb,
    this.addedAt,
  });

  final String canonicalUrl;
  final String? serverFilename;
  final String? cachedTitle;
  final String? cachedThumb;

  /// When this item joined the playlist, or null for one added before
  /// stamping existed or by an app that does not stamp.
  final DateTime? addedAt;

  Map<String, dynamic> toJson() => {
    'canonicalUrl': canonicalUrl,
    if (serverFilename != null) 'serverFilename': serverFilename,
    if (cachedTitle != null) 'cachedTitle': cachedTitle,
    if (cachedThumb != null) 'cachedThumb': cachedThumb,
    if (addedAt != null) 'addedAt': addedAt!.toIso8601String(),
  };

  PlaylistEntry withAddedAt(DateTime at) => PlaylistEntry(
    canonicalUrl: canonicalUrl,
    serverFilename: serverFilename,
    cachedTitle: cachedTitle,
    cachedThumb: cachedThumb,
    addedAt: at,
  );

  factory PlaylistEntry.fromJson(Map<String, dynamic> json) => PlaylistEntry(
    canonicalUrl: json['canonicalUrl']?.toString() ?? '',
    serverFilename: json['serverFilename']?.toString(),
    cachedTitle: json['cachedTitle']?.toString(),
    cachedThumb: json['cachedThumb']?.toString(),
    addedAt: DateTime.tryParse(json['addedAt']?.toString() ?? ''),
  );
}

/// A saved playlist, with pinning and last-played time.
class SavedPlaylist {
  SavedPlaylist({
    String? id,
    required this.name,
    List<PlaylistEntry>? items,
    this.pinned = false,
    DateTime? createdAt,
    this.lastPlayedAt,
    this.updatedAt,
  }) : id = id ?? _uuid.v4(),
       items = items ?? [],
       createdAt = createdAt ?? DateTime.now();

  final String id;
  String name;
  final List<PlaylistEntry> items;
  bool pinned;
  final DateTime createdAt;
  DateTime? lastPlayedAt;

  /// When anything in this playlist last changed (name, pin, order,
  /// members), or null before stamping existed.
  DateTime? updatedAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'pinned': pinned,
    if (lastPlayedAt != null) 'lastPlayedAt': lastPlayedAt!.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    'items': items.map((e) => e.toJson()).toList(),
  };

  factory SavedPlaylist.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List?;
    return SavedPlaylist(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      pinned: json['pinned'] == true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      lastPlayedAt: DateTime.tryParse(json['lastPlayedAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
      items: [
        for (final item in rawItems ?? const [])
          if (item is Map)
            PlaylistEntry.fromJson(Map<String, dynamic>.from(item)),
      ],
    );
  }
}
