import 'dart:async';

import 'package:vh_core/vh_core.dart';
import 'package:test/test.dart';

const yt = 'https://www.youtube.com/watch?v=aqz-KE-bpKQ';
const other = 'https://vimeo.com/76979871';

BackendProgress progress(double f) =>
    BackendProgress(DownloadProgress(fraction: f, downloadedBytes: 0, part: 1));

BackendFailed failure(String stderr) =>
    BackendFailed(ErrorClassifier.classify(stderr));

class Harness {
  Harness({
    FakeBackend? backend,
    this.maxConcurrent = 1,
    this.gate,
    bool Function()? compatible,
    List<String> Function()? subtitles,
  }) : backend = backend ?? FakeBackend() {
    engine = LocalDownloadEngine(
      backend: this.backend,
      folderFor: (task) => '/out/${task.folder ?? ''}',
      history: history,
      pending: pending,
      maxConcurrent: maxConcurrent,
      startGate: gate,
      gateRecheck: const Duration(milliseconds: 5),
      compatibleVideo: compatible,
      subtitleLanguages: subtitles,
      onCompleted: completed.add,
      sizeOf: (_) async => 1234,
    );
    engine.updates.listen(seen.add);
  }

  final FakeBackend backend;
  final int maxConcurrent;
  final bool Function()? gate;
  final store = MemoryKeyValueStore();
  late final history = LocalHistoryStore(store);
  late final pending = LocalPendingStore(store);
  late final LocalDownloadEngine engine;
  final seen = <DownloadTask>[];
  final completed = <DownloadTask>[];

  List<TaskPhase> phasesOf(String id) {
    final phases = <TaskPhase>[];
    for (final t in seen.where((t) => t.id == id)) {
      if (phases.isEmpty || phases.last != t.phase) phases.add(t.phase);
    }
    return phases;
  }

