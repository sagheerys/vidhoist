import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// **The parity guard, for every language.**
///
/// `app_en.arb` is the template; every other `app_<code>.arb` carries the
/// same keys with their placeholders, none left empty. That used to be a
/// written rule for two files that could be forgotten; this makes it a
/// test that **fails** when a key is missing from any language, when its
/// placeholders differ, or when it is left empty.
///
/// It is never disabled or bypassed: a one-legged key means an English
/// string in the middle of another language, or an `undefined_getter`
/// crash at build time.
void main() {
  final dir = Directory('lib/src/l10n');

  Map<String, dynamic> load(String name) {
    final file = File('${dir.path}/$name');
    expect(file.existsSync(), isTrue, reason: 'missing translation: $name');
    return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  }

  /// Every translation file, the template aside.
  final translations = [
    for (final f in dir.listSync())
      if (f is File &&
          RegExp(r'app_(\w+)\.arb$').hasMatch(f.path) &&
          !f.path.endsWith('app_en.arb'))
        f.uri.pathSegments.last,
  ]..sort();

  /// The string keys only, without `@@locale` and without the `@key`
  /// metadata blocks.
  Set<String> messageKeys(Map<String, dynamic> arb) =>
      arb.keys.where((k) => !k.startsWith('@')).toSet();

  /// Placeholder names inside the text: `{percent}`, `{count}`. Plural
  /// forms are picked up from their branches so the files match.
  Set<String> placeholdersOf(String value) =>
      RegExp(r'\{(\w+)\}').allMatches(value).map((m) => m.group(1)!).toSet();

  late Map<String, dynamic> en;

  setUpAll(() => en = load('app_en.arb'));

  test('the twelve languages are all there', () {
    expect(translations, hasLength(11), reason: '$translations');
  });

  for (final name in translations) {
    test('$name: the same keys as the English, none empty, and the same '
        'placeholders in each', () {
      final arb = load(name);
      final enKeys = messageKeys(en);
      final keys = messageKeys(arb);
      expect(
        enKeys.difference(keys).toList()..sort(),
        isEmpty,
        reason: 'keys missing from $name',
      );
      expect(
        keys.difference(enKeys).toList()..sort(),
        isEmpty,
        reason: 'keys in $name that English does not have',
      );
      for (final key in enKeys) {
        final value = arb[key];
        if (value is! String) continue;
        expect(value.trim(), isNotEmpty, reason: '$name: $key is empty');
        expect(
          placeholdersOf(value),
          placeholdersOf(en[key] as String),
          reason: '$name: placeholders differ in "$key"',
        );
      }
    });
  }

  /// **The metadata block is required in the template (`app_en.arb`)
  /// only**, verified against `gen-l10n`'s actual behaviour rather than
  /// assumed: `resultsFound` is a plural in every language with its block
  /// in English alone, and generation passes.
  test('every plural key has an @ block in the English template', () {
    for (final key in messageKeys(en)) {
      final isPlural =
          (en[key] as String).contains(', plural,') ||
          translations.any(
            (name) =>
                ((load(name)[key] as String?) ?? '').contains(', plural,'),
          );
      if (!isPlural) continue;
      expect(
        en['@$key'],
        isNotNull,
        reason: 'a plural without its @$key block in app_en.arb',
      );
    }
  });

  /// **The licence guard.** The About screen once said "all rights
  /// reserved", the opposite of GPL-3.0: the licence grants copying,
  /// modification and redistribution, and that sentence forbids them. Its
  /// return in any language fails here.
  test('no all rights reserved claim to contradict the GPL', () {
    const claims = [
      'all rights reserved',
      'جميع الحقوق محفوظة',
      'todos los derechos reservados',
      'todos os direitos reservados',
      'tous droits réservés',
      'alle rechte vorbehalten',
      'tüm hakları saklıdır',
      'все права защищены',
      'hak cipta dilindungi',
      'کلیه حقوق محفوظ',
      'جملہ حقوق محفوظ',
      'सर्वाधिकार सुरक्षित',
    ];
    for (final name in ['app_en.arb', ...translations]) {
      final values = load(name).entries
          .where((e) => !e.key.startsWith('@'))
          .map((e) => e.value.toString().toLowerCase());
      for (final v in values) {
        for (final claim in claims) {
          expect(v.contains(claim), isFalse, reason: '$name: "$claim"');
        }
      }
    }
  });

  /// The licence expects the user to find its name and the warranty
  /// disclaimer **inside the program**, in their language.
  test('the licence strings are present, and name it', () {
    for (final name in ['app_en.arb', ...translations]) {
      final arb = load(name);
      expect(
        arb['licensedUnder'].toString(),
        contains('GPL-3.0'),
        reason: name,
      );
      expect(arb['copyright'].toString(), contains('2026'), reason: name);
      expect(arb['notAffiliated'].toString(), contains('yt-dlp'), reason: name);
      expect(arb['noWarranty'], isNotNull, reason: name);
    }
  });
}
