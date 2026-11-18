import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_desktop/platform/ytdlp_process.dart';

import 'support/fake_process.dart';

/// yt-dlp as a process on Windows: the command each request becomes, its
/// lines read as they come, the whole tree stopped on cancel, and the
/// probe's JSON kept for the download that follows. No real yt-dlp runs.
void main() {
  late Directory cache;
  const setup = EngineSetup(
    platform: HostPlatform.windows,
    ffmpegDir: r'C:\engine\ffmpeg',
    jsRuntime: r'deno:C:\engine\deno\deno.exe',
  );
  const run = EngineRun(
    ytDlp: r'C:\engine\yt-dlp\yt-dlp.exe',
    setup: setup,
    ffmpeg: r'C:\engine\ffmpeg\ffmpeg.exe',
    deno: r'C:\engine\deno\deno.exe',
  );
  const request = DownloadRequest(
    taskId: 't1',
    url: 'https://www.youtube.com/watch?v=abc',
    folder: r'C:\Users\me\Downloads\Vidhoist',
  );

  setUp(() async {
    cache = await Directory.systemTemp.createTemp('vh_probe_');
  });
  tearDown(() => cache.delete(recursive: true));

  ProcessYtDlpBackend backend(
    FakeStarter starter, {
    FakeTree? tree,
    EngineRun? engine = run,
    DateTime Function()? clock,
  }) => ProcessYtDlpBackend(
    engine: () async => engine,
    probeFolder: cache,
    start: starter.call,
    tree: tree ?? FakeTree(),
    clock: clock,
  );

  group('download', () {
    test('runs the engine with the command its request makes', () async {
      final starter = FakeStarter((s) {
        s.process.say(r'[vh-file] C:\f\clip.mp4');
        s.process.end(0);
      });
      await backend(starter).download(request).toList();
      final started = starter.started.single;
      expect(started.executable, run.ytDlp);
      expect(
        started.arguments,
        CommandBuilder.download(request.toSpec(), setup),
      );
      // yt-dlp prints file names in the console's code page otherwise,
      // and an Arabic title arrives as question marks.
      expect(started.environment, containsPair('PYTHONUTF8', '1'));
      expect(started.environment, containsPair('PYTHONIOENCODING', 'utf-8'));
    });

    test('its lines become progress, then the finished file', () async {
      final starter = FakeStarter((s) {
        s.process
          ..say('[vh] downloading 50 100 NA 1000 5 NA NA')
          ..say('[vh] finished 100 100 NA NA NA NA NA')
          ..say(r'[vh-file] C:\f\clip.mp4');
        s.process.end(0);
      });
      final events = await backend(starter).download(request).toList();
      expect(events.whereType<BackendProgress>(), hasLength(2));
      expect(
        events.whereType<BackendProgress>().first.progress.fraction,
        closeTo(0.5, 1e-9),
      );
      expect((events.last as BackendFinished).path, r'C:\f\clip.mp4');
    });

    test('an Arabic name split across two reads arrives whole', () async {
      const name = r'C:\f\مقطع عربي [abc].mp4';
      final bytes = utf8.encode('[vh-file] $name\r\n');
      final starter = FakeStarter((s) {
        // The cut falls inside a two-byte letter.
        s.process
          ..sayBytes(bytes.sublist(0, 17))
          ..sayBytes(bytes.sublist(17));
        s.process.end(0);
      });
      final events = await backend(starter).download(request).toList();
      expect((events.single as BackendFinished).path, name);
    });

    test('a failed run is classified from what it wrote on stderr', () async {
      final starter = FakeStarter((s) {
        s.process.complain('ERROR: [youtube] abc: Video unavailable');
        s.process.end(1);
      });
      final events = await backend(starter).download(request).toList();
      final failed = events.single as BackendFailed;
      expect(failed.error.kind, YtDlpErrorKind.unavailable);
    });

    // A clip failed on Windows with only "[PYI-31540:ERROR] Failed to
    // execute script '__main__'" in the log: the traceback that says why
    // was dropped.
    test('**the guard**: a failed run leaves its last stderr lines in the '
        'log', () async {
      final logged = <String>[];
      final starter = FakeStarter((s) {
        s.process.complain('Traceback (most recent call last):\n');
        s.process.complain('frame=  120 fps= 30 size=  1024KiB\n');
        s.process.complain('OSError: [Errno 22] Invalid argument\n');
        s.process.complain("[PYI-31540:ERROR] Failed to execute script\n");
        s.process.end(1);
      });
      await ProcessYtDlpBackend(
        engine: () async => run,
        probeFolder: cache,
        start: starter.call,
        tree: FakeTree(),
        onLog: logged.add,
      ).download(request).toList();
      final entry = logged.single;
      expect(entry, contains('OSError: [Errno 22] Invalid argument'));
      expect(entry, contains('Traceback'));
      expect(entry, isNot(contains('frame=')));
    });

    test('the tail keeps the last lines, each cut short', () {
      final long = List.generate(20, (i) => 'line $i').join('\n');
      final tail = ProcessYtDlpBackend.stderrTail(long);
      expect(tail.split('\n'), hasLength(15));
      expect(tail, startsWith('line 5'));
      expect(ProcessYtDlpBackend.stderrTail('x' * 400).length, lessThan(310));
    });

    test('each process is tied to the tree, and let go when it ends', () async {
      final tree = FakeTree();
      final starter = FakeStarter((s) {
        s.process.say(r'[vh-file] C:\f\clip.mp4');
        s.process.end(0);
      });
      await backend(starter, tree: tree).download(request).toList();
      final pid = starter.started.single.process.pid;
      expect(tree.adopted, [pid]);
      expect(tree.released, [pid]);
      expect(tree.killed, isEmpty);
    });

    test(
      'cancel kills the whole tree and the run ends with no verdict',
      () async {
        final tree = FakeTree();
        final starter = FakeStarter(
          (s) => s.process.say('[vh] downloading 10 100 NA NA NA NA NA'),
        );
        final engine = backend(starter, tree: tree);
        final events = <BackendEvent>[];
        final done = Completer<void>();
        engine.download(request).listen(events.add, onDone: done.complete);
        await pumpUntil(() => events.isNotEmpty);
        await engine.cancel('t1');
        await done.future.timeout(const Duration(seconds: 2));
        expect(tree.killed, [starter.started.single.process.pid]);
        expect(events.whereType<BackendFinished>(), isEmpty);
        expect(events.whereType<BackendFailed>(), isEmpty);
      },
    );

    test('cancelling a task that is not running does nothing', () async {
      final tree = FakeTree();
      await backend(FakeStarter(), tree: tree).cancel('nothing');
      expect(tree.killed, isEmpty);
    });

    test('with no engine it fails as missing, without starting', () async {
      final starter = FakeStarter();
      final events = await backend(
        starter,
        engine: null,
      ).download(request).toList();
      expect(
        (events.single as BackendFailed).error.kind,
        YtDlpErrorKind.engineMissing,
      );
      expect(starter.started, isEmpty);
    });

    test('an engine that cannot start fails as missing', () async {
      final starter = FakeStarter()
        ..refuse = const ProcessException('yt-dlp.exe', [], 'not found', 2);
      final events = await backend(starter).download(request).toList();
      expect(
        (events.single as BackendFailed).error.kind,
        YtDlpErrorKind.engineMissing,
      );
    });
  });

  group('probe', () {
    const json = '{"id":"abc","title":"A title","webpage_url":"https://y/abc"}';

    test('keeps the JSON in the cache folder for the download', () async {
      final starter = FakeStarter((s) {
        s.process.say(json);
        s.process.end(0);
      });
      final result = await backend(starter).probe(request.url);
      expect(
        starter.started.single.arguments,
        CommandBuilder.probe(request.url, setup),
      );
      expect(result.info.title, 'A title');
      final kept = File(result.infoJsonPath!);
      expect(kept.parent.path, cache.path);
      expect(jsonDecode(await kept.readAsString()), jsonDecode(json));
      // The link is not in the file's name: the folder can be listed. The
      // name alone, as the temp folder is random and may hold the letters.
      expect(kept.uri.pathSegments.last, isNot(contains('abc')));
    });

    test('a refused probe throws the classified error', () async {
      final starter = FakeStarter((s) {
        s.process.complain('ERROR: Unsupported URL: https://example.com/x');
        s.process.end(1);
      });
      await expectLater(
        backend(starter).probe('https://example.com/x'),
        throwsA(
          isA<YtDlpError>().having(
            (e) => e.kind,
            'kind',
            YtDlpErrorKind.unsupportedUrl,
          ),
        ),
      );
    });

    test('with no engine it throws as missing', () async {
      await expectLater(
        backend(FakeStarter(), engine: null).probe(request.url),
        throwsA(
          isA<YtDlpError>().having(
            (e) => e.kind,
            'kind',
            YtDlpErrorKind.engineMissing,
          ),
        ),
      );
    });

    test('probes older than six hours are swept at the next one', () async {
      final old = File('${cache.path}/old.info.json')..writeAsStringSync('{}');
      final fresh = File('${cache.path}/fresh.info.json')
        ..writeAsStringSync('{}');
      final now = DateTime.now();
      old.setLastModifiedSync(now.subtract(const Duration(hours: 7)));
      final starter = FakeStarter((s) {
        s.process.say(json);
        s.process.end(0);
      });
      await backend(starter, clock: () => now).probe(request.url);
      expect(old.existsSync(), isFalse);
      expect(fresh.existsSync(), isTrue);
    });
  });

  group('version', () {
    test('reads yt-dlp, ffmpeg and Deno', () async {
      final starter = FakeStarter((s) {
        final out = switch (s.executable) {
          final e when e == run.ytDlp => '2026.10.26',
          final e when e == run.ffmpeg =>
            'ffmpeg version 7.1-essentials_build-www.gyan.dev Copyright',
          _ => 'deno 2.9.8 (stable, release, x86_64-pc-windows-msvc)',
        };
        s.process.say(out);
        s.process.end(0);
      });
      final version = await backend(starter).version();
      expect(version.ytDlp.toString(), '2026.10.26');
      expect(version.ffmpeg, '7.1-essentials_build-www.gyan.dev');
      expect(version.jsRuntime, 'deno 2.9.8');
    });

    test('with no engine every part is unknown', () async {
      final version = await backend(FakeStarter(), engine: null).version();
      expect(version.ytDlp, isNull);
      expect(version.ffmpeg, isNull);
      expect(version.jsRuntime, isNull);
    });
  });
}

Future<void> pumpUntil(bool Function() ready) async {
  for (var i = 0; i < 100 && !ready(); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}
