import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';

import 'pc_link_test.dart' show FakeHost;

/// Watching and copying a clip from the computer: its file through the
/// pinned link, whole or by range, and through the proxy the phone's player
/// opens.
void main() {
  final certificate = PcCertificate.generate();
  final bytes = List<int>.generate(5000, (i) => i % 251);
  late FakeHost host;
  late PcPairingWindow window;
  late PcLinkServer server;
  late PcLinkClient client;
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('vh_stream');
    host = FakeHost()
      ..mediaFile = (File('${dir.path}/clip.mp4')..writeAsBytesSync(bytes));
    window = PcPairingWindow(
      store: MemoryPcDeviceStore(),
      fingerprint: certificate.fingerprint,
    );
    await window.load();
    server = PcLinkServer(
      certificate: certificate,
      host: host,
      pairing: window,
      name: 'HOME-PC',
    );
    final port = await server.start(
      address: InternetAddress.loopbackIPv4,
      port: 0,
    );
    final code = window.open();
    final sub = window.requests.listen((r) => r.allow());
    final pairing = await PcLinkClient.pair(
      host: '127.0.0.1',
      port: port,
      code: code,
      phoneName: 'Galaxy',
      onCheck: (_) {},
    );
    await sub.cancel();
    client = PcLinkClient(pairing);
  });

  tearDown(() async {
    client.close();
    await server.stop();
    await window.dispose();
    await dir.delete(recursive: true);
  });

  Future<List<int>> read(PcFileResponse r) async => [
    for (final chunk in await r.body.toList()) ...chunk,
  ];

  group('the file through the link', () {
    test('whole, with its length and type', () async {
      final r = await client.file('i0');
      expect(r.statusCode, 200);
      expect(r.length, 5000);
      expect(r.headers['content-type'], 'video/mp4');
      expect(r.headers['accept-ranges'], 'bytes');
      expect(await read(r), bytes);
    });

    test('a range: exactly those bytes, and where they sit', () async {
      final r = await client.file('i0', range: 'bytes=1000-1999');
      expect(r.statusCode, 206);
      expect(r.headers['content-range'], 'bytes 1000-1999/5000');
      expect(r.length, 1000);
      expect(await read(r), bytes.sublist(1000, 2000));
    });

    test('a range past the end, and a clip that is not a file', () async {
      final past = await client.file('i0', range: 'bytes=9000-');
      expect(past.statusCode, 416);
      expect(past.headers['content-range'], 'bytes */5000');
      await read(past);
      final missing = await client.file('i1');
      expect(missing.statusCode, 404);
      await read(missing);
    });

    test('transcripts come as the computer keeps them', () async {
      final kept = await client.transcripts('i0');
      expect((kept.single as Map)['lang'], 'ar');
      expect(await client.transcripts('i1'), isEmpty);
    });
  });

  group('the proxy the player opens', () {
    late PcStreamProxy proxy;
    PcLinkApi? api;

    setUp(() async {
      api = client;
      proxy = PcStreamProxy(() => api);
      await proxy.start();
    });

    tearDown(() => proxy.stop());

    Future<(int, Map<String, String>, List<int>)> get(
      Uri url, {
      String? range,
    }) async {
      final http = HttpClient();
      addTearDown(() => http.close(force: true));
      final request = await http.getUrl(url);
      if (range != null) request.headers.set('range', range);
      final response = await request.close();
      final body = [for (final c in await response.toList()) ...c];
      return (
        response.statusCode,
        {
          for (final name in PcFileResponse.passed)
            name: ?response.headers.value(name),
        },
        body,
      );
    }

    test('listens on this phone only', () {
      final url = proxy.urlFor('i0')!;
      expect(url.scheme, 'http');
      expect(url.host, '127.0.0.1');
    });

    test('plays a seek: the range goes to the computer and back', () async {
      final (code, headers, body) = await get(
        proxy.urlFor('i0')!,
        range: 'bytes=4000-',
      );
      expect(code, 206);
      expect(headers['content-range'], 'bytes 4000-4999/5000');
      expect(headers['content-type'], 'video/mp4');
      expect(body, bytes.sublist(4000));
      final (whole, _, all) = await get(proxy.urlFor('i0')!);
      expect(whole, 200);
      expect(all, bytes);
    });

    test('**the guard**: without the token there is nothing', () async {
      final url = proxy.urlFor('i0')!;
      final guessed = url.replace(pathSegments: ['not-the-token', 'i0']);
      final bare = url.replace(pathSegments: ['i0']);
      for (final wrong in [guessed, bare]) {
        final (code, _, body) = await get(wrong);
        expect(code, 404, reason: '$wrong');
        expect(utf8.decode(body), isEmpty);
      }
    });

    test('unpaired, or the computer away: the player is told', () async {
      api = null;
      expect((await get(proxy.urlFor('i0')!)).$1, 503);
      await server.stop();
      api = client;
      expect((await get(proxy.urlFor('i0')!)).$1, 502);
    });

    test('a player that leaves mid-file does not stop the next', () async {
      // Big enough to be still under way when the player goes.
      final big = List<int>.generate(8 << 20, (i) => i % 241);
      host.mediaFile!.writeAsBytesSync(big);
      final player = HttpClient();
      final response = await (await player.getUrl(proxy.urlFor('i0')!)).close();
      final got = <int>[];
      final first = Completer<void>();
      final sub = response.listen(
        (chunk) {
          got.addAll(chunk);
          if (!first.isCompleted) first.complete();
        },
        onError: (Object _) {},
        cancelOnError: true,
      );
      await first.future;
      // Gone, as a seek leaves: the connection cut, not the file read.
      player.close(force: true);
      await sub.cancel();
      expect(got.length, lessThan(big.length));
      final (code, _, body) = await get(
        proxy.urlFor('i0')!,
        range: 'bytes=0-9',
      );
      expect(code, 206);
      expect(body, big.sublist(0, 10));
    });

    test('a name it plays, and the names it does not', () {
      expect(PcStreamProxy.idOf('vh-pc:abc'), 'abc');
      expect(PcStreamProxy.idOf('vh-pc:'), isNull);
      expect(PcStreamProxy.idOf('Music/song.mp3'), isNull);
    });
  });
}
