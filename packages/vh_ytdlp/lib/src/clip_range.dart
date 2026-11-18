/// **A stretch of a video fetched alone** (`--download-sections`): from
/// [start] to [end], whole seconds.
///
/// Times are typed by hand, so the reading is forgiving: `90`, `1:30` and
/// `0:01:30` are the same, and Arabic-Indic digits read as the digits they
/// are.
class ClipRange {
  const ClipRange(this.start, this.end);

  final Duration start;
  final Duration end;

  /// The range typed as two times, or null unless both read and [end]
  /// comes after [start].
  static ClipRange? tryParse(String from, String to) {
    final start = parseTime(from);
    final end = parseTime(to);
    if (start == null || end == null || end <= start) return null;
    return ClipRange(start, end);
  }

  /// This stretch inside a video [length] long: the end brought back to
  /// the length, or null when it starts at the end or past it. yt-dlp
  /// handed a stretch past the end fails with only "Invalid argument"
  /// from ffmpeg.
  ClipRange? within(Duration length) {
    if (start >= length) return null;
    return end <= length ? this : ClipRange(start, length);
  }

  /// How long the stretch plays.
  Duration get length => end - start;

  /// `ss`, `m:ss` or `h:mm:ss`; past the first part, each part under 60.
  static Duration? parseTime(String text) {
    final parts = westernDigits(text.trim()).split(':');
    if (parts.length > 3) return null;
    var seconds = 0;
    for (final (i, part) in parts.indexed) {
      final n = RegExp(r'^\d{1,6}$').hasMatch(part) ? int.parse(part) : null;
      if (n == null || (i > 0 && n >= 60)) return null;
      seconds = seconds * 60 + n;
    }
    return Duration(seconds: seconds);
  }

  /// Arabic-Indic and Persian digits as `0`–`9`; the rest left as it is.
  static String westernDigits(String text) => text.replaceAllMapped(
    RegExp('[٠-٩۰-۹]'),
    (m) => '${m[0]!.codeUnitAt(0) & 0xF}',
  );

  /// What `--download-sections` takes: `*` marks a time range, not a
  /// chapter's name.
  String get section => '*${start.inSeconds}-${end.inSeconds}';

  /// Added to the file name, so a stretch never takes the whole video's
  /// name (yt-dlp would then call it downloaded) nor another stretch's.
  /// No colon: Windows refuses one in a name.
  String get fileTag => '${_tag(start)}-${_tag(end)}';

  /// As a person reads it: `2:00–5:30`.
  String get label => '${clock(start)}–${clock(end)}';

  /// How a pending download keeps it: `120-330`.
  String get wire => '${start.inSeconds}-${end.inSeconds}';

  static ClipRange? fromWire(String? wire) {
    final m = RegExp(r'^(\d+)-(\d+)$').firstMatch(wire ?? '');
    if (m == null) return null;
    final start = Duration(seconds: int.parse(m[1]!));
    final end = Duration(seconds: int.parse(m[2]!));
    return end > start ? ClipRange(start, end) : null;
  }

  /// [url] marked with the range as a media fragment (`#t=120,330`): the
  /// stretch's own key in the library, apart from the whole video's, and
  /// still a link to the video.
  String tagUrl(String url) => '$url#t=${start.inSeconds},${end.inSeconds}';

  /// `m:ss`, or `h:mm:ss` from an hour on.
  static String clock(Duration d) {
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    if (d.inHours == 0) return '${d.inMinutes}:$s';
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    return '${d.inHours}:$m:$s';
  }

  static String _tag(Duration d) {
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    final m = d.inMinutes % 60;
    return d.inHours == 0
        ? '${m}m${s}s'
        : '${d.inHours}h${m.toString().padLeft(2, '0')}m${s}s';
  }

  @override
  bool operator ==(Object other) =>
      other is ClipRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'ClipRange($wire)';
}
