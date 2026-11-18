import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';

/// **Back to the library tab, and only then what the share opens.**
///
/// A share always lands on the library. When the app was left on a screen
/// above the tabs (the video player, the audio screen, a batch), the move
/// closes that screen, but only on the next frame. A sheet opened in the
/// meantime belongs to the screen being closed and goes with it: the add
/// sheet showed for a fraction of a second, and the link was lost.
Future<void> landOnLibrary(StatefulNavigationShell shell) async {
  shell.goBranch(0);
  await WidgetsBinding.instance.endOfFrame;
}

/// **Whether a shared link is followed before anything shows** (field
/// report 2026-11-17: TikTok's sheet came seconds late). Following a short
/// link costs up to five seconds; the sheet follows it itself once open.
/// Waiting is worth it only when the link may be a playlist, or when it
/// downloads at once with no sheet, under the address it will be filed by.
bool shareWaitsForLink(String url, {required bool quick}) =>
    quick || ShortLinkResolver.mayHidePlaylist(url);
