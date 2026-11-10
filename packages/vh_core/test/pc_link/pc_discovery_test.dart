import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';

/// Finding the computer on the network: a real UDP exchange on this
/// machine's loopback, the paired phone answered, a stranger not.
void main() {
  const secret = 'the-phone-secret';
  final loopback = [InternetAddress.loopbackIPv4];
  late PcPairingWindow window;
  late PcDiscoveryResponder responder;
  late int port;

  PcPairing pairing({String id = 'phone1', String secret = secret}) =>
      PcPairing(
        host: '192.168.1.24',
        port: 47321,
        fingerprint: 'ab',
        deviceId: id,
        secret: secret,
        name: 'HOME-PC',
      );

  setUp(() async {
    final store = MemoryPcDeviceStore()
      ..devices = [
        PcDevice(
          id: 'phone1',
          name: 'Galaxy',
          secretHash: secretHash(secret),
          pairedAt: DateTime(2026),
        ),
      ];
    window = PcPairingWindow(store: store, fingerprint: 'ab');
    await window.load();
    responder = PcDiscoveryResponder(
      pairing: window,
      linkPort: 47999,
      name: 'HOME-PC',
    );
    port = (await responder.start(
      address: InternetAddress.loopbackIPv4,
      port: 0,
    ))!;
  });

  tearDown(() async {
    responder.stop();
    await window.dispose();
  });

  Future<PcFound?> find(PcPairing p) => pcFindPaired(
    p,
    targets: loopback,
    port: port,
    wait: const Duration(milliseconds: 600),
  );

  test('the paired phone finds it, and where to dial', () async {
    expect(
      await find(pairing()),
      const PcFound(host: '127.0.0.1', port: 47999),
    );
  });

  test('**the guard**: a wrong secret or a stranger hears nothing', () async {
    expect(await find(pairing(secret: 'guessed')), isNull);
    expect(await find(pairing(id: 'stranger')), isNull);
    // The computer itself stays silent, not just the phone unconvinced.
    List<int> probe(String key) => utf8.encode(
      jsonEncode({
        'vh': 'find',
        'id': 'phone1',
        'n': 'abc',
        'm': Hmac(
          sha256,
          utf8.encode(secretHash(key)),
        ).convert(utf8.encode('find:phone1:abc')).toString(),
      }),
    );
    expect(responder.answer(probe(secret)), isNotNull);
    expect(responder.answer(probe('guessed')), isNull);
    expect(
      responder.answer(utf8.encode(jsonEncode({'vh': 'find', 'id': 'phone1'}))),
      isNull,
    );
  });

  test('a revoked phone hears nothing', () async {
    await window.revoke('phone1');
    expect(await find(pairing()), isNull);
  });

  test('**the guard**: an answer without the proof is ignored', () async {
    // Someone else on the network answers every probe with its own address.
    final liar = await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(liar.close);
    liar.listen((event) {
      final d = liar.receive();
      if (d == null) return;
      final probe = jsonDecode(utf8.decode(d.data)) as Map;
      liar.send(
        utf8.encode(
          jsonEncode({'vh': 'here', 'n': probe['n'], 'port': 443, 'm': '00'}),
        ),
        d.address,
        d.port,
      );
    });
    final found = await pcFindPaired(
      pairing(),
      targets: loopback,
      port: liar.port,
      wait: const Duration(milliseconds: 600),
    );
    expect(found, isNull);
  });

  test('pairing: found only while the code is on screen', () async {
    Future<List<PcFound>> look() => pcFindPairable(
      targets: loopback,
      port: port,
      wait: const Duration(milliseconds: 600),
    );
    expect(await look(), isEmpty);
    window.open();
    expect(await look(), [
      const PcFound(host: '127.0.0.1', port: 47999, name: 'HOME-PC'),
    ]);
  });

  test('anything else, or too big, gets silence', () {
    for (final junk in [
      utf8.encode('hello'),
      utf8.encode('[1,2]'),
      utf8.encode(jsonEncode({'vh': 'other'})),
      utf8.encode(jsonEncode({'vh': 'find-pair', 'pad': 'x' * 600})),
    ]) {
      expect(responder.answer(junk), isNull);
    }
  });

  test('a flood is answered a few times, not each', () async {
    final flood = PcDiscoveryResponder(
      pairing: window..open(),
      linkPort: 1,
      name: 'x',
      perSecond: 3,
    );
    final at = (await flood.start(
      address: InternetAddress.loopbackIPv4,
      port: 0,
    ))!;
    addTearDown(flood.stop);
    final asker = await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(asker.close);
    var replies = 0;
    asker.listen((event) {
      if (event == RawSocketEvent.read && asker.receive() != null) replies++;
    });
    final probe = utf8.encode(jsonEncode({'vh': 'find-pair'}));
    for (var i = 0; i < 20; i++) {
      asker.send(probe, InternetAddress.loopbackIPv4, at);
    }
    await Future<void>.delayed(const Duration(milliseconds: 300));
    // A second boundary inside the burst allows one more round.
    expect(replies, inInclusiveRange(1, 6));
  });
}
