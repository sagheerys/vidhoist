import 'subtitle_parser.dart';
import 'transcript.dart';

/// [transcript] as WebVTT, word timing kept the way automatic captions
/// write it (`over, <00:00:01.693><c> which</c>`), so [SubtitleParser]
/// reads back the same lines and words.
///
/// A clip copied from the computer to the phone carries its transcripts as
/// subtitle files beside it: the phone's player reads them there, as it
/// reads the ones a download wrote.
String transcriptToVtt(Transcript transcript) {
  final out = StringBuffer('WEBVTT\n');
  for (final segment in transcript.segments) {
    out.write('\n${_stamp(segment.start)} --> ${_stamp(segment.end)}\n');
    final words = segment.words;
    if (words == null || words.isEmpty) {
      out.write('${_escape(segment.text)}\n');
      continue;
    }
    for (var i = 0; i < words.length; i++) {
      final word = _escape(words[i].text);
      if (i == 0 && words[i].start == segment.start) {
        out.write(word);
      } else {
        // The space inside the tag, as the captions have it: outside, the
        // reader would glue the word to the one before.
        out.write(
          '<${_stamp(words[i].start)}><c>${i == 0 ? '' : ' '}$word</c>',
        );
      }
    }
    out.write('\n');
  }
  return out.toString();
}

String _stamp(Duration d) {
  String two(int n) => n.toString().padLeft(2, '0');
  final ms = (d.inMilliseconds % 1000).toString().padLeft(3, '0');
  return '${two(d.inHours)}:${two(d.inMinutes % 60)}:'
      '${two(d.inSeconds % 60)}.$ms';
}

/// Text that cannot end a cue or open a tag: a line of its own would start
/// a new cue, and a `<` would be read as markup.
String _escape(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll(RegExp(r'\s*\n\s*'), ' ');
