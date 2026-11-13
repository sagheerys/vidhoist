import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart' show PcStreamProxy;
import 'package:vh_media/vh_media.dart';
import 'package:vh_transcripts/vh_transcripts.dart';

import '../../di.dart';
import '../pc/pc_link_state.dart';
import 'caption_style.dart';
import 'transcript_sheet.dart';

const _extensions = {'vtt', 'srt'};

/// The subtitle files yt-dlp wrote beside [mediaPath] with the download
/// (`--write-subs`): `<name>.<language>.vtt`, under the same name as the
/// media without its extension.
List<File> sidecarSubtitleFiles(String mediaPath) {
  final media = File(mediaPath);
  final stem = _stem(media.uri.pathSegments.last);
  try {
    return [
      for (final entry in media.parent.listSync(followLinks: false))
        if (entry is File && _languageOf(entry, stem) != null) entry,
    ];
  } on FileSystemException {
    return const [];
  }
}

/// Deletes [mediaPath]'s subtitles, with the clip; the number deleted.
Future<int> deleteSidecarSubtitles(String mediaPath) async {
  var deleted = 0;
  for (final file in sidecarSubtitleFiles(mediaPath)) {
    try {
      await file.delete();
      deleted++;
    } on FileSystemException {
      // Already gone.
    }
  }
  return deleted;
}

/// Every language of [mediaPath]'s subtitles as the player draws them,
/// [preferred] base languages first, then the rest as found. Empty when
/// there are none.
Future<Map<String, List<VhCaptionLine>>> readSidecarSubtitles(
  String mediaPath, {
  List<String> preferred = const [],
}) async {
  final stem = _stem(File(mediaPath).uri.pathSegments.last);
  final tracks = <String, List<VhCaptionLine>>{};
  for (final file in sidecarSubtitleFiles(mediaPath)) {
    try {
      // Off the drawing thread when large, and skipped unread when too
      // large to be subtitles: anything can sit beside a clip.
      final lines = captionLinesOf(await readSubtitleFile(file));
      if (lines.isNotEmpty) tracks[_languageOf(file, stem)!] = lines;
    } on FileSystemException {
      // A file gone since the listing, or unreadable: the others still show.
    }
  }
  return orderTracks(tracks, preferred: preferred);
}

/// Timed lines as the player draws them.
List<VhCaptionLine> captionLinesOf(List<TranscriptSegment> segments) => [
  for (final s in segments)
    VhCaptionLine(
      start: s.start,
      end: s.end,
      text: s.text,
      words: s.words == null
          ? null
          : [for (final w in s.words!) VhCaptionWord(w.start, w.text)],
    ),
];

/// [tracks] with the [preferred] base languages first, and a language
/// that repeats another's lines left out.
Map<String, List<VhCaptionLine>> orderTracks(
  Map<String, List<VhCaptionLine>> tracks, {
  List<String> preferred = const [],
}) {
  int rank(String language) {
    final at = preferred.indexOf(language.split('-').first.toLowerCase());
    return at < 0 ? preferred.length : at;
  }

  // The plain code before its variants ("ar" before "ar-orig"), so it is
  // the one kept when they are the same.
  final order = tracks.keys.toList()
    ..sort((a, b) {
      final byRank = rank(a).compareTo(rank(b));
      return byRank != 0 ? byRank : a.length.compareTo(b.length);
    });
  final kept = <String, List<VhCaptionLine>>{};
  for (final language in order) {
    final lines = tracks[language]!;
    if (!kept.values.any((other) => _sameLines(other, lines))) {
      kept[language] = lines;
    }
  }
  return kept;
}

/// A clip spoken in Arabic comes with `ar` and `ar-orig` byte for byte the
/// same (the owner's phone, 2026-11-07); offering both put "AR" in the
/// switch twice.
bool _sameLines(List<VhCaptionLine> a, List<VhCaptionLine> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i].start != b[i].start || a[i].text != b[i].text) return false;
  }
  return true;
}

/// The subtitles read so far, by media path, for the player. The player's
/// callbacks run while its children build, where nothing may be watched,
/// so the player watches this whole map and a callback only asks for a
/// path ([SubtitleCache.want]); the answer rebuilds the player.
final subtitleCacheProvider =
    NotifierProvider<
      SubtitleCache,
      Map<String, Map<String, List<VhCaptionLine>>>
    >(SubtitleCache.new);

