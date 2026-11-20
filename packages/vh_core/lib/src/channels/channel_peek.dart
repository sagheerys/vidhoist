import 'package:vh_ytdlp/vh_ytdlp.dart';

import '../backend/download_backend.dart';
import '../storage/key_value_store.dart';
import 'channel_record.dart';
import 'local_channels.dart';

/// What one channel has that its last check did not see.
typedef ChannelNews = ({String channel, List<String> ids, List<String> titles});

/// **Reads the followed channels without touching them**: for a check
/// made while the app is closed, which only says what is new.
///
/// It writes nothing. The app may open in the middle of it and run its own
/// [LocalChannelSource] on the same store; a second writer there would
/// lose one side's seen ids, and those are what keep a channel's back
/// catalogue from downloading. The app's next check finds the same clips
/// and downloads them as it always did.
class ChannelPeek {
  const ChannelPeek({required this.store, required this.backend, this.onLog});

  final KeyValueStore store;
  final DownloadBackend backend;
  final void Function(String message)? onLog;

  /// The due channels' news, the ones with none left out. A channel that
  /// cannot be read is passed over: the app's own check reports it.
  Future<List<ChannelNews>> due(DateTime now) async {
    final records = ChannelRecord.listFrom(
      await store.getString(LocalChannelSource.storeKey),
    );
    final news = <ChannelNews>[];
    for (final record in records) {
      if (!record.isDue(now)) continue;
      try {
        if (await _read(record) case final found?) news.add(found);
      } on Object catch (e) {
        onLog?.call('peek passed over a channel: ${e.runtimeType}');
      }
    }
    return news;
  }

  Future<ChannelNews?> _read(ChannelRecord record) async {
    final feed = ChannelFeed.of(
      await backend.list(record.feedUrl, limit: LocalChannelSource.listLimit),
    );
    // The same test as the check that downloads: a bad filter there is an
    // error on the row, so here it lets nothing through.
    final RegExp filter;
    try {
      filter = RegExp(
        record.titleRegex ?? '',
        caseSensitive: false,
        unicode: true,
      );
    } on FormatException {
      return null;
    }
    final known = record.seen.toSet();
    final fresh = [
      for (final e in feed.entries)
        if (!e.isPending &&
            !known.contains(e.id) &&
            filter.hasMatch(e.title ?? ''))
          e,
    ];
    if (fresh.isEmpty) return null;
    return (
      channel: record.name,
      ids: [for (final e in fresh) e.id],
      titles: [for (final e in fresh) e.title ?? ''],
    );
  }
}
