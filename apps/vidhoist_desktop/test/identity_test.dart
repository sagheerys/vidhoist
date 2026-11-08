import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/identity.dart';
import 'package:vidhoist_desktop/platform/single_instance.dart';

/// The names Windows shows, and the data folder derived from them, must
/// not drift apart or change after the first release.
void main() {
  final rc = File('windows/runner/Runner.rc').readAsStringSync();
  String? field(String name) =>
      RegExp('VALUE "$name", "([^"]*)"').firstMatch(rc)?.group(1);

  test('the name is fixed for good', () {
    expect(DesktopIdentity.displayName, 'Vidhoist');
  });

  test('**the guard**: the data folder is %APPDATA%\\Vidhoist', () {
    // path_provider names the folder ProductName, under CompanyName when
    // that is set: a company here would move every user's data.
    expect(field('ProductName'), DesktopIdentity.displayName);
    expect(field('CompanyName'), isEmpty);
  });

  test("**the guard**: the program's properties name its maker and its "
      'free license, not the template\'s "all rights reserved"', () {
    expect(field('LegalCopyright'), contains('Yasir Sagheer'));
    expect(field('LegalCopyright'), contains('GPL-3.0'));
    expect(field('LegalCopyright'), isNot(contains('reserved')));
  });

  test('Windows shows the same name for the program and its window', () {
    expect(field('FileDescription'), DesktopIdentity.displayName);
    final runner = File('windows/runner/main.cpp').readAsStringSync();
    expect(runner, contains('window.Create(L"${DesktopIdentity.displayName}"'));
  });

  test('one copy per Windows user, through a pipe name that stays whole', () {
    expect(instancePipeName('Yasir'), 'vidhoist.Yasir');
    expect(instancePipeName('Yasir'), isNot(instancePipeName('Sara')));
    // A backslash would end the pipe name; Arabic letters are replaced.
    expect(instancePipeName(r'DOMAIN\ياسر'), 'vidhoist.DOMAIN_____');
    expect(instancePipeName(null), 'vidhoist');
    expect(instancePipeName(''), 'vidhoist');
  });
}
