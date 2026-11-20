import 'dart:ui' show PlatformDispatcher;

import 'package:audio_service/audio_service.dart';

import '../models/play_mode.dart';
import 'media_player_port.dart';

/// Translates the internal player state into `audio_service` vocabulary.
/// Pure functions split out of `VhAudioHandler` for the size limit (rule
/// 4), and also the only unit here testable without a real player.

/// The notification and lock-screen buttons. The order is the display
/// order, and `androidCompactActionIndices` points at the first three.
List<MediaControl> vhMediaControls({
  required bool playing,
  VhMediaLabels labels = VhMediaLabels.en,
}) => [
  MediaControl(
    androidIcon: 'drawable/audio_service_skip_previous',
    label: labels.previous,
    action: MediaAction.skipToPrevious,
  ),
  if (playing)
    MediaControl(
      androidIcon: 'drawable/audio_service_pause',
      label: labels.pause,
      action: MediaAction.pause,
    )
  else
    MediaControl(
      androidIcon: 'drawable/audio_service_play_arrow',
      label: labels.play,
      action: MediaAction.play,
    ),
  MediaControl(
    androidIcon: 'drawable/audio_service_skip_next',
    label: labels.next,
    action: MediaAction.skipToNext,
  ),
  vhCloseControl(labels),
];

/// **Stop, drawn as a close mark**: the square
/// stop icon looked out of place among music players, while the button
/// itself is needed, because a paused session keeps its notification. Same
/// action, another icon; the drawable ships in each app's resources.
MediaControl vhCloseControl([VhMediaLabels labels = VhMediaLabels.en]) =>
    MediaControl(
      androidIcon: 'drawable/$vhCloseIcon',
      label: labels.close,
      action: MediaAction.stop,
    );

/// What TalkBack reads for each notification button. audio_service names
/// them in English only, so an Arabic phone heard "Previous" and "Close"
/// (found 2026-11-18). They follow the phone's language, as the
/// notification itself does, since the handler has no app context.
class VhMediaLabels {
  const VhMediaLabels({
    required this.previous,
    required this.play,
    required this.pause,
    required this.next,
    required this.close,
    required this.channel,
  });

  final String previous;
  final String play;
  final String pause;
  final String next;
  final String close;

  /// The playback notification's kind in Android's settings, beside
  /// "Downloads in progress"; it used to read "VidHoist".
  final String channel;

  static const en = VhMediaLabels(
    previous: 'Previous',
    play: 'Play',
    pause: 'Pause',
    next: 'Next',
    close: 'Close',
    channel: 'Playback',
  );

  static const ar = VhMediaLabels(
    previous: 'السابق',
    play: 'تشغيل',
    pause: 'إيقاف مؤقت',
    next: 'التالي',
    close: 'إغلاق',
    channel: 'التشغيل',
  );

  static VhMediaLabels forLanguage(String code) => code == 'ar' ? ar : en;

  /// The phone's own language.
  static VhMediaLabels system() =>
      forLanguage(PlatformDispatcher.instance.locale.languageCode);
}

/// The resource name both apps must ship under `res/drawable`.
const String vhCloseIcon = 'ic_mt_close';

/// **Idle is published only when the session really ends.** audio_service
/// treats any move into idle as the end and stops its service, removing the
/// notification and the foreground with it. just_audio reports idle for a
/// moment each time it loads a new source, still playing, so a skip or a
/// song ending would end the session mid-playlist and leave the sound
/// running unprotected. While [sessionOpen] (a queue is loaded) that moment
/// reads as loading, which it is.
AudioProcessingState vhProcessingState(
  MediaPlaybackState state, {
  required bool sessionOpen,
}) => switch (state) {
  MediaPlaybackState.idle when sessionOpen => AudioProcessingState.loading,
  MediaPlaybackState.idle => AudioProcessingState.idle,
  MediaPlaybackState.loading => AudioProcessingState.loading,
  MediaPlaybackState.buffering => AudioProcessingState.buffering,
  MediaPlaybackState.ready => AudioProcessingState.ready,
  MediaPlaybackState.completed => AudioProcessingState.completed,
};

AudioServiceRepeatMode vhRepeatMode(PlayMode mode) => switch (mode) {
  PlayMode.repeatOne => AudioServiceRepeatMode.one,
  PlayMode.repeatAll => AudioServiceRepeatMode.all,
  _ => AudioServiceRepeatMode.none,
};

AudioServiceShuffleMode vhShuffleMode({required bool shuffle}) =>
    shuffle ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none;
