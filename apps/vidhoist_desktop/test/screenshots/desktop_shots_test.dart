@Tags(['shots'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_transcripts/vh_transcripts.dart';
import 'package:vh_ui/shots.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/platform/engine_locator.dart';
import 'package:vidhoist_desktop/router.dart';
import 'package:vidhoist_desktop/shell/sidebar.dart';

import '../support/shell_harness.dart';

/// **The Windows app's screenshots for the project's pages**, as the
/// phone's are made: the app's own widgets and fonts, and covers drawn for
/// the purpose (`tool/screenshots/make_covers.py`).
///
/// Not part of the test run: `VH_SHOTS=1 flutter test test/screenshots`
/// writes them to `docs/screenshots/`.
void main() {
  final enabled = Platform.environment['VH_SHOTS'] != null;
  final root = Directory.current.parent.parent.path;
  final covers = '$root/tool/screenshots/covers';
  final out = '$root/docs/screenshots';

  setUpAll(() async {
    if (!enabled) return;
    await loadVhFonts('$root/packages/vh_ui/assets/fonts');
    initVhL10n();
  });

  List<LibraryItem> library(bool arabic) => [
    for (final (i, (title, cover, minutes, audio))
        in (arabic ? _arabicClips : _englishClips).indexed)
      LibraryItem(
        canonicalUrl: 'https://vimeo.com/90000$i',
        title: title,
        uploader: arabic ? _arabicChannels[i % 3] : _englishChannels[i % 3],
        thumbnail: '$covers/$cover.jpg',
        serverFilename: 'clip$i.${audio ? 'm4a' : 'mp4'}',
        timestamp: DateTime.now().subtract(Duration(hours: 3 + i * 9)),
        sizeBytes: (minutes * 9.5 * 1000000).round(),
        isAudio: audio,
        duration: Duration(minutes: minutes, seconds: 7 + i * 6),
      ),
  ];

  Transcript said(String url, bool arabic) => Transcript(
    canonicalUrl: url,
    language: arabic ? 'ar' : 'en',
    source: 'captions',
    fetchedAt: DateTime.now(),
    segments: [
      for (final (i, line) in (arabic ? _arabicLines : _englishLines).indexed)
        TranscriptSegment(
          start: Duration(seconds: i * 7),
          end: Duration(seconds: i * 7 + 6),
          text: line,
        ),
    ],
  );

  Future<void> shoot(
    WidgetTester tester,
    ShellHarness h,
    String name, {
    String? route,
    bool arabic = false,
    void Function()? before,
  }) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    if (arabic) ShellHarness.useArabic(tester);
    // Real shadows: tests draw each as a black outline otherwise.
    debugDisableShadows = false;
    await tester.pumpWidget(
      RepaintBoundary(key: const ValueKey('shot'), child: h.app()),
    );
    await tester.pumpAndSettle();
    before?.call();
    if (route != null) {
      GoRouter.of(tester.element(find.byType(DesktopSidebar))).go(route);
      await tester.pumpAndSettle();
    }
    // Covers are files: read and decoded outside the test's clock.
    for (var i = 0; i < 12; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 250)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey('shot')),
    );
    await tester.runAsync(
      () => saveVhShot(boundary, '$out/$name.png', pixelRatio: 1),
    );
    debugDisableShadows = true;
  }

  for (final lang in ['ar', 'en']) {
    for (final night in [false, true]) {
      final arabic = lang == 'ar';
      final tag = '$lang-${night ? 'night' : 'day'}';

      testWidgets('library $tag', skip: !enabled, (tester) async {
        final h = ShellHarness(
          library: library(arabic),
          withEngine: true,
          night: night,
          overrides: _engineReady(),
        );
        await shoot(tester, h, 'windows-library-$tag', arabic: arabic);
      });

      testWidgets('clip $tag', skip: !enabled, (tester) async {
        final items = library(arabic);
        final clip = items.first;
        final h = ShellHarness(
          library: items,
          withEngine: true,
          night: night,
          overrides: _engineReady(),
          transcripts: {clip.canonicalUrl: said(clip.canonicalUrl, arabic)},
        );
        await shoot(
          tester,
          h,
          'windows-clip-$tag',
          route: DesktopRoutes.item(clip.canonicalUrl),
          arabic: arabic,
          // The transcript beside it is the playing clip's.
          before: () =>
              h.player.showPlaying([toPlaylistItem(clip)], playing: false),
        );
      });

      testWidgets('appearance $tag', skip: !enabled, (tester) async {
        final h = ShellHarness(
          library: library(arabic),
          withEngine: true,
          night: night,
          overrides: _engineReady(),
        );
        await shoot(
          tester,
          h,
          'windows-appearance-$tag',
          route: DesktopSettingsPane.appearance.route,
          arabic: arabic,
        );
      });
    }
  }
}

/// The engine found, as on a computer set up: its line in the sidebar is
/// then quiet rather than a warning.
List<Override> _engineReady() => [
  engineLocatorProvider.overrideWithValue(
    EngineLocator(
      ownFolder: r'C:\e',
      pathFolders: const [],
      exists: (_) => true,
    ),
  ),
  downloadBackendProvider.overrideWithValue(FakeBackend()),
];

const _arabicClips = [
  ('رحلة إلى جبال السروات في موسم الضباب', 'mountains', 14, false),
  ('إبحار هادئ على ساحل البحر الأحمر', 'sea', 9, false),
  ('المدينة في الليل: جولة بين الأبراج', 'city', 22, false),
  ('طبق الخضار المشوي في عشر دقائق', 'kitchen', 6, false),
  ('ألحان المساء', 'music', 4, true),
  ('كثبان الربع الخالي عند الغروب', 'desert', 18, false),
  ('غابات الشمال: نزهة طويلة', 'forest', 31, false),
  ('ألوان الشفق القطبي', 'aurora', 3, false),
  ('غروب على الشاطئ', 'sunset', 11, false),
];

const _englishClips = [
  ('Into the misty mountains at dawn', 'mountains', 14, false),
  ('A quiet sail along the coast', 'sea', 9, false),
  ('The city at night: a walk between towers', 'city', 22, false),
  ('Roasted vegetables in ten minutes', 'kitchen', 6, false),
  ('Evening tunes', 'music', 4, true),
  ('Dunes of the Empty Quarter at sunset', 'desert', 18, false),
  ('Northern forests: a long hike', 'forest', 31, false),
  ('Colours of the aurora', 'aurora', 3, false),
  ('Sunset on the shore', 'sunset', 11, false),
];

const _arabicChannels = ['عدسة الجنوب', 'مطبخ البيت', 'رحّالة'];
const _englishChannels = ['Southern Lens', 'Home Kitchen', 'The Wanderer'];

const _arabicLines = [
  'نبدأ الرحلة قبل الفجر، والضباب يغطي الوادي كله.',
  'كلما صعدنا قليلاً انكشفت القمم واحدة بعد الأخرى.',
  'هذه أشجار العرعر، وعمر بعضها مئات السنين.',
  'نتوقف هنا لنشرب القهوة وننتظر شروق الشمس.',
  'وها هو الضوء الأول يلامس السحاب من تحتنا.',
  'في الحلقة القادمة ننزل إلى القرى الحجرية القديمة.',
];

const _englishLines = [
  'We set out before dawn, with mist filling the whole valley.',
  'With every turn of the path another peak comes into view.',
  'These are juniper trees, some of them hundreds of years old.',
  'We stop here for coffee and wait for the sun to rise.',
  'And there is the first light, touching the clouds below us.',
  'Next time we walk down to the old stone villages.',
];
