import 'package:vh_core/vh_core.dart';
import 'package:test/test.dart';

const _videos = 'https://www.youtube.com/@Some/videos';

Map<String, Object?> _clip(String id, {String? live}) => {
  '_type': 'url',
  'id': id,
  'url': 'https://www.youtube.com/watch?v=$id',
  'title': 'Clip $id',
  'duration': 61,
  'live_status': ?live,
  'thumbnails': [
    {'url': 'https://img.test/$id', 'width': 720, 'height': 404},
  ],
};

Map<String, Object?> _feed(List<Map<String, Object?>> clips, {String? pic}) => {
  '_type': 'playlist',
  'channel': 'Some Channel',
  'channel_id': 'UC_some',
  'channel_follower_count': 42000,
  'thumbnails': [
    if (pic != null) {'url': pic, 'width': 900, 'height': 900},
    {'url': 'https://img.test/banner', 'width': 1060, 'height': 175},
  ],
  'entries': clips,
};

/// **What a channel looks like** on its row: its picture, its banner and
/// its newest clips, kept from each listing so the page has something to
/// show before and between checks.
void main() {
  late MemoryKeyValueStore store;
  late FakeBackend backend;

  LocalChannelSource source() =>
      LocalChannelSource(store: store, backend: backend, enqueue: (_, _, _) {});

  setUp(() {
    store = MemoryKeyValueStore();
    backend = FakeBackend();
    backend.listings[_videos] = _feed([
      _clip('live', live: 'is_upcoming'),
      _clip('b'),
      _clip('a'),
    ], pic: 'https://img.test/avatar');
  });

  Future<ChannelSubscription> follow(LocalChannelSource channels) async =>
      (await channels.follow(
        'https://www.youtube.com/@Some',
        Quality.q720,
        checkIntervalMinutes: 60,
      ))!;

  test('following keeps its picture and its newest clips', () async {
    final sub = await follow(source());
    expect(sub.avatarUrl, 'https://img.test/avatar');
    expect(sub.bannerUrl, 'https://img.test/banner');
    expect(sub.followers, 42000);
    expect(
      [for (final c in sub.recent) c.id],
      ['b', 'a'],
      reason: 'a stream not begun has nothing to show yet',
    );
    final b = sub.recent.first;
    expect(b.title, 'Clip b');
    expect(b.thumbnail, 'https://img.test/b');
    expect(b.duration, const Duration(seconds: 61));
  });

  test('a check brings the newest; a picture left out stays', () async {
    final channels = source();
    await follow(channels);
    backend.listings[_videos] = _feed([_clip('c'), _clip('b'), _clip('a')]);
    await channels.check();
    final sub = (await channels.list()).single;
    expect([for (final c in sub.recent) c.id], ['c', 'b', 'a']);
    expect(sub.avatarUrl, 'https://img.test/avatar');
  });

  test('a failed check keeps what was shown', () async {
    final channels = source();
    await follow(channels);
    backend.listings[_videos] = const YtDlpError(
      YtDlpErrorKind.unavailable,
      'ERROR: This channel does not exist.',
    );
    await channels.check();
    final sub = (await channels.list()).single;
    expect(sub.hasError, isTrue);
    expect([for (final c in sub.recent) c.id], ['b', 'a']);
  });

  test('at most a row of them, and all of it across runs', () async {
    backend.listings[_videos] = _feed([
      for (var i = 20; i > 0; i--) _clip('v$i'),
    ], pic: 'https://img.test/avatar');
    await follow(source());
    final again = (await source().list()).single;
    expect(again.recent, hasLength(ChannelRecord.recentCap));
    expect(again.recent.first.id, 'v20');
    expect(again.recent.first.thumbnail, 'https://img.test/v20');
    expect(again.recent.first.duration, const Duration(seconds: 61));
    expect(again.avatarUrl, 'https://img.test/avatar');
    expect(again.followers, 42000);
  });

  test('a channel kept before pictures reads as having none', () async {
    await store.setString(
      LocalChannelSource.storeKey,
      '[{"id":"UC_old","url":"https://www.youtube.com/@Old",'
      '"feed_url":"https://www.youtube.com/@Old/videos","seen":["x"]}]',
    );
    final sub = (await source().list()).single;
    expect(sub.avatarUrl, isNull);
    expect(sub.recent, isEmpty);
    expect(sub.seenCount, 1);
  });
}
