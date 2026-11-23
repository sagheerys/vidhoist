import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

/// **Every release's notes file speaks every language of the apps.** The
/// file is uploaded beside a release's downloads ([vhNotesAssetName]); a
/// language missing from it shows its readers English, which is what the
/// file exists to prevent.
void main() {
  final folder = Directory('../../docs/release-notes');
  final languages = {
    for (final locale in VhLocalizations.supportedLocales) locale.languageCode,
  };

  test('the folder is there', () => expect(folder.existsSync(), isTrue));

  for (final file
      in folder.existsSync()
          ? folder.listSync().whereType<File>().where(
              (f) => f.path.endsWith('.json'),
            )
          : const <File>[]) {
    final name = file.uri.pathSegments.last;
    test('$name has both apps in all ${languages.length} languages', () {
      expect(
        AppVersion.tryParse(name.replaceAll('.json', '')),
        isNotNull,
        reason: 'named after its version',
      );
      final body = file.readAsStringSync();
      for (final app in ['phone', 'windows']) {
        final notes = vhParseNoteTranslations(body, app);
        expect(notes.keys.toSet(), languages, reason: '$name, $app');
      }
    });
  }
}
