import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The words a user reads, held to one name per thing.
///
/// VidHoist downloads on the device and never had a server, so a string
/// that mentions one (or reassures that there is none) only confuses
/// someone who never expected one. And one thing gets one word in Arabic:
/// one verb for downloading, one name each for the computer, the phone,
/// the QR code and a filter. The banned spellings are
/// in the patterns below.
void main() {
  Map<String, String> strings(String lang) {
    final raw = jsonDecode(
      File('lib/src/l10n/app_$lang.arb').readAsStringSync(),
    ) as Map<String, dynamic>;
    return {
      for (final e in raw.entries)
        if (!e.key.startsWith('@')) e.key: e.value as String,
    };
  }

  List<String> offending(Map<String, String> all, RegExp banned) => [
    for (final e in all.entries)
      if (banned.hasMatch(e.value)) '${e.key}: ${e.value}',
  ];

  test('**the guard**: no string speaks of a server', () {
    expect(
      offending(
        strings('en'),
        RegExp(
          r'\bservers?\b|Me'
          'Tube',
          caseSensitive: false,
        ),
      ),
      isEmpty,
    );
    expect(
      offending(
        strings('ar'),
        RegExp(
          'سيرفر|خادم|Me'
          'Tube',
        ),
      ),
      isEmpty,
    );
  });

  test('**the guard**: the Arabic strings use one word for each thing', () {
    expect(
      offending(
        strings('ar'),
        RegExp(r'تحميل|حمّل|تحمّل|حاسوب|هاتف|هواتف|باركود|مرشّح|Windows'),
      ),
      isEmpty,
    );
  });

  test('the product is VidHoist wherever its name is shown', () {
    final wrong = RegExp(r'Vidhoist(?![\\/])');
    expect(offending(strings('en'), wrong), isEmpty);
    expect(offending(strings('ar'), wrong), isEmpty);
  });
}
