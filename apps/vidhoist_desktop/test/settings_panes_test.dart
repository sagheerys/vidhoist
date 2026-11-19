import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vidhoist_desktop/features/settings/appearance_pane.dart';
import 'package:vidhoist_desktop/features/settings/appearance_preview.dart';
import 'package:vidhoist_desktop/data/choices_data.dart';
import 'package:vidhoist_desktop/data/transcripts_data.dart';
import 'package:vidhoist_desktop/data/update_data.dart';
import 'package:vidhoist_desktop/features/add/add_options.dart';
import 'package:vidhoist_desktop/shell/sidebar.dart';
import 'package:vidhoist_desktop/shell/sidebar_items.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vh_transcripts/vh_transcripts.dart';

import 'support/shell_harness.dart';

/// Lets real file reads finish between frames.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 30; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

String _latest(String version) => jsonEncode({
  'tag_name': 'v$version',
  'body': '## Fixed\n- Faster start.',
  'assets': [
    {
      'name': installerNameFor(version),
      'browser_download_url':
          'https://github.com/x/y/releases/download/v1/setup.exe',
      'size': 28000000,
    },
  ],
});

void main() {
  Future<ShellHarness> open(
    WidgetTester tester,
    String to, {
    Size? workArea,
    Size window = const Size(1440, 900),
    List<Override> overrides = const [],
  }) async {
    ShellHarness.useWindow(tester, window);
    final h = ShellHarness(
      library: const [],
      withEngine: true,
      workArea: workArea,
      overrides: [
        installedVersionProvider.overrideWith((ref) async => '0.1.0'),
        ...overrides,
      ],
    );
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    GoRouter.of(tester.element(find.byType(DesktopSidebar))).go(to);
    await tester.pumpAndSettle();
    return h;
  }

  group('appearance', () {
    testWidgets('**the guard**: night chosen here turns the app dark and '
        'is kept', (tester) async {
      final h = await open(tester, '/settings/appearance');
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.dark);
      // **The guard**: the setting shows what it makes, beside it.
      expect(find.byType(AppearancePreview), findsOneWidget);
      expect(await h.store.getString('ember_theme'), 'dark');
    });

    testWidgets('a language chosen here replaces Windows\' own', (
      tester,
    ) async {
      final h = await open(tester, '/settings/appearance');
      await tester.tap(find.text('العربية'));
      await tester.pumpAndSettle();
      expect(find.text('المظهر واللغة'), findsWidgets);
      expect(await h.store.getString('ember_locale'), 'ar');
    });

    testWidgets('**the guard**: the preview stands right beside the '
        'choices, not across an empty middle', (tester) async {
      // The test font is wide enough for the size hint alone to fill the
      // column; at half its size the words are shorter than the room.
      tester.platformDispatcher.textScaleFactorTestValue = 0.5;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await open(
        tester,
        '/settings/appearance',
        window: const Size(2560, 1440),
      );
      final preview = tester.getRect(find.byType(AppearancePreview));
      final words = find.descendant(
        of: find.byType(ChoiceGroup),
        matching: find.byWidgetPredicate(
          (w) => w is Text || w is DesktopSegments,
        ),
      );
      final widest = [
        for (final e in words.evaluate())
          tester.getRect(find.byWidget(e.widget)).right,
      ].reduce((a, b) => a > b ? a : b);
      expect(preview.left - widest, lessThanOrEqualTo(VhSpace.xxl + 1));
    });

    testWidgets('a size this screen cannot hold cannot be chosen', (
      tester,
    ) async {
      final h = await open(
        tester,
        '/settings/appearance',
        workArea: const Size(1093, 566),
      );
      await tester.tap(find.text('150%'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(await h.store.getString('ember_ui_zoom'), isNot('1.5'));
      await tester.tap(find.text('80%'));
      await tester.pumpAndSettle();
      expect(await h.store.getString('ember_ui_zoom'), '0.8');
    });
  });

  group('downloads', () {
    testWidgets('the default quality is kept, and an add starts with it', (
      tester,
    ) async {
      final h = await open(tester, '/settings/downloads');
      await tester.tap(find.text('Audio').first);
      await tester.pumpAndSettle();
      expect(await h.store.getString('video_quality'), 'audio');
      final choice = AddChoice.startingWith(Quality.audio);
      expect(choice.audio, isTrue);
      expect(AddChoice.startingWith(Quality.q720).quality, Quality.q720);
    });

    testWidgets('the list says the quality under Downloads', (tester) async {
      await open(
        tester,
        '/settings/engine',
        overrides: [
          initialDefaultQualityProvider.overrideWithValue(Quality.q1080),
        ],
      );
      expect(find.text('Up to 1080p'), findsOneWidget);
    });
  });

  testWidgets('subscriptions: not in this version, and Channels is one '
      'click away', (tester) async {
    await open(tester, '/settings/subscriptions');
    final l = lookupVhLocalizations(const Locale('en'));
    expect(find.text(l.desktopChannelsLater), findsWidgets);
    await tester.tap(find.text('Open channels'));
    await tester.pumpAndSettle();
    final router = GoRouter.of(tester.element(find.byType(DesktopSidebar)));
    expect(router.state.uri.path, '/channels');
  });

  testWidgets('transcripts: counted, and all deleted only after asking', (
    tester,
  ) async {
    final dir = Directory.systemTemp.createTempSync('ember_words_');
    addTearDown(() {
      if (dir.existsSync()) dir.deleteSync(recursive: true);
    });
    final store = TranscriptStore(dir);
    await tester.runAsync(
      () => store.write(
        Transcript(
          canonicalUrl: 'https://youtu.be/aaaaaaaaaaa',
          language: 'en',
          source: 'sidecar',
          fetchedAt: DateTime(2026, 10, 24),
          segments: const [
            TranscriptSegment(
              start: Duration.zero,
              end: Duration(seconds: 3),
              text: 'said here',
            ),
          ],
        ),
      ),
    );
    await open(
      tester,
      '/settings/transcripts',
      overrides: [transcriptStoreProvider.overrideWithValue(store)],
    );
    await settle(tester);
    expect(find.text('1 clip'), findsWidgets);

    await tester.tap(find.text('Delete all').last);
    await tester.pumpAndSettle();
    expect(find.text('Delete every transcript?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(dir.existsSync(), isTrue);

    await tester.tap(find.text('Delete all').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete all').last);
    await settle(tester);
    expect(dir.existsSync(), isFalse);
    expect(find.text('No clips yet'), findsWidgets);
  });

  testWidgets('**the guard**: a row that does something carries a button\'s '
      'shape, and one that leads elsewhere stays a link', (tester) async {
    await open(tester, '/settings/updates');
    expect(find.widgetWithText(OutlinedButton, 'Check now'), findsOneWidget);
    GoRouter.of(tester.element(find.byType(DesktopSidebar)))
        .go('/settings/backup');
    await tester.pumpAndSettle();
    // Bold text alone read as the row's value, not as something to press.
    expect(find.widgetWithText(OutlinedButton, 'Back up now'), findsOneWidget);
    GoRouter.of(tester.element(find.byType(DesktopSidebar)))
        .go('/settings/subscriptions');
    await tester.pumpAndSettle();
    expect(find.byType(VhLinkButton), findsWidgets);
    expect(find.byType(OutlinedButton), findsNothing);
  });

  testWidgets('**the guard**: a version found keeps a dot on Settings in the '
      'sidebar until it is installed or skipped, with no Later to lose it', (
    tester,
  ) async {
    await open(
      tester,
      '/settings/updates',
      overrides: [
        updateCheckerProvider.overrideWithValue(
          UpdateChecker(
            assetMarker: 'vidhoist',
            assetExtension: '.exe',
            fetch: (_) async => _latest('0.2.0'),
          ),
        ),
      ],
    );
    SidebarItem settings() => tester.widget<SidebarItem>(
      find.widgetWithText(SidebarItem, 'Settings'),
    );
    expect(settings().dot, isNull);
    await tester.tap(find.text('Check now'));
    await settle(tester);
    expect(settings().dot, 'Version 0.2.0 is available');
    expect(find.text('Later'), findsNothing);
    await tester.tap(find.text('Skip this version'));
    await settle(tester);
    expect(settings().dot, isNull);
  });

  testWidgets('updates: a version found shows its notes and can be skipped', (
    tester,
  ) async {
    final h = await open(
      tester,
      '/settings/updates',
      overrides: [
        updateCheckerProvider.overrideWithValue(
          UpdateChecker(
            assetMarker: 'vidhoist',
            assetExtension: '.exe',
            fetch: (_) async => _latest('0.2.0'),
          ),
        ),
      ],
    );
    await tester.tap(find.text('Check now'));
    await settle(tester);
    expect(find.text('Version 0.2.0 is available'), findsWidgets);
    expect(find.textContaining('Faster start.'), findsOneWidget);
    expect(find.text('Install and restart'), findsOneWidget);

    await tester.tap(find.text('Skip this version'));
    await settle(tester);
    expect(find.text('Install and restart'), findsNothing);
    expect(await h.store.getString(UpdatePrefs.skippedVersionKey), '0.2.0');
  });
}
