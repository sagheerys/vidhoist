import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_ui/mt_ui.dart';

import 'support/shell_harness.dart';

/// **The guard**: with no server, an empty library asks for a link, not
/// for a server to be set up: downloads run on this computer.
void main() {
  testWidgets('an empty library offers to add a link', (tester) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => call.method == 'Clipboard.getData'
          ? <String, Object?>{'text': ''}
          : null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpWidget(
      ShellHarness(library: const [], withEngine: true).app(),
    );
    await tester.pumpAndSettle();
    final l = lookupMTLocalizations(const Locale('en'));
    expect(find.text(l.desktopEmptyLibraryLocal), findsOneWidget);
    expect(find.text(l.serverStatusUnconfigured), findsNothing);
    expect(find.text(l.desktopSetupConnect), findsNothing);
  });
}
