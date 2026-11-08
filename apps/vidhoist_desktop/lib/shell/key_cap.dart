import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

/// A key as the keyboard prints it ("Ctrl K", "Space"), in a hairline
/// frame. Always left to right: keys read the same in either language.
class KeyCap extends StatelessWidget {
  const KeyCap({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: p.line2,
            width: VhThemeX.of(context).hairline,
          ),
          borderRadius: BorderRadius.circular(VhCorners.desktop.box),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: VhSpace.xs,
            vertical: VhSpace.xxs / 2,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: p.ink3),
          ),
        ),
      ),
    );
  }
}
