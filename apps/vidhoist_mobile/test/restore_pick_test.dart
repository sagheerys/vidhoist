import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/engine/welcome_screen.dart';
import 'package:vidhoist_mobile/features/settings/auto_backup.dart';
import 'package:vidhoist_mobile/features/settings/restore_from_file.dart';
import 'package:vidhoist_mobile/features/settings/restore_prompt.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';

/// After a reinstall Android drops the old install's ownership of its
/// backups, the app can no longer list them, and the restore offer found
/// nothing: a reinstall without Google's backup kept no settings.
void main() {
  late Directory folder;

  setUp(() => folder = Directory.systemTemp.createTempSync('vh_pick_offer_'));
  tearDown(() => folder.deleteSync(recursive: true));

  /// A file an earlier install downloaded: its link went with that
  /// install's index.
  final orphan = LocalItem(
    key: '$preferredMediaDir/clip.mp4',
    path: '$preferredMediaDir/clip.mp4',
    title: 'clip',
    sizeBytes: 1,
    modified: DateTime(2026, 11, 1),
  );

  /// One this install downloaded, and so knows the link of.
  final known = LocalItem(
    key: 'https://www.youtube.com/watch?v=jNQXAC9IVRw',
    path: '$preferredMediaDir/known.mp4',
    title: 'known',
    canonicalUrl: 'https://www.youtube.com/watch?v=jNQXAC9IVRw',
    sizeBytes: 1,
    modified: DateTime(2026, 11, 12),
  );

  Widget host(
    MemoryKeyValueStore store, {
    required bool welcomed,
    List<LocalItem> downloads = const [],
    String? picked,
  }) => ProviderScope(
    overrides: [
      keyValueStoreProvider.overrideWithValue(store),
      secretStoreProvider.overrideWithValue(MemorySecretStore()),
      prefsMutexProvider.overrideWithValue(PrefsMutex()),
      initialSettingsProvider.overrideWithValue(const PhoneSettings()),
      loggerProvider.overrideWithValue(
        VhLogger(filePath: '${folder.path}/log.txt'),
      ),
      backupRotationProvider.overrideWithValue(
        BackupRotation(directory: folder.path, prefix: phoneBackupPrefix),
      ),
      localMediaProvider.overrideWith((ref) async => downloads),
      welcomedThisRunProvider.overrideWith((ref) => welcomed),
      backupPickerProvider.overrideWithValue(() async => picked),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      theme: vhTheme(VhVariant.phone, Brightness.light),
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
      home: Scaffold(
        body: Consumer(
          builder: (context, ref, _) => TextButton(
            onPressed: () => maybeOfferAutoRestore(context, ref),
            child: const Text('START'),
          ),
        ),
      ),
    ),
  );

  Future<void> start(WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.tap(find.text('START'));
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pumpAndSettle();
  }

  testWidgets('**the guard**: a reinstall that cannot list its backups is '
      'offered the picker instead', (tester) async {
    final store = MemoryKeyValueStore();
    await tester.pumpWidget(host(store, welcomed: true, downloads: [orphan]));
    await start(tester);
    expect(find.text('Bring back your settings?'), findsOneWidget);
    expect(find.text('Choose a backup'), findsOneWidget);
    expect(await store.getBool('auto_restore_offered'), isTrue);
    expect(await store.getBool(restorePickPendingKey), isNot(isTrue));
  });

  testWidgets('**the guard**: the picked copy is restored like one from '
      'the folder, with its old folder spelling fixed', (tester) async {
    final source = MemoryKeyValueStore();
    await source.setString(
      'last_opened',
      '/storage/emulated/0/Download/Vidhoist/clip.mp4',
    );
    final contents = await BackupService(
      store: source,
      mutex: PrefsMutex(),
      variant: 'phone',
    ).exportToString();
    final store = MemoryKeyValueStore();
    await tester.pumpWidget(
      host(store, welcomed: true, downloads: [orphan], picked: contents),
    );
    await start(tester);
    await tester.runAsync(() async {
      await tester.tap(find.text('Choose a backup'));
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pump();
    expect(await store.getString('last_opened'), '$phoneMediaDir/clip.mp4');
    expect(
      find.byWidgetPredicate(
        (w) => w is Text && w.data == context(tester).vhl.autoRestoreSuccess,
      ),
      findsOneWidget,
    );
  });

  testWidgets('**the guard**: downloads hidden on the welcome run are '
      'offered on a later start', (tester) async {
    // The media permission may not be granted yet on the welcome run.
    final store = MemoryKeyValueStore();
    await tester.pumpWidget(host(store, welcomed: true));
    await start(tester);
    expect(find.text('Bring back your settings?'), findsNothing);
    expect(await store.getBool('auto_restore_offered'), isNot(isTrue));
    expect(await store.getBool(restorePickPendingKey), isTrue);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(host(store, welcomed: false, downloads: [orphan]));
    await start(tester);
    expect(find.text('Bring back your settings?'), findsOneWidget);
    expect(await store.getBool('auto_restore_offered'), isTrue);
  });

  testWidgets('a first install, with only its own downloads, is asked '
      'nothing', (tester) async {
    final store = MemoryKeyValueStore();
    await tester.pumpWidget(host(store, welcomed: true, downloads: [known]));
    await start(tester);
    expect(find.text('Bring back your settings?'), findsNothing);
  });

  testWidgets('settings brought back by Google skip the welcome, and are '
      'asked nothing', (tester) async {
    final store = MemoryKeyValueStore();
    await tester.pumpWidget(host(store, welcomed: false, downloads: [orphan]));
    await start(tester);
    expect(find.text('Bring back your settings?'), findsNothing);
  });
}

BuildContext context(WidgetTester tester) => tester.element(find.text('START'));
