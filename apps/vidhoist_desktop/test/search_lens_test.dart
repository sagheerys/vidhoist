import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/router.dart';
import 'package:vidhoist_desktop/shell/sidebar.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'support/shell_harness.dart';

void main() {
  testWidgets('**the guard**: a search field\'s magnifier is drawn at the '
      'size of the window\'s search box, not grown to fill its slot', (
    tester,
  ) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    final h = ShellHarness(
      withEngine: true,
      overrides: [
        // Logs reads its file; one that is never written is enough here.
        loggerProvider.overrideWithValue(
          VhLogger(filePath: '${Directory.systemTemp.path}/ember_none.log'),
        ),
      ],
    );
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    GoRouter.of(tester.element(find.byType(DesktopSidebar)))
        .go(DesktopSettingsPane.logs.route);
    await tester.pumpAndSettle();
    final lens = find.descendant(
      of: find.byType(TextField),
      matching: find.byWidgetPredicate(
        (w) => w is VhIcon && w.icon == VhIcons.search,
      ),
    );
    expect(lens, findsOneWidget);
    expect(tester.getSize(lens).width, VhDensity.desktop.icon);
  });
}
