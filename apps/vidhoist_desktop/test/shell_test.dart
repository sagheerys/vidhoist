import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vidhoist_desktop/shell/sidebar_items.dart';
import 'package:vidhoist_desktop/router.dart';
import 'package:vidhoist_desktop/shell/player_bar.dart';
import 'package:vidhoist_desktop/shell/right_panel.dart';
import 'package:vidhoist_desktop/shell/shell_layout.dart';
import 'package:vidhoist_desktop/shell/shell_metrics.dart';
import 'package:vidhoist_desktop/shell/sidebar.dart';
import 'package:vidhoist_desktop/shell/title_bar.dart';

import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';

import 'support/shell_harness.dart';

const _clip = PlaylistItem(
  canonicalUrl: 'https://youtu.be/ccccccccccc',
  title: 'Evening Raga',
);

void main() {
  Future<ShellHarness> open(
    WidgetTester tester,
    Size size, {
    ShellLayout layout = const ShellLayout(),
    bool arabic = false,
    bool loaded = false,
  }) async {
    ShellHarness.useWindow(tester, size);
    if (arabic) ShellHarness.useArabic(tester);
    final h = ShellHarness(layout: layout);
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    // The panel folds while nothing plays; [loaded] brings it out.
    if (loaded) {
      h.player.showPlaying(const [_clip], playing: false);
      await tester.pumpAndSettle();
    }
    return h;
  }

  double width(WidgetTester tester, Finder f) => tester.getSize(f).width;

  testWidgets('**the guard**: nothing playing, the panel folds by itself '
      'and comes out with the first clip, the saved choice untouched', (
    tester,
  ) async {
    final h = await open(tester, const Size(1440, 900));
    expect(find.byType(DesktopRightPanel), findsNothing);
    h.player.showPlaying(const [_clip], playing: false);
    await tester.pumpAndSettle();
    expect(find.byType(DesktopRightPanel), findsOneWidget);
    expect(await h.store.getString(ShellLayoutStore.key), isNull);
  });

  testWidgets("**the guard**: a clip's page keeps the panel while nothing "
      'plays: folded there, the picture grew past the window and jumped '
      'back as it started', (tester) async {
    await open(tester, const Size(1440, 900));
    expect(find.byType(DesktopRightPanel), findsNothing);
    GoRouter.of(tester.element(find.byType(DesktopSidebar)))
        .go(DesktopRoutes.item('https://youtu.be/ccccccccccc'));
    await tester.pumpAndSettle();
    expect(find.byType(DesktopRightPanel), findsOneWidget);
  });

  testWidgets('nothing playing, its button still opens the panel, and '
      'closing it again leaves it to come out with the next clip', (
    tester,
  ) async {
    final h = await open(tester, const Size(1440, 900));
    await tester.tap(byLabel('Show side panel'));
    await tester.pumpAndSettle();
    expect(find.byType(DesktopRightPanel), findsOneWidget);
    await tester.tap(byLabel('Hide side panel'));
    await tester.pumpAndSettle();
    expect(find.byType(DesktopRightPanel), findsNothing);
    h.player.showPlaying(const [_clip], playing: false);
    await tester.pumpAndSettle();
    expect(find.byType(DesktopRightPanel), findsOneWidget);
  });

  testWidgets('at 1440 the three columns stand side by side', (tester) async {
    await open(tester, const Size(1440, 900), loaded: true);
    expect(
      width(tester, find.byType(DesktopSidebar)),
      DesktopShellSize.sidebarWide,
    );
    expect(
      width(tester, find.byType(DesktopRightPanel)),
      DesktopShellSize.panel,
    );
    expect(
      tester.getSize(find.byType(DesktopPlayerBar)).height,
      DesktopShellSize.playerBar,
    );
    expect(
      tester.getSize(find.byType(DesktopTitleBar)).height,
      DesktopShellSize.titleBar,
    );
  });

  testWidgets('at 1200 the sidebar narrows and the panel stays', (
    tester,
  ) async {
    await open(tester, const Size(1200, 800), loaded: true);
    expect(
      width(tester, find.byType(DesktopSidebar)),
      DesktopShellSize.sidebarNarrow,
    );
    expect(find.byType(DesktopRightPanel), findsOneWidget);
  });

  testWidgets('at 1000 the panel is a layer, opened and closed by its button', (
    tester,
  ) async {
    final h = await open(tester, const Size(1000, 700));
    expect(find.byType(DesktopRightPanel), findsNothing);

    await tester.tap(byLabel('Show side panel'));
    await tester.pumpAndSettle();
    expect(find.byType(DesktopRightPanel), findsOneWidget);
    // A layer, so the user's saved choice is untouched.
    expect(await h.store.getString(ShellLayoutStore.key), isNull);

    await tester.tap(byLabel('Hide side panel'));
    await tester.pumpAndSettle();
    expect(find.byType(DesktopRightPanel), findsNothing);
  });

  testWidgets('folding a column is saved for the next start', (tester) async {
    final h = await open(tester, const Size(1440, 900), loaded: true);
    await tester.tap(byLabel('Hide side panel'));
    await tester.tap(find.byType(SidebarToggle));
    await tester.pumpAndSettle();
    expect(find.byType(DesktopRightPanel), findsNothing);
    expect(
      width(tester, find.byType(DesktopSidebar)),
      DesktopShellSize.sidebarNarrow,
    );
    final saved = await ShellLayoutStore(
      store: h.store,
      mutex: PrefsMutex(),
    ).read();
    expect(saved, const ShellLayout(sidebarNarrow: true, panelHidden: true));
  });

  testWidgets('the sidebar opens each place and shows which is current', (
    tester,
  ) async {
    await open(tester, const Size(1440, 900));
    DesktopPlace current() =>
        tester.widget<DesktopSidebar>(find.byType(DesktopSidebar)).current;
    for (final (label, place) in [
      ('Favorites', DesktopPlace.favorites),
      ('Playlists', DesktopPlace.playlists),
      ('Settings', DesktopPlace.settings),
      ('Library', DesktopPlace.library),
    ]) {
      await tester.tap(
        find.descendant(
          of: find.byType(DesktopSidebar),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
      expect(current(), place, reason: label);
    }

    // **The guard**: search has one door, the title bar's box (and
    // Ctrl+K). A sidebar entry opened the same palette a third way.
    expect(
      find.descendant(
        of: find.byType(DesktopSidebar),
        matching: find.text('Search'),
      ),
      findsNothing,
    );
    await tester.tap(find.text('Search titles and what was said…'));
    await tester.pumpAndSettle();
    expect(
      find.text('Search titles and what was said, or type > for commands'),
      findsOneWidget,
    );
    expect(current(), DesktopPlace.library);
  });

  testWidgets('back and forward walk the places visited', (tester) async {
    await open(tester, const Size(1440, 900));
    DesktopPlace current() =>
        tester.widget<DesktopSidebar>(find.byType(DesktopSidebar)).current;
    await tester.tap(find.text('Playlists'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    await tester.tap(byLabel('Back'));
    await tester.pumpAndSettle();
    expect(current(), DesktopPlace.playlists);
    await tester.tap(byLabel('Back'));
    await tester.pumpAndSettle();
    expect(current(), DesktopPlace.library);
    await tester.tap(byLabel('Forward'));
    await tester.pumpAndSettle();
    expect(current(), DesktopPlace.playlists);
  });

  testWidgets('**the gate**: moving around never touches the playback', (
    tester,
  ) async {
    final h = await open(tester, const Size(1440, 900));
    h.player.showPlaying([clip('Night Drive'), clip('Blue Hour')]);
    await tester.pumpAndSettle();
    final bar = tester.element(find.byType(DesktopPlayerBar));
    for (final label in ['Playlists', 'Settings', 'Library']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }
    await tester.tap(byLabel('Back'));
    await tester.pumpAndSettle();
    expect(h.player.calls, isEmpty);
    // The same bar, never rebuilt from scratch, still showing the clip.
    expect(tester.element(find.byType(DesktopPlayerBar)), same(bar));
    expect(
      find.descendant(
        of: find.byType(DesktopPlayerBar),
        matching: find.text('Night Drive'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('the player bar drives the player', (tester) async {
    final h = await open(tester, const Size(1440, 900));
    h.player.showPlaying([clip('Night Drive')]);
    await tester.pumpAndSettle();
    await tester.tap(byLabel('Pause'));
    await tester.tap(byLabel('Next'));
    await tester.tap(byLabel('Previous'));
    await tester.tap(byLabel('Shuffle'));
    await tester.tap(byLabel('Playback speed'));
    expect(h.player.calls, [
      'pause',
      'next',
      'previous',
      'shuffle true',
      'speed 1.25',
    ]);
  });

  testWidgets('with nothing queued the controls stay, dimmed and inert', (
    tester,
  ) async {
    final h = await open(tester, const Size(1440, 900));
    await tester.tap(byLabel('Play'), warnIfMissed: false);
    await tester.tap(byLabel('Next'), warnIfMissed: false);
    expect(h.player.calls, isEmpty);
    expect(find.text('Nothing playing'), findsWidgets);
  });

  testWidgets(
    'the queue button on the player bar opens "Up next" in the panel',
    (tester) async {
      await open(
        tester,
        const Size(1440, 900),
        layout: const ShellLayout(panelHidden: true),
      );
      expect(find.byType(DesktopRightPanel), findsNothing);
      await tester.tap(
        find.descendant(
          of: find.byType(DesktopPlayerBar),
          matching: byLabel('Queue'),
        ),
      );
      await tester.pumpAndSettle();
      final panel = tester.widget<DesktopRightPanel>(
        find.byType(DesktopRightPanel),
      );
      expect(panel.tab, PanelTab.upNext);
    },
  );

  testWidgets('the title bar works the window', (tester) async {
    final h = await open(tester, const Size(1440, 900));
    await tester.tap(byLabel('Minimize'));
    await tester.tap(byLabel('Maximize'));
    await tester.tap(byLabel('Close'));
    expect(h.controls.calls, ['minimize', 'toggleMaximize', 'close']);

    h.controls.maximized.value = true;
    await tester.pump();
    expect(byLabel('Restore down'), findsOneWidget);
  });

  testWidgets('a double click on the title bar maximizes', (tester) async {
    final h = await open(tester, const Size(1440, 900));
    final title = find.text('VidHoist');
    await tester.tap(title);
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(title);
    await tester.pumpAndSettle();
    expect(h.controls.calls, contains('toggleMaximize'));
  });

  testWidgets('in Arabic the sidebar moves right and the transport does not', (
    tester,
  ) async {
    await open(tester, const Size(1440, 900), arabic: true, loaded: true);
    final side = tester.getRect(find.byType(DesktopSidebar));
    final panel = tester.getRect(find.byType(DesktopRightPanel));
    expect(side.left, greaterThan(panel.left));
    expect(side.right, 1440);

    // Previous stays left of next, as time runs left to right.
    final previous = tester.getCenter(byLabel('السابق'));
    final next = tester.getCenter(byLabel('التالي'));
    expect(previous.dx, lessThan(next.dx));
  });

  for (final arabic in [false, true]) {
    for (final size in [const Size(960, 600), const Size(1920, 1080)]) {
      testWidgets('no overflow at $size, ${arabic ? 'Arabic' : 'English'}', (
        tester,
      ) async {
        for (final scale in [1.0, 1.3, 2.0]) {
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await open(tester, size, arabic: arabic);
          expect(tester.takeException(), isNull, reason: 'text x$scale');
        }
      });
    }
  }

  testWidgets('**the guard**: the last session comes back once, not at '
      'every page', (tester) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    final h = ShellHarness();
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    expect(h.player.restores, 1);
    await tester.tap(find.text('Playlists'));
    await tester.pumpAndSettle();
    expect(h.player.restores, 1);
  });
}
