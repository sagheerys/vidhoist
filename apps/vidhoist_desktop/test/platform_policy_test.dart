import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/platform/desktop_capability.dart';

void main() {
  group('DesktopCapability', () {
    test('it reads the build from the system version string', () {
      expect(
        DesktopCapability.parseWindowsBuild(
          '"Windows 10 Pro" 10.0 (Build 26200)',
        ),
        26200,
      );
      expect(DesktopCapability.parseWindowsBuild('Linux 6.1'), 0);
    });

    test('an unreadable version turns the media controls off', () {
      const unknown = DesktopCapability(isWindows: true, windowsBuild: 0);
      expect(unknown.canUseSmtc(), isFalse);
      expect(unknown.canShowTaskbarProgress(), isTrue);

      const win11 = DesktopCapability(isWindows: true, windowsBuild: 26200);
      expect(win11.canUseSmtc(), isTrue);
    });

    test('off Windows nothing native is promised', () {
      const other = DesktopCapability(isWindows: false, windowsBuild: 0);
      expect(other.canShowTaskbarProgress(), isFalse);
      expect(other.canUseSmtc(), isFalse);
      expect(other.canDragFilesOut(), isFalse);
    });
  });

  test('**the guard**: only lib/platform looks at Platform', () {
    final offenders = [
      for (final f in Directory('lib').listSync(recursive: true))
        if (f is File &&
            f.path.endsWith('.dart') &&
            !f.path.replaceAll(r'\', '/').startsWith('lib/platform/') &&
            RegExp(r'\bPlatform\.').hasMatch(f.readAsStringSync()))
          f.path,
    ];
    expect(offenders, isEmpty);
  });
}
