import 'package:flutter/material.dart';

import '../theme/vh_theme_controls.dart';
import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import '../widgets/vh_desktop_app.dart';
import '../widgets/vh_polish.dart';

/// A card that answers the mouse: **a plate a shade darker than the page
/// appears behind it**, reaching a little past its edges, and [builder]
/// learns it is hovered (to show a play mark, say). It does not rise and
/// does not glow: a lift with a warm shadow under every card is one of the
/// marks of a generated screen, and the file explorer's plate says the
/// same thing quietly.
///
/// **Windows only.** Outside [VhDesktopApp] it builds the child as it was,
/// never hovered, so a phone or a tablet with a mouse looks the same as
/// before.
class VhHoverLift extends StatefulWidget {
  const VhHoverLift({
    super.key,
    required this.borderRadius,
    required this.builder,
  });

  final BorderRadius borderRadius;

  /// How far the plate reaches past the card on every side.
  static const double reach = VhSpace.xs;
  final Widget Function(BuildContext context, bool hovered) builder;

  @override
  State<VhHoverLift> createState() => _VhHoverLiftState();
}

class _VhHoverLiftState extends State<VhHoverLift> {
  bool _hovered = false;

  void _hover(bool on) {
    if (on != _hovered) setState(() => _hovered = on);
  }

  @override
  Widget build(BuildContext context) {
    if (!VhDesktopApp.isDesktop(context)) {
      return widget.builder(context, false);
    }
    final p = VhThemeX.of(context).palette;
    return MouseRegion(
      onEnter: (_) => _hover(true),
      onExit: (_) => _hover(false),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            left: -VhHoverLift.reach,
            top: -VhHoverLift.reach,
            right: -VhHoverLift.reach,
            bottom: -VhHoverLift.reach,
            child: AnimatedContainer(
              key: const ValueKey('hover-plate'),
              duration: vhMotionDuration(context, VhMotion.fast),
              curve: VhMotion.ease,
              decoration: BoxDecoration(
                color: _hovered
                    ? p.ink.withValues(alpha: vhHoverVeil)
                    : p.ink.withValues(alpha: 0),
                borderRadius: widget.borderRadius,
              ),
            ),
          ),
          widget.builder(context, _hovered),
        ],
      ),
    );
  }
}
