import 'package:flutter/material.dart';

import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import 'vh_motion.dart';
import 'vh_polish.dart';

import '../icons/vh_icon_data.dart';
import '../icons/vh_icons.dart';

/// The room a scrolling list keeps under its last row on a screen with a
/// floating button, so that row can be scrolled clear of the button and
/// still be tapped.
///
/// The button stands its margin above the system's navigation inset and is
/// at most Material's 56 high, so the list ends a margin above its top.
double vhFabClearance(BuildContext context) =>
    _fabHeight +
    2 * kFloatingActionButtonMargin +
    MediaQuery.paddingOf(context).bottom;

const double _fabHeight = 56;

/// The approved "add link" button: a rounded rectangular FAB in the accent
/// colour with a translucent icon box. Its label and icon change when a
/// link is waiting in the clipboard.
class VhFab extends StatelessWidget {
  const VhFab({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = VhIcons.plus,
    this.highlighted = false,
  });

  final String label;
  final VoidCallback onPressed;
  final VhIconData icon;

  /// The "link ready to paste" state: a paste icon and a colour pulse.
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final duration = vhMotionDuration(context, VhMotion.tap);
    final labelStyle = TextStyle(
      fontFamily: VhType.body,
      package: VhType.package,
      fontSize: 13.5,
      fontWeight: FontWeight.w700,
      color: p.onAccent,
    );
    // **The swap between "add link" and "link ready" is animated** (polish
    // 2026-09-04): the colour dissolves, the icons trade places and the
    // width stretches with the label. All three used to jump at once the
    // moment something was copied.
    // **A bound on the width, because nothing else gives it one.** The
    // Scaffold's floating slot lets this button grow as wide as its label
    // wants, so a long label at a large text scale walks off the right of
    // a narrow screen: "Follow a channel" at ×1.3 on 320dp overflowed by
    // 35 pixels (device matrix, 2026-09-20). Today's shipped labels are
    // short enough, but more languages are planned whose words are not.
    final media = MediaQuery.of(context);
    final maxWidth = media.size.width - VhSpace.pagePad * 2;

    return VhPressable(
      child: AnimatedContainer(
        duration: duration,
        curve: VhMotion.entrance,
        decoration: BoxDecoration(
          color: highlighted ? p.accentDeep : p.accent,
          borderRadius: BorderRadius.circular(VhRadius.fab),
          boxShadow: VhShadow.float,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(VhRadius.fab),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(VhRadius.fab),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                VhSpace.md + 1,
                VhSpace.md + 1,
                VhSpace.xl,
                VhSpace.md + 1,
              ),
              child: AnimatedSize(
                duration: duration,
                curve: VhMotion.entrance,
                alignment: AlignmentDirectional.centerStart,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // The glyph alone: a tinted square inside the button
                      // was a box within a box.
                      VhIconSwap(
                        icon: highlighted ? VhIcons.paste : icon,
                        size: 20,
                        color: p.onAccent,
                      ),
                      const SizedBox(width: VhSpace.sm),
                      // **Flexible, so the label yields before the row
                      // does.** The icon keeps its size; only the words
                      // are shortened, and only on the screens where they
                      // would not have fitted at all.
                      Flexible(
                        child: VhAnimatedSwap(
                          child: Text(
                            label,
                            key: ValueKey(label),
                            style: labelStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
