import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/shell/panel_reveal.dart';
import 'package:vidhoist_desktop/features/downloads/downloads_button.dart';
import 'package:go_router/go_router.dart';
import 'package:vidhoist_desktop/features/settings/about_pane.dart';
import 'package:vidhoist_desktop/router.dart';
import 'package:vidhoist_desktop/shell/content_bar.dart';
import 'package:vidhoist_desktop/shell/desktop_mark.dart';
import 'package:vidhoist_desktop/shell/right_panel.dart';
import 'package:vidhoist_desktop/shell/shell_metrics.dart';
import 'package:vidhoist_desktop/shell/sidebar.dart';
import 'package:vidhoist_desktop/shell/sidebar_items.dart';
import 'package:vidhoist_desktop/shell/title_bar.dart';
import 'package:vidhoist_desktop/shell/ui_zoom.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import 'support/shell_harness.dart';

/// The window's one bar: the title bar carries back, search, downloads
/// and the two toggles, and every bare bit of it still moves the window.
void main() {
  Future<ShellHarness> open(
    WidgetTester tester, {
    Size size = const Size(1440, 900),
    bool arabic = false,
    double zoom = 1.0,
  }) async {
    ShellHarness.useWindow(tester, size);
    if (arabic) ShellHarness.useArabic(tester);
    final h = ShellHarness(library: const [], zoom: UiZoom(zoom));
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    // A clip loaded: the side panel, and its button's place over it, come
    // out only while something plays.
    h.player.showPlaying(const [
      PlaylistItem(canonicalUrl: 'https://youtu.be/ccccccccccc', title: 'Clip'),
    ], playing: false);
    await tester.pumpAndSettle();
    return h;
  }

  Finder tip(String en, String ar) => find.byWidgetPredicate(
    (w) => w is VhShortcutTooltip && (w.message == en || w.message == ar),
  );
  final panelButton = tip('Hide side panel', 'إخفاء اللوحة الجانبية');

  for (final arabic in [false, true]) {
    final lang = arabic ? ', in Arabic' : '';

    testWidgets('**the guard**: one bar: the tools sit in the title bar, and '
        'the sidebar starts right under it$lang', (tester) async {
      await open(tester, arabic: arabic);
      final bar = find.byType(DesktopTitleBar);
      expect(
        find.descendant(of: bar, matching: find.byType(DesktopContentBar)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: bar, matching: find.byType(DownloadsButton)),
        findsOneWidget,
      );
      expect(tester.getSize(bar).height, DesktopShellSize.titleBar);
      expect(
        tester.getTopLeft(find.byType(DesktopSidebar)).dy,
        DesktopShellSize.titleBar,
      );
    });

    testWidgets('**the guard**: the sidebar toggle stands over the sidebar, '
        "the panel's button over the panel$lang", (tester) async {
      await open(tester, arabic: arabic);
      final sidebar = tester.getRect(find.byType(DesktopSidebar));
      final toggle = tester.getCenter(find.byType(SidebarToggle));
      expect(toggle.dx, inInclusiveRange(sidebar.left, sidebar.right));
      final panel = tester.getRect(find.byType(DesktopRightPanel));
      final button = tester.getCenter(panelButton);
      expect(button.dx, inInclusiveRange(panel.left, panel.right));
    });

    testWidgets('**the guard**: the bare bar moves the window and a double '
        'click on it maximizes; a tool does neither and answers at once'
        '$lang', (tester) async {
      final h = await open(tester, arabic: arabic);
      // Between the search box and the downloads: bare bar.
      final search = tester.getRect(
        find
            .ancestor(
              of: find.text(
                arabic
                    ? 'ابحث في العناوين وما قيل…'
                    : 'Search titles and what '
                          'was said…',
              ),
              matching: find.byType(Material),
            )
            .first,
      );
      final downloads = tester.getRect(find.byType(DownloadsButton));
      final bare = Offset(
        arabic
            ? (downloads.right + search.left) / 2
            : (search.right + downloads.left) / 2,
        DesktopShellSize.titleBar / 2,
      );
      await tester.dragFrom(bare, const Offset(40, 0));
      await tester.pumpAndSettle();
      expect(h.controls.calls, contains('startDragging'));

      h.controls.calls.clear();
      await tester.tapAt(bare);
      await tester.pump(const Duration(milliseconds: 60));
      await tester.tapAt(bare);
      await tester.pumpAndSettle();
      expect(h.controls.calls, ['toggleMaximize']);

      // A click on a tool takes effect on the frame it ends, not after a
      // wait to learn whether a second click follows.
      h.controls.calls.clear();
      await tester.tap(panelButton);
      await tester.pump();
      // Closing on this very frame: the panel is on its way out.
      expect(
        tester.widget<PanelReveal>(find.byType(PanelReveal).first).shown,
        isFalse,
      );
      await tester.pumpAndSettle();
      expect(find.byType(DesktopRightPanel), findsNothing);
      expect(h.controls.calls, isEmpty);
    });
  }

  testWidgets("**the guard**: the app's mark stands in the title bar, the "
      'small cut there, and the full one beside the name in About', (
    tester,
  ) async {
    await open(tester);
    final inBar = find.descendant(
      of: find.byType(DesktopTitleBar),
      matching: find.byType(DesktopMark),
    );
    expect(inBar, findsOneWidget);
    expect(tester.getSize(inBar).width, lessThan(DesktopMark.smallBelow));

    GoRouter.of(tester.element(find.byType(DesktopSidebar)))
        .go(DesktopSettingsPane.about.route);
    await tester.pumpAndSettle();
    final inAbout = find.descendant(
      of: find.byType(AboutPane),
      matching: find.byType(DesktopMark),
    );
    expect(inAbout, findsOneWidget);
    expect(
      tester.getSize(inAbout).width,
      greaterThanOrEqualTo(DesktopMark.smallBelow),
    );
  });

  testWidgets('**the guard**: given room the search is a box; cramped, a '
      'button that still opens it', (tester) async {
    await open(tester);
    expect(find.text('Search titles and what was said…'), findsOneWidget);

    await open(tester, size: const Size(960, 600), zoom: 1.5);
    expect(find.text('Search titles and what was said…'), findsNothing);
    final button = tip('Search', 'البحث');
    expect(
      find.descendant(of: find.byType(DesktopContentBar), matching: button),
      findsOneWidget,
    );
  });
}
