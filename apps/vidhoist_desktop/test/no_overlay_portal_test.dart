import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vidhoist_desktop/router.dart';
import 'package:vidhoist_desktop/shell/sidebar.dart';
import 'package:vh_media/library.dart';

import 'support/shell_harness.dart';

/// Flutter grafts an `OverlayPortal`'s overlay node back under the node of
/// the place it was built in, and a node keeps only one such mark. Two
/// portals meeting in one node (Material's Slider keeps its bubble's
/// portal always shown; every Material Tooltip builds one) sent Windows'
/// accessibility bridge a node with no parent: the bridge rejected the
/// update, and a tree losing updates that way crashed the app. The app's
/// screens build none.
void main() {
  final clip = LibraryItem(
    canonicalUrl: 'https://youtu.be/aaaaaaaaaaa',
    title: 'Night Drive',
    serverFilename: 'Night Drive.mp4',
    timestamp: DateTime(2026, 10, 20),
  );

  testWidgets('**the guard**: no screen builds an OverlayPortal, playing, '
      'with a tooltip showing', (tester) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    final h = ShellHarness(library: [clip], withEngine: true);
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    h.player.showPlaying([toPlaylistItem(clip)], playing: false);
    await tester.pumpAndSettle();

    // A tooltip on show: the pointer rests on the play button.
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(byLabel('Play')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.textContaining('Play', findRichText: true), findsWidgets);

    for (final route in [
      DesktopRoutes.library,
      DesktopRoutes.playlists,
      DesktopRoutes.item(clip.canonicalUrl),
      DesktopSettingsPane.appearance.route,
      DesktopSettingsPane.downloads.route,
    ]) {
      GoRouter.of(tester.element(find.byType(DesktopSidebar))).go(route);
      await tester.pumpAndSettle();
      expect(find.byType(OverlayPortal), findsNothing, reason: route);
      expect(find.byType(Tooltip), findsNothing, reason: route);
    }
  });
}
