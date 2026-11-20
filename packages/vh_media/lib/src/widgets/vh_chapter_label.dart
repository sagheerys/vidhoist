import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import 'vh_chapters.dart';

/// The chapter playing, beside the time over the video: its number and
/// opening words, which open the list. Nothing before the first chapter.
class VhChapterLabel extends StatelessWidget {
  const VhChapterLabel({
    super.key,
    required this.chapters,
    required this.position,
    required this.onTap,
  });

  final List<VhChapter> chapters;
  final Duration position;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final at = vhChapterAt(chapters, position);
    if (at == null) return const SizedBox.shrink();
    const ink = VhPalette.serverCardInk;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(VhRadius.field),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: VhSpace.xs,
          vertical: VhSpace.xxs,
        ),
        // Faded whole, over a picture no opaque grey can match: in a
        // translucent ink its joined Arabic letters knotted.
        child: Opacity(
          opacity: 0.85,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  vhMetaLine([
                    context.vhl.chapterNumber(at + 1),
                    chapters[at].opening,
                  ]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall!
                      .copyWith(color: ink),
                ),
              ),
              const VhIcon(
                VhIcons.forward,
                matchTextDirection: true,
                size: 16,
                color: ink,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
