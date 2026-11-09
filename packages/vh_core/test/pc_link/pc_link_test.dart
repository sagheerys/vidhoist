import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';

class FakeHost implements PcLinkHost {
  final submitted = <(String, String)>[];
  final cancelled = <String>[];
  File? coverFile;

  @override
  PcStatus status() =>
      const PcStatus(name: 'HOME-PC', version: '1.0.0', active: 1);

  @override
  List<PcTask> tasks() => const [
    PcTask(
      id: 't1',
      url: 'https://example.com/a',
      phase: 'downloading',
      progress: 38,
    ),
  ];

  @override
  PcTask? submit(String url, String quality) {
    if (url.contains('refuse')) return null;
    submitted.add((url, quality));
    return PcTask(id: 't2', url: url, phase: 'queued', quality: quality);
  }

  @override
  bool cancel(String id) {
    cancelled.add(id);
    return id == 't1';
  }

  @override
  Future<PcLibraryPage> library({
    int offset = 0,
    int limit = 100,
    String? query,
  }) async => PcLibraryPage(
    items: [
      for (var i = offset; i < (offset + limit).clamp(0, 3); i++)
        PcItem(
          id: 'i$i',
          title: 'Clip $i',
          duration: const Duration(minutes: 4),
        ),
    ],
    total: 3,
  );

  @override
  Future<File?> cover(String id) async => id == 'i0' ? coverFile : null;
}

