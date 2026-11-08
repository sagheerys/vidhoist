import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import '../models/playlist_item.dart';
import '../widgets/vh_chapters.dart';
import '../widgets/vh_up_next_list.dart';
import 'vh_captions.dart';
import 'vh_video_controls.dart';
import 'vh_video_frame.dart';
import 'vh_video_session.dart';

/// The video and its controls in the player: a band at the top of the
/// screen upright, or the whole screen when [fill] is set.
class VideoArea extends StatelessWidget {
  const VideoArea({
    super.key,
    required this.session,
    required this.onBack,
    required this.onFullscreen,
    required this.onQueue,
    this.artwork,
    this.playlistName,
    this.membershipLine,
    this.fill = false,
    this.captions,
    this.chapters,
  });

  /// The share of the screen's height the player takes on a phone upright.
  static const double share = 0.32;

  /// Fills the screen in landscape instead of 32% of its height.
  final bool fill;
  final VhArtworkBuilder? artwork;
  final VhCaptions? Function(PlaylistItem item)? captions;
  final List<VhChapter> Function(PlaylistItem item)? chapters;

  final VhVideoSession session;
  final VoidCallback onBack;
  final VoidCallback onFullscreen;
  final VoidCallback onQueue;
  final String? playlistName;
  final String? membershipLine;

  @override
  Widget build(BuildContext context) {
    final controller = session.controller;
    final ready = controller != null && controller.value.isInitialized;
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: fill
            ? double.infinity
            : MediaQuery.sizeOf(context).height * share,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: VhPalette.serverCardBg),
            if (ready)
              Center(
                child: VhVideoFrame(
                  controller: controller,
                  item: session.current,
                  artwork: artwork,
                ),
              )
            else
              Center(
                child: session.error != null
                    ? VhIcon(VhIcons.alert, color: VhPalette.serverCardInk)
                    : const VhSpinner(color: VhPalette.serverCardInk),
              ),
            if (ready)
              VhVideoControls(
                session: session,
                captions: switch (session.current) {
                  final item? => captions?.call(item),
                  null => null,
                },
                chapters: switch (session.current) {
                  final item? => chapters?.call(item) ?? const [],
                  null => const [],
                },
                playlistName: playlistName,
                membershipLine: membershipLine,
                onBack: onBack,
                onToggleFullscreen: onFullscreen,
                onQueue: onQueue,
              ),
          ],
        ),
      ),
    );
  }
}
