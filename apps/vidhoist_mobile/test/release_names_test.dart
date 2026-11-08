import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_mobile/features/update/update_state.dart';

/// **The update finds Vidhoist's own APK.** The asset is matched by name,
/// and a stale marker (`lite`) once meant a release carrying
/// `Vidhoist-<version>.apk` would never have been offered.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('**the guard**: from a release carrying both apps\' files, the '
      'phone takes the APK, never the Windows installer', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final checker = c.read(updateCheckerProvider);
    final body = json.encode({
      'tag_name': 'v1.2.3',
      'draft': false,
      'prerelease': false,
      'assets': [
        for (final name in [
          'Vidhoist-1.2.3-windows-x64-setup.exe',
          'Vidhoist-1.2.3-android.apk',
        ])
          {
            'name': name,
            'browser_download_url':
                'https://github.com/sagheerys/vidhoist/releases/download/v1.2.3/$name',
            'size': 1,
          },
      ],
    });
    final release = UpdateRelease.tryParse(
      body,
      assetMarker: checker.assetMarker,
      extension: checker.assetExtension,
    );
    expect(release?.apkUrl, endsWith('Vidhoist-1.2.3-android.apk'));
  });

  // The engine's Python and ffmpeg are built per processor, so a release
  // carries one APK per ABI (about 70 MB each instead of 200 for all).
  test('**the guard**: from a release split per ABI, the phone takes the '
      'file built for its own processor', () async {
    final names = [
      'Vidhoist-1.2.3-windows-x64-setup.exe',
      'Vidhoist-1.2.3-android-armeabi-v7a.apk',
      'Vidhoist-1.2.3-android-arm64-v8a.apk',
      'Vidhoist-1.2.3-android-x86_64.apk',
    ];
    final c = ProviderContainer(
      overrides: [
        deviceAbisProvider.overrideWithValue(const ['arm64-v8a', 'armeabi']),
      ],
    );
    addTearDown(c.dispose);
    final checker = c.read(updateCheckerProvider);
    expect(checker.abis, ['arm64-v8a', 'armeabi']);
    final release = UpdateRelease.tryParse(
      json.encode({
        'tag_name': 'v1.2.3',
        'assets': [
          for (final name in names)
            {
              'name': name,
              'browser_download_url':
                  'https://github.com/sagheerys/vidhoist/releases/download/v1.2.3/$name',
              'size': 1,
            },
        ],
      }),
      assetMarker: checker.assetMarker,
      extension: checker.assetExtension,
      abis: checker.abis,
    );
    expect(release?.apkUrl, endsWith('Vidhoist-1.2.3-android-arm64-v8a.apk'));
  });

  test('the phone tells its ABIs, most preferred first', () async {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(
      const MethodChannel('vidhoist_mobile/media'),
      (call) async =>
          call.method == 'supportedAbis' ? ['arm64-v8a', 'armeabi-v7a'] : null,
    );
    addTearDown(
      () => messenger.setMockMethodCallHandler(
        const MethodChannel('vidhoist_mobile/media'),
        null,
      ),
    );
    expect(await readDeviceAbis(), ['arm64-v8a', 'armeabi-v7a']);
  });
}
