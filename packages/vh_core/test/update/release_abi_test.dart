import 'dart:convert';

import 'package:vh_core/vh_core.dart';
import 'package:test/test.dart';

/// A phone release is split per processor family, because yt-dlp's Python
/// and ffmpeg come compiled for each and one APK carrying all of them is
/// about three times the size. The phone takes the file built for it.
void main() {
  String release(List<String> names) => json.encode({
    'tag_name': 'v1.0.0',
    'assets': [
      for (final name in names)
        {
          'name': name,
          'browser_download_url':
              'https://github.com/o/r/releases/download/v1.0.0/$name',
          'size': name.length,
        },
    ],
  });

  UpdateRelease? pick(List<String> names, List<String> abis) =>
      UpdateRelease.tryParse(
        release(names),
        assetMarker: 'vidhoist',
        abis: abis,
      );

  const split = [
    'Vidhoist-1.0.0-windows-x64-setup.exe',
    'Vidhoist-1.0.0-android-armeabi-v7a.apk',
    'Vidhoist-1.0.0-android-arm64-v8a.apk',
    'Vidhoist-1.0.0-android-x86_64.apk',
  ];

  test('the file for the phone\'s first ABI, whatever the order listed', () {
    expect(
      pick(split, ['arm64-v8a', 'armeabi-v7a', 'armeabi'])?.apkUrl,
      endsWith('Vidhoist-1.0.0-android-arm64-v8a.apk'),
    );
    expect(
      pick(split, ['armeabi-v7a', 'armeabi'])?.apkUrl,
      endsWith('Vidhoist-1.0.0-android-armeabi-v7a.apk'),
    );
  });

  test('a 64-bit phone that also runs 32-bit code takes 32 bits when that '
      'is all there is', () {
    expect(
      pick(
        ['Vidhoist-1.0.0-android-armeabi-v7a.apk'],
        ['arm64-v8a', 'armeabi-v7a'],
      )?.apkUrl,
      endsWith('armeabi-v7a.apk'),
    );
  });

  test('a single APK for every phone is taken when no split one fits', () {
    expect(
      pick(
        ['Vidhoist-1.0.0-android-x86_64.apk', 'Vidhoist-1.0.0-android.apk'],
        ['arm64-v8a'],
      )?.apkUrl,
      endsWith('Vidhoist-1.0.0-android.apk'),
    );
  });

  test('a file built for another processor is never offered', () {
    expect(pick(['Vidhoist-1.0.0-android-x86_64.apk'], ['arm64-v8a']), isNull);
  });

  test('without ABIs the first matching file is taken, as before', () {
    expect(
      pick(split, const [])?.apkUrl,
      endsWith('Vidhoist-1.0.0-android-armeabi-v7a.apk'),
    );
  });

  test('the checker passes its ABIs to the pick', () async {
    final checker = UpdateChecker(
      fetch: (_) async => release(split),
      assetMarker: 'vidhoist',
      abis: const ['arm64-v8a'],
      trustedAsset: (_) => true,
    );
    final found = await checker.checkOrThrow(currentVersion: '0.9.0');
    expect(found?.apkUrl, endsWith('arm64-v8a.apk'));
  });
}
