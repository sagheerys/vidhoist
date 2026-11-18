import 'progress_parser.dart';
import 'progress_tracker.dart';

/// Folds ffmpeg's progress blocks for one stretch into a
/// [DownloadProgress]: how far into the stretch ffmpeg has written, out of
/// the stretch's [length].
///
/// Each block ends with `progress=`; the figures before it are kept until
/// then. ffmpeg's bytes are what it has written, and its speed a multiple
/// of playing speed, so the time left is the stretch left over that
/// multiple.
class ClipProgress {
  ClipProgress(this.length);

  final Duration length;

  Duration _at = Duration.zero;
  int _bytes = 0;
  double? _pace;
  double _fraction = 0;
  int? _written;
  var _pastEnd = false;

  /// Whether ffmpeg ended still behind the stretch's start: a start after
  /// the video's end, which it answers with a few broken seconds and a
  /// negative time rather than an error (measured 2026-11-18). A stretch
  /// that starts inside dips below zero only in its first blocks.
  bool get pastEnd => _pastEnd;

  /// The progress once [line] closes a block, otherwise null.
  DownloadProgress? add(FfmpegLine line) {
    switch (line.key) {
      case 'out_time_us':
        final us = _written = int.tryParse(line.value);
        if (us != null && us >= 0) _at = Duration(microseconds: us);
      case 'total_size':
        _bytes = int.tryParse(line.value) ?? _bytes;
      case 'speed':
        _pace = double.tryParse(line.value.replaceFirst('x', ''));
      case 'progress':
        if (line.value == 'end') _pastEnd = (_written ?? 0) < 0;
        final whole = length.inMicroseconds;
        final done = whole > 0 ? _at.inMicroseconds / whole : 0.0;
        _fraction = line.value == 'end' ? 1.0 : done.clamp(_fraction, 1.0);
        return _now();
    }
    return null;
  }

  /// The longest input ffmpeg opened, from the `Duration:` it writes on
  /// stderr: the only length a site that gives none still has.
  static Duration? inputLength(String stderr) {
    Duration? longest;
    for (final m in _duration.allMatches(stderr)) {
      final time = Duration(
        hours: int.parse(m[1]!),
        minutes: int.parse(m[2]!),
        milliseconds: (double.parse(m[3]!) * 1000).round(),
      );
      if (longest == null || time > longest) longest = time;
    }
    return longest;
  }

  static final _duration = RegExp(r'Duration: (\d+):(\d\d):(\d\d(?:\.\d+)?)');

  /// yt-dlp's own `finished`, once ffmpeg is done.
  DownloadProgress finished() {
    _fraction = 1;
    return _now();
  }

  DownloadProgress _now() {
    final left = (length - _at).inMilliseconds / 1000;
    final pace = _pace;
    return DownloadProgress(
      fraction: _fraction,
      downloadedBytes: _bytes,
      part: 1,
      eta: pace == null || pace <= 0 || left <= 0
          ? null
          : (left / pace).round(),
    );
  }
}
