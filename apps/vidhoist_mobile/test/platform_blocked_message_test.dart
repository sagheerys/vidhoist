import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/features/shared/error_text.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

/// **A login-walled clip names the page that signs in** (2026-11-09).
///
/// Until Settings › Accounts existed the sentence was deliberately plain:
/// telling the person to upload a cookies file sent them looking for a
/// button that did not exist. Now the button exists, and the sentence
/// must point at it, not at a file.
void main() {
  for (final locale in [const Locale('en'), const Locale('ar')]) {
    test('in ${locale.languageCode} it points at Settings › Accounts', () {
      final l10n = lookupVhLocalizations(locale);
      final text = errorText(l10n, const PlatformBlockedException('...'));

      expect(text, l10n.mobileSignInNeeded);
      expect(text, contains(l10n.settingsAccounts));
      expect(text, isNot(contains('cookies')));
    });
  }
}
