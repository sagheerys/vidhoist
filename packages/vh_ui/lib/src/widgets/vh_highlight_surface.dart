import 'package:flutter/material.dart';

import '../theme/vh_theme.dart';
import '../theme/vh_theme_controls.dart';
import 'vh_desktop_app.dart';

/// The card ground: selection is a steady colour, while a highlight is a
/// colour that **fades out by itself**.
///
/// `TweenAnimationBuilder` is enough with no state: it runs from 1 to 0
/// once on the first build, so the highlight extinguishes itself even if
/// the caller forgets to clear it. The list card and the grid card share
/// it so the meaning of the colour cannot drift between the two.
///
/// On the phones a selection is the ink's veil, as every chosen thing in
/// their chrome is; the accent's tint is kept for the highlight, which
/// marks an arrival. The Windows app keeps its own tint.
class VhHighlightSurface extends StatelessWidget {
  const VhHighlightSurface({
    super.key,
    required this.selected,
    required this.highlighted,
    required this.child,
    this.borderRadius,
  });

  static const glowFade = Duration(milliseconds: 2400);

  final bool selected;
  final bool highlighted;
  final Widget child;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final chosen = VhDesktopApp.isDesktop(context)
        ? p.accentSoft
        : vhSelectedFill(p);
    final base = selected ? chosen : Colors.transparent;
    final shape = borderRadius == null
        ? null
        : RoundedRectangleBorder(borderRadius: borderRadius!);
    if (!highlighted) {
      return Material(color: base, shape: shape, child: child);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: 0),
      duration: glowFade,
      curve: Curves.easeOutCubic,
      builder: (context, t, inner) => Material(
        color: Color.lerp(base, p.accentSoft, t),
        shape: shape,
        child: inner,
      ),
      child: child,
    );
  }
}
