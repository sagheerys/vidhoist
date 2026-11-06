import 'package:mt_ytdlp/mt_ytdlp.dart';
import 'package:test/test.dart';

const windows = EngineSetup(
  platform: HostPlatform.windows,
  ffmpegDir: r'C:\engine',
  jsRuntime: r'deno:C:\engine\js\deno.exe',
);
const android = EngineSetup(platform: HostPlatform.android);

/// The value that follows [option], failing when it is absent.
String valueOf(List<String> args, String option) {
  final i = args.indexOf(option);
  expect(i, isNonNegative, reason: '$option is missing');
  return args[i + 1];
}

/// Every value given to [option], in order.
List<String> valuesOf(List<String> args, String option) => [
  for (var i = 0; i < args.length - 1; i++)
    if (args[i] == option) args[i + 1],
];

void main() {
  group('download', () {
    const link = DownloadSpec(url: 'https://youtu.be/x', folder: r'C:\out');

    test('the link goes last, after "--"', () {
      final args = CommandBuilder.download(link, windows);
      expect(args.sublist(args.length - 2), ['--', 'https://youtu.be/x']);
    });

    test('a link that looks like an option stays a link', () {
      final args = CommandBuilder.download(
        const DownloadSpec(url: '-rf', folder: 'out'),
        android,
      );
      expect(args.indexOf('-rf'), args.indexOf('--') + 1);
    });

    test("no config of the user's own, and IPv4 unless turned off", () {
      final args = CommandBuilder.download(link, windows);
      expect(args.first, '--ignore-config');
      expect(args, contains('-4'));
      final v6 = CommandBuilder.download(
        link,
        const EngineSetup(platform: HostPlatform.android, forceIpv4: false),
      );
      expect(v6, isNot(contains('-4')));
    });

    test('Windows names its ffmpeg, its JS runtime and safe file names', () {
      final args = CommandBuilder.download(link, windows);
      expect(valueOf(args, '--ffmpeg-location'), r'C:\engine');
      expect(valueOf(args, '--js-runtimes'), r'deno:C:\engine\js\deno.exe');
      expect(args, contains('--windows-filenames'));
    });

    test('Android leaves those to the library', () {
      final args = CommandBuilder.download(link, android);
      expect(args, isNot(contains('--ffmpeg-location')));
      expect(args, isNot(contains('--js-runtimes')));
      expect(args, isNot(contains('--windows-filenames')));
    });

    test('progress, parts and the final file come back tagged', () {
      final args = CommandBuilder.download(link, android);
      expect(args, containsAll(['--newline', '--progress']));
      final templates = valuesOf(args, '--progress-template');
      expect(templates, hasLength(2));
      expect(templates[0], startsWith('download:[vh] %(progress.status)s '));
      // Last, the format: a subtitle file has none (measured 2026-11-07).
      expect(templates[0], endsWith(' %(info.format_id)s'));
      expect(templates[1], startsWith('postprocess:[vh-pp] '));
      expect(valuesOf(args, '--print'), [
        'video:[vh-parts] %(filesize_approx)s '
            '%(requested_formats.:.filesize_approx)j',
        'after_move:[vh-file] %(filepath)s',
      ]);
    });

    test('the folder and the name template', () {
      final args = CommandBuilder.download(link, windows);
      expect(valueOf(args, '-P'), r'C:\out');
      expect(valueOf(args, '-o'), '%(title).80B [%(id)s].%(ext)s');
    });

    test('the format choice comes from FormatSelector', () {
      final args = CommandBuilder.download(
        const DownloadSpec(
          url: 'u',
          folder: 'f',
          choice: FormatChoice.h720,
          compatible: true,
        ),
        android,
      );
      expect(
        valueOf(args, '-f'),
        FormatSelector.selector(FormatChoice.h720, compatible: true),
      );
      expect(valueOf(args, '--merge-output-format'), 'mp4');
    });

    test('one video unless playlist items are named', () {
      expect(CommandBuilder.download(link, android), contains('--no-playlist'));
      final some = CommandBuilder.download(
        const DownloadSpec(url: 'u', folder: 'f', playlistItems: [1, 3, 5]),
        android,
      );
      expect(some, isNot(contains('--no-playlist')));
      expect(some, contains('--yes-playlist'));
      expect(valueOf(some, '--playlist-items'), '1,3,5');
    });

    test('subtitles, when asked, never fail the video', () {
      expect(
        CommandBuilder.download(link, android),
        isNot(contains('--write-subs')),
      );
      final args = CommandBuilder.download(
        const DownloadSpec(
          url: 'u',
          folder: 'f',
          subtitleLanguages: ['ar.*', 'en.*'],
        ),
        android,
      );
      expect(valueOf(args, '--sub-langs'), 'ar.*,en.*');
      expect(args, containsAll(['--write-auto-subs', '--ignore-errors']));
    });

    test('the info JSON and the thumbnail are kept unless turned off', () {
      expect(
        CommandBuilder.download(link, android),
        containsAll(['--write-info-json', '--write-thumbnail']),
      );
      final bare = CommandBuilder.download(
        const DownloadSpec(
          url: 'u',
          folder: 'f',
          writeInfoJson: false,
          writeThumbnail: false,
        ),
        android,
      );
      expect(bare, isNot(contains('--write-info-json')));
      expect(bare, isNot(contains('--write-thumbnail')));
    });

    test('cookies and a speed limit', () {
      final args = CommandBuilder.download(
        const DownloadSpec(url: 'u', folder: 'f', rateLimit: '2M'),
        const EngineSetup(platform: HostPlatform.android, cookiesFile: 'c.txt'),
      );
      expect(valueOf(args, '--cookies'), 'c.txt');
      expect(valueOf(args, '-r'), '2M');
    });

    test("cookies from a browser's own store, on probes too", () {
      const setup = EngineSetup(
        platform: HostPlatform.windows,
        cookiesFromBrowser: 'firefox',
      );
      final download = CommandBuilder.download(
        const DownloadSpec(url: 'u', folder: 'f'),
        setup,
      );
      expect(valueOf(download, '--cookies-from-browser'), 'firefox');
      expect(download, isNot(contains('--cookies')));
      final probe = CommandBuilder.probe('u', setup);
      expect(valueOf(probe, '--cookies-from-browser'), 'firefox');
      expect(probe.last, 'u');
    });

    test("from a probe's info JSON there is no link at all", () {
      final args = CommandBuilder.download(
        const DownloadSpec(infoJsonPath: 'probe.json', folder: 'f'),
        android,
      );
      expect(valueOf(args, '--load-info-json'), 'probe.json');
      expect(args, isNot(contains('--')));
      expect(args.last, 'probe.json');
    });

    test('a download from both a link and a JSON is a mistake', () {
      expect(
        () => DownloadSpec(url: 'u', infoJsonPath: 'p', folder: 'f'),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  test('**the guard**: on Windows yt-dlp prints in UTF-8', () {
    // Owner, 2026-11-06: a title with "/" is saved as "⧸", which yt-dlp
    // printed without that character on Windows; the path read back did not
    // exist and the finished video never reached the library. The Python
    // environment variables do not reach the frozen build; --encoding does.
    for (final args in [
      CommandBuilder.download(
        const DownloadSpec(url: 'u', folder: 'f'),
        windows,
      ),
      CommandBuilder.probe('u', windows),
      CommandBuilder.playlist('p', windows),
    ]) {
      expect(valueOf(args, '--encoding'), 'utf-8');
    }
    expect(CommandBuilder.probe('u', android), isNot(contains('--encoding')));
  });

  test('probe asks for the info JSON of one video', () {
    expect(CommandBuilder.probe('https://youtu.be/x', android), [
      '--ignore-config',
      '--no-colors',
      '-4',
      '-J',
      '--no-playlist',
      '--',
      'https://youtu.be/x',
    ]);
  });

  test('a playlist is listed flat, up to a limit', () {
    final args = CommandBuilder.playlist('p', windows, limit: 5);
    expect(args, containsAll(['-J', '--flat-playlist']));
    expect(valueOf(args, '--playlist-end'), '5');
    expect(
      CommandBuilder.playlist('p', windows),
      isNot(contains('--playlist-end')),
    );
  });

  test('version', () {
    expect(CommandBuilder.version(), ['--version']);
  });
}
