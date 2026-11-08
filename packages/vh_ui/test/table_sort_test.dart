import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// Sorting from the table's header is the Windows app's; the tablet keeps
/// plain titles and its sort sheet.
void main() {
  const columns = VhMediaColumns(size: true, added: true);

  Future<void> pump(WidgetTester tester, VhTableSort? sort) =>
      tester.pumpWidget(
        MaterialApp(
          theme: vhTheme(VhVariant.desktop, Brightness.light),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: Scaffold(
            body: SizedBox(
              width: 900,
              child: VhMediaRowHeader(columns: columns, sort: sort),
            ),
          ),
        ),
      );

  testWidgets('**the guard**: with no sorting the titles are plain text', (
    tester,
  ) async {
    await pump(tester, null);
    expect(
      find.descendant(
        of: find.byType(VhMediaRowHeader),
        matching: find.byType(InkWell),
      ),
      findsNothing,
    );
    expect(find.byType(VhIcon), findsNothing);
  });

  testWidgets('a click on a title sorts by it, the arrow marks the column', (
    tester,
  ) async {
    final asked = <VhTableColumn>[];
    await pump(
      tester,
      VhTableSort(
        column: VhTableColumn.added,
        ascending: false,
        onSort: asked.add,
      ),
    );
    await tester.tap(find.text('Title'));
    await tester.tap(find.text('Size'));
    await tester.tap(find.text('Added'));
    expect(asked, [
      VhTableColumn.title,
      VhTableColumn.size,
      VhTableColumn.added,
    ]);
    // One arrow, beside the column the table is sorted by.
    final arrow = find.byType(VhIcon);
    expect(arrow, findsOneWidget);
    expect(
      tester.getCenter(arrow).dx,
      greaterThan(tester.getCenter(find.text('Added')).dx),
    );
  });
}
