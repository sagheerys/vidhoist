import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../shell/key_cap.dart';

/// The palette's foot: the keys that move, open and close it, **drawn as
/// keys beside plain words**, not a line of arrows and dots.
class PaletteKeys extends StatelessWidget {
  const PaletteKeys({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return Wrap(
      spacing: VhSpace.xs,
      runSpacing: VhSpace.xxs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final (key, what) in [
          ('↑ ↓', l.desktopPaletteMove),
          ('Enter', l.desktopPaletteOpen),
          ('Esc', l.desktopPaletteClose),
        ]) ...[
          KeyCap(label: key),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: VhSpace.sm),
            child: Text(what, style: text.labelSmall?.copyWith(color: p.ink3)),
          ),
        ],
      ],
    );
  }
}