void main() {
  // One certificate for the whole file: generating one takes a moment.
  final certificate = PcCertificate.generate();
  late FakeHost host;
  late PcPairingWindow window;
  late PcLinkServer server;
  late int port;

  setUp(() async {
    host = FakeHost();
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
    port = await server.start(address: InternetAddress.loopbackIPv4, port: 0);
  });

  tearDown(() async {
    await server.stop();
    await window.dispose();
  });

  /// Pairs as the owner would: the code from the screen, the owner allowing
  /// the request once its four digits match the phone's.
  Future<PcPairing> pairPhone({String? code, bool allow = true}) async {
    final shown = window.open();
    String? phoneCheck;
    final sub = window.requests.listen((request) {
      expect(
        request.check,
        phoneCheck,
        reason: 'both screens show the same digits',
      );
      expect(request.name, 'Galaxy');
      allow ? request.allow() : request.deny();
    });
    try {
      return await PcLinkClient.pair(
        host: '127.0.0.1',
        port: port,
        code: code ?? shown,
        phoneName: 'Galaxy',
        onCheck: (check) => phoneCheck = check,
      );
    } finally {
      await sub.cancel();
    }
  }

  test(
    'a certificate is P-256, self-signed, and its fingerprint is stable',
    () {
      final again = PcCertificate(
        certPem: certificate.certPem,
        keyPem: certificate.keyPem,
      );
      expect(again.fingerprint, certificate.fingerprint);
      expect(certificate.fingerprint, hasLength(64));
      expect(certificate.certPem, startsWith('-----BEGIN CERTIFICATE-----'));
      expect(certificate.keyPem, startsWith('-----BEGIN PRIVATE KEY-----'));
      expect(
        PcCertificate.generate().fingerprint,
        isNot(certificate.fingerprint),
      );
    },
  );

  test('pairing pins the certificate, then every call works', () async {
    final pairing = await pairPhone();
    expect(pairing.fingerprint, certificate.fingerprint);
    expect(pairing.name, 'HOME-PC');
    expect(window.devices.single.secretHash, secretHash(pairing.secret));
    expect(window.devices.single.secretHash, isNot(contains(pairing.secret)));
    expect(window.isOpen, isFalse, reason: 'one code, one pairing');

    final client = PcLinkClient(pairing);
    addTearDown(client.close);
    expect((await client.status()).name, 'HOME-PC');
    expect((await client.tasks()).single.progress, 38);
    final task = await client.submit('https://youtu.be/abc', '720');
    expect(task.quality, '720');
    expect(host.submitted.single, ('https://youtu.be/abc', '720'));
    expect(await client.cancel('t1'), isTrue);
    expect(await client.cancel('nope'), isFalse);
    final page = await client.library(offset: 1, limit: 5);
    expect(page.total, 3);
    expect([for (final i in page.items) i.id], ['i1', 'i2']);
  });

  test('a cover comes through, and only a kept one', () async {
    final dir = await Directory.systemTemp.createTemp('vh_cover');
    addTearDown(() => dir.delete(recursive: true));
    host.coverFile = File('${dir.path}/c.jpg')..writeAsBytesSync([1, 2, 3]);
    final client = PcLinkClient(await pairPhone());
    addTearDown(client.close);
    expect(await client.cover('i0'), [1, 2, 3]);
    expect(await client.cover('i1'), isNull);
  });

  test('the server refuses links that are not web links', () async {
    final client = PcLinkClient(await pairPhone());
    addTearDown(client.close);
    for (final bad in [
      'file:///C:/Windows/win.ini',
      'javascript:alert(1)',
      'not a link',
    ]) {
      await expectLater(
        client.submit(bad, 'best'),
        throwsA(
          isA<PcLinkException>().having(
            (e) => e.failure,
            'failure',
            PcLinkFailure.refused,
          ),
        ),
      );
    }
    await expectLater(
      client.submit('https://example.com/refuse', 'best'),
      throwsA(
        isA<PcLinkException>().having(
          (e) => e.failure,
          'failure',
          PcLinkFailure.refused,
        ),
      ),
    );
    expect(host.submitted, isEmpty);
  });

  group('a scan of the network', () {
    Future<(int, String)> raw(
      String method,
      String path, {
      Map<String, String>? headers,
    }) async {
      final http = HttpClient()..badCertificateCallback = (_, _, _) => true;
      addTearDown(() => http.close(force: true));
      final request = await http.openUrl(
        method,
        Uri.parse('https://127.0.0.1:$port$path'),
      );
      headers?.forEach(request.headers.set);
      final response = await request.close();
      return (response.statusCode, await utf8.decodeStream(response));
    }

    test(
      'finds every path an empty 404, pairing included while shut',
      () async {
        for (final path in [
          '/',
          PcLink.statusPath,
          PcLink.downloadsPath,
          PcLink.libraryPath,
          '/v1/library/i0/cover',
        ]) {
          expect(await raw('GET', path), (404, ''), reason: path);
        }
        expect(await raw('POST', PcLink.pairPath), (404, ''));
      },
    );

    test('a made-up secret is refused, and names nothing', () async {
      await pairPhone();
      final id = window.devices.single.id;
      final (code, body) = await raw(
        'GET',
        PcLink.statusPath,
        headers: {
          PcLink.deviceHeader: id,
          'authorization': 'Bearer ${newSecret()}',
        },
      );
      expect(code, 401);
      expect(body, isEmpty);
      expect(body, isNot(contains('HOME-PC')));
    });

    test('the certificate names nothing either', () async {
      final socket = await SecureSocket.connect(
        '127.0.0.1',
        port,
        onBadCertificate: (_) => true,
      );
      addTearDown(socket.destroy);
      final subject = socket.peerCertificate!.subject;
      expect(subject.toLowerCase(), isNot(contains('vidhoist')));
      expect(subject, contains('localhost'));
    });
  });

  group('pairing refuses', () {
    test('a wrong code, and shuts after five', () async {
      window.open();
      for (var i = 0; i < PcLink.maxAttempts; i++) {
        expect(window.isOpen, isTrue);
        await expectLater(
          PcLinkClient.pair(
            host: '127.0.0.1',
            port: port,
            code: 'xxxxxx',
            phoneName: 'x',
            onCheck: (_) {},
          ),
          throwsA(
            isA<PcLinkException>().having(
              (e) => e.failure,
              'f',
              PcLinkFailure.wrongCode,
            ),
          ),
        );
      }
      expect(window.isOpen, isFalse);
      expect(window.devices, isEmpty);
    });

    test('when the owner says no', () async {
      await expectLater(
        pairPhone(allow: false),
        throwsA(
          isA<PcLinkException>().having(
            (e) => e.failure,
            'f',
            PcLinkFailure.pairingDenied,
          ),
        ),
      );
      expect(window.devices, isEmpty);
    });

    test('when no code is shown', () async {
      await expectLater(
        PcLinkClient.pair(
          host: '127.0.0.1',
          port: port,
          code: '123456',
          phoneName: 'x',
          onCheck: (_) {},
        ),
        throwsA(
          isA<PcLinkException>().having(
            (e) => e.failure,
            'f',
            PcLinkFailure.pairingClosed,
          ),
        ),
      );
    });
  });

  test(
    'another computer with another certificate is refused before any request',
    () async {
      final pairing = await pairPhone();
      final impostor = PcLinkServer(
        certificate: PcCertificate.generate(),
        host: host,
        pairing: window,
        name: 'EVIL',
      );
      final evilPort = await impostor.start(
        address: InternetAddress.loopbackIPv4,
        port: 0,
      );
      addTearDown(impostor.stop);
      final client = PcLinkClient(pairing.copyWith(port: evilPort));
      addTearDown(client.close);
      await expectLater(
        client.submit('https://youtu.be/abc', 'best'),
        throwsA(
          isA<PcLinkException>().having(
            (e) => e.failure,
            'f',
            PcLinkFailure.wrongCertificate,
          ),
        ),
      );
      expect(host.submitted, isEmpty, reason: 'nothing reached a server');
    },
  );

  test('a forgotten phone learns it must pair again', () async {
    final pairing = await pairPhone();
    await window.revoke(pairing.deviceId);
    final client = PcLinkClient(pairing);
    addTearDown(client.close);
    await expectLater(
      client.status(),
      throwsA(
        isA<PcLinkException>().having(
          (e) => e.failure,
          'f',
          PcLinkFailure.unauthorized,
        ),
      ),
    );
  });

  test('an unreachable computer says so', () async {
    final pairing = await pairPhone();
    await server.stop();
    final client = PcLinkClient(pairing, timeout: const Duration(seconds: 2));
    addTearDown(client.close);
    await expectLater(
      client.status(),
      throwsA(
        isA<PcLinkException>().having(
          (e) => e.failure,
          'f',
          PcLinkFailure.unreachable,
        ),
      ),
    );
  });

  test('the four digits are deterministic and depend on every input', () {
    final a = pairingCheck(fingerprint: 'f', code: '123456', nonce: 'n');
    expect(a, hasLength(4));
    expect(pairingCheck(fingerprint: 'f', code: '123456', nonce: 'n'), a);
    final others = {
      pairingCheck(fingerprint: 'g', code: '123456', nonce: 'n'),
      pairingCheck(fingerprint: 'f', code: '123457', nonce: 'n'),
      pairingCheck(fingerprint: 'f', code: '123456', nonce: 'm'),
    };
    expect(others, isNot(contains(a)));
  });

  test('records survive JSON, and bad JSON reads as absent', () {
    const pairing = PcPairing(
      host: 'h',
      port: 1,
      fingerprint: 'f',
      deviceId: 'd',
      secret: 's',
      name: 'n',
    );
    expect(PcPairing.fromJson(pairing.toJson())!.toJson(), pairing.toJson());
    expect(PcPairing.fromJson({'host': 1}), isNull);
    expect(PcTask.fromJson({'id': 1}), isNull);
    expect(PcItem.fromJson(null), isNull);
    final item = PcItem(
      id: 'x',
      title: 't',
      duration: const Duration(seconds: 61),
      added: DateTime(2026),
      hasCover: true,
    );
    final back = PcItem.fromJson(jsonDecode(jsonEncode(item.toJson())))!;
    expect(back.duration, item.duration);
    expect(back.added, item.added);
    expect(back.hasCover, isTrue);
  });
}
