import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vidhoist_desktop/data/clip_delete.dart';
import 'package:vidhoist_desktop/data/downloads_data.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/library_data.dart';
import 'package:vidhoist_desktop/data/lists_data.dart';
import 'package:vidhoist_desktop/data/pc_link_data.dart';
import 'package:vidhoist_desktop/data/pc_link_host.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/features/clip/clip_actions.dart';

import 'support/shell_harness.dart';

/// What a paired phone may do to this computer's clips: see its saved
/// lists, and delete one clip **only where the owner allowed it, and only
/// to the Recycle Bin**.
void main() {
  const url = 'https://youtu.be/aaaaaaaaaaa';
  late Directory dir;
  late File file;
  late ProviderContainer c;
  late DesktopPcHost host;
  late List<String> recycled;
  late Recycled answer;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('vidhoist_pc_delete_');
    addTearDown(() => dir.deleteSync(recursive: true));
    file = File('${dir.path}${Platform.pathSeparator}Night.mp4')
      ..writeAsBytesSync([0, 1, 2]);
    recycled = [];
    answer = Recycled.done;
    c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        playerProvider.overrideWithValue(FakePlayer()),
        downloadEngineProvider.overrideWithValue(null),
        recycleFileProvider.overrideWithValue((path) {
          recycled.add(path);
          if (answer == Recycled.done) File(path).deleteSync();
          return answer;
        }),
      ],
    );
    addTearDown(c.dispose);
    await c
        .read(localHistoryStoreProvider)
        .record(
          task: DownloadTask(inputUrl: url, quality: Quality.best, title: 'N'),
          path: file.path,
        );
    host = c.read(
      Provider((ref) => DesktopPcHost(ref, name: 'PC', version: '1')),
    );
    // The switch reads its saved value once; let it before changing it.
    c.read(pcLinkDeleteProvider);
    await Future<void>.delayed(Duration.zero);
  });

  Future<LibraryItem> clip() async =>
      (await c.read(libraryItemsProvider.future)).single;

  test('**the guard**: off until the owner turns it on, and then '
      'only to the Recycle Bin', () async {
    final id = pcItemId(await clip());
    expect(host.status().canDelete, isFalse);
    expect(await host.delete(id), PcDeleteOutcome.notAllowed);
    expect(file.existsSync(), isTrue);
    expect(recycled, isEmpty);

    await c.read(pcLinkDeleteProvider.notifier).set(true);
    expect(host.status().canDelete, isTrue);
    expect(await host.delete('not-an-id'), PcDeleteOutcome.missing);
    expect(await host.delete(id), PcDeleteOutcome.deleted);
    expect(recycled, [file.path], reason: 'through the bin, not a delete');
    expect(await c.read(libraryItemsProvider.future), isEmpty);
  });

  test('a drive with no Recycle Bin: the phone deletes nothing, the owner '
      'here still can', () async {
    await c.read(pcLinkDeleteProvider.notifier).set(true);
    answer = Recycled.noBin;
    final item = await clip();
    expect(await host.delete(pcItemId(item)), PcDeleteOutcome.noRecycleBin);
    expect(file.existsSync(), isTrue);
    expect(await c.read(libraryItemsProvider.future), hasLength(1));

    await c.read(clipActionsProvider).deleteFile(item);
    expect(file.existsSync(), isFalse);
  });

  test('a file Windows will not let go stays, and its record too', () async {
    await c.read(pcLinkDeleteProvider.notifier).set(true);
    answer = Recycled.refused;
    expect(await host.delete(pcItemId(await clip())), PcDeleteOutcome.failed);
    expect(file.existsSync(), isTrue);
    expect(await c.read(libraryItemsProvider.future), hasLength(1));
  });

  test('the permission is not carried by a backup', () {
    expect(pcLinkDeviceOnlyKeys, contains(pcLinkDeleteKey));
  });

  test('the saved lists: only the clips that are files here, in order, '
      'and none without one', () async {
    final store = c.read(playlistsStoreProvider);
    final evening = await store.create(
      'Evening',
      items: const [
        PlaylistEntry(canonicalUrl: 'https://youtu.be/gone'),
        PlaylistEntry(canonicalUrl: url),
      ],
    );
    await store.create(
      'Empty here',
      items: const [PlaylistEntry(canonicalUrl: 'https://youtu.be/elsewhere')],
    );
    c.invalidate(playlistsProvider);
    final lists = await host.lists();
    expect([for (final l in lists) (l.name, l.count)], [('Evening', 1)]);
    expect(lists.single.items, isEmpty);
    final one = await host.list(evening.id);
    expect(one!.items.single.id, pcItemId(await clip()));
    expect(await host.list('nope'), isNull);
  });
}
