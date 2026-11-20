import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';

const _videos = 'https://www.youtube.com/@Some/videos';
const _other = 'https://www.youtube.com/@Other/videos';

Map<String, Object?> _clip(String id, {String? title, String? live}) => {
  '_type': 'url',
  'id': id,
  'url': 'https://www.youtube.com/watch?v=$id',
  'title': title ?? 'Clip $id',
  'live_status': ?live,
};

Map<String, Object?> _feed(String name, List<Map<String, Object?>> clips) => {
  '_type': 'playlist',
  'channel': name,
  'channel_id': 'UC_$name',
  'title': '$name - Videos',
  'entries': clips,
};

void main() {
  late MemoryKeyValueStore store;
  late FakeBackend backend;
  late DateTime now;

  LocalChannelSource source() => LocalChannelSource(
    store: store,
    backend: backend,
    enqueue: (_, _, _) {},
    clock: () => now,
  );

  ChannelPeek peek() => ChannelPeek(store: store, backend: backend);

  setUp(() async {
    store = MemoryKeyValueStore();
    backend = FakeBackend();
    now = DateTime(2026, 11, 20, 10);
    backend.listings[_videos] = _feed('Some', [_clip('b'), _clip('a')]);
    await source().follow(
      'https://www.youtube.com/@Some',
      Quality.q720,
      checkIntervalMinutes: 60,
    );
  });

  test('a due channel with new clips is reported, newest first', () async {
    backend.listings[_videos] = _feed('Some', [
      _clip('d', title: 'Fourth'),
      _clip('c', title: 'Third'),
      _clip('b'),
      _clip('a'),
    ]);
    now = now.add(const Duration(hours: 2));
    final news = await peek().due(now);
    expect(news, hasLength(1));
    expect(news.single.channel, 'Some');
    expect(news.single.ids, ['d', 'c']);
    expect(news.single.titles, ['Fourth', 'Third']);
  });

  /// **The guard**: the app may open mid-peek and run its own check on the
  /// same store. A write here would race it and could lose the seen ids
  /// that stop a back catalogue downloading.
  test(
    'it writes nothing, so the app still finds and downloads them',
    () async {
      final before = await store.getString(LocalChannelSource.storeKey);
      backend.listings[_videos] = _feed('Some', [_clip('c'), _clip('b')]);
      now = now.add(const Duration(hours: 2));
      await peek().due(now);
      expect(await store.getString(LocalChannelSource.storeKey), before);

      final queued = <String>[];
      await LocalChannelSource(
        store: store,
        backend: backend,
        enqueue: (url, _, _) => queued.add(url),
        clock: () => now,
      ).checkDue();
      expect(queued, ['https://www.youtube.com/watch?v=c']);
    },
  );

  test('a channel not yet due is not read at all', () async {
    backend.listed.clear();
    now = now.add(const Duration(minutes: 20));
    expect(await peek().due(now), isEmpty);
    expect(backend.listed, isEmpty);
  });

  test(
    'nothing new, a stream on the air, and a paused channel say nothing',
    () async {
      backend.listings[_videos] = _feed('Some', [
        _clip('live', live: 'is_live'),
        _clip('b'),
      ]);
      now = now.add(const Duration(hours: 2));
      expect(await peek().due(now), isEmpty);

      final channels = source();
      final sub = (await channels.list()).single;
      await channels.update(sub.id, enabled: false);
      backend.listings[_videos] = _feed('Some', [_clip('c'), _clip('b')]);
      expect(await peek().due(now), isEmpty);
    },
  );

  test(
    "the title filter is the download's: what it would skip is not news",
    () async {
      final channels = source();
      final sub = (await channels.list()).single;
      await channels.update(sub.id, titleRegex: 'episode');
      backend.listings[_videos] = _feed('Some', [
        _clip('d', title: 'Episode 4'),
        _clip('c', title: 'A short'),
        _clip('b'),
      ]);
      now = now.add(const Duration(hours: 2));
      expect((await peek().due(now)).single.ids, ['d']);
    },
  );

  test('one channel that fails does not hide the others', () async {
    backend.listings[_other] = _feed('Other', [_clip('x')]);
    await source().follow(
      'https://www.youtube.com/@Other',
      Quality.q720,
      checkIntervalMinutes: 60,
    );
    backend.listings[_videos] = const NetworkException('offline');
    backend.listings[_other] = _feed('Other', [_clip('y'), _clip('x')]);
    now = now.add(const Duration(hours: 2));
    final news = await peek().due(now);
    expect(news.single.channel, 'Other');
    expect(news.single.ids, ['y']);
  });
}
