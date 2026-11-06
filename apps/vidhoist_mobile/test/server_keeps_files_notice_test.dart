import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/settings/widgets/server_keeps_files_notice.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';

import 'device_matrix.dart';

/// **The notice for a server that keeps its files** (audit 2026-09-19).
///
/// It appears only while [TrashcanProbe] has seen the server serve a file
/// it was told to delete, which is why no other test of this screen ever
/// renders it: the settings tests leave the flag unset. A block that is
/// only ever drawn on one owner's phone is a block nobody has measured at
/// a large font on a small screen.
void main() {
  Widget host({required bool keeps, Locale locale = const Locale('ar')}) {
    final container = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        secretStoreProvider.overrideWithValue(MemorySecretStore()),
        prefsMutexProvider.overrideWithValue(PrefsMutex()),
        initialSettingsProvider.overrideWithValue(
          const LiteSettings(serverUrl: 'https://mt.example.com'),
        ),
        serverKeepsFilesProvider.overrideWith((ref) async => keeps),
      ],
    );
    addTearDown(container.dispose);
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: MTLocalizations.localizationsDelegates,
        supportedLocales: MTLocalizations.supportedLocales,
        theme: mtTheme(MTVariant.lite, Brightness.light),
        // Off the settings since the engine moved to the phone; tested on
        // its own until the server layer goes in batch 6.
        home: const Scaffold(
          body: SingleChildScrollView(child: ServerKeepsFilesNotice()),
        ),
      ),
    );
  }

  testWidgets('it is shown when the server keeps files, and only then', (
    tester,
  ) async {
    await tester.pumpWidget(host(keeps: true));
    await tester.pumpAndSettle();
    final l10n = MTLocalizations.of(tester.element(find.byType(Scaffold)));
    expect(find.text(l10n.serverKeepsFilesTitle), findsOneWidget);

    await tester.pumpWidget(host(keeps: false));
    await tester.pumpAndSettle();
    expect(find.text(l10n.serverKeepsFilesTitle), findsNothing);
  });

  testWidgets('**device matrix**: the notice overflows nothing, in either '
      'language', (tester) async {
    await expectNoOverflow(tester, () => host(keeps: true));
    await expectNoOverflow(
      tester,
      () => host(keeps: true, locale: const Locale('en')),
    );
  });
}
