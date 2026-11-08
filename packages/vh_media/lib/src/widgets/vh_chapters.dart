import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import 'media_time.dart';

/// One chapter of a clip: where it begins, and its opening words. The app
/// works them out (from a transcript, which this package does not know);
/// the record has the same shape as the transcripts package's, so its
/// chapters pass straight in.
typedef VhChapter = ({Duration start, String opening});

/// The chapter playing at [position]: the last to have begun. Null before
/// the first, or for a clip without chapters.
int? vhChapterAt(List<VhChapter> chapters, Duration position) {
  int? at;
  for (final (i, chapter) in chapters.indexed) {
    if (chapter.start > position) break;
    at = i;
  }
  return at;
}

/// Chapters as rows: the time each begins and its opening words, the one
/// playing lit. A tap plays from there.
class VhChapterRows extends StatelessWidget {
  const VhChapterRows({
    super.key,
    required this.chapters,
    required this.current,
    required this.onSeek,
    this.from = 0,
    this.count,
  });

  final List<VhChapter> chapters;
  final int? current;
  final ValueChanged<Duration> onSeek;

  /// The first row shown, and how many; all of them by default.
  final int from;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final to = count == null
        ? chapters.length
        : (from + count!).clamp(0, chapters.length);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = from; i < to; i++)
          Semantics(
            button: true,
            selected: i == current,
            child: Material(
              color: i == current ? vhSelectedFill(p) : Colors.transparent,
              borderRadius: BorderRadius.circular(VhRadius.field),
              child: InkWell(
                key: ValueKey('chapter-$i'),
                borderRadius: BorderRadius.circular(VhRadius.field),
                onTap: () => onSeek(chapters[i].start),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: VhSpace.sm,
                    vertical: VhSpace.sm,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vhLtrRun(vhFormatDuration(chapters[i].start)),
                        style: text.labelMedium!
                            .copyWith(
                              color: i == current ? p.accentInk : p.ink3,
                            )
                            .tabular,
                      ),
                      const SizedBox(width: VhSpace.md),
                      Expanded(
                        child: VhForeignText(
                          chapters[i].opening,
                          maxLines: 2,
                          style: text.bodySmall!.copyWith(
                            color: i == current ? p.ink : p.ink2,
                            fontWeight: i == current ? FontWeight.w700 : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// **The chapters under the player's buttons**: a few around the one
/// playing, and the way to all of them. An arrow in the heading folds
/// them away and back; [folded] keeps that choice where the app wants it
/// kept, and without one it lasts as long as the section.
class VhChapterSection extends StatefulWidget {
  const VhChapterSection({
    super.key,
    required this.chapters,
    required this.current,
    required this.onSeek,
    required this.onShowAll,
    this.folded,
  });

  /// How many rows the section shows before "View all".
  static const shown = 4;

  final List<VhChapter> chapters;
  final int? current;
  final ValueChanged<Duration> onSeek;
  final VoidCallback onShowAll;
  final ValueNotifier<bool>? folded;

  @override
  State<VhChapterSection> createState() => _VhChapterSectionState();
}

class _VhChapterSectionState extends State<VhChapterSection> {
  final _own = ValueNotifier(false);

  ValueNotifier<bool> get _folded => widget.folded ?? _own;

  @override
  void dispose() {
    _own.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final chapters = widget.chapters;
    final last = chapters.length - VhChapterSection.shown;
    // The one playing second from the top, so what comes next shows.
    final from = ((widget.current ?? 0) - 1).clamp(0, last < 0 ? 0 : last);
    final still = MediaQuery.disableAnimationsOf(context);
    return ValueListenableBuilder(
      valueListenable: _folded,
      builder: (context, folded, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VhSectionHeader(
            title: l10n.desktopChapters,
            trailing: l10n.chaptersFromTranscript(chapters.length),
            action: IconButton(
              key: const ValueKey('chapters-fold'),
              onPressed: () => _folded.value = !folded,
              tooltip: folded ? l10n.chaptersUnfold : l10n.chaptersFold,
              visualDensity: VisualDensity.compact,
              icon: AnimatedRotation(
                turns: folded ? 0.5 : 0,
                duration: still ? Duration.zero : VhMotion.fast,
                child: VhIcon(VhIcons.chevronUp, color: p.ink2),
              ),
            ),
          ),
          AnimatedSize(
            duration: still ? Duration.zero : VhMotion.medium,
            curve: VhMotion.ease,
            alignment: AlignmentDirectional.topCenter,
            child: folded
                ? const SizedBox(width: double.infinity)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: VhSpace.xs),
                      VhChapterRows(
                        chapters: chapters,
                        current: widget.current,
                        onSeek: widget.onSeek,
                        from: from,
                        count: VhChapterSection.shown,
                      ),
                      if (chapters.length > VhChapterSection.shown)
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            onPressed: widget.onShowAll,
                            child: Text(l10n.chaptersShowAll),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// Every chapter in a sheet, the one playing lit as playback moves; a tap
/// closes the sheet and plays from there.
Future<void> showVhChapterSheet(
  BuildContext context, {
  required List<VhChapter> chapters,
  required Listenable ticks,
  required Duration Function() position,
  required ValueChanged<Duration> onSeek,
}) => showVhSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (sheet) => ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(sheet).height * 0.75,
    ),
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        VhSpace.pagePad,
        VhSpace.lg,
        VhSpace.pagePad,
        vhSheetBottomPad(sheet),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VhSectionHeader(
            title: sheet.vhl.desktopChapters,
            trailing: sheet.vhl.chaptersFromTranscript(chapters.length),
          ),
          const SizedBox(height: VhSpace.xs),
          Flexible(
            child: SingleChildScrollView(
              child: ListenableBuilder(
                listenable: ticks,
                builder: (context, _) => VhChapterRows(
                  chapters: chapters,
                  current: vhChapterAt(chapters, position()),
                  onSeek: (start) {
                    Navigator.of(sheet).pop();
                    onSeek(start);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
