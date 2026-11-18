import 'dart:io';

import 'package:vh_core/vh_core.dart';
import 'package:test/test.dart';

/// The real Windows runs measured in batch 1, kept in `vh_ytdlp`.
String fixture(String name) =>
    File('../vh_ytdlp/test/fixtures/windows/$name').readAsStringSync();

Stream<String> linesOf(String text) => Stream.fromIterable(text.split('\n'));

Future<List<BackendEvent>> read(String stdout, int code, String stderr) =>
    readDownloadRun(
      linesOf(stdout),
      Future.value((exitCode: code, stderr: stderr)),
    ).toList();

void main() {
  group('reading a run', () {
    test('a merged 1080p download: progress, then the file', () async {
      final events = await read(
        fixture('yt-1080-js.stdout.txt'),
        0,
        fixture('yt-1080-js.stderr.txt'),
      );
      final progress = events.whereType<BackendProgress>().toList();
      expect(progress, isNotEmpty);
      expect(progress.last.progress.fraction, 1);
      expect(progress.last.progress.part, 2);
      final finished = events.last as BackendFinished;
      expect(finished.path, endsWith('[aqz-KE-bpKQ].mp4'));
    });

    // Seen 2026-11-17: a stretch's bar stood still, then the file was done.
    test('**the guard**: a stretch moves with the progress ffmpeg gives, '
        'and the whole video sizes do not send it back', () async {
      List<String> block(int us, int bytes, [String state = 'continue']) => [
        'frame=97',
        'total_size=$bytes',
        'out_time_us=$us',
        'out_time_ms=$us',
        'speed=2.00x',
        'progress=$state',
      ];
      final events = await readDownloadRun(
        Stream.fromIterable([
          '[vh-parts] 90000000 [80000000, 10000000]',
          '[download] Destination: c.mp4',
          ...block(30000000, 1000),
          ...block(60000000, 2000),
          ...block(120000000, 4000, 'end'),
          '[vh] finished 4000 4000 NA 2.3 1700 NA NA 396+258',
          r'[vh-file] C:\out\a [x] 1m00s-3m00s.mp4',
        ]),
        Future.value((exitCode: 0, stderr: '')),
        clip: const Duration(minutes: 2),
      ).toList();
      final seen = [
        for (final e in events.whereType<BackendProgress>()) e.progress,
      ];
      expect([for (final p in seen) p.fraction], [0.25, 0.5, 1, 1]);
      expect(seen.first.downloadedBytes, 1000);
      // 90 s of the stretch left at twice playing speed.
      expect(seen.first.eta, 45);
      expect(events.last, isA<BackendFinished>());
    });

    // Seen 2026-11-18: an Instagram video 24 s long, asked from 1:00 to
    // 2:00, left a 4 s file that would not play, and yt-dlp exited 0.
    test('**the guard**: a stretch that starts past the end fails, says '
        'how long the video is, and leaves no file', () async {
      final folder = Directory.systemTemp.createTempSync('vh_past_end');
      addTearDown(() => folder.deleteSync(recursive: true));
      final broken = File('${folder.path}/a [x] 1m00s-2m00s.mp4')
        ..writeAsBytesSync([0, 1, 2]);
      final events = await readDownloadRun(
        Stream.fromIterable([
          '[download] Destination: ${broken.path}',
          'total_size=1019474',
          'out_time_us=-35783333',
          'progress=end',
          '[vh] finished 1019474 1019474 NA 1 NA NA NA',
          '[vh-file] ${broken.path}',
        ]),
        Future.value((
          exitCode: 0,
          stderr:
              '  Duration: 00:00:24.22, start: 0.000000, bitrate: 1671 kb/s\n'
              '  Duration: 00:00:24.21, start: 0.000000, bitrate: 68 kb/s\n',
        )),
        clip: const Duration(minutes: 1),
      ).toList();
      final failed = events.last as BackendFailed;
      expect(failed.error.kind, YtDlpErrorKind.clipPastEnd);
      expect(
        failed.error.length,
        const Duration(seconds: 24, milliseconds: 220),
      );
      expect(broken.existsSync(), isFalse);
      expect(
        EngineFailureException.from(failed.error),
        isA<ClipPastEndException>().having(
          (e) => e.length,
          'length',
          const Duration(seconds: 24, milliseconds: 220),
        ),
      );
    });

    test('announced parts and post-processing come through', () async {
      final events = await read(
        [
          '[vh-parts] 1000 [900, 100]',
          '[vh] downloading 450 900 NA 1 1 NA NA',
          '[vh] finished 900 900 NA 1 NA NA NA',
          '[vh] downloading 50 100 NA 1 1 NA NA',
          '[vh] finished 100 100 NA 1 NA NA NA',
          '[vh-pp] started Merger',
          '[vh-pp] finished Merger',
          'something else',
          r'[vh-file] C:\out\a [x].mp4',
        ].join('\n'),
        0,
        '',
      );
      final fractions = [
        for (final e in events.whereType<BackendProgress>())
          e.progress.fraction,
      ];
      expect(fractions.first, 0.45);
      expect(fractions[2], closeTo(0.95, 1e-9));
      expect(
        events.whereType<BackendPostprocessing>().single.postprocessor,
        'Merger',
      );
      expect((events.last as BackendFinished).path, r'C:\out\a [x].mp4');
    });

    test(
      '**the guard**: subtitles fetched first do not fill the bar',
      () async {
        // Owner, 2026-11-07, on the phone and on Windows: the counter went
        // from 0 to 100 at once. Two subtitle files had taken the places of
        // the video and its audio; measured on a real run with subtitles.
        final events = await read(
          [
            '[vh-parts] 1000 [900, 100]',
            '[vh] downloading 20 40 NA 1 NA NA NA NA',
            '[vh] finished 40 40 NA 1 NA NA NA NA',
            '[vh] downloading 30 60 NA 1 NA NA NA NA',
            '[vh] finished 60 60 NA 1 NA NA NA NA',
            '[vh] downloading 450 900 NA 1 1 NA NA 399',
            '[vh] finished 900 900 NA 1 NA NA NA 399',
            '[vh] downloading 50 100 NA 1 1 NA NA 251',
            '[vh] finished 100 100 NA 1 NA NA NA 251',
            r'[vh-file] C:\out\a [x].mp4',
          ].join('\n'),
          0,
          '',
        );
        final fractions = [
          for (final e in events.whereType<BackendProgress>())
            e.progress.fraction,
        ];
        expect(fractions, [0.45, 0.9, 0.95, 1.0]);
      },
    );

    test('a failed run is classified from its stderr', () async {
      final events = await read('', 1, fixture('tiktok.stderr.txt'));
      final failed = events.single as BackendFailed;
      expect(failed.error.kind, YtDlpErrorKind.geoBlocked);
    });

    test('success without a file is a failure', () async {
      final events = await read('[vh] finished 1 1 NA 1 NA NA NA', 0, 'odd');
      final failed = events.last as BackendFailed;
      expect(failed.error.kind, YtDlpErrorKind.failed);
      expect(failed.error.message, contains('without naming a file'));
    });
  });

  group('the request', () {
    test('each quality has its format choice', () {
      expect(
        {
          for (final q in Quality.values)
            q: DownloadRequest(
              taskId: 't',
              url: 'u',
              folder: 'f',
              quality: q,
            ).formatChoice,
        },
        {
          Quality.best: FormatChoice.best,
          Quality.q1080: FormatChoice.h1080,
          Quality.q720: FormatChoice.h720,
          Quality.q480: FormatChoice.h480,
          Quality.q360: FormatChoice.h360,
          Quality.audio: FormatChoice.audio,
        },
      );
    });

    test('from a link, or from a probe when there is one', () {
      const request = DownloadRequest(
        taskId: 't',
        url: 'https://x',
        folder: '/out',
        quality: Quality.q720,
        compatible: true,
        subtitleLanguages: ['ar.*'],
        playlistItems: [2],
      );
      final spec = request.toSpec();
      expect(spec.url, 'https://x');
      expect(spec.infoJsonPath, isNull);
      expect(spec.choice, FormatChoice.h720);
      expect(spec.compatible, isTrue);
      expect(spec.subtitleLanguages, ['ar.*']);
      expect(spec.playlistItems, [2]);

      final probed = request.copyWith(infoJsonPath: () => '/c/p.json');
      expect(probed.toSpec().url, isNull);
      expect(probed.toSpec().infoJsonPath, '/c/p.json');
      expect(probed.copyWith(infoJsonPath: () => null).infoJsonPath, isNull);
      expect(probed.copyWith(quality: Quality.best).quality, Quality.best);
      expect(probed.copyWith(quality: Quality.best).infoJsonPath, '/c/p.json');
    });

    test('the tuning survives a retry at another quality', () {
      const request = DownloadRequest(
        taskId: 't',
        url: 'u',
        folder: '/out',
        tuning: DownloadTuning(
          audioFormat: AudioFormat.original,
          rateLimit: '5M',
          concurrentFragments: 4,
          embedSubtitles: true,
        ),
      );
      final spec = request.copyWith(quality: Quality.q480).toSpec();
      expect(spec.audioFormat, AudioFormat.original);
      expect(spec.rateLimit, '5M');
      expect(spec.concurrentFragments, 4);
      expect(spec.embedSubtitles, isTrue);
    });

    test('the cover goes inside the file unless the app says not to', () {
      const request = DownloadRequest(taskId: 't', url: 'u', folder: '/out');
      expect(request.toSpec().embedThumbnail, isTrue);
      expect(request.toSpec(embedThumbnail: false).embedThumbnail, isFalse);
    });
  });

  test('engine errors in the core terms', () {
    YtDlpError e(YtDlpErrorKind kind) => YtDlpError(kind, 'm');
    expect(
      EngineFailureException.from(e(YtDlpErrorKind.network)),
      isA<NetworkException>(),
    );
    expect(
      EngineFailureException.from(e(YtDlpErrorKind.signInRequired)),
      isA<PlatformBlockedException>(),
    );
    final disk = EngineFailureException.from(e(YtDlpErrorKind.diskFull));
    expect((disk as EngineFailureException).kind, YtDlpErrorKind.diskFull);
    expect(disk.detail, 'm');
    expect(disk.isRetryable, isFalse);
  });

  test('the fake backend answers versions and updates', () async {
    final fake = FakeBackend();
    expect((await fake.version()).ytDlp.toString(), '2026.10.26');
    final outcome = await fake.updateEngine();
    expect(outcome.updated, isFalse);
    expect(fake.updates, 1);
    final probe = await FakeBackend(
      scripts: {'u': const FakeScript(keepsInfoJson: false)},
    ).probe('u');
    expect(probe.infoJsonPath, isNull);
    expect(probe.info.title, 'Title of u');
  });
}
