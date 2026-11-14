import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/settings/battery_freedom.dart';
import 'package:vidhoist_mobile/features/settings/settings_hub.dart';
import 'package:vidhoist_mobile/features/settings/settings_page.dart';
import 'package:vidhoist_mobile/features/settings/settings_screen.dart';
import 'package:vidhoist_mobile/features/settings/settings_sections.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/settings/widgets/engine_fields.dart';
import 'package:vidhoist_mobile/features/settings/widgets/settings_fields.dart';
import 'package:vidhoist_mobile/features/settings/widgets/subtitle_download_fields.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'device_matrix.dart';

/// **The settings home** (approved mock-up, 2026-10-14): three short
/// groups whose rows show each setting as it stands, each opening its own
/// page. On a tablet held sideways the same rows open in two panes
/// (approved 2026-10-10).
void main() {
  Widget host({
    PhoneSettings settings = const PhoneSettings(),
    BatteryFreedom? battery,
  }) {
    final container = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        secretStoreProvider.overrideWithValue(MemorySecretStore()),
        prefsMutexProvider.overrideWithValue(PrefsMutex()),
        initialSettingsProvider.overrideWithValue(settings),
        batteryFreedomProvider.overrideWithValue(
          battery ?? _Battery(free: true),
        ),
        // The logs and backup pages read the log on opening.
        loggerProvider.overrideWithValue(
          VhLogger(filePath: '${Directory.systemTemp.path}/mtf_settings.log'),
        ),
      ],
    );
    addTearDown(container.dispose);
    final router = GoRouter(
      initialLocation: '/settings',
      routes: [
        GoRoute(
          path: '/settings',
          builder: (_, _) => const SettingsScreen(),
          routes: [
            for (final pane in SettingsPane.values)
              GoRoute(path: pane.name, builder: (_, _) => SettingsPage(pane)),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        theme: vhTheme(VhVariant.phone, Brightness.light),
      ),
    );
  }

  Future<void> at(
    WidgetTester tester,
    Size size, {
    PhoneSettings settings = const PhoneSettings(),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(host(settings: settings));
    await tester.pumpAndSettle();
  }

  VhLocalizations l10nOf(WidgetTester tester) =>
      tester.element(find.byType(SettingsScreen)).vhl;

  testWidgets('a phone opens on the short home, not the long page', (
    tester,
  ) async {
    await at(tester, const Size(411, 914));
    expect(find.byType(SettingsHub), findsNothing);
    expect(find.byType(EngineFields), findsNothing);
    expect(find.byType(VhSettingsRow), findsWidgets);
  });

  testWidgets('a tablet upright keeps the phone\'s home too', (tester) async {
    await at(tester, const Size(800, 1280));
    expect(find.byType(SettingsHub), findsNothing);
    expect(find.byType(VhSettingsRow), findsWidgets);
  });

  testWidgets('GUARD: every section has a row, and its row opens its page', (
    tester,
  ) async {
    // Tall enough for the whole list, so no row is out of reach.
    await at(tester, const Size(411, 2000));
    final l10n = l10nOf(tester);
    final titles = {
      SettingsPane.engine: l10n.mobileSettingsEngine,
      SettingsPane.accounts: l10n.settingsAccounts,
      SettingsPane.channels: l10n.desktopChannels,
      SettingsPane.downloads: l10n.settingsDownloads,
      SettingsPane.pc: l10n.pcTab,
      SettingsPane.playback: l10n.settingsPlayback,
      SettingsPane.appearance: l10n.appearanceAndLanguage,
      SettingsPane.backup: l10n.settingsBackup,
      SettingsPane.updates: l10n.updates,
      SettingsPane.logs: l10n.diagnosticLogs,
      SettingsPane.about: l10n.aboutApp,
    };
    expect(titles.keys, SettingsPane.values, reason: 'a section without a row');
    expect(
      find.byType(VhSettingsRow),
      findsNWidgets(SettingsPane.values.length),
    );

    for (final MapEntry(key: pane, value: title) in titles.entries) {
      await tester.tap(
        find.descendant(
          of: find.byType(VhSettingsRow),
          matching: find.text(title),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(
        find.byWidgetPredicate((w) => w is SettingsPage && w.pane == pane),
        findsOneWidget,
        reason: '$pane',
      );
      GoRouter.of(tester.element(find.byType(SettingsPage))).pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
    }
  });

  testWidgets('each row shows the setting as it stands', (tester) async {
    await at(
      tester,
      const Size(411, 2000),
      settings: const PhoneSettings(
        quality: Quality.q720,
        wifiOnly: true,
        themeMode: ThemeMode.dark,
        compatiblePlayback: false,
      ),
    );
    final l10n = l10nOf(tester);
    expect(
      find.text(vhMetaLine([l10n.quality720, l10n.settingsValueWifiOnly])),
      findsOneWidget,
    );
    expect(find.text(l10n.settingsValueCompatOff), findsOneWidget);
    expect(find.text(vhMetaLine([l10n.themeDark, 'English'])), findsOneWidget);
  });

  testWidgets('the engine row is there: the engine is on the phone', (
    tester,
  ) async {
    await at(tester, const Size(411, 914));
    final l10n = l10nOf(tester);
    expect(find.text(l10n.mobileSettingsEngine), findsOneWidget);
    // Before its first update the library cannot tell its version.
    expect(find.text(l10n.mobileEngineVersionUnknown), findsOneWidget);
  });

  testWidgets('a tablet on its side opens the engine pane beside the list', (
    tester,
  ) async {
    await at(tester, const Size(1280, 800));
    expect(find.byType(SettingsHub), findsOneWidget);
    expect(find.byType(EngineFields), findsOneWidget);
    expect(find.byType(DownloadFields), findsNothing);
    final l10n = l10nOf(tester);

    await tester.tap(find.text(l10n.settingsDownloads));
    await tester.pumpAndSettle();
    expect(find.byType(DownloadFields), findsOneWidget);
    expect(find.byType(EngineFields), findsNothing);

    await tester.tap(find.text(l10n.settingsPlayback));
    await tester.pumpAndSettle();
    expect(find.byType(PlaybackFields), findsOneWidget);

    await tester.tap(find.text(l10n.appearanceAndLanguage));
    await tester.pumpAndSettle();
    expect(find.byType(AppearanceFields), findsOneWidget);
  });

  testWidgets('**device matrix**: neither shape overflows', (tester) async {
    await expectNoOverflow(tester, host);
  });

  testWidgets('**device matrix**: nor does any section\'s own page', (
    tester,
  ) async {
    for (final pane in const [
      SettingsPane.engine,
      SettingsPane.downloads,
      SettingsPane.playback,
      SettingsPane.appearance,
      SettingsPane.updates,
    ]) {
      await expectNoOverflow(tester, () {
        final app = host() as UncontrolledProviderScope;
        return UncontrolledProviderScope(
          container: app.container,
          child: MaterialApp(
            localizationsDelegates: VhLocalizations.localizationsDelegates,
            supportedLocales: VhLocalizations.supportedLocales,
            theme: vhTheme(VhVariant.phone, Brightness.light),
            home: SettingsPage(pane),
          ),
        );
      });
    }
  });

  // Field report 2026-11-01: an empty strip past the last card, kept for a
  // mini player and an add button that never show on this tab.
  testWidgets('**the guard**: the home ends just past its last card', (
    tester,
  ) async {
    await at(tester, const Size(411, 600));
    final list = find.byType(ListView).first;
    await tester.drag(list, const Offset(0, -4000));
    await tester.pumpAndSettle();
    final gap =
        tester.getRect(list).bottom -
        tester.getRect(find.byType(VhSettingsGroup).last).bottom;
    expect(gap, lessThanOrEqualTo(VhSpace.xl + 1));
  });

  group('Settings › Downloads', () {
    Widget downloads(BatteryFreedom battery) {
      final app = host(battery: battery) as UncontrolledProviderScope;
      return UncontrolledProviderScope(
        container: app.container,
        child: MaterialApp(
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          theme: vhTheme(VhVariant.phone, Brightness.light),
          home: const SettingsPage(SettingsPane.downloads),
        ),
      );
    }

    testWidgets('**the guard**: the settings home carries no battery banner, '
        'restricted or not', (tester) async {
      await tester.pumpWidget(host(battery: _Battery(free: false)));
      await tester.pumpAndSettle();
      final l10n = tester.element(find.byType(SettingsScreen)).vhl;
      expect(find.text(l10n.batteryTitle), findsNothing);
      expect(find.text(l10n.batteryRestricted), findsNothing);
    });

    testWidgets('**the guard**: Downloads › Advanced says it is restricted, '
        'Allow opens the dialog of Android, and the row then reads allowed', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(600, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final battery = _Battery(free: false);
      await tester.pumpWidget(downloads(battery));
      await tester.pumpAndSettle();
      final l10n = tester.element(find.byType(BatteryTile)).vhl;
      expect(find.text(l10n.batteryStateLimited), findsOneWidget);
      expect(find.text(l10n.batteryRestricted), findsOneWidget);

      await tester.tap(find.text(l10n.batteryAllow));
      await tester.pumpAndSettle();
      expect(battery.asked, 1);
      expect(find.text(l10n.batteryStateFree), findsOneWidget);
      expect(find.text(l10n.batteryFree), findsOneWidget);
      expect(find.text(l10n.batteryAllow), findsNothing);
    });

    testWidgets('**the guard**: a language chip adds or drops that language, '
        'the last one stays, and the subtitles can go inside the video', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(600, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(downloads(_Battery(free: true)));
      await tester.pumpAndSettle();
      final scope = ProviderScope.containerOf(
        tester.element(find.byType(SubtitleDownloadFields)),
      );
      final l10n = tester.element(find.byType(SubtitleDownloadFields)).vhl;
      await tester.tap(find.text('Français'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('العربية'));
      await tester.pumpAndSettle();
      expect(scope.read(settingsProvider).subtitleLangs, ['en', 'fr']);
      await tester.tap(find.text('English'));
      await tester.tap(find.text('Français'));
      await tester.pumpAndSettle();
      expect(scope.read(settingsProvider).subtitleLangs, ['fr']);

      await tester.tap(find.text(l10n.embedSubtitles));
      await tester.pumpAndSettle();
      expect(scope.read(settingsProvider).tuning.embedSubtitles, isTrue);

      // Subtitles off: the languages leave with them.
      await tester.tap(find.text(l10n.mobileSubtitles));
      await tester.pumpAndSettle();
      expect(find.byType(SubtitleDownloadFields), findsNothing);
    });

    testWidgets('**device matrix**: Downloads holds while restricted', (
      tester,
    ) async {
      await expectNoOverflow(tester, () => downloads(_Battery(free: false)));
    });
  });
}

/// Android's answer, scripted: restricted until asked, allowed after.
class _Battery implements BatteryFreedom {
  _Battery({required this.free});

  bool free;
  var asked = 0;

  @override
  Future<bool> isFree() async => free;

  @override
  Future<bool> ask() async {
    asked++;
    return free = true;
  }
}
