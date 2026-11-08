import 'dart:async';
import 'dart:convert';

import 'package:mt_ytdlp/mt_ytdlp.dart';

import '../api/api_exceptions.dart';
import '../backend/download_backend.dart';
import '../models/channel_subscription.dart';
import '../models/quality.dart';
import '../storage/key_value_store.dart';
import 'channel_record.dart';
import 'channel_source.dart';

/// Hands a new clip to the download queue.
typedef ChannelEnqueue = void Function(
  String url,
  Quality quality,
  String? folder,
);

/// **Following channels on this device**: what Vidhoist's server did on its
/// own schedule. A channel is read by a flat listing (`yt-dlp
/// --flat-playlist`, about two seconds), the ids already met are kept, and
/// whatever is new goes to the download queue.
///
/// Following marks what the channel offers as seen, so following a channel
/// with 900 videos downloads none of them; only what comes after. A stream
/// on the air or not begun is left unseen, and arrives once it is over.
class LocalChannelSource implements ChannelSource {
  LocalChannelSource({
    required this.store,
    required this.backend,
    required this.enqueue,
    DateTime Function()? clock,
    this.onLog,
  }) : _clock = clock ?? DateTime.now;

  final KeyValueStore store;
  final DownloadBackend backend;
  final ChannelEnqueue enqueue;
  final void Function(String message)? onLog;
  final DateTime Function() _clock;

  static const storeKey = 'channels_v1';

  /// The newest clips read at each check. A channel that posts more than
  /// this between two checks loses the oldest of them; the shortest
  /// interval is half an hour.
  static const listLimit = 30;

  /// How soon a check that could not reach the site is tried again: a
  /// phone waking with no network yet, or a site asking to slow down.
  static const retryDelay = Duration(minutes: 5);

  List<ChannelRecord>? _records;

  /// One change at a time: a check runs for seconds per channel, and a
  /// follow or a pause made meanwhile must not be written over by it.
  Future<void> _last = Future.value();

  Future<T> _serial<T>(Future<T> Function() action) {
    final run = _last.then((_) => action());
    _last = run.then((_) {}, onError: (_) {});
    return run;
  }

  Future<List<ChannelRecord>> _load() async {
    if (_records case final loaded?) return loaded;
    final text = await store.getString(storeKey);
    final records = ChannelRecord.listFrom(text);
    // Text that reads as nothing is set aside, not written over by the
    // next change: the seen ids in it are what keeps a channel's back
    // catalogue from downloading.
    if (records.isEmpty && text != null && text.trim() != '[]') {
      await store.setString('${storeKey}_unreadable', text);
    }
    return _records = records;
  }

  Future<void> _save() => store.setString(
    storeKey,
    jsonEncode([for (final r in _records ?? const []) r.toJson()]),
  );

  @override
  Future<List<ChannelSubscription>> list() async => [
    for (final r in await _load()) r.subscription,
  ];

  @override
  Future<ChannelSubscription?> follow(
    String url,
    Quality quality, {
    required int checkIntervalMinutes,
    String? titleRegex,
    String? folder,
  }) => _serial(() async {
    final records = await _load();
    var feedUrl = channelFeedUrl(url);
    var pasted = url.trim();
    if (records.any((r) => r.feedUrl == feedUrl)) {
      throw const AlreadyFollowedException();
    }
    var feed = ChannelFeed.of(
      await _read(() => backend.list(feedUrl, limit: listLimit)),
    );
    // A clip's link follows its channel: the library knows its clips'
    // links, not their channels'.
    if (feed.isClip) {
      final channel = feed.channelUrl;
      if (channel == null) {
        throw const EngineFailureException(
          YtDlpErrorKind.unsupportedUrl,
          'no channel named for this link',
        );
      }
      pasted = channel;
      feedUrl = channelFeedUrl(channel);
      if (records.any((r) => r.feedUrl == feedUrl)) {
        throw const AlreadyFollowedException();
      }
      feed = ChannelFeed.of(
        await _read(() => backend.list(feedUrl, limit: listLimit)),
      );
    }
    final id = feed.id.isNotEmpty ? feed.id : feedUrl;
    if (records.any((r) => r.id == id)) {
      throw const AlreadyFollowedException();
    }
    final record = ChannelRecord(
      id: id,
      name: feed.name.isNotEmpty ? feed.name : feedUrl,
      url: pasted,
      feedUrl: feedUrl,
      quality: quality.wire,
      checkIntervalMinutes: checkIntervalMinutes,
      titleRegex: _blankToNull(titleRegex),
      folder: _blankToNull(folder),
      lastChecked: _clock(),
      seen: [
        for (final e in feed.entries)
          if (!e.isPending) e.id,
      ],
    )..refresh(feed);
    records.add(record);
    await _save();
    onLog?.call('channel followed: ${record.seen.length} clips seen');
    return record.subscription;
  });

