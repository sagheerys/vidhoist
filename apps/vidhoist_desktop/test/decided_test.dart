import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vidhoist_desktop/data/library_data.dart';
import 'package:vidhoist_desktop/data/transcripts_data.dart';
import 'package:vidhoist_desktop/data/volume.dart';
import 'package:vidhoist_desktop/features/reading/reading_find.dart';
import 'package:vidhoist_desktop/router.dart';
import 'package:vidhoist_desktop/shell/player_bar.dart';
import 'package:vidhoist_desktop/shell/right_panel.dart';
import 'package:vidhoist_desktop/shell/ember_slider.dart';
import 'package:vidhoist_desktop/shell/engine_line.dart';
import 'package:vidhoist_desktop/shell/sidebar.dart';
import 'package:vidhoist_desktop/shell/volume_slider.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_media/library.dart';
import 'package:mt_transcripts/mt_transcripts.dart';

import 'support/shell_harness.dart';

const _url = 'https://youtu.be/aaaaaaaaaaa';

final _entry = LibraryItem(
  canonicalUrl: _url,
  title: 'Night Drive',
  uploader: 'Field Notes',
  onServer: true,
  serverFilename: 'Night Drive.mp4',
  timestamp: DateTime(2026, 10, 20),
);

Transcript _said(String language, String text) => Transcript(
  canonicalUrl: _url,
  language: language,
  source: 'sidecar',
  fetchedAt: DateTime(2026, 10, 24),
  segments: [
    TranscriptSegment(
      start: const Duration(seconds: 1),
      end: const Duration(seconds: 4),
      text: text,
    ),
  ],
);

void main() {
  Future<ShellHarness> open(
    WidgetTester tester, {
    Size window = const Size(1440, 900),
    bool playing = true,
    List<Override> overrides = const [],
  }) async {
    ShellHarness.useWindow(tester, window);
    final h = ShellHarness(
      library: [_entry],
      withEngine: true,
      transcripts: {_url: _said('en', 'The pool keeps the pool warm.')},
      overrides: overrides,
    );
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    if (playing) {
      h.player.showPlaying([toPlaylistItem(_entry)], playing: false);
      await tester.pumpAndSettle();
    }
    return h;
  }

  ProviderContainer containerOf(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(EmberSidebar)));

  void go(WidgetTester tester, String to) =>
      GoRouter.of(tester.element(find.byType(EmberSidebar))).go(to);

  testWidgets('the player bar\'s heart marks what plays a favourite', (
    tester,
  ) async {
    final h = await open(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(EmberPlayerBar),
        matching: byLabel('Add to favorites'),
      ),
    );
    await tester.pumpAndSettle();
    final tags = await containerOf(tester).read(tagsIndexProvider).tagsOf(_url);
    expect(tags, contains(MTConstants.favoritesSystemTag));
    expect(h.player.calls, isNot(contains('playItems')));
  });

  testWidgets('the volume slider sets the level and keeps it', (tester) async {
    final h = await open(tester);
    final slider = find.descendant(
      of: find.byType(EmberVolumeSlider),
      matching: find.byType(EmberSlider),
    );
    tester.widget<EmberSlider>(slider).onChanged!(30);
    await tester.pumpAndSettle();
    expect(containerOf(tester).read(volumeProvider), 30);
    expect(await h.store.getInt(VolumeLevel.key), 30);
  });

  testWidgets('**the guard**: Ctrl+F finds in the side panel\'s transcript, '
      'not the window\'s search', (tester) async {
    await open(tester);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    final bar = find.descendant(
      of: find.byType(EmberRightPanel),
      matching: find.byType(ReadingFindBar),
    );
    expect(bar, findsOneWidget);
    await tester.enterText(
      find.descendant(of: bar, matching: find.byType(TextField)),
      'pool',
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('1 of 2'), findsOneWidget);
  });

  testWidgets('the reading room offers each language kept, and shows the '
      'one chosen', (tester) async {
    await open(
      tester,
      playing: false,
      overrides: [
        transcriptLanguagesProvider.overrideWith(
          (ref, url) async => [
            _said('en', 'The pool keeps the pool warm.'),
            _said('ar', 'يبقي الحوض دافئاً.'),
          ],
        ),
      ],
    );
    go(tester, EmberRoutes.reading(_url));
    await tester.pumpAndSettle();
    expect(find.textContaining('The pool keeps'), findsWidgets);
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();
    expect(find.textContaining('يبقي الحوض'), findsWidgets);
  });

  testWidgets('**the guard**: the sidebar\'s foot is the engine, not the '
      'server\'s address', (tester) async {
    await open(tester, playing: false);
    expect(find.byType(SidebarEngineLine), findsOneWidget);
    expect(find.textContaining('8081'), findsNothing);
  });

  testWidgets('a section below the list\'s fold is brought into view', (
    tester,
  ) async {
    await open(tester, window: const Size(960, 600), playing: false);
    go(tester, '/settings/about');
    await tester.pumpAndSettle();
    // The page's title and the list's entry.
    expect(find.text('About').hitTestable(), findsNWidgets(2));
  });

  testWidgets('**the guard**: and again when the window takes another size, '
      'as it does a moment after it opens', (tester) async {
    await open(tester, window: const Size(1440, 1000), playing: false);
    go(tester, '/settings/about');
    await tester.pumpAndSettle();
    ShellHarness.useWindow(tester, const Size(960, 600));
    await tester.pumpAndSettle();
    expect(find.text('About').hitTestable(), findsNWidgets(2));
  });
}
