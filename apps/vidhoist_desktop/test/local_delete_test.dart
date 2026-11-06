import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_media/library.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/library_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/features/clip/clip_actions.dart';

import 'support/shell_harness.dart';

/// **The guard**: deleting a clip deletes its file on this computer and
/// everything kept about it. It went to the server before, and with no
/// server it did nothing while saying "deleted".
void main() {
  late Directory dir;
  setUp(() {
    dir = Directory.systemTemp.createTempSync('vidhoist_delete_');
    addTearDown(() => dir.deleteSync(recursive: true));
  });

  test(
    'the file, its record, its tag and its place in the library go',
    () async {
      const url = 'https://youtu.be/aaaaaaaaaaa';
      final file = File('${dir.path}${Platform.pathSeparator}Night Drive.mp4')
        ..writeAsBytesSync([0, 1, 2]);
      final player = FakePlayer();
      final c = ProviderContainer(
        overrides: [
          keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
          playerProvider.overrideWithValue(player),
        ],
      );
      addTearDown(c.dispose);
      await c
          .read(localHistoryStoreProvider)
          .record(
            task: DownloadTask(
              inputUrl: url,
              quality: Quality.best,
              title: 'Night',
            ),
            path: file.path,
          );
      await c
          .read(tagsIndexProvider)
          .toggleTag(url, MTConstants.favoritesSystemTag);
      final before = await c.read(libraryItemsProvider.future);
      final item = before.single;

      await c.read(clipActionsProvider).deleteFile(item);

      expect(file.existsSync(), isFalse);
      expect(await c.read(localHistoryStoreProvider).entries(), isEmpty);
      expect(await c.read(tagsIndexProvider).readAll(), isEmpty);
      expect(await c.read(libraryItemsProvider.future), isEmpty);
    },
  );

  test('a file already gone is still forgotten', () async {
    const url = 'https://youtu.be/bbbbbbbbbbb';
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        playerProvider.overrideWithValue(FakePlayer()),
      ],
    );
    addTearDown(c.dispose);
    final path = '${dir.path}${Platform.pathSeparator}gone.mp4';
    await c
        .read(localHistoryStoreProvider)
        .record(
          task: DownloadTask(
            inputUrl: url,
            quality: Quality.best,
            title: 'Gone',
          ),
          path: path,
        );
    await c
        .read(clipActionsProvider)
        .deleteFile(
          LibraryItem(canonicalUrl: url, title: 'Gone', localPath: path),
        );
    expect(await c.read(localHistoryStoreProvider).entries(), isEmpty);
  });
}
