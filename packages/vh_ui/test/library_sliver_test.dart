import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// **The library's modes on a tablet**:
/// cards and compact rows gain columns, the list becomes a table, and a
/// phone keeps exactly the single column it had.
void main() {
  const count = 12;

  Widget item(VhLibraryLayout layout, int i, VhMediaColumns? columns) {
    final key = Key('item-$i');
    final title = i.isEven
        ? 'Homelab Hour — Ep. 12: Backups that actually restore'
        : 'رحلة إلى جبال السروات';
    if (columns != null) {
      return VhMediaRow(
        key: key,
        columns: columns,
        title: title,
        subtitle: 'Homelab Hour',
        duration: '1:02:33',
        size: '412.7 MB',
        added: '14 hours ago',
        tags: const ['homelab', 'backup'],
        favorite: i == 0,
        onFavoriteToggle: () {},
        onMore: () {},
      );
    }
    return switch (layout) {
      VhLibraryLayout.cards || VhLibraryLayout.grid => VhMediaGridCard(
        key: key,
        feed: layout == VhLibraryLayout.cards,
        title: title,
        subtitle: 'Homelab Hour · 14 hours ago',
        duration: '3:10',
        onMore: () {},
      ),
      _ => VhMediaCard(
        key: key,
        compact: layout == VhLibraryLayout.compact,
        title: title,
        subtitle: 'Homelab Hour · 14 hours ago',
        onMore: () {},
      ),
    };
  }

  /// [window] is the screen; [library] is the width the library actually
  /// has beside the rail and, when open, the player panel.
  Future<void> pump(
    WidgetTester tester,
    VhLibraryLayout layout, {
    Size window = const Size(1280, 800),
    double? library,
    double scale = 1,
    bool location = true,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = window;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: vhTheme(VhVariant.desktop, Brightness.light),
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: Scaffold(
          body: Align(
            alignment: AlignmentDirectional.topStart,
            child: SizedBox(
              width: library ?? window.width,
              child: CustomScrollView(
                slivers: [
                  VhLibrarySliver(
                    layout: layout,
                    itemCount: count,
                    showLocation: location,
                    itemBuilder: (context, i, columns) =>
                        item(layout, i, columns),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// How many items share the first item's row.
  int perRow(WidgetTester tester) {
    final top = tester.getTopLeft(find.byKey(const Key('item-0'))).dy;
    var n = 0;
    for (var i = 0; i < count; i++) {
      final found = find.byKey(Key('item-$i'));
      if (found.evaluate().isEmpty) break;
      if (tester.getTopLeft(found).dy == top) n++;
    }
    return n;
  }

  group('a phone keeps one column', () {
    for (final layout in VhLibraryLayout.values.where(
      (l) => l != VhLibraryLayout.grid,
    )) {
      testWidgets(layout.name, (tester) async {
        await pump(tester, layout, window: const Size(411, 914));
        expect(perRow(tester), 1);
        expect(find.byType(VhMediaRowHeader), findsNothing);
        expect(find.byType(VhMediaRow), findsNothing);
      });
    }
  });

  group('cards on a tablet', () {
    testWidgets('two across beside the player panel, three without it', (
      tester,
    ) async {
      await pump(tester, VhLibraryLayout.cards, library: 754);
      expect(perRow(tester), 2);
      await pump(tester, VhLibraryLayout.cards, library: 1155);
      expect(perRow(tester), 3);
    });

    testWidgets('two across held upright', (tester) async {
      await pump(
        tester,
        VhLibraryLayout.cards,
        window: const Size(800, 1280),
        library: 675,
      );
      expect(perRow(tester), 2);
    });
  });

  group('compact rows on a tablet', () {
    testWidgets('two across beside the panel, three without it', (
      tester,
    ) async {
      await pump(tester, VhLibraryLayout.compact, library: 754);
      expect(perRow(tester), 2);
      await pump(tester, VhLibraryLayout.compact, library: 1155);
      expect(perRow(tester), 3);
    });
  });

  group('the grid', () {
    double cell(WidgetTester tester) =>
        tester.getSize(find.byKey(const Key('item-0'))).width;

    testWidgets('a tablet keeps covers of 210 at most', (tester) async {
      await pump(tester, VhLibraryLayout.grid, library: 1155);
      expect(cell(tester), lessThanOrEqualTo(210));
    });

    testWidgets('**the guard**: a wide library lets the cover grow to 280', (
      tester,
    ) async {
      // A maximized 1920 window: eight covers of 185 to a row before.
      await pump(
        tester,
        VhLibraryLayout.grid,
        window: const Size(1920, 1080),
        library: 1632,
      );
      expect(cell(tester), inInclusiveRange(240, 280));
      expect(perRow(tester), 6);
    });
  });

  group('the list as a table', () {
    VhMediaColumns columns(WidgetTester tester) =>
        tester.widget<VhMediaRowHeader>(find.byType(VhMediaRowHeader)).columns;

    testWidgets('beside the panel: length, size and date; the source, '
        'which the details also give, goes first', (tester) async {
      await pump(tester, VhLibraryLayout.list, library: 754);
      final c = columns(tester);
      expect((c.size, c.added, c.location), (true, true, false));
    });

    testWidgets('the full width adds the date and the tags', (tester) async {
      await pump(tester, VhLibraryLayout.list, library: 1155);
      final c = columns(tester);
      expect((c.size, c.added, c.location), (true, true, true));
      expect(find.text(vhName('#homelab')), findsWidgets);
    });

    testWidgets('upright drops the source, then the date', (tester) async {
      await pump(
        tester,
        VhLibraryLayout.list,
        window: const Size(800, 1280),
        library: 675,
      );
      final c = columns(tester);
      expect((c.size, c.added, c.location), (true, false, false));
    });

    testWidgets('**the guard**: a large font drops the source before the '
        'title is cut', (tester) async {
      // A 1280 window less the sidebar, text at 130%: the title was cut to
      // about 250 points while the source column stayed.
      await pump(tester, VhLibraryLayout.list, library: 1000, scale: 1.3);
      final c = columns(tester);
      expect((c.size, c.added, c.location), (true, true, false));
      // The title's column: about 266 points before, the source kept.
      final title = find.text(
        'Homelab Hour — Ep. 12: Backups that actually restore',
      );
      expect(tester.getSize(title.first).width, greaterThan(380));
    });

    testWidgets('**the guard**: a wide table gives the channel a column, '
        'holds the title to its width, and keeps the heart at the edge', (
      tester,
    ) async {
      await pump(
        tester,
        VhLibraryLayout.list,
        window: const Size(1920, 1080),
        library: 1632,
      );
      final c = columns(tester);
      expect((c.channel, c.location), (true, true));
      final l10n = tester.element(find.byType(VhMediaRowHeader)).vhl;
      expect(find.text(l10n.columnChannel), findsOneWidget);
      final row = tester.getRect(find.byKey(const Key('item-0')));
      final heading = tester.getRect(find.text(l10n.titleLabel));
      final channel = tester.getRect(find.text(l10n.columnChannel));
      // The channel's column follows a title no wider than its limit,
      // instead of the far side of a long empty stretch.
      expect(
        channel.left - heading.left,
        lessThan(VhMediaColumns.titleMax(TextScaler.noScaling) + 40),
      );
      // The channel is in its column, not under the title too.
      expect(
        find.text('Homelab Hour'),
        findsNWidgets(find.byType(VhMediaRow).evaluate().length),
      );
      // The row's buttons keep its far edge; the room the title leaves is
      // before them.
      final last = tester.getRect(
        find
            .descendant(
              of: find.byKey(const Key('item-0')),
              matching: find.byType(IconButton),
            )
            .last,
      );
      expect(row.right - last.right, lessThan(VhSpace.lg));
    });

    testWidgets('a narrower table has no channel column', (tester) async {
      await pump(tester, VhLibraryLayout.list, library: 1155);
      expect(columns(tester).channel, isFalse);
    });

    testWidgets('the phone app has no source column', (tester) async {
      await pump(tester, VhLibraryLayout.list, library: 754, location: false);
      expect(columns(tester).location, isFalse);
    });

    testWidgets('the largest font falls back to the phone row', (tester) async {
      await pump(tester, VhLibraryLayout.list, library: 754, scale: 2);
      expect(find.byType(VhMediaRowHeader), findsNothing);
      expect(find.byType(VhMediaCard), findsWidgets);
    });

    testWidgets('every cell sits under its heading', (tester) async {
      await pump(tester, VhLibraryLayout.list, library: 1155);
      final l10n = tester.element(find.byType(VhMediaRowHeader)).vhl;
      final heading = tester.getRect(find.text(l10n.columnLength));
      final cell = tester.getRect(find.textContaining('1:02:33').first);
      expect(cell.right, moreOrLessEquals(heading.right, epsilon: 1));
    });
  });

  testWidgets('no layout overflows a tablet at any font scale', (tester) async {
    const shapes = [
      (Size(1280, 800), 754.0),
      (Size(1280, 800), 1155.0),
      (Size(800, 1280), 675.0),
      (Size(960, 600), 434.0),
      (Size(960, 600), 835.0),
      (Size(600, 960), 475.0),
      // The grid used to overflow on a phone too, from a fixed cell ratio.
      (Size(320, 534), 320.0),
      (Size(411, 914), 411.0),
    ];
    for (final (window, library) in shapes) {
      for (final scale in const [1.0, 1.3, 2.0]) {
        for (final layout in VhLibraryLayout.values) {
          await pump(
            tester,
            layout,
            window: window,
            library: library,
            scale: scale,
          );
          expect(
            tester.takeException(),
            isNull,
            reason: '$window $library $scale ${layout.name}',
          );
        }
      }
    }
  });
}
