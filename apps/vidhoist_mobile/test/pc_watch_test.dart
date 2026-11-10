import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_transcripts/vh_transcripts.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/pc/pc_copy.dart';
import 'package:vidhoist_mobile/features/pc/pc_link_state.dart';
import 'package:vidhoist_mobile/features/pc/pc_pairing_store.dart';
import 'package:vidhoist_mobile/features/pc/pc_screen.dart';
import 'package:vidhoist_mobile/features/pc/pc_stream.dart';
import 'package:vidhoist_mobile/features/player/sidecar_subtitles.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';

import 'pc_link_test.dart' show FakeApi;

const _pairing = PcPairing(
  host: '192.168.1.24',
  port: PcLink.defaultPort,
  fingerprint:
      '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef',
  deviceId: 'dev1',
  secret: 'the-secret',
  name: 'HOME-PC',
);

const _clip = PcItem(
  id: 'i1',
  title: 'Rust for TypeScript devs',
  url: 'https://youtu.be/rust',
  extension: 'webm',
  thumbnail: 'https://i.ytimg.com/vi/rust/hq.jpg',
);

Map<String, Object?> _transcript(String language, String text) => Transcript(
  canonicalUrl: _clip.url!,
  language: language,
  source: 'captions',
  fetchedAt: DateTime.utc(2026),
  segments: [
    TranscriptSegment(
      start: Duration.zero,
      end: const Duration(seconds: 2),
      text: text,
    ),
  ],
).toJson();

