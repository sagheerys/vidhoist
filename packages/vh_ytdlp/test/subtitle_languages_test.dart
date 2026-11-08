import 'package:vh_ytdlp/vh_ytdlp.dart';
import 'package:test/test.dart';

/// yt-dlp matches each `--sub-langs` pattern against the whole code.
bool asked(List<String> patterns, String code) =>
    patterns.any((p) => RegExp('^(?:$p)\$').hasMatch(code));

void main() {
  test('**the guard**: a language, its original and its regions, never the '
      'machine translations into it', () {
    // Measured 2026-11-07: `ar.*` also asked for tracks such as `ar-fr-FR`
    // (Arabic translated from French); YouTube refused one with 429 and the
    // file lost that subtitle. Regions are upper case, sources lower case.
    final ar = SubtitleLanguages.patternsFor('ar');
    for (final code in ['ar', 'ar-orig', 'ar-SA', 'ar-EG']) {
      expect(asked(ar, code), isTrue, reason: code);
    }
    for (final code in ['ar-fr-FR', 'ar-en', 'arz', 'en']) {
      expect(asked(ar, code), isFalse, reason: code);
    }
    final en = SubtitleLanguages.patternsFor('en');
    for (final code in ['en', 'en-orig', 'en-US', 'en-GB']) {
      expect(asked(en, code), isTrue, reason: code);
    }
    expect(asked(en, 'en-de-DE'), isFalse);
  });

  test('several languages in order, each once', () {
    expect(SubtitleLanguages.patterns(['ar', 'en', 'ar']), [
      ...SubtitleLanguages.patternsFor('ar'),
      ...SubtitleLanguages.patternsFor('en'),
    ]);
  });
}
