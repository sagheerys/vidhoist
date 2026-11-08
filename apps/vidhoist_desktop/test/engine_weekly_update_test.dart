import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_desktop/data/downloads_data.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/engine_fetch_data.dart';
import 'package:vidhoist_desktop/di.dart';

/// yt-dlp brought up to date once a week at start, as the phone does,
/// while nothing is downloading; the button's update counts as a check.
void main() {
  late MemoryKeyValueStore store;
  late FakeBackend backend;

  setUp(() {
    store = MemoryKeyValueStore();
    backend = FakeBackend();
  });

  ProviderContainer container({
    LocalDownloadEngine? engine,
    bool withBackend = true,
  }) {
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        downloadBackendProvider.overrideWithValue(withBackend ? backend : null),
        downloadEngineProvider.overrideWithValue(engine),
        engineUpdateDelayProvider.overrideWithValue(Duration.zero),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  Future<void> checked(DateTime at) =>
      store.setInt(EngineRefresh.updatedAtKey, at.millisecondsSinceEpoch);

  test('never checked: yt-dlp is updated at start and the date kept', () async {
    final c = container();
    await c.read(engineWeeklyUpdateProvider.future);
    expect(backend.updates, 1);
    expect(await store.getInt(EngineRefresh.updatedAtKey), isNotNull);
  });

  test('checked this week: left alone', () async {
    await checked(DateTime.now().subtract(const Duration(days: 6)));
    final c = container();
    await c.read(engineWeeklyUpdateProvider.future);
    expect(backend.updates, 0);
  });

  test('checked eight days ago: updated', () async {
    await checked(DateTime.now().subtract(const Duration(days: 8)));
    final c = container();
    await c.read(engineWeeklyUpdateProvider.future);
    expect(backend.updates, 1);
  });

  test('a download under way: left to the next start', () async {
    final held = FakeBackend(hold: true);
    final engine = LocalDownloadEngine(backend: held, folderFor: (_) => '/o');
    addTearDown(engine.dispose);
    engine.submit('https://www.youtube.com/watch?v=aqz-KE-bpKQ', Quality.best);
    final c = container(engine: engine);
    await c.read(engineWeeklyUpdateProvider.future);
    expect(backend.updates, 0);
    expect(await store.getInt(EngineRefresh.updatedAtKey), isNull);
  });

  test('a failed update leaves the date alone, for the next start', () async {
    backend.updateOutcome = const UpdateOutcome(
      updated: false,
      error: 'no network',
    );
    final c = container();
    await c.read(engineWeeklyUpdateProvider.future);
    expect(backend.updates, 1);
    expect(await store.getInt(EngineRefresh.updatedAtKey), isNull);
  });

  test('no backend: nothing to update', () async {
    final c = container(withBackend: false);
    await c.read(engineWeeklyUpdateProvider.future);
    expect(backend.updates, 0);
  });

  test("the button's update counts as the week's check", () async {
    final c = container();
    await c.read(engineUpdateProvider.notifier).update();
    expect(await store.getInt(EngineRefresh.updatedAtKey), isNotNull);
    expect(backend.updates, 1);
  });
}
