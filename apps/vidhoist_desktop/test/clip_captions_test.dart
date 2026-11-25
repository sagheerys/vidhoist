import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vidhoist_desktop/data/appearance_data.dart';
import 'package:vidhoist_desktop/data/subtitles_data.dart';
import 'package:vidhoist_desktop/data/transcripts_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/features/clip/clip_stage.dart';
import 'package:vidhoist_desktop/features/clip/video_controls.dart';
import 'package:vidhoist_desktop/router.dart';
import 'package:vidhoist_desktop/shell/sidebar.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_transcripts/vh_transcripts.dart';

import 'support/shell_harness.dart';

const _url = 'https://youtu.be/aaaaaaaaaaa';

final _clip = LibraryItem(
  canonicalUrl: _url,
  title: 'Homelab Hour - Ep. 12',
  serverFilename: 'homelab.mp4',
  timestamp: DateTime(2026, 10, 20),
  duration: const Duration(minutes: 12),
);

final _said = Transcript(
  canonicalUrl: _url,
  language: 'en',
  source: 'sidecar',
  fetchedAt: DateTime(2026, 10, 24),
  segments: [
    TranscriptSegment(
      start: Duration.zero,
      end: const Duration(seconds: 6),
      text: 'The pool keeps the pool warm.',
    ),
  ],
);

void main() {
  /// Brings the picture's controls up, as the pointer over it does: they
  /// wait for it, paused or playing. One mouse per test, nudged each time.
  TestGesture? mouse;
  setUp(() => mouse = null);
  Future<void> wake(WidgetTester tester) async {
    final at = tester.getCenter(find.byType(ClipVideoControls));
    if (mouse == null) {
      final added = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(added.removePointer);
      await added.addPointer(location: at);
      mouse = added;
    }
    await mouse!.moveTo(at + const Offset(4, 4));
    await mouse!.moveTo(at);
    await tester.pumpAndSettle();
  }

  Future<ShellHarness> watching(WidgetTester tester) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    final h = ShellHarness(
      library: [_clip],
      withEngine: true,
      transcripts: {_url: _said},
    );
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    h.player.showPlaying([toPlaylistItem(_clip)], playing: false);
    GoRouter.of(tester.element(find.byType(DesktopSidebar)))
        .go(DesktopRoutes.item(_url));
    await tester.pumpAndSettle();
    return h;
  }

  Finder onPicture() => find.descendant(
    of: find.byType(VhCaptionsLayer),
    matching: find.text('The pool keeps the pool warm.'),
  );

  testWidgets('**the guard**: CC puts the transcript over the picture, and '
      'takes it off again', (tester) async {
    final h = await watching(tester);
    expect(find.byType(VhCaptionsLayer), findsOneWidget);
    expect(onPicture(), findsNothing);
    await wake(tester);
    await tester.tap(find.bySemanticsLabel('Show subtitles'));
    await tester.pumpAndSettle();
    expect(onPicture(), findsOneWidget);
    expect(await h.store.getBool(DesktopSubtitles.key), isTrue);
    await wake(tester);
    await tester.tap(find.bySemanticsLabel('Hide subtitles'));
    await tester.pumpAndSettle();
    expect(onPicture(), findsNothing);
  });

  testWidgets('C does the same from the keyboard', (tester) async {
    await watching(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
    await tester.pumpAndSettle();
    expect(onPicture(), findsOneWidget);
  });

  final arabic = Transcript(
    canonicalUrl: _url,
    language: 'ar',
    source: 'sidecar',
    fetchedAt: DateTime(2026, 10, 24),
    segments: [
      TranscriptSegment(
        start: Duration.zero,
        end: const Duration(seconds: 6),
        text: 'المسبح يدفئ المسبح.',
      ),
    ],
  );

  Future<ShellHarness> twoLanguages(WidgetTester tester) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    final h = ShellHarness(
      library: [_clip],
      withEngine: true,
      transcripts: {_url: _said},
      overrides: [
        transcriptLanguagesProvider.overrideWith(
          (ref, url) async => [arabic, _said],
        ),
      ],
    );
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    h.player.showPlaying([toPlaylistItem(_clip)], playing: false);
    GoRouter.of(tester.element(find.byType(DesktopSidebar)))
        .go(DesktopRoutes.item(_url));
    await tester.pumpAndSettle();
    await wake(tester);
    await tester.tap(find.bySemanticsLabel('Show subtitles'));
    await tester.pumpAndSettle();
    return h;
  }

  Finder said(String text) => find.descendant(
    of: find.byType(VhCaptionsLayer),
    matching: find.text(text),
  );

  testWidgets('**the guard**: a clip in two languages switches between them '
      'from the language button, as on the phone, and keeps the choice', (
    tester,
  ) async {
    final h = await twoLanguages(tester);
    expect(said('The pool keeps the pool warm.'), findsOneWidget);
    await wake(tester);
    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();
    expect(said('المسبح يدفئ المسبح.'), findsOneWidget);
    expect(find.text('AR'), findsOneWidget);
    expect(await h.store.getString(DesktopSubtitles.languageKey), 'ar');
  });

  testWidgets('**the guard**: the size and the background are chosen on the '
      'picture too, and kept', (tester) async {
    final h = await twoLanguages(tester);
    await wake(tester);
    await tester.tap(find.bySemanticsLabel('Subtitle options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Text size · Large'));
    await tester.pumpAndSettle();
    expect(await h.store.getInt(DesktopSubtitles.sizeKey), 2);
    await wake(tester);
    await tester.tap(find.bySemanticsLabel('Subtitle options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Background · None'));
    await tester.pumpAndSettle();
    expect(await h.store.getInt(DesktopSubtitles.backgroundKey), 2);
    final layer = tester.widget<VhCaptionsLayer>(find.byType(VhCaptionsLayer));
    expect(layer.captions.scale, DesktopSubtitles.scales[2]);
    expect(layer.captions.background, VhCaptionBackground.none);
  });

  test('**the guard**: an Arabic reader gets the Arabic subtitles first, by '
      "the app's language, not Windows'", () async {
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        initialAppearanceProvider.overrideWithValue((
          theme: ThemeMode.system,
          locale: 'ar',
        )),
        transcriptForProvider.overrideWith((ref, key) async => _said),
        transcriptLanguagesProvider.overrideWith(
          (ref, url) async => [_said, arabic],
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(transcriptForProvider(_url).future);
    await c.read(transcriptLanguagesProvider(_url).future);
    expect(c.read(captionTracksProvider(_url))!.keys, ['ar', 'en']);
    expect(readerLanguages('ar'), ['ar', 'en']);
  });

  test('**the guard**: theater is the larger picture, the page\'s whole '
      'height', () {
    const width = 1600.0;
    const height = 760.0;
    expect(
      stageWidth(width, height, theater: true),
      greaterThan(stageWidth(width, height)),
    );
  });
}
