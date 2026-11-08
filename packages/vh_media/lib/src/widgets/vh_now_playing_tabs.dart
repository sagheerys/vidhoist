import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import '../models/playlist_item.dart';
import '../playback/audio_handler.dart';
import '../video/video_side_panel.dart';
import 'vh_up_next_list.dart';

/// What is playing, read along beside the controls: the app's companion
/// for the current item (a transcript, in Super) and the queue, as two
/// tabs.
///
/// It lives wherever a tablet has room for it next to the player: the side
/// panel beside the library, the second column of the full player held
/// sideways, and under the controls held upright. A phone never shows it;
/// there the same two open as sheets from their buttons.
class VhNowPlayingTabs extends StatefulWidget {
  const VhNowPlayingTabs({
    super.key,
    required this.handler,
    this.artwork,
    this.companion,
  });

  final VhAudioHandler handler;
  final VhArtworkBuilder? artwork;

  /// Asked again for each item as the queue moves. Null, or a null answer,
  /// leaves the queue as the only tab.
  final VhVideoPanel? Function(PlaylistItem item)? companion;

  @override
  State<VhNowPlayingTabs> createState() => _VhNowPlayingTabsState();
}

class _VhNowPlayingTabsState extends State<VhNowPlayingTabs> {
  /// The reader's choice. The companion opens first when an item has one:
  /// it is the reason to keep the panel open at all.
  bool _queue = false;

  VhAudioHandler get _handler => widget.handler;

  @override
  Widget build(BuildContext context) => StreamBuilder<MediaItem?>(
    stream: _handler.mediaItem,
    builder: (context, _) {
      final item = _handler.currentItem;
      if (item == null) return const SizedBox.shrink();
      final pane = widget.companion?.call(item);
      final showQueue = _queue || pane == null;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: VhSpace.xs,
            runSpacing: VhSpace.xs,
            children: [
              if (pane != null)
                VhPanelTab(
                  icon: pane.icon,
                  label: pane.label,
                  selected: !showQueue,
                  onTap: () => setState(() => _queue = false),
                ),
              VhPanelTab(
                icon: VhIcons.queue,
                label: '${context.vhl.upNext} · ${_handler.items.length}',
                selected: showQueue,
                onTap: () => setState(() => _queue = true),
              ),
            ],
          ),
          const SizedBox(height: VhSpace.sm),
          Expanded(
            child: showQueue
                ? _queueList()
                // Keyed by the item, so the next clip gets its own
                // transcript rather than the last one's scroll and search.
                : KeyedSubtree(
                    key: ValueKey(item.canonicalUrl),
                    child: pane.builder(
                      context,
                      () => setState(() => _queue = true),
                    ),
                  ),
          ),
        ],
      );
    },
  );

  Widget _queueList() => ListenableBuilder(
    listenable: _handler.playingNotifier,
    builder: (context, _) {
      final ordered = _handler.orderedItems;
      final currentUrl = _handler.currentItem?.canonicalUrl;
      return VhUpNextList(
        items: ordered,
        currentIndex: ordered.indexWhere((i) => i.canonicalUrl == currentUrl),
        artwork: widget.artwork,
        paused: !_handler.playingNotifier.value,
        revealCurrent: true,
        onTap: (index) =>
            _handler.skipToQueueItem(_handler.items.indexOf(ordered[index])),
      );
    },
  );
}

/// A tab drawn like the library's filter chips: the chosen one inverted.
/// One tab of a panel beside the player: an icon and a label, filled with
/// the ink when chosen.
class VhPanelTab extends StatelessWidget {
  const VhPanelTab({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final VhIconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final fg = selected ? p.bg : p.ink2;
    final radius = BorderRadius.circular(VhRadius.chip);
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? p.ink : p.card,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: VhSpace.md,
              vertical: VhSpace.xs,
            ),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: selected ? p.ink : p.line2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                VhIcon(icon, size: 15, color: fg),
                const SizedBox(width: VhSpace.xxs),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: fg,
                    fontWeight: selected ? FontWeight.w700 : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
