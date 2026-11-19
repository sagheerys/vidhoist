import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// **The languages Android knows the app speaks** are the ones it is
/// translated into: Android 13's per-app language setting lists
/// `locales_config.xml`, and the launcher shortcuts are native strings,
/// one folder per language. A language added to the arb files and not
/// here would be missing from that setting and its shortcuts English.
void main() {
  const res = 'android/app/src/main/res';

  /// Android's resource folder for a language: Indonesian keeps its old
  /// code there.
  String folder(String code) => code == 'id' ? 'in' : code;

  test('**the guard**: Android lists every language the app is '
      'translated into, and no other', () {
    final xml = File('$res/xml/locales_config.xml').readAsStringSync();
    final listed = {
      for (final m in RegExp(r'android:name="([\w-]+)"').allMatches(xml))
        m.group(1)!.split('-').first,
    };
    final translated = {
      for (final locale in VhLocalizations.supportedLocales)
        locale.languageCode,
    };
    expect(listed, translated);
    final manifest = File('android/app/src/main/AndroidManifest.xml')
        .readAsStringSync();
    expect(manifest, contains('android:localeConfig="@xml/locales_config"'));
  });

  test('**the guard**: each language has its launcher shortcuts and its '
      'notification kind, and the picker names it in itself', () {
    final keys = RegExp(r'name="(\w+)"')
        .allMatches(File('$res/values/strings.xml').readAsStringSync())
        .map((m) => m.group(1))
        .toSet();
    for (final locale in VhLocalizations.supportedLocales) {
      final code = locale.languageCode;
      expect(vhLanguageNames, contains(code), reason: code);
      if (code == 'en') continue;
      final file = File('$res/values-${folder(code)}/strings.xml');
      expect(file.existsSync(), isTrue, reason: file.path);
      final own = RegExp(r'name="(\w+)"')
          .allMatches(file.readAsStringSync())
          .map((m) => m.group(1))
          .toSet();
      expect(own, keys, reason: file.path);
    }
  });
}
