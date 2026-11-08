import 'dart:async';

import 'package:vh_core/vh_core.dart';
import 'package:test/test.dart';

const _videos = 'https://www.youtube.com/@Some/videos';

Map<String, Object?> _feed(List<String> ids) => {
  '_type': 'playlist',
  'channel': 'Some',
  'channel_id': 'UC_some',
  'entries': [
    for (final id in ids)
      {'id': id, 'url': 'https://www.youtube.com/watch?v=$id'},
  ],
};

void main() {
  late FakeBackend backend;
  late List<String> queued;
  late DateTime now;
  late LocalChannelSource source;

  setUp(() async {
    backend = FakeBackend()..listings[_videos] = _feed(['a']);
    queued = [];
    now = DateTime(2026, 11, 8, 10);
    source = LocalChannelSource(
      store: MemoryKeyValueStore(),
      backend: backend,
      enqueue: (url, _, _) => queued.add(url),
      clock: () => now,
    );
    await source.follow(
      'https://www.youtube.com/@Some',
      Quality.best,
      checkIntervalMinutes: 30,
    );
    backend.listed.clear();
  });

  test('a tick checks only what is due, and says so', () async {
    var checked = 0;
    final ticker = ChannelTicker(source: source, onChecked: () => checked++);

    await ticker.tick();
    expect(backend.listed, isEmpty, reason: 'followed just now');
    expect(checked, 0);

    now = now.add(const Duration(minutes: 30));
    backend.listings[_videos] = _feed(['b', 'a']);
    await ticker.tick();
    expect(backend.listed, [_videos]);
    expect(queued, ['https://www.youtube.com/watch?v=b']);
    expect(checked, 1);
  });

  test('a tick during a slow check does nothing', () async {
    now = now.add(const Duration(hours: 1));
    final gate = Completer<void>();
    final slow = _SlowBackend(backend, gate.future);
    final ticker = ChannelTicker(
      source: LocalChannelSource(
        store: MemoryKeyValueStore(),
        backend: slow,
        enqueue: (_, _, _) {},
        clock: () => now,
      ),
    );
    await ticker.source.follow(
      'https://www.youtube.com/@Some',
      Quality.best,
      checkIntervalMinutes: 30,
    );
    now = now.add(const Duration(hours: 1));
    slow
      ..lists = 0
      ..hold = true;
    final first = ticker.tick();
    await Future<void>.delayed(Duration.zero);
    await ticker.tick();
    gate.complete();
    await first;
    expect(slow.lists, 1);
  });

  test('a failure is reported, and the next tick runs', () async {
    final errors = <Object>[];
    final ticker = ChannelTicker(source: source, onError: errors.add);
    now = now.add(const Duration(hours: 1));
    // The check itself keeps its error on the row; only a fault outside it
    // reaches here, such as the store refusing to write.
    final failing = ChannelTicker(
      source: LocalChannelSource(
        store: _BrokenStore(),
        backend: backend,
        enqueue: (_, _, _) {},
        clock: () => now,
      ),
      onError: errors.add,
    );
    await failing.tick();
    expect(errors, hasLength(1));
    await ticker.tick();
    expect(backend.listed, [_videos]);
  });

  test(
    'started, it waits, then ticks on its own; stopped, it does not',
    () async {
      now = now.add(const Duration(hours: 1));
      final ticker = ChannelTicker(
        source: source,
        first: const Duration(milliseconds: 10),
        every: const Duration(hours: 1),
      )..start();
      expect(backend.listed, isEmpty);
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(backend.listed, [_videos]);

      ticker.stop();
      now = now.add(const Duration(hours: 1));
      ticker
        ..stop()
        ..start()
        ..stop();
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(backend.listed, [
        _videos,
      ], reason: 'stopped before its first tick');
    },
  );
}

/// Lists through [inner] once [gate] opens, counting the listings.
class _SlowBackend implements DownloadBackend {
  _SlowBackend(this.inner, this.gate);

  final FakeBackend inner;
  final Future<void> gate;
  int lists = 0;
  bool hold = false;

  @override
  Future<InfoJson> list(String url, {int? limit}) async {
    lists++;
    if (hold) await gate;
    return inner.list(url, limit: limit);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// A store that cannot be read.
class _BrokenStore implements KeyValueStore {
  @override
  Future<Object?> get(String key) => Future.error(StateError('disk gone'));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
