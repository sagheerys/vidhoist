import 'dart:convert';

import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';

/// A release page as the apps used to show it: English for visitors, with
/// the table of files, and no Arabic half.
const _page = '''
**A fix release.**

| File | For |
|---|---|
| `Vidhoist-1.2.0-android-arm64-v8a.apk` | phones |

- Deleting works again.
''';

final _notesFile = json.encode({
  'phone': {
    'en': '- Deleting works again.',
    'ar': '- الحذف يعمل من جديد.',
    'de': '- Löschen funktioniert wieder.',
    'fr': '   ',
  },
  'windows': {'en': '- Windows only.'},
});

const _apkUrl =
    'https://github.com/owner/app/releases/download/v1.2.0/Vidhoist-1.2.0-android.apk';
const _notesUrl =
    'https://github.com/owner/app/releases/download/v1.2.0/release-notes.json';

String _release({bool withNotesFile = true}) => json.encode({
  'tag_name': 'v1.2.0',
  'body': _page,
  'html_url': 'https://github.com/owner/app/releases/tag/v1.2.0',
  'assets': [
    {'name': 'Vidhoist-1.2.0-android.apk', 'browser_download_url': _apkUrl},
    if (withNotesFile)
      {'name': 'release-notes.json', 'browser_download_url': _notesUrl},
  ],
});

void main() {
  group('the notes file', () {
    test('gives each app its own part, and skips empty entries', () {
      final phone = vhParseNoteTranslations(_notesFile, 'phone');
      expect(phone.keys, unorderedEquals(['en', 'ar', 'de']));
      expect(vhParseNoteTranslations(_notesFile, 'windows'), {
        'en': '- Windows only.',
      });
    });

    test('a broken file is no translations, never an error', () {
      for (final body in ['', 'nope', '[]', '{"phone": 3}', '{"phone": []}']) {
        expect(vhParseNoteTranslations(body, 'phone'), isEmpty, reason: body);
      }
    });
  });

  group('the language shown', () {
    final translations = vhParseNoteTranslations(_notesFile, 'phone');

    test('is the reader\'s own when the file has it', () {
      expect(
        vhReleaseNotesIn('ar', body: _page, translations: translations),
        '- الحذف يعمل من جديد.',
      );
      expect(
        vhReleaseNotesIn('DE', body: _page, translations: translations),
        '- Löschen funktioniert wieder.',
      );
    });

    test('falls back to the file\'s English, not to the page', () {
      final shown = vhReleaseNotesIn(
        'tr',
        body: _page,
        translations: translations,
      );
      expect(shown, '- Deleting works again.');
      expect(shown, isNot(contains('|')));
    });

    test('is the page, as before, for a release without the file', () {
      expect(vhReleaseNotesIn('ar', body: _page), _page.trim());
    });
  });

  group('the update check', () {
    late List<Uri> fetched;
    late String? notesBody;

    UpdateChecker checker({String? app = 'phone'}) => UpdateChecker(
      assetMarker: 'vidhoist',
      repo: 'owner/app',
      notesApp: app,
      fetch: (uri) async {
        fetched.add(uri);
        if (uri.toString() == _notesUrl) {
          if (notesBody == null) throw Exception('404');
          return notesBody!;
        }
        return _release();
      },
    );

    setUp(() {
      fetched = [];
      notesBody = _notesFile;
    });

    test('reads the notes file of a newer release', () async {
      final release = await checker().check(currentVersion: '1.1.0');
      expect(release!.notesUrl, _notesUrl);
      expect(release.translations['ar'], '- الحذف يعمل من جديد.');
      // The notes file is not this app's download.
      expect(release.apkUrl, _apkUrl);
    });

    test('offers the update all the same when the file fails', () async {
      notesBody = null;
      final release = await checker().check(currentVersion: '1.1.0');
      expect(release, isNotNull);
      expect(release!.translations, isEmpty);
      expect(release.notes, _page);
    });

    test('fetches nothing more when nothing is newer', () async {
      expect(await checker().check(currentVersion: '1.2.0'), isNull);
      expect(fetched.map((u) => u.toString()), isNot(contains(_notesUrl)));
    });

    test('a file served from elsewhere is not read', () async {
      final elsewhere = UpdateChecker(
        assetMarker: 'vidhoist',
        repo: 'owner/app',
        notesApp: 'phone',
        fetch: (uri) async {
          fetched.add(uri);
          return json.encode({
            'tag_name': 'v1.2.0',
            'body': _page,
            'assets': [
              {
                'name': 'Vidhoist-1.2.0-android.apk',
                'browser_download_url': _apkUrl,
              },
              {
                'name': 'release-notes.json',
                'browser_download_url': 'https://example.org/notes.json',
              },
            ],
          });
        },
      );
      final release = await elsewhere.check(currentVersion: '1.1.0');
      expect(release!.notesUrl, isNull);
      expect(fetched, hasLength(1));
    });
  });

  group('"what\'s new"', () {
    late UpdatePrefs prefs;
    late bool online;

    WhatsNewService service() => WhatsNewService(
      prefs: prefs,
      checker: UpdateChecker(
        assetMarker: 'vidhoist',
        repo: 'owner/app',
        notesApp: 'phone',
        fetch: (uri) async {
          if (!online) throw Exception('offline');
          return uri.toString() == _notesUrl ? _notesFile : _release();
        },
      ),
    );

    setUp(() {
      prefs = UpdatePrefs(store: MemoryKeyValueStore(), mutex: PrefsMutex());
      online = true;
    });

    test('keeps the translations saved at the check, offline', () async {
      await prefs.setLastSeenVersion('1.1.0');
      await prefs.saveNotes(
        '1.2.0',
        _page,
        translations: {'ar': '- الحذف يعمل من جديد.'},
      );
      online = false;
      final shown = await service().pending(
        currentVersion: '1.2.0',
        upgraded: true,
      );
      expect(shown!.translations, {'ar': '- الحذف يعمل من جديد.'});
    });

    test('reads the file when nothing was saved', () async {
      final shown = await service().of('1.2.0');
      expect(shown!.notes, _page);
      expect(shown.translations['de'], '- Löschen funktioniert wieder.');
    });

    test('an older save without translations still reads', () async {
      await prefs.saveNotes('1.2.0', _page);
      expect(await prefs.savedTranslationsOf('1.2.0'), isEmpty);
      expect(await prefs.savedNotes(), ('1.2.0', _page));
    });

    test('translations saved for another version are not shown', () async {
      await prefs.saveNotes('1.1.9', 'old', translations: {'ar': 'قديم'});
      expect(await prefs.savedTranslationsOf('1.2.0'), isEmpty);
    });
  });
}
