import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart'
    show VhCaptionBackground, VhPictureInPicture;

import '../../di.dart';

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
  });

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

  /// What `--sub-langs` asks for: the app's two languages, without their
  /// machine translations (`SubtitleLanguages`).
  List<String> get subtitleLanguages =>
      subtitles ? SubtitleLanguages.patterns(const ['ar', 'en']) : const [];

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

    /// Distinguishes "clear the language" from "do not change it": `null`
    /// alone is not enough.
    bool clearLocale = false,
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
    );
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

  Future<void> setCaptionSize(int size) async {
    await _mutex.run(() => _store.setInt('caption_size', size));
    state = state.copyWith(captionSize: size);
  }

  Future<void> setCaptionBackground(int background) async {
    await _mutex.run(() => _store.setInt('caption_background', background));
    state = state.copyWith(captionBackground: background);
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
