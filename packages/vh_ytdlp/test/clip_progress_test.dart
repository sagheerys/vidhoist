import 'package:test/test.dart';
import 'package:vh_ytdlp/vh_ytdlp.dart';

/// ffmpeg's `-progress pipe:1` lines for one stretch, as measured
/// 2026-11-17 on a two-minute stretch.
void main() {
  FfmpegLine line(String raw) => YtDlpLine.parse(raw) as FfmpegLine;

  test('only the keys the progress needs are read as ffmpeg lines', () {
    expect(YtDlpLine.parse('out_time_us=2333333'), isA<FfmpegLine>());
    expect(YtDlpLine.parse('progress=continue'), isA<FfmpegLine>());
    expect(YtDlpLine.parse('frame=97'), isA<OtherLine>());
    expect(YtDlpLine.parse('[download] a=b'), isA<OtherLine>());
  });

  test('a block counts once it closes, never goes back, and ends at 1', () {
    final clip = ClipProgress(const Duration(seconds: 120));
    expect(clip.add(line('out_time_us=60000000')), isNull);
    expect(clip.add(line('progress=continue'))!.fraction, 0.5);
    clip.add(line('out_time_us=N/A'));
    expect(clip.add(line('progress=continue'))!.fraction, 0.5);
    clip.add(line('out_time_us=30000000'));
    expect(clip.add(line('progress=continue'))!.fraction, 0.5);
    expect(clip.add(line('progress=end'))!.fraction, 1);
  });

  test('the time left is the stretch left over ffmpeg\'s pace', () {
    final clip = ClipProgress(const Duration(seconds: 100))
      ..add(line('out_time_us=20000000'))
      ..add(line('speed=1.6x'));
    expect(clip.add(line('progress=continue'))!.eta, 50);
    clip.add(line('speed=N/A'));
    expect(clip.add(line('progress=continue'))!.eta, isNull);
  });

  // Seen 2026-11-18: an Instagram video 24 s long, asked from 1:00 to 2:00,
  // gave a 4 s file that would not play, and yt-dlp exited 0.
  test('**the guard**: a stretch ffmpeg ends still behind is past the '
      'end; one that only starts behind is not', () {
    final past = ClipProgress(const Duration(seconds: 60))
      ..add(line('out_time_us=-35783333'))
      ..add(line('progress=end'));
    expect(past.pastEnd, isTrue);

    final inside = ClipProgress(const Duration(seconds: 10));
    for (final us in ['-1930000', '4000000', '10000000']) {
      inside
        ..add(line('out_time_us=$us'))
        ..add(line('progress=${us == '10000000' ? 'end' : 'continue'}'));
      if (us != '10000000') expect(inside.pastEnd, isFalse);
    }
    expect(inside.pastEnd, isFalse);
  });

  test('the length is the longest input ffmpeg names on stderr', () {
    const stderr = '''
Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'https://example.invalid/v.mp4':
  Duration: 00:00:24.22, start: 0.000000, bitrate: 1671 kb/s
Input #1, mov,mp4,m4a,3gp,3g2,mj2, from 'https://example.invalid/a.mp4':
  Duration: 00:00:24.21, start: 0.000000, bitrate: 68 kb/s
''';
    expect(
      ClipProgress.inputLength(stderr),
      const Duration(seconds: 24, milliseconds: 220),
    );
    expect(ClipProgress.inputLength('  Duration: N/A, bitrate: N/A'), isNull);
    expect(
      ClipProgress.inputLength('  Duration: 01:02:03.5,'),
      const Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 500),
    );
  });
}
