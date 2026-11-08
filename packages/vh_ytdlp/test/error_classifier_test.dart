import 'package:vh_ytdlp/vh_ytdlp.dart';
import 'package:test/test.dart';

import 'fixtures.dart';

YtDlpErrorKind kindOf(String stderr) => ErrorClassifier.classify(stderr).kind;

void main() {
  group('the real failures', () {
    final expected = {
      'err-unavailable': YtDlpErrorKind.unavailable,
      'err-unsupported': YtDlpErrorKind.unavailable,
      'tiktok': YtDlpErrorKind.geoBlocked,
      'tiktok3': YtDlpErrorKind.geoBlocked,
      'x': YtDlpErrorKind.network,
    };
    for (final MapEntry(key: run, value: kind) in expected.entries) {
      test('$run is ${kind.name}', () {
        final error = ErrorClassifier.classify(fixture('$run.stderr.txt'));
        expect(error.kind, kind);
        expect(error.message, startsWith('ERROR: ['));
        expect(error.extractor, isNotNull);
      });
    }

    test('the extractor is named', () {
      expect(
        ErrorClassifier.classify(fixture('tiktok.stderr.txt')).extractor,
        'TikTok',
      );
      expect(
        ErrorClassifier.classify(fixture('x.stderr.txt')).extractor,
        'twitter:amplify',
      );
    });
  });

  test('warnings are not the error', () {
    final error = ErrorClassifier.classify(
      'WARNING: [TikTok] The extractor is attempting impersonation\n'
      'ERROR: [TikTok] 1: Your IP address is blocked from accessing this post\n',
    );
    expect(error.kind, YtDlpErrorKind.geoBlocked);
    expect(error.message, isNot(contains('WARNING')));
  });

  group('each kind', () {
    final cases = {
      'ERROR: [youtube] x: HTTP Error 429: Too Many Requests':
          YtDlpErrorKind.rateLimited,
      "ERROR: [youtube] x: Sign in to confirm you're not a bot":
          YtDlpErrorKind.signInRequired,
      'ERROR: [youtube] x: Sign in to confirm your age':
          YtDlpErrorKind.signInRequired,
      'ERROR: [instagram] x: Requested content is not available, '
              'rate-limit reached or login required':
          YtDlpErrorKind.signInRequired,
      "ERROR: [youtube] x: Private video. Sign in if you've been granted "
              'access to this video':
          YtDlpErrorKind.unavailable,
      'ERROR: [youtube] x: Join this channel to get access to members-only '
              'content':
          YtDlpErrorKind.unavailable,
      'ERROR: [youtube] x: The uploader has not made this video available '
              'in your country':
          YtDlpErrorKind.geoBlocked,
      'ERROR: Unsupported URL: https://example.com/':
          YtDlpErrorKind.unsupportedUrl,
      'ERROR: [youtube] x: Requested format is not available. Use --list-formats':
          YtDlpErrorKind.formatUnavailable,
      'ERROR: unable to write data: [Errno 28] No space left on device':
          YtDlpErrorKind.diskFull,
      'ERROR: Postprocessing: ffprobe and ffmpeg not found. Please install':
          YtDlpErrorKind.engineMissing,
      'ERROR: You have requested merging of multiple formats but ffmpeg is '
              'not installed':
          YtDlpErrorKind.engineMissing,
      'ERROR: [youtube] x: Unable to download webpage: <urlopen error '
              '[Errno 11001] getaddrinfo failed>':
          YtDlpErrorKind.network,
      'ERROR: [generic] x: Read timed out.': YtDlpErrorKind.network,
      // The phone with no internet, as an owner's screenshot showed it.
      'ERROR: [youtube:tab] @x/videos: Unable to download API page: '
              '[Errno 7] No address associated with host':
          YtDlpErrorKind.network,
      'ERROR: [youtube] x: Something new went wrong': YtDlpErrorKind.failed,
    };
    for (final MapEntry(key: stderr, value: kind) in cases.entries) {
      test('${kind.name}: $stderr', () => expect(kindOf(stderr), kind));
    }
  });

  test('only a missing format is retried at best', () {
    expect(
      ErrorClassifier.classify('ERROR: Requested format is not available')
          .retryAtBest,
      isTrue,
    );
    expect(
      ErrorClassifier.classify('ERROR: HTTP Error 429').retryAtBest,
      isFalse,
    );
  });

  test('with no ERROR line the last thing said is the message', () {
    final error = ErrorClassifier.classify('Traceback\n  boom\nKeyError: x\n');
    expect(error.kind, YtDlpErrorKind.failed);
    expect(error.message, 'KeyError: x');
    expect(error.extractor, isNull);
    expect(ErrorClassifier.classify('').message, '');
  });

  test('it reads as an exception', () {
    expect(
      ErrorClassifier.classify('ERROR: HTTP Error 429').toString(),
      'YtDlpError(rateLimited): ERROR: HTTP Error 429',
    );
  });

  group('reason: the first sentence of what yt-dlp said', () {
    test('drops the ERROR prefix, the extractor tag and the id', () {
      expect(
        ErrorClassifier.reason('ERROR: [youtube] aaa: Video unavailable'),
        'Video unavailable',
      );
      expect(ErrorClassifier.reason('ERROR: HTTP Error 429'), 'HTTP Error 429');
    });

    test('keeps the first line of several', () {
      expect(
        ErrorClassifier.reason(
          '[youtube] This video is unavailable\nNo video formats found!\n'
          'Requested format is not available',
        ),
        'This video is unavailable',
      );
    });

    test('leaves a plain reason alone', () {
      expect(
        ErrorClassifier.reason('URL is missing a host'),
        'URL is missing a host',
      );
      expect(ErrorClassifier.reason('  timeout  '), 'timeout');
    });

    test('never returns less than it was given', () {
      expect(ErrorClassifier.reason('[youtube]'), '[youtube]');
      expect(ErrorClassifier.reason(''), '');
    });
  });
}
