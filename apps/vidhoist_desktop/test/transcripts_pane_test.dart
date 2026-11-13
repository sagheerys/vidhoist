import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_desktop/data/transcripts_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/features/settings/transcripts_pane.dart';
import 'package:vidhoist_desktop/router.dart';

import 'desktop_matrix.dart';

/// Settings › Transcripts: moving them to and from a phone lives under
/// Backup alone.
void main() {
  final l = lookupVhLocalizations(const Locale('en'));

  Widget app(GoRouter router, {Brightness brightness = Brightness.light}) =>
      ProviderScope(
        overrides: [
          keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
          transcriptStoreProvider.overrideWithValue(null),
        ],
        child: MaterialApp.router(
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          theme: vhDesktopTheme(VhVariant.desktop, brightness),
          routerConfig: router,
        ),
      );

  GoRouter router() => GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(VhSpace.lg),
            child: TranscriptsPane(),
          ),
        ),
      ),
      GoRoute(
        path: DesktopSettingsPane.backup.route,
        builder: (_, _) => const Text('backup pane'),
      ),
    ],
  );

  testWidgets('**the guard**: no import or export of its own; one link '
      'opens Backup, where both are', (tester) async {
    final r = router();
    addTearDown(r.dispose);
    await tester.pumpWidget(app(r));
    await tester.pumpAndSettle();

    expect(find.text('Import'), findsNothing);
    expect(find.text('Export'), findsNothing);
    expect(find.text(l.transcriptsDeleteAll), findsOneWidget);
    expect(find.text(l.desktopTranscriptsMoveHint), findsOneWidget);

    await tester.tap(find.text(l.desktopOpenBackup));
    await tester.pumpAndSettle();
    expect(find.text('backup pane'), findsOneWidget);
  });

  for (final brightness in Brightness.values) {
    testWidgets('fits at 960 and 1440, both languages, ${brightness.name}', (
      tester,
    ) async {
      final made = <GoRouter>[];
      addTearDown(() {
        for (final r in made) {
          r.dispose();
        }
      });
      await expectNoOverflow(
        tester,
        () => app((made..add(router())).last, brightness: brightness),
        windows: const [
          DesktopWindowSize('smallest 960x600', Size(960, 600)),
          DesktopWindowSize('laptop 1440x900', Size(1440, 900)),
        ],
      );
    });
  }
}
