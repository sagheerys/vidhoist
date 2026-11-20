import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
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
