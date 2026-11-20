import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_mobile/features/background/background_check.dart';
import 'package:vidhoist_mobile/features/background/background_status.dart';

const _videos = 'https://www.youtube.com/@Some/videos';

Map<String, Object?> _feed(List<String> ids) => {
  '_type': 'playlist',
  'channel': 'Some',
  'channel_id': 'UC_some',
  'entries': [
    for (final id in ids)
      {
        '_type': 'url',
        'id': id,
        'url': 'https://www.youtube.com/watch?v=$id',
        'title': 'Clip $id',
      },
  ],
};

void main() {
  late Directory dir;
  late MemoryKeyValueStore store;
  late FakeBackend backend;
  late DateTime now;
  late List<List<ChannelNews>> told;
  late List<String> versionsTold;
  late int versionAsked;
  String? released;

  BackgroundStatusFile file() =>
      BackgroundStatusFile('${dir.path}/background_check.json');

  BackgroundCheck check() => BackgroundCheck(
    peek: ChannelPeek(store: store, backend: backend),
    status: file(),
    notifyNews: (news) async => told.add(news),
    newVersion: () async {
      versionAsked++;
      return released;
    },
    notifyUpdate: (v) async => versionsTold.add(v),
    clock: () => now,
  );

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('vh_background');
    addTearDown(() => dir.delete(recursive: true));
    store = MemoryKeyValueStore();
    backend = FakeBackend();
    now = DateTime(2026, 11, 20, 8);
    told = [];
    versionsTold = [];
    versionAsked = 0;
    released = null;
    backend.listings[_videos] = _feed(['a']);
    await LocalChannelSource(
      store: store,
      backend: backend,
      enqueue: (_, _, _) {},
      clock: () => now,
    ).follow(
      'https://www.youtube.com/@Some',
      Quality.q720,
      checkIntervalMinutes: 60,
    );
  });

  test(
    'new clips are told of in one notice, and the run is written down',
    () async {
      backend.listings[_videos] = _feed(['c', 'b', 'a']);
      now = now.add(const Duration(hours: 6));
      expect(await check().run(), 2);
      expect(told.single.single.ids, ['c', 'b']);
      final status = await file().read();
      expect(status.lastRun, now);
      expect(status.lastNew, 2);
    },
  );

  /// **The guard**: the check writes nothing to the channels, so six hours
  /// on it finds the same clips while the app has not yet been opened.
  /// Without the list of what it told of, it would tell of them again at
  /// every check until then.
  test('clips already told of are not told of again', () async {
    backend.listings[_videos] = _feed(['b', 'a']);
    now = now.add(const Duration(hours: 6));
    await check().run();
    now = now.add(const Duration(hours: 6));
    expect(await check().run(), 0);
    expect(told, hasLength(1));

    backend.listings[_videos] = _feed(['c', 'b', 'a']);
    now = now.add(const Duration(hours: 6));
    expect(await check().run(), 1);
    expect(told.last.single.ids, ['c']);
  });

  test('nothing new: no notice, but the run is still written down', () async {
    now = now.add(const Duration(hours: 6));
    expect(await check().run(), 0);
    expect(told, isEmpty);
    expect((await file().read()).lastRun, now);
  });

  test(
    'an update is looked for once a day, and each version told of once',
    () async {
      released = '1.1.0';
      now = now.add(const Duration(hours: 6));
      await check().run();
      expect(versionsTold, ['1.1.0']);
      expect(versionAsked, 1);

      // Six hours on: not looked for again the same day.
      now = now.add(const Duration(hours: 6));
      await check().run();
      expect(versionAsked, 1);

      // A day on: looked for, but the same version is not told of twice.
      now = now.add(const Duration(days: 1));
      await check().run();
      expect(versionAsked, 2);
      expect(versionsTold, ['1.1.0']);

      released = '1.2.0';
      now = now.add(const Duration(days: 1));
      await check().run();
      expect(versionsTold, ['1.1.0', '1.2.0']);
    },
  );

  test('a failed update check does not stop the run', () async {
    final failing = BackgroundCheck(
      peek: ChannelPeek(store: store, backend: backend),
      status: file(),
      notifyNews: (news) async => told.add(news),
      newVersion: () => throw const NetworkException('offline'),
      notifyUpdate: (v) async => versionsTold.add(v),
      clock: () => now,
    );
    now = now.add(const Duration(hours: 6));
    await failing.run();
    expect((await file().read()).lastRun, now);
  });

  test('an unreadable status file is a fresh start', () async {
    await File('${dir.path}/background_check.json').writeAsString('{not json');
    final status = await file().read();
    expect(status.lastRun, isNull);
    expect(status.notified, isEmpty);
  });

  test('the list of what was told of keeps the newest', () async {
    final many = [
      for (var i = 0; i < BackgroundStatus.notifiedCap; i++) 'old$i',
    ];
    await file().write(BackgroundStatus(notified: many));
    backend.listings[_videos] = _feed(['new', 'a']);
    now = now.add(const Duration(hours: 6));
    await check().run();
    final kept = (await file().read()).notified;
    expect(kept, hasLength(BackgroundStatus.notifiedCap));
    expect(kept.last, 'new');
    expect(kept.first, 'old1');
  });
}
