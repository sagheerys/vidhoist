import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_media/vh_media.dart' show vhFormatDuration;
import 'package:vh_transcripts/vh_transcripts.dart' show SearchText;
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../downloads_library/local_item.dart';
import '../player/playback_providers.dart';

/// [text] with every word of [query] lit in the action colour, wherever the
/// subtitles spelled it differently from how it was typed.
class HighlightedText extends StatelessWidget {
  const HighlightedText(
    this.text, {
    super.key,
    required this.query,
    required this.style,
    this.maxLines,
  });

  final String text;
  final String query;
  final TextStyle style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final lit = style.copyWith(
      color: p.accentInk,
      backgroundColor: p.accentSoft,
      fontWeight: FontWeight.w700,
    );
    final spans = <TextSpan>[];
    var at = 0;
    for (final (start, end) in SearchText.matchRanges(text, query)) {
      if (start > at) spans.add(TextSpan(text: text.substring(at, start)));
      spans.add(TextSpan(text: text.substring(start, end), style: lit));
      at = end;
    }
    if (at < text.length) spans.add(TextSpan(text: text.substring(at)));
    final (direction, align) = vhForeignLine(context, text);
    return Text.rich(
      TextSpan(style: style, children: spans),
      textDirection: direction,
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    );
  }
}

/// One moment of a clip: when it was said, and what. Tapping it plays the
/// clip from that second.
class SaidMomentRow extends ConsumerWidget {
  const SaidMomentRow({
    super.key,
    required this.item,
    required this.start,
    required this.text,
    required this.query,
    this.next,
  });

  final LocalItem item;
  final Duration start;
  final String text;
  final String query;

  /// The line after, dimmer, so the moment can be judged in place.
  final String? next;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = VhThemeX.of(context).palette;
    final body = Theme.of(context).textTheme.bodySmall!.copyWith(color: p.ink2);
    return InkWell(
      onTap: () => playFromMoment(context, ref.read, item, start),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: VhSpace.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A time reads left to right in either language.
            Text(
              vhLtrRun(vhFormatDuration(start)),
              style: body
                  .copyWith(color: p.accent, fontWeight: FontWeight.w700)
                  .tabular,
            ),
            const SizedBox(width: VhSpace.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HighlightedText(text, query: query, style: body, maxLines: 2),
                  // Lit too: a phrase the captions split ends on this line.
                  if (next case final after?)
                    HighlightedText(
                      after,
                      query: query,
                      maxLines: 1,
                      style: body.copyWith(color: p.ink3),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Plays [item] from [start]: the moment the words were said.
///
/// Video goes through the saved position, which the video player already
/// resumes from on open, so no second way of starting mid-clip is added.
/// Audio seeks once loaded, because the audio player resumes only long
/// items on its own.
Future<void> playFromMoment(
  BuildContext context,
  T Function<T>(ProviderListenable<T> provider) read,
  LocalItem item,
  Duration start,
) async {
  final entry = toPlaylistItem(item);
  if (item.isAudio) {
    final handler = read(audioHandlerProvider);
    await handler.playItems([entry], startIndex: 0);
    await handler.seek(start);
    return;
  }
  // A moment in the first seconds clears any older position instead, so
  // the clip starts from the top rather than where it was last left.
  await read(playbackPositionsProvider).save(item.key, start);
  read(playbackRequestProvider.notifier).state = PlaybackRequest(
    items: [entry],
    startIndex: 0,
  );
  if (context.mounted) await context.push('/player');
}
