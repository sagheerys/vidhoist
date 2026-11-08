import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import '../models/playlist_item.dart';
import 'vh_up_next_list.dart';

/// The queue contents, the same in all three shapes: a bottom sheet for
/// audio, an "up next" section for portrait video, a side panel for
/// landscape. All three carry a "save this queue" button and a "show all"
/// link, and the button is absent when the source is already a saved
/// playlist ([playlistName] non-empty).
class VhQueuePanel extends StatelessWidget {
  const VhQueuePanel({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelect,
    this.artwork,
    this.onShowAll,
    this.playlistName,
    this.dark = false,
    this.paused = false,
    this.nested = false,
  });

  /// The items in actual play order.
  final List<PlaylistItem> items;

  /// The current index inside [items].
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final VhArtworkBuilder? artwork;

  /// Turns the current playback session into a permanent playlist.

  /// Jumps to the playlist's detail page in its own tab.
  final VoidCallback? onShowAll;
  final String? playlistName;
  final bool dark;

  /// The current item is paused, which is passed to the equaliser so it
  /// stands still.
  final bool paused;

  /// **Inside a scrollable parent?** Otherwise the video list at the bottom
  /// cannot be scrolled. The inner list was `shrinkWrap`
  /// with no `physics`, an independent scroll view exactly as tall as its
  /// content, so it had no range to move **and it swallowed the drag**,
  /// which never reached the parent. The answer is not to drop `shrinkWrap`
  /// but to disable the child's physics so the parent scrolls everything.
  final bool nested;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        VhQueueHeader(
          count: items.length,
          playlistName: playlistName,
          onShowAll: onShowAll,
          dark: dark,
        ),
        const SizedBox(height: VhSpace.xs),
        // Sized to its rows, and still lazy: the height here is bounded,
        // so only the rows that fit are built.
        Flexible(
          child: VhUpNextList(
            items: items,
            currentIndex: currentIndex,
            artwork: artwork,
            dark: dark,
            paused: paused,
            shrinkWrap: true,
            physics: nested ? const NeverScrollableScrollPhysics() : null,
            revealCurrent: !nested,
            onTap: onSelect,
          ),
        ),
      ],
    );
  }
}

/// The queue's title, its size and the "show all" link, above its rows.
class VhQueueHeader extends StatelessWidget {
  const VhQueueHeader({
    super.key,
    required this.count,
    this.playlistName,
    this.onShowAll,
    this.dark = false,
  });

  final int count;
  final String? playlistName;
  final VoidCallback? onShowAll;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final l10n = context.vhl;
    final ink = dark ? p.miniInk : p.ink;
    final muted = dark ? p.miniInkMuted : p.ink3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                playlistName == null
                    ? l10n.upNext
                    : l10n.upNextIn(vhName(playlistName)),
                style: text.titleMedium!.copyWith(color: ink),
              ),
            ),
            if (onShowAll != null)
              TextButton(
                onPressed: onShowAll,
                child: Text(
                  l10n.viewAllInPlaylists,
                  style: text.labelSmall!.copyWith(
                    color: p.accentInk,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        Text(
          l10n.queueItemsCount(count),
          style: text.labelSmall!.copyWith(color: muted),
        ),
      ],
    );
  }
}

/// Opens the queue bottom sheet, for the audio screen and the portrait
/// player.
Future<void> showVhQueueSheet(
  BuildContext context, {
  required List<PlaylistItem> items,
  required int currentIndex,
  required ValueChanged<int> onSelect,
  VhArtworkBuilder? artwork,
  VoidCallback? onShowAll,
  String? playlistName,
  Listenable? liveness,
  bool Function()? paused,
}) => showVhSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  builder: (sheetContext) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(VhSpace.pagePad),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.72,
        ),
        // **The sheet is built once and does not know playback stopped**,
        // so it is rebuilt on [liveness], the video session or the audio
        // player's notifier, or the equaliser keeps dancing over a silent
        // clip.
        child: _LiveQueue(
          liveness: liveness,
          builder: (context) => VhQueuePanel(
            items: items,
            currentIndex: currentIndex,
            artwork: artwork,
            playlistName: playlistName,
            paused: paused?.call() ?? false,
            onShowAll: onShowAll,
            onSelect: (index) {
              Navigator.of(sheetContext).pop();
              onSelect(index);
            },
          ),
        ),
      ),
    ),
  ),
);

/// Rebuilds the sheet's contents whenever [liveness] changes, or once when
/// no liveness source is supplied.
class _LiveQueue extends StatelessWidget {
  const _LiveQueue({required this.builder, this.liveness});

  final WidgetBuilder builder;
  final Listenable? liveness;

  @override
  Widget build(BuildContext context) => liveness == null
      ? builder(context)
      : ListenableBuilder(
          listenable: liveness!,
          builder: (context, _) => builder(context),
        );
}
