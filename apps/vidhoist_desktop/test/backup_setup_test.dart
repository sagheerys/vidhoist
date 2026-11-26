import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/data/backup_data.dart';
import 'package:vidhoist_desktop/data/backup_folder.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/first_start.dart';
import 'package:vidhoist_desktop/data/folders_data.dart';
import 'package:vidhoist_desktop/data/library_data.dart';
import 'package:vidhoist_desktop/data/lists_data.dart';
import 'package:vidhoist_desktop/identity.dart';
import 'package:vidhoist_desktop/data/transcripts_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/features/settings/backup_actions.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_transcripts/vh_transcripts.dart';

const _a = 'https://www.youtube.com/watch?v=aaaaaaaaaaa';

/// A phone's backup: one favourite, and an `active_url` entry (which must
/// not come over).
Future<String> _phoneBackup() async {
  final store = MemoryKeyValueStore();
  final mutex = PrefsMutex();
  await TagsIndex(
    store: store,
    mutex: mutex,
    clock: () => DateTime.utc(2026, 10, 20),
  ).toggleTag(_a, VhConstants.favoritesSystemTag);
  await store.setString('active_url', 'http://192.168.1.10:8081');
  return BackupService(
    store: store,
    mutex: mutex,
    variant: 'phone',
  ).exportToString();
}

class _Downloads extends NoFolders {
  _Downloads(this.root);
  final Directory root;

  @override
  Future<String?> downloads() async => root.path;
}