  /// Waits until the fake backend holds the download of [id] open.
  Future<void> held(String id) async {
    for (var i = 0; i < 200 && !backend.isHeld(id); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(backend.isHeld(id), isTrue, reason: '$id never started');
  }

  Future<DownloadTask> until(String id, TaskPhase phase) async {
    final now = engine.taskById(id);
    if (now?.phase == phase) return now!;
    return engine.updates
        .firstWhere((t) => t.id == id && t.phase == phase)
        .timeout(const Duration(seconds: 5));
  }
}

void main() {
  test('a download goes through each phase to the library', () async {
    final h = Harness();
    final task = h.engine.submit('look: $yt', Quality.q1080, folder: 'music');
    expect(task.inputUrl, yt);
    final done = await h.until(task.id, TaskPhase.completed);

    expect(h.phasesOf(task.id), [
      TaskPhase.queued,
      TaskPhase.preparing,
      TaskPhase.downloading,
      TaskPhase.completed,
    ]);
    expect(done.localPath, '/out/music/${task.id}.mp4');
    expect(done.title, 'Title of $yt');
    expect(done.progress, 1);
    expect(h.completed.single.id, task.id);

    final entry = (await h.history.entries()).single;
    expect(entry.path, done.localPath);
    expect(entry.item.title, 'Title of $yt');
    expect(entry.item.canonicalUrl, yt);
    expect(entry.item.sizeBytes, 1234);
    expect(entry.item.folder, 'music');
    expect(await h.pending.load(), isEmpty);
  });

  test(
    'the link is read once and the download starts from that reading',
    () async {
      final h = Harness();
      final task = h.engine.submit(yt, Quality.best);
      await h.until(task.id, TaskPhase.completed);
      expect(h.backend.probes, [yt]);
      final request = h.backend.requests.single;
      expect(request.infoJsonPath, '$yt.info.json');
      expect(request.toSpec().url, isNull);
      expect(request.toSpec().infoJsonPath, '$yt.info.json');
      expect(request.folder, '/out/');
    },
  );

  test(
    'progress is broadcast at whole percentages, with speed and time left',
    () async {
      final h = Harness(
        backend: FakeBackend(
          scripts: {
            yt: FakeScript(
              events: (r) => [
                for (final f in [0.101, 0.102, 0.109, 0.5, 0.501]) progress(f),
                const BackendProgress(
                  DownloadProgress(
                    fraction: 0.9,
                    downloadedBytes: 9,
                    part: 1,
                    speed: 2.5,
                    eta: 4,
                  ),
                ),
                const BackendPostprocessing('Merger'),
                BackendFinished('/out/a.mp4'),
              ],
            ),
          },
        ),
      );
      final task = h.engine.submit(yt, Quality.best);
      await h.until(task.id, TaskPhase.completed);
      final moving = h.seen
          .where((t) => t.id == task.id && t.phase == TaskPhase.downloading)
          .map((t) => t.progress)
          .toList();
      expect(moving, [0, 0.101, 0.5, 0.9]);
      final fast = h.seen.lastWhere((t) => t.progress == 0.9);
      expect(fast.speed, 2.5);
      expect(fast.eta, 4);
      expect(h.phasesOf(task.id), contains(TaskPhase.postprocessing));
      expect(h.engine.taskById(task.id)!.speed, isNull);
    },
  );

  test('a height a site cannot meet is retried once at best', () async {
    final h = Harness(
      backend: FakeBackend(
        scripts: {
          other: FakeScript(
            events: (r) => r.quality == Quality.best
                ? [BackendFinished('/out/v.mp4')]
                : [
                    failure(
                      'ERROR: [vimeo] x: Requested format is not available',
                    ),
                  ],
          ),
        },
      ),
    );
    final task = h.engine.submit(other, Quality.q720);
    final done = await h.until(task.id, TaskPhase.completed);
    expect(h.backend.requests.map((r) => r.quality), [
      Quality.q720,
      Quality.best,
    ]);
    expect(done.quality, Quality.q720);
  });

  test('best that still fails is not retried again', () async {
    final h = Harness(
      backend: FakeBackend(
        scripts: {
          other: FakeScript(
            events: (_) => [
              failure('ERROR: Requested format is not available'),
            ],
          ),
        },
      ),
    );
    final task = h.engine.submit(other, Quality.best);
    final failed = await h.until(task.id, TaskPhase.failed);
    expect(h.backend.requests, hasLength(1));
    expect(
      (failed.error! as EngineFailureException).kind,
      YtDlpErrorKind.formatUnavailable,
    );
  });

  group('failures are classified in the core terms', () {
    final cases = <String, Matcher>{
      'ERROR: [youtube] x: Unable to download webpage: <urlopen error '
              'getaddrinfo failed>':
          isA<NetworkException>(),
      "ERROR: [youtube] x: Sign in to confirm you're not a bot":
          isA<PlatformBlockedException>(),
      'ERROR: [TikTok] 1: Your IP address is blocked from accessing this post':
          isA<EngineFailureException>().having(
            (e) => e.kind,
            'kind',
            YtDlpErrorKind.geoBlocked,
          ),
    };
    for (final MapEntry(key: stderr, value: matcher) in cases.entries) {
      test(stderr, () async {
        final h = Harness(
          backend: FakeBackend(
            scripts: {
              yt: FakeScript(events: (_) => [failure(stderr)]),
            },
          ),
        );
        final task = h.engine.submit(yt, Quality.best);
        final failed = await h.until(task.id, TaskPhase.failed);
        expect(failed.error, matcher);
        expect(failed.error!.detail, stderr);
        expect(await h.history.entries(), isEmpty);
        expect(await h.pending.load(), isEmpty);
      });
    }

    test('a probe that fails fails the task', () async {
      final h = Harness(
        backend: FakeBackend(
          scripts: {
            yt: FakeScript(
              probeError: ErrorClassifier.classify(
                'ERROR: [youtube] x: This video is unavailable',
              ),
            ),
          },
        ),
      );
      final task = h.engine.submit(yt, Quality.best);
      final failed = await h.until(task.id, TaskPhase.failed);
      expect(
        (failed.error! as EngineFailureException).kind,
        YtDlpErrorKind.unavailable,
      );
      expect(h.backend.requests, isEmpty);
    });

    test('anything else thrown is a local failure', () async {
      final h = Harness(
        backend: FakeBackend(
          scripts: {yt: FakeScript(probeError: StateError('disk'))},
        ),
      );
      final task = h.engine.submit(yt, Quality.best);
      final failed = await h.until(task.id, TaskPhase.failed);
      expect(failed.error, isA<LocalFailureException>());
    });

    test('a download that ends with no result has failed', () async {
      final h = Harness(
        backend: FakeBackend(scripts: {yt: FakeScript(events: (_) => [])}),
      );
      final task = h.engine.submit(yt, Quality.best);
      final failed = await h.until(task.id, TaskPhase.failed);
      expect(failed.error, isA<LocalFailureException>());
    });
  });

  group('stopping', () {
    test('cancelling a waiting task never starts it', () async {
      final h = Harness(backend: FakeBackend(hold: true));
      final first = h.engine.submit(yt, Quality.best);
      final second = h.engine.submit(other, Quality.best);
      await h.held(first.id);
      h.engine.cancel(second.id);
      expect(h.engine.taskById(second.id)!.phase, TaskPhase.cancelled);
      h.backend.release(first.id);
      await h.until(first.id, TaskPhase.completed);
      expect(h.backend.probes, [yt]);
      expect((await h.pending.load()).map((t) => t.id), isEmpty);
    });

    test(
      'cancelling a running task stops its process and records nothing',
      () async {
        final h = Harness(backend: FakeBackend(hold: true));
        final task = h.engine.submit(yt, Quality.best);
        await h.held(task.id);
        expect((await h.pending.load()).single.id, task.id);
        h.engine.cancel(task.id);
        await pumpEventQueue();
        expect(h.backend.cancelled, [task.id]);
        expect(h.engine.taskById(task.id)!.phase, TaskPhase.cancelled);
        expect(await h.history.entries(), isEmpty);
        expect(await h.pending.load(), isEmpty);
        expect(h.engine.hasActiveWork, isFalse);
      },
    );

    test('pause keeps the reading and resume continues from it', () async {
      final h = Harness(backend: FakeBackend(hold: true));
      final task = h.engine.submit(yt, Quality.best);
      await h.held(task.id);
      h.engine.pause(task.id);
      await pumpEventQueue();
      expect(h.engine.taskById(task.id)!.phase, TaskPhase.paused);
      expect(h.backend.cancelled, [task.id]);
      expect((await h.pending.load()).single.phase, TaskPhase.paused);
      expect(h.engine.hasActiveWork, isTrue);

      h.engine.pause(task.id);
      h.backend
        ..hold = false
        ..cancelled.clear();
      h.engine.resume(task.id);
      await h.until(task.id, TaskPhase.completed);
      expect(h.backend.probes, [yt]);
      expect(h.backend.requests, hasLength(2));
      expect(h.backend.requests.last.infoJsonPath, '$yt.info.json');
    });

    test('a waiting task can be paused and resumed too', () async {
      final h = Harness(backend: FakeBackend(hold: true));
      final first = h.engine.submit(yt, Quality.best);
      final second = h.engine.submit(other, Quality.best);
      h.engine.pause(second.id);
      expect(h.engine.taskById(second.id)!.phase, TaskPhase.paused);
      h.engine.resume(second.id);
      h.engine.resume(first.id);
      h.backend.hold = false;
      h.backend.release(first.id);
      await h.until(second.id, TaskPhase.completed);
    });

    test('cancelling a paused task ends it', () async {
      final h = Harness(backend: FakeBackend(hold: true));
      final task = h.engine.submit(yt, Quality.best);
      await h.held(task.id);
      h.engine.pause(task.id);
      await pumpEventQueue();
      h.engine.cancel(task.id);
      expect(h.engine.taskById(task.id)!.phase, TaskPhase.cancelled);
      await pumpEventQueue();
      expect(await h.pending.load(), isEmpty);
    });

    test('stopping something finished or unknown does nothing', () async {
      final h = Harness();
      final task = h.engine.submit(yt, Quality.best);
      await h.until(task.id, TaskPhase.completed);
      h.engine
        ..cancel(task.id)
        ..pause(task.id)
        ..resume(task.id)
        ..cancel('nobody');
      expect(h.engine.taskById(task.id)!.phase, TaskPhase.completed);
    });
  });

  group('the queue', () {
    test('one at a time by default, a single before a batch', () async {
      final h = Harness(backend: FakeBackend(hold: true));
      final first = h.engine.submit(yt, Quality.best);
      final batch = h.engine.submit(
        '$other/1',
        Quality.best,
        isBatchMember: true,
      );
      final single = h.engine.submit('$other/2', Quality.best);
      await h.held(first.id);
      expect(h.engine.taskById(batch.id)!.phase, TaskPhase.queued);
      h.backend.hold = false;
      h.backend.release(first.id);
      await h.until(batch.id, TaskPhase.completed);
      expect(h.backend.probes, [yt, '$other/2', '$other/1']);
      expect(h.engine.taskById(single.id)!.phase, TaskPhase.completed);
    });

    test('maxConcurrent runs that many at once', () async {
      final h = Harness(backend: FakeBackend(hold: true), maxConcurrent: 2);
      final a = h.engine.submit(yt, Quality.best);
      final b = h.engine.submit(other, Quality.best);
      await h.held(a.id);
      await h.held(b.id);
    });

    test('a site of sound alone is fetched as audio', () {
      final h = Harness(backend: FakeBackend(hold: true));
      final task = h.engine.submit(
        'https://soundcloud.com/the80m/the-following',
        Quality.q1080,
      );
      expect(task.quality, Quality.audio);
    });

    test('a finished task can be forgotten, a running one cannot', () async {
      final h = Harness(backend: FakeBackend(hold: true));
      final task = h.engine.submit(yt, Quality.best);
      await h.held(task.id);
      h.engine.forget(task.id);
      expect(h.engine.taskById(task.id), isNotNull);
      h.backend.release(task.id);
      await h.until(task.id, TaskPhase.completed);
      h.engine.forget(task.id);
      expect(h.engine.tasks, isEmpty);
    });
  });

  group('the start gate', () {
    test('waits for the network, then goes on', () async {
      var open = false;
      final h = Harness(gate: () => open);
      final task = h.engine.submit(yt, Quality.best);
      await h.until(task.id, TaskPhase.waitingForNetwork);
      expect(h.backend.requests, isEmpty);
      open = true;
      await h.until(task.id, TaskPhase.completed);
    });

    test('a cancel ends the wait at once', () async {
      final h = Harness(gate: () => false);
      final task = h.engine.submit(yt, Quality.best);
      await h.until(task.id, TaskPhase.waitingForNetwork);
      h.engine.cancel(task.id);
      await pumpEventQueue();
      expect(h.engine.taskById(task.id)!.phase, TaskPhase.cancelled);
      expect(h.backend.requests, isEmpty);
    });
  });

  test('settings are read when each download starts', () async {
    var compatible = false;
    final h = Harness(compatible: () => compatible, subtitles: () => ['ar.*']);
    await h.until(h.engine.submit(yt, Quality.best).id, TaskPhase.completed);
    compatible = true;
    await h.until(h.engine.submit(other, Quality.best).id, TaskPhase.completed);
    expect(h.backend.requests.map((r) => r.compatible), [false, true]);
    expect(h.backend.requests.first.subtitleLanguages, ['ar.*']);
  });

  group('across launches', () {
    test('what was left is queued again, a paused one stays paused', () async {
      final store = MemoryKeyValueStore();
      final saved = LocalPendingStore(store);
      await saved.put(
        DownloadTask(id: 'a', inputUrl: yt, quality: Quality.q720),
      );
      await saved.put(
        DownloadTask(
          id: 'b',
          inputUrl: other,
          quality: Quality.best,
          phase: TaskPhase.paused,
        ),
      );
      final backend = FakeBackend();
      final engine = LocalDownloadEngine(
        backend: backend,
        folderFor: (_) => '/out',
        pending: saved,
      );
      expect(await engine.restorePending(), 2);
      await engine.updates
          .firstWhere((t) => t.id == 'a' && t.phase == TaskPhase.completed)
          .timeout(const Duration(seconds: 5));
      expect(engine.taskById('b')!.phase, TaskPhase.paused);
      expect(backend.requests.single.quality, Quality.q720);
      expect((await saved.load()).single.id, 'b');
      expect(await engine.restorePending(), 1);
      expect(engine.tasks, hasLength(2));
    });

    test('dispose stops the running download and keeps its record', () async {
      final h = Harness(backend: FakeBackend(hold: true));
      final task = h.engine.submit(yt, Quality.best);
      await h.held(task.id);
      await h.engine.dispose();
      expect(h.backend.cancelled, [task.id]);
      expect((await h.pending.load()).single.id, task.id);
    });
  });
}
