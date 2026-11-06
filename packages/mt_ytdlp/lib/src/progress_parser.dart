import 'dart:convert';

import 'command_builder.dart';

/// One line of what a download command prints on stdout.
sealed class YtDlpLine {
  const YtDlpLine();

  /// Reads one stdout line of a [CommandBuilder.download] run.
  ///
  /// Never throws: a line it does not know, or a tagged line cut short,
  /// comes back as [OtherLine], so a yt-dlp that prints something new
  /// cannot stop a download.
  static YtDlpLine parse(String raw) {
    final line = raw.trimRight();
    if (_after(line, CommandBuilder.fileTag) case final path?) {
      return path.isEmpty ? OtherLine(line) : FileLine(path);
    }
    if (_after(line, CommandBuilder.partsTag) case final rest?) {
      return PartsLine.tryParse(rest) ?? OtherLine(line);
    }
    if (_after(line, CommandBuilder.postprocessTag) case final rest?) {
      final parts = rest.split(' ');
      if (parts.length < 2) return OtherLine(line);
      return PostprocessLine(parts[0], parts.sublist(1).join(' '));
    }
    if (_after(line, CommandBuilder.progressTag) case final rest?) {
      return ProgressLine.tryParse(rest) ?? OtherLine(line);
    }
    return OtherLine(line);
  }

  static String? _after(String line, String tag) =>
      line.startsWith('$tag ') ? line.substring(tag.length + 1).trim() : null;
}

/// How far one stream has come.
///
/// A video merged from two streams reports each in turn, so the
/// downloaded bytes start again from zero for the audio part;
/// `ProgressTracker` turns that into one figure for the whole download.
final class ProgressLine extends YtDlpLine {
  const ProgressLine({
    required this.status,
    this.downloaded,
    this.total,
    this.totalEstimate,
    this.speed,
    this.eta,
    this.fragmentIndex,
    this.fragmentCount,
    this.formatId,
    this.isSideFile = false,
  });

  /// `downloading`, `finished` or `error`.
  final String status;
  final int? downloaded;

  /// Known for a single stream; null for a fragmented one, which gives
  /// [totalEstimate] instead.
  final int? total;
  final int? totalEstimate;

  /// Bytes per second.
  final double? speed;

  /// Seconds.
  final int? eta;
  final int? fragmentIndex;
  final int? fragmentCount;

  /// The format being fetched, such as `399`; null for a subtitle file and
  /// on lines printed before the field existed.
  final String? formatId;

  /// A file beside the video, such as a subtitle: the line names no format.
  /// Not one of the parts yt-dlp announced, so it moves no progress.
  final bool isSideFile;

  bool get isFinished => status == 'finished';

  /// The stream's size, exact when yt-dlp knows it.
  int? get size => total ?? totalEstimate;

  /// From 0 to 1, or null while the size is unknown.
  double? get fraction {
    final size = this.size;
    final done = downloaded;
    if (isFinished) return 1;
    if (size == null || done == null || size <= 0) return null;
    return (done / size).clamp(0.0, 1.0);
  }

  /// The fields after the tag, as `CommandBuilder` orders them; yt-dlp
  /// writes `NA` for a field it does not know. Null when the status is
  /// missing or a field is not a number.
  static bool _none(String field) => field == 'NA' || field == 'None';

  static ProgressLine? tryParse(String fields) {
    final f = fields.split(' ').where((s) => s.isNotEmpty).toList();
    if (f.isEmpty || f.length > 9) return null;
    num? at(int i) {
      if (i >= f.length || f[i] == 'NA' || f[i] == 'None') return null;
      return num.tryParse(f[i]) ?? double.nan;
    }

    final values = [for (var i = 1; i < 8; i++) at(i)];
    if (values.any((v) => v != null && v.isNaN)) return null;
    int? whole(num? v) => v?.round();
    return ProgressLine(
      status: f[0],
      downloaded: whole(values[0]),
      total: whole(values[1]),
      totalEstimate: whole(values[2]),
      speed: values[3]?.toDouble(),
      eta: whole(values[4]),
      fragmentIndex: whole(values[5]),
      fragmentCount: whole(values[6]),
      formatId: f.length == 9 && !_none(f[8]) ? f[8] : null,
      isSideFile: f.length == 9 && _none(f[8]),
    );
  }
}

/// The size of each part yt-dlp picked, printed before the first byte.
final class PartsLine extends YtDlpLine {
  const PartsLine(this.sizes);

  /// One entry per stream, in download order; null where yt-dlp could not
  /// tell.
  final List<int?> sizes;

  /// `<whole size> <JSON list of part sizes>`; a single stream gives an
  /// empty list, and then the whole size is its size.
  static PartsLine? tryParse(String fields) {
    final space = fields.indexOf(' ');
    if (space < 0) return null;
    final whole = num.tryParse(fields.substring(0, space))?.round();
    final Object? parts;
    try {
      parts = jsonDecode(fields.substring(space + 1));
    } on FormatException {
      return null;
    }
    if (parts is! List) return null;
    if (parts.isEmpty) return PartsLine([whole]);
    return PartsLine([for (final p in parts) p is num ? p.round() : null]);
  }
}

/// A post-processor starting or finishing: merging the streams,
/// converting the audio, embedding the thumbnail.
final class PostprocessLine extends YtDlpLine {
  const PostprocessLine(this.status, this.postprocessor);

  /// `started`, `processing` or `finished`.
  final String status;

  /// yt-dlp's own name for it, such as `Merger` or `ExtractAudio`.
  final String postprocessor;

  bool get isMerge => postprocessor == 'Merger';
  bool get isAudioConversion => postprocessor == 'ExtractAudio';
}

/// The path of a finished file, after any merge or conversion: the file
/// the app records, rather than a name guessed from the template.
final class FileLine extends YtDlpLine {
  const FileLine(this.path);

  final String path;
}

/// Anything else yt-dlp printed.
final class OtherLine extends YtDlpLine {
  const OtherLine(this.text);

  final String text;
}
