import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// **What the release build's shrinker must leave**, read from the build
/// files: the tests run unshrunk code and cannot see it go.
///
/// WorkManager made the release app close before its first frame, while
/// every test and the debug build passed: R8 removed the empty constructor
/// of the database class WorkManager builds by reflection at start.
void main() {
  final gradle = File('android/app/build.gradle.kts').readAsStringSync();
  final rules = File('android/app/proguard-rules.pro').readAsStringSync();

  test('with WorkManager in the app, its database class is kept', () {
    if (!gradle.contains('androidx.work:work-runtime')) return;
    expect(
      rules,
      contains(
        '-keep class * extends androidx.room.RoomDatabase { <init>(); }',
      ),
    );
    expect(rules, contains('androidx.work.impl.WorkDatabase_Impl'));
  });

  /// Flutter shrinks a release by default; these rules reach it only
  /// through this line.
  test('the release build reads these rules', () {
    expect(gradle, contains('"proguard-rules.pro"'));
    expect(gradle, isNot(contains('isMinifyEnabled = false')));
  });
}
