import 'dart:convert';

import 'package:vh_core/vh_core.dart';
import 'package:test/test.dart';

void main() {
  late MemoryKeyValueStore store;
  late MemorySecretStore secrets;
  late BackupService service;

  setUp(() {
    store = MemoryKeyValueStore();
    secrets = MemorySecretStore();
    service = BackupService(
      store: store,
      mutex: PrefsMutex(),
      variant: 'phone',
    );
  });

  group('BackupService: the plain format', () {
    test('a full round trip with every type, and no secret', () async {
      await store.setString('server_url', 'https://vidhoist.example.com');
      await store.setBool('library_compact_view', true);
      await store.setInt('player_play_mode', 2);
      await store.setDouble('player_playback_speed', 1.5);
      await store.setStringList('external_urls', ['https://a', 'https://b']);
      await secrets.write(SecretKeys.username, 'user');
      await secrets.write(SecretKeys.password, 'sirri-jiddan');

      final exported = await service.exportToString();
      // Plain text, no encrypted header, and no key that dies with a
      // reinstall.
      expect(exported, startsWith('{'));
      expect(exported, isNot(contains('sirri-jiddan')));
      expect(
        exported,
        isNot(contains('user')),
        reason: 'اسم المستخدم لم يعد يُنسخ — الملف بلا سرّ إطلاقاً',
      );

      // A new device: **with no key imported at all**, which is the whole
      // gain.
      final freshStore = MemoryKeyValueStore();
      final freshService = BackupService(
        store: freshStore,
        mutex: PrefsMutex(),
        variant: 'phone',
      );

      final result = await freshService.importFromString(exported);
      expect(result.format, BackupFormat.plain);
      expect(result.keysRestored, 5);
      expect(
        await freshStore.getString('server_url'),
        'https://vidhoist.example.com',
      );
      expect(await freshStore.getBool('library_compact_view'), isTrue);
      expect(await freshStore.getInt('player_play_mode'), 2);
      expect(await freshStore.getDouble('player_playback_speed'), 1.5);
      expect(await freshStore.getStringList('external_urls'), [
        'https://a',
        'https://b',
      ]);
    });

    test('what this phone has pending stays on this phone', () async {
      // A pending download restored on another phone would start there a
      // second time, for a promise this one made; the other flag is a
      // fact about one install, not about the user.
      await store.setString(BackupService.serverPendingKey, '[{"id":"t1"}]');
      await store.setBool(BackupService.serverKeepsFilesKey, true);
      await store.setBool('library_compact_view', true);

      final exported = await service.exportToString();
      expect(exported, isNot(contains(BackupService.serverPendingKey)));
      expect(exported, isNot(contains(BackupService.serverKeepsFilesKey)));

      // And a file that carries them anyway — edited by hand, or from a
      // build between two releases — does not plant them here.
      final planted = json.decode(exported) as Map<String, dynamic>;
      (planted['prefs']
          as Map<String, dynamic>)[BackupService.serverKeepsFilesKey] = {
        't': 'b',
        'v': true,
      };
      final fresh = MemoryKeyValueStore();
      await BackupService(
        store: fresh,
        mutex: PrefsMutex(),
        variant: 'phone',
      ).importFromString(json.encode(planted));
      expect(await fresh.getBool(BackupService.serverKeepsFilesKey), isNull);
      expect(await fresh.getBool('library_compact_view'), isTrue);
    });

    test('nor the on-device engine\'s unfinished downloads, nor what the '
        'app names as its own device\'s', () async {
      // The partial files are on this device; restored elsewhere the
      // records would start every download again from nothing. When the
      // engine was last updated is a fact about this install: restored on
      // a new phone, it would skip the update its year-old yt-dlp needs.
      final mine = BackupService(
        store: store,
        mutex: PrefsMutex(),
        variant: 'phone',
        deviceOnlyKeys: const {'engine_updated_at'},
      );
      await store.setStringList(LocalPendingStore.key, ['{"id":"t1"}']);
      await store.setInt('engine_updated_at', 1);
      await store.setBool('library_compact_view', true);

      final exported = await mine.exportToString();
      expect(exported, isNot(contains(LocalPendingStore.key)));
      expect(exported, isNot(contains('engine_updated_at')));
      expect(exported, contains('library_compact_view'));

      final planted = json.decode(exported) as Map<String, dynamic>;
      (planted['prefs'] as Map<String, dynamic>)['engine_updated_at'] = {
        't': 'i',
        'v': 1,
      };
      final fresh = MemoryKeyValueStore();
      await BackupService(
        store: fresh,
        mutex: PrefsMutex(),
        variant: 'phone',
        deviceOnlyKeys: const {'engine_updated_at'},
      ).importFromString(json.encode(planted));
      expect(await fresh.getInt('engine_updated_at'), isNull);
    });

    test('**the guard**: the covers kept as files stay on this phone, or a '
        'restore elsewhere shows those clips with no cover at all', () async {
      // Found while restoring a backup on a fresh install (2026-11-05):
      // the paths pointed at files of the old install, and the clips they
      // stood for showed blank.
      await store.setString(
        KeptCoverIndex.keptKey,
        '{"https://youtu.be/a":"/data/user/0/app/files/kept_covers/a.jpg"}',
      );
      await store.setBool('library_compact_view', true);

      final exported = await service.exportToString();
      expect(exported, isNot(contains(KeptCoverIndex.keptKey)));

      final planted = json.decode(exported) as Map<String, dynamic>;
      (planted['prefs'] as Map<String, dynamic>)[KeptCoverIndex.keptKey] = {
        't': 's',
        'v': '{"https://youtu.be/a":"/old/kept_covers/a.jpg"}',
      };
      final fresh = MemoryKeyValueStore();
      await BackupService(
        store: fresh,
        mutex: PrefsMutex(),
        variant: 'phone',
      ).importFromString(json.encode(planted));
      expect(await fresh.getString(KeptCoverIndex.keptKey), isNull);
      expect(await fresh.getBool('library_compact_view'), isTrue);
    });

    test('the "what is new" record stays with the installed app', () async {
      // Restored from an older backup it would show a sheet already read,
      // or show one on a fresh install.
      await store.setString(UpdatePrefs.lastSeenVersionKey, '2.3.0');
      await store.setString(UpdatePrefs.notesKey, '{"version":"2.3.0"}');
      final exported = await service.exportToString();
      expect(exported, isNot(contains(UpdatePrefs.lastSeenVersionKey)));
      expect(exported, isNot(contains(UpdatePrefs.notesKey)));

      final planted = json.decode(exported) as Map<String, dynamic>;
      (planted['prefs']
          as Map<String, dynamic>)[UpdatePrefs.lastSeenVersionKey] = {
        't': 's',
        'v': '2.2.0',
      };
      final fresh = MemoryKeyValueStore();
      await BackupService(
        store: fresh,
        mutex: PrefsMutex(),
        variant: 'phone',
      ).importFromString(json.encode(planted));
      expect(await fresh.getString(UpdatePrefs.lastSeenVersionKey), isNull);
    });

    test('credentials embedded in the URL are stripped', () async {
      await store.setString('server_url', 'https://u:pw@host/path');
      final exported = await service.exportToString();
      expect(exported, isNot(contains('pw@host')));
      expect(exported, contains('https://host/path'));
    });

    test(
      'text that is not a backup raises BackupFormatException, not a crash',
      () async {
        expect(
          service.importFromString('مرحبا'),
          throwsA(isA<BackupFormatException>()),
        );
        expect(
          service.importFromString('{"app":"شيء آخر"}'),
          throwsA(isA<BackupFormatException>()),
        );
        expect(
          service.importFromString('{ليس json'),
          throwsA(isA<BackupFormatException>()),
        );
      },
    );
  });

  test('a file with no header raises BackupFormatException', () {
    expect(
      service.importFromString('{"app": "x"}'),
      throwsA(isA<BackupFormatException>()),
    );
  });

  test('**the guard**: an old binary backup format is refused, not read', () {
    for (final header in ['MTBACKUP1', 'MTSBACKUP1', 'MTF1']) {
      expect(
        service.importFromString('$header\nabc\ndef'),
        throwsA(isA<BackupFormatException>()),
        reason: header,
      );
    }
  });

  test('a backup from Vidhoist 1.0.0, named MTF, still imports', () async {
    final result = await service.importFromString(
      json.encode({
        'app': 'MTF',
        'variant': 'lite',
        'version': 3,
        'prefs': {
          'theme_mode': {'t': 's', 'v': 'dark'},
        },
      }),
    );
    expect(result.keysRestored, 1);
    expect(await store.getString('theme_mode'), 'dark');
  });

  test("a backup is written under Vidhoist's own name", () async {
    final written = json.decode(await service.exportToString()) as Map;
    expect(written['app'], 'Vidhoist');
  });
}
