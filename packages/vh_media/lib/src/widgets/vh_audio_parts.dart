import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import '../models/playlist_item.dart';
import '../playback/audio_handler.dart';
import 'media_time.dart';
import 'vh_extra_button.dart';
import 'vh_progress_slider.dart';
import 'vh_tilted_artwork.dart';

/// The source chip, the title and the artist line under the cover.
class VhAudioTitles extends StatelessWidget {
  const VhAudioTitles({
    super.key,
    required this.item,
    required this.media,
    required this.index,
    required this.total,
    this.playlistName,
    this.showSourceChip = true,
    this.favorite = false,
    this.onFavorite,
  });

  final PlaylistItem item;
  final MediaItem media;
  final int index;
  final int total;
  final String? playlistName;
  final bool showSourceChip;

  /// The heart beside the title, shown when [onFavorite] is given.
  final bool favorite;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final l10n = context.vhl;
    final parts = [
      if (media.artist != null && media.artist!.isNotEmpty) media.artist!,
      if (playlistName != null) '«$playlistName»',
      if (total > 1) vhLtrRun(l10n.playlistOf(index + 1, total)),
    ];
    final title = VhForeignText(
      media.title,
      center: true,
      maxLines: 2,
      style: text.titleLarge!.copyWith(fontSize: 19),
    );
    return Column(
      children: [
        if (showSourceChip) ...[
          VhSourceChip(local: item.hasLocal),
          const SizedBox(height: VhSpace.sm),
        ],
        if (onFavorite case final toggle?)
          Row(
            children: [
              // Balances the heart, so the title stays centred.
              const SizedBox(width: kMinInteractiveDimension),
              Expanded(child: title),
              VhFavoriteButton(favorite: favorite, onPressed: toggle),
            ],
          )
        else
          title,
        if (parts.isNotEmpty) ...[
          const SizedBox(height: VhSpace.xxs),
          Text(
            parts.join(' · '),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall!.copyWith(color: p.ink3),
          ),
        ],
      ],
    );
  }
}

/// The progress bar, fed by the player's position.
class VhAudioSlider extends StatelessWidget {
  const VhAudioSlider({super.key, required this.handler, required this.media});

  final VhAudioHandler handler;
  final MediaItem media;

  @override
  Widget build(BuildContext context) => StreamBuilder<Duration>(
    stream: handler.positionStream,
    builder: (context, snapshot) => VhProgressSlider(
      position: snapshot.data ?? Duration.zero,
      duration: media.duration,
      onSeek: handler.seek,
    ),
  );
}

/// The line under the controls: **speed at one end and the queue at the
/// other, as light marks** (mobile plan, page 02), and an app's extra
/// between them. Two framed pills with their names written out ("Speed
/// 1.0×", "Queue 12") were heavier than the transport above them; the
/// names stay for screen readers.
class VhAudioSubControls extends StatelessWidget {
  const VhAudioSubControls({
    super.key,
    required this.handler,
    this.onQueue,
    this.extra,
  });

  final VhAudioHandler handler;

  /// Null where the queue is already on screen, as a tab beside the player.
  final VoidCallback? onQueue;
  final VhExtraAction? extra;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return StreamBuilder<PlaybackState>(
      stream: handler.playbackState,
      builder: (context, snapshot) {
        final speed = snapshot.data?.speed ?? 1.0;
        return Row(
          children: [
            _Mark(
              onTap: () => handler.setSpeed(vhNextSpeed(speed)),
              label: l10n.playbackSpeed,
              child: Text(
                '${vhFormatSpeed(speed)}×',
                style: text.labelLarge!.copyWith(color: p.ink2).tabular,
              ),
            ),
            const Spacer(),
            if (extra case final extra?) VhExtraButton(extra: extra),
            const Spacer(),
            if (onQueue case final open?)
              _Mark(
                onTap: open,
                label: l10n.queueLabel,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VhIcon(VhIcons.queue, size: 20, color: p.ink2),
                    const SizedBox(width: VhSpace.xxs),
                    Text(
                      '${handler.items.length}',
                      style: text.labelSmall!.copyWith(color: p.ink2),
                    ),
                  ],
                ),
              )
            else
              // Keeps the extra in the middle when the queue is elsewhere.
              const SizedBox(width: _Mark.size),
          ],
        );
      },
    );
  }
}

/// A light tappable mark: no frame, a finger-sized target, its name read
/// out rather than written.
class _Mark extends StatelessWidget {
  const _Mark({required this.onTap, required this.label, required this.child});

  final VoidCallback onTap;
  final String label;
  final Widget child;

  static const double size = 48;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(VhRadius.chip),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: size, minHeight: size),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: VhSpace.sm),
          child: Center(widthFactor: 1, child: child),
        ),
      ),
    ),
  );
}
