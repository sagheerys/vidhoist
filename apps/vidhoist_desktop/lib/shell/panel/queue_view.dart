import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import '../grip.dart';
import '../now_playing_bars.dart';

/// What comes next, in play order, with the clip playing marked: drag a
/// line by its grip to reorder, click it to play it now.
class QueueView extends StatelessWidget {
  const QueueView({super.key, required this.state, required this.player});

  final VhPlayerState state;
  final VhPlayer player;

  @override
  Widget build(BuildContext context) {
    final ordered = state.ordered;
    final current = state.current;
    final at = current == null ? -1 : ordered.indexOf(current);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ReorderableListView.builder(
            // Material's own handle is a Material icon; the grip below is
            // drawn instead, and only it starts a drag, so a click still
            // plays.
            buildDefaultDragHandles: false,
            itemCount: ordered.length,
            onReorderItem: (from, to) =>
                unawaited(player.moveQueueItem(from, to)),
            itemBuilder: (context, i) => _QueueLine(
              key: ValueKey(Object.hash(ordered[i].canonicalUrl, i)),
              index: i,
              item: ordered[i],
              current: i == at,
              playing: state.playing,
              onTap: () => unawaited(
                player.skipToQueueItem(state.items.indexOf(ordered[i])),
              ),
            ),
          ),
        ),
        if (at == ordered.length - 1)
          Padding(
            padding: const EdgeInsets.only(top: VhSpace.sm),
            child: Text(
              context.vhl.desktopQueueEnd,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: VhThemeX.of(context).palette.ink3),
            ),
          ),
      ],
    );
  }
}

class _QueueLine extends StatelessWidget {
  const _QueueLine({
    super.key,
    required this.index,
    required this.item,
    required this.current,
    required this.playing,
    required this.onTap,
  });

  final int index;
  final PlaylistItem item;
  final bool current;
  final bool playing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final l = context.vhl;
    return Material(
      color: current ? vhSelectedFill(p) : p.bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VhCorners.desktop.chip),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        // A floor, not a fixed height: with large text the two lines need
        // more than one row's worth.
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: VhDensity.desktop.row + VhSpace.sm,
          ),
          child: Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: VhShortcutTooltip(
                    message: l.desktopDragToReorder,
                    child: SizedBox(
                      width: VhSpace.xxl,
                      height: VhDensity.desktop.row,
                      child: const DesktopGrip(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: vhTextDirectionOf(
                        item.title,
                        Directionality.of(context),
                      ),
                      style: text.bodySmall?.copyWith(
                        color: p.ink,
                        fontWeight: current ? FontWeight.w700 : null,
                      ),
                    ),
                    if (item.uploader case final who?)
                      Text(
                        who,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.labelSmall?.copyWith(color: p.ink3),
                      ),
                  ],
                ),
              ),
              // At the line's end, after the title, as the phone marks it.
              if (current)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: VhSpace.sm),
                  child: NowPlayingBars(playing: playing),
                ),
              if (item.duration case final length?)
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: VhSpace.xs,
                    end: VhSpace.sm,
                  ),
                  child: Text(
                    vhFormatDuration(length),
                    style: text.labelSmall?.tabular.copyWith(color: p.ink3),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
