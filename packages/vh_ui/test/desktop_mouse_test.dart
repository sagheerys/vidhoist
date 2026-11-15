import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// What the mouse and the keyboard add on Windows, and the promise that a
/// phone sees none of it.
void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    required bool desktop,
  }) async {
    final app = MaterialApp(
      theme: desktop
          ? vhDesktopTheme(VhVariant.desktop, Brightness.light)
          : vhTheme(VhVariant.desktop, Brightness.light),
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
    await tester.pumpWidget(desktop ? VhDesktopApp(child: app) : app);
  }

  Widget card() => Align(
    alignment: Alignment.topLeft,
    child: SizedBox(
      width: 240,
      child: VhMediaGridCard(title: 'Amber Skies', onTap: () {}),
    ),
  );

  Future<TestGesture> hover(WidgetTester tester, Finder target) async {
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(target));
    await tester.pumpAndSettle();
    return mouse;
  }

  double playMark(WidgetTester tester) => tester
      .widget<AnimatedOpacity>(
        find.ancestor(
          of: find.byWidgetPredicate(
            (w) => w is VhIcon && w.icon == VhIcons.play,
          ),
          matching: find.byType(AnimatedOpacity),
        ),
      )
      .opacity;

  BoxDecoration plate(WidgetTester tester) =>
      tester
              .widget<AnimatedContainer>(
                find.byKey(const ValueKey('hover-plate')),
              )
              .decoration!
          as BoxDecoration;

  bool shown(WidgetTester tester) => plate(tester).color!.a > 0;

  testWidgets('on Windows a plate appears behind a card and offers play', (
    tester,
  ) async {
    await pump(tester, card(), desktop: true);
    expect(playMark(tester), 0);
    expect(shown(tester), isFalse);

    final mouse = await hover(tester, find.byType(VhMediaGridCard));
    expect(playMark(tester), 1);
    expect(shown(tester), isTrue);
    // **The guard**: no glow and no lift, only the plate.
    expect(plate(tester).boxShadow, isNull);
    expect(
      find.descendant(
        of: find.byType(VhHoverLift),
        matching: find.byWidgetPredicate(
          (w) => w is AnimatedContainer && w.transform != null,
        ),
      ),
      findsNothing,
    );

    await mouse.moveTo(const Offset(700, 500));
    await tester.pumpAndSettle();
    expect(playMark(tester), 0);
    expect(shown(tester), isFalse);
  });

  testWidgets('**the guard**: on a phone, even with a mouse, nothing moves', (
    tester,
  ) async {
    await pump(tester, card(), desktop: false);
    await hover(tester, find.byType(VhMediaGridCard));
    expect(
      find.descendant(
        of: find.byType(VhHoverLift),
        matching: find.byType(AnimatedContainer),
      ),
      findsNothing,
    );
  });

  Widget buttons() => VhFocusRingLayer(
    child: Column(
      children: [
        TextButton(onPressed: () {}, child: const Text('One')),
        TextButton(onPressed: () {}, child: const Text('Two')),
      ],
    ),
  );

  Finder ring() => find.byKey(VhFocusRingLayer.ringKey);

  testWidgets('the focus ring follows the keyboard and leaves with a click', (
    tester,
  ) async {
    await pump(tester, buttons(), desktop: true);
    expect(ring(), findsNothing);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(ring(), findsOneWidget);
    final first = tester.getRect(ring());
    expect(first.contains(tester.getCenter(find.text('One'))), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(
      tester.getRect(ring()).contains(tester.getCenter(find.text('Two'))),
      isTrue,
    );

    // A click puts focus where it lands but shows no ring: the mouse knows
    // where it is.
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.down(tester.getCenter(find.text('One')));
    await mouse.up();
    await tester.pumpAndSettle();
    expect(ring(), findsNothing);
  });

  // Seen on Windows: ↑ in a clip's time field stepped the time and drew a
  // second frame inside the field's own, as if focus had moved.
  testWidgets('**the guard**: arrows typed in a field show no ring; Tab '
      'still does', (tester) async {
    await pump(
      tester,
      VhFocusRingLayer(
        child: Column(
          children: [
            TextButton(onPressed: () {}, child: const Text('One')),
            const TextField(),
          ],
        ),
      ),
      desktop: true,
    );
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    for (final key in [
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowRight,
    ]) {
      await tester.sendKeyEvent(key);
      await tester.pumpAndSettle();
      expect(ring(), findsNothing, reason: '$key');
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(ring(), findsOneWidget);
  });

  test('the desktop theme: thin scrollbar, tooltip after 600ms, no focus '
      'fill', () {
    final theme = vhDesktopTheme(VhVariant.desktop, Brightness.light);
    final p = VhPalette.of(VhVariant.desktop, Brightness.light);
    final bar = theme.scrollbarTheme;
    expect(bar.thickness?.resolve({}), VhDensity.desktop.scrollbar);
    expect(bar.thumbColor?.resolve({}), p.line2);
    expect(bar.thumbColor?.resolve({WidgetState.dragged}), p.ink3);
    expect(theme.tooltipTheme.waitDuration, const Duration(milliseconds: 600));
    expect(theme.focusColor, Colors.transparent);
  });

  test('**the guard**: the phone theme keeps its own focus and scrollbar', () {
    final phone = vhTheme(VhVariant.desktop, Brightness.light);
    expect(phone.focusColor, isNot(Colors.transparent));
    expect(phone.scrollbarTheme.thickness, isNull);
  });
}
