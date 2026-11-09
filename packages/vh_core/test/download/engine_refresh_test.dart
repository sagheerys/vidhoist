import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';

YtDlpError error(String stderr) => ErrorClassifier.classify(stderr);

const stale =
    'ERROR: [youtube] x: Unable to extract player response; please report '
    'this issue. Confirm you are on the latest version using  yt-dlp -U';
const gone = 'ERROR: [youtube] x: Video unavailable';

/// The engine brought up to date from a failure that looks like an old
/// yt-dlp, with a gap between attempts and one attempt for a burst.
void main() {
  late FakeBackend backend;
  late MemoryKeyValueStore store;
  late DateTime now;
  late List<String> log;

  setUp(() {
    backend = FakeBackend();
    store = MemoryKeyValueStore();
    now = DateTime(2026, 11, 8, 12);
    log = [];
  });

  EngineRefresh refresh({Duration minGap = const Duration(hours: 6)}) =>
      EngineRefresh(
        backend: backend,
        store: store,
        minGap: minGap,
        now: () => now,
        onLog: log.add,
      );

  test('a failure that is not about the engine asks nothing', () async {
    expect(await refresh().afterFailure(error(gone)), isFalse);
    expect(backend.updates, 0);
    expect(await store.getInt(EngineRefresh.attemptKey), isNull);
  });

  test(
    'a stale failure updates, and says so when it brought a new build',
    () async {
      backend.updateOutcome = UpdateOutcome(
        updated: true,
        version: EngineVersion.tryParse('2026.11.07'),
      );
      expect(await refresh().afterFailure(error(stale)), isTrue);
      expect(backend.updates, 1);
      expect(
        await store.getInt(EngineRefresh.updatedAtKey),
        now.millisecondsSinceEpoch,
      );
      expect(log.last, contains('2026.11.07'));
    },
  );

  test(
    'an engine already current is noted as checked, and is no retry',
    () async {
      expect(await refresh().afterFailure(error(stale)), isFalse);
      expect(backend.updates, 1);
      expect(
        await store.getInt(EngineRefresh.updatedAtKey),
        now.millisecondsSinceEpoch,
      );
    },
  );

  test('a failed update is not noted as checked', () async {
    backend.updateOutcome = const UpdateOutcome(
      updated: false,
      error: 'no network',
    );
    expect(await refresh().afterFailure(error(stale)), isFalse);
    expect(await store.getInt(EngineRefresh.updatedAtKey), isNull);
    expect(
      await store.getInt(EngineRefresh.attemptKey),
      now.millisecondsSinceEpoch,
    );
  });

  test('attempts keep the gap, whatever the last one found', () async {
    final r = refresh();
    await r.afterFailure(error(stale));
    now = now.add(const Duration(hours: 5));
    expect(await r.afterFailure(error(stale)), isFalse);
    expect(backend.updates, 1);
    now = now.add(const Duration(hours: 2));
    await r.afterFailure(error(stale));
    expect(backend.updates, 2);
  });

  test('the gap is kept across launches, through the store', () async {
    await refresh().afterFailure(error(stale));
    await refresh().afterFailure(error(stale));
    expect(backend.updates, 1);
  });

  test('failures at the same time share one attempt', () async {
    backend.updateOutcome = const UpdateOutcome(updated: true);
    final r = refresh();
    final results = await Future.wait([
      r.afterFailure(error(stale)),
      r.afterFailure(error(stale)),
      r.afterFailure(error(stale)),
    ]);
    expect(results, [true, true, true]);
    expect(backend.updates, 1);
  });

  test('an update that throws is a failed update', () async {
    final r = EngineRefresh(
      backend: _Throws(),
      store: store,
      now: () => now,
      onLog: log.add,
    );
    expect(await r.afterFailure(error(stale)), isFalse);
    expect(log.last, contains('Bad state'));
  });

  group('recordRepair — what "repair the engine" leaves', () {
    test('a finished repair counts as an update and frees the next '
        'attempt from a failure at once', () async {
      await store.setInt(EngineRefresh.attemptKey, 1);
      await EngineRefresh.recordRepair(
        store,
        PrefsMutex(),
        const UpdateOutcome(updated: true),
        at: now,
      );
      expect(await store.getInt(EngineRefresh.attemptKey), isNull);
      expect(
        await store.getInt(EngineRefresh.updatedAtKey),
        now.millisecondsSinceEpoch,
      );

      final r = EngineRefresh(backend: FakeBackend(), store: store);
      await r.afterFailure(error(stale));
      expect(await store.getInt(EngineRefresh.attemptKey), isNotNull);
    });

    test('a repair that could not fetch leaves the update due', () async {
      await store.setInt(EngineRefresh.updatedAtKey, 1);
      await EngineRefresh.recordRepair(
        store,
        PrefsMutex(),
        const UpdateOutcome(updated: false, error: 'offline'),
      );
      expect(await store.getInt(EngineRefresh.updatedAtKey), isNull);
    });
  });
}

class _Throws extends FakeBackend {
  @override
  Future<UpdateOutcome> updateEngine({
    EngineChannel channel = EngineChannel.stable,
  }) async => throw StateError('no updater');
}
