/// A yt-dlp release, such as `2026.10.26`; nightly builds add a fourth
/// number (`2026.10.27.232`).
///
/// The date is what matters: YouTube changes often enough that a build a
/// few months old stops working, so the app tells the person when theirs
/// is getting old (the Android library shipped one a year old,
/// `docs/ENGINE.md`, finding 12).
class EngineVersion implements Comparable<EngineVersion> {
  const EngineVersion(this.year, this.month, this.day, [this.build = 0]);

  final int year;
  final int month;
  final int day;
  final int build;

  static final _pattern = RegExp(r'(\d{4})\.(\d{1,2})\.(\d{1,2})(?:\.(\d+))?');

  /// The first version in [text] (`yt-dlp --version` prints it alone), or
  /// null when there is none.
  static EngineVersion? tryParse(String? text) {
    final m = _pattern.firstMatch(text ?? '');
    if (m == null) return null;
    final v = EngineVersion(
      int.parse(m.group(1)!),
      int.parse(m.group(2)!),
      int.parse(m.group(3)!),
      int.parse(m.group(4) ?? '0'),
    );
    return (v.month >= 1 && v.month <= 12 && v.day >= 1 && v.day <= 31)
        ? v
        : null;
  }

  DateTime get date => DateTime.utc(year, month, day);

  /// Days between the release and [now].
  int ageInDays(DateTime now) => now.toUtc().difference(date).inDays;

  /// Whether it is older than [days] at [now]; 90 by default, after which
  /// YouTube downloads have usually broken at least once.
  bool isStale(DateTime now, {int days = 90}) => ageInDays(now) > days;

  @override
  int compareTo(EngineVersion other) => _key.compareTo(other._key);

  int get _key => ((year * 100 + month) * 100 + day) * 100000 + build;

  bool operator <(EngineVersion other) => compareTo(other) < 0;

  @override
  bool operator ==(Object other) =>
      other is EngineVersion && other._key == _key;

  @override
  int get hashCode => _key.hashCode;

  @override
  String toString() {
    String two(int n) => n.toString().padLeft(2, '0');
    final base = '$year.${two(month)}.${two(day)}';
    return build == 0 ? base : '$base.$build';
  }
}

/// The version a helper prints first, such as `7.1.1` from
/// `ffmpeg version 7.1.1 …` or `2.9.8` from `deno 2.9.8 …`; null when
/// there is none.
String? toolVersion(String? output) =>
    RegExp(r'\b(\d+\.\d+(?:\.\d+)?)').firstMatch(output ?? '')?.group(1);
