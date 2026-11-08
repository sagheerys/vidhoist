import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import 'transcript_pane.dart';

/// Opens the transcript of the clip [session] is playing from the bottom,
/// over the lower part of the player, so the picture goes on above it.
/// A tap on a line plays from there; the sheet closes itself when the
/// clip changes, as its lines were the old clip's.
Future<void> showTranscriptSheet(
  BuildContext context, {
  required VhVideoSession session,
  required Map<String, List<VhCaptionLine>> tracks,
  required ValueNotifier<String?> language,
}) => showVhSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  // Lighter than a dialog's: the clip goes on behind it.
  barrierColor: Colors.black26,
  builder: (sheet) {
    // Above the keyboard while searching, the lines shrinking to make room
    // rather than the search field going under it.
    final keyboard = MediaQuery.viewInsetsOf(sheet).bottom;
    final room = MediaQuery.sizeOf(sheet).height - keyboard;
    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: SizedBox(
        height: math.min(MediaQuery.sizeOf(sheet).height * 0.62, room * 0.8),
        child: _SessionTranscript(
          session: session,
          tracks: tracks,
          language: language,
        ),
      ),
    );
  },
);

/// The pane, fed the session's position as it plays.
class _SessionTranscript extends StatefulWidget {
  const _SessionTranscript({
    required this.session,
    required this.tracks,
    required this.language,
  });

  final VhVideoSession session;
  final Map<String, List<VhCaptionLine>> tracks;
  final ValueNotifier<String?> language;

  @override
  State<_SessionTranscript> createState() => _SessionTranscriptState();
}

class _SessionTranscriptState extends State<_SessionTranscript> {
  late final _position = ValueNotifier(widget.session.position);
  late final String? _clip = widget.session.current?.canonicalUrl;

  /// The controller listened to; the session swaps it for each clip.
  ChangeNotifier? _controller;

  @override
  void initState() {
    super.initState();
    widget.session.addListener(_sessionChanged);
    _listenTo(widget.session.controller);
  }

  @override
  void dispose() {
    widget.session.removeListener(_sessionChanged);
    _controller?.removeListener(_tick);
    _position.dispose();
    super.dispose();
  }

  void _listenTo(ChangeNotifier? controller) {
    if (identical(controller, _controller)) return;
    _controller?.removeListener(_tick);
    _controller = controller?..addListener(_tick);
  }

  void _tick() => _position.value = widget.session.position;

  void _sessionChanged() {
    if (!mounted) return;
    if (widget.session.current?.canonicalUrl != _clip) {
      Navigator.of(context).maybePop();
      return;
    }
    _listenTo(widget.session.controller);
    _tick();
  }

  void _seek(Duration to) {
    _position.value = to;
    unawaited(widget.session.controller?.seekTo(to));
  }

  @override
  Widget build(BuildContext context) => TranscriptPane(
    tracks: widget.tracks,
    language: widget.language,
    position: _position,
    onSeek: _seek,
  );
}
