import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_desktop/shell/error_text.dart';

/// Every way yt-dlp on the device can fail has its own sentence, in both
/// languages: the generic "Error: …" with yt-dlp's English inside an
/// Arabic line is what the server pipeline showed, and it told the person
/// nothing they could act on.
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

      test('the sentences differ from one another', () {
        expect(expected.values.toSet(), hasLength(expected.length));
      });
    });
  }
}
