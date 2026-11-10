import 'package:test/test.dart';
import 'package:vh_transcripts/vh_transcripts.dart';

Transcript _of(List<TranscriptSegment> segments) => Transcript(
  canonicalUrl: 'https://youtu.be/x',
  language: 'ar',
  source: 'captions',
  fetchedAt: DateTime.utc(2026),
  segments: segments,
);

void main() {
  test('lines and their words read back as they were written', () {
    final segments = [
      const TranscriptSegment(
        start: Duration(seconds: 1),
        end: Duration(seconds: 3),
        text: 'over, which we',
        words: [
          TranscriptWord(Duration(seconds: 1), 'over,'),
          TranscriptWord(Duration(milliseconds: 1693), 'which'),
          TranscriptWord(Duration(milliseconds: 2100), 'we'),
        ],
      ),
      const TranscriptSegment(
        start: Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 45),
        end: Duration(hours: 1, minutes: 2, seconds: 5),
        text: 'مرحباً بكم',
      ),
    ];
    final back = SubtitleParser.parse(transcriptToVtt(_of(segments)));
    expect(back, hasLength(2));
    expect([back[0].start, back[0].end], [segments[0].start, segments[0].end]);
    expect(back[0].text, 'over, which we');
    expect(
      [for (final w in back[0].words!) (w.start, w.text)],
      [for (final w in segments[0].words!) (w.start, w.text)],
    );
    expect(back[1].start, segments[1].start);
    expect(back[1].text, 'مرحباً بكم');
    expect(back[1].words, isNull);
  });

  test('text that looks like markup or a new cue stays text', () {
    final vtt = transcriptToVtt(
      _of(const [
        TranscriptSegment(
          start: Duration.zero,
          end: Duration(seconds: 1),
          text: 'a <b> & 1 --> 2\n\nnext',
        ),
      ]),
    );
    final back = SubtitleParser.parse(vtt);
    expect(back.single.text, 'a <b> & 1 --> 2 next');
  });
}
