import 'dart:convert';

import 'package:mt_ytdlp/mt_ytdlp.dart';

import '../models/channel_clip.dart';
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
    this.retryAt,
    this.avatarUrl,
    this.bannerUrl,
    this.followers,
    this.recent = const [],
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

  /// Set when a check starts, and kept when it could not reach the site:
  /// the channel is read again from then on, not a whole interval later.
  DateTime? retryAt;

  String? avatarUrl;
  String? bannerUrl;
  int? followers;

  /// The newest clips the last listing named, for the page.
  List<ChannelClip> recent;

  /// A page row shows a few; a listing names [LocalChannelSource.listLimit].
  static const recentCap = 8;

  /// What a listing says the channel looks like now. A picture the listing
  /// left out stays as it was: one site answers without it now and then.
  void refresh(ChannelFeed feed) {
    avatarUrl = feed.avatarUrl ?? avatarUrl;
    bannerUrl = feed.bannerUrl ?? bannerUrl;
    followers = feed.followers ?? followers;
    recent = [
      for (final e in feed.entries.where((e) => !e.isPending).take(recentCap))
        ChannelClip(
          id: e.id,
          url: e.url,
          title: e.title,
          thumbnail: e.thumbnail,
          duration: e.duration,
          published: e.published,
        ),
    ];
  }

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

  bool isDue(DateTime now) {
    if (!enabled) return false;
    if (retryAt case final at?) return !now.isBefore(at);
    return lastChecked == null ||
        !now.isBefore(
          lastChecked!.add(Duration(minutes: checkIntervalMinutes)),
        );
  }

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
    avatarUrl: avatarUrl,
    bannerUrl: bannerUrl,
    followers: followers,
    recent: recent,
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
    if (retryAt != null) 'retry': retryAt!.millisecondsSinceEpoch,
    if (avatarUrl != null) 'avatar': avatarUrl,
    if (bannerUrl != null) 'banner': bannerUrl,
    if (followers != null) 'followers': followers,
    if (recent.isNotEmpty) 'recent': [for (final c in recent) c.toJson()],
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
      retryAt: switch (raw['retry']) {
        final int ms => DateTime.fromMillisecondsSinceEpoch(ms),
        _ => null,
      },
      avatarUrl: text('avatar'),
      bannerUrl: text('banner'),
      followers: switch (raw['followers']) {
        final int n when n >= 0 => n,
        _ => null,
      },
      recent: [
        if (raw['recent'] case final List clips)
          for (final c in clips) ?ChannelClip.fromJson(c),
      ],
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
