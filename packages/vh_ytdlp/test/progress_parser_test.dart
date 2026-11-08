import 'package:vh_ytdlp/vh_ytdlp.dart';
import 'package:test/test.dart';

import 'fixtures.dart';

void main() {
  group('the real runs', () {
    for (final run in fixtureRuns()) {
      final lines = fixture('$run.stdout.txt')
          .split('\n')
          .where((l) => l.startsWith('[vh'))
          .toList();
      if (lines.isEmpty) continue;

      test('$run: every tagged line is read, none falls through', () {
        final parsed = lines.map(YtDlpLine.parse).toList();
        final missed = [
          for (var i = 0; i < lines.length; i++)
            if (parsed[i] is OtherLine) lines[i],
        ];
        expect(missed, isEmpty);
        // The cancelled run was stopped part-way: no file, no finish.
        final cancelled = run == 'yt-cancel';
        expect(parsed.whereType<FileLine>(), hasLength(cancelled ? 0 : 1));
        expect(parsed.whereType<ProgressLine>().last.isFinished, !cancelled);
      });
    }
  });

  group('progress', () {
    test('a stream of known size', () {
      final line = YtDlpLine.parse(
        '[vh] downloading 31744 124386876 NA 568102.8228326634 218 NA NA',
      );
      expect(line, isA<ProgressLine>());
      line as ProgressLine;
      expect(line.status, 'downloading');
      expect(line.downloaded, 31744);
      expect(line.total, 124386876);
      expect(line.totalEstimate, isNull);
      expect(line.speed, closeTo(568102.82, 0.01));
      expect(line.eta, 218);
      expect(line.fragmentIndex, isNull);
      expect(line.fraction, closeTo(31744 / 124386876, 1e-9));
    });

    test('**the guard**: a subtitle file is told from the video by its '
        'missing format', () {
      // Measured 2026-11-07: yt-dlp fetches the subtitles first, with
      // progress lines of their own and no format id; counted as the
      // video's parts, two files took the bar to 100% before the video began.
      final subtitle = YtDlpLine.parse(
        '[vh] downloading 4096 40582 NA 81743.5 NA NA NA NA',
      ) as ProgressLine;
      expect(subtitle.isSideFile, isTrue);
      final video = YtDlpLine.parse(
        '[vh] downloading 4096 71283827 NA 81743.5 872 NA NA 399',
      ) as ProgressLine;
      expect(video.isSideFile, isFalse);
      expect(video.downloaded, 4096);
      expect(video.formatId, '399');
      final drc = YtDlpLine.parse(
        '[vh] finished 100 100 NA 1 NA NA NA 251-drc',
      ) as ProgressLine;
      expect(drc.formatId, '251-drc');
      // A line from before the format field (the batch 1 runs) is media.
      final old = YtDlpLine.parse(
        '[vh] downloading 1024 124386876 NA 61791.8 2014 NA NA',
      ) as ProgressLine;
      expect(old.isSideFile, isFalse);
      expect(old.formatId, isNull);
    });

    test('a fragmented stream gives an estimate and fragment numbers', () {
      final line = YtDlpLine.parse(
        '[vh] downloading 2048 NA 40960.5 NA NA 3 20',
      ) as ProgressLine;
      expect(line.total, isNull);
      expect(line.size, 40961);
      expect(line.speed, isNull);
      expect(line.fragmentIndex, 3);
      expect(line.fragmentCount, 20);
    });

    test('a size nobody knows leaves the fraction unknown', () {
      final line = YtDlpLine.parse(
        '[vh] downloading 2048 NA NA NA NA NA NA',
      ) as ProgressLine;
      expect(line.fraction, isNull);
    });

    test('finished is whole', () {
      final line = YtDlpLine.parse(
        '[vh] finished 8021517 8021517 NA 809784.59 NA NA NA',
      ) as ProgressLine;
      expect(line.isFinished, isTrue);
      expect(line.fraction, 1);
    });

    test('a line cut short still reads; garbage does not', () {
      expect(
        YtDlpLine.parse('[vh] downloading 10971238 124386876'),
        isA<ProgressLine>(),
      );
      expect(YtDlpLine.parse('[vh] downloading lots'), isA<OtherLine>());
      expect(YtDlpLine.parse('[vh] '), isA<OtherLine>());
      expect(YtDlpLine.parse('[vh] a 1 2 3 4 5 6 7 8 9'), isA<OtherLine>());
    });
  });

  group('the other tags', () {
    test('the finished file, Windows path and spaces kept', () {
      final line = YtDlpLine.parse(
        r'[vh-file] C:\out\Big Buck Bunny [aqz-KE-bpKQ].mp4'
        '\r',
      );
      expect(
        (line as FileLine).path,
        r'C:\out\Big Buck Bunny [aqz-KE-bpKQ].mp4',
      );
      expect(YtDlpLine.parse('[vh-file] '), isA<OtherLine>());
    });

    test('the parts of a merged download', () {
      final line = YtDlpLine.parse(
        '[vh-parts] 181292478 [150524845, 30767602]',
      ) as PartsLine;
      expect(line.sizes, [150524845, 30767602]);
    });

    test('one stream is its whole size', () {
      expect((YtDlpLine.parse('[vh-parts] 30767602 []') as PartsLine).sizes, [
        30767602,
      ]);
      expect((YtDlpLine.parse('[vh-parts] NA [null, 12]') as PartsLine).sizes, [
        null,
        12,
      ]);
    });

    test('parts that are not JSON fall through', () {
      expect(YtDlpLine.parse('[vh-parts] 12 [1,'), isA<OtherLine>());
      expect(YtDlpLine.parse('[vh-parts] 12 {"a":1}'), isA<OtherLine>());
      expect(YtDlpLine.parse('[vh-parts] 12'), isA<OtherLine>());
    });

    test('post-processing', () {
      final merge =
          YtDlpLine.parse('[vh-pp] started Merger') as PostprocessLine;
      expect(merge.status, 'started');
      expect(merge.isMerge, isTrue);
      final audio =
          YtDlpLine.parse('[vh-pp] finished ExtractAudio') as PostprocessLine;
      expect(audio.isAudioConversion, isTrue);
      expect(YtDlpLine.parse('[vh-pp] started'), isA<OtherLine>());
    });

    test('anything else is kept as text', () {
      final line = YtDlpLine.parse('WARNING: Unknown codec iamf.001.001.Opus');
      expect((line as OtherLine).text, startsWith('WARNING'));
    });
  });
}
