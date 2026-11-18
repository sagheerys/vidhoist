import 'dart:async';

import '../backend/download_backend.dart';

/// **One link read before it is submitted**: the add screen asks a
/// video's length so a stretch cannot be typed past its end, and the
/// download that follows starts from that same reading rather than asking
/// yt-dlp twice (on a phone a probe is several seconds).
///
/// One link at a time, as the add screen shows one; the reading is let go
/// after [keep], since its media links expire after some hours.
class EarlyProbe {
  EarlyProbe(
    this._probe, {
    this.keep = const Duration(minutes: 30),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final Future<ProbeResult> Function(String url) _probe;
  final Duration keep;
  final DateTime Function() _clock;

  ({String url, Future<ProbeResult> result, DateTime at})? _slot;

  /// The reading of [url], made now or earlier; a failed one is not kept.
  Future<ProbeResult> read(String url) {
    if (_fresh(url) case final slot?) return slot.result;
    final result = _probe(url);
    final slot = (url: url, result: result, at: _clock());
    _slot = slot;
    unawaited(
      result.then<void>(
        (_) {},
        onError: (Object _) {
          if (identical(_slot, slot)) _slot = null;
        },
      ),
    );
    return result;
  }

  /// The reading of [url] for its download, once, or null when there is
  /// none; if it fails, the download reads the link again itself.
  Future<ProbeResult>? take(String url) {
    final slot = _fresh(url);
    if (slot == null) return null;
    _slot = null;
    return slot.result.catchError((Object _) => _probe(url));
  }

  ({String url, Future<ProbeResult> result, DateTime at})? _fresh(String url) {
    final slot = _slot;
    if (slot == null || slot.url != url) return null;
    return _clock().difference(slot.at) < keep ? slot : null;
  }
}
