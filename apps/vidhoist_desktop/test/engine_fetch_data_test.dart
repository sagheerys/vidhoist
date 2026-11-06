import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_core/mt_core.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/engine_fetch_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vidhoist_desktop/platform/engine_fetcher.dart';
import 'package:vidhoist_desktop/platform/engine_locator.dart';
import 'package:vidhoist_desktop/platform/engine_pins.dart';

/// What the screens see of a fetch: its share while it runs, the part
/// found once it is done, a failure kept to show; and ffmpeg and Deno
/// fetched by themselves the first time a download needs them.
void main() {
  late Directory root;
  late EngineLocator locator;
  final bytes = utf8.encode('archive');
  var fail = false;
  late List<EnginePart> fetched;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('vh_fetch_');
    locator = EngineLocator(ownFolder: '${root.path}\\engine', pathFolders: []);
    fail = false;
    fetched = [];
  });
  tearDown(() => root.delete(recursive: true));

  ProviderContainer container() {
    final fetcher = EngineFetcher(
      locator: locator,
      pins: {
        for (final part in EnginePart.values)
          part: PinnedAsset(
            part: part,
            version: '1',
            url: Uri.parse('https://example.com/${part.name}.zip'),
            sha256: sha256.convert(bytes).toString(),
          ),
      },
      download: (url) async {
        if (fail) throw const SocketException('offline');
        fetched.add(
          EnginePart.values.byName(url.pathSegments.last.split('.').first),
        );
        return (length: bytes.length, bytes: Stream.value(bytes));
      },
      unpack: (zip, into) async {
        for (final name in ['ffmpeg.exe', 'ffprobe.exe', 'deno.exe']) {
          File('${into.path}\\$name').writeAsStringSync(name);
        }
      },
    );
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        engineLocatorProvider.overrideWithValue(locator),
        engineFetcherProvider.overrideWithValue(fetcher),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('a fetch shows its share, then the part is found', () async {
    final c = container();
    final shares = <double?>[];
    c.listen(
      engineFetchProvider,
      (_, now) => shares.add(now[EnginePart.deno]?.fraction),
    );
    expect(c.read(enginePathsProvider).deno, isNull);
    expect(
      await c.read(engineFetchProvider.notifier).fetch(EnginePart.deno),
      isTrue,
    );
    expect(shares, contains(1.0));
    expect(c.read(engineFetchProvider)[EnginePart.deno], isNull);
    expect(c.read(enginePathsProvider).deno, isNotNull);
  });

  test('a failure is kept, for the engine line to say', () async {
    fail = true;
    final c = container();
    expect(
      await c.read(engineFetchProvider.notifier).fetch(EnginePart.ffmpeg),
      isFalse,
    );
    expect(
      c.read(engineFetchProvider)[EnginePart.ffmpeg]!.failure,
      FetchFailure.network,
    );
  });

  test('a download first fetches what is missing, once', () async {
    final c = container();
    final notifier = c.read(engineFetchProvider.notifier);
    await Future.wait([notifier.ensure(), notifier.ensure()]);
    expect(fetched, [EnginePart.ffmpeg, EnginePart.deno]);
    await notifier.ensure();
    expect(fetched, hasLength(2));
  });

  test(
    'a part that failed on its own is not tried at every download',
    () async {
      fail = true;
      final c = container();
      final notifier = c.read(engineFetchProvider.notifier);
      await notifier.ensure();
      fail = false;
      await notifier.ensure();
      expect(fetched, isEmpty);
      // Asked for by the person, it is tried again.
      expect(await notifier.fetch(EnginePart.ffmpeg), isTrue);
    },
  );
}
