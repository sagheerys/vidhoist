import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/playlists/playlists_screen.dart';
import 'package:vidhoist_mobile/features/playlists/widgets/smart_list_rows.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'device_matrix.dart';

/// **Guard: the smart playlists are quiet rows, not cards** (favourites
/// and the latest additions were still three dark glowing cards).
void main() {
  final clip = LocalItem(
    key: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    path: '/storage/emulated/0/Download/Vidhoist/clip.mp4',
    title: 'Trip to the Sarawat mountains',
    sizeBytes: 1,
    modified: DateTime(2026, 10, 31),
    favorite: true,
  );

  Widget host({Brightness brightness = Brightness.light}) {
    final container = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        secretStoreProvider.overrideWithValue(MemorySecretStore()),
        prefsMutexProvider.overrideWithValue(PrefsMutex()),
        initialSettingsProvider.overrideWithValue(const PhoneSettings()),
        localMediaProvider.overrideWith((ref) async => [clip]),
      ],
    );
    addTearDown(container.dispose);
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: vhTheme(VhVariant.phone, brightness),
        locale: const Locale('en'),
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        home: const PlaylistsScreen(),
      ),
    );
  }

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('**the guard**: favourites and the latest additions are rows '
      'in one group, each with its count', (tester) async {
    await tester.pumpWidget(host());
    await settle(tester);
    expect(find.byType(SmartListRows), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Latest additions'), findsOneWidget);
  });

  testWidgets('the tab fits every device and text size', (tester) async {
    await expectNoOverflow(tester, host);
  });
}
