import 'package:vh_ytdlp/vh_ytdlp.dart';

import '../backend/download_backend.dart';
import '../storage/key_value_store.dart';

/// **The download choices both apps offer**, saved under the same keys on
/// both: a backup carries every pref, so a choice made on the phone
/// arrives on the computer as the same choice, and back.
class DownloadChoices {
  const DownloadChoices({
    this.audioFormat = AudioFormat.m4a,
    this.rateLimit,
    this.fastStreams = false,
    this.subtitleLangs,
    this.embedSubtitles = false,
  });

  static const audioFormatKey = 'audio_format';
  static const rateLimitKey = 'download_rate_limit';
  static const fastStreamsKey = 'download_fast_streams';
  static const subtitleLangsKey = 'download_subtitle_languages';
  static const embedSubtitlesKey = 'download_embed_subtitles';

  /// The limits offered, as yt-dlp's `-r` takes them; a few steps are
  /// easier to choose from than a number to type.
  static const rateLimits = ['1M', '2M', '5M', '10M'];

  /// Pieces fetched at once with fast streams on: enough to fill a home
  /// line on a site that serves small pieces, few enough not to look like
  /// a flood.
  static const fastPieces = 4;

  /// What "audio only" is saved as.
  final AudioFormat audioFormat;

  /// One of [rateLimits]; null for none.
  final String? rateLimit;

  /// yt-dlp's `-N` at [fastPieces], for streams served in pieces.
  final bool fastStreams;

  /// The subtitle languages chosen, codes from [subtitleLanguageNames];
  /// null until one is chosen, and each app has its own default.
  final List<String>? subtitleLangs;

  /// The subtitles also inside the file, for other players.
  final bool embedSubtitles;

  /// What the engine is told; [subtitles] is whether subtitles are
  /// fetched at all, since there is nothing to embed without them.
  DownloadTuning tuning({required bool subtitles}) => DownloadTuning(
    audioFormat: audioFormat,
    rateLimit: rateLimit,
    concurrentFragments: fastStreams ? fastPieces : null,
    embedSubtitles: subtitles && embedSubtitles,
  );

  DownloadChoices copyWith({
    AudioFormat? audioFormat,
    String? rateLimit,
    bool clearRateLimit = false,
    bool? fastStreams,
    List<String>? subtitleLangs,
    bool? embedSubtitles,
  }) => DownloadChoices(
    audioFormat: audioFormat ?? this.audioFormat,
    rateLimit: clearRateLimit ? null : (rateLimit ?? this.rateLimit),
    fastStreams: fastStreams ?? this.fastStreams,
    subtitleLangs: subtitleLangs ?? this.subtitleLangs,
    embedSubtitles: embedSubtitles ?? this.embedSubtitles,
  );

  static Future<DownloadChoices> load(KeyValueStore store) async =>
      DownloadChoices(
        audioFormat: parseAudioFormat(await store.getString(audioFormatKey)),
        rateLimit: parseRateLimit(await store.getString(rateLimitKey)),
        fastStreams: await store.getBool(fastStreamsKey) ?? false,
        subtitleLangs: parseSubtitleLangs(
          await store.getStringList(subtitleLangsKey),
        ),
        embedSubtitles: await store.getBool(embedSubtitlesKey) ?? false,
      );

  /// A stored name this build does not know reads as M4A, never as an
  /// error at launch.
  static AudioFormat parseAudioFormat(String? wire) {
    for (final format in AudioFormat.values) {
      if (format.wire == wire) return format;
    }
    return AudioFormat.m4a;
  }

  /// A limit no longer offered reads as none.
  static String? parseRateLimit(String? stored) =>
      rateLimits.contains(stored) ? stored : null;

  /// Codes this build does not offer are dropped; none left reads as not
  /// chosen, so a stored list can never fetch nothing.
  static List<String>? parseSubtitleLangs(List<String>? stored) {
    final known = [
      for (final code in {...?stored})
        if (subtitleLanguageNames.containsKey(code)) code,
    ];
    return known.isEmpty ? null : known;
  }

  /// [chosen] with [code] added or taken out; the last one stays, since
  /// none would be the subtitles switch turned off, said in a stranger
  /// way.
  static List<String> toggled(List<String> chosen, String code) {
    if (!chosen.contains(code)) return [...chosen, code];
    if (chosen.length == 1) return chosen;
    return [...chosen]..remove(code);
  }
}

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
