import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/data/library_data.dart';
import 'package:vidhoist_desktop/data/shapes/shapes_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_media/vh_media.dart' show MediaShape;

late Directory _root;

/// A clip with its file on this computer, unless it is not [here].
LibraryItem _clip(String id, {Duration? duration, bool here = true}) =>
    LibraryItem(
      canonicalUrl: 'https://youtu.be/$id',
      title: id,
      localPath: here
          ? (File('${_root.path}\\$id.mp4')..writeAsBytesSync([1])).path
          : null,
      duration: duration,
      timestamp: DateTime(2026, 11, 1),
    );

/// **Every clip's length in the library** (owner's request 2026-11-04): the
/// history holds none, so a clip never played on this computer showed no
/// length. Its header is read in the background, as the phone's enricher
/// does.
void main() {
  setUpAll(() => _root = Directory.systemTemp.createTempSync('ember_shape_'));
  tearDownAll(() => _root.deleteSync(recursive: true));

  group('which clips are read, and where', () {
    test('only those with no length yet and a file to read', () {
      final items = [
        _clip('known', duration: const Duration(minutes: 3)),
        _clip('unknown'),
        _clip('nowhere', here: false),
        _clip('tried'),
      ];
      expect(
        [
          for (final i in shapeCandidates(items, {'https://youtu.be/tried'}))
            i.title,
        ],
        ['unknown'],
      );
    });

    test('**the guard**: a file here is read in place with no header; a '
        'file gone is not read at all', () {
      final local = shapeSourceOf(_clip('a'))!;
      expect(local.url, endsWith('a.mp4'));
      expect(local.headers, isEmpty);
      final gone = LibraryItem(
        canonicalUrl: 'https://youtu.be/b',
        title: 'b',
        localPath: '${_root.path}\\gone.mp4',
      );
      expect(shapeSourceOf(gone), isNull);
    });
  });

  group('learning in the background', () {
    late MemoryKeyValueStore store;
    setUp(() => store = MemoryKeyValueStore());

    ProviderContainer make(List<LibraryItem> items, ShapeProbe probe) {
      final container = ProviderContainer(
        overrides: [
          keyValueStoreProvider.overrideWithValue(store),
          libraryItemsProvider.overrideWith((ref) async => items),
          shapeProbeProvider.overrideWithValue(probe),
          shapeProbeGapProvider.overrideWithValue(Duration.zero),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    Future<Map<String, MediaShape>> learned(ProviderContainer c) async {
      c.read(shapeEnrichmentProvider);
      await c.read(libraryItemsProvider.future);
      for (var i = 0; i < 50; i++) {
        await Future<void>.delayed(Duration.zero);
      }
      return c.read(mediaShapeIndexProvider).readAll();
    }

    test('**the guard**: a clip never played gets its length and shape, and '
        'is kept so it is read once', () async {
      final asked = <String>[];
      final c = make([_clip('a'), _clip('b')], (url, headers) async {
        asked.add(url);
        return const ProbedShape(
          duration: Duration(minutes: 4, seconds: 2),
          aspectRatio: 16 / 9,
        );
      });
      final shapes = await learned(c);
      expect(shapes['https://youtu.be/a']!.duration.inSeconds, 242);
      expect(shapes['https://youtu.be/b']!.aspectRatio, closeTo(16 / 9, 1e-9));
      expect(asked, hasLength(2));
    });

    test('sound alone is kept with a square shape, as on the phone', () async {
      final c = make(
        [_clip('song')],
        (url, headers) async =>
            const ProbedShape(duration: Duration(minutes: 3)),
      );
      final shapes = await learned(c);
      expect(shapes['https://youtu.be/song']!.aspectRatio, 1);
    });

    test('**the guard**: files that cannot be read are left after six '
        'misses, and those are asked again later', () async {
      var asked = 0;
      final c = make([for (var i = 0; i < 10; i++) _clip('c$i')], (
        url,
        headers,
      ) async {
        asked++;
        return null;
      });
      expect(await learned(c), isEmpty);
      expect(asked, 6);

      c.invalidate(libraryItemsProvider);
      await learned(c);
      expect(asked, 12);
    });

    test('with no engine (a test or a failed start) nothing is read', () async {
      final c = ProviderContainer(
        overrides: [
          keyValueStoreProvider.overrideWithValue(store),
          libraryItemsProvider.overrideWith((ref) async => [_clip('a')]),
        ],
      );
      addTearDown(c.dispose);
      c.read(shapeEnrichmentProvider);
      await c.read(libraryItemsProvider.future);
      expect(await c.read(mediaShapeIndexProvider).readAll(), isEmpty);
    });
  });
}
