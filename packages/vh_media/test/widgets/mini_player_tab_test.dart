import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import '../playback/fake_player_port.dart';

/// **The mini player on a screen with no room for its bar**: a tab at the
/// edge where lines start, opening into the bar and folding back.
void main() {
  late VhAudioHandler handler;

  setUp(() {
    final store = MemoryKeyValueStore();
    final mutex = PrefsMutex();
    handler = VhAudioHandler(
      player: FakePlayerPort(),
      resolver: PlaybackSourceResolver(
        endpoint: ServerStreamEndpoint(
          buildUrl: (name) => 'https://srv/download/$name',
          headers: const {},
        ),
        fileExists: (_) => false,
      ),
      positions: PlaybackPositionStore(store: store, mutex: mutex),
      prefs: PlaybackPrefs(store: store, mutex: mutex),
      stateStore: AudioStateStore(store: store, mutex: mutex),
      saveInterval: const Duration(hours: 1),
    );
  });
  tearDown(() => handler.dispose());

  Future<void> play(WidgetTester tester) => tester.runAsync(
    () => handler.playItems([
      const PlaylistItem(
        canonicalUrl: 'https://x/a',
        title: 'Rain sounds',
        serverFilename: 'a.mp3',
        isAudio: true,
      ),
      const PlaylistItem(
        canonicalUrl: 'https://x/b',
        title: 'Night drive',
        serverFilename: 'b.mp3',
        isAudio: true,
      ),
    ]),
  );

  Future<void> pump(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    bool visible = true,
    double keyboard = 0,
    bool still = true,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        theme: vhTheme(VhVariant.phone, Brightness.light),
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              viewInsets: EdgeInsets.only(bottom: keyboard),
              // The level bars move for as long as something plays, so
              // the tests settle with motion off, as the phone does when
              // asked for no motion; one test below keeps it on.
              disableAnimations: still,
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  const Positioned.fill(child: Text('settings')),
                  PositionedDirectional(
                    start: 0,
                    bottom: 16,
                    child: VhMiniPlayerTab(
                      handler: handler,
                      visible: visible,
                      onOpen: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    if (still) await tester.pumpAndSettle();
  }

  Finder tab(WidgetTester tester) => find.bySemanticsLabel(
    tester.element(find.text('settings')).vhl.miniPlayerTab('Rain sounds'),
  );

  testWidgets('nothing playing, no tab', (tester) async {
    await pump(tester);
    expect(find.byType(VhMiniPlayerBar), findsNothing);
    expect(tester.getSize(find.byType(VhMiniPlayerTab)).width, 0);
  });

  testWidgets('a tap opens the bar, which folds back by itself', (
    tester,
  ) async {
    await play(tester);
    await pump(tester);
    expect(tab(tester), findsOneWidget);
    expect(find.byType(VhMiniPlayerBar), findsNothing);

    await tester.tap(tab(tester));
    await tester.pumpAndSettle();
    expect(find.byType(VhMiniPlayerBar), findsOneWidget);
    expect(find.text('Rain sounds'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.byType(VhMiniPlayerBar), findsNothing);
    expect(tab(tester), findsOneWidget);
  });

  testWidgets('a touch outside folds it at once, a touch inside keeps it', (
    tester,
  ) async {
    await play(tester);
    await pump(tester);
    await tester.tap(tab(tester));
    await tester.pumpAndSettle();

    // Using it restarts the countdown.
    await tester.pump(const Duration(seconds: 3));
    await tester.tap(
      find.byTooltip(tester.element(find.text('settings')).vhl.next),
    );
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(VhMiniPlayerBar), findsOneWidget);

    await tester.tapAt(const Offset(200, 100));
    await tester.pumpAndSettle();
    expect(find.byType(VhMiniPlayerBar), findsNothing);
  });

  testWidgets('the keyboard and leaving the screen hide it', (tester) async {
    await play(tester);
    await pump(tester, keyboard: 300);
    expect(tab(tester), findsNothing);
    await pump(tester, visible: false);
    expect(tab(tester), findsNothing);
  });

  testWidgets('its bars move while playing, unless motion is off', (
    tester,
  ) async {
    await play(tester);
    await pump(tester, still: false);
    await tester.pump(const Duration(milliseconds: 500));
    double tallest() => tester
        .widgetList<Container>(
          find.descendant(
            of: find.byType(VhMiniPlayerTab),
            matching: find.byType(Container),
          ),
        )
        .map((c) => c.constraints?.maxHeight ?? 0)
        .where((h) => h < 20)
        .fold(0.0, (a, b) => a > b ? a : b);
    final first = tallest();
    await tester.pump(const Duration(milliseconds: 200));
    expect(tallest(), isNot(first));

    await pump(tester);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('it sits at the edge where lines start', (tester) async {
    await play(tester);
    await pump(tester);
    expect(tester.getRect(tab(tester)).left, 0);
    await pump(tester, locale: const Locale('ar'));
    expect(tester.getRect(tab(tester)).right, 400);
  });
}
