import 'dart:convert';

import 'package:vh_core/vh_core.dart';
import 'package:test/test.dart';

const _videos = 'https://www.youtube.com/@Some/videos';

Map<String, Object?> _clip(String id, {String? title, String? live}) => {
  '_type': 'url',
  'id': id,
  'url': 'https://www.youtube.com/watch?v=$id',
  'title': title ?? 'Clip $id',
  'live_status': ?live,
};

/// A videos tab as yt-dlp lists it, newest first.
Map<String, Object?> _feed(List<Map<String, Object?>> clips) => {
  '_type': 'playlist',
  'channel': 'Some Channel',
  'channel_id': 'UC_some',
  'title': 'Some Channel - Videos',
  'entries': clips,
};

void main() {
  late MemoryKeyValueStore store;
  late FakeBackend backend;
  late List<(String, Quality, String?)> queued;
  late DateTime now;

  LocalChannelSource source() => LocalChannelSource(
    store: store,
    backend: backend,
    enqueue: (url, quality, folder) => queued.add((url, quality, folder)),
    clock: () => now,
  );

  setUp(() {
    store = MemoryKeyValueStore();
    backend = FakeBackend();
    queued = [];
    now = DateTime(2026, 11, 8, 10);
    backend.listings[_videos] = _feed([_clip('b'), _clip('a')]);
  });

  Future<ChannelSubscription> follow(
    LocalChannelSource channels, {
    String url = 'https://www.youtube.com/@Some',
    String? titleRegex,
    String? folder,
    int interval = 60,
  }) async => (await channels.follow(
    url,
    Quality.q720,
    checkIntervalMinutes: interval,
    titleRegex: titleRegex,
    folder: folder,
  ))!;

  group('following', () {
    test('what the channel has is seen, and nothing downloads', () async {
      final sub = await follow(source());
      expect(backend.listed, [_videos]);
      expect(sub.name, 'Some Channel');
      expect(sub.id, 'UC_some');
      expect(sub.seenCount, 2);
      expect(sub.quality, Quality.q720.wire);
      expect(sub.url, 'https://www.youtube.com/@Some');
      expect(queued, isEmpty);
    });

    test('the same channel twice, in any form, is refused', () async {
      final channels = source();
      await follow(channels);
      await expectLater(
        follow(channels, url: 'https://youtube.com/@Some/'),
        throwsA(isA<AlreadyFollowedException>()),
      );
      // Another link that resolves to the same channel.
      backend.listings['https://www.youtube.com/channel/UC_some/videos'] =
          _feed([_clip('b')]);
      await expectLater(
        follow(channels, url: 'https://www.youtube.com/channel/UC_some'),
        throwsA(isA<AlreadyFollowedException>()),
      );
      expect(await channels.list(), hasLength(1));
    });

    test("a clip's link follows its channel", () async {
      const clip = 'https://www.youtube.com/watch?v=b';
      backend.listings[clip] = {
        '_type': 'video',
        'id': 'b',
        'channel': 'Some Channel',
        'channel_id': 'UC_some',
        'uploader_url': 'https://www.youtube.com/@Some',
      };
      final channels = source();
      final sub = await follow(channels, url: clip);
      expect(backend.listed, [clip, _videos]);
      expect(sub.url, 'https://www.youtube.com/@Some');
      expect(sub.seenCount, 2, reason: "the channel's clips, not the one");
      await expectLater(
        follow(channels, url: clip),
        throwsA(isA<AlreadyFollowedException>()),
      );
    });

    test('a clip that names no channel is not followed', () async {
      const clip = 'https://example.com/v/1';
      backend.listings[clip] = {'_type': 'video', 'id': '1'};
      final channels = source();
      await expectLater(
        follow(channels, url: clip),
        throwsA(isA<EngineFailureException>()),
      );
      expect(await channels.list(), isEmpty);
    });

    test('a link yt-dlp cannot read is not followed', () async {
      backend.listings[_videos] = const YtDlpError(
        YtDlpErrorKind.unavailable,
        'ERROR: This channel does not exist.',
      );
      final channels = source();
      await expectLater(follow(channels), throwsA(isA<VhApiException>()));
      expect(await channels.list(), isEmpty);
    });
  });

  group('checking', () {
    test('only what is new is queued, oldest first, as chosen', () async {
      final channels = source();
      await follow(channels, folder: 'Some');
      backend.listings[_videos] = _feed([
        _clip('d'),
        _clip('c'),
        _clip('b'),
        _clip('a'),
      ]);
      now = now.add(const Duration(hours: 2));
      await channels.check();
      expect(queued, [
        ('https://www.youtube.com/watch?v=c', Quality.q720, 'Some'),
        ('https://www.youtube.com/watch?v=d', Quality.q720, 'Some'),
      ]);
      final sub = (await channels.list()).single;
      expect(sub.seenCount, 4);
      expect(sub.lastChecked, now);
      expect(sub.hasError, isFalse);

      queued.clear();
      await channels.check();
      expect(queued, isEmpty, reason: 'a second look finds nothing new');
    });

    test('a stream on the air waits until it is over', () async {
      final channels = source();
      await follow(channels);
      backend.listings[_videos] = _feed([
        _clip('live', live: 'is_live'),
        _clip('soon', live: 'is_upcoming'),
        _clip('b'),
        _clip('a'),
      ]);
      await channels.check();
      expect(queued, isEmpty);

      backend.listings[_videos] = _feed([
        _clip('live', live: 'was_live'),
        _clip('b'),
        _clip('a'),
      ]);
      await channels.check();
      expect(queued.single.$1, endsWith('v=live'));
    });

    test('the title filter, ignoring case, in Arabic too', () async {
      final channels = source();
      await follow(channels, titleRegex: 'درس|lesson');
      backend.listings[_videos] = _feed([
        _clip('x', title: 'LESSON 4'),
        _clip('y', title: 'الدرس الخامس'),
        _clip('z', title: 'A vlog'),
        _clip('b'),
        _clip('a'),
      ]);
      await channels.check();
      expect(queued.map((q) => q.$1.split('=').last), ['y', 'x']);
      // What the filter turned down is seen, not offered again.
      expect((await channels.list()).single.seenCount, 5);
    });

    test('a broken filter is named on the row and nothing is read', () async {
      final channels = source();
      final sub = await follow(channels);
      await channels.update(sub.id, titleRegex: '([unclosed');
      backend.listed.clear();
      await channels.check();
      expect(backend.listed, isEmpty);
      expect((await channels.list()).single.error, startsWith('title filter'));
    });

    test('a channel that fails is kept on the row until one works', () async {
      final channels = source();
      await follow(channels);
      backend.listings[_videos] = const YtDlpError(
        YtDlpErrorKind.unavailable,
        'ERROR: [youtube:tab] @Some: This channel does not exist.',
      );
      now = now.add(const Duration(hours: 1));
      await channels.check();
      var sub = (await channels.list()).single;
      expect(sub.error, contains('does not exist'));
      expect(sub.lastChecked, now, reason: 'not tried again at once');
      expect(await channels.due(), isEmpty);

      backend.listings[_videos] = _feed([_clip('b'), _clip('a')]);
      await channels.check();
      sub = (await channels.list()).single;
      expect(sub.hasError, isFalse);
    });

    test('**the guard**: no network says nothing, keeps the last good check '
        'and tries again in minutes', () async {
      final channels = source();
      await follow(channels);
      final good = now;
      now = now.add(const Duration(hours: 1));
      backend.listings[_videos] = const YtDlpError(
        YtDlpErrorKind.network,
        'ERROR: [youtube:tab] @Some/videos: Unable to download API page: '
        '[Errno 7] No address associated with host',
      );
      await channels.check();
      var sub = (await channels.list()).single;
      expect(sub.hasError, isFalse, reason: 'the phone woke offline');
      expect(sub.lastChecked, good);
      expect(await channels.due(), isEmpty, reason: 'not every minute');
      now = now.add(LocalChannelSource.retryDelay);
      expect(await channels.due(), ['UC_some']);

      backend.listings[_videos] = _feed([_clip('c'), _clip('b'), _clip('a')]);
      await channels.checkDue();
      sub = (await channels.list()).single;
      expect(sub.lastChecked, now);
      expect(queued.single.$1, 'https://www.youtube.com/watch?v=c');
      expect(await channels.due(), isEmpty, reason: 'a whole interval now');
    });

    test('a site asking to slow down is waited out the same way', () async {
      final channels = source();
      await follow(channels);
      now = now.add(const Duration(hours: 1));
      backend.listings[_videos] = const YtDlpError(
        YtDlpErrorKind.rateLimited,
        'ERROR: HTTP Error 429: Too Many Requests',
      );
      await channels.check();
      expect((await channels.list()).single.hasError, isFalse);
    });

    test('a retry put off is kept across runs', () async {
      await follow(source());
      now = now.add(const Duration(hours: 1));
      backend.listings[_videos] = const YtDlpError(
        YtDlpErrorKind.network,
        'ERROR: Unable to download webpage: timed out',
      );
      await source().check();
      final again = source();
      expect(await again.due(), isEmpty);
      now = now.add(LocalChannelSource.retryDelay);
      expect(await again.due(), ['UC_some']);
    });
  });

  group('when', () {
    test('a channel is due once its interval has run out', () async {
      final channels = source();
      await follow(channels, interval: 30);
      expect(await channels.due(), isEmpty);
      now = now.add(const Duration(minutes: 29));
      expect(await channels.due(), isEmpty);
      now = now.add(const Duration(minutes: 1));
      expect(await channels.due(), ['UC_some']);

      backend.listed.clear();
      await channels.checkDue();
      expect(backend.listed, [_videos]);
      expect(await channels.due(), isEmpty);
    });

    test('a paused channel is never due, and checked only by name', () async {
      final channels = source();
      final sub = await follow(channels);
      await channels.update(sub.id, enabled: false);
      now = now.add(const Duration(days: 3));
      expect(await channels.due(), isEmpty);

      backend.listed.clear();
      await channels.check();
      expect(backend.listed, isEmpty);
      await channels.check(ids: [sub.id]);
      expect(backend.listed, [_videos]);
    });
  });

  group('kept', () {
    test('across runs, with every change', () async {
      final first = source();
      final sub = await follow(first);
      await first.update(
        sub.id,
        name: 'Renamed',
        checkIntervalMinutes: 180,
        titleRegex: 'x',
        folder: 'Sub',
      );
      final again = (await source().list()).single;
      expect(again.name, 'Renamed');
      expect(again.checkIntervalMinutes, 180);
      expect(again.titleRegex, 'x');
      expect(again.folder, 'Sub');
      expect(again.seenCount, 2);

      await first.update(sub.id, clearTitleRegex: true, folder: '');
      final cleared = (await source().list()).single;
      expect(cleared.titleRegex, isNull);
      expect(cleared.folder, isNull);

      await first.unfollow([sub.id]);
      expect(await source().list(), isEmpty);
    });

    test('two changes at once on a fresh run both last', () async {
      final sub = await follow(source());
      backend.listings['https://www.youtube.com/@Other/videos'] = {
        ..._feed([_clip('o')]),
        'channel_id': 'UC_other',
      };
      // A new run reads the stored list once; two changes that each read
      // it for themselves would write over one another.
      final fresh = source();
      await Future.wait([
        fresh.update(sub.id, name: 'Renamed'),
        follow(fresh, url: 'https://www.youtube.com/@Other'),
      ]);
      final kept = await source().list();
      expect(kept.map((s) => s.name), containsAll(['Renamed', 'Some Channel']));
      expect(kept, hasLength(2));
    });

    test('unreadable text is set aside, not lost', () async {
      await store.setString(LocalChannelSource.storeKey, '{not json');
      final channels = source();
      expect(await channels.list(), isEmpty);
      await follow(channels);
      expect(
        await store.getString('${LocalChannelSource.storeKey}_unreadable'),
        '{not json',
      );
    });

    test('the seen ids stop growing at their cap, the oldest dropped', () {
      final record = ChannelRecord(
        id: 'c',
        name: 'c',
        url: 'u',
        feedUrl: 'u',
        quality: 'best',
        checkIntervalMinutes: 60,
        seen: [for (var i = 0; i < ChannelRecord.seenCap; i++) '$i'],
      )..markSeen('new');
      expect(record.seen, hasLength(ChannelRecord.seenCap));
      expect(record.seen.first, '1');
      expect(record.seen.last, 'new');
      final back = ChannelRecord.fromJson(
        jsonDecode(jsonEncode(record.toJson())),
      )!;
      expect(back.seen, record.seen);
    });
  });
}