void main() {
  group('backups', () {
    late Directory root;
    late ProviderContainer c;
    late MemoryKeyValueStore store;

    setUp(() {
      root = Directory.systemTemp.createTempSync('ember_backup_');
      store = MemoryKeyValueStore();
      c = ProviderContainer(
        overrides: [
          keyValueStoreProvider.overrideWithValue(store),
          backupFolderProvider.overrideWithValue(
            Directory('${root.path}/backup'),
          ),
          transcriptStoreProvider.overrideWithValue(
            TranscriptStore(Directory('${root.path}/transcripts')),
          ),
          desktopFoldersProvider.overrideWithValue(_Downloads(root)),
        ],
      );
    });
    tearDown(() {
      c.dispose();
      root.deleteSync(recursive: true);
    });

    test(
      'a dated copy, then restoring it makes this computer as it was',
      () async {
        await store.setString('video_sort_option', 'oldest');
        final copy = await c.read(backupsProvider).backUpNow();
        expect(copy, isNotNull);
        expect(await c.read(backupsProvider).list(), hasLength(1));
        await store.setString('video_sort_option', 'newest');
        await c.read(backupsProvider).restore(copy!);
        expect(await store.getString('video_sort_option'), 'oldest');
      },
    );

    test("**the guard**: a phone's backup is added, and its `active_url` "
        'does not come over', () async {
      final tags = c.read(tagsIndexProvider);
      await tags.toggleTag(_a, 'mine');
      final outcome = await c
          .read(backupsProvider)
          .importFile(await _phoneBackup());
      expect(outcome, isA<MergedBackup>());
      expect((await tags.tagsOf(_a)).toSet(), {
        'mine',
        VhConstants.favoritesSystemTag,
      });
      expect(await store.getString('active_url'), isNull);
    });

    test('a transcripts file adds what this computer lacked', () async {
      final t = Transcript(
        canonicalUrl: _a,
        language: 'en',
        source: 'captions',
        fetchedAt: DateTime.utc(2026, 10, 1),
        segments: const [],
      );
      final outcome = await c
          .read(backupsProvider)
          .importFile(TranscriptBundle.encode([t]));
      expect((outcome as MergedTranscripts).added, 1);
      final again = await c
          .read(backupsProvider)
          .importFile(TranscriptBundle.encode([t]));
      expect((again as MergedTranscripts).added, 0);
    });

    test("**the guard**: this computer's own backup, chosen as a file, is "
        'offered whole, and restoring it brings back the library and the '
        'channels (merged, it brought the playlists alone)', () async {
      await store.setStringList(LocalHistoryStore.key, ['{"path":"C:/a.mp4"}']);
      await store.setString(LocalChannelSource.storeKey, '[{"id":"c1"}]');
      final file = await BackupService(
        store: store,
        mutex: PrefsMutex(),
        variant: 'desktop',
      ).exportToString();
      await store.remove(LocalHistoryStore.key);
      await store.remove(LocalChannelSource.storeKey);

      final outcome = await c.read(backupsProvider).importFile(file);
      expect(outcome, isA<ComputerBackup>());
      // Nothing changes until the person says so.
      expect(await store.getStringList(LocalHistoryStore.key), isNull);

      await c
          .read(backupsProvider)
          .restoreText((outcome as ComputerBackup).contents);
      expect(await store.getStringList(LocalHistoryStore.key), hasLength(1));
      expect(await store.getString(LocalChannelSource.storeKey), isNotNull);
    });

    test('what this computer exports for the phone is still merged, not '
        'restored', () async {
      await c.read(tagsIndexProvider).toggleTag(_a, 'mine');
      final folder = await c.read(backupsProvider).exportForPhone();
      final shared = Directory(folder!)
          .listSync()
          .whereType<File>()
          .firstWhere((f) => f.path.contains('vidhoist_'))
          .readAsStringSync();
      expect(
        await c.read(backupsProvider).importFile(shared),
        isA<MergedBackup>(),
      );
    });

    test('the clips already in the download folder go back in the library, '
        "and a playlist's own record names a file the name cannot", () async {
      final downloads = '${root.path}\\${DesktopIdentity.displayName}';
      Directory(downloads).createSync(recursive: true);
      File('$downloads\\Talk [Ekrbvyw94A0].mp4').writeAsStringSync('v');
      File('$downloads\\A song [2070939652].m4a').writeAsStringSync('a');
      File('$downloads\\left.mp4').writeAsStringSync('?');
      await c
          .read(playlistsStoreProvider)
          .create(
            'Mine',
            items: [
              PlaylistEntry(
                canonicalUrl: 'https://soundcloud.com/someone/a-song',
                serverFilename: '/audio_download/A song [2070939652].m4a',
              ),
            ],
          );

      final result = await c.read(backupsProvider).recoverLibrary();
      expect(result!.added, 2);
      expect(result.unknown, 1);
      final urls = {
        for (final e in await c.read(localHistoryStoreProvider).entries())
          e.item.canonicalUrl,
      };
      expect(urls, {
        'https://www.youtube.com/watch?v=Ekrbvyw94A0',
        'https://soundcloud.com/someone/a-song',
      });

      final again = await c.read(backupsProvider).recoverLibrary();
      expect(again!.added, 0);
    });

    test('the saved transcripts are kept beside the backups and come back '
        'with a restore: they are files of their own, not settings', () async {
      final store = c.read(transcriptStoreProvider)!;
      final t = Transcript(
        canonicalUrl: _a,
        language: 'en',
        source: 'captions',
        fetchedAt: DateTime.utc(2026, 10, 1),
        segments: const [],
      );
      await store.write(t);
      final copy = await c.read(backupsProvider).backUpNow();
      expect(File('${root.path}/backup/transcripts.json').existsSync(), isTrue);

      // A reinstall that deleted the app's data.
      await store.clear();
      await c.read(backupsProvider).restore(copy!);
      expect(await store.read(_a, 'en'), isNotNull);
    });

    test('**the guard**: "Delete all" takes the copy beside the backups too, '
        'so a later restore does not bring back what was deleted', () async {
      final transcripts = c.read(transcriptStoreProvider)!;
      await transcripts.write(
        Transcript(
          canonicalUrl: _a,
          language: 'en',
          source: 'captions',
          fetchedAt: DateTime.utc(2026, 10, 1),
          segments: const [],
        ),
      );
      final copy = await c.read(backupsProvider).backUpNow();
      await transcripts.clear();
      await c.read(backupsProvider).forgetTranscripts();
      expect(
        File('${root.path}/backup/transcripts.json').existsSync(),
        isFalse,
      );

      await c.read(backupsProvider).restore(copy!);
      expect(await transcripts.read(_a, 'en'), isNull);
    });

    test('**the guard**: a first start makes no automatic backup until it is '
        'settled, so an empty install never becomes the newest', () async {
      await c.read(startupBackupProvider.future);
      expect(await c.read(backupsProvider).list(), isEmpty);

      await store.setBool(welcomedKey, true);
      c.invalidate(startupBackupProvider);
      await c.read(startupBackupProvider.future);
      expect(await c.read(backupsProvider).list(), hasLength(1));
    });

    test('anything else is refused', () async {
      expect(
        await c.read(backupsProvider).importFile('just text'),
        isA<NotABackup>(),
      );
    });

    test('the export for the phone is two files in Downloads', () async {
      await c.read(tagsIndexProvider).toggleTag(_a, 'mine');
      final folder = await c
          .read(backupsProvider)
          .exportForPhone(at: DateTime(2026, 10, 24, 12));
      final names = Directory(folder!)
          .listSync()
          .map((f) => f.uri.pathSegments.last)
          .toList();
      expect(names, ['vidhoist_2026-10-24_120000.json']);
      expect(folder, endsWith(r'\For the phone'));
    });

    test('**the guard**: the export is written under a temporary name and '
        'renamed, and what an interrupted one left is not left for the '
        'phone', () async {
      await c.read(tagsIndexProvider).toggleTag(_a, 'mine');
      final base = await c.read(downloadFolderProvider.future);
      final dir = Directory('$base\\For the phone')
        ..createSync(recursive: true);
      File('${dir.path}\\vidhoist_2026-10-23_100000.json.tmp')
          .writeAsStringSync('{"vidhoist_backup":');
      await c
          .read(backupsProvider)
          .exportForPhone(at: DateTime(2026, 10, 24, 12));
      final names = dir.listSync().map((f) => f.uri.pathSegments.last);
      expect(names, ['vidhoist_2026-10-24_120000.json']);
      final text = File('${dir.path}\\vidhoist_2026-10-24_120000.json')
          .readAsStringSync();
      expect(BackupMerge.looksLikeBackup(text), isTrue);
    });
  });

  group('where the backups live', () {
    late Directory root;
    setUp(() => root = Directory.systemTemp.createTempSync('vh_backup_dir_'));
    tearDown(() => root.deleteSync(recursive: true));

    test(
      "**the guard**: beside the downloads, not inside the app's data, "
      'which an uninstall may delete; the old ones are carried over',
      () async {
        final roaming = '${root.path}\\roaming';
        final old = Directory('$roaming/backup')..createSync(recursive: true);
        File('${old.path}/vidhoist_2026-11-01_120000.json')
            .writeAsStringSync('{}');

        final dir = await desktopBackupFolder(
          _Downloads(Directory('${root.path}\\Downloads')),
          roaming: roaming,
        );
        expect(
          dir.path,
          '${root.path}\\Downloads\\${DesktopIdentity.displayName}\\Backups',
        );
        expect(
          File('${dir.path}\\vidhoist_2026-11-01_120000.json').existsSync(),
          isTrue,
        );
        expect(old.existsSync(), isFalse);
      },
    );

    test('with no Downloads folder, the old place', () async {
      final dir = await desktopBackupFolder(
        const NoFolders(),
        roaming: root.path,
      );
      expect(dir.path, '${root.path}/backup');
    });
  });

  test('a dropped backup or transcripts file goes to the import, links to '
      'the add dialog', () async {
    expect(isBackupText(await _phoneBackup()), isTrue);
    expect(isBackupText(TranscriptBundle.encode(const [])), isTrue);
    expect(isBackupText('https://youtu.be/aaaaaaaaaaa'), isFalse);
  });
}
