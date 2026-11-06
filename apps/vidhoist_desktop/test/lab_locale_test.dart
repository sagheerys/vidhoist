import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/data/lab_options.dart';

void main() {
  test('--lab-locale picks the language for development; without it the '
      'app follows Windows', () {
    expect(labLocaleFrom(['--lab-route=/library', '--lab-locale=en']), 'en');
    expect(labLocaleFrom(['--lab-route=/library']), isNull);
  });
}
