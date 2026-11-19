import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The words Android shows before Flutter starts: the launcher shortcuts and
/// the engine's notification. They are held to the app's own wording
/// (packages/vh_ui/test/wording_test.dart): one verb for downloading, one
/// name for shorts, and VidHoist with a capital H (asked 2026-11-18).
void main() {
  const main = 'android/app/src/main';

  test('**the guard**: the Arabic shortcuts say تنزيل and القِصار', () {
    final ar = File('$main/res/values-ar/strings.xml').readAsStringSync();
    expect(ar, isNot(contains('تحميل')));
    expect(ar, isNot(contains('المقاطع القصيرة')));
  });

  test('**the guard**: the engine notification never reads "Vidhoist"', () {
    final engine = File('$main/kotlin/com/yasir/vidhoist/EngineService.kt')
        .readAsStringSync();
    expect(engine, isNot(contains('"Vidhoist"')));
  });
}
