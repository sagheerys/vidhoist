import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// **The status bar's icon is the mark** (owner, 2026-11-14): the folded
/// ribbon replaced the window with the arrow on 2026-11-11, but the icon
/// every notification puts in the status bar kept the old drawing, since
/// nothing made it from the kit.
void main() {
  final xml = File('android/app/src/main/res/drawable/ic_stat_vidhoist.xml')
      .readAsStringSync();

  test('**the guard**: it is made by the kit, from the mark', () {
    expect(xml, contains('tool/icons/vidhoist_kit.py'));
    expect(xml, isNot(contains('make_icons.py')));
    // The two arms of the ribbon, each its own shape.
    expect('android:pathData'.allMatches(xml), hasLength(2));
  });

  test('white on clear alone, as Android tints it to the bar', () {
    final colours = RegExp(r'android:fillColor="([^"]+)"')
        .allMatches(xml)
        .map((m) => m[1])
        .toSet();
    expect(colours, {'#FFFFFFFF'});
    expect(xml, isNot(contains('strokeColor')));
  });

  test('every notification names it', () {
    for (final path in [
      'lib/main.dart',
      'lib/features/home/notifications.dart',
      'android/app/src/main/kotlin/com/yasir/vidhoist/EngineService.kt',
    ]) {
      expect(File(path).readAsStringSync(), contains('ic_stat_vidhoist'));
    }
  });
}
