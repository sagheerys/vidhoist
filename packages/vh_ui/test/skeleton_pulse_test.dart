import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// The skeleton's breath (a still placeholder read as a frozen screen,
/// where the big apps' placeholders move).
void main() {
  Widget host({bool still = false}) => MaterialApp(
    theme: vhTheme(VhVariant.desktop, Brightness.light),
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: still),
      child: const Scaffold(
        body: VhSkeletonPulse(child: SizedBox(width: 100, height: 20)),
      ),
    ),
  );

  double opacity(WidgetTester tester) => tester
      .widget<FadeTransition>(
        find.descendant(
          of: find.byType(VhSkeletonPulse),
          matching: find.byType(FadeTransition),
        ),
      )
      .opacity
      .value;

  testWidgets('**the guard**: it breathes while it waits', (tester) async {
    await tester.pumpWidget(host());
    final seen = <double>{};
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
      seen.add((opacity(tester) * 100).round() / 100);
    }
    expect(seen.length, greaterThan(3));
    expect(seen.reduce((a, b) => a < b ? a : b), lessThan(0.7));
  });

  testWidgets('it stops by itself, fully bright, so a window settles', (
    tester,
  ) async {
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
    expect(opacity(tester), 1);
  });

  testWidgets('with animations turned off it never moves', (tester) async {
    await tester.pumpWidget(host(still: true));
    await tester.pump(const Duration(milliseconds: 450));
    expect(opacity(tester), 1);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}
