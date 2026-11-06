import 'package:mt_ytdlp/mt_ytdlp.dart';
import 'package:test/test.dart';

void main() {
  // These are the strings checked against the real info JSON with
  // `yt-dlp --load-info-json … --simulate`; the comment beside each is what
  // yt-dlp picked from the fixture (docs/ENGINE.md). A change here needs
  // that check again.
  group('selector', () {
    test('best takes the best picture and sound', () {
      // 401+258: AV1 2160p with AAC
      expect(FormatSelector.selector(FormatChoice.best), 'bv*+ba/b');
    });

    test('a height is a ceiling for the merged and the single stream', () {
      // 399+258: AV1 1080p
      expect(
        FormatSelector.selector(FormatChoice.h1080),
        'bv*[height<=1080]+ba/b[height<=1080]',
      );
      // 396+258: AV1 360p
      expect(
        FormatSelector.selector(FormatChoice.h360),
        'bv*[height<=360]+ba/b[height<=360]',
      );
    });

    test('compatible prefers H.264 and AAC, then anything under the cap', () {
      // 298+258: H.264 720p60 with AAC
      expect(
        FormatSelector.selector(FormatChoice.h720, compatible: true),
        "bv*[height<=720][vcodec~='^(avc|h264)'][ext=mp4]+ba[ext=m4a]"
        '/b[height<=720][ext=mp4]/bv*[height<=720]+ba/b[height<=720]',
      );
      // 299+258: H.264 1080p60, the best H.264 there is
      expect(
        FormatSelector.selector(FormatChoice.best, compatible: true),
        "bv*[vcodec~='^(avc|h264)'][ext=mp4]+ba[ext=m4a]/b[ext=mp4]/bv*+ba/b",
      );
    });

    test('audio takes the best sound, compatible or not', () {
      // 258: AAC
      expect(FormatSelector.selector(FormatChoice.audio), 'ba/b');
      expect(
        FormatSelector.selector(FormatChoice.audio, compatible: true),
        'ba/b',
      );
    });
  });

  group('args', () {
    test('video is merged into MP4 so the file name is predictable', () {
      expect(FormatSelector.args(FormatChoice.h480), [
        '-f',
        'bv*[height<=480]+ba/b[height<=480]',
        '--merge-output-format',
        'mp4',
      ]);
    });

    test('audio is extracted and converted, M4A unless asked otherwise', () {
      expect(FormatSelector.args(FormatChoice.audio), [
        '-f',
        'ba/b',
        '-x',
        '--audio-format',
        'm4a',
      ]);
      expect(
        FormatSelector.args(
          FormatChoice.audio,
          audioFormat: AudioFormat.original,
        ).last,
        'best',
      );
    });
  });

  test('every choice has a height except best and audio', () {
    expect(
      {for (final c in FormatChoice.values) c: c.height},
      {
        FormatChoice.best: null,
        FormatChoice.h1080: 1080,
        FormatChoice.h720: 720,
        FormatChoice.h480: 480,
        FormatChoice.h360: 360,
        FormatChoice.audio: null,
      },
    );
  });
}
