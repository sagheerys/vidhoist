import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../di.dart';
import 'appearance_data.dart';
import 'transcripts_data.dart';

/// Settings › Downloads beyond the quality: the audio format, a speed
/// limit, fast streams, the subtitle languages and embedding them. The
/// phone's keys ([DownloadChoices]), so a backup carries them across.
final downloadChoicesProvider =
    NotifierProvider<DownloadChoicesNotifier, DownloadChoices>(
      DownloadChoicesNotifier.new,
    );

class DownloadChoicesNotifier extends Notifier<DownloadChoices> {
  @override
  DownloadChoices build() {
    unawaited(
      DownloadChoices.load(ref.read(keyValueStoreProvider))
          .then((saved) => state = saved, onError: (_) {}),
    );
    return const DownloadChoices();
  }

  KeyValueStore get _store => ref.read(keyValueStoreProvider);

  Future<void> _save(Future<void> Function(KeyValueStore store) write) =>
      ref.read(prefsMutexProvider).run(() => write(_store));

  Future<void> setAudioFormat(AudioFormat format) {
    state = state.copyWith(audioFormat: format);
    return _save(
      (s) => s.setString(DownloadChoices.audioFormatKey, format.wire),
    );
  }

  /// One of [DownloadChoices.rateLimits]; null for no limit.
  Future<void> setRateLimit(String? rate) {
    state = state.copyWith(rateLimit: rate, clearRateLimit: rate == null);
    return _save(
      (s) => rate == null
          ? s.remove(DownloadChoices.rateLimitKey)
          : s.setString(DownloadChoices.rateLimitKey, rate),
    );
  }

  Future<void> setFastStreams(bool on) {
    state = state.copyWith(fastStreams: on);
    return _save((s) => s.setBool(DownloadChoices.fastStreamsKey, on));
  }

  /// Adds or takes out [code], starting from the languages in use
  /// ([current]) while none has been chosen; the last one stays.
  Future<void> toggleSubtitleLang(String code, List<String> current) {
    final now = DownloadChoices.toggled(state.subtitleLangs ?? current, code);
    state = state.copyWith(subtitleLangs: now);
    return _save((s) => s.setStringList(DownloadChoices.subtitleLangsKey, now));
  }

  Future<void> setEmbedSubtitles(bool on) {
    state = state.copyWith(embedSubtitles: on);
    return _save((s) => s.setBool(DownloadChoices.embedSubtitlesKey, on));
  }
}

/// The subtitle languages fetched: those chosen, or until then the
/// reader's language and English, as before there was a choice.
final subtitleLangsProvider = Provider<List<String>>(
  (ref) =>
      ref.watch(downloadChoicesProvider).subtitleLangs ??
      readerLanguages(ref.watch(appearanceProvider).locale),
);
