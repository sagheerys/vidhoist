import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../library/artwork.dart';
import 'done_check.dart';

/// One line of the panel: the title, what is happening to it, a thin bar
/// while it moves, and its actions.
class PanelLine extends ConsumerWidget {
  const PanelLine({
    super.key,
    required this.title,
    required this.status,
    this.thumbnail,
    this.error = false,
    this.done = false,
    this.progress,
    this.actions = const [],
    this.onClose,
  });

  /// The width of the clip's picture at the line's start.
  static const double coverWidth = 64;

  final String title;

  /// The clip's cover, when the preview or the library found one.
  final String? thumbnail;
  final String status;
  final bool error;

  /// Arrived: a check is drawn before the status.
  final bool done;

  /// 0 to 1; a negative value moves without a known end; null shows none.
  final double? progress;
  final List<Widget> actions;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final l = context.vhl;
    const coverHeight = coverWidth * 9 / 16;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: VhSpace.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Which clip at a glance, before its title is read.
          ClipRRect(
            borderRadius: BorderRadius.circular(VhCorners.desktop.thumb),
            child: Container(
              width: coverWidth,
              height: coverHeight,
              color: p.cardAlt,
              alignment: Alignment.center,
              child:
                  artworkFor(
                    ref,
                    context,
                    thumbnail,
                    width: coverWidth,
                    height: coverHeight,
                  ) ??
                  VhIcon(VhIcons.library, size: VhSpace.lg, color: p.ink3),
            ),
          ),
          const SizedBox(width: VhSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vhName(title),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodyMedium,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (done) ...[
                      const DoneCheck(),
                      const SizedBox(width: VhSpace.xxs),
                    ],
                    Flexible(
                      child: Text(
                        status,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.labelSmall?.copyWith(
                          color: error ? p.err : p.ink3,
                        ),
                      ),
                    ),
                  ],
                ),
                if (progress case final value?)
                  Padding(
                    padding: const EdgeInsets.only(top: VhSpace.xxs),
                    // The line led by the accent, or the sliding
                    // perforations while the amount is unknown.
                    child: value < 0
                        ? const VhFilmStrip()
                        : VhProgressBar(value: value),
                  ),
                // Under the text, where a long label wraps instead of
                // pushing the line past the panel at large text sizes.
                if (actions.isNotEmpty)
                  Wrap(spacing: VhSpace.xs, children: actions),
              ],
            ),
          ),
          if (onClose case final close?)
            VhShortcutTooltip(
              message: l.cancel,
              child: IconButton(
                onPressed: close,
                icon: VhIcon(
                  VhIcons.close,
                  size: VhSpace.md,
                  color: p.ink3,
                  semanticLabel: l.cancel,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
