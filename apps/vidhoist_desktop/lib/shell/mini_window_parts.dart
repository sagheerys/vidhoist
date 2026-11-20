part of 'mini_window.dart';

// The small card's titles, buttons and progress line.

class _Titles extends StatelessWidget {
  const _Titles({required this.item, this.onPicture = false});

  final PlaylistItem? item;

  /// White over a picture, the mini player's ink otherwise.
  final bool onPicture;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final ink = onPicture ? Colors.white : p.miniInk;
    final muted = onPicture ? Colors.white70 : p.miniInkMuted;
    final item = this.item;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item?.title ?? context.vhl.desktopNothingPlaying,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textDirection: item == null
              ? null
              : vhTextDirectionOf(item.title, Directionality.of(context)),
          style: text.titleSmall?.copyWith(color: ink),
        ),
        if (item?.uploader case final who?)
          Text(
            who,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall?.copyWith(color: muted),
          ),
      ],
    );
  }
}

/// Play and next, and the way back to the full window. They keep the
/// direction of time in Arabic too, as the player bar's do.
class _Buttons extends StatelessWidget {
  const _Buttons({
    required this.state,
    required this.widget,
    required this.ink,
  });

  final VhPlayerState state;
  final DesktopMiniWindow widget;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final player = widget.player;
    final live = !state.isEmpty;
    Widget button(VhIconData icon, String label, VoidCallback? onTap) =>
        VhShortcutTooltip(
          message: label,
          child: IconButton(
            onPressed: onTap,
            icon: VhIcon(
              icon,
              size: VhDensity.desktop.icon,
              color: onTap == null ? ink.withValues(alpha: 0.4) : ink,
              semanticLabel: label,
            ),
          ),
        );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(
            state.playing ? VhIcons.pause : VhIcons.playFill,
            state.playing ? l.pause : l.play,
            live
                ? () =>
                      unawaited(state.playing ? player.pause() : player.play())
                : null,
          ),
          button(
            VhIcons.next,
            l.next,
            live ? () => unawaited(player.skipToNext()) : null,
          ),
          button(VhIcons.fullscreen, l.desktopMiniRestore, widget.onRestore),
        ],
      ),
    );
  }
}

/// A hairline of the clip's progress along the card's foot.
class _Progress extends StatelessWidget {
  const _Progress({required this.player, required this.state});

  final VhPlayer player;
  final VhPlayerState state;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return StreamBuilder<Duration>(
      stream: player.positionStream,
      initialData: player.position,
      builder: (context, snap) {
        final total = state.duration?.inMilliseconds ?? 0;
        final at = snap.data?.inMilliseconds ?? 0;
        // Drawn, not Material's bar: the hairline fills left to right as
        // the playback bar does, whatever the language.
        return SizedBox(
          height: _hairline,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: total <= 0 ? 0 : (at / total).clamp(0.0, 1.0),
              child: ColoredBox(color: p.accent),
            ),
          ),
        );
      },
    );
  }

  static const _hairline = 2.0;
}
