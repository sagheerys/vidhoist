import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/background/background_state.dart';
import 'package:vidhoist_mobile/features/background/background_status.dart';
import 'package:vidhoist_mobile/features/background/background_tile.dart';
import 'package:vidhoist_mobile/features/channels/channel_art.dart';
import 'package:vidhoist_mobile/features/channels/channels_screen.dart';
import 'package:vidhoist_mobile/features/channels/channels_state.dart';
import 'package:vidhoist_mobile/features/channels/follow_sheet.dart';
import 'package:vidhoist_mobile/features/settings/auto_backup.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';

Map<String, Object?> _feed(String name) => {
  '_type': 'playlist',
  'channel': name,
  'channel_id': 'UC_$name',
  'entries': [
    {'id': '${name}1', 'url': 'https://www.youtube.com/watch?v=${name}1'},
  ],
};

class _Scheduler implements BackgroundScheduler {
  final calls = <(bool, bool)>[];

  @override
  Future<void> schedule({required bool on, bool soon = false}) async =>
      calls.add((on, soon));

  @override
  void answerRuns() {}
}

class _Backups implements AutoBackup {
  @override
  Future<void> requestBackup() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Art extends ChannelArt {
  _Art() : super(root: () async => Directory.systemTemp.path);

  @override
  Future<File?> file(String id, ChannelArtKind kind, String? url) async => null;
}

/// **The check while the app is closed, as the user meets it**: off until
/// turned on, offered once at the first follow, and saying when it last
/// ran, since Android picks the moment.
void main() {
  late MemoryKeyValueStore store;
  late FakeBackend backend;
  late _Scheduler scheduler;
  late Directory dir;

  setUp(() async {
    store = MemoryKeyValueStore();
    backend = FakeBackend()
      ..listings['https://www.youtube.com/@Some/videos'] = _feed('Some')
      ..listings['https://www.youtube.com/@Other/videos'] = _feed('Other');
    scheduler = _Scheduler();
    dir = await Directory.systemTemp.createTemp('vh_bg_ui');
    addTearDown(() => dir.delete(recursive: true));
  });

  ProviderContainer container({
    BackgroundStatus? status,
    BackgroundStatus Function()? statusNow,
  }) {
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        secretStoreProvider.overrideWithValue(MemorySecretStore()),
        prefsMutexProvider.overrideWithValue(PrefsMutex()),
        initialSettingsProvider.overrideWithValue(const PhoneSettings()),
        loggerProvider.overrideWithValue(
          VhLogger(filePath: '${dir.path}/vh.log'),
        ),
        downloadBackendProvider.overrideWithValue(backend),
        downloadEngineProvider.overrideWithValue(null),
        autoBackupProvider.overrideWithValue(_Backups()),
        channelArtProvider.overrideWithValue(_Art()),
        backgroundSchedulerProvider.overrideWithValue(scheduler),
        backgroundSupportDirProvider.overrideWith((ref) async => dir.path),
        // The file itself is read in background_check_test; a widget test
        // cannot wait on the disk.
        if (status != null)
          backgroundStatusProvider.overrideWith((ref) async => status),
        if (statusNow != null)
          backgroundStatusProvider.overrideWith((ref) async => statusNow()),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  Widget app(ProviderContainer c, {String lang = 'en'}) =>
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp(
          theme: vhTheme(VhVariant.phone, Brightness.light),
          locale: Locale(lang),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: const ChannelsScreen(),
        ),
      );

  Future<void> followIn(WidgetTester tester, String name) async {
    final context = tester.element(find.byType(ChannelsScreen));
    final shown = showFollowSheet(context);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).first,
      'https://www.youtube.com/@$name',
    );
    await tester.pump();
    final follow = find.widgetWithText(FilledButton, 'Follow');
    await tester.ensureVisible(follow);
    await tester.pumpAndSettle();
    await tester.tap(follow);
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pumpAndSettle();
    // The offer, when it comes, waits on the screen; the sheet is done.
    expect(shown, isNotNull);
  }

  testWidgets('**the guard**: it is off until the user turns it on', (
    tester,
  ) async {
    final c = container();
    await c
        .read(channelsControllerProvider)
        .follow(
          'https://www.youtube.com/@Some',
          quality: Quality.best,
          checkIntervalMinutes: 60,
        );
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    expect(find.byType(BackgroundChecksTile), findsOneWidget);
    final tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(tile.value, isFalse);
    expect(scheduler.calls, isEmpty, reason: 'nothing scheduled behind it');
  });

  testWidgets('turned on, it is kept, scheduled with a first check soon, '
      'and says none has run yet', (tester) async {
    final c = container();
    await c
        .read(channelsControllerProvider)
        .follow(
          'https://www.youtube.com/@Some',
          quality: Quality.best,
          checkIntervalMinutes: 60,
        );
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();
    expect(await store.getBool(backgroundChecksKey), isTrue);
    expect(scheduler.calls, [(true, true)]);
    expect(find.textContaining('No check while closed yet'), findsOneWidget);

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();
    expect(await store.getBool(backgroundChecksKey), isFalse);
    expect(scheduler.calls.last, (false, false));
  });

  testWidgets('it says when the last check while closed ran', (tester) async {
    await store.setBool(backgroundChecksKey, true);
    final c = container(
      status: BackgroundStatus(
        lastRun: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    );
    await c
        .read(channelsControllerProvider)
        .follow(
          'https://www.youtube.com/@Some',
          quality: Quality.best,
          checkIntervalMinutes: 60,
        );
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    expect(find.textContaining('Last check while closed:'), findsOneWidget);
    // On at start, so the schedule is made again, without a first check.
    expect(scheduler.calls, [(true, false)]);
  });

  /// **The guard**: the check runs while the app is out of sight, and the
  /// line kept its first answer, saying none had run after one had.
  testWidgets('back from the background, the line says the check that ran '
      'meanwhile', (tester) async {
    await store.setBool(backgroundChecksKey, true);
    var reads = 0;
    final c = container(
      statusNow: () {
        reads++;
        return reads == 1
            ? const BackgroundStatus()
            : BackgroundStatus(
                lastRun: DateTime.now().subtract(const Duration(minutes: 3)),
              );
      },
    );
    await c
        .read(channelsControllerProvider)
        .follow(
          'https://www.youtube.com/@Some',
          quality: Quality.best,
          checkIntervalMinutes: 60,
        );
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    expect(find.textContaining('No check while closed yet'), findsOneWidget);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.textContaining('Last check while closed:'), findsOneWidget);
  });

  testWidgets('**the guard**: the first follow offers it once, and '
      'turning it on from there schedules it', (tester) async {
    final c = container();
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();

    await followIn(tester, 'Some');
    expect(
      find.text('Hear about new videos while VidHoist is closed?'),
      findsOneWidget,
    );
    await tester.tap(find.text('Turn on'));
    await tester.pumpAndSettle();
    expect(c.read(backgroundChecksProvider), isTrue);
    expect(scheduler.calls, [(true, true)]);

    await followIn(tester, 'Other');
    expect(
      find.text('Hear about new videos while VidHoist is closed?'),
      findsNothing,
    );
  });

  testWidgets('"Not now" is final: the next follow does not ask again', (
    tester,
  ) async {
    final c = container();
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();

    await followIn(tester, 'Some');
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(c.read(backgroundChecksProvider), isFalse);
    expect(scheduler.calls, isEmpty);

    await followIn(tester, 'Other');
    expect(
      find.text('Hear about new videos while VidHoist is closed?'),
      findsNothing,
    );
  });

  for (final lang in ['ar', 'en', 'de', 'ur']) {
    testWidgets('the switch and its lines fit a narrow phone, $lang', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await store.setBool(backgroundChecksKey, true);
      final c = container();
      await c
          .read(channelsControllerProvider)
          .follow(
            'https://www.youtube.com/@Some',
            quality: Quality.best,
            checkIntervalMinutes: 60,
          );
      await tester.pumpWidget(app(c, lang: lang));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
