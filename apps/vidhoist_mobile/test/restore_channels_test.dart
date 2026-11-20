import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/channels/channel_card.dart';
import 'package:vidhoist_mobile/features/channels/channels_screen.dart';
import 'package:vidhoist_mobile/features/channels/channels_state.dart';
import 'package:vidhoist_mobile/features/settings/auto_backup.dart';
import 'package:vidhoist_mobile/features/settings/restore_from_file.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';

Map<String, Object?> _feed(String name) => {
  '_type': 'playlist',
  'channel': name,
  'channel_id': 'UC_$name',
  'entries': [
    {'id': '${name}1', 'url': 'https://www.youtube.com/watch?v=${name}1'},
  ],
};

/// **A restore brings the followed channels back, at once and for good.**
///
/// The channels' source keeps what it read in memory. A restore wrote the
/// channels to the store and reloaded the page's list, which asked the
/// same source and got the channels of before: none, on a phone set up
/// again. The next follow or check then wrote that memory over them.
void main() {
  late FakeBackend backend;

  setUp(() {
    backend = FakeBackend()
      ..listings['https://www.youtube.com/@Some/videos'] = _feed('Some')
      ..listings['https://www.youtube.com/@Other/videos'] = _feed('Other');
  });

  /// A backup from a phone that follows one channel.
  Future<String> backupWithSome() async {
    final old = MemoryKeyValueStore();
    await LocalChannelSource(
      store: old,
      backend: backend,
      enqueue: (_, _, _) {},
    ).follow(
      'https://www.youtube.com/@Some',
      Quality.best,
      checkIntervalMinutes: 60,
    );
    return BackupService(
      store: old,
      mutex: PrefsMutex(),
      variant: 'phone',
    ).exportToString();
  }

  testWidgets('**the guard**: the page shows the restored channel without a '
      'restart, and the next follow keeps it', (tester) async {
    final backup = await backupWithSome();
    final store = MemoryKeyValueStore();
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        secretStoreProvider.overrideWithValue(MemorySecretStore()),
        prefsMutexProvider.overrideWithValue(PrefsMutex()),
        initialSettingsProvider.overrideWithValue(const PhoneSettings()),
        loggerProvider.overrideWithValue(
          VhLogger(filePath: '${Directory.systemTemp.path}/vh_restore.log'),
        ),
        downloadBackendProvider.overrideWithValue(backend),
        downloadEngineProvider.overrideWithValue(null),
        autoBackupProvider.overrideWithValue(_Backups()),
      ],
    );
    addTearDown(c.dispose);
    late WidgetRef widgetRef;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp(
          theme: vhTheme(VhVariant.phone, Brightness.light),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: Consumer(
            builder: (context, ref, _) {
              widgetRef = ref;
              return const ChannelsScreen();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ChannelCard), findsNothing, reason: 'a fresh phone');

    await c.read(backupServiceProvider).importFromString(backup);
    await refreshAfterRestore(widgetRef);
    await tester.pumpAndSettle();
    expect(find.byType(ChannelCard), findsOneWidget);
    expect(find.textContaining('Some', findRichText: true), findsWidgets);

    await c
        .read(channelsControllerProvider)
        .follow(
          'https://www.youtube.com/@Other',
          quality: Quality.best,
          checkIntervalMinutes: 60,
        );
    final kept = await c.read(channelSourceProvider).list();
    expect([for (final s in kept) s.name]..sort(), ['Other', 'Some']);
  });
}

/// Writes no backup: the follow asks for one, and the test is not about it.
class _Backups implements AutoBackup {
  @override
  Future<void> requestBackup() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
