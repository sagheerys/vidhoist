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

import 'package:vidhoist_mobile/features/shell/keyboard_trace.dart';

import 'icon_finder.dart';

/// **The keyboard never comes up by itself around a finished download.**
/// It did once, after a download, with nothing to say why. These hold the
/// app's side of it: a download that completes, and a tap on its
/// notification, leave no text field holding the keyboard; and when the
/// keyboard does rise, the diagnostic log says where.
void main() {
  final items = [
    for (var i = 0; i < 40; i++)
      LocalItem(
        key: 'https://v/item$i',
        canonicalUrl: 'https://v/item$i',
        path: '/storage/emulated/0/Download/VidHoist/item$i.mp4',
        title: 'Clip number $i',
        sizeBytes: 1000000,
        modified: DateTime(2026, 11, 23).subtract(Duration(hours: i)),
      ),
  ];
  late ProviderContainer container;
  late GoRouter router;

  Future<void> pumpApp(WidgetTester tester) async {
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
    late StatefulNavigationShell shell;
    router = GoRouter(
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            shell = navigationShell;
            return Consumer(
              builder: (context, ref, _) {
                ref.listen<ItemReveal?>(itemRevealProvider, (_, next) {
                  if (next != null) openLibraryForReveal(GoRouter.of(context));
                });
                return Scaffold(body: navigationShell);
              },
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(path: '/', builder: (_, _) => const LibraryScreen()),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/settings',
                  builder: (_, _) => const Scaffold(body: Text('settings')),
                ),
              ],
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('en'),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          theme: vhTheme(VhVariant.phone, Brightness.light),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(shell.currentIndex, 0);
  }

  Future<void> reveal(WidgetTester tester, int i) async {
    container.read(itemRevealProvider.notifier).state = ItemReveal(
      items[i].key,
    );
    await tester.pumpAndSettle();
  }

  /// No keyboard on screen and no text field waiting for one: with no
  /// field attached, Android has nothing to raise the keyboard for when
  /// the app returns to the front.
  void expectNoKeyboard(WidgetTester tester) {
    expect(tester.testTextInput.isVisible, isFalse);
    expect(tester.testTextInput.hasAnyClients, isFalse);
  }

  testWidgets('a tap on the notification with the search left open on '
      'another tab', (tester) async {
    await pumpApp(tester);
    await tester.tap(byVhIcon(VhIcons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Clip');
    await tester.pumpAndSettle();
    expect(tester.testTextInput.isVisible, isTrue);
    tester.testTextInput.hide();
    router.go('/settings');
    await tester.pumpAndSettle();
    await reveal(tester, 30);
    expectNoKeyboard(tester);
    // The search itself stays: it does not hide the clip.
    expect(container.read(libraryViewProvider).query, 'Clip');
  });

  testWidgets('**the guard**: a tap on the notification from the library, '
      'the search open on a word the clip matches', (tester) async {
    await pumpApp(tester);
    await tester.tap(byVhIcon(VhIcons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Clip');
    await tester.pumpAndSettle();
    // Hidden by hand: the field keeps the focus, which is what Android
    // looks for to raise the keyboard again as the app comes back.
    tester.testTextInput.hide();

    await reveal(tester, 30);

    expectNoKeyboard(tester);
    expect(container.read(libraryViewProvider).query, 'Clip');
  });

  testWidgets('a tap on the notification while the search hides the clip', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(byVhIcon(VhIcons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'number 3');
    await tester.pumpAndSettle();
    // The search field still has the focus and the keyboard, as when the
    // notification is tapped from the library itself.
    await reveal(tester, 25);
    expectNoKeyboard(tester);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('a tap on the notification over a sheet being typed in', (
    tester,
  ) async {
    await pumpApp(tester);
    final context = tester.element(find.byType(LibraryScreen));
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        builder: (_) => const TextField(autofocus: true),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.testTextInput.isVisible, isTrue);
    await reveal(tester, 25);
    expectNoKeyboard(tester);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('a download completing while the search is open does not '
      'bring the keyboard back', (tester) async {
    await pumpApp(tester);
    await tester.tap(byVhIcon(VhIcons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Clip');
    await tester.pumpAndSettle();
    tester.testTextInput.hide();
    // What a completed download does without any tap: lights the item and
    // reads the folder again.
    container.read(highlightedItemProvider.notifier).state = items[2].key;
    container.invalidate(localMediaProvider);
    await tester.pumpAndSettle();
    expect(tester.testTextInput.isVisible, isFalse);
  });

  testWidgets('the keyboard coming up is logged with the screen, and '
      'whether a field asked for it', (tester) async {
    final lines = <String>[];
    final trace = KeyboardTrace(lines.add);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: TextField())),
    );
    final context = tester.element(find.byType(Scaffold));

    // Raised with nothing focused: the system's doing.
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();
    trace.metricsChanged(context, '/settings');
    expect(lines.single, contains('/settings'));
    expect(lines.single, contains('no text field'));

    // Still up: nothing more is written.
    trace.metricsChanged(context, '/settings');
    expect(lines, hasLength(1));

    tester.view.viewInsets = FakeViewPadding.zero;
    await tester.pump();
    trace.metricsChanged(context, '/');
    await tester.tap(find.byType(TextField));
    await tester.pump();
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();
    trace.metricsChanged(context, '/');
    expect(lines, hasLength(2));
    expect(lines.last, contains('a text field has the focus'));
  });
}
