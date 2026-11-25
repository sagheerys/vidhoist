import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/features/clip/clip_page.dart';
import 'package:vidhoist_desktop/features/stats/stats_bars.dart';
import 'package:vidhoist_desktop/features/stats/stats_page.dart';
import 'package:vidhoist_desktop/router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_media/vh_media.dart' show PlaybackPositionStore;
import 'package:vh_ui/vh_ui.dart';

import 'support/shell_harness.dart';

const _mb = 1024 * 1024;

LibraryItem _clip(
  String id, {
  String? channel,
  int mb = 0,
  DateTime? added,
  String site = 'https://youtu.be/',
}) => LibraryItem(
  canonicalUrl: '$site$id',
  title: 'Clip $id',
  uploader: channel,
  sizeBytes: mb * _mb,
  duration: const Duration(minutes: 30),
  timestamp: added ?? DateTime(2026, 10, 1),
);

void main() {
  testWidgets('**the guard**: what the history does not say is not shown as '
      'if it were: no running time when most lengths are unknown, no '
      'channels when none is named', (tester) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    final h = ShellHarness(
      library: [
        for (final id in ['aaaaaaaaaaa', 'bbbbbbbbbbb', 'ccccccccccc'])
          LibraryItem(
            canonicalUrl: 'https://youtu.be/$id',
            title: 'Clip $id',
            sizeBytes: _mb,
            duration: id == 'aaaaaaaaaaa' ? const Duration(hours: 2) : null,
            timestamp: DateTime(2026, 10, 1),
          ),
      ],
      withEngine: true,
    );
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Statistics'));
    await tester.pumpAndSettle();
    expect(find.byType(StatsPage), findsOneWidget);
    expect(find.text('Running time'), findsNothing);
    expect(find.text('By channel'), findsNothing);
    expect(find.text('By site'), findsOneWidget);
  });

  group('the page', () {
    final items = [
      _clip('aaaaaaaaaaa', channel: 'Rivers', mb: 300),
      _clip('bbbbbbbbbbb', channel: 'Hills', mb: 900),
    ];

    Future<ShellHarness> open(WidgetTester tester) async {
      ShellHarness.useWindow(tester, const Size(1440, 900));
      final h = ShellHarness(library: items, withEngine: true);
      // Clip a was played here once.
      await PlaybackPositionStore(
        store: h.store,
        mutex: PrefsMutex(),
        clock: DateTime.now,
      ).save(items.first.canonicalUrl, const Duration(minutes: 1));
      await tester.pumpWidget(h.app());
      await tester.pumpAndSettle();
      return h;
    }

    testWidgets('**the guard**: the library\'s counts lead to the figures, '
        'and a suggestion opens a clip without deleting anything', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(find.bySemanticsLabel('Statistics'));
      await tester.pumpAndSettle();
      expect(find.byType(StatsPage), findsOneWidget);
      expect(find.text('Library statistics'), findsOneWidget);
      // Two clips, 1.2 GB, an hour, none with a transcript, one unplayed.
      for (final figure in [
        '2',
        vhFormatSize(1200 * _mb),
        '1 hour',
        vhLtrRun('0%'),
        '1',
      ]) {
        expect(find.text(figure), findsWidgets, reason: figure);
      }
      // **The guard**: the figures share one frame; no figure has a box of
      // its own.
      expect(find.byType(StatsFigures), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(StatsTile),
          matching: find.byWidgetPredicate(
            (w) =>
                w is Container &&
                w.decoration is BoxDecoration &&
                (w.decoration! as BoxDecoration).border != null,
          ),
        ),
        findsNothing,
      );
      // The never played: b alone, a was played.
      final never = find.ancestor(
        of: find.text('Never played here'),
        matching: find.byType(StatsSuggestion),
      );
      final unplayed = find.descendant(
        of: never,
        matching: find.text('Clip bbbbbbbbbbb'),
      );
      expect(unplayed, findsOneWidget);
      expect(
        find.descendant(of: never, matching: find.text('Clip aaaaaaaaaaa')),
        findsNothing,
      );
      await tester.ensureVisible(unplayed);
      await tester.pumpAndSettle();
      await tester.tap(unplayed);
      await tester.pumpAndSettle();
      expect(find.byType(ClipPage), findsOneWidget);
    });

    testWidgets('**the guard**: a library refresh keeps the page and where '
        'it was read', (tester) async {
      // Every refresh swapped the page for a spinner, so a reader scrolled
      // down was thrown back to the top.
      ShellHarness.useWindow(tester, const Size(960, 600));
      final libraryChanged = StateProvider<int>((ref) => 0);
      // A recount that takes a while, as with a large library: the first
      // count is immediate, every later one waits for [slow].
      final slow = Completer<void>();
      var counts = 0;
      final h = ShellHarness(
        library: items,
        withEngine: true,
        overrides: [
          libraryStatsProvider.overrideWith((ref) async {
            ref.watch(libraryChanged);
            if (counts++ > 0) await slow.future;
            return statsOf(items, hasText: (_) => false, played: (_) => false);
          }),
        ],
      );
      await tester.pumpWidget(h.app());
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('Statistics'));
      await tester.pumpAndSettle();
      final page = find.descendant(
        of: find.byType(StatsPage),
        matching: find.byType(Scrollable),
      );
      tester.state<ScrollableState>(page.first).position.jumpTo(120);
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(StatsPage)),
      );
      // What the app does: the library under the figures changes.
      container.read(libraryChanged.notifier).state++;
      await tester.pump();
      expect(
        find.descendant(
          of: find.byType(StatsPage),
          matching: find.byType(VhSpinner),
        ),
        findsNothing,
      );
      slow.complete();
      await tester.pumpAndSettle();
      expect(tester.state<ScrollableState>(page.first).position.pixels, 120);
    });

    testWidgets('the palette has the page too, and the library stays lit in '
        'the sidebar', (tester) async {
      await open(tester);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, '>statistics');
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.byType(StatsPage), findsOneWidget);
      expect(placeOf(Uri.parse(DesktopRoutes.stats)), DesktopPlace.library);
    });

    testWidgets('every control on the page has a name', (tester) async {
      final semantics = tester.ensureSemantics();
      await open(tester);
      await tester.tap(find.bySemanticsLabel('Statistics'));
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
    });
  });

  testWidgets('**the guard**: with a large font the figures stay whole, the '
      'bar gives way, and every bar starts at the same place', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 400);
    addTearDown(tester.view.reset);
    const rows = <StatsBar>[
      (label: 'Southern Lens', measure: 462, value: '3 clips · 462.1 MB'),
      (label: 'Home Kitchen', measure: 145, value: '3 clips · 145.0 MB'),
      (label: 'Ro', measure: 462, value: '3 clips · 462.1 MB'),
    ];
    await tester.pumpWidget(
      MaterialApp(
        theme: vhTheme(VhVariant.desktop, Brightness.light),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
          child: Scaffold(
            // The test font's letters are wider than the app's: this is the
            // room half a 1280 window's page gives the app's own font.
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(width: 800, child: StatsBars(rows: rows)),
            ),
          ),
        ),
      ),
    );
    for (final row in rows) {
      final value = find.text(row.value).first;
      expect(
        tester.renderObject<RenderParagraph>(value).didExceedMaxLines,
        isFalse,
        reason: row.value,
      );
    }
    final names = {
      for (final row in rows) tester.getSize(find.text(row.label)).width,
    };
    // One column for the names, so every bar starts at the same place.
    expect(names, hasLength(1));
  });
}
