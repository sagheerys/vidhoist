import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/data/pc_link_addresses.dart';

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
}
