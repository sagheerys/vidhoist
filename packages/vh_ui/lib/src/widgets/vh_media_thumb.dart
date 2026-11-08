import 'package:flutter/material.dart';

import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import 'vh_polish.dart';
import 'vh_thumb_pill.dart';

/// A row's thumbnail: the cover in a rounded frame, with the duration and
/// an audio mark over its corners. Shared by the phone row and the
/// tablet's table row, so the two never draw a cover differently.
class VhMediaThumb extends StatelessWidget {
  const VhMediaThumb({
    super.key,
    required this.width,
    required this.height,
    this.duration,
    this.playing = false,
    this.audio = false,
    this.child,
  });

  final double width;
  final double height;
  final String? duration;
  final bool playing;
  final bool audio;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: p.cardAlt,
        borderRadius: BorderRadius.circular(VhRadius.thumb),
        border: Border.all(color: p.line, width: VhThemeX.of(context).hairline),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          child ??
              vhCoverPlaceholder(
                context,
                size: 20,
                color: p.ink3,
                audio: audio,
              ),
          if (duration != null)
            PositionedDirectional(
              bottom: 5,
              start: 5,
              child: VhThumbPill.duration(duration!),
            ),
          // Without a cover the placeholder is already a music note, so a
          // second one would only repeat it.
          if (audio && child != null)
            PositionedDirectional(
              bottom: 5,
              end: 5,
              child: VhThumbPill.audio(),
            ),
        ],
      ),
    );
  }
}
