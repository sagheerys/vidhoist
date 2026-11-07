import 'dart:convert';

import '../models/channel_subscription.dart';

/// One followed channel as [LocalChannelSource] keeps it: what the page
/// shows, and the ids already met.
class ChannelRecord {
  ChannelRecord({
    required this.id,
    required this.name,
    required this.url,
    required this.feedUrl,
    required this.quality,
    required this.checkIntervalMinutes,
    required List<String> seen,
    this.enabled = true,
    this.titleRegex,
    this.folder,
    this.lastChecked,
    this.error,
  }) : seen = _capped(seen);

  final String id;
  String name;

  /// As pasted, for the page.
  final String url;

  /// What is listed ([channelFeedUrl]): a YouTube front page's videos tab.
  final String feedUrl;

  /// [Quality.wire].
  final String quality;
  int checkIntervalMinutes;
  bool enabled;
  String? titleRegex;
  String? folder;
  DateTime? lastChecked;
  String? error;

  /// The ids met, oldest first.
  final List<String> seen;

  /// Far more than one listing holds ([LocalChannelSource.listLimit]): a
  /// clip that drops out of the newest thirty and comes back, as a pinned
  /// or re-uploaded one may, must still be known.
  static const seenCap = 500;

  static List<String> _capped(List<String> ids) =>
      ids.length <= seenCap ? [...ids] : ids.sublist(ids.length - seenCap);

  void markSeen(String id) {
    if (seen.contains(id)) return;
    seen.add(id);
    if (seen.length > seenCap) seen.removeRange(0, seen.length - seenCap);
  }

  bool isDue(DateTime now) =>
      enabled &&
      (lastChecked == null ||
          !now.isBefore(
            lastChecked!.add(Duration(minutes: checkIntervalMinutes)),
          ));

  ChannelSubscription get subscription => ChannelSubscription(
    id: id,
    name: name,
    url: url,
    enabled: enabled,
    checkIntervalMinutes: checkIntervalMinutes,
    quality: quality,
    titleRegex: titleRegex,
    seenCount: seen.length,
    lastChecked: lastChecked,
    error: error,
    folder: folder,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'url': url,
    'feed_url': feedUrl,
    'quality': quality,
    'interval': checkIntervalMinutes,
    'enabled': enabled,
    if (titleRegex != null) 'title_regex': titleRegex,
    if (folder != null) 'folder': folder,
    if (lastChecked != null) 'checked': lastChecked!.millisecondsSinceEpoch,
    if (error != null) 'error': error,
    'seen': seen,
  };

  /// Null for a row that cannot be used, so one bad row drops out rather
  /// than the whole list.
  static ChannelRecord? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final id = raw['id'];
    final url = raw['url'];
    if (id is! String || id.isEmpty || url is! String || url.isEmpty) {
      return null;
    }
    String? text(String key) => switch (raw[key]) {
      final String s when s.isNotEmpty => s,
      _ => null,
    };
    final checked = raw['checked'];
    return ChannelRecord(
      id: id,
      name: text('name') ?? url,
      url: url,
      feedUrl: text('feed_url') ?? url,
      quality: text('quality') ?? 'best',
      checkIntervalMinutes: switch (raw['interval']) {
        final int n when n > 0 => n,
        _ => 60,
      },
      enabled: raw['enabled'] != false,
      titleRegex: text('title_regex'),
      folder: text('folder'),
      lastChecked: checked is int
          ? DateTime.fromMillisecondsSinceEpoch(checked)
          : null,
      error: text('error'),
      seen: [
        if (raw['seen'] case final List ids)
          for (final s in ids)
            if (s is String) s,
      ],
    );
  }

  /// The stored list; empty for nothing stored or text that is not a list.
  static List<ChannelRecord> listFrom(String? text) {
    if (text == null || text.isEmpty) return [];
    final Object? decoded;
    try {
      decoded = jsonDecode(text);
    } on FormatException {
      return [];
    }
    if (decoded is! List) return [];
    return [for (final row in decoded) ?fromJson(row)];
  }
}
