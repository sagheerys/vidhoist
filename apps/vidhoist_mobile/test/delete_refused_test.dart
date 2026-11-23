import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_actions.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/downloads_library/media_remover.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/shared/error_text.dart';

/// Android as it treats a download whose owner it forgot (the app's data
/// was cleared, or the app was installed again): the path refuses, and
/// only its own dialog deletes.
class _ForgetfulAndroid extends MediaRemover {
  _ForgetfulAndroid({required this.userAllows});

  final bool userAllows;
  final asked = <List<String>>[];

  @override
  Future<bool> delete(File file) async => !file.existsSync();

  @override
  Future<bool> askSystem(List<String> paths) async {
    asked.add(paths);
    if (!userAllows) return false;
    for (final path in paths) {
      File(path).deleteSync();
    }
    return true;
  }
}

/// A clip the app could play and share but not delete: "Cannot delete
/// file ... No such file or directory" for a file that was there, while
/// the gallery deleted it without trouble.
void main() {
  // Deleting rescans the gallery through a platform channel.
  TestWidgetsFlutterBinding.ensureInitialized();
  const url = 'https://www.youtube.com/watch?v=aaaaaaaaaaa';

  late Directory temp;
  setUp(() => temp = Directory.systemTemp.createTempSync('vh_delete'));
  tearDown(() => temp.deleteSync(recursive: true));

  LocalItem clip() {
    final file = File('${temp.path}/Clip [aaaaaaaaaaa].mp4')
      ..writeAsBytesSync(const [0]);
    File('${temp.path}/Clip [aaaaaaaaaaa].en.vtt').writeAsStringSync('WEBVTT');
    return LocalItem(
      key: url,
      path: file.path.replaceAll(r'\', '/'),
      canonicalUrl: url,
      title: 'Clip',
      sizeBytes: 1,
      modified: DateTime(2026, 11, 20),
    );
  }

  ProviderContainer container(_ForgetfulAndroid android) {
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        secretStoreProvider.overrideWithValue(MemorySecretStore()),
        prefsMutexProvider.overrideWithValue(PrefsMutex()),
        initialSettingsProvider.overrideWithValue(const PhoneSettings()),
        loggerProvider.overrideWithValue(
          VhLogger(filePath: '${Directory.systemTemp.path}/vh_delete.log'),
        ),
        mediaRemoverProvider.overrideWithValue(android),
        localMediaProvider.overrideWith((ref) async => const []),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('**the guard**: a clip Android will not delete by its path is put '
      'to the user in the system dialog, subtitles and all', () async {
    final item = clip();
    final android = _ForgetfulAndroid(userAllows: true);
    final c = container(android);
    await c.read(titleIndexProvider).put(url, 'Clip');
    await c.read(offlineIndexProvider).put(url, item.path);

    expect(await c.read(libraryActionsProvider).deleteFiles([item]), 1);

    expect(android.asked.single, hasLength(2));
    expect(temp.listSync(), isEmpty);
    expect(await c.read(titleIndexProvider).readAll(), isEmpty);
    expect(await c.read(offlineIndexProvider).readAll(), isEmpty);
  });

  test('**the guard**: declined, the clip stays whole in the library and '
      'the screen is told nothing was deleted', () async {
    final item = clip();
    final c = container(_ForgetfulAndroid(userAllows: false));
    await c.read(titleIndexProvider).put(url, 'Clip');
    await c.read(offlineIndexProvider).put(url, item.path);

    await expectLater(
      c.read(libraryActionsProvider).deleteFiles([item]),
      throwsA(
        isA<DeleteRefusedException>()
            .having((e) => e.left, 'left', 1)
            .having((e) => e.deleted, 'deleted', 0),
      ),
    );

    expect(File(item.path).existsSync(), isTrue);
    expect((await c.read(titleIndexProvider).readAll())[url], 'Clip');
    expect((await c.read(offlineIndexProvider).readAll())[url], item.path);
  });

  test('the refusal is worded for the user, not shown as an errno', () {
    const refused = DeleteRefusedException(deleted: 0, left: 1);
    for (final locale in const [Locale('en'), Locale('ar')]) {
      final l10n = lookupVhLocalizations(locale);
      expect(errorText(l10n, refused), l10n.deleteRefused);
    }
  });
}
