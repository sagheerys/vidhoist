import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:video_player/video_player.dart';

import '../models/playlist_item.dart';
import '../widgets/vh_up_next_list.dart';
import 'vh_video_open.dart';

/// The picture of the clip in the video player, at its own shape.
///
/// **An audio file has no picture**: a playlist
/// that mixes videos and songs plays them all in the video player, and a
/// song there reports a 0x0 frame, which drew as an empty black square,
/// held sideways or not. Its cover stands in, in a 16:9 frame like the
/// videos around it, and the music icon where there is no cover.
class VhVideoFrame extends StatelessWidget {
  const VhVideoFrame({
    super.key,
    required this.controller,
    required this.item,
    this.artwork,
  });

  final VideoPlayerController controller;
  final PlaylistItem? item;
  final VhArtworkBuilder? artwork;

  @override
  Widget build(BuildContext context) {
    final size = controller.value.size;
    if (!size.isEmpty) {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VhVideoView(controller),
      );
    }
    final cover = switch (item) {
      final item? => artwork?.call(context, item),
      null => null,
    };
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRect(
        child:
            cover ??
            VhIcon(VhIcons.music, size: 64, color: VhPalette.serverCardInk),
      ),
    );
  }
}
