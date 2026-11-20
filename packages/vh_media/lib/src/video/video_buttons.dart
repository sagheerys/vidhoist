import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import '../models/play_mode.dart';
import '../widgets/media_time.dart';
import 'vh_video_session.dart';

/// The standalone video chrome buttons, split out of
/// `video_control_bars.dart` when the speed button was added (the file
/// size limit).

/// The chrome buttons over the video: semi-transparent dark squares with
/// light ink.
class VhVideoIconButton extends StatelessWidget {
  const VhVideoIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.size = 36,
    this.active = false,
    this.onLongPress,
    this.longPressHint,
  });

  final VhIconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final double size;
  final bool active;

  /// A second action under a long press, said by [longPressHint] to a
  /// screen reader. With one the tooltip gives way: on a phone it shows on
  /// the same long press.
  final VoidCallback? onLongPress;
  final String? longPressHint;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final button = Material(
      color: active
          ? p.accent.withValues(alpha: 0.3)
          : Colors.black.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(VhRadius.field - 1),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(VhRadius.field - 1),
        child: SizedBox(
          width: size,
          height: size,
          // Subtitles on and off, the play mode, full screen: the
          // glyph swaps rather than jumps.
          child: VhIconSwap(
            icon: icon,
            size: size * 0.42,
            color: VhPalette.serverCardInk,
          ),
        ),
      ),
    );
    if (onLongPress == null) return Tooltip(message: tooltip, child: button);
    return Semantics(
      label: tooltip,
      onLongPressHint: longPressHint,
      child: button,
    );
  }
}

/// The speed button in **the player chrome**.
///
/// **Correcting an initial mistaken note:** the first reading was that
/// speed had no entry point at all, when in fact it has a chip in the video
/// info sheet at the bottom of the screen. But that sheet **does not exist
/// in full screen**, which is exactly the situation where you want to slow
/// a lesson down or speed an introduction up. So this button fills a real
/// gap rather than an imagined one.
///
/// A tap **cycles** through [vhNextSpeed], the same behaviour as the audio
/// player and the sheet, word for word, so the user never learns two rules
/// for the same idea.
class VhVideoSpeedButton extends StatelessWidget {
  const VhVideoSpeedButton({super.key, required this.session});

  final VhVideoSession session;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final speed =
        session.controller?.value.playbackSpeed ?? PlaybackSpeeds.normal;
    final normal = (speed - PlaybackSpeeds.normal).abs() < 0.01;
    return Tooltip(
      message: context.vhl.playbackSpeed,
      child: Material(
        // A non-normal speed is **a persistent state** that should be
        // visible without reading: the accent colour says "this clip is not
        // running at its original speed".
        color: normal
            ? Colors.black.withValues(alpha: 0.4)
            : p.accent.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(VhRadius.field - 1),
        child: InkWell(
          onTap: () => session.setSpeed(vhNextSpeed(speed)),
          borderRadius: BorderRadius.circular(VhRadius.field - 1),
          child: SizedBox(
            height: 36,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: VhSpace.sm),
              child: Center(
                child: Text(
                  '${vhFormatSpeed(speed)}×',
                  style: Theme.of(context).textTheme.labelMedium!
                      .copyWith(
                        color: normal ? VhPalette.serverCardInk : p.onAccent,
                        fontWeight: FontWeight.w700,
                      )
                      .tabular,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
