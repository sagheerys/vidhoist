import 'package:flutter/material.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import '../features/listening/listening_room.dart';
import 'now_playing.dart';
import 'player_controls.dart';
import 'seek_bar.dart';
import 'shell_metrics.dart';
import 'volume_slider.dart';

/// The player bar, fixed at the foot of the window and never hidden, so
/// sound and its controls survive every move around the app. With nothing
/// queued the controls stay in place, dimmed.
class DesktopPlayerBar extends StatelessWidget {
  const DesktopPlayerBar({
    super.key,
    required this.player,
    required this.onShowQueue,
    required this.onOpen,
    required this.onMini,
    required this.audioOnly,
    required this.listening,
    required this.onListen,
  });

  final VhPlayer player;
  final VoidCallback onShowQueue;

  /// Opens the playing clip's page, from a click on its title.
  final ValueChanged<String> onOpen;

  /// Turns the window into the small card above the others.
  final VoidCallback onMini;

  /// Whether a video is heard with its picture off; whether the listening
  /// room is asked for, and the way in and out.
  final bool audioOnly;
  final bool listening;
  final VoidCallback onListen;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return Container(
      height: DesktopShellSize.playerBar,
      decoration: BoxDecoration(
        color: p.bg,
        border: Border(
          top: BorderSide(color: p.line, width: VhThemeX.of(context).hairline),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: VhSpace.xl),
      child: StreamBuilder<VhPlayerState>(
        stream: player.states,
        initialData: player.state,
        builder: (context, snap) {
          final state = snap.data ?? player.state;
          return Row(
            children: [
              Expanded(
                child: DesktopNowPlaying(state: state, onOpen: onOpen),
              ),
              Expanded(
                flex: 2,
                child: _Transport(player: player, state: state),
              ),
              Expanded(
                child: _Extras(
                  player: player,
                  state: state,
                  onShowQueue: onShowQueue,
                  onMini: onMini,
                  // The room is for sound: a picture has full screen.
                  listening: playsAsSound(state.current, audioOnly: audioOnly)
                      ? listening
                      : null,
                  onListen: onListen,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The transport and the seek bar. **They never mirror** in Arabic: play
/// controls keep the direction of time, as media players do everywhere.
class _Transport extends StatelessWidget {
  const _Transport({required this.player, required this.state});

  final VhPlayer player;
  final VhPlayerState state;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l = context.vhl;
    final live = !state.isEmpty;
    VoidCallback? when(VoidCallback f) => live ? f : null;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DesktopPlayerControl(
                icon: VhIcons.shuffle,
                label: l.shuffle,
                selected: state.shuffle,
                onTap: when(() => player.setShuffle(!state.shuffle)),
              ),
              DesktopPlayerControl(
                icon: VhIcons.prev,
                label: l.previous,
                onTap: when(player.skipToPrevious),
              ),
              const SizedBox(width: VhSpace.xs),
              DesktopPlayButton(
                playing: state.playing,
                label: state.playing ? l.pause : l.play,
                onTap: when(state.playing ? player.pause : player.play),
                accent: p.accent,
                ink: p.onAccent,
              ),
              const SizedBox(width: VhSpace.xs),
              DesktopPlayerControl(
                icon: VhIcons.next,
                label: l.next,
                onTap: when(player.skipToNext),
              ),
              DesktopPlayerControl(
                icon: playModeIcon(state.mode),
                label: vhPlayModeLabel(context, state.mode),
                selected: state.mode != PlayMode.autoNext,
                onTap: when(() => player.setPlayMode(nextPlayMode(state.mode))),
              ),
            ],
          ),
          DesktopSeekBar(player: player, duration: state.duration),
        ],
      ),
    );
  }
}

class _Extras extends StatelessWidget {
  const _Extras({
    required this.player,
    required this.state,
    required this.onShowQueue,
    required this.onMini,
    required this.listening,
    required this.onListen,
  });

  final VhPlayer player;
  final VhPlayerState state;
  final VoidCallback onShowQueue;
  final VoidCallback onMini;

  /// Whether the listening room is open; null hides its button.
  final bool? listening;
  final VoidCallback onListen;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l = context.vhl;
    final speeds = PlaybackSpeeds.options;
    final at = speeds.indexOf(state.speed);
    final nextSpeed = speeds[(at + 1) % speeds.length];
    // In a narrow window the group shrinks rather than spill past the bar.
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerEnd,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VhShortcutTooltip(
            message: l.playbackSpeed,
            child: TextButton(
              onPressed: state.isEmpty
                  ? null
                  : () => player.setSpeed(nextSpeed),
              // Read as what it is, then the speed: "Playback speed, 1.0×".
              child: Semantics(
                label: l.playbackSpeed,
                value: vhLtrRun('${state.speed}×'),
                excludeSemantics: true,
                child: Text(
                  vhLtrRun('${state.speed}×'),
                  style: Theme.of(context).textTheme.labelMedium?.tabular
                      .copyWith(color: p.ink2),
                ),
              ),
            ),
          ),
          if (listening case final open?)
            DesktopPlayerControl(
              icon: VhIcons.headphones,
              label: context.vhl.desktopListeningRoom,
              selected: open,
              onTap: onListen,
            ),
          DesktopPlayerControl(
            icon: VhIcons.pip,
            label: l.desktopMiniWindow,
            shortcut: 'Ctrl M',
            onTap: state.isEmpty ? null : onMini,
          ),
          DesktopPlayerControl(
            icon: VhIcons.queue,
            label: l.queueLabel,
            onTap: onShowQueue,
          ),
          const SizedBox(width: VhSpace.xs),
          const DesktopVolumeSlider(),
        ],
      ),
    );
  }
}

/// The repeat button's next mode, and R's: round the four in order.
PlayMode nextPlayMode(PlayMode mode) =>
    PlayMode.values[(mode.index + 1) % PlayMode.values.length];

/// Each mode its own glyph, so the button says which is on: a "1" in the
/// loop for one clip, an arrow to a bar for stopping after it.
VhIconData playModeIcon(PlayMode mode) => switch (mode) {
  PlayMode.repeatOne => VhIcons.repeatOne,
  PlayMode.stopAtEnd => VhIcons.stopAfter,
  PlayMode.autoNext || PlayMode.repeatAll => VhIcons.repeat,
};
