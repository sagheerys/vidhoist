import 'dart:math' as math;

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import '../models/playlist_item.dart';
import '../playback/audio_handler.dart';
import '../widgets/vh_extra_button.dart';
import '../widgets/vh_breathing_glow.dart';
import '../widgets/vh_player_controls_row.dart';
import '../widgets/vh_queue_panel.dart';
import '../widgets/vh_tilted_artwork.dart';
import '../widgets/vh_drag_to_dismiss.dart';
import '../video/video_side_panel.dart';
import '../widgets/vh_audio_parts.dart';
import '../widgets/vh_now_playing_tabs.dart';
import '../widgets/vh_up_next_list.dart';

/// The full audio screen: a tilted cover, a draggable progress bar,
/// previous and next, the modes and shuffle, and a queue button.
class VhAudioScreen extends StatelessWidget {
  const VhAudioScreen({
    super.key,
    required this.handler,
    this.artwork,
    this.cover,
    this.onShowPlaylist,
    this.onDetails,
    this.playlistName,
    this.showSourceChip = true,
    this.extra,
    this.companion,
    this.isFavorite,
    this.onFavorite,
    this.peek,
  });

  final VhAudioHandler handler;
  final VhArtworkBuilder? artwork;

  /// The picture for the big square cover, which may want a better one
  /// than a list row; [artwork] when null.
  final VhArtworkBuilder? cover;
  final VoidCallback? onShowPlaylist;

  /// **Clip details**, which replaced the queue button in the header: the
  /// queue already has its visible button at the
  /// bottom of the screen, and a second one at the top repeats it without
  /// adding anything.
  final VoidCallback? onDetails;
  final String? playlistName;

  /// **The source chip, streamed or "playing from your device"**:
  /// information that matters only where both sources coexist. The phone
  /// app turns it off, since everything in its library is already on the
  /// device.
  final bool showSourceChip;

  /// Asked again for each item as the queue moves: an app feature this
  /// package does not know, such as a transcript, that only some items
  /// have. Null, or a null answer, shows nothing.
  final VhExtraAction? Function(PlaylistItem item)? extra;

  /// Read along beside the player on a tablet, as a tab next to the queue
  /// (a transcript, in the apps). On a phone it is reached through [extra].
  final VhVideoPanel? Function(PlaylistItem item)? companion;

  /// The heart beside the title: whether the clip is a favourite, and the
  /// toggle. Both or neither.
  final bool Function(PlaylistItem item)? isFavorite;
  final void Function(PlaylistItem item)? onFavorite;

  /// **A glimpse under the controls on a tall phone**: the transcript's
  /// current lines, in place of [extra]'s button. Null for a clip with
  /// nothing to show, and left out on a short screen or at a large text
  /// size, where the button comes back.
  final Widget? Function(PlaylistItem item)? peek;

  /// The height a phone needs before [peek] shows, in logical points: the
  /// Galaxy S22 (823) and taller.
  static const peekMinHeight = 780.0;

