import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/engine_fetch_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/platform/engine_locator.dart';
import 'package:vidhoist_desktop/shell/engine_line.dart';

/// The sidebar's foot, where the server's address was: the engine's
/// version, quiet while all is well, and in one click its update and the
/// IPv4 choice.
void main() {
  late FakeBackend backend;
  late MemoryKeyValueStore store;

  setUp(() {
    backend = FakeBackend();
    store = MemoryKeyValueStore();
  });

  Future<void> pump(
    WidgetTester tester, {
    bool found = true,
    Map<EnginePart, PartFetch> fetching = const {},
    Locale locale = const Locale('en'),
    bool night = false,
  }) async {
    final locator = EngineLocator(
      ownFolder: r'C:\e',
      pathFolders: const [],
      exists: (path) => found && path == r'C:\e\yt-dlp\yt-dlp.exe',
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyValueStoreProvider.overrideWithValue(store),
          engineLocatorProvider.overrideWithValue(locator),
          downloadBackendProvider.overrideWithValue(backend),
          if (fetching.isNotEmpty)
            engineFetchProvider.overrideWith(() => _Fetching(fetching)),
        ],
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          theme: vhDesktopTheme(
            VhVariant.desktop,
            night ? Brightness.dark : Brightness.light,
          ),
          home: const Scaffold(
            body: SizedBox(width: 240, child: SidebarEngineLine(narrow: false)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('**the guard**: an engine that is there is quiet, with its '
      'version', (tester) async {
    await pump(tester);
    expect(find.byKey(const ValueKey('engine-quiet')), findsOneWidget);
    expect(find.byKey(const ValueKey('engine-dot')), findsNothing);
    expect(find.textContaining('2026.10.26'), findsOneWidget);
  });

  testWidgets('no yt-dlp: a dot, and the line says so', (tester) async {
    await pump(tester, found: false);
    expect(find.byKey(const ValueKey('engine-dot')), findsOneWidget);
    final l = lookupVhLocalizations(const Locale('en'));
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is VhShortcutTooltip &&
            w.message.contains(l.desktopEngineMissing),
      ),
      findsOneWidget,
    );
  });

  testWidgets('a part being fetched shows how far', (tester) async {
    await pump(
      tester,
      fetching: {EnginePart.ffmpeg: const PartFetch(fraction: 0.4)},
    );
    expect(find.textContaining('40%'), findsOneWidget);
  });

  testWidgets('its menu turns IPv4 off', (tester) async {
    await pump(tester);
    final l = lookupVhLocalizations(const Locale('en'));
    await tester.tap(find.byType(SidebarEngineLine));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.desktopEngineIpv4));
    await tester.pumpAndSettle();
    expect(await store.getBool(EngineOptionsNotifier.ipv4Key), isFalse);
  });

  testWidgets('its menu updates yt-dlp', (tester) async {
    await pump(tester);
    final l = lookupVhLocalizations(const Locale('en'));
    await tester.tap(find.byType(SidebarEngineLine));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.desktopEngineUpdate));
    await tester.pumpAndSettle();
    expect(backend.updates, 1);
    expect(find.text(l.desktopEngineUpToDate), findsOneWidget);
  });

  for (final locale in const [Locale('en'), Locale('ar')]) {
    for (final night in [false, true]) {
      testWidgets('fits narrow, ${locale.languageCode}, '
          '${night ? 'night' : 'day'}', (tester) async {
        await pump(
          tester,
          locale: locale,
          night: night,
          fetching: {EnginePart.deno: const PartFetch(fraction: 0.5)},
        );
        expect(tester.takeException(), isNull);
      });
    }
  }
}

class _Fetching extends EngineFetchNotifier {
  _Fetching(this.initial);

  final Map<EnginePart, PartFetch> initial;

  @override
  Map<EnginePart, PartFetch> build() => initial;
}