class SubtitleCache
    extends Notifier<Map<String, Map<String, List<VhCaptionLine>>>> {
  final _asked = <String>{};

  @override
  Map<String, Map<String, List<VhCaptionLine>>> build() => const {};

  /// Reads [path]'s subtitles once; asking again costs nothing.
  void want(String path) {
    if (!_asked.add(path)) return;
    readSidecarSubtitles(path, preferred: _preferred).then((tracks) {
      state = {...state, path: tracks};
    });
  }

  /// A clip playing from the computer: its transcripts, asked of the
  /// computer once, under the item's [key]. One that cannot be reached
  /// gives none for this run, rather than asking on every rebuild.
  void wantFromPc(String key, String id) {
    if (!_asked.add(key)) return;
    final client = ref.read(pcClientProvider);
    Future<Map<String, List<VhCaptionLine>>> read() async {
      if (client == null) return const {};
      final tracks = <String, List<VhCaptionLine>>{};
      for (final raw in await client.transcripts(id)) {
        final transcript = Transcript.fromJson(raw);
        if (transcript == null || transcript.isEmpty) continue;
        tracks[transcript.language] = captionLinesOf(transcript.segments);
      }
      return orderTracks(tracks, preferred: _preferred);
    }

    read()
        .catchError((Object _) => const <String, List<VhCaptionLine>>{})
        .then((tracks) => state = {...state, key: tracks});
  }

  List<String> get _preferred => [
    ?ref.read(settingsProvider).localeCode,
    'ar',
    'en',
  ];
}

/// Whether subtitles show, and in which language: the person's choice,
/// kept from clip to clip for this run.
final subtitleChoiceProvider = Provider<SubtitleChoice>((ref) {
  final choice = SubtitleChoice();
  ref.onDispose(choice.dispose);
  return choice;
});

class SubtitleChoice {
  final shown = ValueNotifier<bool>(false);
  final language = ValueNotifier<String?>(null);

  void dispose() {
    shown.dispose();
    language.dispose();
  }
}

/// The player's subtitles for [item]: null while they are read, and for a
/// clip that has none, so no CC button is offered. At the size and over
/// the background chosen in the settings; a long press on CC opens those
/// choices and the transcript of [session]'s clip.
///
/// [subtitles] is the [subtitleCacheProvider] map the player watched.
VhCaptions? sidecarCaptionsFor(
  WidgetRef ref,
  Map<String, Map<String, List<VhCaptionLine>>> subtitles,
  PlaylistItem item, {
  VhVideoSession? session,
}) {
  final tracks = sidecarTracksFor(ref, subtitles, item);
  if (tracks == null) return null;
  final choice = ref.read(subtitleChoiceProvider);
  final settings = ref.read(settingsProvider);
  late final VhCaptions captions;
  captions = VhCaptions(
    lines: tracks.values.first,
    tracks: tracks.length > 1 ? tracks : const {},
    shown: choice.shown,
    language: choice.language,
    scale: settings.captionScale,
    background: settings.captionBackdrop,
    onOptions: session == null
        ? null
        : (context) => unawaited(
            showCaptionOptions(
              context,
              captions,
              onTranscript: () => unawaited(
                showTranscriptSheet(
                  context,
                  session: session,
                  tracks: tracks,
                  language: choice.language,
                ),
              ),
            ),
          ),
  );
  return captions;
}

/// [item]'s subtitles by language, the reader's first: null while they
/// are read and for a clip with none.
Map<String, List<VhCaptionLine>>? sidecarTracksFor(
  WidgetRef ref,
  Map<String, Map<String, List<VhCaptionLine>>> subtitles,
  PlaylistItem item,
) {
  final path = item.localPath;
  final pcId = PcStreamProxy.idOf(item.serverFilename ?? '');
  final key = path ?? (pcId == null ? null : item.serverFilename);
  if (key == null) return null;
  final tracks = subtitles[key];
  if (tracks == null) {
    final cache = ref.read(subtitleCacheProvider.notifier);
    path != null ? cache.want(path) : cache.wantFromPc(key, pcId!);
    return null;
  }
  return tracks.isEmpty ? null : tracks;
}

String _stem(String name) {
  final dot = name.lastIndexOf('.');
  return dot <= 0 ? name : name.substring(0, dot);
}

/// The language between the media's name and the subtitle's extension, or
/// null for a file that is not one of its subtitles.
String? _languageOf(File file, String stem) {
  final name = file.uri.pathSegments.last;
  if (!name.startsWith('$stem.')) return null;
  final rest = name.substring(stem.length + 1);
  final dot = rest.lastIndexOf('.');
  if (dot <= 0) return null;
  final extension = rest.substring(dot + 1).toLowerCase();
  final language = rest.substring(0, dot);
  if (!_extensions.contains(extension) || language.contains('.')) return null;
  return language;
}
