import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';

void main() {
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('vh_recovery');
  });

  tearDown(() async {
    await root.delete(recursive: true);
  });

  File put(String relative, [String body = 'x']) {
    final file = File('${root.path}/$relative');
    file.parent.createSync(recursive: true);
    return file..writeAsStringSync(body);
  }

  Future<RecoveryScan> scan({
    Set<String> paths = const {},
    Set<String> urls = const {},
  }) => LibraryRecovery.scan(root.path, knownPaths: paths, knownUrls: urls);

  test('a YouTube file is found by the id at the end of its name', () async {
    put('Some talk [Ekrbvyw94A0].mp4', 'video');
    final result = await scan();
    expect(result.found, hasLength(1));
    final f = result.found.single;
    expect(f.url, 'https://www.youtube.com/watch?v=Ekrbvyw94A0');
    expect(f.title, 'Some talk');
    expect(f.sizeBytes, 5);
    expect(f.folder, isNull);
    expect(f.isAudio, isFalse);
  });

  test('the info JSON beside a file names any site', () async {
    put('A song [2070939652].m4a');
    put(
      'A song [2070939652].info.json',
      jsonEncode({
        'webpage_url': 'https://soundcloud.com/someone/a-song',
        'title': 'A song, properly',
        'uploader': 'someone',
      }),
    );
    final f = (await scan()).found.single;
    expect(f.url, 'https://soundcloud.com/someone/a-song');
    expect(f.title, 'A song, properly');
    expect(f.uploader, 'someone');
    expect(f.isAudio, isTrue);
    expect(f.infoJsonPath, endsWith('A song [2070939652].info.json'));
  });

  test('**the guard**: a file whose link cannot be told is left out, never '
      'given an invented one', () async {
    put('left.mp4');
    put('A song [2070939652].m4a');
    final result = await scan();
    expect(result.found, isEmpty);
    expect(result.unknown, hasLength(2));
  });

  test("**the guard**: an Instagram post's eleven-character id is not taken "
      "for YouTube's (a real folder held two)", () async {
    // Ends with a character a YouTube id never ends with.
    put('Video by growwithazab [DfcylhUo7gp].mp4');
    // Ends with one it may, but carries Instagram's own caption-less title.
    put('Video by someone [DfcylhUo7gk].mp4');
    final result = await scan();
    expect(result.found, isEmpty);
    expect(result.unknown, hasLength(2));
  });

  test(
    "a file the person's own records name takes the link they keep",
    () async {
      put('A song [2070939652].m4a');
      final f = (await LibraryRecovery.scan(
        root.path,
        knownPaths: const {},
        knownUrls: const {},
        linksByName: {
          '/audio_download/A SONG [2070939652].m4a':
              'https://soundcloud.com/someone/a-song',
        },
      )).found.single;
      expect(f.url, 'https://soundcloud.com/someone/a-song');
      expect(f.title, 'A song');
    },
  );

  test('channel subfolders are searched, and recorded as the folder', () async {
    put('Some channel/Clip [abcdefghijk].mp4');
    final f = (await scan()).found.single;
    expect(f.folder, 'Some channel');
  });

  test('half of a merge left behind is not a clip', () async {
    put('Clip [TSJtkRabws8].f399.mp4');
    final result = await scan();
    expect(result.found, isEmpty);
    expect(result.unknown, isEmpty);
  });

  test("the app's own folders and other files are skipped", () async {
    put('For the phone/vidhoist_2026.json');
    put('Backups/vidhoist_2026.json');
    put('Clip [abcdefghijk].en.vtt');
    put('Clip [abcdefghijk].jpg');
    final result = await scan();
    expect(result.found, isEmpty);
    expect(result.unknown, isEmpty);
  });

  test(
    'what the library lists already, by path or by link, stays as it is',
    () async {
      final listed = put('Listed [abcdefghijk].mp4');
      put('Same clip again [lmnopqrstuw].mp4');
      final result = await scan(
        paths: {listed.path.toUpperCase().replaceAll('/', r'\')},
        urls: {'https://www.youtube.com/watch?v=lmnopqrstuw'},
      );
      expect(result.found, isEmpty);
    },
  );

  test('two files of one clip give one entry', () async {
    put('Clip [abcdefghijk].mp4');
    put('Clip (1) [abcdefghijk].mp4');
    expect((await scan()).found, hasLength(1));
  });

  test('a missing folder finds nothing', () async {
    final result = await LibraryRecovery.scan(
      '${root.path}/nowhere',
      knownPaths: const {},
      knownUrls: const {},
    );
    expect(result.found, isEmpty);
    expect(result.unknown, isEmpty);
  });

  group('recorded in the library', () {
    test('as a download records them, once', () async {
      final store = MemoryKeyValueStore();
      final history = LocalHistoryStore(store);
      put('Clip [abcdefghijk].mp4', 'video');
      put('Channel/Tune [lmnopqrstuw].m4a', 'audio');
      final found = (await scan()).found;

      expect(await history.recordRecovered(found), 2);
      expect(await history.recordRecovered(found), 0);

      final entries = await history.entries();
      expect(entries, hasLength(2));
      final tune = entries.firstWhere((e) => e.path.endsWith('.m4a'));
      expect(
        tune.item.canonicalUrl,
        'https://www.youtube.com/watch?v=lmnopqrstuw',
      );
      expect(tune.item.title, 'Tune');
      expect(tune.item.downloadType, 'audio');
      expect(tune.item.folder, 'Channel');
    });
  });
}
