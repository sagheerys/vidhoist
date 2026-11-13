import 'dart:io';

import 'subtitle_parser.dart';
import 'transcript.dart';

/// The largest subtitle file read from disk. An hour of speech is about
/// 100KB; a file fifty times that is not subtitles, and read whole it would
/// sit in memory several times over (the text, its lines, its cues).
const int maxSubtitleFileBytes = 5 * 1024 * 1024;

/// The cues of the subtitle file [file], read off the drawing thread when
/// large; none for a file over [maxSubtitleFileBytes], which is skipped
/// before a byte of it is read. Throws [FileSystemException] as reading
/// would.
Future<List<TranscriptSegment>> readSubtitleFile(File file) async {
  if (await file.length() > maxSubtitleFileBytes) return const [];
  return SubtitleParser.parseAway(await file.readAsString());
}
