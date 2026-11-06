import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';

import '../platform/engine_fetcher.dart';
import '../platform/engine_locator.dart';
import '../platform/engine_pins.dart';
import 'engine_data.dart';

/// One part's fetch as the screens show it: its share while it runs, or
/// why it last failed.
class PartFetch {
  const PartFetch({this.fraction, this.failure});

  /// 0 to 1 while running; null once failed.
  final double? fraction;
  final FetchFailure? failure;

  bool get running => fraction != null;
}

/// Fetches into the app's engine folder; null where there is none (tests
/// that do not ask for one).
final engineFetcherProvider = Provider<EngineFetcher?>((ref) {
  final locator = ref.watch(engineLocatorProvider);
  return locator == null ? null : EngineFetcher(locator: locator);
});

/// The fetches under way or failed, by part; a part done is absent.
final engineFetchProvider =
    NotifierProvider<EngineFetchNotifier, Map<EnginePart, PartFetch>>(
      EngineFetchNotifier.new,
    );

class EngineFetchNotifier extends Notifier<Map<EnginePart, PartFetch>> {
  final _running = <EnginePart, Future<bool>>{};

  /// What [ensure] already tried this run: a part that failed on its own
  /// waits for the person to ask, rather than holding every download.
  final _tried = <EnginePart>{};

  @override
  Map<EnginePart, PartFetch> build() => const {};

  /// Fetches the pinned [part]; true once it is in place.
  Future<bool> fetch(EnginePart part) {
    final fetcher = ref.read(engineFetcherProvider);
    if (fetcher == null) return Future.value(false);
    return install(fetcher.pins[part]!);
  }

  /// Fetches [asset], as an update does with a newer yt-dlp.
  Future<bool> install(PinnedAsset asset) =>
      _running[asset.part] ??= _run(asset).whenComplete(() {
        // A block, not an arrow: the removed future would be awaited by
        // itself.
        _running.remove(asset.part);
      });

  /// ffmpeg and Deno, the first time a download needs them: neither is in
  /// the installer (162 and 94 MB, `docs/ENGINE.md` finding 8).
  Future<void> ensure() async {
    final paths = ref.read(enginePathsProvider);
    for (final part in const [EnginePart.ffmpeg, EnginePart.deno]) {
      if (paths.has(part)) continue;
      if (_running[part] case final running?) {
        await running;
        continue;
      }
      if (!_tried.add(part)) continue;
      await fetch(part);
    }
  }

  Future<bool> _run(PinnedAsset asset) async {
    final fetcher = ref.read(engineFetcherProvider);
    if (fetcher == null) return false;
    _set(asset.part, const PartFetch(fraction: 0));
    try {
      await for (final progress in fetcher.install(asset)) {
        _set(asset.part, PartFetch(fraction: progress.fraction ?? 0));
      }
      _set(asset.part, const PartFetch(fraction: 1));
      _set(asset.part, null);
      ref.read(enginePathsProvider.notifier).refresh();
      ref.invalidate(engineVersionProvider);
      return true;
    } on EngineFetchException catch (e) {
      _set(asset.part, PartFetch(failure: e.reason));
      return false;
    } on Object {
      _set(asset.part, const PartFetch(failure: FetchFailure.network));
      return false;
    }
  }

  void _set(EnginePart part, PartFetch? fetch) {
    final next = {...state};
    if (fetch == null) {
      next.remove(part);
    } else {
      next[part] = fetch;
    }
    state = next;
  }
}

/// The last engine update: running, its outcome, or none yet.
final engineUpdateProvider =
    NotifierProvider<EngineUpdateNotifier, AsyncValue<UpdateOutcome?>>(
      EngineUpdateNotifier.new,
    );

class EngineUpdateNotifier extends Notifier<AsyncValue<UpdateOutcome?>> {
  @override
  AsyncValue<UpdateOutcome?> build() => const AsyncData(null);

  Future<UpdateOutcome?> update({
    EngineChannel channel = EngineChannel.stable,
  }) async {
    final backend = ref.read(downloadBackendProvider);
    if (backend == null || state.isLoading) return null;
    state = const AsyncLoading();
    final outcome = await backend.updateEngine(channel: channel);
    ref.read(enginePathsProvider.notifier).refresh();
    ref.invalidate(engineVersionProvider);
    state = AsyncData(outcome);
    return outcome;
  }
}
