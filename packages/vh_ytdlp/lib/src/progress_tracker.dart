import 'progress_parser.dart';

/// Where a whole download stands, its parts taken together.
class DownloadProgress {
  const DownloadProgress({
    required this.fraction,
    required this.downloadedBytes,
    required this.part,
    this.totalBytes,
    this.speed,
    this.eta,
  });

  /// From 0 to 1; never goes back during one download.
  final double fraction;

  /// Bytes received across all parts.
  final int downloadedBytes;

  /// All parts' size, when every part's size is known.
  final int? totalBytes;

  /// The part being downloaded, from 1.
  final int part;

  /// Bytes per second of the current part.
  final double? speed;

  /// Seconds left of the current part.
  final int? eta;
}

/// Folds the lines of one download into one [DownloadProgress].
///
/// yt-dlp reports each stream on its own: a merged video is the picture
/// first, then the sound, each counted from zero. Weighted by the parts'
/// sizes (a [PartsLine], printed before the first byte) the bar moves with
/// the bytes; without them each part counts the same. A part that was not
/// expected widens the count instead of sending the bar back.
class ProgressTracker {
  ProgressTracker({List<int?> partSizes = const []})
    : _sizes = List.of(partSizes);

  List<int?> _sizes;

  /// Takes the sizes yt-dlp announced; a [ProgressLine] that brings an
  /// exact size later still wins for its own part.
  void expectParts(PartsLine parts) {
    _sizes = [
      for (var i = 0; i < parts.sizes.length; i++)
        i < _sizes.length && i < _part ? _sizes[i] : parts.sizes[i],
    ];
  }

  int _part = 0;
  int _finishedBytes = 0;
  int _lastDownloaded = 0;
  bool _partOpen = false;
  double _fraction = 0;

  /// The progress after [line]. Each `finished` closes one part: yt-dlp
  /// prints one per stream, and a stream already on disk prints that
  /// alone.
  DownloadProgress add(ProgressLine line) {
    final downloaded = line.downloaded ?? 0;
    // Counting from zero again without a `finished` between: a new part.
    if (_partOpen && downloaded < _lastDownloaded) _close(_lastDownloaded);
    _partOpen = true;
    _lastDownloaded = downloaded;
    if (_sizes.length <= _part) _sizes.add(line.size);
    // The stream's own figure is exact where the announced one was
    // approximate.
    if (line.total case final exact?) _sizes[_part] = exact;
    _sizes[_part] ??= line.size;

    final current = line.fraction ?? 0;
    final parts = _sizes.length;
    final known = _sizes.every((s) => s != null && s > 0);
    final total = known ? _sizes.fold<int>(0, (a, s) => a + s!) : null;
    final whole = total != null
        ? (_finishedBytes + downloaded) / total
        : (_part + current) / parts;
    _fraction = whole.clamp(_fraction, 1.0);

    final progress = DownloadProgress(
      fraction: _fraction,
      downloadedBytes: _finishedBytes + downloaded,
      totalBytes: total,
      part: _part + 1,
      speed: line.speed,
      eta: line.eta,
    );
    if (line.isFinished) _close(line.size ?? downloaded);
    return progress;
  }

  void _close(int bytes) {
    _finishedBytes += bytes;
    _part++;
    _partOpen = false;
    _lastDownloaded = 0;
  }
}
