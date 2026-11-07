import 'dart:async';

import 'local_channels.dart';

/// Checks the followed channels when they are due, for as long as the app
/// runs: a while after it starts, for what came while it was closed, then
/// every [every] for the channels whose interval has run out.
///
/// Nothing runs while the app is closed (decided 2026-11-07): no task in
/// the system's scheduler, no yt-dlp behind its owner's back. Missing a
/// check costs nothing, since the clips stay on the channel and the next
/// check finds them.
class ChannelTicker {
  ChannelTicker({
    required this.source,
    this.onChecked,
    this.onError,
    this.first = const Duration(seconds: 30),
    this.every = const Duration(minutes: 1),
  });

  final LocalChannelSource source;

  /// After a check that looked at something, so the page and the library
  /// read again.
  final void Function()? onChecked;
  final void Function(Object error)? onError;

  /// Not at once: the app's first seconds belong to its window and to the
  /// downloads the last run left unfinished.
  final Duration first;
  final Duration every;

  Timer? _first;
  Timer? _every;

  void start() {
    stop();
    _first = Timer(first, () => unawaited(tick()));
    _every = Timer.periodic(every, (_) => unawaited(tick()));
  }

  void stop() {
    _first?.cancel();
    _every?.cancel();
    _first = _every = null;
  }

  /// Checks what is due. A tick that comes during a slow check finds
  /// nothing due: a check marks its channel checked before reading it.
  Future<void> tick() async {
    try {
      final due = await source.due();
      if (due.isEmpty) return;
      await source.check(ids: due);
      onChecked?.call();
    } on Object catch (e) {
      onError?.call(e);
    }
  }
}
