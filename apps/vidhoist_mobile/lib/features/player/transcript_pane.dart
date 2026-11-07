import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mt_media/mt_media.dart';
import 'package:mt_transcripts/mt_transcripts.dart';
import 'package:mt_ui/mt_ui.dart';

import 'caption_style.dart';
import 'transcript_line_tile.dart';

export 'transcript_line_tile.dart';

/// The clip's subtitles read as a transcript: every line with its time,
/// the one being said lit and kept in view, a search that folds Arabic
/// (a word typed without hamza finds it written with one), and a tap that
/// plays from a line. Two languages or more get a switch, which is the
/// player's own choice of language.
class TranscriptPane extends StatefulWidget {
  const TranscriptPane({
    super.key,
    required this.tracks,
    required this.language,
    required this.position,
    required this.onSeek,
  });

  /// Every language the clip has, by code, the reader's first.
  final Map<String, List<MTCaptionLine>> tracks;
  final ValueNotifier<String?> language;
  final ValueListenable<Duration> position;
  final ValueChanged<Duration> onSeek;

  @override
  State<TranscriptPane> createState() => _TranscriptPaneState();
}

class _TranscriptPaneState extends State<TranscriptPane> {
  final _current = GlobalKey();
  final _found = GlobalKey();
  final _query = TextEditingController();

  late String _code;
  late List<TranscriptSegment> _segments;
  int? _now;
  List<FindHit> _hits = const [];
  var _hit = 0;

  /// When the reader last scrolled by hand. Following waits a moment
  /// after it, so reading back up is not pulled down to the line being
  /// said (as on Windows).
  DateTime _scrolledByHand = DateTime.fromMillisecondsSinceEpoch(0);
  static const _handPause = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _take();
    widget.position.addListener(_follow);
    widget.language.addListener(_switched);
  }

  @override
  void dispose() {
    widget.position.removeListener(_follow);
    widget.language.removeListener(_switched);
    _query.dispose();
    super.dispose();
  }

  /// The language on screen, the player's choice when the clip has it.
  void _take() {
    final chosen = widget.language.value;
    _code = chosen != null && widget.tracks.containsKey(chosen)
        ? chosen
        : widget.tracks.keys.first;
    _segments = [
      for (final line in widget.tracks[_code]!)
        TranscriptSegment(start: line.start, end: line.end, text: line.text),
    ];
    _now = segmentAt(_segments, widget.position.value);
    _hits = findIn(_segments, _query.text);
    _hit = 0;
  }

  void _switched() => setState(_take);

  void _follow() {
    final now = segmentAt(_segments, widget.position.value);
    if (now == _now || !mounted) return;
    setState(() => _now = now);
    if (_query.text.trim().isNotEmpty ||
        DateTime.now().difference(_scrolledByHand) < _handPause) {
      return;
    }
    _reveal(_current, animate: true);
  }

  void _search(String _) {
    setState(() {
      _hits = findIn(_segments, _query.text);
      _hit = 0;
    });
    _reveal(_found);
  }

  void _step(int by) {
    if (_hits.isEmpty) return;
    setState(() => _hit = (_hit + by) % _hits.length);
    _reveal(_found);
  }

  void _reveal(GlobalKey key, {bool animate = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = key.currentContext;
      if (target == null || !target.mounted) return;
      unawaited(
        Scrollable.ensureVisible(
          target,
          alignment: 0.3,
          duration: animate
              ? mtMotionDuration(context, MTMotion.medium)
              : Duration.zero,
          curve: MTMotion.ease,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chosen = _hits.isEmpty ? null : _hits[_hit];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(context),
        _searchField(context),
        _underSearch(context),
        const SizedBox(height: MTSpace.xs),
        Expanded(
          child: NotificationListener<UserScrollNotification>(
            onNotification: (n) {
              if (n.direction != ScrollDirection.idle) {
                _scrolledByHand = DateTime.now();
              }
              return false;
            },
            // A column, not a lazy list, so the line being said always has
            // a place to scroll to; a transcript is a few hundred lines.
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                MTSpace.sm,
                0,
                MTSpace.sm,
                MTSpace.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (i, line) in _segments.indexed)
                    TranscriptLineTile(
                      key: chosen?.line == i
                          ? _found
                          : (i == _now ? _current : null),
                      start: line.start,
                      text: line.text.trim(),
                      current: i == _now,
                      marks: [
                        for (final h in _hits)
                          if (h.line == i) (h.start, h.end),
                      ],
                      chosen: chosen?.line == i
                          ? (chosen!.start, chosen.end)
                          : null,
                      onTap: () => widget.onSeek(line.start),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// The title, and the languages when there are several.
  Widget _header(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: MTSpace.lg),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: MTSpace.sm,
      runSpacing: MTSpace.xs,
      children: [
        Text(
          context.mtl.mobileTranscript,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (widget.tracks.length > 1)
          CaptionChoiceChips(
            labels: [for (final code in widget.tracks.keys) captionCode(code)],
            chosen: widget.tracks.keys.toList().indexOf(_code),
            onChosen: (i) =>
                widget.language.value = widget.tracks.keys.elementAt(i),
          ),
      ],
    ),
  );

  Widget _searchField(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(MTSpace.lg, MTSpace.sm, MTSpace.lg, 0),
    child: TextField(
      controller: _query,
      onChanged: _search,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: context.mtl.desktopReadingFind,
        prefixIcon: const Padding(
          padding: EdgeInsets.all(MTSpace.sm),
          child: MTIcon(MTIcons.search),
        ),
        isDense: true,
      ),
    ),
  );

  /// While searching: where the search is and the steps between results.
  /// Otherwise: what a tap on a line does.
  Widget _underSearch(BuildContext context) {
    final l10n = context.mtl;
    final p = MTThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    if (_query.text.trim().isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          MTSpace.lg,
          MTSpace.xs,
          MTSpace.lg,
          0,
        ),
        child: Text(
          l10n.mobileTranscriptHint,
          style: text.labelSmall?.copyWith(color: p.ink3),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MTSpace.md),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: MTSpace.sm),
              child: Text(
                _hits.isEmpty
                    ? l10n.noResults
                    : l10n.desktopReadingFound(_hit + 1, _hits.length),
                style: text.labelMedium?.copyWith(color: p.ink2),
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.desktopReadingPreviousMatch,
            onPressed: _hits.isEmpty ? null : () => _step(-1),
            icon: const MTIcon(MTIcons.chevronUp),
          ),
          IconButton(
            tooltip: l10n.desktopReadingNextMatch,
            onPressed: _hits.isEmpty ? null : () => _step(1),
            icon: const MTIcon(MTIcons.chevronDown),
          ),
        ],
      ),
    );
  }
}
