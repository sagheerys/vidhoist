import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_core/mt_core.dart';
import 'package:vidhoist_mobile/features/update/update_state.dart';

/// **The update finds Vidhoist's own APK.** The fork kept the parent's
/// asset marker (`lite`) after the rename, so a release carrying
/// `Vidhoist-<version>.apk` would never have been offered. Found while
/// bringing in v2.7.0 (2026-11-05), before any release.
void main() {
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
}
