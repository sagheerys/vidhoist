import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// **The sign-ins stay on the phone.** Android backs an app's files up to
/// the user's Google account and copies them to a new phone unless the
/// rules leave them out; the cookies a sign-in leaves are promised to stay
/// where yt-dlp reads them.
void main() {
  const rules = [
    'android/app/src/main/res/xml/backup_rules.xml',
    'android/app/src/main/res/xml/data_extraction_rules.xml',
  ];

  test('**the guard**: both backup rules leave the sign-ins and the '
      'secrets out, in every scope', () {
    for (final path in rules) {
      final xml = File(path).readAsStringSync();
      for (final exclusion in [
        '<exclude domain="sharedpref" path="FlutterSecureStorage.xml"/>',
        '<exclude domain="file" path="cookies.txt"/>',
        '<exclude domain="root" path="app_webview/"/>',
      ]) {
        // The newer rules have two scopes, cloud backup and transfer.
        final scopes = path.contains('extraction') ? 2 : 1;
        expect(
          exclusion.allMatches(xml).length,
          scopes,
          reason: '$exclusion in $path',
        );
      }
    }
  });

  test('the cookies file is where the rules say: cookies.txt in the '
      "app's files folder", () {
    for (final path in [
      'lib/main.dart',
      'lib/features/background/background_main.dart',
    ]) {
      expect(File(path).readAsStringSync(), contains('/cookies.txt'));
    }
    // The folder both use is the app's support folder, Android's files/.
    expect(
      File('lib/main.dart').readAsStringSync(),
      contains('final logsDir = await getApplicationSupportDirectory();'),
    );
  });
}
