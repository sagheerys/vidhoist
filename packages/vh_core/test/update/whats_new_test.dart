import 'dart:convert';

import 'package:vh_core/vh_core.dart';
import 'package:test/test.dart';

/// The shape of a real release page (v2.2.1, shortened): English, a rule,
/// then the Arabic summary.
const _notes = '''
A fix release for both apps. It installs over 2.2.0 and keeps your
settings and library.

## Fixed

- **The notification buttons no longer stop responding.**

## Which file

| | |
|---|---|
| **Vidhoist-2.2.1-android.apk** | For family and friends. |

The details are in [CHANGELOG.md](https://example.org/CHANGELOG.md).

---

**بالعربية:** إصدار إصلاح للتطبيقين، يُثبَّت فوق 2.2.0.

- **أزرار الإشعار لم تعد تتوقف عن الاستجابة.**
''';

void main() {
  group('the notes in the reader\'s language', () {
    test('an Arabic interface gets the Arabic summary alone', () {
      final ar = vhReleaseNotesFor(_notes, arabic: true);
      expect(ar, startsWith('إصدار إصلاح للتطبيقين'));
      expect(ar, contains('أزرار الإشعار'));
      expect(ar, isNot(contains('Fixed')));
      expect(ar, isNot(contains('بالعربية')));
    });

    test('any other gets the English, without the download guide', () {
      final en = vhReleaseNotesFor(_notes, arabic: false);
      expect(en, startsWith('A fix release'));
      expect(en, contains('## Fixed'));
      expect(en, contains('no longer stop responding'));
      expect(en, isNot(contains('Which file')));
      expect(en, isNot(contains('.apk')));
      expect(en, isNot(contains('CHANGELOG')));
      expect(en, isNot(contains('بالعربية')));
    });

    test('notes without an Arabic half are shown whole', () {
      const plain = 'Fixes.\n\n---\n\nMore fixes.';
      expect(vhReleaseNotesFor(plain, arabic: true), plain);
      expect(vhReleaseNotesFor('Fixes only.', arabic: false), 'Fixes only.');
    });
  });

  group('the notes for the app reading them', () {
    // Shaped like the 2.1.0 and 2.2.0 pages: items marked for one app at
    // the start or the end, a continuation line, and a lead whose list is
    // all for the other app.
    const mixed = '''
## Added

- **Vidhoist Windows: follow a channel, and its new videos arrive by
  themselves.** Settings, Subscriptions.
- **Vidhoist Phone finishes, at the next launch, the downloads it could not.**
- **The details show what a file really is.** Both apps.
- **"View all" leaves full screen first**, instead of
  opening it over a player still locked sideways. Vidhoist Windows.

## Only in Windows

- **Vidhoist Windows: cookies from the browser.**

---

**بالعربية:** إصدار للتطبيقين.

- **Windows — تابع قناة وتصلك مقاطعها الجديدة وحدها.**
- **Phone — يُكمل عند الفتح التالي ما لم يستطع إكماله.**
- **التفاصيل تعرض جودة الملف الحقيقية.**

**ومن كان على 2.1.0 يحصل أيضاً على الجديد منذها:**

- **Windows — الكوكيز من المتصفح.**
- **إشعار عند الوصول (Windows).**
- **مزامنة أسرع، Windows وحده.**
''';

    test('Phone leaves out what only Windows has', () {
      final en = vhReleaseNotesFor(mixed, arabic: false, app: 'phone');
      expect(en, contains('Vidhoist Phone finishes'));
      expect(en, contains('what a file really is'));
      expect(en, isNot(contains('follow a channel')));
      expect(en, isNot(contains('themselves')));
      expect(en, isNot(contains('View all')));
      expect(en, isNot(contains('locked sideways')));
      expect(en, isNot(contains('cookies')));
      expect(en, isNot(contains('Only in Windows')));

      final ar = vhReleaseNotesFor(mixed, arabic: true, app: 'phone');
      expect(ar, contains('Phone — يُكمل'));
      expect(ar, contains('جودة الملف'));
      expect(ar, isNot(contains('تابع قناة')));
      expect(ar, isNot(contains('الكوكيز')));
      expect(ar, isNot(contains('ومن كان على 2.1.0')));
      // A marker at the end of a bullet that is bold throughout.
      expect(ar, isNot(contains('إشعار عند الوصول')));
      expect(ar, isNot(contains('مزامنة أسرع')));
    });

    test('Windows leaves out what only Phone has, and keeps its own', () {
      final en = vhReleaseNotesFor(mixed, arabic: false, app: 'windows');
      expect(en, contains('follow a channel'));
      expect(en, contains('View all'));
      expect(en, contains('cookies'));
      expect(en, isNot(contains('Vidhoist Phone finishes')));

      final ar = vhReleaseNotesFor(mixed, arabic: true, app: 'windows');
      expect(ar, contains('تابع قناة'));
      expect(ar, contains('ومن كان على 2.1.0'));
      expect(ar, isNot(contains('يُكمل عند الفتح')));
    });

    test('without an app the notes are whole, as before', () {
      expect(
        vhReleaseNotesFor(mixed, arabic: false),
        contains('Vidhoist Windows: follow a channel'),
      );
    });
  });

  group('what\'s new, once after an update', () {
    late MemoryKeyValueStore store;
    late UpdatePrefs prefs;
    late List<Uri> fetched;
    String? remoteNotes;

    WhatsNewService service() => WhatsNewService(
      prefs: prefs,
      checker: UpdateChecker(
        assetMarker: 'super',
        repo: 'owner/app',
        fetch: (uri) async {
          fetched.add(uri);
          if (remoteNotes == null) throw Exception('offline');
          return json.encode({'tag_name': 'v2.3.0', 'body': remoteNotes});
        },
      ),
    );

    setUp(() {
      store = MemoryKeyValueStore();
      prefs = UpdatePrefs(store: store, mutex: PrefsMutex());
      fetched = [];
      remoteNotes = 'From the page.';
    });

    test('a fresh install shows nothing, now or on the next launch', () async {
      expect(
        await service().pending(currentVersion: '2.3.0', upgraded: false),
        isNull,
      );
      expect(await prefs.lastSeenVersion(), '2.3.0');
      expect(
        await service().pending(currentVersion: '2.3.0', upgraded: true),
        isNull,
      );
      expect(fetched, isEmpty);
    });

    test(
      'the first version with the feature still greets an upgrade',
      () async {
        final shown = await service().pending(
          currentVersion: '2.3.0',
          upgraded: true,
        );
        expect(shown!.version, '2.3.0');
        expect(shown.notes, 'From the page.');
        expect(
          fetched.single.toString(),
          'https://api.github.com/repos/owner/app/releases/tags/v2.3.0',
        );
        expect(
          shown.pageUrl,
          'https://github.com/owner/app/releases/tag/v2.3.0',
        );
      },
    );

    test('notes saved at the check are used without a network', () async {
      await prefs.setLastSeenVersion('2.2.1');
      await prefs.saveNotes('2.3.0', 'Saved before the update.');
      remoteNotes = null;
      final shown = await service().pending(
        currentVersion: '2.3.0',
        upgraded: true,
      );
      expect(shown!.notes, 'Saved before the update.');
      expect(fetched, isEmpty);
    });

    test('notes saved for another version are not shown as these', () async {
      await prefs.setLastSeenVersion('2.2.0');
      await prefs.saveNotes('2.2.1', 'The old notes.');
      final shown = await service().pending(
        currentVersion: '2.3.0',
        upgraded: true,
      );
      expect(shown!.notes, 'From the page.');
    });

    test('offline with nothing saved, it offers the page alone', () async {
      await prefs.setLastSeenVersion('2.2.1');
      remoteNotes = null;
      final shown = await service().pending(
        currentVersion: '2.3.0',
        upgraded: true,
      );
      expect(shown!.notes, isEmpty);
      expect(shown.pageUrl, endsWith('/v2.3.0'));
    });

    test('once seen, never again for that version', () async {
      await prefs.setLastSeenVersion('2.2.1');
      final s = service();
      final shown = await s.pending(currentVersion: '2.3.0', upgraded: true);
      await s.markSeen(shown!.version);
      expect(await s.pending(currentVersion: '2.3.0', upgraded: true), isNull);
    });

    test('asked for, it answers even after the version was seen', () async {
      await prefs.setLastSeenVersion('2.3.0');
      await prefs.saveNotes('2.3.0', 'Saved notes.');
      final notes = await service().of('2.3.0');
      expect(notes!.notes, 'Saved notes.');
      expect(await service().of('dev'), isNull);
    });

    test('a reinstall of an older version shows nothing', () async {
      await prefs.setLastSeenVersion('2.3.0');
      expect(
        await service().pending(currentVersion: '2.2.1', upgraded: true),
        isNull,
      );
    });

    test('an unreadable version shows nothing', () async {
      expect(
        await service().pending(currentVersion: 'dev', upgraded: true),
        isNull,
      );
    });

    test('a broken saved entry costs only the offline copy', () async {
      await prefs.setLastSeenVersion('2.2.1');
      await store.setString(UpdatePrefs.notesKey, '{not json');
      final shown = await service().pending(
        currentVersion: '2.3.0',
        upgraded: true,
      );
      expect(shown!.notes, 'From the page.');
    });
  });
}
