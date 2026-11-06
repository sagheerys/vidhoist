import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_transcripts/mt_transcripts.dart';

import 'transcripts_data.dart';

/// The subtitles yt-dlp wrote beside [mediaPath] (`<name>.<language>.vtt`
/// or `.srt`), read as transcripts of [canonicalUrl]. A track that holds
/// no line is skipped.
Future<List<Transcript>> readSidecarTranscripts({
  required String mediaPath,
  required String canonicalUrl,
  DateTime? at,
}) async {
  final media = File(mediaPath);
  final name = media.uri.pathSegments.last;
  final dot = name.lastIndexOf('.');
  final stem = dot <= 0 ? name : name.substring(0, dot);
  final found = <Transcript>[];
  final seen = <String>{};
  try {
    await for (final entry in media.parent.list()) {
      if (entry is! File) continue;
      final file = entry.uri.pathSegments.last;
      if (!file.startsWith('$stem.')) continue;
      final rest = file.substring(stem.length + 1).split('.');
      if (rest.length != 2 || !const {'vtt', 'srt'}.contains(rest[1])) {
        continue;
      }
      final language = Transcript.baseLanguage(rest[0]);
      if (!seen.add(language)) continue;
      final segments = SubtitleParser.parse(await entry.readAsString());
      if (segments.isEmpty) continue;
      found.add(
        Transcript(
          canonicalUrl: canonicalUrl,
          language: language,
          source: 'captions',
          fetchedAt: at ?? DateTime.now(),
          segments: segments,
          reader: SubtitleParser.version,
        ),
      );
    }
  } on FileSystemException {
    // The folder went away: the clip simply has no transcript yet.
  }
  return found;
}

/// Keeps what [task] brought with it as the clip's transcripts, searchable
/// at once. Never throws: the clip is in the library whatever happens.
Future<void> importSidecarTranscripts(Ref ref, DownloadTask task) async {
  final path = task.localPath;
  final store = ref.read(transcriptStoreProvider);
  if (path == null || store == null) return;
  try {
    for (final transcript in await readSidecarTranscripts(
      mediaPath: path,
      canonicalUrl: task.canonicalUrl ?? task.effectiveUrl,
    )) {
      await keepTranscript(ref, store, transcript, fetched: true);
    }
  } on Object {
    // A transcript lost is fetched again from the clip's page later.
  }
}