  @override
  Widget build(BuildContext context) => StreamBuilder<MediaItem?>(
    stream: handler.mediaItem,
    builder: (context, snapshot) {
      final media = snapshot.data;
      final item = handler.currentItem;
      if (media == null || item == null) {
        return const _EmptyPlayer();
      }
      // **Dragging down returns it to the mini player** (requested
      // 2026-09-04): the screen rose out of it like a sheet, so it is
      // natural to drag it back. The scrubber and the buttons are
      // unaffected, since the gesture is vertical.
      //
      // **The whole Scaffold moves, not its content**: moving the content
      // alone left the screen background in place, showing a dark void
      // above it, whereas what is wanted is the cover and the mini player
      // showing behind it like a sheet being dragged away. That is why its
      // route is non-opaque in the router.
      final size = MediaQuery.sizeOf(context);
      final tablet = size.shortestSide >= VhBreakpoint.tabletSide;
      final sideways = size.width > size.height;
      return VhDragToDismiss(
        child: Scaffold(
          body: SafeArea(
            child: !tablet
                ? sideways
                      ? _sideways(context, item, media)
                      : _player(context, item, media)
                // **A tablet keeps the queue and the transcript in view**
                // (2026-10-10): beside the player when held sideways,
                // under it when upright, instead of a sheet over it.
                : sideways
                ? Row(
                    children: [
                      Expanded(child: _player(context, item, media)),
                      VerticalDivider(
                        width: 1,
                        color: VhThemeX.of(context).palette.line,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(VhSpace.xl),
                          child: _tabs(),
                        ),
                      ),
                    ],
                  )
                : _player(context, item, media, below: _tabs()),
          ),
        ),
      );
    },
  );

  Widget _tabs() => VhNowPlayingTabs(
    handler: handler,
    artwork: artwork,
    companion: companion,
  );

  /// The player column. With [below], a tablet held upright, the cover
  /// gives up part of its height to the tabs, and the pills drop the queue
  /// and the extra, which the tabs already show.
  Widget _player(
    BuildContext context,
    PlaylistItem item,
    MediaItem media, {
    Widget? below,
  }) {
    final size = MediaQuery.sizeOf(context);
    final roomy =
        below == null &&
        size.height >= peekMinHeight &&
        MediaQuery.textScalerOf(context).scale(1) <= 1.3;
    final shownPeek = roomy ? peek?.call(item) : null;
    return VhReadableWidth(
      maxWidth: below == null ? VhBreakpoint.player : VhBreakpoint.readable,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: VhSpace.xl),
        child: Column(
          children: [
            _Header(handler: handler, onDetails: onDetails),
            // The cover takes what the rest leaves, up to its usual size: at
            // Android's largest text on a small phone the fixed-size cover
            // pushed the controls past the bottom. The spare room stays two
            // parts above to one below.
            Expanded(
              flex: 5,
              child: LayoutBuilder(
                builder: (context, box) {
                  final size = math.min(
                    _artSize(context),
                    box.maxHeight - VhSpace.lg * 2,
                  );
                  if (size < _smallestArt) return const SizedBox();
                  return Align(
                    alignment: const Alignment(0, 1 / 3),
                    child: VhBreathingGlow(
                      playing: handler.playingNotifier,
                      size: size,
                      child: VhTiltedArtwork(
                        item: item,
                        artwork: cover ?? artwork,
                        size: size,
                        // The glow behind is the light; a deep shadow under
                        // the plate as well read as two.
                        shadow: false,
                      ),
                    ),
                  );
                },
              ),
            ),
            VhAudioTitles(
              item: item,
              media: media,
              playlistName: playlistName,
              index: handler.currentIndex,
              total: handler.items.length,
              showSourceChip: showSourceChip,
              favorite: isFavorite?.call(item) ?? false,
              onFavorite: onFavorite == null ? null : () => onFavorite!(item),
            ),
            const SizedBox(height: VhSpace.xl),
            VhAudioSlider(handler: handler, media: media),
            const SizedBox(height: VhSpace.md),
            VhPlayerControlsRow(handler: handler),
            const SizedBox(height: VhSpace.lg),
            VhAudioSubControls(
              handler: handler,
              onQueue: _onTablet(context) ? null : () => _openQueue(context),
              extra: _onTablet(context) || shownPeek != null
                  ? null
                  : extra?.call(item),
            ),
            const SizedBox(height: VhSpace.lg),
            if (below != null) Expanded(flex: 4, child: below),
            if (shownPeek != null) ...[
              shownPeek,
              const SizedBox(height: VhSpace.lg),
            ],
          ],
        ),
      ),
    );
  }

  /// **A phone held sideways**, which used to show no cover at all.
  /// Stacked in a column, the controls left the cover less height than its
  /// smallest size, so it was dropped. Beside the controls it gets the
  /// screen's full height. The controls scroll rather than overflow at the
  /// largest text.
  Widget _sideways(BuildContext context, PlaylistItem item, MediaItem media) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: VhSpace.xl),
        child: Column(
          children: [
            _Header(handler: handler, onDetails: onDetails),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, box) {
                        final size =
                            math.min(box.maxWidth, box.maxHeight) -
                            VhSpace.lg * 2;
                        if (size < _smallestArt) return const SizedBox();
                        return Center(
                          child: VhBreathingGlow(
                            playing: handler.playingNotifier,
                            size: size,
                            child: VhTiltedArtwork(
                              item: item,
                              artwork: cover ?? artwork,
                              size: size,
                              shadow: false,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: VhSpace.xl),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, box) => SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: box.maxHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              VhAudioTitles(
                                item: item,
                                media: media,
                                playlistName: playlistName,
                                index: handler.currentIndex,
                                total: handler.items.length,
                                showSourceChip: showSourceChip,
                                favorite: isFavorite?.call(item) ?? false,
                                onFavorite: onFavorite == null
                                    ? null
                                    : () => onFavorite!(item),
                              ),
                              const SizedBox(height: VhSpace.md),
                              VhAudioSlider(handler: handler, media: media),
                              VhPlayerControlsRow(handler: handler),
                              const SizedBox(height: VhSpace.sm),
                              VhAudioSubControls(
                                handler: handler,
                                onQueue: () => _openQueue(context),
                                extra: extra?.call(item),
                              ),
                              const SizedBox(height: VhSpace.sm),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  static bool _onTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= VhBreakpoint.tabletSide;

  /// Below this a cover says nothing; the controls get the room instead.
  static const _smallestArt = 64.0;

  double _artSize(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return (size.width - VhSpace.xl * 2).clamp(120.0, size.height * 0.38);
  }

  void _openQueue(BuildContext context) {
    final ordered = handler.orderedItems;
    final currentUrl = handler.currentItem?.canonicalUrl;
    showVhQueueSheet(
      context,
      items: ordered,
      currentIndex: ordered.indexWhere((i) => i.canonicalUrl == currentUrl),
      artwork: artwork,
      playlistName: playlistName,
      liveness: handler.playingNotifier,
      paused: () => !handler.playingNotifier.value,
      onShowAll: onShowPlaylist,
      onSelect: (index) =>
          handler.skipToQueueItem(handler.items.indexOf(ordered[index])),
    );
  }
}

class _EmptyPlayer extends StatelessWidget {
  const _EmptyPlayer();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: VhEmptyState(
      title: context.vhl.nowPlaying,
      message: context.vhl.nothingHereYet,
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.handler, this.onDetails});

  final VhAudioHandler handler;
  final VoidCallback? onDetails;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l10n = context.vhl;
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: l10n.dismiss,
          icon: VhIcon(VhIcons.chevronDown, color: p.ink2),
        ),
        Expanded(
          child: Text(
            l10n.nowPlaying,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: p.ink3,
              letterSpacing: vhLabelTracking(context, 1.6),
            ),
          ),
        ),
        if (onDetails case final VoidCallback show)
          IconButton(
            onPressed: show,
            tooltip: l10n.details,
            icon: VhIcon(VhIcons.info, color: p.ink2),
          )
        else
          const SizedBox(width: 48),
      ],
    );
  }
}
