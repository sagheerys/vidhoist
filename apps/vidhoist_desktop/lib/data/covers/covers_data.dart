import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_media/vh_media.dart' show cachedCoverFetcher;

import '../../di.dart';
import '../../features/library/artwork.dart';
import '../library_data.dart';
import 'cover_enricher.dart';
import 'cover_shrink.dart';
import 'mp4_cover.dart';

/// Where found covers are kept: `%LOCALAPPDATA%\Vidhoist\cache\embedded`.
/// Overridden in main; null (tests) turns the search off.
final coverFolderProvider = Provider<Directory?>((ref) => null);

/// Takes one frame from a video, given where it is and the headers to
/// read it with (none, for a file here). Overridden in main with the
/// engine's; null (tests) leaves videos alone.
final frameGrabProvider =
    Provider<
      Future<Uint8List?> Function(String url, Map<String, String> headers)?
    >((ref) => null);

final probeFailureIndexProvider = Provider(
  (ref) => ProbeFailureIndex(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

/// Reads a range of a clip's file on this computer.
RangeReader localRangeReader(String path) => (start, length) async {
  final file = await File(path).open();
  try {
    await file.setPosition(start);
    return await file.read(length);
  } finally {
    await file.close();
  }
};

/// Where a video's frame is taken from: its file on this computer, read
/// in place; nothing when the file is not there.
FrameFor videoFrameFor(
  Future<Uint8List?> Function(String url, Map<String, String> headers) grab,
) => (item) async {
  if (item.localPath case final path? when File(path).existsSync()) {
    return grab(path, const {});
  }
  return null;
};

/// Looks for missing covers in the background whenever the library is
/// read, one clip at a time so the library never waits, and shows what it
/// found every few covers and at the end. Watched by the shell.
final coverEnrichmentProvider = Provider<void>((ref) {
  final folder = ref.watch(coverFolderProvider);
  if (folder == null) return;
  final enricher = CoverEnricher(
    artwork: ref.watch(artworkIndexProvider),
    failures: ref.watch(probeFailureIndexProvider),
    folder: folder,
    readerFor: (item) => switch (item.localPath) {
      final path? when File(path).existsSync() => localRangeReader(path),
      _ => null,
    },
    frameFor: switch (ref.watch(frameGrabProvider)) {
      final grab? => videoFrameFor(grab),
      null => null,
    },
  );
  // The app always names its cover cache; without one (a test) nothing is
  // fetched.
  final cache = ref.watch(artworkCacheProvider);
  final CoverFetcher fetch = cache == null
      ? (_) async => const FetchedCover.failed()
      : cachedCoverFetcher(cache, (_) => const {});
  var running = false;
  var stopped = false;
  ref.onDispose(() => stopped = true);

  Future<void> run(List<LibraryItem> items) async {
    if (running) return;
    running = true;
    var found = 0;
    var shown = 0;
    var missed = 0;
    // A kept file looks the same as the online cover, but the library
    // should read it from now on.
    var keptAny = false;
    try {
      // Black covers taken before frames were checked, once: forgotten
      // here, they are taken again below from further in.
      await forgetDarkCovers(folder, ref.read(artworkIndexProvider));
      // Gone while that ran (the window closed): nothing is left to read.
      if (stopped) return;
      // Online covers kept as files first, so a clip taken down at its
      // source keeps its face; one already gone gets a picture from the
      // clip's own file instead.
      final byUrl = {for (final item in items) item.canonicalUrl: item};
      final keeper = CoverKeeper(
        kept: ref.read(keptCoverIndexProvider),
        failures: ref.read(probeFailureIndexProvider),
        folder: folder,
        shrink: shrinkCover,
        fetch: fetch,
        fallback: (url) async => switch (byUrl[url]) {
          final item? => enricher.pictureOf(item),
          null => null,
        },
      );
      for (final url in await keeper.candidates({
        for (final item in items) item.canonicalUrl: item.thumbnail,
      })) {
        if (stopped) return;
        final outcome = await keeper.keep(url, byUrl[url]!.thumbnail!);
        if (outcome == CoverOutcome.failed) {
          // Offline, most likely: the rest waits for the next reading.
          if (++missed >= _missesBeforeRest) break;
          continue;
        }
        missed = 0;
        if (outcome == CoverOutcome.replaced) found++;
        if (outcome == CoverOutcome.kept) keptAny = true;
        if (found - shown >= _showEvery) {
          shown = found;
          ref.invalidate(libraryItemsProvider);
        }
      }
      missed = 0;
      for (final item in await enricher.candidates(items)) {
        if (stopped) return;
        if (await enricher.enrich(item)) {
          found++;
          missed = 0;
          // Hundreds of videos take minutes: show them as they come.
          if (found - shown >= _showEvery) {
            shown = found;
            ref.invalidate(libraryItemsProvider);
          }
        } else if (++missed >= _missesBeforeRest) {
          // The files are likely out of reach; marking every clip after
          // this as having no cover would hide them all for a day.
          break;
        }
      }
      // Covers kept before they were made card-sized, once.
      if (!stopped) await shrinkKeptCovers(folder);
    } finally {
      running = false;
    }
    if ((found > shown || keptAny) && !stopped) {
      ref.invalidate(libraryItemsProvider);
    }
  }

  ref.listen(libraryItemsProvider, (_, next) {
    // Newest first, as the library opens: hundreds of videos take minutes,
    // and the ones on screen should not come last.
    if (next.valueOrNull case final items?) {
      unawaited(run(buildLibraryView(items)));
    }
  }, fireImmediately: true);
});

const _showEvery = 12;
const _missesBeforeRest = 6;
