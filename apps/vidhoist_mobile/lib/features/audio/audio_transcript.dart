import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_transcripts/vh_transcripts.dart';
import 'package:vh_ui/vh_ui.dart';

import '../player/caption_style.dart';
import '../player/transcript_pane.dart';
import '../player/transcript_sheet.dart';

/// Opens the transcript of [item], which [handler] is playing, following
/// along: the line being said is lit and kept in view, and a tap on any
/// line plays from there without leaving the music player.
Future<void> showPlayingTranscript(
  BuildContext context, {
  required VhAudioHandler handler,
  required PlaylistItem item,
  required Map<String, List<VhCaptionLine>> tracks,
  required ValueNotifier<String?> language,
}) => showTranscriptFrame(
  context,
  (_) => PlayingTranscript(
    handler: handler,
    clip: item.canonicalUrl,
    tracks: tracks,
    language: language,
  ),
);

/// The transcript pane fed the music player's time.
class PlayingTranscript extends StatefulWidget {
  const PlayingTranscript({
    super.key,
    required this.handler,
    required this.clip,
    required this.tracks,
    required this.language,
    this.closeWhenMoved = true,
  });

  final VhAudioHandler handler;

  /// The item whose lines these are.
  final String clip;
  final Map<String, List<VhCaptionLine>> tracks;
  final ValueNotifier<String?> language;

  /// A sheet closes itself when the queue moves on, rather than follow the
  /// next item's time with this one's words. A tablet's tab is rebuilt
  /// for the next item instead.
  final bool closeWhenMoved;

  @override
  State<PlayingTranscript> createState() => _PlayingTranscriptState();
}

class _PlayingTranscriptState extends State<PlayingTranscript> {
  late final _position = ValueNotifier(widget.handler.player.position);
  late final StreamSubscription<Duration> _ticks;
  StreamSubscription<String?>? _moves;

  @override
  void initState() {
    super.initState();
    _ticks = widget.handler.positionStream.listen((at) => _position.value = at);
    if (widget.closeWhenMoved) {
      _moves = widget.handler.currentKey.listen((key) {
        if (mounted && key != widget.clip) Navigator.of(context).maybePop();
      });
    }
  }

  @override
  void dispose() {
    unawaited(_ticks.cancel());
    unawaited(_moves?.cancel());
    _position.dispose();
    super.dispose();
  }

  void _seek(Duration to) {
    _position.value = to;
    unawaited(widget.handler.seek(to));
  }

  @override
  Widget build(BuildContext context) => TranscriptPane(
    tracks: widget.tracks,
    language: widget.language,
    position: _position,
    onSeek: _seek,
  );
}

/// **The line being said, under the music player's controls**, and the
/// one after it, on a phone tall enough to hold them. A tap opens the
/// whole transcript. A clip in two languages or more names the one shown,
/// and a tap on the name moves to the next: the same choice as the video's
/// subtitles, so every player follows it.
class TranscriptPeek extends StatelessWidget {
  const TranscriptPeek({
    super.key,
    required this.tracks,
    required this.language,
    required this.position,
    required this.onOpen,
    this.initial = Duration.zero,
  });

  final Map<String, List<VhCaptionLine>> tracks;
  final ValueNotifier<String?> language;
  final Stream<Duration> position;

  /// Where playback is as the peek appears, before [position] says.
  final Duration initial;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String?>(
    valueListenable: language,
    builder: (context, chosen, _) {
      final code = chosen != null && tracks.containsKey(chosen)
          ? chosen
          : tracks.keys.first;
      return _card(context, code, [
        for (final line in tracks[code]!)
          TranscriptSegment(start: line.start, end: line.end, text: line.text),
      ]);
    },
  );

  Widget _card(
    BuildContext context,
    String code,
    List<TranscriptSegment> lines,
  ) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final l10n = context.vhl;
    final corner = BorderRadius.circular(VhRadius.card);
    return Material(
      color: p.card,
      shape: RoundedRectangleBorder(
        borderRadius: corner,
        side: BorderSide(color: p.line, width: VhThemeX.of(context).hairline),
      ),
      child: InkWell(
        onTap: onOpen,
        borderRadius: corner,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            VhSpace.md,
            VhSpace.sm,
            VhSpace.md,
            VhSpace.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  VhIcon(VhIcons.transcript, size: 16, color: p.ink2),
                  const SizedBox(width: VhSpace.xs),
                  // The title and what sits beside it share the line and
                  // give way to each other on a small phone or a large font.
                  Expanded(
                    child: Text(
                      l10n.mobileTranscript,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelLarge!.copyWith(color: p.ink),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: tracks.length > 1
                          ? _switch(context, code)
                          : Text(
                              l10n.mobileTranscriptOpen,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: text.labelSmall!.copyWith(color: p.ink3),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: VhSpace.xs),
              StreamBuilder<Duration>(
                stream: position,
                initialData: initial,
                builder: (context, snapshot) =>
                    _lines(context, lines, snapshot.data ?? Duration.zero),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The language shown; a tap moves to the next one the clip has.
  Widget _switch(BuildContext context, String code) {
    final p = VhThemeX.of(context).palette;
    final codes = tracks.keys.toList();
    return Tooltip(
      message: context.vhl.subtitlesLanguage,
      child: TextButton.icon(
        onPressed: () =>
            language.value = codes[(codes.indexOf(code) + 1) % codes.length],
        style: TextButton.styleFrom(
          foregroundColor: p.ink2,
          visualDensity: VisualDensity.compact,
        ),
        icon: const VhIcon(VhIcons.swap, size: 16),
        label: Text(
          captionCode(code),
          maxLines: 1,
          style: Theme.of(context).textTheme.labelSmall!
              .copyWith(color: p.ink2),
        ),
      ),
    );
  }

  /// The line being said, lit, and the next one dimmer. Before the first
  /// line, the first two, unlit.
  Widget _lines(
    BuildContext context,
    List<TranscriptSegment> lines,
    Duration at,
  ) {
    final p = VhThemeX.of(context).palette;
    final style = Theme.of(context).textTheme.bodySmall!;
    final now = segmentAt(lines, at);
    final first = now ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final i in [first, first + 1])
          if (i < lines.length)
            Builder(
              builder: (context) {
                final words = lines[i].text.trim();
                final (direction, align) = vhForeignLine(context, words);
                return Text(
                  words,
                  textDirection: direction,
                  textAlign: align,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style.copyWith(
                    color: i == now ? p.ink : p.ink3,
                    fontWeight: i == now ? FontWeight.w500 : null,
                  ),
                );
              },
            ),
      ],
    );
  }
}
