import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart'
    show VhCaptionBackground, VhPictureInPicture;

import '../../di.dart';
import 'subtitle_languages.dart';

/// The phone's settings. Storage key names are fixed: a renamed key would
/// leave saved settings and backups behind.
class PhoneSettings {
  const PhoneSettings({
    this.quality = Quality.best,
    this.quickDownload = false,
    this.wifiOnly = false,
    this.autoRetry = true,
    this.compatiblePlayback = true,
    this.pictureInPicture = false,
    this.themeMode = ThemeMode.system,
    this.localeCode,
    this.forceIpv4 = true,
    this.subtitles = true,
    this.captionSize = 1,
    this.captionBackground = 0,
    this.welcomed = false,
    this.downloadVolume,
    this.audioFormat = AudioFormat.m4a,
    this.rateLimit,
    this.fastStreams = false,
    this.subtitleLangs = defaultSubtitleLangs,
    this.embedSubtitles = false,
  });

  /// What "audio only" is saved as: M4A plays everywhere, MP3 is what
  /// older players and cars ask for, the original skips the conversion.
  final AudioFormat audioFormat;

  /// The download speed cap as yt-dlp's `-r` takes it, one of
  /// [rateLimits]; null for none. For a shared connection, or a plan that
  /// slows down past a daily amount.
  final String? rateLimit;

  static const rateLimits = ['1M', '2M', '5M', '10M'];

  /// Streams cut into pieces (X, and many sites' HLS or DASH) fetched
  /// [fastPieces] pieces at a time. Off unless turned on: more requests
  /// at once is what some sites throttle.
  final bool fastStreams;

  /// Enough to hide each piece's round trip, few enough for a phone.
  static const fastPieces = 4;

  /// The languages subtitles are fetched in, in the order chosen; never
  /// empty, since turning [subtitles] off is how none are fetched.
  final List<String> subtitleLangs;

  static const defaultSubtitleLangs = ['ar', 'en'];

  /// The subtitles also inside the video, for players that read no file
  /// beside it. Off unless turned on: the app's own player needs none.
  final bool embedSubtitles;

  /// The above, as the engine reads them at each download.
  DownloadTuning get tuning => DownloadTuning(
    audioFormat: audioFormat,
    rateLimit: rateLimit,
    concurrentFragments: fastStreams ? fastPieces : null,
    embedSubtitles: subtitles && embedSubtitles,
  );

  /// The memory card new downloads go to, by its id (`PhoneVolume.id`);
  /// null for the phone's own storage. About this phone, so kept out of
  /// backups: another phone's card has another id.
  final String? downloadVolume;

  static const downloadVolumeKey = 'download_volume';

  /// yt-dlp's `-4`: a broken IPv6 route stalls every download (ENGINE.md,
  /// findings 7 and 20). Off only for a network with IPv6 alone.
  final bool forceIpv4;

  /// Subtitles fetched with the download itself, saved beside the file.
  final bool subtitles;

  /// The subtitles' size over the video: an index into [captionScales],
  /// medium at first.
  final int captionSize;

  /// What sits behind them: an index into [VhCaptionBackground.values],
  /// the dark capsule at first.
  final int captionBackground;

  /// Small, medium, large and larger. The first three are the Windows
  /// app's; the fourth is for reading from across a room.
  static const captionScales = [0.85, 1.0, 1.25, 1.5];

  double get captionScale =>
      captionScales[captionSize.clamp(0, captionScales.length - 1)];

  VhCaptionBackground get captionBackdrop =>
      VhCaptionBackground.values[captionBackground.clamp(
        0,
        VhCaptionBackground.values.length - 1,
      )];

  /// The welcome screen has readied the engine once; a fresh install shows
  /// it first.
  final bool welcomed;

  /// Never renamed: a renamed key shows the welcome screen again.
  static const welcomedKey = 'engine_welcome_done';

  /// What `--sub-langs` asks for: the chosen languages, without their
  /// machine translations (`SubtitleLanguages`).
  List<String> get subtitleLanguages =>
      subtitles ? SubtitleLanguages.patterns(subtitleLangs) : const [];

  final Quality quality;

  /// **Quick download**: a shared or pasted link downloads immediately at
  /// the default quality with no sheet, which makes that an effective
  /// setting rather than an initial value.
  final bool quickDownload;

  /// Downloading on Wi-Fi only, so a phone on mobile data keeps its plan.
  final bool wifiOnly;

  /// Retries what failed because of the network once it returns, never what
  /// the site refused.
  final bool autoRetry;

  /// **Best playback compatibility (H.264/AAC).** Measured on YouTube:
  /// `best` alone yields VP9 or AV1 in webm, and hardware AV1 decoding is
  /// missing from
  /// most phones, so the picture appears torn. On by default; turning it
  /// off allows the highest resolution at the cost of compatibility.
  final bool compatiblePlayback;

