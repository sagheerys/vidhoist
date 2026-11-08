import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/features/library/library_page.dart';
import 'package:vh_ui/vh_ui.dart';

import 'support/shell_harness.dart';

void main() {
  BuildContext place(WidgetTester tester) =>
      tester.element(find.byType(LibraryPage));

  testWidgets('the app starts on the Vidhoist palette', (tester) async {
    await tester.pumpWidget(ShellHarness().app());
    await tester.pumpAndSettle();
    expect(
      Theme.of(place(tester)).colorScheme.primary,
      const Color(0xFF2457D6),
    );
  });

  testWidgets('the app declares itself the Windows app', (tester) async {
    ShellHarness.useWindow(tester, const Size(1280, 800));
    await tester.pumpWidget(ShellHarness().app());
    await tester.pumpAndSettle();
    expect(place(tester).windowClass, VhWindowClass.desktop);
  });

  testWidgets('day and night follow Windows', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(ShellHarness().app());
    await tester.pumpAndSettle();
    final scheme = Theme.of(place(tester)).colorScheme;
    expect(scheme.brightness, Brightness.dark);
    expect(scheme.primary, const Color(0xFF7FA3FF));

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpAndSettle();
    expect(
      Theme.of(place(tester)).colorScheme.primary,
      const Color(0xFF2457D6),
    );
  });

  testWidgets('the language follows Windows: Arabic reads right to left', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ar', 'SA')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(ShellHarness().app());
    await tester.pumpAndSettle();
    expect(Directionality.of(place(tester)), TextDirection.rtl);
  });
}
