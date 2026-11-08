/// The `--sub-langs` patterns for a reader's languages.
///
/// `ar.*` looked right and asked for too much: it also matches the
/// machine translations into Arabic, one per source track (`ar-fr-FR` is
/// Arabic translated from French). Each is one more request, and YouTube
/// refused one with 429 (measured 2026-11-07). A region is upper case
/// (`ar-SA`), a translation's source lower case, so the patterns tell them
/// apart.
abstract final class SubtitleLanguages {
  /// The language itself, its original track (`ar-orig`) and its regions.
  static List<String> patternsFor(String language) => [
    language,
    '$language-orig',
    '$language-[A-Z]+',
  ];

  /// [patternsFor] each of [languages], in order, each once.
  static List<String> patterns(Iterable<String> languages) => [
    for (final language in {...languages}) ...patternsFor(language),
  ];
}
