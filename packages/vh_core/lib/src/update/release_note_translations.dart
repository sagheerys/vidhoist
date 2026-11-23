import 'dart:convert';

import 'release_notes.dart';

/// The file a release carries beside its downloads with its notes in every
/// language of the apps.
///
/// **A file, not the release page.** The page is written for visitors in
/// English and Arabic; an app that shows the page whole, as the update
/// sheet of older versions does, would show twelve languages stacked if
/// they lived there. Older versions ignore the file, since its name ends
/// in neither `.apk` nor `.exe`.
///
/// ```json
/// {"phone": {"en": "- Markdown", "ar": "- …"}, "windows": {"en": "…"}}
/// ```
const String vhNotesAssetName = 'release-notes.json';

/// The ceiling for the notes file: twelve languages of a few lines each
/// are a few kilobytes, so anything far past it is not that file.
const int vhNotesAssetCeiling = 256 * 1024;

/// [app]'s notes by language code, read from the notes file's [body].
///
/// Never throws: a broken file means no translations, and the apps fall
/// back to the release page.
Map<String, String> vhParseNoteTranslations(String body, String app) {
  try {
    final decoded = json.decode(body);
    if (decoded is! Map) return const {};
    final byLanguage = decoded[app];
    if (byLanguage is! Map) return const {};
    return {
      for (final MapEntry(:key, :value) in byLanguage.entries)
        if (key is String && value is String && value.trim().isNotEmpty)
          key.toLowerCase(): value.trim(),
    };
  } on FormatException {
    return const {};
  }
}

/// The notes to show a reader of [language] (a language code, `ar`, `pt`).
///
/// In order: the notes file in that language, the notes file in English,
/// then the release page itself, cut to the half the reader reads
/// ([vhReleaseNotesFor]). A release from before the file existed has only
/// the page.
String vhReleaseNotesIn(
  String language, {
  required String body,
  Map<String, String> translations = const {},
  String? app,
}) {
  final code = language.toLowerCase();
  return translations[code] ??
      translations['en'] ??
      vhReleaseNotesFor(body, arabic: code == 'ar', app: app);
}
