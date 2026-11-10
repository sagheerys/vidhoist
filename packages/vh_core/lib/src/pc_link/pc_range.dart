import 'dart:io';

/// One byte range of a file, both ends included, as HTTP counts them.
class PcByteRange {
  const PcByteRange(this.start, this.end);

  final int start;
  final int end;

  int get length => end - start + 1;

  /// The `Content-Range` of this range in a file of [total] bytes.
  String contentRange(int total) => 'bytes $start-$end/$total';

  @override
  bool operator ==(Object other) =>
      other is PcByteRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'PcByteRange($start-$end)';
}

/// What a `Range` header asks of a file of [length] bytes.
sealed class PcRangeRequest {
  const PcRangeRequest();
}

/// The whole file: no header, or one this server does not read (several
/// ranges, another unit). A player asks again with one it can.
final class PcWholeFile extends PcRangeRequest {
  const PcWholeFile();
}

final class PcPartOfFile extends PcRangeRequest {
  const PcPartOfFile(this.range);

  final PcByteRange range;
}

/// A range that starts past the end: answered 416.
final class PcRangeUnsatisfiable extends PcRangeRequest {
  const PcRangeUnsatisfiable();
}

/// Reads a `Range` header: `bytes=500-999`, `bytes=500-` (to the end) or
/// `bytes=-500` (the last 500). A seek in a video is one such request, so
/// a player can start anywhere without fetching what lies before.
PcRangeRequest pcRangeOf(String? header, int length) {
  final value = header?.trim() ?? '';
  final match = RegExp(r'^bytes=(\d*)-(\d*)$').firstMatch(value);
  if (match == null) return const PcWholeFile();
  final from = match[1]!, to = match[2]!;
  if (from.isEmpty && to.isEmpty) return const PcWholeFile();
  if (from.isEmpty) {
    // The last n bytes; more than the file holds is the whole file.
    final n = int.tryParse(to);
    if (n == null || n == 0 || length == 0) return const PcRangeUnsatisfiable();
    final start = n >= length ? 0 : length - n;
    return PcPartOfFile(PcByteRange(start, length - 1));
  }
  final start = int.tryParse(from);
  if (start == null || start >= length) return const PcRangeUnsatisfiable();
  final asked = to.isEmpty ? null : int.tryParse(to);
  if (to.isNotEmpty && (asked == null || asked < start)) {
    return const PcWholeFile();
  }
  final end = asked == null || asked >= length ? length - 1 : asked;
  return PcPartOfFile(PcByteRange(start, end));
}

/// The media type a player is told for a file, by its extension.
String pcMediaType(String extension) => switch (extension.toLowerCase()) {
  'mp4' || 'm4v' => 'video/mp4',
  'webm' => 'video/webm',
  'mkv' => 'video/x-matroska',
  'mov' => 'video/quicktime',
  '3gp' => 'video/3gpp',
  'avi' => 'video/x-msvideo',
  'mp3' => 'audio/mpeg',
  'm4a' => 'audio/mp4',
  'aac' => 'audio/aac',
  'ogg' || 'opus' => 'audio/ogg',
  'wav' => 'audio/wav',
  'flac' => 'audio/flac',
  _ => 'application/octet-stream',
};

/// Sends [file], whole or the range [request] asks for: a player seeking in
/// a video asks for the bytes from there on, not the whole file again.
Future<void> servePcFile(
  File file,
  HttpRequest request,
  HttpResponse response,
) async {
  final length = await file.length();
  response.headers
    ..set(HttpHeaders.acceptRangesHeader, 'bytes')
    ..set(
      HttpHeaders.contentTypeHeader,
      pcMediaType(file.path.split('.').last),
    );
  final PcByteRange? part;
  switch (pcRangeOf(request.headers.value(HttpHeaders.rangeHeader), length)) {
    case PcRangeUnsatisfiable():
      response
        ..statusCode = HttpStatus.requestedRangeNotSatisfiable
        ..headers.set(HttpHeaders.contentRangeHeader, 'bytes */$length');
      return;
    case PcWholeFile():
      part = null;
      response.contentLength = length;
    case PcPartOfFile(:final range):
      part = range;
      response
        ..statusCode = HttpStatus.partialContent
        ..contentLength = range.length
        ..headers.set(
          HttpHeaders.contentRangeHeader,
          range.contentRange(length),
        );
  }
  if (request.method == 'HEAD') return;
  try {
    await response.addStream(
      part == null ? file.openRead() : file.openRead(part.start, part.end + 1),
    );
  } on IOException {
    // A player drops the connection on every seek and asks again from the
    // new place: routine, not a failure to log.
  }
}
