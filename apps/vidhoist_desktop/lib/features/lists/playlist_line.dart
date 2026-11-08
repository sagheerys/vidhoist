import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../shell/grip.dart';
import '../../shell/now_playing_bars.dart';
import '../library/artwork.dart';

/// One clip of a saved list: the grip it is dragged by, its cover, title
/// and length, and a cross to take it out of the list (never off the
/// server). The clip playing is marked; one no longer there says so.
class PlaylistLine extends ConsumerWidget {
  const PlaylistLine({
    super.key,
    required this.index,
    required this.item,
    required this.missing,
    required this.current,
    this.playing = true,
    required this.onTap,
    required this.onRemove,
  });

  final int index;
  final PlaylistItem item;
  final bool missing;
  final bool current;

  /// The player runs: the current line's bars sway, or stand still.
  final bool playing;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  static const double _thumbWidth = 64;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final l = context.vhl;
    final subtitle = missing ? l.itemUnavailable : item.uploader;
    return Padding(
      padding: const EdgeInsets.only(bottom: VhSpace.xxs),
      child: Material(
        color: current ? vhSelectedFill(p) : p.bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VhCorners.desktop.chip),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: VhDensity.desktop.row + VhSpace.md,
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
                Opacity(
                  opacity: missing ? 0.5 : 1,
                  child: VhMediaThumb(
                    width: _thumbWidth,
                    height: _thumbWidth * 9 / 16,
                    audio: item.isAudio,
                    playing: current,
                    child: artworkFor(
                      ref,
                      context,
                      item.artworkUrl,
                      width: _thumbWidth,
                    ),
                  ),
                ),
                const SizedBox(width: VhSpace.sm),
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
                          color: missing ? p.ink3 : p.ink,
                          fontWeight: current ? FontWeight.w700 : null,
                        ),
                      ),
                      if (subtitle case final line?)
                        Text(
                          line,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.labelSmall?.copyWith(
                            color: missing ? p.err : p.ink3,
                          ),
                        ),
                    ],
                  ),
                ),
                // At the line's end, after the title, as the phone marks it.
                if (current)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: VhSpace.sm,
                    ),
                    child: NowPlayingBars(playing: playing),
                  ),
                if (item.duration case final length?)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: VhSpace.xs,
                    ),
                    child: Text(
                      vhFormatDuration(length),
                      style: text.labelSmall?.tabular.copyWith(color: p.ink3),
                    ),
                  ),
                VhShortcutTooltip(
                  message: l.desktopRemoveFromList,
                  child: IconButton(
                    onPressed: onRemove,
                    icon: VhIcon(
                      VhIcons.close,
                      size: VhSpace.md,
                      color: p.ink3,
                      semanticLabel: l.desktopRemoveFromList,
                    ),
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
