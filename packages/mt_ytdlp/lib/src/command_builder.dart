import 'format_selector.dart';

/// Which app the command is for: the two differ in file names and in what
/// the engine around yt-dlp already adds.
enum HostPlatform { windows, android }

/// What surrounds yt-dlp on this machine, the same for every command.
class EngineSetup {
  const EngineSetup({
    required this.platform,
    this.ffmpegDir,
    this.jsRuntime,
    this.forceIpv4 = true,
    this.cookiesFile,
  });

  final HostPlatform platform;

  /// The folder holding `ffmpeg` and `ffprobe`; null where yt-dlp finds
  /// them itself (the Android library sets this up).
  final String? ffmpegDir;

  /// `<name>:<path>` for `--js-runtimes`, such as `deno:C:\…\deno.exe`.
  /// Null on Android, where the library passes QuickJS on every request.
  final String? jsRuntime;

  /// `-4`: a network with a broken IPv6 route stalls every download by
  /// about 20 s, then crawls (`docs/ENGINE.md`, findings 7 and 20). Off
  /// only for networks that have IPv6 alone.
  final bool forceIpv4;

  /// A Netscape cookies file, for sites that need a signed-in session.
  final String? cookiesFile;
}

/// One download, from a link or from an info JSON a probe already wrote.
class DownloadSpec {
  const DownloadSpec({
    this.url,
    this.infoJsonPath,
    required this.folder,
    this.choice = FormatChoice.best,
    this.compatible = false,
    this.audioFormat = AudioFormat.m4a,
    this.nameTemplate = defaultNameTemplate,
    this.subtitleLanguages = const [],
    this.writeInfoJson = true,
    this.writeThumbnail = true,
    this.playlistItems,
    this.rateLimit,
  }) : assert(
         (url == null) != (infoJsonPath == null),
         'a download starts from a link or from an info JSON, not both',
       );

  /// The title cut to 80 bytes, so the path stays inside Windows' limit
  /// with room for the folder, and the video id, so two videos with one
  /// title never overwrite each other.
  static const defaultNameTemplate = '%(title).80B [%(id)s].%(ext)s';

  final String? url;

  /// A probe's info JSON: the download starts within seconds instead of
  /// solving YouTube's challenge again (about 50 s on a phone).
  final String? infoJsonPath;

  final String folder;
  final FormatChoice choice;
  final bool compatible;
  final AudioFormat audioFormat;
  final String nameTemplate;

  /// Patterns for `--sub-langs`, such as `ar.*`; empty fetches none.
  final List<String> subtitleLanguages;

  final bool writeInfoJson;
  final bool writeThumbnail;

  /// The 1-based items of a playlist to fetch; null keeps a link to one
  /// video from growing into its whole playlist or channel.
  final List<int>? playlistItems;

  /// `-r`, such as `2M`.
  final String? rateLimit;
}

/// The argument lists handed to yt-dlp, the executable itself left out.
///
/// Order matters (the link goes last, after `--`), so the Android side
/// passes the list whole with `YoutubeDLRequest.addCommands`: the
/// library's `addOption` groups options by name and reorders them
/// (`docs/ENGINE.md`, finding 21).
abstract final class CommandBuilder {
  /// Starts each progress line, followed by the fields of
  /// [_progressFields] separated by spaces.
  static const progressTag = '[vh]';

  /// Starts each post-processing line: status, then the post-processor.
  static const postprocessTag = '[vh-pp]';

  /// Starts the line naming each finished file, after any merge or
  /// conversion.
  static const fileTag = '[vh-file]';

  /// Starts the line, printed once the formats are picked, giving the
  /// whole size and then each part's size as a JSON list (empty when one
  /// stream was picked), so the progress can be weighted by bytes.
  static const partsTag = '[vh-parts]';

  static const _progressFields = [
    'status',
    'downloaded_bytes',
    'total_bytes',
    'total_bytes_estimate',
    'speed',
    'eta',
    'fragment_index',
    'fragment_count',
  ];

  static String get _progressTemplate =>
      'download:$progressTag ${_progressFields.map((f) => '%(progress.$f)s').join(' ')}';

  static const _postprocessTemplate =
      'postprocess:$postprocessTag %(progress.status)s %(progress.postprocessor)s';

  /// What every command starts with: no config file of the user's own can
  /// change what the app expects to read back.
  static List<String> _base(EngineSetup setup) => [
    '--ignore-config',
    '--no-colors',
    if (setup.forceIpv4) '-4',
    if (setup.ffmpegDir case final dir?) ...['--ffmpeg-location', dir],
    if (setup.jsRuntime case final runtime?) ...['--js-runtimes', runtime],
    if (setup.cookiesFile case final cookies?) ...['--cookies', cookies],
  ];

  /// Downloads [spec]. Progress comes as [progressTag] and
  /// [postprocessTag] lines, the final file as a [fileTag] line.
  ///
  /// `--print` alone would silence the progress, so `--progress` brings it
  /// back (`docs/ENGINE.md`, "The command line that works").
  static List<String> download(DownloadSpec spec, EngineSetup setup) => [
    ..._base(setup),
    '--newline',
    '--progress',
    '--progress-template',
    _progressTemplate,
    '--progress-template',
    _postprocessTemplate,
    '--print',
    'video:$partsTag %(filesize_approx)s %(requested_formats.:.filesize_approx)j',
    '--print',
    'after_move:$fileTag %(filepath)s',
    '--continue',
    '--no-overwrites',
    '-P',
    spec.folder,
    '-o',
    spec.nameTemplate,
    if (setup.platform == HostPlatform.windows) '--windows-filenames',
    ...FormatSelector.args(
      spec.choice,
      compatible: spec.compatible,
      audioFormat: spec.audioFormat,
    ),
    if (spec.writeInfoJson) '--write-info-json',
    if (spec.writeThumbnail) ...[
      '--write-thumbnail',
      '--convert-thumbnails',
      'jpg',
    ],
    if (spec.subtitleLanguages.isNotEmpty) ...[
      '--write-subs',
      '--write-auto-subs',
      '--sub-langs',
      spec.subtitleLanguages.join(','),
      '--sub-format',
      'vtt/srt/best',
      // A refused subtitle track must not fail the video it belongs to.
      '--ignore-errors',
    ],
    if (spec.rateLimit case final rate?) ...['-r', rate],
    if (spec.playlistItems case final items?) ...[
      '--yes-playlist',
      '--playlist-items',
      items.join(','),
    ] else
      '--no-playlist',
    if (spec.infoJsonPath case final info?) ...['--load-info-json', info],
    // "--" keeps a link that starts with "-" from being read as an option.
    if (spec.url case final url?) ...['--', url],
  ];

  /// Reads what [url] offers without downloading it: the info JSON comes
  /// on stdout. The app keeps it and downloads from it later
  /// ([DownloadSpec.infoJsonPath]), so YouTube's challenge is solved once.
  static List<String> probe(String url, EngineSetup setup) => [
    ..._base(setup),
    '-J',
    '--no-playlist',
    '--',
    url,
  ];

  /// Lists a playlist or a channel without reading each video: one JSON
  /// on stdout, its `entries` holding the id, link and title of each.
  static List<String> playlist(String url, EngineSetup setup, {int? limit}) => [
    ..._base(setup),
    '-J',
    '--flat-playlist',
    if (limit case final n?) ...['--playlist-end', '$n'],
    '--',
    url,
  ];

  /// Prints the version alone, such as `2026.10.26`.
  static List<String> version() => const ['--version'];
}
