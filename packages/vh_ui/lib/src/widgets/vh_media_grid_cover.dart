import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;

import '../icons/vh_icon.dart';
import '../icons/vh_icon_data.dart';
import '../icons/vh_icons.dart';
import '../l10n/l10n.dart';
import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import '../kit/vh_shortcut_tooltip.dart';
import 'vh_desktop_app.dart';
import 'vh_equalizer.dart';
import 'vh_polish.dart';
import 'vh_thumb_pill.dart';

/// A 16:9 thumbnail carrying duration, favourite and more. Every card
/// action lives on the cover because a grid cell has no width for a column
/// of buttons beside it.
class VhMediaGridCover extends StatelessWidget {
  const VhMediaGridCover({
    super.key,
    required this.duration,
    required this.playing,
    required this.paused,
    required this.favorite,
    required this.audio,
    required this.onFavoriteToggle,
    required this.onMore,
    this.hovered = false,
    this.child,
  });

  final String? duration;
  final bool playing;
  final bool paused;
  final bool favorite;
  final bool audio;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onMore;

  /// The mouse is over the card (Windows only): a play mark fades in.
  final bool hovered;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l10n = context.vhl;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: p.cardAlt,
          borderRadius: BorderRadius.circular(VhRadius.thumb),
          border: Border.all(
            color: p.line,
            width: VhThemeX.of(context).hairline,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // The picture and its marks: the card's name already says them.
            ExcludeSemantics(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  child ??
                      vhCoverPlaceholder(
                        context,
                        size: 22,
                        color: p.ink3,
                        audio: audio,
                      ),
                  if (playing)
                    Align(
                      alignment: Alignment.center,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: p.ink.withValues(alpha: 0.55),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(VhSpace.xs),
                          child: VhEqualizer(animate: !paused),
                        ),
                      ),
                    ),
                  // Under the mouse, a play mark says what a click does: Windows
                  // only, and not over the playing clip, which already shows its
                  // equalizer there.
                  if (!playing && VhDesktopApp.isDesktop(context))
                    Align(
                      child: AnimatedOpacity(
                        opacity: hovered ? 1 : 0,
                        duration: vhMotionDuration(context, VhMotion.fast),
                        // Dark in day and night alike, like the cover buttons:
                        // the theme's ink turns pale at night, under a white mark.
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: VhPalette.fullscreenScrim.withValues(
                              alpha: 0.6,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(VhSpace.xs),
                            child: VhIcon(VhIcons.play, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  if (duration != null)
                    PositionedDirectional(
                      bottom: 5,
                      start: 5,
                      child: VhThumbPill.duration(duration!),
                    ),
                  // Without a cover the placeholder is already a music note, so
                  // a second one would only repeat it.
                  if (audio && child != null)
                    PositionedDirectional(
                      bottom: 5,
                      end: 5,
                      child: VhThumbPill.audio(),
                    ),
                ],
              ),
            ),
            PositionedDirectional(
              top: 0,
              end: 0,
              child: Row(
                children: [
                  // **On a computer the heart waits for the pointer** unless
                  // the clip is a favourite: a heart on every cover at rest
                  // was one of the marks of a generated grid. It stays one
                  // key (F) and one menu row away for the others.
                  if (onFavoriteToggle != null &&
                      (favorite || hovered || !VhDesktopApp.isDesktop(context)))
                    _CoverButton(
                      icon: favorite ? VhIcons.favoriteOn : VhIcons.favorite,
                      tooltip: favorite
                          ? l10n.removeFromFavorites
                          : l10n.addToFavorites,
                      // **A fixed white, not `p.bg`**: the
                      // chip always sits over a dark cover, so the theme
                      // background colour made it dark on dark at night,
                      // all but invisible.
                      color: favorite ? p.favorite : Colors.white,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onFavoriteToggle!();
                      },
                    ),
                  if (onMore != null)
                    _CoverButton(
                      icon: VhIcons.moreVert,
                      tooltip: l10n.itemOptions,
                      color: Colors.white,
                      onTap: onMore!,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverButton extends StatelessWidget {
  const _CoverButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  final VhIconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // On the computer, the app's own tooltip: Material's breaks Windows'
    // accessibility tree when two meet in one node (see
    // VhShortcutTooltip). It says nothing to a reader, so the button is
    // named here instead.
    if (VhDesktopApp.isDesktop(context)) {
      return VhShortcutTooltip(
        message: tooltip,
        child: Semantics(label: tooltip, child: _button()),
      );
    }
    return Tooltip(message: tooltip, child: _button());
  }

  // A bare ink well is only tappable: the reader is told it is a button.
  Widget _button() => Semantics(
    button: true,
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(VhSpace.xs),
        // The favourite heart fades and expands rather than jumping (polish
        // 2026-09-04).
        child: VhIconSwap(
          icon: icon,
          size: 17,
          color: color,
          // Icons over a thumbnail of unknown colour: a light shadow keeps
          // them legible over both pale and dark covers.
          shadows: const [Shadow(color: Color(0x99000000), blurRadius: 5)],
        ),
      ),
    ),
  );
}
