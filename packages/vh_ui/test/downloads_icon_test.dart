import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

import 'icon_finder.dart';

/// The downloads icon moves only while something downloads.
void main() {
  Widget host(int active, {bool still = false}) => MediaQuery(
    data: MediaQueryData(disableAnimations: still),
    child: MaterialApp(
      theme: vhTheme(VhVariant.desktop, Brightness.light),
      home: Scaffold(
        body: Center(child: VhDownloadsIcon(active: active)),
      ),
    ),
  );

  // The glyph is drawn twice: the still tray first, the moving arrow last.
  Offset arrow(WidgetTester tester) =>
      tester.getTopLeft(byVhIcon(VhIcons.download).last);
  Offset tray(WidgetTester tester) =>
      tester.getTopLeft(byVhIcon(VhIcons.download).first);

  group('the drop', () {
    test('rests upright for most of the loop', () {
      expect(vhDownloadDrop(0), (0.0, 1.0));
      expect(vhDownloadDrop(0.4), (0.0, 1.0));
    });

    test('falls and fades, then returns from above', () {
      final (falling, fading) = vhDownloadDrop(0.7);
      expect(falling, greaterThan(0));
      expect(fading, lessThan(1));
      final (rising, _) = vhDownloadDrop(0.8);
      expect(rising, lessThan(0));
      final (end, shown) = vhDownloadDrop(1);
      expect(end, closeTo(0, 1e-9));
      expect(shown, closeTo(1, 1e-9));
    });
  });

  testWidgets('with downloads running the arrow moves', (tester) async {
    await tester.pumpWidget(host(2));
    final rest = arrow(tester);
    final line = tray(tester);
    await tester.pump(VhDownloadsIcon.period * 0.65);
    expect(arrow(tester).dy, greaterThan(rest.dy));
    // Only the arrow: the line it drops into does not move.
    expect(tray(tester), line);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('with none it stands still and shows no count', (tester) async {
    await tester.pumpWidget(host(0));
    final rest = arrow(tester);
    await tester.pump(VhDownloadsIcon.period * 0.65);
    expect(arrow(tester), rest);
    expect(tester.hasRunningAnimations, isFalse);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('the last download finishing stops it upright', (tester) async {
    await tester.pumpWidget(host(1));
    final rest = arrow(tester);
    await tester.pump(VhDownloadsIcon.period * 0.65);
    await tester.pumpWidget(host(0));
    await tester.pumpAndSettle();
    expect(arrow(tester), rest);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('reduced motion keeps it still, count and all', (tester) async {
    await tester.pumpWidget(host(3, still: true));
    final rest = arrow(tester);
    await tester.pump(VhDownloadsIcon.period * 0.65);
    expect(arrow(tester), rest);
    expect(tester.hasRunningAnimations, isFalse);
    expect(find.text('3'), findsOneWidget);
  });
}
