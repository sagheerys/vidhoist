import 'package:flutter/material.dart';

import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';

/// The one number a screen is about: a version, a percent. Drawn in the
/// display face with fixed-width digits, so a counting percent does not
/// shift sideways, and always left to right, as a number reads in Arabic
/// too.
///
/// **Its growth with the system text size stops at 1.3x**: at 56 it is
/// already the largest thing on the screen, and doubling it pushed the
/// button under it off a short phone.
class VhFigure extends StatelessWidget {
  const VhFigure(
    this.value, {
    super.key,
    this.unit,
    this.size = VhEmphasis.figure,
    this.semanticsLabel,
  });

  final String value;

  /// What follows the number, smaller and quieter: "%".
  final String? unit;
  final double size;

  /// What a screen reader says in place of the bare number.
  final String? semanticsLabel;

  static const _maxScale = 1.3;
  static const _unitShare = 0.42;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final style = Theme.of(context).textTheme.headlineLarge!.tabular
        .copyWith(fontSize: size, height: 1.15);
    return Text.rich(
      TextSpan(
        text: value,
        style: style,
        children: [
          if (unit != null)
            TextSpan(
              text: unit,
              style: style.copyWith(fontSize: size * _unitShare, color: p.ink2),
            ),
        ],
      ),
      textDirection: TextDirection.ltr,
      semanticsLabel: semanticsLabel,
      textScaler: MediaQuery.textScalerOf(context)
          .clamp(maxScaleFactor: _maxScale),
    );
  }
}
