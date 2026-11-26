import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/item_reveal.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_screen.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/downloads_library/media_access.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

/// **A tap on "download complete" brings the clip before the user's eyes.**
/// It used to light the item and nothing more: no scroll to it, and a list
/// scrolled elsewhere, searched or filtered left it out of sight.
void main() {
  final items = [
    for (var i = 0; i < 60; i++)
      LocalItem(
        key: 'https://www.youtube.com/watch?v=item$i',
        canonicalUrl: 'https://www.youtube.com/watch?v=item$i',
        path:
            '/storage/emulated/0/Download/VidHoist/item$i.'
            '${i.isEven ? 'mp4' : 'mp3'}',
        title: 'Clip number $i',
        sizeBytes: 1000000,
        modified: DateTime(2026, 11, 23).subtract(Duration(hours: i)),
      ),
  ];
  String keyOf(int i) => items[i].key;

  late ProviderContainer container;

  Future<void> pumpLibrary(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.reset);
    container = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        secretStoreProvider.overrideWithValue(MemorySecretStore()),
        prefsMutexProvider.overrideWithValue(PrefsMutex()),
        initialSettingsProvider.overrideWithValue(const PhoneSettings()),
        mediaAccessGateProvider.overrideWithValue(
          MediaAccessGate(
            probe: () async => true,
            isGranted: (_) async => true,
            ask: (_) async => true,
          ),
        ),
        localMediaProvider.overrideWith((ref) async => items),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          theme: vhTheme(VhVariant.phone, Brightness.light),
          home: const LibraryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> reveal(WidgetTester tester, String key) async {
    container.read(itemRevealProvider.notifier).state = ItemReveal(key);
    await tester.pumpAndSettle();
  }

  bool onScreen(WidgetTester tester, String title) {
    final found = find.text(title);
    if (found.evaluate().isEmpty) return false;
    final box = tester.getRect(found.first);
    return box.top >= 0 && box.bottom <= 800;
  }

  testWidgets('scrolls far down the list to the item and lights it', (
    tester,
  ) async {
    await pumpLibrary(tester);
    expect(onScreen(tester, 'Clip number 52'), isFalse);

    await reveal(tester, keyOf(52));

    expect(onScreen(tester, 'Clip number 52'), isTrue);
    expect(container.read(highlightedItemProvider), keyOf(52));
    expect(container.read(itemRevealProvider), isNull);
  });

  testWidgets('a filter that hides the item is undone, one that shows it '
      'is kept', (tester) async {
    await pumpLibrary(tester);
    final view = container.read(libraryViewProvider.notifier);

    view.setType(MediaTypeFilter.audio);
    await tester.pumpAndSettle();
    await reveal(tester, keyOf(41)); // an audio file: the filter stays
    expect(container.read(libraryViewProvider).type, MediaTypeFilter.audio);
    expect(onScreen(tester, 'Clip number 41'), isTrue);

    await reveal(tester, keyOf(40)); // a video: the filter goes
    expect(container.read(libraryViewProvider).type, MediaTypeFilter.all);
    expect(onScreen(tester, 'Clip number 40'), isTrue);
  });

  testWidgets('a search that leaves the item out is cleared, and selection '
      'ends', (tester) async {
    await pumpLibrary(tester);
    final view = container.read(libraryViewProvider.notifier);
    view.setQuery('number 3');
    view.toggleSelected(keyOf(3));
    await tester.pumpAndSettle();

    await reveal(tester, keyOf(57));

    final options = container.read(libraryViewProvider);
    expect(options.query, isEmpty);
    expect(options.selecting, isFalse);
    expect(onScreen(tester, 'Clip number 57'), isTrue);
  });

  testWidgets('**the guard**: back undoes a selection and stays in the '
      'library; the next back may leave', (tester) async {
    await pumpLibrary(tester);
    final view = container.read(libraryViewProvider.notifier);
    view.toggleSelected(keyOf(1));
    view.toggleSelected(keyOf(2));
    await tester.pumpAndSettle();
    final route = ModalRoute.of(tester.element(find.byType(LibraryScreen)))!;
    expect(route.popDisposition, RoutePopDisposition.doNotPop);
    // As Android's back does: the route is asked, and here refuses.
    final left = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(left, isTrue, reason: 'back was taken by the screen');
    expect(container.read(libraryViewProvider).selecting, isFalse);
    expect(find.byType(LibraryScreen), findsOneWidget);
    expect(route.popDisposition, isNot(RoutePopDisposition.doNotPop));
  });

  testWidgets('a clip deleted since says so instead of doing nothing', (
    tester,
  ) async {
    await pumpLibrary(tester);
    await reveal(tester, 'https://www.youtube.com/watch?v=gone');
    final l10n = tester.element(find.byType(LibraryScreen)).vhl;
    expect(find.text(l10n.notificationClipGone), findsOneWidget);
    expect(container.read(highlightedItemProvider), isNull);
  });

  testWidgets('players, sheets and dialogs above the tabs all close', (
    tester,
  ) async {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Text('library')),
        GoRoute(path: '/player', builder: (_, _) => const Text('player')),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    unawaited(router.push('/player'));
    await tester.pumpAndSettle();
    final context = tester.element(find.text('player'));
    unawaited(
      showDialog<void>(context: context, builder: (_) => const Text('dialog')),
    );
    await tester.pumpAndSettle();
    expect(find.text('dialog'), findsOneWidget);

    openLibraryForReveal(router);
    await tester.pumpAndSettle();

    expect(find.text('dialog'), findsNothing);
    expect(find.text('player'), findsNothing);
    expect(find.text('library'), findsOneWidget);
  });
}
