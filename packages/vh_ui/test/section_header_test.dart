import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// **Guard: a section header's note sits at the end of its line.** Made
/// flexible to stop it overflowing a narrow phone, it took half the line
/// and floated in the middle on every wider screen (seen on a tablet,
/// 2026-11-01).
void main() {
  Future<void> pump(WidgetTester tester, double width, String note) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size(width, 400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: vhTheme(VhVariant.desktop, Brightness.light),
        home: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: VhSectionHeader(title: 'Your playlists', trailing: note),
          ),
        ),
      ),
    );
  }

  testWidgets('**the guard**: on a wide screen the note ends where the '
      'line ends', (tester) async {
    await pump(tester, 900, 'By last played');
    final line = tester.getRect(find.byType(VhSectionHeader));
    final note = tester.getRect(find.text('By last played'));
    expect(line.right - note.right, lessThan(VhSpace.sm));
  });

  testWidgets('on a narrow phone a long note gives way to the title', (
    tester,
  ) async {
    await pump(tester, 320, 'Followed in Settings or the player and more');
    expect(tester.takeException(), isNull);
    expect(find.text('Your playlists'), findsOneWidget);
  });
}
