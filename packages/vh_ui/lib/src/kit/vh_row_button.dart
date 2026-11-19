import 'package:flutter/material.dart';

import '../icons/vh_icon.dart';
import '../icons/vh_icon_data.dart';
import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import '../widgets/vh_desktop_app.dart';

/// An action at the end of a settings row: a small outlined button in the
/// ink. Bold text alone read as the row's value rather than something to
/// press, so a row that does something (backs up, checks, chooses a file)
/// carries a button's shape, while a row that only leads to another page
/// keeps [VhLinkButton].
///
/// The ink, not the accent, as [VhLinkButton] explains: a settings page
/// holds many of these. One that deletes says so in the error colour.
class VhRowButton extends StatelessWidget {
  const VhRowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.danger = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final VhIconData? icon;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final corners = VhDesktopApp.isDesktop(context)
        ? VhCorners.desktop
        : VhCorners.mobile;
    final ink = danger ? p.err : p.ink;
    final enabled = onPressed != null;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: ink,
        disabledForegroundColor: p.ink3,
        side: BorderSide(
          color: !enabled
              ? p.line
              : danger
              ? p.err.withValues(alpha: 0.45)
              : p.line2,
        ),
        textStyle: Theme.of(context).textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: VhSpace.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(corners.field),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon case final glyph?) ...[
            VhIcon(glyph, size: 16, color: enabled ? ink : p.ink3),
            const SizedBox(width: VhSpace.xs),
          ],
          // Ellipsized when the row is narrower than the label (a large
          // text size in a narrow pane), never spilled.
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
