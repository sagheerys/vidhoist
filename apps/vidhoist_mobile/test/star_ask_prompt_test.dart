import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/star/star_ask_prompt.dart';

import 'device_matrix.dart';

/// The star question on the phone: a sheet over the library after the
/// third download that finished, and over nothing else.
void main() {
  final l = lookupVhLocalizations(const Locale('en'));

  late MemoryKeyValueStore store;
  late List<String> opened;
  late ProviderContainer container;
  late GoRouter router;

  setUp(() {
    store = MemoryKeyValueStore();
    opened = [];
    container = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        starPageOpenerProvider.overrideWithValue(
          (url) async => opened.add(url),
        ),
      ],
    );
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) =>
              const StarAskPrompt(child: Scaffold(body: Text('library'))),
        ),
        GoRoute(
          path: '/settings',
          builder: (_, _) => const Scaffold(body: Text('settings')),
        ),
      ],
    );
  });

  tearDown(() {
    router.dispose();
    container.dispose();
  });

  Widget app() => UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
      theme: vhTheme(VhVariant.phone, Brightness.light),
    ),
  );

  /// As the download watcher does when a download finishes.
  Future<void> finish(WidgetTester tester, int n) async {
    for (var i = 0; i < n; i++) {
      await StarAsk(store).countFinished();
      container.read(finishedCountedProvider.notifier).state++;
    }
    await tester.pump(StarAskPrompt.settle);
    await tester.pumpAndSettle();
  }

  testWidgets('**the guard**: after the third finished download, a moment '
      'later, a sheet over the library; swiped away, it waits', (tester) async {
    await tester.pumpWidget(app());
    await finish(tester, 2);
    expect(find.byType(VhStarAsk), findsNothing);
    await StarAsk(store).countFinished();
    container.read(finishedCountedProvider.notifier).state++;
    await tester.pump();
    // The clip just arrived is seen first.
    expect(find.byType(VhStarAsk), findsNothing);
    await tester.pump(StarAskPrompt.settle);
    await tester.pumpAndSettle();
    expect(find.text(l.starAskTitle), findsOneWidget);
    await tester.tap(find.text(l.starAskLater));
    await tester.pumpAndSettle();
    expect(find.byType(VhStarAsk), findsNothing);
    await finish(tester, 1);
    expect(find.byType(VhStarAsk), findsNothing);
  });

  testWidgets('**the guard**: not on another page', (tester) async {
    await tester.pumpWidget(app());
    router.go('/settings');
    await tester.pumpAndSettle();
    await finish(tester, 3);
    expect(find.byType(VhStarAsk), findsNothing);
    // Still due: the next look from the library asks.
    expect(await StarAsk(store).isDue(), isTrue);
  });

  testWidgets('the star opens the repository and ends it', (tester) async {
    await tester.pumpWidget(app());
    await finish(tester, 3);
    await tester.tap(find.text(l.starAskStar));
    await tester.pumpAndSettle();
    expect(opened, [StarAsk.repoUrl]);
    expect(await StarAsk(store).isDue(), isFalse);
  });

  testWidgets('ideas and problems open GitHub\'s forms', (tester) async {
    await tester.pumpWidget(app());
    await finish(tester, 3);
    await tester.tap(find.text(l.starAskIdeas));
    await tester.pumpAndSettle();
    expect(opened, [StarAsk.ideasUrl]);
  });

  testWidgets('"Don\'t show this again" ends it', (tester) async {
    await tester.pumpWidget(app());
    await finish(tester, 3);
    await tester.tap(find.text(l.starAskNever));
    await tester.pumpAndSettle();
    expect(opened, isEmpty);
    await finish(tester, 25);
    expect(find.byType(VhStarAsk), findsNothing);
  });

  testWidgets('**device matrix**: the sheet fits every phone and font', (
    tester,
  ) async {
    for (final locale in const [Locale('en'), Locale('ar')]) {
      await expectNoOverflow(
        tester,
        () => MaterialApp(
          locale: locale,
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          theme: vhTheme(VhVariant.phone, Brightness.light),
          home: const Scaffold(body: _Sheet()),
        ),
      );
    }
  });
}

class _Sheet extends StatelessWidget {
  const _Sheet();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(VhSpace.xl),
      child: VhStarAsk(
        onStar: () {},
        onIdeas: () {},
        onLater: () {},
        onNever: () {},
      ),
    ),
  );
}
