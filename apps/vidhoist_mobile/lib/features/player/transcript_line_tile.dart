import 'package:flutter/material.dart';
import 'package:mt_media/mt_media.dart';
import 'package:mt_ui/mt_ui.dart';

/// One line of the transcript: its time and its words, lit while it is
/// being said, with what the search found marked and the result it is on
/// marked strongest.
class TranscriptLineTile extends StatelessWidget {
  const TranscriptLineTile({
    super.key,
    required this.start,
    required this.text,
    required this.current,
    required this.onTap,
    this.marks = const [],
    this.chosen,
  });

  final Duration start;
  final String text;
  final bool current;
  final VoidCallback onTap;

  /// Ranges of [text] the search found.
  final List<(int, int)> marks;

  /// The one of [marks] the search is on, if it is in this line.
  final (int, int)? chosen;

  @override
  Widget build(BuildContext context) {
    final p = MTThemeX.of(context).palette;
    final theme = Theme.of(context).textTheme;
    final corner = BorderRadius.circular(MTRadius.field);
    final direction = mtTextDirectionOf(text, Directionality.of(context));
    return Semantics(
      button: true,
      selected: current,
      child: InkWell(
        onTap: onTap,
        borderRadius: corner,
        child: AnimatedContainer(
          duration: mtMotionDuration(context, MTMotion.fast),
          // The row is at least a finger high.
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(
            horizontal: MTSpace.sm,
            vertical: MTSpace.sm,
          ),
          decoration: BoxDecoration(
            color: current ? p.accentSoft : null,
            borderRadius: corner,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: MTSpace.md),
                child: Text(
                  mtFormatDuration(start),
                  style: theme.labelSmall?.tabular.copyWith(
                    color: current ? p.accentInk : p.ink3,
                    fontWeight: current ? FontWeight.w700 : null,
                    height: 1.9,
                  ),
                ),
              ),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: mtMotionDuration(context, MTMotion.fast),
                  style: (theme.bodyMedium ?? const TextStyle()).copyWith(
                    color: current ? p.ink : p.ink2,
                    fontWeight: current ? FontWeight.w600 : null,
                  ),
                  child: marks.isEmpty
                      ? Text(text, textDirection: direction)
                      : Text.rich(
                          TextSpan(children: _spans(p)),
                          textDirection: direction,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> _spans(MTPalette p) {
    final spans = <TextSpan>[];
    var at = 0;
    for (final mark in marks) {
      final (from, to) = mark;
      if (from < at || to > text.length) continue;
      if (from > at) spans.add(TextSpan(text: text.substring(at, from)));
      final on = mark == chosen;
      spans.add(
        TextSpan(
          text: text.substring(from, to),
          style: TextStyle(
            backgroundColor: on ? p.accent : p.accentSoft,
            color: on ? p.onAccent : null,
          ),
        ),
      );
      at = to;
    }
    if (at < text.length) spans.add(TextSpan(text: text.substring(at)));
    return spans;
  }
}
