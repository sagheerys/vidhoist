import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_media/library.dart';

import '../library_data.dart';

/// What a clip's header says: how long it is, and its picture's shape
/// (none for sound alone).
class ProbedShape {
  const ProbedShape({required this.duration, this.aspectRatio});

  final Duration duration;
  final double? aspectRatio;
}

typedef ShapeProbe = Future<ProbedShape?> Function(
  String url,
  Map<String, String> headers,
);

/// Reads a clip's header, given where it is and the headers to read it
/// with. Overridden in main with the engine's; null (tests) reads nothing.
final shapeProbeProvider = Provider<ShapeProbe?>((ref) => null);

/// The pause between two clips, so a library of hundreds is read without
/// this computer noticing; a test makes it zero.
final shapeProbeGapProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 1),
);

/// The clips whose length is not known yet, in the order given, leaving
/// out those already [tried] this session and those with no file to read.
List<LibraryItem> shapeCandidates(List<LibraryItem> items, Set<String> tried) =>
    [
      for (final item in items)
        if (item.duration == null &&
            !tried.contains(item.canonicalUrl) &&
            item.localPath != null)
          item,
    ];

/// Where [item]'s header is read: its file on this computer, in place;
/// null when the file is not there.
({String url, Map<String, String> headers})? shapeSourceOf(LibraryItem item) {
  if (item.localPath case final path? when File(path).existsSync()) {
    return (url: path, headers: const {});
  }
  return null;
}

/// Learns the length of every clip in the library in the background, as
/// the phone's library enricher does: the history holds none, and a clip
/// that was never played here showed no length at all. One clip at a time,
/// newest first so the screen fills from the top; what is learned is kept,
/// so each clip is read once. Watched by the shell.
final shapeEnrichmentProvider = Provider<void>((ref) {
  final probe = ref.watch(shapeProbeProvider);
  if (probe == null) return;
  final shapes = ref.watch(mediaShapeIndexProvider);
  final gap = ref.watch(shapeProbeGapProvider);
  final tried = <String>{};
  var running = false;
  var stopped = false;
  ref.onDispose(() => stopped = true);

  Future<void> run(List<LibraryItem> items) async {
    if (running) return;
    running = true;
    var found = 0;
    var shown = 0;
    final misses = <String>[];
    try {
      for (final item in shapeCandidates(items, tried)) {
        if (stopped) return;
        tried.add(item.canonicalUrl);
        final source = shapeSourceOf(item);
        if (source == null) continue;
        final shape = await probe(source.url, source.headers);
        if (stopped) return;
        if (shape == null) {
          misses.add(item.canonicalUrl);
          if (misses.length >= _missesBeforeRest) {
            // The files are likely out of reach (a drive unplugged):
            // these are asked again at the next reading instead of being
            // given up on.
            tried.removeAll(misses);
            break;
          }
          continue;
        }
        misses.clear();
        await shapes.remember(
          item.canonicalUrl,
          shape.duration,
          shape.aspectRatio ?? 1,
        );
        found++;
        // Hundreds of clips take minutes: show them as they come.
        if (found - shown >= _showEvery) {
          shown = found;
          ref.invalidate(libraryItemsProvider);
        }
        if (gap > Duration.zero) await Future<void>.delayed(gap);
      }
    } finally {
      running = false;
    }
    if (found > shown && !stopped) ref.invalidate(libraryItemsProvider);
  }

  ref.listen(libraryItemsProvider, (_, next) {
    if (next.valueOrNull case final items?) {
      unawaited(run(buildLibraryView(items)));
    }
  }, fireImmediately: true);
});

const _showEvery = 12;
const _missesBeforeRest = 6;