/// Batch B of the link: a clip on the computer played on the phone through
/// the proxy, copied into the phone's library, and its transcripts shown.
void main() {
  final l = lookupVhLocalizations(const Locale('en'));
  late MemoryKeyValueStore store;
  late Directory dir;
  late FakeApi api;

  setUp(() async {
    store = MemoryKeyValueStore();
    dir = await Directory.systemTemp.createTemp('vh_pc_copy');
    api = FakeApi()
      ..files = {'i1': List<int>.generate(4096, (i) => i % 256)}
      ..kept = {
        'i1': [_transcript('ar', 'مرحباً'), _transcript('en', 'Hello')],
      };
  });

  tearDown(() => dir.delete(recursive: true));

  List<Override> overrides({String? locale}) => [
    keyValueStoreProvider.overrideWithValue(store),
    secretStoreProvider.overrideWithValue(MemorySecretStore()),
    prefsMutexProvider.overrideWithValue(PrefsMutex()),
    initialSettingsProvider.overrideWithValue(
      PhoneSettings(localeCode: locale),
    ),
    loggerProvider.overrideWithValue(
      VhLogger(filePath: '${Directory.systemTemp.path}/vh_pc_watch.log'),
    ),
    initialPcPairingProvider.overrideWithValue(_pairing),
    pcClientProvider.overrideWith((ref) => api),
    pcCopyDirProvider.overrideWithValue(dir.path),
  ];

  ProviderContainer container({String? locale}) {
    final c = ProviderContainer(overrides: overrides(locale: locale));
    addTearDown(c.dispose);
    return c;
  }

  List<String> names() =>
      [for (final f in dir.listSync()) f.uri.pathSegments.last]..sort();

  group('watching', () {
    test('a computer clip plays from the proxy, keyed by its link', () async {
      final proxy = PcStreamProxy(() => api);
      await proxy.start();
      addTearDown(proxy.stop);
      final resolver = PlaybackSourceResolver(
        endpoint: pcStreamEndpoint(proxy),
        fileExists: (_) => false,
      );
      final item = pcPlaylistItem(_clip);
      expect(item.canonicalUrl, 'https://youtu.be/rust');
      final source = resolver.resolve(item)!;
      expect(source.isLocal, isFalse);
      expect(source.uri, proxy.urlFor('i1'));
      expect(source.uri.host, '127.0.0.1');
    });

    test('**the guard**: a copy on the phone plays the file instead', () {
      final proxy = PcStreamProxy(() => api);
      final resolver = PlaybackSourceResolver(
        endpoint: pcStreamEndpoint(proxy),
        fileExists: (path) => path == '/phone/rust.webm',
      );
      final source = resolver.resolve(
        pcPlaylistItem(_clip, onPhone: '/phone/rust.webm'),
      )!;
      expect(source.isLocal, isTrue);
    });

    test('**the guard**: a phone file gone from outside stays unplayable, '
        'not an address on the computer', () async {
      final proxy = PcStreamProxy(() => api);
      await proxy.start();
      addTearDown(proxy.stop);
      final resolver = PlaybackSourceResolver(
        endpoint: pcStreamEndpoint(proxy),
        fileExists: (_) => false,
      );
      const gone = PlaylistItem(
        canonicalUrl: 'https://youtu.be/gone',
        title: 'Gone',
        localPath: '/phone/gone.mp4',
        serverFilename: 'Music/gone.mp4',
      );
      expect(resolver.resolve(gone), isNull);
    });

    test('a clip from the computer shows its transcripts, the reader\'s '
        'language first', () async {
      final c = container(locale: 'en');
      final key = pcPlaylistItem(_clip).serverFilename!;
      c.read(subtitleCacheProvider.notifier).wantFromPc(key, 'i1');
      await pumpEventQueue();
      final tracks = c.read(subtitleCacheProvider)[key]!;
      expect(tracks.keys, ['en', 'ar']);
      expect(tracks['ar']!.single.text, 'مرحباً');
    });

    test('a computer out of reach gives no captions, and no error', () async {
      api.reachable = false;
      final c = container();
      c.read(subtitleCacheProvider.notifier).wantFromPc('vh-pc:i1', 'i1');
      await pumpEventQueue();
      expect(c.read(subtitleCacheProvider)['vh-pc:i1'], isEmpty);
    });
  });

  group('copying to the phone', () {
    test('the file, its subtitles beside it, and the library told', () async {
      final c = container();
      expect(
        await c.read(pcCopiesProvider.notifier).copy(_clip),
        PcCopyEnd.copied,
      );
      final files = names();
      expect(files, hasLength(3));
      final media = files.singleWhere((n) => n.endsWith('.webm'));
      expect(media, startsWith('Rust for TypeScript devs_'));
      final stem = media.substring(0, media.length - 5);
      expect(files, containsAll(['$stem.ar.vtt', '$stem.en.vtt']));
      expect(File('${dir.path}/$media').readAsBytesSync(), api.files['i1']);
      final ar = sidecarSubtitleFiles('${dir.path}/$media');
      expect(ar, hasLength(2));
      final offline = await c.read(offlineIndexProvider).readAll();
      expect(offline['https://youtu.be/rust'], '${dir.path}/$media');
      final titles = await c.read(titleIndexProvider).readAll();
      expect(titles['https://youtu.be/rust'], 'Rust for TypeScript devs');
      expect(c.read(pcCopiesProvider), isEmpty);
    });

    test('**the guard**: a copy cut off leaves nothing behind', () async {
      api.files = {'i1': List<int>.filled(100, 1)};
      final c = container();
      // The computer says more than it sends: the link dropped mid-file.
      final short = _ShortApi(api);
      final cc = ProviderContainer(
        overrides: [
          ...overrides(),
          pcClientProvider.overrideWith((_) => short),
        ],
      );
      addTearDown(cc.dispose);
      expect(
        await cc.read(pcCopiesProvider.notifier).copy(_clip),
        PcCopyEnd.failed,
      );
      expect(names(), isEmpty);
      expect(await c.read(offlineIndexProvider).readAll(), isEmpty);
    });

    test('stopped, nothing is kept', () async {
      final c = container();
      final copies = c.read(pcCopiesProvider.notifier);
      final done = copies.copy(_clip);
      copies.stop('i1');
      expect(await done, PcCopyEnd.stopped);
      expect(names(), isEmpty);
    });

    test(
      '**the guard**: a language that is not one names no other file',
      () async {
        api.kept = {
          'i1': [_transcript('/../../evil', 'x'), _transcript('ar', 'ok')],
        };
        await container().read(pcCopiesProvider.notifier).copy(_clip);
        expect(names().where((n) => n.endsWith('.vtt')), hasLength(1));
        expect(
          Directory(dir.parent.path)
              .listSync()
              .where((f) => f.path.endsWith('.vtt')),
          isEmpty,
        );
      },
    );
  });

  testWidgets('a clip\'s menu offers watching and copying', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides(),
        child: MaterialApp(
          theme: vhTheme(VhVariant.phone, Brightness.light),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: const Scaffold(body: PcScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l.itemOptions).first);
    await tester.pumpAndSettle();
    expect(find.text(l.pcWatch), findsOneWidget);
    expect(find.text(l.pcCopyToPhone), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}

/// The computer that promises a length and sends less.
class _ShortApi extends FakeApi {
  _ShortApi(this.inner);

  final FakeApi inner;

  @override
  Future<PcFileResponse> file(String id, {String? range}) async =>
      PcFileResponse(
        statusCode: 200,
        headers: const {'content-length': '5000'},
        body: Stream.value(List<int>.filled(100, 1)),
      );

  @override
  Future<List<Object?>> transcripts(String id) async => const [];
}
