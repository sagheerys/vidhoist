import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/data/backup_data.dart';
import 'package:vidhoist_desktop/data/folders_data.dart';
import 'package:vidhoist_desktop/data/library_data.dart';
import 'package:vidhoist_desktop/data/transcripts_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/features/settings/backup_actions.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_transcripts/vh_transcripts.dart';

const _a = 'https://www.youtube.com/watch?v=aaaaaaaaaaa';

/// A phone's backup: one favourite, and the address of the server the
/// phone once had (which must not come over).
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

    test("**the guard**: a phone's backup is added, and its server's "
        'address does not come over', () async {
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
  });

  test('a dropped backup or transcripts file goes to the import, links to '
      'the add dialog', () async {
    expect(isBackupText(await _phoneBackup()), isTrue);
    expect(isBackupText(TranscriptBundle.encode(const [])), isTrue);
    expect(isBackupText('https://youtu.be/aaaaaaaaaaa'), isFalse);
  });
}
