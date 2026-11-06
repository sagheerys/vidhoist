/// What the person picked, before it becomes yt-dlp's `-f`.
///
/// A height is a ceiling, offered for every site and not YouTube alone: a
/// site that lists no heights refuses the selector, and the caller retries
/// once with [FormatChoice.best] (see `YtDlpError.retryAtBest`).
enum FormatChoice {
  best(null),
  h1080(1080),
  h720(720),
  h480(480),
  h360(360),
  audio(null);

  const FormatChoice(this.height);

  /// The height ceiling, or null for [best] and [audio].
  final int? height;

  bool get isAudio => this == FormatChoice.audio;
}

/// What an audio download is converted to.
enum AudioFormat {
  /// AAC in MP4: plays on every phone and in every desktop player.
  m4a('m4a'),

  /// Whatever the site sent (Opus on YouTube), with no conversion.
  original('best'),
  mp3('mp3');

  const AudioFormat(this.wire);

  /// The value of `--audio-format`.
  final String wire;
}

/// The `-f` selectors and the options that go with them.
///
/// Each selector below was checked against a real YouTube info JSON
/// (`test/fixtures/windows/probe-json.stdout.txt`) with
/// `yt-dlp --load-info-json … --simulate`; `docs/ENGINE.md` keeps the
/// picks. Changing one means checking it again the same way.
abstract final class FormatSelector {
  /// H.264 video in MP4 with AAC audio: what old phones, TVs and Windows'
  /// own player decode in hardware. AV1 and VP9 are what YouTube offers
  /// first, and they stutter or fail on those.
  static const _h264 = "[vcodec~='^(avc|h264)'][ext=mp4]";

  /// The `-f` value for [choice].
  ///
  /// With [compatible], H.264 comes first; if a video has no H.264 stream
  /// under the ceiling, the best stream under it comes instead, so the
  /// download never fails for the codec alone.
  static String selector(FormatChoice choice, {bool compatible = false}) {
    if (choice.isAudio) return 'ba/b';
    final h = choice.height;
    final cap = h == null ? '' : '[height<=$h]';
    final any = 'bv*$cap+ba/b$cap';
    if (!compatible) return any;
    return 'bv*$cap$_h264+ba[ext=m4a]/b$cap[ext=mp4]/$any';
  }

  /// `-f` and the options that go with it: video is merged into MP4, so the
  /// file name ends the same whatever streams were picked; audio is
  /// extracted and converted to [audioFormat].
  static List<String> args(
    FormatChoice choice, {
    bool compatible = false,
    AudioFormat audioFormat = AudioFormat.m4a,
  }) => [
    '-f',
    selector(choice, compatible: compatible),
    if (choice.isAudio) ...[
      '-x',
      '--audio-format',
      audioFormat.wire,
    ] else ...[
      '--merge-output-format',
      'mp4',
    ],
  ];
}
