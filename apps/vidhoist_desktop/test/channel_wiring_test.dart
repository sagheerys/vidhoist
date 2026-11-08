import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_desktop/data/channels_data.dart';
import 'package:vidhoist_desktop/data/downloads_data.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/folders_data.dart';
import 'package:vidhoist_desktop/di.dart';

const _videos = 'https://www.youtube.com/@Some/videos';

Map<String, Object?> _feed(List<String> ids) => {
  '_type': 'playlist',
  'channel': 'Some Channel',
  'channel_id': 'UC_some',
  'entries': [
    for (final id in ids)
      {'id': id, 'url': 'https://www.youtube.com/watch?v=$id', 'title': id},
  ],
};

/// Channels on this computer: kept by the app, read through its yt-dlp,
/// and what is new downloaded like a pasted link.
void main() {
  late Directory downloads;
  late MemoryKeyValueStore store;
  late FakeBackend backend;

  setUp(() async {
    downloads = await Directory.systemTemp.createTemp('vh_ch_');
    store = MemoryKeyValueStore();
    backend = FakeBackend()..listings[_videos] = _feed(['a']);
  });
  tearDown(() => downloads.delete(recursive: true));

  ProviderContainer container({bool engine = true}) {
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        desktopFoldersProvider.overrideWithValue(_Folders(downloads.path)),
        if (engine) downloadBackendProvider.overrideWithValue(backend),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('no engine, nowhere to keep channels', () {
    expect(container(engine: false).read(channelSourceProvider), isNull);
  });

  test(
    'a new clip goes to the download queue, in the channel\'s folder',
    () async {
      final c = container();
      await c.read(downloadFolderProvider.future);
      final controller = c.read(channelsControllerProvider);
      final name = await controller.follow(
        'https://www.youtube.com/@Some',
        quality: Quality.q720,
        checkIntervalMinutes: 60,
        ownFolder: true,
      );
      expect(name, 'Some Channel');
      final engine = c.read(downloadEngineProvider)!;
      expect(engine.tasks, isEmpty, reason: 'what was there stays there');

      backend.listings[_videos] = _feed(['b', 'a']);
      final followed = (await c.read(channelsProvider.future)).subscriptions!;
      expect(followed.single.folder, 'Some Channel');
      await controller.checkNow();

      final task = engine.tasks.single;
      expect(task.inputUrl, 'https://www.youtube.com/watch?v=b');
      expect(task.quality, Quality.q720);
      expect(task.folder, 'Some Channel');
    },
  );

  test('the channels outlive the run', () async {
    final first = container();
    await first
        .read(channelsControllerProvider)
        .follow(
          'https://www.youtube.com/@Some',
          quality: Quality.best,
          checkIntervalMinutes: 60,
        );
    final again = container();
    final kept = (await again.read(channelsProvider.future)).subscriptions!;
    expect(kept.single.name, 'Some Channel');
  });
}

class _Folders extends NoFolders {
  _Folders(this.downloadsRoot);

  final String downloadsRoot;

  @override
  Future<String?> downloads() async => downloadsRoot;
}
