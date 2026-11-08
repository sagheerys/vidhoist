import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

import 'icon_finder.dart';

void main() {
  Widget host(
    ScrollController controller, {
    bool fresh = false,
    int count = 300,
  }) => MaterialApp(
    theme: vhTheme(VhVariant.desktop, Brightness.light),
    home: Scaffold(
      body: VhJumpToEnd(
        controller: controller,
        tooltip: 'Go to the newest',
        fresh: fresh,
        child: ListView.builder(
          controller: controller,
          padding: const EdgeInsets.only(bottom: VhJumpToEnd.reserve),
          itemCount: count,
          // Uneven heights, like wrapped log lines: the end measured
          // before a jump is not the real one.
          itemBuilder: (_, i) =>
              SizedBox(height: i % 7 == 0 ? 120 : 20, child: Text('line $i')),
        ),
      ),
    ),
  );

  double opacity(WidgetTester tester) => tester
      .widget<AnimatedOpacity>(
        find.descendant(
          of: find.byType(VhJumpToEnd),
          matching: find.byType(AnimatedOpacity),
        ),
      )
      .opacity;

  testWidgets('hidden at first, out while scrolling down, gone on the '
      'way back up', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(host(controller));
    expect(opacity(tester), 0);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(opacity(tester), 1);

    await tester.drag(find.byType(ListView), const Offset(0, 100));
    await tester.pumpAndSettle();
    expect(opacity(tester), 0);
  });

  testWidgets('one tap lands on the real end, then it hides', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(host(controller));
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    await tester.tap(byVhIcon(VhIcons.chevronDown));
    await tester.pumpAndSettle();
    expect(controller.position.extentAfter, 0);
    expect(find.text('line 299'), findsOneWidget);
    expect(opacity(tester), 0);
  });

  testWidgets('hidden, it takes no taps', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(host(controller));
    await tester.tap(byVhIcon(VhIcons.chevronDown), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(controller.offset, 0);
  });

  testWidgets('new entries below mark it with a dot but do not bring it '
      'out', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(host(controller));
    await tester.pumpWidget(host(controller, fresh: true));
    await tester.pumpAndSettle();
    expect(opacity(tester), 0);
    expect(controller.offset, 0, reason: 'the reader is not moved');

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(opacity(tester), 1);
  });

  testWidgets('settleAtEnd reaches the real end of a long uneven list', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(host(controller, count: 1000));
    // Each step waits for a frame, and frames here come from pump.
    var settled = false;
    unawaited(VhJumpToEnd.settleAtEnd(controller).then((_) => settled = true));
    for (var i = 0; i < 20 && !settled; i++) {
      await tester.pump();
    }
    expect(settled, isTrue);
    expect(controller.position.extentAfter, 0);
    expect(find.text('line 999'), findsOneWidget);
  });
}
