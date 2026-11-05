import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_core/mt_core.dart';
import 'package:vidhoist_desktop/data/update_data.dart';

/// **The update finds Vidhoist's own installer.** The fork kept the
/// parent's asset marker (`ember`) and file name (`Vidhoist-Ember-…`) after
/// the rename, so a Vidhoist release would never have been offered: its
/// installer is named by `vidhoist.iss`, and nothing in it says "ember".
/// Found while bringing in v2.7.0 (2026-11-05), before any release.
void main() {
  test('**the guard**: the name the app downloads to is the name the '
      'installer script gives', () {
    final iss = File('windows/installer/vidhoist.iss').readAsStringSync();
    final base = RegExp(
      r'^OutputBaseFilename=(.+)$',
      multiLine: true,
    ).firstMatch(iss)!.group(1)!.trim();
    expect(
      installerNameFor('1.2.3'),
      '${base.replaceAll('{#AppVersion}', '1.2.3')}.exe',
    );
  });

  test('**the guard**: from a release carrying both apps\' files, Windows '
      'takes the installer', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final checker = c.read(updateCheckerProvider);
    final body = json.encode({
      'tag_name': 'v1.2.3',
      'draft': false,
      'prerelease': false,
      'assets': [
        for (final name in [
          'Vidhoist-1.2.3-android.apk',
          installerNameFor('1.2.3'),
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
    expect(release?.apkUrl, endsWith(installerNameFor('1.2.3')));
  });
}
