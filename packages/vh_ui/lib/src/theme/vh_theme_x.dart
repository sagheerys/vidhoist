import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Theme extension: carries the app's palette to every widget through
/// `VhThemeX.of(context)` instead of any literal colour.
class VhThemeX extends ThemeExtension<VhThemeX> {
  const VhThemeX({
    required this.palette,
    required this.variant,
    this.hairline = 1,
  });

  final VhPalette palette;
  final VhVariant variant;

  /// How thick a hairline (a border, a rule) is drawn: one pixel, or more
  /// where the user asked the system for high contrast.
  final double hairline;

  static VhThemeX of(BuildContext context) =>
      Theme.of(context).extension<VhThemeX>()!;

  @override
  VhThemeX copyWith({
    VhPalette? palette,
    VhVariant? variant,
    double? hairline,
  }) => VhThemeX(
    palette: palette ?? this.palette,
    variant: variant ?? this.variant,
    hairline: hairline ?? this.hairline,
  );

  @override
  VhThemeX lerp(VhThemeX? other, double t) => t < 0.5 ? this : other ?? this;
}
