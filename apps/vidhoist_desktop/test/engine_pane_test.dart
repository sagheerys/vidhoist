import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/engine_fetch_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/features/settings/engine_pane.dart';
import 'package:vidhoist_desktop/features/settings/simple_panes.dart';
import 'package:vidhoist_desktop/platform/engine_fetcher.dart';
import 'package:vidhoist_desktop/platform/engine_locator.dart';

import 'desktop_matrix.dart';

/// Settings › Engine: each part and where it stands, a fetch for the ones
/// not here yet, yt-dlp's update, and IPv4.
void main() {
  late FakeBackend backend;
  late MemoryKeyValueStore store;
  late List<EnginePart> asked;

  setUp(() {
    backend = FakeBackend();
    store = MemoryKeyValueStore();
    asked = [];
  });

  Widget app({
    Brightness brightness = Brightness.light,
    Map<EnginePart, PartFetch> fetching = const {},
  }) => ProviderScope(
    overrides: [
      keyValueStoreProvider.overrideWithValue(store),
      engineLocatorProvider.overrideWithValue(
        EngineLocator(
          ownFolder: r'C:\e',
          pathFolders: const [],
          exists: (path) => path == r'C:\e\yt-dlp\yt-dlp.exe',
        ),
      ),
      downloadBackendProvider.overrideWithValue(backend),
      engineFetchProvider.overrideWith(() => _Fetches(asked, fetching)),
    ],
    child: MaterialApp(
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
      theme: vhDesktopTheme(VhVariant.desktop, brightness),
      home: const Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(VhSpace.lg),
          child: EnginePane(),
        ),
      ),
    ),
  );

  final l = lookupVhLocalizations(const Locale('en'));
  Finder switchOf(String title) => find.descendant(
    of: find.widgetWithText(SwitchLine, title),
    matching: find.byType(VhSwitch),
  );

  testWidgets('yt-dlp is there; ffmpeg and Deno can be fetched', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.textContaining('2026.10.26'), findsOneWidget);
    expect(find.text(l.desktopEngineFetch), findsNWidgets(2));
    await tester.tap(find.text(l.desktopEngineFetch).first);
    await tester.pumpAndSettle();
    expect(asked, [EnginePart.ffmpeg]);
  });

  testWidgets('a fetch under way shows its share; a failed one says why', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        fetching: {
          EnginePart.ffmpeg: const PartFetch(fraction: 0.25),
          EnginePart.deno: const PartFetch(failure: FetchFailure.corrupt),
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(l.desktopEngineFetching(25)), findsOneWidget);
    expect(find.text(l.desktopEngineFetchCorrupt), findsOneWidget);
  });

  testWidgets('the update runs and says how it went', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.desktopEngineUpdate).last);
    await tester.pumpAndSettle();
    expect(backend.updates, 1);
    expect(find.text(l.desktopEngineUpToDate), findsWidgets);
  });

  testWidgets('IPv4 is switched and kept', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(switchOf(l.desktopEngineIpv4));
    await tester.pumpAndSettle();
    expect(await store.getBool(EngineOptionsNotifier.ipv4Key), isFalse);
  });

  for (final brightness in Brightness.values) {
    testWidgets('fits at 960 and 1440, both languages, ${brightness.name}', (
      tester,
    ) async {
      await expectNoOverflow(
        tester,
        () => app(
          brightness: brightness,
          fetching: {EnginePart.deno: const PartFetch(fraction: 0.5)},
        ),
        windows: const [
          DesktopWindowSize('smallest 960x600', Size(960, 600)),
          DesktopWindowSize('laptop 1440x900', Size(1440, 900)),
        ],
      );
    });
  }
}

class _Fetches extends EngineFetchNotifier {
  _Fetches(this.asked, this.initial);

  final List<EnginePart> asked;
  final Map<EnginePart, PartFetch> initial;

  @override
  Map<EnginePart, PartFetch> build() => initial;

  @override
  Future<bool> fetch(EnginePart part) async {
    asked.add(part);
    return true;
  }
}
