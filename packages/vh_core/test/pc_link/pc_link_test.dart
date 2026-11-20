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
    PcLibrarySort sort = PcLibrarySort.newest,
    PcLibraryKind kind = PcLibraryKind.all,
  }) async {
    asked.add((query, sort, kind));
    return PcLibraryPage(
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
  }

  /// What each library request asked for: the search, order and kind.
  final asked = <(String?, PcLibrarySort, PcLibraryKind)>[];

  @override
  Future<File?> cover(String id) async => id == 'i0' ? coverFile : null;

  /// The clip `i0`'s file, when a test gives it one.
  File? mediaFile;

  @override
  Future<File?> file(String id) async => id == 'i0' ? mediaFile : null;

  @override
  Future<List<Object?>> transcripts(String id) async => id == 'i0'
      ? [
          {'lang': 'ar', 'url': 'https://example.com/a'},
        ]
      : const [];

  @override
  Future<List<PcList>> lists() async => const [
    PcList(id: 'l1', name: 'Evening', count: 2, coverId: 'i1'),
  ];

  @override
  Future<PcList?> list(String id) async => id == 'l1'
      ? const PcList(
          id: 'l1',
          name: 'Evening',
          count: 2,
          items: [
            PcItem(id: 'i2', title: 'Clip 2'),
            PcItem(id: 'i0', title: 'Clip 0'),
          ],
        )
      : null;

  /// What [delete] answers for a clip there; tests change it.
  var deleting = PcDeleteOutcome.deleted;
  final deleted = <String>[];

  @override
  Future<PcDeleteOutcome> delete(String id) async {
    if (!id.startsWith('i')) return PcDeleteOutcome.missing;
    if (deleting == PcDeleteOutcome.deleted) deleted.add(id);
    return deleting;
  }
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

  /// Pairs as a person would: the code from the screen, the person at the
  /// computer allowing the request once its four digits match the phone's.
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

  test(
    '**the guard**: the search, order and kind the phone asks for reach '
    "the computer, and the defaults read as an older phone's request",
    () async {
      final client = PcLinkClient(await pairPhone());
      addTearDown(client.close);
      await client.library(
        query: 'رحلة',
        sort: PcLibrarySort.title,
        kind: PcLibraryKind.audio,
      );
      await client.library();
      expect(host.asked, [
        ('رحلة', PcLibrarySort.title, PcLibraryKind.audio),
        (null, PcLibrarySort.newest, PcLibraryKind.all),
      ]);
    },
  );

  test('the computer says when it can sort; an older one does not', () {
    const sorting = PcStatus(name: 'PC', version: '1', sorts: true);
    expect(PcStatus.fromJson(sorting.toJson())!.sorts, isTrue);
    expect(PcStatus.fromJson({'name': 'PC', 'version': '1'})!.sorts, isFalse);
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

  test('**the guard**: a cover that is not a picture is never served, '
      'whatever path the library row holds', () async {
    final dir = await Directory.systemTemp.createTemp('vh_cover');
    addTearDown(() => dir.delete(recursive: true));
    final client = PcLinkClient(await pairPhone());
    addTearDown(client.close);
    for (final name in ['secrets.txt', 'notes', 'key.pem', 'c.jpg.exe']) {
      host.coverFile = File('${dir.path}/$name')..writeAsBytesSync([1, 2]);
      expect(await client.cover('i0'), isNull, reason: name);
    }
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

  test('the saved lists, and one with its clips in its order', () async {
    final client = PcLinkClient(await pairPhone());
    addTearDown(client.close);
    final lists = await client.lists();
    expect(lists.single.name, 'Evening');
    expect(lists.single.count, 2);
    expect(lists.single.coverId, 'i1');
    expect(lists.single.items, isEmpty, reason: 'the clips come with one');
    final one = await client.list('l1');
    expect([for (final i in one!.items) i.id], ['i2', 'i0']);
    expect(await client.list('gone'), isNull);
  });

  test('a delete says what became of it', () async {
    final client = PcLinkClient(await pairPhone());
    addTearDown(client.close);
    expect(await client.delete('i0'), PcDeleteOutcome.deleted);
    expect(host.deleted, ['i0']);
    expect(await client.delete('x9'), PcDeleteOutcome.missing);
    for (final refusal in [
      PcDeleteOutcome.notAllowed,
      PcDeleteOutcome.noRecycleBin,
      PcDeleteOutcome.failed,
    ]) {
      host.deleting = refusal;
      expect(await client.delete('i1'), refusal);
    }
    expect(host.deleted, ['i0'], reason: 'a refusal deletes nothing');
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
          '/v1/library/i0/file',
          '/v1/library/i0/transcripts',
          PcLink.listsPath,
          '/v1/lists/l1',
        ]) {
          expect(await raw('GET', path), (404, ''), reason: path);
        }
        expect(await raw('POST', PcLink.pairPath), (404, ''));
      },
    );

    test(
      '**the guard**: a delete without the secret deletes nothing',
      () async {
        host.deleting = PcDeleteOutcome.deleted;
        await pairPhone();
        final id = window.devices.single.id;
        expect(await raw('DELETE', '/v1/library/i0'), (404, ''));
        final (code, body) = await raw(
          'DELETE',
          '/v1/library/i0',
          headers: {
            PcLink.deviceHeader: id,
            'authorization': 'Bearer ${newSecret()}',
          },
        );
        expect((code, body), (401, ''));
        expect(host.deleted, isEmpty);
      },
    );

    test(
      '**the guard**: a refused request that never ends its body is '
      'answered and closed, not read for as long as it keeps sending',
      () async {
        final socket = await SecureSocket.connect(
          '127.0.0.1',
          port,
          onBadCertificate: (_) => true,
        );
        addTearDown(socket.destroy);
        final answer = StringBuffer();
        final closed = socket
            .cast<List<int>>()
            .transform(utf8.decoder)
            .forEach(answer.write);
        socket.write(
          'POST ${PcLink.downloadsPath} HTTP/1.1\r\n'
          'Host: 127.0.0.1\r\n'
          'Transfer-Encoding: chunked\r\n\r\n'
          '5\r\nhello\r\n',
        );
        await socket.flush();
        // The body's last chunk is never sent.
        await closed.timeout(const Duration(seconds: 5));
        expect(answer.toString(), startsWith('HTTP/1.1 404'));
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

  group('pairing by the QR code', () {
    test('the phone finds the address that answers, then pairs with the '
        'certificate pinned from the start', () async {
      final shown = window.open();
      final sub = window.requests.listen((request) => request.allow());
      addTearDown(sub.cancel);
      final offer = PcPairOffer(
        // 127.0.0.2 answers nothing: the server listens on .1 only.
        hosts: const ['127.0.0.2', '127.0.0.1'],
        port: port,
        code: shown,
        fingerprint: certificate.fingerprint,
      );
      final host = await PcLinkClient.reach(
        hosts: offer.hosts,
        port: offer.port,
        fingerprint: offer.fingerprint,
      );
      expect(host, '127.0.0.1');
      final pairing = await PcLinkClient.pair(
        host: host!,
        port: port,
        code: shown,
        phoneName: 'Galaxy',
        onCheck: (_) {},
        fingerprint: offer.fingerprint,
      );
      expect(pairing.fingerprint, certificate.fingerprint);
      expect(window.devices.single.name, 'Galaxy');
    });

    test('**the guard**: another certificate than the code says is refused '
        'before the code leaves the phone', () async {
      final shown = window.open();
      var asked = false;
      final sub = window.requests.listen((_) => asked = true);
      addTearDown(sub.cancel);
      final other = PcCertificate.generate().fingerprint;
      expect(
        await PcLinkClient.reach(
          hosts: const ['127.0.0.1'],
          port: port,
          fingerprint: other,
        ),
        isNull,
      );
      await expectLater(
        PcLinkClient.pair(
          host: '127.0.0.1',
          port: port,
          code: shown,
          phoneName: 'Galaxy',
          onCheck: (_) {},
          fingerprint: other,
        ),
        throwsA(
          isA<PcLinkException>().having(
            (e) => e.failure,
            'f',
            PcLinkFailure.wrongCertificate,
          ),
        ),
      );
      expect(asked, isFalse);
      expect(window.isOpen, isTrue, reason: 'no try was spent');
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

    test('when the person at the computer says no', () async {
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
      url: 'https://youtu.be/x',
      extension: 'webm',
    );
    final back = PcItem.fromJson(jsonDecode(jsonEncode(item.toJson())))!;
    expect(back.duration, item.duration);
    expect(back.added, item.added);
    expect(back.hasCover, isTrue);
    expect(back.url, 'https://youtu.be/x');
    expect(back.extension, 'webm');
    // An older computer sends neither.
    expect(PcItem.fromJson({'id': 'x', 'title': 't'})!.url, isNull);
  });

  test('deleting is off unless the computer says, and a list survives', () {
    const on = PcStatus(name: 'PC', version: '1', canDelete: true);
    expect(PcStatus.fromJson(on.toJson())!.canDelete, isTrue);
    expect(PcStatus.fromJson({'name': 'PC'})!.canDelete, isFalse);
    const list = PcList(
      id: 'l',
      name: 'n',
      count: 1,
      thumbnail: 'https://i/t.jpg',
      items: [PcItem(id: 'a', title: 'A')],
    );
    final back = PcList.fromJson(list.toJson())!;
    expect(
      (back.name, back.count, back.thumbnail),
      ('n', 1, 'https://i/t.jpg'),
    );
    expect(back.items.single.id, 'a');
    expect(PcList.fromJson({'id': 'l'}), isNull);
  });
}
