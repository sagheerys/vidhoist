import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

import 'icon_finder.dart';

/// Two touches of motion asked for on 2026-10-04: a paused subscription
/// travels to the end of the list instead of jumping there, and the
/// connection icon's cloud turns its arrows while the connection is being
/// checked.
void main() {
  group('rows travel to their new place', () {
    Widget rows(List<String> order, {bool reduceMotion = false}) => MediaQuery(
      data: MediaQueryData(disableAnimations: reduceMotion),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topCenter,
          child: VhReorderMotion(
            children: [
              for (final name in order)
                SizedBox(key: ValueKey(name), height: 100, child: Text(name)),
            ],
          ),
        ),
      ),
    );

    double topOf(WidgetTester tester, String name) =>
        tester.getTopLeft(find.text(name)).dy;

    testWidgets('the moved row starts where it was and ends where it '
        'belongs', (tester) async {
      await tester.pumpWidget(rows(['a', 'b', 'c']));
      await tester.pump();
      expect(topOf(tester, 'a'), 0);

      // "a" is paused and sorts last.
      await tester.pumpWidget(rows(['b', 'c', 'a']));
      // The first frame still shows it at the top: no flash of the end.
      expect(topOf(tester, 'a'), closeTo(0, 1));
      expect(topOf(tester, 'b'), closeTo(100, 1));

      await tester.pump(VhMotion.medium ~/ 2);
      final halfway = topOf(tester, 'a');
      expect(halfway, greaterThan(0));
      expect(halfway, lessThan(200));

      await tester.pumpAndSettle();
      expect(topOf(tester, 'a'), 200);
      expect(topOf(tester, 'b'), 0);
      expect(topOf(tester, 'c'), 100);
    });

    // Found in the pre-release review of 2.4.0: a moving row was wrapped
    // in a new widget for the trip, so its state was thrown away twice.
    testWidgets('a row keeps its own state through the move', (tester) async {
      Widget rowsWithState(List<String> order) => Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topCenter,
          child: VhReorderMotion(
            children: [
              for (final name in order)
                _Counter(key: ValueKey(name), name: name),
            ],
          ),
        ),
      );
      await tester.pumpWidget(rowsWithState(['a', 'b']));
      await tester.pump();
      await tester.tap(find.text('a 0'));
      await tester.pump();
      expect(find.text('a 1'), findsOneWidget);

      await tester.pumpWidget(rowsWithState(['b', 'a']));
      await tester.pump(VhMotion.medium ~/ 2);
      expect(find.text('a 1'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('a 1'), findsOneWidget);
    });

    testWidgets('with motion reduced, the rows simply take their places', (
      tester,
    ) async {
      await tester.pumpWidget(rows(['a', 'b', 'c'], reduceMotion: true));
      await tester.pump();
      await tester.pumpWidget(rows(['b', 'c', 'a'], reduceMotion: true));
      await tester.pump();
      expect(topOf(tester, 'a'), 200);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('a new row just appears', (tester) async {
      await tester.pumpWidget(rows(['a', 'b']));
      await tester.pump();
      await tester.pumpWidget(rows(['a', 'new', 'b']));
      await tester.pumpAndSettle();
      expect(topOf(tester, 'new'), 100);
      expect(topOf(tester, 'b'), 200);
    });
  });

  group('the connection cloud', () {
    Widget cloud({required bool checking, bool reduceMotion = false}) =>
        MediaQuery(
          data: MediaQueryData(disableAnimations: reduceMotion),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: VhConnectionIcon(
                icon: VhIcons.cloudCheck,
                color: Colors.white,
                checking: checking,
              ),
            ),
          ),
        );

    double turnOf(WidgetTester tester) => tester
        .widget<RotationTransition>(
          find.descendant(
            of: find.byType(VhConnectionIcon),
            matching: find.byType(RotationTransition),
          ),
        )
        .turns
        .value;

    testWidgets('while checking, the arrows in the cloud turn', (tester) async {
      await tester.pumpWidget(cloud(checking: true));
      await tester.pump(const Duration(milliseconds: 300));
      final early = turnOf(tester);
      await tester.pump(const Duration(milliseconds: 300));
      expect(turnOf(tester), isNot(early));
      expect(byVhIcon(VhIcons.refresh), findsOneWidget);
    });

    testWidgets('once settled, the state glyph stands still', (tester) async {
      await tester.pumpWidget(cloud(checking: true));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpWidget(cloud(checking: false));
      await tester.pumpAndSettle();
      expect(byVhIcon(VhIcons.cloudCheck), findsOneWidget);
      expect(byVhIcon(VhIcons.refresh), findsNothing);
      expect(tester.hasRunningAnimations, isFalse);
    });

    // On a home network the check ended before the eye saw anything, and a
    // refresh looked ignored.
    testWidgets('a quick answer still shows the arrows for a moment', (
      tester,
    ) async {
      await tester.pumpWidget(cloud(checking: true));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpWidget(cloud(checking: false));
      // Past a crossfade, which would show fading arrows anyway, and short
      // of the shortest turn.
      await tester.pump(VhMotion.reveal + const Duration(milliseconds: 100));
      expect(byVhIcon(VhIcons.refresh), findsOneWidget);
      expect(byVhIcon(VhIcons.cloudCheck), findsNothing);
      await tester.pump(VhConnectionIcon.shortestTurn);
      await tester.pumpAndSettle();
      expect(byVhIcon(VhIcons.refresh), findsNothing);
      expect(byVhIcon(VhIcons.cloudCheck), findsOneWidget);
    });

    testWidgets('a slow answer settles at once when it comes', (tester) async {
      await tester.pumpWidget(cloud(checking: true));
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpWidget(cloud(checking: false));
      // Only the crossfade, no hold.
      await tester.pump(VhMotion.reveal + const Duration(milliseconds: 20));
      expect(byVhIcon(VhIcons.refresh), findsNothing);
      expect(byVhIcon(VhIcons.cloudCheck), findsOneWidget);
    });

    testWidgets('with motion reduced, the arrows do not turn', (tester) async {
      await tester.pumpWidget(cloud(checking: true, reduceMotion: true));
      await tester.pump(const Duration(milliseconds: 300));
      expect(turnOf(tester), 0);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}

/// A row with state of its own, counting its taps.
class _Counter extends StatefulWidget {
  const _Counter({super.key, required this.name});

  final String name;

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int _taps = 0;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => setState(() => _taps++),
    child: SizedBox(height: 100, child: Text('${widget.name} $_taps')),
  );
}
