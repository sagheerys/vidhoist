import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// **Guard: the bar's pill travels, and the sections fade into each
/// other.** Material's bar grew a new pill under each destination and the
/// shell cut from one section to the next in a single frame; the plan has
/// one pill sliding in 240 and the sections crossing in 160 each way.
void main() {
  const items = [
    VhNavItem(icon: VhIcons.library, selectedIcon: VhIcons.library, label: 'أ'),
    VhNavItem(icon: VhIcons.list, selectedIcon: VhIcons.list, label: 'ب'),
    VhNavItem(
      icon: VhIcons.settings,
      selectedIcon: VhIcons.settings,
      label: 'ج',
    ),
  ];

  Widget host(int index) => MaterialApp(
    theme: vhTheme(VhVariant.desktop, Brightness.light),
    home: Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        bottomNavigationBar: VhBottomBar(
          items: items,
          selectedIndex: index,
          onSelected: (_) {},
        ),
        body: VhTabStack(
          index: index,
          children: const [Text('الأول'), Text('الثاني'), Text('الثالث')],
        ),
      ),
    ),
  );

  double pillX(WidgetTester tester) =>
      tester.getCenter(find.byKey(const ValueKey('bar-pill'))).dx;

  testWidgets('the pill slides from one section to the next', (tester) async {
    await tester.pumpWidget(host(0));
    final first = pillX(tester);
    await tester.pumpWidget(host(2));
    await tester.pump(VhMotion.page ~/ 2);
    final midway = pillX(tester);
    await tester.pumpAndSettle();
    final last = pillX(tester);
    expect(midway, greaterThan(first));
    expect(midway, lessThan(last));
  });

  testWidgets('a reader hears which section is chosen', (tester) async {
    await tester.pumpWidget(host(1));
    expect(
      tester.getSemantics(find.text('ب')),
      matchesSemantics(
        label: 'ب',
        hint: 'Tab 2 of 3',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
      ),
    );
  });

  testWidgets('the section left fades out before the new one fades in', (
    tester,
  ) async {
    await tester.pumpWidget(host(0));
    await tester.pumpWidget(host(1));
    await tester.pump(VhMotion.fast ~/ 2);
    double opacityOf(String text) => tester
        .widget<Opacity>(
          find
              .ancestor(of: find.text(text), matching: find.byType(Opacity))
              .first,
        )
        .opacity;
    expect(opacityOf('الأول'), inExclusiveRange(0, 1));
    expect(opacityOf('الثاني'), 0);
    await tester.pumpAndSettle();
    expect(opacityOf('الثاني'), 1);
    expect(find.text('الأول'), findsNothing);
  });

  testWidgets('a count shows on its icon, and none at zero', (tester) async {
    Widget bar(int count) => MaterialApp(
      theme: vhTheme(VhVariant.phone, Brightness.light),
      home: Scaffold(
        bottomNavigationBar: VhBottomBar(
          items: [
            items[0],
            VhNavItem(
              icon: VhIcons.monitor,
              selectedIcon: VhIcons.monitor,
              label: 'الكمبيوتر',
              badge: count,
            ),
          ],
          selectedIndex: 0,
          onSelected: (_) {},
        ),
      ),
    );
    await tester.pumpWidget(bar(2));
    expect(find.text('2'), findsOneWidget);
    expect(tester.getSemantics(find.text('الكمبيوتر')).label, 'الكمبيوتر, 2');
    await tester.pumpWidget(bar(0));
    expect(find.byType(Badge), findsNothing);
    await tester.pumpWidget(bar(120));
    expect(find.text('99+'), findsOneWidget);
  });
}
