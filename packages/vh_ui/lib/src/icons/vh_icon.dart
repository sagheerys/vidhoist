import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart' show Theme;
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/vh_theme.dart';
import '../widgets/vh_desktop_app.dart';
import 'vh_icon_data.dart';

/// Draws a VidHoist icon the way `Icon` draws a glyph: colour and size from the
/// surrounding [IconTheme], so it drops into a button unchanged. The ember
/// mark always takes the palette's accent, which is what keeps the icon in
/// step with day, night and the app's own colour.
class VhIcon extends StatelessWidget {
  const VhIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
    this.matchTextDirection = false,
    this.shadows,
  });

  final VhIconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  /// Mirrored when the text runs right to left: for the arrows that point
  /// along the reading direction (back, forward, a row's chevron), as
  /// `Icon` mirrors them.
  final bool matchTextDirection;

  /// **On a phone these turn in Arabic by themselves**, as the Material
  /// glyphs they replaced did: the arrow out of a box, lines of text, the
  /// question mark. Without it the phone's Arabic screens pointed the
  /// English way where they never had. The Windows app mirrors at its call
  /// sites instead, so it is left as it is.
  ///
  /// The queue and adding to it are left out: a musical note does not read
  /// along a line, and turned, its stem stood on the wrong side of the head,
  /// a note drawn backwards. Both keep one shape in every language.
  static const _readsAlong = {'external', 'transcript', 'help'};

  /// Drawn beneath the icon, blurred, as `Icon` draws its glyph's shadows:
  /// what keeps an icon legible over a cover of unknown colour.
  final List<Shadow>? shadows;

  static String _hex(Color c) {
    final argb = c.toARGB32();
    final rgb = (argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
    final alpha = (argb >> 24) & 0xFF;
    return alpha == 0xFF
        ? '#$rgb'
        : '#$rgb${alpha.toRadixString(16).padLeft(2, '0')}';
  }

  /// The ink from [color] or the icon theme, with a theme's opacity (a
  /// disabled button's) on top, as `Icon` dims.
  Color _inkIn(BuildContext context) {
    final theme = IconTheme.of(context);
    final ink = color ?? theme.color ?? const Color(0xFF000000);
    final opacity = theme.opacity ?? 1;
    return opacity < 1 ? ink.withValues(alpha: ink.a * opacity) : ink;
  }

  /// The SVG as it is drawn here: the ink **opaque**, and the ember from
  /// the palette. A translucent ink is laid on the whole glyph instead, by
  /// [build]: each stroke painted in it alone laid it twice where two
  /// strokes meet, and a bug's legs showed as bright knots on its body.
  @visibleForTesting
  String svgIn(BuildContext context) {
    final ink = _inkIn(context).withValues(alpha: 1);
    // Outside the app's theme (a bare widget in a test) the ember takes the
    // ink, as Material's glyph draws without a theme.
    final ember =
        Theme.of(context).extension<VhThemeX>()?.palette.accent ?? ink;
    return icon.paint(ink: _hex(ink), ember: _hex(ember));
  }

  @override
  Widget build(BuildContext context) {
    final side = size ?? IconTheme.of(context).size ?? 24;
    Widget glyph = SvgPicture.string(svgIn(context), width: side, height: side);
    final fade = _inkIn(context).a;
    if (fade < 1) glyph = Opacity(opacity: fade, child: glyph);
    if (shadows case final shadows? when shadows.isNotEmpty) {
      glyph = Stack(
        clipBehavior: Clip.none,
        children: [
          for (final s in shadows)
            Transform.translate(
              offset: s.offset,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: s.blurSigma,
                  sigmaY: s.blurSigma,
                ),
                child: SvgPicture.string(
                  icon.paint(ink: _hex(s.color), ember: _hex(s.color)),
                  width: side,
                  height: side,
                ),
              ),
            ),
          glyph,
        ],
      );
    }
    // A filled twin turns as its outline does: the queue's tab swaps one for
    // the other when chosen, and only one of them turning flipped the note
    // across the tab at the tap.
    final outline = icon.name.endsWith('_fill')
        ? icon.name.substring(0, icon.name.length - '_fill'.length)
        : icon.name;
    final turns =
        matchTextDirection ||
        (_readsAlong.contains(outline) && !VhDesktopApp.isDesktop(context));
    if (turns && Directionality.maybeOf(context) == TextDirection.rtl) {
      glyph = Transform.flip(flipX: true, child: glyph);
    }
    // **A box of its own size with the glyph centred in it**, as `Icon`
    // lays out: a parent that forces a larger box (an input field's prefix,
    // a stack that fills its cover) widens the box, never the glyph. Without
    // it the search lens in a field grew to twice its size.
    return Semantics(
      label: semanticLabel,
      excludeSemantics: semanticLabel == null,
      child: SizedBox(
        width: side,
        height: side,
        child: Center(child: glyph),
      ),
    );
  }
}
