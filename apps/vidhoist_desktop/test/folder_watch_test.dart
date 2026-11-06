import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_core/mt_core.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/folder_watch.dart';
import 'package:vidhoist_desktop/data/folders_data.dart';
import 'package:vidhoist_desktop/data/library_data.dart';
import 'package:vidhoist_desktop/di.dart';

/// The library keeps up with the download folder by itself: a clip deleted
/// in Explorer leaves it without a button, and a file still arriving
/// (`.part`) does not rebuild it at every write.
void main() {
  late Directory root;
  late MemoryKeyValueStore store;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('vh_watch_');
    store = MemoryKeyValueStore();
  });
  tearDown(() => root.delete(recursive: true));

  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        downloadFolderProvider.overrideWith((ref) async => root.path),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  Future<void> until(bool Function() done) async {
    for (var i = 0; i < 100 && !done(); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  test('a clip deleted outside the app leaves the library', () async {
    final clip = File('${root.path}\\clip.mp4')..writeAsStringSync('media');
    await LocalHistoryStore(store).record(
      task: DownloadTask(
        inputUrl: 'https://example.com/a',
        quality: Quality.best,
      ),
      path: clip.path,
    );
    final c = container();
    await c.read(downloadFolderProvider.future);
    c.listen(folderWatchProvider, (_, _) {});
    expect(await c.read(libraryItemsProvider.future), hasLength(1));
    var items = 1;
    c.listen(libraryItemsProvider, (_, next) {
      items = next.valueOrNull?.length ?? items;
    });
    await Future<void>.delayed(const Duration(milliseconds: 200));
    clip.deleteSync();
    await until(() => items == 0);
    expect(items, 0);
  });

  test('a partial file changing does not rebuild the library', () async {
    final c = container();
    await c.read(downloadFolderProvider.future);
    c.listen(folderWatchProvider, (_, _) {});
    var builds = 0;
    c.listen(localLibraryProvider, (_, _) => builds++);
    await c.read(localLibraryProvider.future);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    builds = 0;
    final part = File('${root.path}\\clip.mp4.part');
    for (var i = 0; i < 5; i++) {
      part.writeAsStringSync('x' * i, mode: FileMode.append);
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    expect(builds, 0);
  });
}
