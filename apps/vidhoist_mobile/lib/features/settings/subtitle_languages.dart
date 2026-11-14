/// **The languages subtitles can be fetched in, each named in itself**,
/// like the app's own language list and for the same reason: someone
/// looks for their language as they write it, whatever the interface
/// language. Kept apart from the app's languages: a subtitle can be in a
/// language the app is not translated into.
///
/// The most spoken languages with subtitles on the big sites; a code here
/// is what yt-dlp's `--sub-langs` matches (`SubtitleLanguages`).
const Map<String, String> subtitleLanguageNames = {
  'ar': 'العربية',
  'en': 'English',
  'fr': 'Français',
  'es': 'Español',
  'de': 'Deutsch',
  'tr': 'Türkçe',
  'fa': 'فارسی',
  'ur': 'اردو',
  'hi': 'हिन्दी',
  'id': 'Bahasa Indonesia',
  'ru': 'Русский',
  'pt': 'Português',
  'it': 'Italiano',
  'ja': '日本語',
  'ko': '한국어',
  'zh': '中文',
};
