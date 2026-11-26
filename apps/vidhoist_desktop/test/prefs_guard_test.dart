import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/platform/prefs_guard.dart';
import 'package:vh_core/vh_core.dart';

const _good = '{"flutter.tags_index":"[1,2]","flutter.theme_mode":"dark"}';

/// What shared_preferences_windows does with the file at the first read:
/// it throws on anything but empty text or one JSON object, and takes
/// empty text for no settings at all.
Map<String, Object?> _pluginRead(File file) {
  if (!file.existsSync()) return {};
  final text = file.readAsStringSync();
  if (text.isEmpty) return {};
  return (json.decode(text) as Map).cast<String, Object?>();
}

void main() {
  late Directory folder;
  late VhLogger logger;
  late PrefsGuard guard;

  File named(String name) => File('${folder.path}\\$name');
  Set<String> names() =>
      folder.listSync().map((f) => f.path.split(r'\').last).toSet();

  setUp(() {
    folder = Directory.systemTemp.createTempSync('vh_prefs_guard_');
    logger = VhLogger(filePath: '${folder.path}\\logs\\app.log');
    guard = PrefsGuard(
      folder: folder.path,
      logger: logger,
      clock: () => DateTime(2026, 11, 25, 9),
    );
  });
  tearDown(() => folder.deleteSync(recursive: true));

  test('the file is the one the plugin keeps in the support folder', () {
    expect(prefsFileName, 'shared_preferences.json');
    expect(guard.file.path, '${folder.path}\\shared_preferences.json');
  });

  test('**the guard**: a file cut short by a crash comes back from the last '
      'good copy, and the broken one is kept aside, not deleted', () async {
    named(prefsFileName).writeAsStringSync(_good);
    expect(await guard.check(), PrefsCheck.healthy);
    const cut = '{"flutter.tags_index":"[1,2]","flutter.th';
    named(prefsFileName).writeAsStringSync(cut);
    expect(() => _pluginRead(named(prefsFileName)), throwsFormatException);

    expect(await guard.check(), PrefsCheck.restored);
    expect(_pluginRead(named(prefsFileName)), json.decode(_good));
    final aside = named('shared_preferences.broken-2026-11-25_090000.json');
    expect(aside.readAsStringSync(), cut);
    expect(names(), {
      'logs',
      'shared_preferences.broken-2026-11-25_090000.json',
      prefsCopyName,
      prefsFileName,
    });
    expect(File(logger.filePath).readAsStringSync(), contains('restored'));
  });

  test('an empty file, a write cut off after the truncation, is broken '
      'too: the plugin would read it as no settings at all', () async {
    named(prefsCopyName).writeAsStringSync(_good);
    named(prefsFileName).writeAsBytesSync(const []);
    expect(_pluginRead(named(prefsFileName)), isEmpty);

    expect(await guard.check(), PrefsCheck.restored);
    expect(_pluginRead(named(prefsFileName)), json.decode(_good));
  });

  test('bytes that are not text, or JSON that is not an object, are '
      'broken', () async {
    named(prefsCopyName).writeAsStringSync(_good);
    named(prefsFileName).writeAsBytesSync(List.filled(64, 0));
    expect(await guard.check(), PrefsCheck.restored);
    named(prefsFileName).writeAsStringSync('[1]');
    expect(await guard.check(), PrefsCheck.restored);
    expect(_pluginRead(named(prefsFileName)), json.decode(_good));
  });

  test('a whole file is left untouched and becomes the copy, written '
      'through a temporary name', () async {
    named(prefsCopyName).writeAsStringSync('{"flutter.theme_mode":"light"}');
    named(prefsFileName).writeAsStringSync(_good);
    final before = named(prefsFileName).lastModifiedSync();

    expect(await guard.check(), PrefsCheck.healthy);
    expect(named(prefsFileName).readAsStringSync(), _good);
    expect(named(prefsFileName).lastModifiedSync(), before);
    expect(named(prefsCopyName).readAsStringSync(), _good);
    expect(names(), {prefsCopyName, prefsFileName});
  });

  test('a broken file with no good copy is put aside, so the app starts '
      'with no settings instead of failing at every start', () async {
    named(prefsFileName).writeAsStringSync('{"flutter.a');
    expect(await guard.check(), PrefsCheck.lost);
    expect(named(prefsFileName).existsSync(), isFalse);
    expect(_pluginRead(named(prefsFileName)), isEmpty);
    expect(
      named('shared_preferences.broken-2026-11-25_090000.json').existsSync(),
      isTrue,
    );
  });

  test('a missing file is not brought back: the plugin never deletes it, '
      'so it was removed on purpose', () async {
    named(prefsCopyName).writeAsStringSync(_good);
    expect(await guard.check(), PrefsCheck.none);
    expect(named(prefsFileName).existsSync(), isFalse);
  });

  test('a refresh that meets a broken file keeps the copy it has', () async {
    named(prefsFileName).writeAsStringSync(_good);
    await guard.check();
    named(prefsFileName).writeAsStringSync('{"flutter.tags');
    await guard.refresh();
    expect(named(prefsCopyName).readAsStringSync(), _good);

    named(prefsFileName).writeAsStringSync('{"flutter.theme_mode":"system"}');
    await guard.refresh();
    expect(
      named(prefsCopyName).readAsStringSync(),
      '{"flutter.theme_mode":"system"}',
    );
  });
}
