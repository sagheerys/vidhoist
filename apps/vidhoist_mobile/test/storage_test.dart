import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/storage/media_folder_rename.dart';
import 'package:vidhoist_mobile/features/storage/phone_volumes.dart';

/// Where downloads go (plan item R4) and the folder's `VidHoist` spelling.
void main() {
  const card = PhoneVolume(
    id: '1A2B-3C4D',
    path: '/storage/1A2B-3C4D',
    label: 'SD card',
  );

  group('PhoneVolume', () {
    test('read from the channel, a nameless card named by its id', () {
      expect(
        PhoneVolume.fromMap({
          'id': '1A2B-3C4D',
          'path': '/storage/1A2B-3C4D',
          'label': 'SD card',
        }),
        card,
      );
      expect(
        PhoneVolume.fromMap({'id': 'X', 'path': '/storage/X'})!.label,
        'X',
      );
    });

    test('a malformed entry is skipped, not fatal', () {
      expect(PhoneVolume.fromMap(null), isNull);
      expect(PhoneVolume.fromMap({'id': '', 'path': '/p'}), isNull);
      expect(PhoneVolume.fromMap({'id': 'X'}), isNull);
      expect(PhoneVolume.fromMap('X'), isNull);
    });

    test('the card\'s folder is named as the phone\'s', () {
      expect(card.mediaDir, '/storage/1A2B-3C4D/Download/VidHoist');
    });
  });

  group('downloadDirFor and libraryDirsFor', () {
    test('the chosen card while it is in, the phone otherwise', () {
      expect(downloadDirFor(null, const [card]), phoneMediaDir);
      expect(downloadDirFor(card.id, const [card]), card.mediaDir);
      expect(downloadDirFor(card.id, const []), phoneMediaDir);
      expect(downloadDirFor('other', const [card]), phoneMediaDir);
    });

    test('the library reads the phone first, then every card in', () {
      expect(libraryDirsFor(const []), [phoneMediaDir]);
      expect(libraryDirsFor(const [card]), [phoneMediaDir, card.mediaDir]);
    });
  });

  group('rewriteStoredPaths — the data that hangs on a path', () {
    const old = '/storage/emulated/0/Download/Vidhoist';

    test('JSON values, string lists and keys say VidHoist after, and what '
        'changed is counted', () async {
      final store = MemoryKeyValueStore();
      await store.setString(
        'offline_index',
        jsonEncode({'https://youtu.be/a': '$old/A [a].mp4'}),
      );
      await store.setStringList('recent', ['$old/B.mp4', 'https://x.com/']);
      await store.setString('title_$old/C.mp4', 'C');

      final changed = await rewriteStoredPaths(store, PrefsMutex());

      expect(changed, 3);
      expect(jsonDecode((await store.getString('offline_index'))!), {
        'https://youtu.be/a': '$phoneMediaDir/A [a].mp4',
      });
      expect(await store.getStringList('recent'), [
        '$phoneMediaDir/B.mp4',
        'https://x.com/',
      ]);
      expect(await store.getString('title_$phoneMediaDir/C.mp4'), 'C');
      expect(await store.getString('title_$old/C.mp4'), isNull);
    });

    test('any spelling of the folder, and the folder alone', () async {
      final store = MemoryKeyValueStore();
      await store.setString('a', '/storage/emulated/0/Download/VIDHOIST/x');
      await store.setString('b', old);
      await rewriteStoredPaths(store, PrefsMutex());
      expect(await store.getString('a'), '$phoneMediaDir/x');
      expect(await store.getString('b'), phoneMediaDir);
    });

    test('nothing else is touched: a longer folder name, another folder, '
        'other types, and a second run changes nothing', () async {
      final store = MemoryKeyValueStore();
      await store.setString('a', '/storage/emulated/0/Download/VidhoistOld/x');
      await store.setString('b', '/storage/emulated/0/Movies/Vidhoist/x');
      await store.setString('c', 'Vidhoist is the old spelling');
      await store.setInt('d', 3);
      await store.setString('e', '$old/x');
      final mutex = PrefsMutex();

      expect(await rewriteStoredPaths(store, mutex), 1);
      expect(await rewriteStoredPaths(store, mutex), 0);
      expect(
        await store.getString('a'),
        '/storage/emulated/0/Download/VidhoistOld/x',
      );
      expect(
        await store.getString('b'),
        '/storage/emulated/0/Movies/Vidhoist/x',
      );
      expect(await store.getString('c'), 'Vidhoist is the old spelling');
      expect(await store.getInt('d'), 3);
    });
  });

  group('renameMediaFolder — what a file manager shows', () {
    late Directory parent;

    setUp(() async {
      parent = await Directory.systemTemp.createTemp('vh_rename_');
      addTearDown(() => parent.delete(recursive: true));
    });

    List<String> names() => [
      for (final e in parent.listSync()) e.path.split(RegExp(r'[\\/]')).last,
    ];

    test('the old spelling is renamed with its files, through a spare name '
        'that does not stay (this disk ignores case too)', () async {
      final old = Directory('${parent.path}/Vidhoist');
      await File('${old.path}/clip.mp4').create(recursive: true);

      final said = await renameMediaFolder(parent: parent.path);

      expect(said, contains('renamed Vidhoist to VidHoist'));
      expect(names(), ['VidHoist']);
      expect(File('${parent.path}/VidHoist/clip.mp4').existsSync(), isTrue);
    });

    test('nothing to do when it is spelled right or not there', () async {
      expect(await renameMediaFolder(parent: parent.path), isNull);
      await Directory('${parent.path}/VidHoist').create();
      expect(await renameMediaFolder(parent: parent.path), isNull);
      expect(names(), ['VidHoist']);
    });

    test('a parent that cannot be read is said, not thrown', () async {
      final said = await renameMediaFolder(parent: '${parent.path}/missing');
      expect(said, startsWith('media folder: cannot list'));
    });
  });

  group('a rename Android refuses, as on the owner phone', () {
    late Directory parent;

    setUp(() async {
      parent = await Directory.systemTemp.createTemp('vh_find_');
      addTearDown(() => parent.delete(recursive: true));
    });

    test('the folder is found under the spelling the disk has, since '
        'Android lists files under that one only', () async {
      await Directory('${parent.path}/Vidhoist').create();
      expect(
        await findMediaDir(parent: parent.path),
        '${parent.path}/Vidhoist',
      );
    });

    test('no folder yet: the wanted spelling', () async {
      expect(
        await findMediaDir(parent: parent.path),
        '${parent.path}/VidHoist',
      );
      expect(
        await findMediaDir(parent: '${parent.path}/missing'),
        '${parent.path}/missing/VidHoist',
      );
    });

    test('paths already moved to VidHoist go back to Vidhoist on disk, '
        'so the library and its titles come back', () async {
      const disk = '/storage/emulated/0/Download/Vidhoist';
      final store = MemoryKeyValueStore();
      await store.setString(
        'offline_index',
        jsonEncode({'https://youtu.be/a': '$preferredMediaDir/A.mp4'}),
      );

      expect(await rewriteStoredPaths(store, PrefsMutex(), to: disk), 1);
      expect(jsonDecode((await store.getString('offline_index'))!), {
        'https://youtu.be/a': '$disk/A.mp4',
      });
    });
  });

  group('the setting', () {
    test('kept under its key, and null removes it', () async {
      final store = MemoryKeyValueStore();
      final c = ProviderContainer(
        overrides: [
          keyValueStoreProvider.overrideWithValue(store),
          initialSettingsProvider.overrideWithValue(const PhoneSettings()),
        ],
      );
      addTearDown(c.dispose);
      final notifier = c.read(settingsProvider.notifier);

      await notifier.setDownloadVolume(card.id);
      expect(c.read(settingsProvider).downloadVolume, card.id);
      expect((await PhoneSettings.load(store)).downloadVolume, card.id);

      await notifier.setDownloadVolume(null);
      expect(c.read(settingsProvider).downloadVolume, isNull);
      expect(await store.getString(PhoneSettings.downloadVolumeKey), isNull);
    });

    test('left out of backups: another phone\'s card has another id', () async {
      final store = MemoryKeyValueStore();
      await store.setString(PhoneSettings.downloadVolumeKey, card.id);
      await store.setString('video_quality', 'best');
      final c = ProviderContainer(
        overrides: [keyValueStoreProvider.overrideWithValue(store)],
      );
      addTearDown(c.dispose);

      final backup = await c.read(backupServiceProvider).exportToString();

      expect(backup, contains('video_quality'));
      expect(backup, isNot(contains(PhoneSettings.downloadVolumeKey)));
    });
  });
}
