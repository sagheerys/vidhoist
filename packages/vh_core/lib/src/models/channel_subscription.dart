import 'channel_clip.dart';

/// **A followed channel, as the screens show it**.
///
/// `LocalChannelSource` runs the checks, keeps the ids it has already
/// seen in a `ChannelRecord`, and queues whatever is new. This class is
/// the part of that record the interface shows, and nothing more.
class ChannelSubscription {
  const ChannelSubscription({
    required this.id,
    required this.name,
    required this.url,
    required this.enabled,
    required this.checkIntervalMinutes,
    this.quality,
    this.titleRegex,
    this.seenCount = 0,
    this.lastChecked,
    this.error,
    this.folder,
    this.avatarUrl,
    this.bannerUrl,
    this.followers,
    this.recent = const [],
  });

  final String id;

  /// The channel's own title, as the site gave it when it was followed.
  /// The user can rename it.
  final String name;

  final String url;

  /// A paused subscription stays in the list and stops being checked.
  /// **Pausing rather than deleting is the safe retreat**: deleting throws
  /// away `seen_ids`, so re-subscribing later starts from "everything
  /// currently on the channel is already seen" and the gap is lost forever.
  final bool enabled;

  final int checkIntervalMinutes;

  /// The wire value (`best`, `1080`, `audio` …), kept as text because it is
  /// stored that way and the app only displays it.
  final String? quality;

  /// Only titles matching this are downloaded. Null means everything.
  final String? titleRegex;

  /// **How many ids have been seen, not how many were downloaded.**
  /// It starts at the size of the channel, because subscribing marks the
  /// existing catalogue as seen. Labelling this "downloaded" would
  /// tell someone who just subscribed that 214 files landed on their disk.
  final int seenCount;

  /// Read as **seconds, not milliseconds** by [fromJson].
  final DateTime? lastChecked;

  /// The last check's failure, kept until a check succeeds.
  final String? error;

  /// The folder below the download directory its clips are saved in, or
  /// null for the top. **It applies to what arrives from then on**: a file
  /// that is already downloaded is never moved.
  final String? folder;

  /// The channel's square picture and its page's wide one, from the last
  /// listing; null for a site without them, or before the first check.
  final String? avatarUrl;
  final String? bannerUrl;

  /// How many follow it, as the site counts them.
  final int? followers;

  /// Its newest clips, newest first, as the last check listed them.
  final List<ChannelClip> recent;

  bool get hasError => error != null && error!.trim().isNotEmpty;

  ChannelSubscription copyWith({
    String? name,
    bool? enabled,
    int? checkIntervalMinutes,
    String? titleRegex,
    bool clearTitleRegex = false,
  }) => ChannelSubscription(
    id: id,
    name: name ?? this.name,
    url: url,
    enabled: enabled ?? this.enabled,
    checkIntervalMinutes: checkIntervalMinutes ?? this.checkIntervalMinutes,
    quality: quality,
    titleRegex: clearTitleRegex ? null : (titleRegex ?? this.titleRegex),
    seenCount: seenCount,
    lastChecked: lastChecked,
    error: error,
    folder: folder,
    avatarUrl: avatarUrl,
    bannerUrl: bannerUrl,
    followers: followers,
    recent: recent,
  );

  /// Returns null for anything that is not a usable row, so one malformed
  /// entry drops out of the list instead of taking the screen down with it.
  static ChannelSubscription? fromJson(dynamic decoded) {
    if (decoded is! Map) return null;
    final id = decoded['id'];
    final url = decoded['url'];
    if (id is! String || id.isEmpty) return null;
    if (url is! String || url.isEmpty) return null;
    final name = decoded['name'];
    return ChannelSubscription(
      id: id,
      // A row that lost its title still has a URL to show.
      name: name is String && name.trim().isNotEmpty ? name.trim() : url,
      url: url,
      // **Absent means enabled**: the field is only ever false when the
      // user paused it, and treating a missing value as paused would show
      // a working subscription as stopped.
      enabled: decoded['enabled'] != false,
      checkIntervalMinutes: _asInt(decoded['check_interval_minutes']) ?? 60,
      quality: _asText(decoded['quality']),
      titleRegex: _asText(decoded['title_regex']),
      seenCount: _asInt(decoded['seen_count']) ?? 0,
      lastChecked: _asEpochSeconds(decoded['last_checked']),
      error: _asText(decoded['error']),
      folder: _asText(decoded['folder']),
    );
  }

  /// A list of rows. Anything that is not an array is **not an empty list
  /// but a refusal**: unreadable data and "no channels followed" must not
  /// look the same.
  static List<ChannelSubscription>? listFromJson(dynamic decoded) {
    if (decoded is! List) return null;
    return [for (final row in decoded) ?fromJson(row)];
  }

  static String? _asText(dynamic raw) {
    if (raw is! String) return null;
    final text = raw.trim();
    return text.isEmpty ? null : text;
  }

  static int? _asInt(dynamic raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw.trim());
    return null;
  }

  /// Seconds since the epoch, as a float. Zero and negatives are "never
  /// checked" rather than 1970.
  static DateTime? _asEpochSeconds(dynamic raw) {
    final num? seconds = raw is num
        ? raw
        : (raw is String ? num.tryParse(raw.trim()) : null);
    if (seconds == null || seconds <= 0) return null;
    return DateTime.fromMillisecondsSinceEpoch((seconds * 1000).round());
  }

  @override
  String toString() => 'ChannelSubscription($id, $name, enabled: $enabled)';
}