  /// Leaving the app while a video plays moves it to a corner of the
  /// screen, and the player has a button for it. Off unless turned on.
  final bool pictureInPicture;
  final ThemeMode themeMode;

  /// null means the system language (detected on first run).
  final String? localeCode;

  PhoneSettings copyWith({
    Quality? quality,
    bool? quickDownload,
    bool? wifiOnly,
    bool? autoRetry,
    bool? compatiblePlayback,
    bool? pictureInPicture,
    ThemeMode? themeMode,
    String? localeCode,
    bool? forceIpv4,
    bool? subtitles,
    int? captionSize,
    int? captionBackground,
    bool? welcomed,
    String? downloadVolume,
    AudioFormat? audioFormat,
    String? rateLimit,
    bool? fastStreams,
    List<String>? subtitleLangs,
    bool? embedSubtitles,

    /// Distinguishes "clear the language" from "do not change it": `null`
    /// alone is not enough. The same for the card.
    bool clearLocale = false,
    bool clearDownloadVolume = false,
    bool clearRateLimit = false,
  }) => PhoneSettings(
    quality: quality ?? this.quality,
    quickDownload: quickDownload ?? this.quickDownload,
    wifiOnly: wifiOnly ?? this.wifiOnly,
    autoRetry: autoRetry ?? this.autoRetry,
    compatiblePlayback: compatiblePlayback ?? this.compatiblePlayback,
    pictureInPicture: pictureInPicture ?? this.pictureInPicture,
    themeMode: themeMode ?? this.themeMode,
    localeCode: clearLocale ? null : (localeCode ?? this.localeCode),
    forceIpv4: forceIpv4 ?? this.forceIpv4,
    subtitles: subtitles ?? this.subtitles,
    captionSize: captionSize ?? this.captionSize,
    captionBackground: captionBackground ?? this.captionBackground,
    welcomed: welcomed ?? this.welcomed,
    downloadVolume: clearDownloadVolume
        ? null
        : (downloadVolume ?? this.downloadVolume),
    audioFormat: audioFormat ?? this.audioFormat,
    rateLimit: clearRateLimit ? null : (rateLimit ?? this.rateLimit),
    fastStreams: fastStreams ?? this.fastStreams,
    subtitleLangs: subtitleLangs ?? this.subtitleLangs,
    embedSubtitles: embedSubtitles ?? this.embedSubtitles,
  );

  /// Loads the initial snapshot before runApp.
  static Future<PhoneSettings> load(KeyValueStore store) async {
    final themeName = await store.getString('theme_mode');
    return PhoneSettings(
      quality: Quality.fromWire(await store.getString('video_quality')),
      quickDownload: await store.getBool('quick_download_enabled') ?? false,
      wifiOnly: await store.getBool('wifi_only_downloads') ?? false,
      autoRetry: await store.getBool('auto_retry_downloads') ?? true,
      compatiblePlayback: await store.getBool('compatible_playback') ?? true,
      pictureInPicture: await store.getBool('picture_in_picture') ?? false,
      themeMode: ThemeMode.values.firstWhere(
        (m) => m.name == themeName,
        orElse: () => ThemeMode.system,
      ),
      localeCode: await store.getString('app_locale'),
      forceIpv4: await store.getBool('engine_force_ipv4') ?? true,
      subtitles: await store.getBool('download_subtitles') ?? true,
      captionSize: await store.getInt('caption_size') ?? 1,
      captionBackground: await store.getInt('caption_background') ?? 0,
      welcomed: await store.getBool(welcomedKey) ?? false,
      downloadVolume: await store.getString(downloadVolumeKey),
      audioFormat: _audioFormat(await store.getString('audio_format')),
      rateLimit: switch (await store.getString('download_rate_limit')) {
        final rate? when rateLimits.contains(rate) => rate,
        _ => null,
      },
      fastStreams: await store.getBool('download_fast_streams') ?? false,
      subtitleLangs: _subtitleLangs(
        await store.getStringList('download_subtitle_languages'),
      ),
      embedSubtitles: await store.getBool('download_embed_subtitles') ?? false,
    );
  }

  /// Codes this build does not offer are dropped; none left reads as the
  /// default, so a stored list can never fetch nothing with the switch on.
  static List<String> _subtitleLangs(List<String>? stored) {
    final known = [
      for (final code in {...?stored})
        if (subtitleLanguageNames.containsKey(code)) code,
    ];
    return known.isEmpty ? defaultSubtitleLangs : known;
  }

  /// A stored name this build does not know reads as the default, never
  /// as an error at launch.
  static AudioFormat _audioFormat(String? wire) {
    for (final format in AudioFormat.values) {
      if (format.wire == wire) return format;
    }
    return AudioFormat.m4a;
  }
}

class SettingsNotifier extends Notifier<PhoneSettings> {
  @override
  PhoneSettings build() {
    final settings = ref.read(initialSettingsProvider);
    VhPictureInPicture.instance.enabled.value = settings.pictureInPicture;
    return settings;
  }

