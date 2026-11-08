import 'package:flutter/material.dart';

import '../l10n/bidi.dart';

/// Text the app did not write, a title above all, in its own direction:
/// an English title under the Arabic interface otherwise shows its closing
/// "!" at the front and its ellipsis at the wrong end. See [vhForeignLine].
class VhForeignText extends StatelessWidget {
  const VhForeignText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.center = false,
  });

  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  /// Centred rather than aligned with the interface.
  final bool center;

  @override
  Widget build(BuildContext context) {
    final (direction, align) = vhForeignLine(context, text);
    return Text(
      text,
      textDirection: direction,
      textAlign: center ? TextAlign.center : align,
      maxLines: maxLines,
      overflow: overflow,
      style: style,
    );
  }
}
