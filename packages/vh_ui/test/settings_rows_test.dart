import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

import 'icon_finder.dart';

/// **The settings home's rows** (approved mock-up, 2026-10-14): the value
/// under the title, a chevron where a page is pushed, and the open
/// section lit on the tablet's list, where nothing is pushed.
void main() {
  Widget host(Widget child, {Locale locale = const Locale('en')}) =>
      MaterialApp(
        locale: locale,
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        theme: vhTheme(VhVariant.phone, Brightness.light),
        home: Scaffold(body: ListView(children: [child])),
      );

  testWidgets('a row shows its value and opens on a tap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      host(
        VhSettingsGroup(
          title: 'App',
          rows: [
            VhSettingsRow(
              icon: VhIcons.download,
              title: 'Downloads',
              value: 'Best · Wi‑Fi only',
              onTap: () => taps++,
            ),
            VhSettingsRow(
              icon: VhIcons.playFill,
              title: 'Playback',
              value: 'Best compatibility: on',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
    expect(find.text('Best · Wi‑Fi only'), findsOneWidget);
    expect(byVhIcon(VhIcons.forward), findsNWidgets(2));
    // A hairline between the two rows, none above the first.
    expect(find.byType(Divider), findsOneWidget);

    await tester.tap(find.text('Downloads'));
    expect(taps, 1);
  });

  // Owner's choice, 2026-11-01: each group a card as in the mock-ups, not
  // rows laid straight on the page.
  testWidgets('**the guard**: a group is a card with its heading inside', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        VhSettingsGroup(
          title: 'App',
          rows: [
            VhSettingsRow(
              icon: VhIcons.download,
              title: 'Downloads',
              value: 'Best',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
    final card = VhPalette.of(VhVariant.phone, Brightness.light).card;
    final box = find.descendant(
      of: find.byType(VhSettingsGroup),
      matching: find.byWidgetPredicate(
        (w) =>
            w is DecoratedBox &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).color == card,
      ),
    );
    expect(box, findsOneWidget);
    for (final inside in ['App', 'Downloads']) {
      expect(
        find.descendant(of: box, matching: find.text(inside)),
        findsOneWidget,
      );
    }
  });

  testWidgets('on the tablet list: lit when open, no chevron, no lines', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        VhSettingsGroup(
          title: 'App',
          divided: false,
          rows: [
            for (final open in [true, false])
              VhSettingsRow(
                icon: VhIcons.download,
                title: open ? 'Open' : 'Closed',
                value: 'value',
                selected: open,
                chevron: false,
                onTap: () {},
              ),
          ],
        ),
      ),
    );
    expect(byVhIcon(VhIcons.forward), findsNothing);
    expect(find.byType(Divider), findsNothing);
    final tiles = tester.widgetList<ListTile>(find.byType(ListTile)).toList();
    expect(tiles.first.selected, isTrue);
    expect(tiles.last.selected, isFalse);
  });

  // Seen on a tablet: the lit colour is painted on the nearest Material,
  // and on the page's own it stayed behind when a card above the list grew
  // a line. Each row carries its surface along.
  testWidgets('GUARD: each row paints its light on a surface of its own', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        VhSettingsRow(
          icon: VhIcons.download,
          title: 'Open',
          value: 'value',
          selected: true,
          onTap: () {},
        ),
      ),
    );
    // The surface the tile paints on (above it) belongs to the row.
    expect(
      find.descendant(
        of: find.byType(VhSettingsRow),
        matching: find.ancestor(
          of: find.byType(ListTile),
          matching: find.byType(Material),
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('a long value stays on one line, in either direction', (
    tester,
  ) async {
    for (final locale in const [Locale('en'), Locale('ar')]) {
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        host(
          VhSettingsRow(
            icon: VhIcons.transcript,
            title: 'النصوص والترجمة',
            value: 'مفعّل · 58 مقطعاً · الترجمة ظاهرة · ' * 3,
            onTap: () {},
          ),
          locale: locale,
        ),
      );
      expect(tester.takeException(), isNull, reason: '$locale');
    }
  });
}
