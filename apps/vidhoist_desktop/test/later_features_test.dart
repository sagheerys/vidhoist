import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vidhoist_desktop/data/later_features.dart';
import 'package:vidhoist_desktop/router.dart';
import 'package:vidhoist_desktop/shell/sidebar.dart';

import 'support/shell_harness.dart';

/// **The guard**: Channels and Sync are hidden in 1.0, never removed: the
/// sidebar and Settings leave them out until their switch is on, and the
/// server's own sections are gone from Settings.
void main() {
  Future<ShellHarness> open(WidgetTester tester, {bool later = false}) async {
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
    final h = ShellHarness(library: const []);
    if (later) await h.store.setBool(LaterFeaturesNotifier.key, true);
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    GoRouter.of(tester.element(find.byType(EmberSidebar)))
        .go(EmberSettingsPane.engine.route);
    await tester.pumpAndSettle();
    return h;
  }

  Finder inSidebar(String label) => find.descendant(
    of: find.byType(EmberSidebar),
    matching: find.text(label),
  );

  testWidgets('off: no Channels, no Sync, no server sections', (tester) async {
    await open(tester);
    expect(inSidebar('Channels'), findsNothing);
    expect(find.text('Sync'), findsNothing);
    expect(find.text('Addresses'), findsNothing);
    // The engine's own section is first, where the server's was.
    expect(find.text('Engine'), findsWidgets);
  });

  testWidgets('on: both come back', (tester) async {
    await open(tester, later: true);
    expect(inSidebar('Channels'), findsOneWidget);
    expect(find.text('Sync'), findsWidgets);
  });
}