  @override
  Future<void> update(
    String id, {
    String? name,
    bool? enabled,
    int? checkIntervalMinutes,
    String? titleRegex,
    bool clearTitleRegex = false,
    String? folder,
  }) => _serial(() async {
    final record = (await _load()).where((r) => r.id == id).firstOrNull;
    if (record == null) return;
    if (_blankToNull(name) case final named?) record.name = named;
    if (enabled != null) record.enabled = enabled;
    if (checkIntervalMinutes != null) {
      record.checkIntervalMinutes = checkIntervalMinutes;
    }
    if (clearTitleRegex) {
      record.titleRegex = null;
    } else if (_blankToNull(titleRegex) case final regex?) {
      record.titleRegex = regex;
    }
    // Empty sends new clips to the top folder; null leaves it.
    if (folder != null) record.folder = _blankToNull(folder);
    await _save();
  });

  @override
  Future<void> unfollow(List<String> ids) => _serial(() async {
    (await _load()).removeWhere((r) => ids.contains(r.id));
    await _save();
  });

  /// The channels whose interval has run out at [now], paused ones never.
  Future<List<String>> due([DateTime? now]) async {
    final at = now ?? _clock();
    return [
      for (final r in await _load())
        if (r.isDue(at)) r.id,
    ];
  }

  /// Checks the channels that are due; what a timer calls.
  Future<void> checkDue() async {
    final ids = await due();
    if (ids.isNotEmpty) await check(ids: ids);
  }

  /// A paused channel is checked only when asked by name: the button on
  /// its row, not "check all".
  @override
  Future<void> check({List<String>? ids}) => _serial(() async {
    final records = await _load();
    final targets = [
      for (final r in records)
        if (ids == null ? r.enabled : ids.contains(r.id)) r,
    ];
    for (final record in targets) {
      await _checkOne(record);
      await _save();
    }
  });

  Future<void> _checkOne(ChannelRecord record) async {
    final at = _clock();
    // Marked before reading, so a tick meanwhile finds it not due.
    record.retryAt = at.add(retryDelay);
    final RegExp? filter;
    try {
      filter = record.titleRegex == null
          ? null
          : RegExp(record.titleRegex!, caseSensitive: false, unicode: true);
    } on FormatException catch (e) {
      record
        ..error = 'title filter: ${e.message}'
        ..lastChecked = at
        ..retryAt = null;
      return;
    }
    final ChannelFeed feed;
    try {
      feed = ChannelFeed.of(
        await _read(() => backend.list(record.feedUrl, limit: listLimit)),
      );
    } on Exception catch (e) {
      // No network is not the channel's fault: nothing is said, the last
      // good check stays on the row, and it is tried again shortly.
      if (_passing(e)) {
        onLog?.call('channel check put off: ${e.runtimeType}');
        return;
      }
      record
        ..error = _describe(e)
        ..lastChecked = at
        ..retryAt = null;
      return;
    }
    final known = record.seen.toSet();
    final fresh = [
      for (final e in feed.entries)
        if (!e.isPending && !known.contains(e.id)) e,
    ];
    // Oldest first, so the queue keeps the channel's order.
    for (final entry in fresh.reversed) {
      final title = entry.title ?? '';
      if (filter == null || filter.hasMatch(title)) {
        enqueue(entry.url, Quality.fromWire(record.quality), record.folder);
      }
      record.markSeen(entry.id);
    }
    record
      ..error = null
      ..lastChecked = at
      ..retryAt = null
      ..refresh(feed);
    if (fresh.isNotEmpty) {
      onLog?.call('channel checked: ${fresh.length} new');
    }
  }

  /// A listing that failed, as the engine words it everywhere else.
  Future<InfoJson> _read(Future<InfoJson> Function() run) async {
    try {
      return await run();
    } on YtDlpError catch (e) {
      throw EngineFailureException.from(e);
    }
  }

  /// A failure that says nothing about the channel and passes by itself.
  static bool _passing(Exception e) => switch (e) {
    NetworkException() || TimeoutException() => true,
    EngineFailureException(kind: YtDlpErrorKind.rateLimited) => true,
    _ => false,
  };

  /// Kept on the row until a check succeeds: yt-dlp's own words, which
  /// the page shows as they are.
  static String _describe(Exception e) => switch (e) {
    MTApiException(:final detail?) when detail.trim().isNotEmpty => detail,
    _ => e.toString(),
  };

  static String? _blankToNull(String? text) {
    final trimmed = text?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
