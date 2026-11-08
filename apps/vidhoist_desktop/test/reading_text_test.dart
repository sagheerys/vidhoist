import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/features/reading/reading_text.dart';
import 'package:vh_transcripts/vh_transcripts.dart';
import 'package:vh_ui/vh_ui.dart';

TranscriptSegment _line(int from, int to, String text) => TranscriptSegment(
  start: Duration(seconds: from),
  end: Duration(seconds: to),
  text: text,
);

/// The words and the moment as the reading room copies them; the
/// paragraphs, quotes and links they are built from live in
/// vh_transcripts with their own tests.
void main() {
  final lines = [
    _line(10, 12, 'The first line'),
    _line(12, 15, 'goes on here.'),
    _line(20, 23, 'After a pause'),
  ];
  final paragraphs = paragraphsOf(lines);

  test('**the guard**: is copied with its words, title, span of time and '
      'a link to its first second', () {
    final quote = quoteOf(paragraphs, 0, paragraphs.first.text.length)!;
    final l = lookupVhLocalizations(const Locale('en'));
    expect(
      quoteText(
        l,
        quote: quote,
        segments: lines,
        title: 'Night Drive',
        canonicalUrl: 'https://youtu.be/aaaaaaaaaaa',
      ),
      '“The first line goes on here.”\n'
      '— Night Drive, 0:10–0:15\n'
      'https://youtu.be/aaaaaaaaaaa?t=10s',
    );
    final ar = lookupVhLocalizations(const Locale('ar'));
    expect(
      quoteText(
        ar,
        quote: quote,
        segments: lines,
        title: 'Night Drive',
        canonicalUrl: 'https://youtu.be/aaaaaaaaaaa',
      ),
      startsWith('«The first line goes on here.»'),
    );
  });
}
