import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/features/shared/error_text.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

/// **A login-walled clip gets the plain sentence, on purpose** (2026-09-20).
///
/// The phone app has no cookies screen. Telling the person to upload a
/// cookies file would send them looking for a button that does not exist,
/// and this test is what keeps that choice deliberate rather than
/// forgotten.
void main() {
  for (final locale in [const Locale('en'), const Locale('ar')]) {
    test('in ${locale.languageCode} it says a login is required', () {
      final l10n = lookupVhLocalizations(locale);
      final text = errorText(l10n, const PlatformBlockedException('...'));

      expect(text, l10n.errPlatformBlocked);
    });
  }
}
