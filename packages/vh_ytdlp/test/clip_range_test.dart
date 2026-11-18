import 'package:test/test.dart';
import 'package:vh_ytdlp/vh_ytdlp.dart';

void main() {
  group('a time typed by hand', () {
    test('seconds, minutes and hours all read', () {
      expect(ClipRange.parseTime('90'), const Duration(seconds: 90));
      expect(ClipRange.parseTime(' 1:30 '), const Duration(seconds: 90));
      expect(ClipRange.parseTime('0:01:30'), const Duration(seconds: 90));
      expect(ClipRange.parseTime('1:02:03'), const Duration(seconds: 3723));
    });

    test('Arabic-Indic digits read as the digits they are', () {
      expect(ClipRange.parseTime('٢:٠٥'), const Duration(seconds: 125));
      expect(ClipRange.parseTime('۱:۳۰'), const Duration(seconds: 90));
    });

    test('nonsense is refused, not guessed', () {
      for (final text in ['', 'abc', '1:60', '1::2', '1:2:3:4', '-5', '1.5']) {
        expect(ClipRange.parseTime(text), isNull, reason: text);
      }
    });
  });

  test('a range must end after it starts', () {
    expect(ClipRange.tryParse('2:00', '5:30'), isNotNull);
    expect(ClipRange.tryParse('5:30', '2:00'), isNull);
    expect(ClipRange.tryParse('1:00', '1:00'), isNull);
    expect(ClipRange.tryParse('', '1:00'), isNull);
  });

  test('how yt-dlp, a file name, a person and the library see it', () {
    final clip = ClipRange.tryParse('2:00', '5:30')!;
    expect(clip.section, '*120-330');
    expect(clip.fileTag, '2m00s-5m30s');
    expect(clip.label, '2:00–5:30');
    expect(clip.tagUrl('https://y/v'), 'https://y/v#t=120,330');
    final long = ClipRange.tryParse('1:00:05', '1:02:00')!;
    expect(long.label, '1:00:05–1:02:00');
    expect(long.fileTag, '1h00m05s-1h02m00s');
    expect(long.fileTag, isNot(contains(':')));
  });

  test('kept and read back as it was', () {
    final clip = ClipRange.tryParse('0:07', '0:42')!;
    expect(ClipRange.fromWire(clip.wire), clip);
    expect(ClipRange.fromWire(null), isNull);
    expect(ClipRange.fromWire('9-3'), isNull);
    expect(ClipRange.fromWire('junk'), isNull);
  });

  // Seen: 10:00 to 20:00 asked of a 16:52 video; past its end, yt-dlp
  // fails with only ffmpeg's "Invalid argument".
  test('**the guard**: a stretch is fitted inside the video length', () {
    const length = Duration(minutes: 16, seconds: 52);
    const inside = ClipRange(Duration(minutes: 10), Duration(minutes: 15));
    expect(inside.within(length), same(inside));
    expect(
      const ClipRange(
        Duration(minutes: 10),
        Duration(minutes: 20),
      ).within(length),
      const ClipRange(Duration(minutes: 10), length),
    );
    expect(
      const ClipRange(
        Duration(minutes: 17),
        Duration(minutes: 20),
      ).within(length),
      isNull,
    );
    expect(
      const ClipRange(length, Duration(minutes: 20)).within(length),
      isNull,
    );
  });
}
