import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_media/mt_media.dart';
import 'package:mt_transcripts/mt_transcripts.dart';

import '../../di.dart';
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
Future<Map<String, List<MTCaptionLine>>> readSidecarSubtitles(
  String mediaPath, {
  List<String> preferred = const [],
}) async {
  final stem = _stem(File(mediaPath).uri.pathSegments.last);
  final tracks = <String, List<MTCaptionLine>>{};
  for (final file in sidecarSubtitleFiles(mediaPath)) {
    try {
      final lines = [
        for (final s in SubtitleParser.parse(await file.readAsString()))
          MTCaptionLine(
            start: s.start,
            end: s.end,
            text: s.text,
            words: s.words == null
                ? null
                : [for (final w in s.words!) MTCaptionWord(w.start, w.text)],
          ),
      ];
      if (lines.isNotEmpty) tracks[_languageOf(file, stem)!] = lines;
    } on FileSystemException {
      // A file gone since the listing, or unreadable: the others still show.
    }
  }
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
  final kept = <String, List<MTCaptionLine>>{};
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
bool _sameLines(List<MTCaptionLine> a, List<MTCaptionLine> b) {
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
      Map<String, Map<String, List<MTCaptionLine>>>
    >(SubtitleCache.new);

class SubtitleCache
    extends Notifier<Map<String, Map<String, List<MTCaptionLine>>>> {
  final _asked = <String>{};

  @override
  Map<String, Map<String, List<MTCaptionLine>>> build() => const {};

  /// Reads [path]'s subtitles once; asking again costs nothing.
  void want(String path) {
    if (!_asked.add(path)) return;
    final locale = ref.read(settingsProvider).localeCode;
    readSidecarSubtitles(path, preferred: [?locale, 'ar', 'en']).then((tracks) {
      state = {...state, path: tracks};
    });
  }
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
MTCaptions? sidecarCaptionsFor(
  WidgetRef ref,
  Map<String, Map<String, List<MTCaptionLine>>> subtitles,
  PlaylistItem item, {
  MTVideoSession? session,
}) {
  final tracks = sidecarTracksFor(ref, subtitles, item);
  if (tracks == null) return null;
  final choice = ref.read(subtitleChoiceProvider);
  final settings = ref.read(settingsProvider);
  late final MTCaptions captions;
  captions = MTCaptions(
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
Map<String, List<MTCaptionLine>>? sidecarTracksFor(
  WidgetRef ref,
  Map<String, Map<String, List<MTCaptionLine>>> subtitles,
  PlaylistItem item,
) {
  final path = item.localPath;
  if (path == null) return null;
  final tracks = subtitles[path];
  if (tracks == null) {
    ref.read(subtitleCacheProvider.notifier).want(path);
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
