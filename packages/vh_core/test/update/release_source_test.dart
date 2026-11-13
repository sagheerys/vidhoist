import 'dart:convert';
import 'dart:io';

import 'package:vh_core/vh_core.dart';
import 'package:test/test.dart';

/// The update downloads a file and installs it (runs it, on Windows), so
/// the file comes from GitHub over https or there is no update.
void main() {
  // `releases/latest` as GitHub answered it for 2.6.0 (2026-11-05),
  // trimmed to the fields the app reads.
  final real = File('test/fixtures/github_release_2_6_0.json')
      .readAsStringSync();

  test("each app reads its own file's hash, and a release without hashes "
      'still updates', () {
    // The shape GitHub's API gives an asset since it began recording a
    // hash at upload: `digest: "sha256:<hex>"`, in either case.
    final listed = File('test/fixtures/github_release_digests.json')
        .readAsStringSync();
    String? hash(String ending) => UpdateRelease.tryParse(
      listed,
      assetMarker: 'vidhoist',
      extension: ending,
    )?.sha256;
    expect(
      hash('.exe'),
      'a39d2db355eeb092b661b3eca15e4c6acb19913ec3579d5e769c21d1df1bc78c',
    );
    expect(
      hash('.apk'),
      '6181aaf5c0d3b8e1f2a4c6e8091b3d5f7a9c1e3f5b7d9f1a3c5e7092b4d6f8a0',
    );
    // 2.6.0 was published before GitHub listed hashes: no hash, same update.
    final old = UpdateRelease.tryParse(real, assetMarker: 'lite');
    expect(old, isNotNull);
    expect(old!.sha256, isNull);
  });

  test('a digest that is not a SHA-256 is no hash at all', () {
    for (final digest in [
      'md5:0123456789abcdef0123456789abcdef',
      'sha256:${'a' * 63}',
      'sha256:${'g' * 64}',
      42,
    ]) {
      final json = jsonDecode(real) as Map<String, dynamic>;
      (json['assets'] as List).cast<Map<String, dynamic>>().first['digest'] =
          digest;
      final r = UpdateRelease.tryParse(jsonEncode(json), assetMarker: 'lite');
      expect(r!.sha256, isNull, reason: '$digest');
    }
  });

  String moved(String Function(String url) to, {String? page}) {
    final json = jsonDecode(real) as Map<String, dynamic>;
    for (final asset in json['assets'] as List) {
      final a = asset as Map<String, dynamic>;
      a['browser_download_url'] = to(a['browser_download_url'] as String);
    }
    if (page != null) json['html_url'] = page;
    return jsonEncode(json);
  }

  test('the published release is taken as it is: the update still works', () {
    final r = UpdateRelease.tryParse(real, assetMarker: 'lite')!;
    expect(r.version.toString(), '2.6.0');
    expect(r.apkUrl, startsWith('https://github.com/sagheerys/'));
    expect(
      r.pageUrl,
      'https://github.com/sagheerys/vidhoist-mobile/releases/tag/v2.6.0',
    );
    expect(UpdateRelease.tryParse(real, assetMarker: 'super'), isNotNull);
  });

  test('**the guard**: a file anywhere but GitHub over https is no '
      'update', () {
    for (final to in <String Function(String)>[
      (u) => u.replaceFirst('https://', 'http://'),
      (u) => u.replaceFirst('github.com', 'evil.example'),
      (u) => u.replaceFirst(
        'https://github.com',
        'https://github.com.evil.example',
      ),
      (_) => 'file:///C:/Windows/System32/calc.exe',
    ]) {
      expect(
        UpdateRelease.tryParse(moved(to), assetMarker: 'lite'),
        isNull,
        reason: moved(to),
      );
    }
  });

  test('a release page elsewhere is not opened', () {
    final r = UpdateRelease.tryParse(
      moved((u) => u, page: 'file:///C:/x.exe'),
      assetMarker: 'lite',
    );
    expect(r!.pageUrl, '');
  });
}
