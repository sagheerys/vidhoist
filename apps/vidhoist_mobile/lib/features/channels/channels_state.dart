import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../../di.dart';
import '../settings/auto_backup.dart';
import 'channel_art.dart';

/// The channels followed on this phone, kept by the app and read through
/// its yt-dlp. What is new joins the download queue like a pasted link, at
/// the channel's quality; the phone keeps one folder, so no channel has a
/// folder of its own here.
final channelSourceProvider = Provider<LocalChannelSource>(
  (ref) => LocalChannelSource(
    store: ref.watch(keyValueStoreProvider),
    backend: ref.watch(downloadBackendProvider),
    enqueue: (url, quality, _) =>
        ref.read(downloadEngineProvider)?.submit(url, quality),
    onLog: (message) =>
        unawaited(ref.read(loggerProvider).log(message, tag: 'channels')),
  ),
);

/// The followed channels as the page reads them: the active ones, the
/// paused ones last, each by name.
final channelsProvider = FutureProvider<List<ChannelSubscription>>((ref) async {
  final all = await ref.watch(channelSourceProvider).list();
  return all..sort((a, b) {
    if (a.enabled != b.enabled) return a.enabled ? -1 : 1;
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });
});

/// Checks the channels as they fall due while the app runs, in sight or
/// in the background; what came while it was closed is checked a little
/// after it opens. Watched by the shell.
final channelTickerProvider = Provider<void>((ref) {
  final ticker = ChannelTicker(
    source: ref.watch(channelSourceProvider),
    onChecked: () => ref.invalidate(channelsProvider),
    onError: (e) => unawaited(
      ref.read(loggerProvider).log('channel check failed: $e', tag: 'channels'),
    ),
  )..start();
  ref.onDispose(ticker.stop);
});

/// The intervals offered, in minutes: nothing under half an hour, since a
/// channel read every minute is read 1,440 times a day for a video that
/// comes weekly.
const channelIntervals = <int>[30, 60, 180, 360, 720, 1440];

/// What the page does to the channels. Each action reads the list again,
/// and a follow or an unfollow is backed up like a playlist is.
class ChannelsController {
  const ChannelsController(this._ref);

  final Ref _ref;

  LocalChannelSource get _source => _ref.read(channelSourceProvider);

  /// The channel's own name, as yt-dlp resolved it.
  Future<String?> follow(
    String url, {
    required Quality quality,
    required int checkIntervalMinutes,
    String? titleRegex,
  }) async {
    final created = await _source.follow(
      url,
      quality,
      checkIntervalMinutes: checkIntervalMinutes,
      titleRegex: titleRegex,
    );
    _changed(backup: true);
    return created?.name;
  }

  Future<void> setEnabled(ChannelSubscription sub, bool enabled) async {
    await _source.update(sub.id, enabled: enabled);
    _changed();
  }

  /// Empty clears the filter.
  Future<void> edit(
    ChannelSubscription sub, {
    required int checkIntervalMinutes,
    required String titleRegex,
  }) async {
    final filter = titleRegex.trim();
    await _source.update(
      sub.id,
      checkIntervalMinutes: checkIntervalMinutes,
      titleRegex: filter.isEmpty ? null : filter,
      clearTitleRegex: filter.isEmpty,
    );
    _changed(backup: true);
  }

  /// Its pictures go with it; following it again fetches them anew.
  Future<void> unfollow(ChannelSubscription sub) async {
    await _source.unfollow([sub.id]);
    unawaited(_ref.read(channelArtProvider).forget(sub.id));
    _changed(backup: true);
  }

  /// [only] checks one channel, paused or not; none checks every active
  /// one.
  Future<void> checkNow({ChannelSubscription? only}) async {
    await _source.check(ids: only == null ? null : [only.id]);
    _changed();
  }

  void _changed({bool backup = false}) {
    _ref.invalidate(channelsProvider);
    if (backup) unawaited(_ref.read(autoBackupProvider).requestBackup());
  }
}

final channelsControllerProvider = Provider(ChannelsController.new);
