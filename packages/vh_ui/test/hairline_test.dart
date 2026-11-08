import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

void main() {
  test("**the guard**: the phones' theme keeps its one-pixel rules and "
      'borders; only the desktop with high contrast thickens them', () {
    for (final variant in VhVariant.values) {
      for (final brightness in Brightness.values) {
        final phone = vhTheme(variant, brightness);
        expect(phone.extension<VhThemeX>()!.hairline, 1);
        expect(phone.dividerTheme.thickness, 1);
        final desk = vhDesktopTheme(variant, brightness);
        expect(desk.extension<VhThemeX>()!.hairline, 1);
        final contrast = vhDesktopTheme(
          variant,
          brightness,
          highContrast: true,
        );
        expect(contrast.extension<VhThemeX>()!.hairline, 2);
        expect(contrast.dividerTheme.thickness, 2);
      }
    }
  });
}
