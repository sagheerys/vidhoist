import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

/// A button the app adds to a player for the item now playing: a feature
/// this package does not know, such as a transcript.
class VhExtraAction {
  const VhExtraAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final VhIconData icon;

  /// Read aloud and shown on a long press; the button itself is the icon
  /// alone.
  final String label;
  final VoidCallback onTap;
}

/// [VhExtraAction] as a filled round button in the action colour: the one
/// thing on the row that is not a setting, so it stands out from them.
class VhExtraButton extends StatelessWidget {
  const VhExtraButton({super.key, required this.extra, this.size = 40});

  final VhExtraAction extra;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return Tooltip(
      message: extra.label,
      child: Material(
        color: p.accent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: extra.onTap,
          customBorder: const CircleBorder(),
          child: SizedBox.square(
            dimension: size,
            child: VhIcon(
              extra.icon,
              size: size * 0.55,
              color: p.onAccent,
              semanticLabel: extra.label,
            ),
          ),
        ),
      ),
    );
  }
}
