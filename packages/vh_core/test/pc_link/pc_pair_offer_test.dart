import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';

/// The pairing QR code: what it carries, and that nothing else reads as one.
void main() {
  final fingerprint = 'ab' * 32;
  const hosts = ['192.168.1.24', '100.101.102.103'];

  test('what the computer writes, the phone reads back', () {
    final offer = PcPairOffer(
      hosts: hosts,
      port: 47321,
      code: '123456',
      fingerprint: fingerprint,
    );
    final read = PcPairOffer.parse(offer.toUri())!;
    expect(read.hosts, hosts);
    expect(read.port, 47321);
    expect(read.code, '123456');
    expect(read.fingerprint, fingerprint);
  });

  test('**the guard**: anything but a whole offer gives nothing to dial', () {
    String uri({
      String scheme = 'vidhoist',
      String v = '1',
      String h = '192.168.1.24',
      String p = '47321',
      String c = '123456',
      String? f,
    }) => '$scheme://pair?v=$v&h=$h&p=$p&c=$c&f=${f ?? fingerprint}';

    expect(PcPairOffer.parse(uri()), isNotNull);
    expect(PcPairOffer.parse('https://example.com'), isNull);
    expect(PcPairOffer.parse('just text'), isNull);
    expect(PcPairOffer.parse(uri(scheme: 'https')), isNull);
    expect(PcPairOffer.parse(uri(v: '2')), isNull, reason: 'a newer format');
    expect(PcPairOffer.parse(uri(p: '0')), isNull);
    expect(PcPairOffer.parse(uri(p: '70000')), isNull);
    expect(PcPairOffer.parse(uri(c: '12345')), isNull);
    expect(PcPairOffer.parse(uri(c: 'abcdef')), isNull);
    expect(PcPairOffer.parse(uri(f: 'ab' * 16)), isNull, reason: 'short');
    expect(PcPairOffer.parse(uri(f: 'zz' * 32)), isNull);
    expect(PcPairOffer.parse(uri(h: '')), isNull);
    expect(PcPairOffer.parse(uri(h: '999.1.1.1')), isNull);
    expect(PcPairOffer.parse(uri(h: 'a/b@evil')), isNull);
  });

  test('a bad address among good ones is dropped, not the offer', () {
    final read = PcPairOffer.parse(
      'vidhoist://pair?v=1&h=999.1.1.1,192.168.1.24&p=47321&c=123456'
      '&f=$fingerprint',
    )!;
    expect(read.hosts, ['192.168.1.24']);
  });

  test('a computer with many adapters still makes a readable code', () {
    final offer = PcPairOffer(
      hosts: [for (var i = 1; i <= 10; i++) '10.0.0.$i'],
      port: 47321,
      code: '123456',
      fingerprint: fingerprint,
    );
    expect(PcPairOffer.parse(offer.toUri())!.hosts, hasLength(6));
  });
}
