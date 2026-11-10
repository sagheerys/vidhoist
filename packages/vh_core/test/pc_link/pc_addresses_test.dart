import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';

/// Which address the owner sees first (owner's report, 2026-11-09: six in a
/// row, from Wi-Fi, a second network, VirtualBox, WSL and Tailscale).
void main() {
  test('**the guard**: home first, Tailscale next, the added adapters '
      'last', () {
    final sorted = sortPcAddresses(const [
      ('VirtualBox Host-Only Network', '192.168.56.1'),
      ('vEthernet (WSL)', '172.20.96.1'),
      ('Tailscale', '100.101.102.103'),
      ('Wi-Fi', '192.168.2.10'),
      ('Ethernet', '10.0.0.5'),
    ]);
    expect(
      [for (final a in sorted) a.address],
      [
        '192.168.2.10',
        '10.0.0.5',
        '100.101.102.103',
        '192.168.56.1',
        '172.20.96.1',
      ],
    );
    expect(
      [for (final a in sorted) a.kind],
      [
        PcAddressKind.home,
        PcAddressKind.home,
        PcAddressKind.tailscale,
        PcAddressKind.other,
        PcAddressKind.other,
      ],
    );
  });

  test("Tailscale's range is known whatever the adapter is called", () {
    expect(pcAddressKind('Ethernet 3', '100.64.0.1'), PcAddressKind.tailscale);
    expect(
      pcAddressKind('Ethernet 3', '100.127.255.1'),
      PcAddressKind.tailscale,
    );
    expect(pcAddressKind('Ethernet 3', '100.128.0.1'), PcAddressKind.other);
  });

  test('VirtualBox host-only is set aside even when renamed', () {
    expect(pcAddressKind('Ethernet 2', '192.168.56.1'), PcAddressKind.other);
  });

  test('a public address is not offered first', () {
    expect(pcAddressKind('Ethernet', '8.8.8.8'), PcAddressKind.other);
  });

  group('the routes the phone keeps', () {
    const routes = [
      PcAddress(
        address: '192.168.1.24',
        adapter: 'Wi-Fi',
        kind: PcAddressKind.home,
      ),
      PcAddress(
        address: '100.101.102.103',
        adapter: 'Tailscale',
        kind: PcAddressKind.tailscale,
      ),
    ];

    test('the computer tells them with its status', () {
      const status = PcStatus(name: 'PC', version: '1', addresses: routes);
      expect(PcStatus.fromJson(status.toJson())!.addresses, routes);
      // An older computer sends none.
      expect(
        PcStatus.fromJson({'name': 'PC', 'version': '1'})!.addresses,
        isEmpty,
      );
    });

    test('the pairing keeps them, and the route chosen among them', () {
      const pairing = PcPairing(
        host: '100.101.102.103',
        port: 47321,
        fingerprint: 'f',
        deviceId: 'd',
        secret: 's',
        name: 'PC',
        routes: routes,
      );
      final back = PcPairing.fromJson(pairing.toJson())!;
      expect(back.routes, routes);
      expect(back.host, '100.101.102.103');
      // A pairing saved before routes existed still reads.
      final old = pairing.toJson()..remove('routes');
      expect(PcPairing.fromJson(old)!.routes, isEmpty);
    });

    test('a kind this version does not know is worked out from the '
        'address', () {
      final read = PcAddress.fromJson({
        'address': '100.101.102.103',
        'adapter': 'x',
        'kind': 'satellite',
      })!;
      expect(read.kind, PcAddressKind.tailscale);
    });
  });
}
