import 'dart:convert';

import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_core/src/download/early_probe.dart';

/// The add screen's reading of a link, kept for that link's download: one
/// link, taken once, let go once its media links may have expired.
void main() {
  const url = 'https://www.youtube.com/watch?v=abc';
  late List<String> asked;
  late DateTime now;
  var fail = false;

  setUp(() {
    asked = [];
    now = DateTime(2026, 11, 17, 17);
    fail = false;
  });

  EarlyProbe early() => EarlyProbe((url) async {
    asked.add(url);
    if (fail) throw const YtDlpError(YtDlpErrorKind.network, 'offline');
    return ProbeResult(InfoJson.parse(jsonEncode({'id': 'abc'})));
  }, clock: () => now);

  test('read twice, then taken once: one probe', () async {
    final probe = early();
    await probe.read(url);
    await probe.read(url);
    expect(probe.take(url), isNotNull);
    expect(probe.take(url), isNull);
    expect(asked, [url]);
  });

  test('another link, or one read too long ago, is not taken', () async {
    final probe = early();
    await probe.read(url);
    expect(probe.take('https://www.youtube.com/watch?v=other'), isNull);
    now = now.add(const Duration(minutes: 31));
    expect(probe.take(url), isNull);
  });

  test('a reading that failed is not kept', () async {
    final probe = early();
    fail = true;
    await expectLater(probe.read(url), throwsA(isA<YtDlpError>()));
    await Future<void>.delayed(Duration.zero);
    expect(probe.take(url), isNull);
  });

  test('taken while it fails, the download reads the link afresh', () async {
    final probe = early();
    fail = true;
    probe.read(url).ignore();
    final taken = probe.take(url)!;
    fail = false;
    expect(await taken, isA<ProbeResult>());
    expect(asked, [url, url]);
  });
}
