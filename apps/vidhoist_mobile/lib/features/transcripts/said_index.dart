import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vh_transcripts/vh_transcripts.dart';

import '../downloads_library/library_providers.dart';
import '../downloads_library/local_item.dart';

/// Where the words of each clip are kept for the search: the app's own
/// files, read once from the subtitle files beside the clips. A copy,
/// because YouTube's subtitle files are several times the size of what was
/// said, and a search must not parse every one of them at each launch.
final saidStoreProvider = FutureProvider<TranscriptStore>(
  (ref) async => TranscriptStore(
    Directory(
      '${(await getApplicationSupportDirectory()).path}'
      '${Platform.pathSeparator}transcripts',
    ),
  ),
);

/// The search over what was said, read from [saidStoreProvider] the first
/// time it is asked for.
final saidIndexProvider = FutureProvider<TranscriptIndex>((ref) async {
  final index = TranscriptIndex();
  final store = await ref.watch(saidStoreProvider.future);
  await for (final transcript in store.readAll()) {
    index.add(transcript);
  }
  return index;
});

/// Bumped whenever a clip's words are added or dropped, so a search on
/// screen shows the new state without the index being rebuilt.
final saidRevisionProvider = StateProvider<int>((ref) => 0);

/// The subtitle files yt-dlp wrote beside the clips of one folder
/// (`<name>.<language>.vtt` or `.srt`), listed once however many clips
/// the folder holds: asking the folder again for each clip made a library
/// of a thousand clips a million names to read.
class _Folders {
  final _names = <String, List<String>>{};

  Future<List<String>> _in(Directory folder) async =>
      _names[folder.path] ??= await _list(folder);

  static Future<List<String>> _list(Directory folder) async {
    try {
      return [
        await for (final entry in folder.list(followLinks: false))
          if (entry is File) entry.uri.pathSegments.last,
      ];
    } on FileSystemException {
      // The folder went away: its clips simply have no words yet.
      return const [];
    }
  }

  /// [mediaPath]'s subtitle files, by base language (`ar` for `ar-orig`),
  /// the plain code kept when a clip carries both.
  Future<Map<String, File>> subtitlesOf(String mediaPath) async {
    final media = File(mediaPath);
    final name = media.uri.pathSegments.last;
    final dot = name.lastIndexOf('.');
    final stem = dot <= 0 ? name : name.substring(0, dot);
    final found = <String, File>{};
    final names = [...await _in(media.parent)]
      ..sort((a, b) => a.length.compareTo(b.length));
    for (final file in names) {
      if (!file.startsWith('$stem.')) continue;
      final rest = file.substring(stem.length + 1).split('.');
      if (rest.length != 2 || !const {'vtt', 'srt'}.contains(rest[1])) {
        continue;
      }
      found.putIfAbsent(
        Transcript.baseLanguage(rest[0]),
        () => File('${media.parent.path}${Platform.pathSeparator}$file'),
      );
    }
    return found;
  }
}

/// Keeps the search in step with the library: the words of a clip that
/// arrived are read from its subtitle files, once, and those of a clip
/// that left are dropped.
///
/// The library walks its folder after every download, so this runs then
/// and at launch; a clip already read costs one lookup. Nothing is asked
/// of any site: the files are the ones the download wrote.
class SaidIndexer {
  SaidIndexer(this._ref);

  final Ref _ref;
  var _running = false;
  List<LocalItem>? _waiting;

  /// One walk at a time; a library that changed meanwhile is walked next.
  Future<void> run(List<LocalItem> items) async {
    if (_running) {
      _waiting = items;
      return;
    }
    _running = true;
    try {
      await _walk(items);
    } on Object {
      // The search is an extra: a folder that cannot be read leaves the
      // library as it was.
    } finally {
      _running = false;
      final next = _waiting;
      _waiting = null;
      if (next != null) unawaited(run(next));
    }
  }

  Future<void> _walk(List<LocalItem> items) async {
    final store = await _ref.read(saidStoreProvider.future);
    final index = await _ref.read(saidIndexProvider.future);
    final folders = _Folders();
    final present = <String>{};
    var changed = false;

    for (final item in items) {
      present.add(item.key);
      if (index.contains(item.key)) continue;
      final files = await folders.subtitlesOf(item.path);
      for (final MapEntry(key: language, value: file) in files.entries) {
        final List<TranscriptSegment> segments;
        try {
          // Off the drawing thread when large, and skipped unread when
          // too large to be subtitles: anything can sit beside a clip.
          segments = await readSubtitleFile(file);
        } on FileSystemException {
          continue;
        }
        if (segments.isEmpty) continue;
        final transcript = Transcript(
          canonicalUrl: item.key,
          language: language,
          source: 'captions',
          fetchedAt: item.modified,
          segments: segments,
          reader: SubtitleParser.version,
        );
        await store.write(transcript);
        index.add(transcript);
        changed = true;
      }
    }

    // A clip deleted, in the app or outside it, takes its words with it.
    for (final url in index.urls) {
      if (present.contains(url)) continue;
      await store.remove(url);
      index.remove(url);
      changed = true;
    }
    if (changed) _ref.read(saidRevisionProvider.notifier).state++;
  }
}

final saidIndexerProvider = Provider((ref) => SaidIndexer(ref));

/// Walks the library whenever it changes. Watched by the shell, so it
/// lives as long as the app is open.
final saidIndexingProvider = Provider<void>((ref) {
  ref.listen(localMediaProvider, (_, next) {
    final items = next.valueOrNull;
    if (items != null) unawaited(ref.read(saidIndexerProvider).run(items));
  }, fireImmediately: true);
});
