import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_transcripts/vh_transcripts.dart';
import 'package:vidhoist_desktop/data/downloads_data.dart';
import 'package:vidhoist_desktop/data/library_data.dart';
import 'package:vidhoist_desktop/data/pc_link_host.dart';
import 'package:vidhoist_desktop/data/transcripts_data.dart';

/// What a paired phone reads of a clip to watch or copy it: the file and
/// the transcripts, asked for by the clip's id and never by a path.
void main() {
  late Directory dir;
  late DesktopPcHost host;
  late LibraryItem web;
  late LibraryItem folder;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('vh_host');
    final clip = File('${dir.path}/clip.webm')..writeAsBytesSync([1, 2, 3]);
    final song = File('${dir.path}/song.mp3')..writeAsBytesSync([4]);
    web = LibraryItem(
      canonicalUrl: 'https://youtu.be/abc',
      title: 'Clip',
      localPath: clip.path,
    );
    folder = LibraryItem(
      canonicalUrl: song.path,
      title: 'Song',
      localPath: song.path,
    );
    final store = TranscriptStore(Directory('${dir.path}/transcripts'));
    await store.write(
      Transcript(
        canonicalUrl: web.canonicalUrl,
        language: 'ar',
        source: 'captions',
        fetchedAt: DateTime.utc(2026),
        segments: const [
          TranscriptSegment(
            start: Duration.zero,
            end: Duration(seconds: 1),
            text: 'مرحباً',
          ),
        ],
      ),
    );
    final container = ProviderContainer(
      overrides: [
        downloadEngineProvider.overrideWithValue(null),
        libraryItemsProvider.overrideWith((ref) async => [web, folder]),
        transcriptStoreProvider.overrideWithValue(store),
      ],
    );
    addTearDown(container.dispose);
    host = container.read(
      Provider((ref) => DesktopPcHost(ref, name: 'PC', version: '1')),
    );
  });

  tearDown(() => dir.delete(recursive: true));

  test('the file of a clip, by its id alone', () async {
    expect((await host.file(pcItemId(web)))?.path, web.localPath);
    expect(await host.file('not-an-id'), isNull);
    expect(await host.file(web.localPath!), isNull, reason: 'no path asked');
  });

  test('its transcripts, as the phone reads them', () async {
    final kept = await host.transcripts(pcItemId(web));
    expect(Transcript.fromJson(kept.single)!.segments.single.text, 'مرحباً');
    expect(await host.transcripts(pcItemId(folder)), isEmpty);
  });

  test('**the guard**: a clip keyed by its path does not send the path', () {
    final item = pcItemOf(folder);
    expect(item.url, isNull);
    expect(item.extension, 'mp3');
    expect(item.toJson().toString(), isNot(contains(dir.path)));
    expect(pcItemOf(web).url, 'https://youtu.be/abc');
    expect(pcItemOf(web).extension, 'webm');
  });

  group('the library as the phone asks for it', () {
    LibraryItem clip(
      String title, {
      String? uploader,
      int day = 1,
      int? size,
      bool audio = false,
      bool file = true,
    }) => LibraryItem(
      canonicalUrl: 'https://youtu.be/$title',
      title: title,
      uploader: uploader,
      timestamp: DateTime(2026, 11, day),
      sizeBytes: size,
      isAudio: audio,
      localPath: file ? '/clips/$title' : null,
    );

    final all = [
      clip('رحلة إلى أسوان', uploader: 'قناة السفر', day: 3, size: 900),
      clip('Rust for beginners', day: 5, size: 300),
      clip('بودكاست التاريخ', day: 1, audio: true),
      clip('Only on the web', day: 9, file: false),
    ];
    List<String> titles(List<LibraryItem> items) => [
      for (final i in items) i.title,
    ];

    test('**the guard**: a word typed without its hamza or marks finds the '
        'title written with them, in the channel too', () {
      expect(titles(pcLibraryOrder(all, query: 'اسوان')), ['رحلة إلى أسوان']);
      expect(titles(pcLibraryOrder(all, query: 'السَّفر')), ['رحلة إلى أسوان']);
      expect(titles(pcLibraryOrder(all, query: 'RUST beginners')), [
        'Rust for beginners',
      ]);
    });

    test('**the guard**: each order and kind, files on the computer only', () {
      expect(titles(pcLibraryOrder(all)), [
        'Rust for beginners',
        'رحلة إلى أسوان',
        'بودكاست التاريخ',
      ]);
      expect(
        titles(pcLibraryOrder(all, sort: PcLibrarySort.oldest)).first,
        'بودكاست التاريخ',
      );
      expect(
        titles(pcLibraryOrder(all, sort: PcLibrarySort.title)).first,
        'Rust for beginners',
      );
      // A size not known goes last.
      expect(titles(pcLibraryOrder(all, sort: PcLibrarySort.size)), [
        'رحلة إلى أسوان',
        'Rust for beginners',
        'بودكاست التاريخ',
      ]);
      expect(titles(pcLibraryOrder(all, kind: PcLibraryKind.audio)), [
        'بودكاست التاريخ',
      ]);
      expect(pcLibraryOrder(all, kind: PcLibraryKind.video), hasLength(2));
    });
  });
}
