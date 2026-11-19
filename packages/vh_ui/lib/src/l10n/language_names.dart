/// **Every language named in itself**, never translated.
///
/// The language picker shows each language the way its own speakers
/// write it, so someone who cannot read the current interface
/// language can still find theirs. That is why these names **stay out of
/// the arb files**: translating them into every other language costs
/// translators effort and helps nobody.
///
/// **Adding a language later is two lines**: an `app_xx.arb` file and one
/// line here. Forget the line and the language code shows instead of the
/// name. Nothing crashes, and `arb_parity_test` catches it.
const Map<String, String> vhLanguageNames = {
  'ar': 'العربية',
  'de': 'Deutsch',
  'en': 'English',
  'es': 'Español',
  'fa': 'فارسی',
  'fr': 'Français',
  'hi': 'हिन्दी',
  'id': 'Bahasa Indonesia',
  'pt': 'Português (Brasil)',
  'ru': 'Русский',
  'tr': 'Türkçe',
  'ur': 'اردو',
};

/// The language name, or its code in capitals if it is not one the app
/// is translated into: a transcript can be in any language a clip is
/// spoken in.
String vhLanguageName(String code) =>
    vhLanguageNames[code] ?? code.toUpperCase();
