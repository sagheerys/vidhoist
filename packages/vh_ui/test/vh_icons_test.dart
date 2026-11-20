import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

void main() {
  Future<void> pumpAll(WidgetTester tester, ThemeData theme) =>
      tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Wrap(children: [for (final i in VhIcons.all) VhIcon(i)]),
        ),
      );

  testWidgets('every icon draws without an error, day and night', (
    tester,
  ) async {
    for (final b in Brightness.values) {
      await pumpAll(tester, vhTheme(VhVariant.desktop, b));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$b');
      expect(find.byType(SvgPicture), findsNWidgets(VhIcons.all.length));
    }
  });

  test('**the guard**: no icon keeps a dash written against pathLength', () {
    // flutter_svg ignores pathLength: a gap measured against it lands in the
    // wrong place (the search lens closed, the heart's gap moved). The
    // generator converts such dashes to absolute lengths.
    for (final icon in VhIcons.all) {
      expect(icon.svg, isNot(contains('pathLength')), reason: icon.name);
      expect(icon.svg, isNot(contains('class=')), reason: icon.name);
      expect(icon.svg, isNot(contains('currentColor')), reason: icon.name);
      expect(icon.svg, contains('{ink}'), reason: icon.name);
    }
  });

  testWidgets('the accent follows the palette, the ink the icon theme', (
    tester,
  ) async {
    late BuildContext ctx;
    Future<String> drawn(VhVariant v, Brightness b) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: vhTheme(v, b),
          home: IconTheme(
            data: const IconThemeData(color: Color(0xFF112233)),
            child: Builder(
              builder: (c) {
                ctx = c;
                return const VhIcon(VhIcons.search);
              },
            ),
          ),
        ),
      );
      // MaterialApp animates a theme change; read the colour once it lands.
      await tester.pumpAndSettle();
      return const VhIcon(VhIcons.search).svgIn(ctx);
    }

    final desktopDay = await drawn(VhVariant.desktop, Brightness.light);
    expect(desktopDay, contains('#2457d6'));
    expect(desktopDay, contains('#112233'));

    final desktopNight = await drawn(VhVariant.desktop, Brightness.dark);
    expect(desktopNight, contains('#7fa3ff'));

    final phoneDay = await drawn(VhVariant.phone, Brightness.light);
    expect(phoneDay, contains('#2457d6'));
  });

  test('the alternatives that were not chosen are not generated', () {
    final names = {for (final i in VhIcons.all) i.name};
    expect(names, containsAll(['settings', 'search', 'favorite', 'queue']));
    for (final rejected in ['settings_8', 'sliders', 'knob', 'download_line']) {
      expect(names, isNot(contains(rejected)));
    }
  });

  Widget framed(Widget child, {TextDirection dir = TextDirection.ltr}) =>
      MaterialApp(
        theme: vhTheme(VhVariant.desktop, Brightness.light),
        home: Directionality(
          textDirection: dir,
          child: Center(child: child),
        ),
      );

  testWidgets('**the guard**: the reading arrows turn in Arabic, nothing '
      'else does', (tester) async {
    Finder flip() => find.descendant(
      of: find.byType(VhIcon),
      matching: find.byType(Transform),
    );
    const arrow = VhIcon(VhIcons.forward, matchTextDirection: true);
    await tester.pumpWidget(framed(arrow, dir: TextDirection.rtl));
    expect(flip(), findsOneWidget);
    await tester.pumpWidget(framed(arrow));
    expect(flip(), findsNothing);
    await tester.pumpWidget(
      framed(const VhIcon(VhIcons.share), dir: TextDirection.rtl),
    );
    expect(flip(), findsNothing);
  });

  testWidgets('**the guard**: a filled icon turns in Arabic as its outline '
      'does, so a tab does not flip when it is chosen', (tester) async {
    Finder flip() => find.descendant(
      of: find.byType(VhIcon),
      matching: find.byType(Transform),
    );
    final byName = {for (final i in VhIcons.all) i.name: i};
    final twins = [
      for (final i in VhIcons.all)
        if (i.name.endsWith('_fill') &&
            byName.containsKey(i.name.replaceAll('_fill', '')))
          (byName[i.name.replaceAll('_fill', '')]!, i),
    ];
    expect(twins.map((t) => t.$2), contains(VhIcons.queueFill));
    for (final (outline, filled) in twins) {
      await tester.pumpWidget(framed(VhIcon(outline), dir: TextDirection.rtl));
      final turns = flip().evaluate().length;
      await tester.pumpWidget(framed(VhIcon(filled), dir: TextDirection.rtl));
      expect(flip().evaluate().length, turns, reason: filled.name);
    }
  });

  testWidgets('a shadow draws a blurred copy beneath the icon', (tester) async {
    await tester.pumpWidget(
      framed(
        const VhIcon(
          VhIcons.moreVert,
          shadows: [Shadow(color: Color(0x99000000), blurRadius: 5)],
        ),
      ),
    );
    expect(find.byType(ImageFiltered), findsOneWidget);
    expect(find.byType(SvgPicture), findsNWidgets(2));
  });

  testWidgets('outside the app\'s theme the icon still draws', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: VhIcon(VhIcons.cloud, color: Color(0xFF445566)),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('**the guard**: what Flutter draws by itself takes the app\'s '
      'glyphs too: the back arrow, the chosen segment', (tester) async {
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: nav,
        theme: vhTheme(VhVariant.phone, Brightness.light),
        home: const Scaffold(),
      ),
    );
    nav.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(),
          body: SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('A')),
              ButtonSegment(value: 1, label: Text('B')),
            ],
            selected: const {0},
            onSelectionChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final names = [
      for (final i in tester.widgetList<VhIcon>(find.byType(VhIcon)))
        i.icon.name,
    ];
    expect(names, containsAll(['back', 'check']));
    expect(find.byType(Icon), findsNothing);
  });

  testWidgets('**the guard**: a parent that forces a larger box widens the '
      'box, never the glyph', (tester) async {
    // An input field's prefix forces 48 by 48; the lens grew to fill it.
    await tester.pumpWidget(
      framed(
        const SizedBox.square(
          dimension: 48,
          child: VhIcon(VhIcons.search, size: 20),
        ),
      ),
    );
    expect(tester.getSize(find.byType(SvgPicture)), const Size(20, 20));
  });

  /// **The guard**: dimmed through its colour, each stroke was painted
  /// alone and the ink laid twice where two met, bright knots by night.
  /// The glyph is drawn opaque and dimmed whole.
  testWidgets("a disabled button's dimmed icon theme dims the whole glyph", (
    tester,
  ) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      framed(
        IconTheme(
          data: const IconThemeData(color: Color(0xFF112233), opacity: 0.5),
          child: Builder(
            builder: (c) {
              ctx = c;
              return const VhIcon(VhIcons.close);
            },
          ),
        ),
      ),
    );
    final svg = const VhIcon(VhIcons.close).svgIn(ctx);
    expect(svg, contains('#112233'));
    expect(svg, isNot(contains('#11223380')));
    final dim = tester.widget<Opacity>(
      find
          .ancestor(of: find.byType(SvgPicture), matching: find.byType(Opacity))
          .first,
    );
    expect(dim.opacity, closeTo(0.5, 0.01));
  });

  testWidgets('**the guard**: a translucent colour is laid on the whole '
      'glyph, not on each stroke', (tester) async {
    await tester.pumpWidget(
      framed(const VhIcon(VhIcons.bug, color: Color(0x80F0EBE4))),
    );
    final dim = tester.widget<Opacity>(
      find
          .ancestor(of: find.byType(SvgPicture), matching: find.byType(Opacity))
          .first,
    );
    expect(dim.opacity, closeTo(0.5, 0.01));
  });

  testWidgets("**the guard**: in Arabic a phone turns what Material's glyphs "
      'turned, and the computer leaves it to its call sites', (tester) async {
    Finder flip() => find.descendant(
      of: find.byType(VhIcon),
      matching: find.byType(Transform),
    );
    for (final icon in [
      VhIcons.external,
      VhIcons.transcript,
      VhIcons.queue,
      VhIcons.queueAdd,
      VhIcons.help,
    ]) {
      await tester.pumpWidget(framed(VhIcon(icon), dir: TextDirection.rtl));
      expect(flip(), findsOneWidget, reason: icon.name);
      await tester.pumpWidget(
        VhDesktopApp(child: framed(VhIcon(icon), dir: TextDirection.rtl)),
      );
      expect(flip(), findsNothing, reason: '${icon.name} on the computer');
    }
    await tester.pumpWidget(
      framed(const VhIcon(VhIcons.share), dir: TextDirection.rtl),
    );
    expect(flip(), findsNothing);
  });
}
