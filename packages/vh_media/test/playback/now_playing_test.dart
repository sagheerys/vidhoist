import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import 'fake_player_port.dart';

import '../icon_finder.dart';

/// **Tablet guards**: the player panel beside the library, its two tabs,
/// and the full player's tablet forms. A phone keeps the queue and the
/// extra as buttons that open sheets.
void main() {
  testWidgets('**the guard**: a tab with a long label shrinks to its panel, '
      'ellipsized, rather than spill past it', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: vhTheme(VhVariant.phone, Brightness.light),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 160,
              child: Wrap(
                children: [
                  VhPanelTab(
                    icon: VhIcons.queue,
                    label: 'Als Nächstes in der Warteschlange · 12',
                    selected: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(VhPanelTab)).width,
      lessThanOrEqualTo(160),
    );
  });

  late MemoryKeyValueStore store;
  late VhAudioHandler handler;

  setUp(() {
    store = MemoryKeyValueStore();
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

  PlaylistItem clip(String id) => PlaylistItem(
    canonicalUrl: 'https://x/$id',
    title: id,
    serverFilename: '$id.mp3',
    isAudio: true,
  );

  VhVideoPanel transcript(PlaylistItem item) => VhVideoPanel(
    icon: VhIcons.transcript,
    label: 'Transcript',
    builder: (context, close) => Text('words of ${item.title}'),
  );

  Future<void> pump(WidgetTester tester, Size size, Widget child) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: vhTheme(VhVariant.desktop, Brightness.light),
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        home: child,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  group('the tabs', () {
    Widget tabs({bool companion = true}) => Scaffold(
      body: VhNowPlayingTabs(
        handler: handler,
        companion: companion ? transcript : null,
      ),
    );

    testWidgets('the companion opens first, and the queue is a tap away', (
      tester,
    ) async {
      await tester.runAsync(() => handler.playItems([clip('a'), clip('b')]));
      await pump(tester, const Size(400, 800), tabs());
      expect(find.text('words of a'), findsOneWidget);
      await tester.tap(find.textContaining('Up next'));
      await tester.pump();
      expect(find.text('words of a'), findsNothing);
      expect(find.byType(VhUpNextList), findsOneWidget);
    });

    testWidgets('with no companion the queue is the only tab', (tester) async {
      await tester.runAsync(() => handler.playItems([clip('a'), clip('b')]));
      await pump(tester, const Size(400, 800), tabs(companion: false));
      expect(find.text('Transcript'), findsNothing);
      expect(find.byType(VhUpNextList), findsOneWidget);
    });
  });

  group('the panel', () {
    Widget panel(void Function() onCollapse) => Scaffold(
      body: SizedBox(
        width: VhBreakpoint.sidePanel,
        child: VhNowPlayingPanel(
          handler: handler,
          onOpen: () {},
          onCollapse: onCollapse,
          companion: transcript,
        ),
      ),
    );

    testWidgets('is empty while nothing plays', (tester) async {
      await pump(tester, const Size(1280, 800), panel(() {}));
      expect(find.byType(VhPlayerControlsRow), findsNothing);
    });

    testWidgets('shows the controls and the transcript, and folds away', (
      tester,
    ) async {
      var folded = 0;
      await tester.runAsync(() => handler.playItems([clip('a'), clip('b')]));
      await pump(tester, const Size(1280, 800), panel(() => folded++));
      expect(find.byType(VhPlayerControlsRow), findsOneWidget);
      expect(find.text('words of a'), findsOneWidget);
      await tester.tap(byVhIcon(VhIcons.collapse));
      expect(folded, 1);
    });

    testWidgets('fits a small tablet on its side at a large font', (
      tester,
    ) async {
      await tester.runAsync(() => handler.playItems([clip('a'), clip('b')]));
      // 948x544 is an 8-inch tablet's window on its side; 2.0 is Android's
      // largest font.
      for (final size in const [
        Size(948, 544),
        Size(960, 600),
        Size(1280, 800),
      ]) {
        for (final scale in const [1.3, 2.0]) {
          await pump(
            tester,
            size,
            MediaQuery(
              data: MediaQueryData(
                size: size,
                textScaler: TextScaler.linear(scale),
              ),
              child: panel(() {}),
            ),
          );
          expect(tester.takeException(), isNull, reason: '$size at $scale');
        }
      }
    });
  });

  group('the full audio screen', () {
    Widget screen() =>
        VhAudioScreen(handler: handler, companion: transcript, extra: _extra);

    testWidgets('a phone keeps the queue and the extra as buttons', (
      tester,
    ) async {
      await tester.runAsync(() => handler.playItems([clip('a'), clip('b')]));
      await pump(tester, const Size(411, 914), screen());
      expect(find.byType(VhNowPlayingTabs), findsNothing);
      expect(byVhIcon(VhIcons.queue), findsOneWidget);
      expect(byVhIcon(VhIcons.favoriteOn), findsOneWidget);
    });

    testWidgets('the square cover draws its own picture', (tester) async {
      // The wide YouTube thumbnail goes to the big square only; list rows
      // keep theirs.
      await tester.runAsync(() => handler.playItems([clip('a'), clip('b')]));
      await pump(
        tester,
        const Size(411, 914),
        VhAudioScreen(
          handler: handler,
          artwork: (_, _) => const SizedBox(key: Key('row')),
          cover: (_, _) => const SizedBox(key: Key('cover')),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(VhTiltedArtwork),
          matching: find.byKey(const Key('cover')),
        ),
        findsOneWidget,
      );
      expect(find.byKey(const Key('row')), findsNothing);
    });

    testWidgets('a phone on its side sets the cover beside the controls', (
      tester,
    ) async {
      // Held sideways, the player used to have no cover.
      await tester.runAsync(() => handler.playItems([clip('a'), clip('b')]));
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      for (final size in const [
        Size(823, 360),
        Size(915, 390),
        Size(640, 320),
      ]) {
        for (final scale in const [1.0, 1.3, 2.0]) {
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          await pump(tester, size, screen());
          expect(tester.takeException(), isNull, reason: '$size at $scale');
          final cover = tester.getRect(find.byType(VhTiltedArtwork));
          final controls = tester.getRect(find.byType(VhPlayerControlsRow));
          expect(cover.height, greaterThan(size.height / 2), reason: '$size');
          expect(cover.overlaps(controls), isFalse, reason: '$size');
        }
      }
      expect(find.byType(VhNowPlayingTabs), findsNothing);
    });

    testWidgets('a tablet on its side puts the tabs in a second column', (
      tester,
    ) async {
      await tester.runAsync(() => handler.playItems([clip('a'), clip('b')]));
      await pump(tester, const Size(1280, 800), screen());
      final tabs = tester.getRect(find.byType(VhNowPlayingTabs));
      final controls = tester.getRect(find.byType(VhPlayerControlsRow));
      expect(tabs.left, greaterThan(controls.right));
      expect(byVhIcon(VhIcons.favoriteOn), findsNothing);
    });

    testWidgets('an 8-inch tablet of 593 points on its side counts too', (
      tester,
    ) async {
      await tester.runAsync(() => handler.playItems([clip('a'), clip('b')]));
      await pump(tester, const Size(948, 544), screen());
      expect(find.byType(VhNowPlayingTabs), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a tablet upright puts the tabs under the controls', (
      tester,
    ) async {
      await tester.runAsync(() => handler.playItems([clip('a'), clip('b')]));
      await pump(tester, const Size(800, 1280), screen());
      final tabs = tester.getRect(find.byType(VhNowPlayingTabs));
      final controls = tester.getRect(find.byType(VhPlayerControlsRow));
      expect(tabs.top, greaterThan(controls.bottom));
      expect(find.text('words of a'), findsOneWidget);
    });
  });

  group('the mini player', () {
    testWidgets('offers the panel back only when asked to', (tester) async {
      await tester.runAsync(() => handler.playItems([clip('a')]));
      await pump(
        tester,
        const Size(411, 914),
        Scaffold(
          bottomNavigationBar: VhMiniPlayer(handler: handler, onOpen: () {}),
        ),
      );
      expect(byVhIcon(VhIcons.fullscreen), findsNothing);

      var expanded = 0;
      await pump(
        tester,
        const Size(1280, 800),
        Scaffold(
          bottomNavigationBar: VhMiniPlayer(
            handler: handler,
            onOpen: () {},
            onExpand: () => expanded++,
          ),
        ),
      );
      await tester.tap(byVhIcon(VhIcons.fullscreen));
      expect(expanded, 1);
    });
  });
}

VhExtraAction? _extra(PlaylistItem item) =>
    VhExtraAction(icon: VhIcons.favoriteOn, label: 'Extra', onTap: () {});
