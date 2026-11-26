import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';

const url = 'https://example.com/watch/abc123';

/// yt-dlp's work files for the video `abc123`, as a stopped download of it
/// leaves them under the app's name template.
const partials = [
  'Clip [abc123].f399.mp4.part',
  'Clip [abc123].f399.mp4.ytdl',
  'Clip [abc123].f399.mp4.part-Frag3.part',
  'Clip [abc123].f251.webm',
  'Clip [abc123].temp.mp4',
];

/// What a cancel must never touch: the same video finished earlier with
/// its subtitles, another video whose title holds the id, another video's
/// partial file, and a stretch of the same video.
final kept = [
  'Clip [abc123].mp4',
  'Clip [abc123].en.vtt',
  'Song [abc123] [x9].mp4.part',
  'Other [zzz].mp4.part',
  'Clip [abc123] ${ClipRange.fromWire('10-20')!.fileTag}.mp4.part',
];

void main() {
  late Directory dir;
  late MemoryKeyValueStore store;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('vh_cancel_');
    store = MemoryKeyValueStore();
    for (final name in kept) {
      File('${dir.path}/$name').writeAsStringSync('kept');
    }
  });
  tearDown(() => dir.delete(recursive: true));

  bool exists(String name) => File('${dir.path}/$name').existsSync();

  /// A download of [url] that writes [partials] and then runs until it is
  /// stopped.
  FakeBackend writingBackend() => FakeBackend(
    hold: true,
    scripts: {
      url: FakeScript(
        info: const {'id': 'abc123', 'title': 'Clip', 'webpage_url': url},
        events: (request) {
          for (final name in partials) {
            File('${request.folder}/$name').writeAsStringSync('part');
          }
          return [
            const BackendProgress(
              DownloadProgress(fraction: 0.3, downloadedBytes: 30, part: 1),
            ),
            BackendFinished('${request.folder}/Clip [abc123].mp4'),
          ];
        },
      ),
    },
  );

  LocalDownloadEngine engineOn(FakeBackend backend) => LocalDownloadEngine(
    backend: backend,
    folderFor: (_) => dir.path,
    pending: LocalPendingStore(store),
  );

  Future<void> started(FakeBackend backend, String id) async {
    for (var i = 0; i < 400 && !backend.isHeld(id); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(backend.isHeld(id), isTrue, reason: 'the download never started');
  }

  Future<void> gone(Iterable<String> names) async {
    for (var i = 0; i < 400 && names.any(exists); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    expect(names.where(exists), isEmpty);
  }

  void expectKept() {
    for (final name in kept) {
      expect(exists(name), isTrue, reason: '$name must stay');
    }
  }

  test('**the guard**: cancelling a download deletes its partial files and '
      'nothing else', () async {
    final backend = writingBackend();
    final engine = engineOn(backend);
    final task = engine.submit(url, Quality.best);
    await started(backend, task.id);
    expect(partials.every(exists), isTrue);

    engine.cancel(task.id);

    await gone(partials);
    expectKept();
  });

  test('**the guard**: pausing keeps the partial files to resume from, and '
      'cancelling the paused task then deletes them', () async {
    final backend = writingBackend();
    final engine = engineOn(backend);
    final task = engine.submit(url, Quality.best);
    await started(backend, task.id);

    engine.pause(task.id);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(engine.taskById(task.id)!.phase, TaskPhase.paused);
    expect(partials.where((n) => !exists(n)), isEmpty);

    engine.cancel(task.id);
    await gone(partials);
    expectKept();
  });

  test('a download paused in the last run is cleaned when cancelled, from '
      'the video id kept with it', () async {
    final first = engineOn(writingBackend());
    final task = first.submit(url, Quality.best);
    await started(first.backend as FakeBackend, task.id);
    first.pause(task.id);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await first.dispose();

    final next = engineOn(FakeBackend());
    await next.restorePending();
    expect(next.taskById(task.id)!.mediaId, 'abc123');
    next.cancel(task.id);

    await gone(partials);
    expectKept();
  });

  test('another unfinished task of the same video keeps the files', () async {
    final backend = writingBackend();
    final engine = engineOn(backend);
    final task = engine.submit(url, Quality.best);
    await started(backend, task.id);
    final again = engine.submit(url, Quality.q720);

    engine.cancel(task.id);
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(partials.where((n) => !exists(n)), isEmpty);
    engine.cancel(again.id);
  });

  test('a file the stopped process still holds is deleted once let go '
      '(Windows refuses it until then)', () async {
    final backend = _SlowToLetGo(dir);
    final engine = engineOn(backend);
    final task = engine.submit(url, Quality.best);
    await started(backend, task.id);
    expect(exists(partials.first), isTrue);

    engine.cancel(task.id);

    await gone(partials);
    // Elsewhere an open file can be deleted, so only Windows proves the
    // wait.
    if (Platform.isWindows) expect(backend.letGo, isTrue);
    expectKept();
  });

  group('which files are a task\'s', () {
    test('its work files, by the id where the name puts it', () {
      for (final name in partials) {
        expect(isTaskPartial('/d/$name', 'abc123'), isTrue, reason: name);
      }
      expect(isTaskPartial(r'C:\d\Clip [abc123].mp4.part', 'abc123'), isTrue);
    });

    test('never a finished file, another video, or a stretch', () {
      for (final name in kept) {
        expect(isTaskPartial('/d/$name', 'abc123'), isFalse, reason: name);
      }
      expect(isTaskPartial('/d/Clip [abc123].mp4.part', ''), isFalse);
    });

    test('a stretch\'s own files, and not the whole video\'s', () {
      final clip = ClipRange.fromWire('10-20');
      final tag = clip!.fileTag;
      expect(
        isTaskPartial('/d/Clip [abc123] $tag.mp4.part', 'abc123', clip: clip),
        isTrue,
      );
      expect(
        isTaskPartial('/d/Clip [abc123].mp4.part', 'abc123', clip: clip),
        isFalse,
      );
    });
  });
}

/// A backend whose process keeps its partial file open for a moment after
/// the stop returns, as a process ending on Windows does.
class _SlowToLetGo extends FakeBackend {
  _SlowToLetGo(this.dir) : super(hold: true);

  final Directory dir;
  RandomAccessFile? _open;
  bool letGo = false;

  @override
  Future<ProbeResult> probe(String link) async {
    scripts[link] = FakeScript(
      info: const {'id': 'abc123', 'title': 'Clip', 'webpage_url': url},
      events: (request) {
        for (final name in partials) {
          File('${request.folder}/$name').writeAsStringSync('part');
        }
        _open = File('${request.folder}/${partials.first}')
            .openSync(mode: FileMode.append);
        return [
          const BackendProgress(
            DownloadProgress(fraction: 0.3, downloadedBytes: 30, part: 1),
          ),
        ];
      },
    );
    return super.probe(link);
  }

  @override
  Future<void> cancel(String taskId) async {
    await super.cancel(taskId);
    final open = _open;
    _open = null;
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 700), () {
        open?.closeSync();
        letGo = true;
      }),
    );
  }
}
