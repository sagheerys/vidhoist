import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../di.dart';
import 'downloads_data.dart';
import 'engine_data.dart';
import 'library_data.dart';

/// Where channels are kept: on this computer, read through yt-dlp, what
/// is new handed to the download queue like a pasted link. Null where
/// there is no engine (a test that does not ask for one).
final channelSourceProvider = Provider<ChannelSource?>((ref) {
  final backend = ref.watch(downloadBackendProvider);
  if (backend == null) return null;
  return LocalChannelSource(
    store: ref.watch(keyValueStoreProvider),
    backend: backend,
    enqueue: (url, quality, folder) =>
        ref.read(downloadEngineProvider)?.submit(url, quality, folder: folder),
    onLog: (message) => _log(ref, message),
  );
});

/// Checks the channels when they are due, while the app runs. Watched by
/// the shell, so it lives as long as the window.
final channelTickerProvider = Provider<void>((ref) {
  final source = ref.watch(channelSourceProvider);
  if (source is! LocalChannelSource) return;
  final ticker = ChannelTicker(
    source: source,
    onChecked: () {
      ref
        ..invalidate(channelsProvider)
        ..invalidate(historyProvider);
    },
    onError: (e) => _log(ref, 'channel check failed: $e'),
  )..start();
  ref.onDispose(ticker.stop);
});

void _log(Ref ref, String message) {
  try {
    unawaited(ref.read(loggerProvider).log(message, tag: 'channels'));
  } on Object {
    // No log in tests.
  }
}

/// The followed channels.
///
/// Null [subscriptions] is not an empty list: it is nowhere to keep them,
/// and the page says so rather than offering a button that could never
/// work.
class ChannelsState {
  const ChannelsState(this.subscriptions);

  final List<ChannelSubscription>? subscriptions;

  bool get supported => subscriptions != null;

  /// For reading, as on the phone: the ones that need attention first,
  /// then the active ones, the paused ones last, each by name.
  List<ChannelSubscription> get sorted => [...?subscriptions]
    ..sort((a, b) {
      if (a.hasError != b.hasError) return a.hasError ? -1 : 1;
      if (a.enabled != b.enabled) return a.enabled ? -1 : 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

  ChannelSubscription? byId(String id) =>
      subscriptions?.where((s) => s.id == id).firstOrNull;
}

/// The list, read again on demand rather than polled: what a check
/// downloads arrives through the library like everything else.
final channelsProvider = FutureProvider<ChannelsState>((ref) async {
  final source = ref.watch(channelSourceProvider);
  if (source == null) return const ChannelsState(null);
  return ChannelsState(await source.list());
});

/// The intervals offered, in minutes, as on the phone: nothing under half
/// an hour, since a feed fetched every minute is fetched 1,440 times a day
/// for a video that comes weekly.
const channelIntervals = <int>[30, 60, 180, 360, 720, 1440];

/// The offered interval nearest to [minutes]: a channel followed elsewhere
/// may hold any number, and the choice must not show empty.
int nearestChannelInterval(int minutes) => channelIntervals.contains(minutes)
    ? minutes
    : channelIntervals.reduce(
        (a, b) => (a - minutes).abs() <= (b - minutes).abs() ? a : b,
      );

/// What can be done to the followed channels. Each action **reads the list
/// again** rather than editing a copy: the source owns this state, may
/// refuse a change, and a check changes fields nobody sent.
class ChannelsController {
  const ChannelsController(this._ref);

  final Ref _ref;

  ChannelSource? get _source => _ref.read(channelSourceProvider);

  /// Returns the channel's own title as it was resolved, so the notice
  /// names what was followed rather than echoing the link.
  Future<String?> follow(
    String url, {
    required Quality quality,
    required int checkIntervalMinutes,
    String? titleRegex,
    bool ownFolder = false,
    String folder = '',
  }) async {
    final source = _source;
    if (source == null) return null;
    final named = ownFolder ? ServerPath.cleanFolder(folder) : '';
    final created = await source.follow(
      url,
      quality,
      checkIntervalMinutes: checkIntervalMinutes,
      titleRegex: titleRegex,
      folder: named.isEmpty ? null : named,
    );
    // **An empty name means the channel's own**, known only once the link
    // is resolved. Set straight after: nothing is downloaded in between,
    // since following marks what is there as seen.
    if (ownFolder && named.isEmpty && created != null) {
      final fromChannel = channelFolderName(created.name);
      if (fromChannel.isNotEmpty) {
        await source.update(created.id, folder: fromChannel);
      }
    }
    _reload();
    return created?.name;
  }

  Future<void> setEnabled(ChannelSubscription sub, bool enabled) async {
    await _source?.update(sub.id, enabled: enabled);
    _reload();
  }

  /// [folder] null leaves it as it is; empty sends new clips to the top.
  Future<void> edit(
    ChannelSubscription sub, {
    required String name,
    required int checkIntervalMinutes,
    required String titleRegex,
    String? folder,
    Quality? quality,
  }) async {
    await _source?.update(
      sub.id,
      name: name == sub.name ? null : name,
      checkIntervalMinutes: checkIntervalMinutes == sub.checkIntervalMinutes
          ? null
          : checkIntervalMinutes,
      // A channel saved without one is at the best, and unchanged there.
      quality: quality == Quality.fromWire(sub.quality) ? null : quality,
      titleRegex: titleRegex.isEmpty ? null : titleRegex,
      // An emptied field is a deletion, not a field left as it was.
      clearTitleRegex: titleRegex.isEmpty && sub.titleRegex != null,
      folder: folder,
    );
    _reload();
  }

  Future<void> unfollow(ChannelSubscription sub) async {
    await _source?.unfollow([sub.id]);
    _reload();
  }

  /// A check takes as long as yt-dlp takes to walk the channel; the list
  /// is read again when it ends, **and the library with it**, or a check
  /// that found something looks like one that did nothing.
  Future<void> checkNow({ChannelSubscription? only}) async {
    await _source?.check(ids: only == null ? null : [only.id]);
    _reload();
    _ref.invalidate(historyProvider);
  }

  void _reload() => _ref.invalidate(channelsProvider);
}

final channelsControllerProvider = Provider(ChannelsController.new);