  KeyValueStore get _store => ref.read(keyValueStoreProvider);
  PrefsMutex get _mutex => ref.read(prefsMutexProvider);

  /// Re-reads every setting from storage, after importing a backup (rule
  /// 8).
  Future<void> reloadFromStore() async =>
      state = await PhoneSettings.load(_store);

  Future<void> setQuality(Quality quality) async {
    await _mutex.run(() => _store.setString('video_quality', quality.wire));
    state = state.copyWith(quality: quality);
  }

  Future<void> setQuickDownload(bool enabled) async {
    await _mutex.run(() => _store.setBool('quick_download_enabled', enabled));
    state = state.copyWith(quickDownload: enabled);
  }

  Future<void> setWifiOnly(bool enabled) async {
    await _mutex.run(() => _store.setBool('wifi_only_downloads', enabled));
    state = state.copyWith(wifiOnly: enabled);
  }

  Future<void> setAutoRetry(bool enabled) async {
    await _mutex.run(() => _store.setBool('auto_retry_downloads', enabled));
    state = state.copyWith(autoRetry: enabled);
  }

  Future<void> setCompatiblePlayback(bool enabled) async {
    await _mutex.run(() => _store.setBool('compatible_playback', enabled));
    state = state.copyWith(compatiblePlayback: enabled);
  }

  Future<void> setPictureInPicture(bool enabled) async {
    await _mutex.run(() => _store.setBool('picture_in_picture', enabled));
    VhPictureInPicture.instance.enabled.value = enabled;
    state = state.copyWith(pictureInPicture: enabled);
  }

  Future<void> setForceIpv4(bool enabled) async {
    await _mutex.run(() => _store.setBool('engine_force_ipv4', enabled));
    state = state.copyWith(forceIpv4: enabled);
  }

  Future<void> setWelcomed() async {
    await _mutex.run(() => _store.setBool(PhoneSettings.welcomedKey, true));
    state = state.copyWith(welcomed: true);
  }

  Future<void> setSubtitles(bool enabled) async {
    await _mutex.run(() => _store.setBool('download_subtitles', enabled));
    state = state.copyWith(subtitles: enabled);
  }

  /// Adds or removes [code]; the last language left stays.
  Future<void> toggleSubtitleLang(String code) async {
    final now = [...state.subtitleLangs];
    if (!now.remove(code)) now.add(code);
    if (now.isEmpty) return;
    await _mutex.run(
      () => _store.setStringList('download_subtitle_languages', now),
    );
    state = state.copyWith(subtitleLangs: now);
  }

  Future<void> setEmbedSubtitles(bool enabled) async {
    await _mutex.run(() => _store.setBool('download_embed_subtitles', enabled));
    state = state.copyWith(embedSubtitles: enabled);
  }

  Future<void> setCaptionSize(int size) async {
    await _mutex.run(() => _store.setInt('caption_size', size));
    state = state.copyWith(captionSize: size);
  }

  Future<void> setCaptionBackground(int background) async {
    await _mutex.run(() => _store.setInt('caption_background', background));
    state = state.copyWith(captionBackground: background);
  }

  /// The card new downloads go to; null for the phone's own storage.
  Future<void> setDownloadVolume(String? id) async {
    await _mutex.run(
      () => id == null
          ? _store.remove(PhoneSettings.downloadVolumeKey)
          : _store.setString(PhoneSettings.downloadVolumeKey, id),
    );
    state = state.copyWith(downloadVolume: id, clearDownloadVolume: id == null);
  }

  Future<void> setAudioFormat(AudioFormat format) async {
    await _mutex.run(() => _store.setString('audio_format', format.wire));
    state = state.copyWith(audioFormat: format);
  }

  /// One of [PhoneSettings.rateLimits]; null for no limit.
  Future<void> setRateLimit(String? rate) async {
    await _mutex.run(
      () => rate == null
          ? _store.remove('download_rate_limit')
          : _store.setString('download_rate_limit', rate),
    );
    state = state.copyWith(rateLimit: rate, clearRateLimit: rate == null);
  }

  Future<void> setFastStreams(bool enabled) async {
    await _mutex.run(() => _store.setBool('download_fast_streams', enabled));
    state = state.copyWith(fastStreams: enabled);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _mutex.run(() => _store.setString('theme_mode', mode.name));
    state = state.copyWith(themeMode: mode);
  }

  /// **`null` means "follow the system language"**: the key is erased so
  /// `localeCode` returns empty, as it was on the day of installation.
  /// Without this the option was **a door that closes and never opens**:
  /// the first touch of the switch pinned a language forever, with no way
  /// back short of clearing the app's data, and with it the library and the
  /// favourites.
  Future<void> setLocale(String? code) async {
    await _mutex.run(
      () => code == null
          ? _store.remove('app_locale')
          : _store.setString('app_locale', code),
    );
    state = state.copyWith(localeCode: code, clearLocale: code == null);
  }
}
