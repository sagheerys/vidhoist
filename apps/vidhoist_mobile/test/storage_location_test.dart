import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/settings/settings_page.dart';
import 'package:vidhoist_mobile/features/settings/settings_sections.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/storage/phone_volumes.dart';
import 'package:vidhoist_mobile/features/storage/storage_location_tile.dart';

import 'device_matrix.dart';

/// A [VolumeSource] that answers what the test put in, as the phone would
/// on a refresh.
class FakeVolumes implements VolumeSource {
  FakeVolumes(this.list);
  List<PhoneVolume> list;

  @override
  Future<List<PhoneVolume>> volumes() async => list;
}

/// **Settings › Downloads › Save to** (plan item R4): the phone or a
/// memory card, and a plain word when there is no card or it is out.
void main() {
  const card = PhoneVolume(
    id: '1A2B-3C4D',
    path: '/storage/1A2B-3C4D',
    label: 'SD card',
  );

  late MemoryKeyValueStore store;
  setUp(() => store = MemoryKeyValueStore());

  Widget app(
    Widget home, {
    List<PhoneVolume> volumes = const [],
    PhoneSettings settings = const PhoneSettings(),
    Locale? locale,
  }) => ProviderScope(
    overrides: [
      keyValueStoreProvider.overrideWithValue(store),
      initialSettingsProvider.overrideWithValue(settings),
      initialVolumesProvider.overrideWithValue(volumes),
      volumeSourceProvider.overrideWithValue(FakeVolumes(volumes)),
    ],
    child: MaterialApp.router(
      locale: locale,
      theme: vhTheme(VhVariant.phone, Brightness.light),
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
      routerConfig: GoRouter(
        routes: [GoRoute(path: '/', builder: (_, _) => home)],
      ),
    ),
  );

  const downloads = SettingsPage(SettingsPane.downloads);

  VhLocalizations l10nOf(WidgetTester tester) =>
      tester.element(find.byType(StorageLocationTile)).vhl;

  testWidgets('with no card the row says phone storage, and the sheet says '
      'there is no card to pick', (tester) async {
    await tester.pumpWidget(app(downloads));
    await tester.pumpAndSettle();
    final l10n = l10nOf(tester);
    expect(find.text(l10n.storageLocation), findsOneWidget);
    expect(
      find.textContaining(l10n.storagePhone, findRichText: true),
      findsOneWidget,
    );

    await tester.tap(find.text(l10n.storageLocation));
    await tester.pumpAndSettle();
    expect(find.byType(StorageLocationSheet), findsOneWidget);
    expect(find.textContaining(l10n.storageNoCard), findsOneWidget);
  });

  testWidgets('a card is offered and picking it is kept', (tester) async {
    await tester.pumpWidget(app(downloads, volumes: const [card]));
    await tester.pumpAndSettle();
    final l10n = l10nOf(tester);

    await tester.tap(find.text(l10n.storageLocation));
    await tester.pumpAndSettle();
    expect(find.textContaining(l10n.storageNoCard), findsNothing);
    await tester.tap(find.text('SD card'));
    await tester.pumpAndSettle();

    expect(find.byType(StorageLocationSheet), findsNothing);
    expect(await store.getString(PhoneSettings.downloadVolumeKey), card.id);
    expect(find.textContaining('SD card', findRichText: true), findsOneWidget);
  });

  testWidgets('a chosen card that is out is said so on the row', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(downloads, settings: const PhoneSettings(downloadVolume: 'gone')),
    );
    await tester.pumpAndSettle();
    expect(find.text(l10nOf(tester).storageCardMissing), findsOneWidget);
  });

  testWidgets('a card put in after the start shows on opening the page', (
    tester,
  ) async {
    final source = FakeVolumes(const []);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyValueStoreProvider.overrideWithValue(store),
          initialSettingsProvider.overrideWithValue(
            const PhoneSettings(downloadVolume: '1A2B-3C4D'),
          ),
          volumeSourceProvider.overrideWithValue(source..list = const [card]),
        ],
        child: MaterialApp(
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: const Scaffold(body: StorageLocationTile()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('SD card', findRichText: true), findsOneWidget);
  });

  testWidgets('the page and the sheet fit every phone at every text size, '
      'in both languages', (tester) async {
    const long = PhoneVolume(
      id: 'B',
      path: '/storage/B',
      label: 'SanDisk Extreme microSDXC UHS-I card',
    );
    for (final locale in const [Locale('ar'), Locale('en')]) {
      await expectNoOverflow(
        tester,
        () => app(
          downloads,
          volumes: const [long],
          settings: const PhoneSettings(downloadVolume: 'B'),
          locale: locale,
        ),
      );
      await expectNoOverflow(
        tester,
        () => app(
          const Scaffold(body: StorageLocationSheet()),
          volumes: const [card, long],
          locale: locale,
        ),
      );
    }
  });
}
