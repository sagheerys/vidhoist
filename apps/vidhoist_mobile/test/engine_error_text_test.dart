import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/features/shared/error_text.dart';

/// Every way yt-dlp on the device can fail has its own sentence, in both
/// languages: a generic "Error: …" with yt-dlp's English inside an
/// Arabic line tells the person nothing they could act on.
void main() {
  for (final locale in [const Locale('en'), const Locale('ar')]) {
    final l = lookupVhLocalizations(locale);
    group(locale.languageCode, () {
      final expected = {
        YtDlpErrorKind.unavailable: l.engineErrUnavailable,
        YtDlpErrorKind.geoBlocked: l.engineErrGeoBlocked,
        YtDlpErrorKind.unsupportedUrl: l.engineErrUnsupported,
        YtDlpErrorKind.rateLimited: l.engineErrRateLimited,
        YtDlpErrorKind.formatUnavailable: l.engineErrFormat,
        YtDlpErrorKind.diskFull: l.engineErrDiskFull,
        YtDlpErrorKind.engineMissing: l.engineErrMissing,
        YtDlpErrorKind.clipPastEnd: l.errClipPastEndUnknown,
      };
      for (final MapEntry(key: kind, value: text) in expected.entries) {
        test(kind.name, () {
          expect(errorText(l, EngineFailureException(kind, 'ERROR: x')), text);
        });
      }

      test('anything else names the reason, its first line only', () {
        final text = errorText(
          l,
          const EngineFailureException(
            YtDlpErrorKind.failed,
            'ERROR: [youtube] x: Something new\n  more',
          ),
        );
        expect(text, l.engineErrFailed(vhName('Something new')));
      });

      // A stretch asked past a video's end used to reach yt-dlp, which
      // said only "Invalid argument".
      test('**the guard**: a stretch past the end names the length', () {
        final text = errorText(
          l,
          ClipPastEndException(const Duration(minutes: 16, seconds: 52)),
        );
        expect(text, l.errClipPastEnd('16:52'));
      });

      // Seen 2026-11-18 on Instagram, which gives no length: the stretch
      // is found past the end only after the run.
      test('a stretch past the end of a video of no known length says so '
          'without a time', () {
        expect(
          errorText(l, ClipPastEndException(null)),
          l.errClipPastEndUnknown,
        );
      });

      test('the sentences differ from one another', () {
        expect(expected.values.toSet(), hasLength(expected.length));
      });
    });
  }
}
