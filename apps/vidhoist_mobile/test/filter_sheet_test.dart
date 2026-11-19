import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/downloads_library/widgets/library_chips.dart';
import 'package:vidhoist_mobile/features/downloads_library/widgets/sort_sheet.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'device_matrix.dart';
import 'widget_test.dart' show sample;

import 'icon_finder.dart';

/// **One chip row above the list**: the platform
/// row moved into the sort sheet, and a chosen platform shows in the first
/// row with its way out.
void main() {
  late ProviderContainer container;

  List<Override> overrides() => [
    keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
    secretStoreProvider.overrideWithValue(MemorySecretStore()),
    initialSettingsProvider.overrideWithValue(const PhoneSettings()),
    localMediaProvider.overrideWith(
      (ref) async => [
        sample('a'),
        sample('b', platform: MediaPlatform.youtube),
        sample('c', platform: MediaPlatform.youtube),
      ],
    ),
  ];

  Widget app(Widget below) => ProviderScope(
    overrides: overrides(),
    child: MaterialApp(
      theme: vhTheme(VhVariant.phone, Brightness.light),
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
      home: Scaffold(
        body: Consumer(
          builder: (context, ref, _) {
            container = ProviderScope.containerOf(context);
            return Column(
              children: [
                TextButton(
                  onPressed: () => showSortSheet(context, ref),
                  child: const Text('open'),
                ),
                below,
              ],
            );
          },
        ),
      ),
    ),
  );

  testWidgets('**the guard**: the platforms are in the sheet with their '
      'counts, and choosing one narrows the library', (tester) async {
    await tester.pumpWidget(app(const SizedBox()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Sort and site'), findsOneWidget);
    expect(find.text('All sites'), findsOneWidget);
    final youtube = find.textContaining('YouTube');
    await tester.ensureVisible(youtube);
    await tester.tap(youtube);
    await tester.pump();
    expect(container.read(libraryViewProvider).platform, MediaPlatform.youtube);
  });

  testWidgets('**the guard**: a chosen platform shows first in the chip row, '
      'and its ✕ clears it', (tester) async {
    await tester.pumpWidget(app(const LibraryFilterChips()));
    await tester.pumpAndSettle();
    expect(find.byType(InputChip), findsNothing);

    container
        .read(libraryViewProvider.notifier)
        .setPlatform(MediaPlatform.youtube);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(InputChip, 'YouTube'), findsOneWidget);

    await tester.tap(byVhIcon(VhIcons.close));
    await tester.pumpAndSettle();
    expect(container.read(libraryViewProvider).platform, isNull);
    expect(find.byType(InputChip), findsNothing);
  });

  testWidgets('**the guard**: the filter button shows a dot while a platform '
      'is chosen, and only then', (tester) async {
    await tester.pumpWidget(
      app(
        Consumer(
          builder: (context, ref, _) => VhFilterButton(
            tooltip: 'Sort and site',
            active: ref.watch(
              libraryViewProvider.select((o) => o.platform != null),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
    bool dot() => tester.widget<Badge>(find.byType(Badge)).isLabelVisible;
    expect(dot(), isFalse);
    container.read(libraryViewProvider.notifier).setType(MediaTypeFilter.audio);
    await tester.pump();
    expect(dot(), isFalse);
    container
        .read(libraryViewProvider.notifier)
        .setPlatform(MediaPlatform.youtube);
    await tester.pump();
    expect(dot(), isTrue);
  });

  testWidgets('the chosen favourites chip is ink, like the rest', (
    tester,
  ) async {
    await tester.pumpWidget(app(const LibraryFilterChips()));
    await tester.pumpAndSettle();
    container.read(libraryViewProvider.notifier).setScope(LocalScope.favorites);
    await tester.pumpAndSettle();
    final chip = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, 'Favorites'),
    );
    expect(chip.selected, isTrue);
    expect(chip.selectedColor, isNull);
  });

  testWidgets('the sheet with its platforms holds on every device', (
    tester,
  ) async {
    await expectNoOverflow(
      tester,
      () => ProviderScope(
        overrides: overrides(),
        child: MaterialApp(
          theme: vhTheme(VhVariant.phone, Brightness.light),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: const _OpensSheet(),
        ),
      ),
    );
  });
}

class _OpensSheet extends ConsumerStatefulWidget {
  const _OpensSheet();

  @override
  ConsumerState<_OpensSheet> createState() => _OpensSheetState();
}

class _OpensSheetState extends ConsumerState<_OpensSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showSortSheet(context, ref),
    );
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}
