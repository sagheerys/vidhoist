import 'package:flutter/material.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_transcripts/vh_transcripts.dart';
import 'package:vh_ui/vh_ui.dart';

/// One line of the side panel's transcript: its time and its words, lit
/// while it is being said, with the words the find bar found marked.
class TranscriptLine extends StatelessWidget {
  const TranscriptLine({
    super.key,
    required this.line,
    required this.current,
    required this.onTap,
    this.marks = const [],
    this.chosen,
  });

  final TranscriptSegment line;
  final bool current;
  final VoidCallback onTap;

  /// Ranges of the line's trimmed text the find bar found.
  final List<(int, int)> marks;

  /// The one of [marks] the find bar is on, if it is in this line.
  final (int, int)? chosen;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final corner = BorderRadius.circular(VhCorners.desktop.chip);
    final words = line.text.trim();
    final style = text.bodySmall?.copyWith(
      color: current ? p.ink : p.ink2,
      fontWeight: current ? FontWeight.w700 : null,
    );
    return Semantics(
      button: true,
      selected: current,
      child: InkWell(
        onTap: onTap,
        borderRadius: corner,
        child: AnimatedContainer(
          duration: vhMotionDuration(context, VhMotion.fast),
          padding: const EdgeInsets.symmetric(
            horizontal: VhSpace.sm,
            vertical: VhSpace.xs,
          ),
          decoration: BoxDecoration(
            color: current ? p.accentSoft : null,
            borderRadius: corner,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: VhSpace.xxl * 2,
                child: Text(
                  vhFormatDuration(line.start),
                  // Grey down the list, the accent only beside the line
                  // being heard, as in the reading room.
                  style: text.labelSmall?.tabular.copyWith(
                    color: current ? p.accentInk : p.ink3,
                    fontWeight: current ? FontWeight.w700 : null,
                  ),
                ),
              ),
              Expanded(
                // The words take their new colour and weight at the pace
                // the background does, so the line does not blink.
                child: AnimatedDefaultTextStyle(
                  duration: vhMotionDuration(context, VhMotion.fast),
                  style: style ?? const TextStyle(),
                  child: marks.isEmpty
                      ? Text(
                          words,
                          textDirection: vhTextDirectionOf(
                            words,
                            Directionality.of(context),
                          ),
                        )
                      : Text.rich(
                          TextSpan(children: _spans(words, p)),
                          textDirection: vhTextDirectionOf(
                            words,
                            Directionality.of(context),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> _spans(String words, VhPalette p) {
    final spans = <TextSpan>[];
    var at = 0;
    for (final mark in marks) {
      final (start, end) = mark;
      if (start < at || end > words.length) continue;
      if (start > at) spans.add(TextSpan(text: words.substring(at, start)));
      final on = mark == chosen;
      spans.add(
        TextSpan(
          text: words.substring(start, end),
          style: TextStyle(
            backgroundColor: on ? p.accent : p.accentSoft,
            color: on ? p.onAccent : null,
          ),
        ),
      );
      at = end;
    }
    if (at < words.length) spans.add(TextSpan(text: words.substring(at)));
    return spans;
  }
}
