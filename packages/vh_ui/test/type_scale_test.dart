import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

void main() {
  test('**the guard**: the phones keep the sizes they always had', () {
    // Literal numbers on purpose: if the mobile scale is edited, this
    // fails, and every phone screen would have changed with it.
    for (final variant in VhVariant.values) {
      final text = vhTheme(variant, Brightness.light).textTheme;
      expect(text.headlineLarge!.fontSize, 24);
      expect(text.bodyLarge!.fontSize, 15);
      expect(text.bodySmall!.fontSize, 11.5);
    }
  });

  test('the Windows app reads a step smaller, captions a step larger', () {
    final text = vhTheme(
      VhVariant.desktop,
      Brightness.dark,
      type: VhTypeScale.desktop,
    ).textTheme;
    expect(text.headlineLarge!.fontSize, 24);
    expect(text.bodyLarge!.fontSize, 14);
    expect(text.bodySmall!.fontSize, 12.5);
  });
}
