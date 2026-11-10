/// The computer's addresses and what each is: Windows lists one per network
/// adapter, and programs add their own (VirtualBox, WSL, Hyper-V…). Shown
/// flat, six addresses read as a puzzle (owner's report, 2026-11-09); the
/// computer sorts them, and tells a paired phone, which lets the owner pick
/// the home network or Tailscale (owner's choice, 2026-11-10).
library;

enum PcAddressKind {
  /// A private address on a real adapter: the one the phone at home uses.
  home,

  /// Tailscale's own range: the phone reaches it from outside the home.
  tailscale,

  /// An adapter another program added, or an address no phone dials.
  other,
}

class PcAddress {
  const PcAddress({
    required this.address,
    required this.adapter,
    required this.kind,
  });

  final String address;

  /// Windows' name for the adapter ("Wi-Fi", "Ethernet"…), shown beside it.
  final String adapter;
  final PcAddressKind kind;

  Map<String, Object?> toJson() => {
    'address': address,
    'adapter': adapter,
    'kind': kind.name,
  };

  static PcAddress? fromJson(Object? json) {
    if (json is! Map || json['address'] is! String) return null;
    final address = json['address'] as String;
    final adapter = json['adapter'] as String? ?? '';
    return PcAddress(
      address: address,
      adapter: adapter,
      // A kind this version does not know is worked out again here.
      kind:
          PcAddressKind.values.asNameMap()[json['kind']] ??
          pcAddressKind(adapter, address),
    );
  }

  static List<PcAddress> listFromJson(Object? json) => [
    if (json is List)
      for (final entry in json) ?PcAddress.fromJson(entry),
  ];

  @override
  bool operator ==(Object other) =>
      other is PcAddress &&
      other.address == address &&
      other.adapter == adapter &&
      other.kind == kind;

  @override
  int get hashCode => Object.hash(address, adapter, kind);
}

/// Adapters other programs add. Their names are the only sign Windows
/// gives; an unknown one still shows, among the others.
final _virtual = RegExp(
  r'virtualbox|vmware|vethernet|hyper-v|wsl|docker|loopback|npcap|'
  r'bluetooth|zerotier|hamachi|radmin|openvpn|wireguard|vpn|tap-',
  caseSensitive: false,
);

PcAddressKind pcAddressKind(String adapter, String address) {
  final parts = address.split('.').map(int.tryParse).toList();
  if (parts.length != 4 || parts.contains(null)) return PcAddressKind.other;
  final a = parts[0]!;
  final b = parts[1]!;
  // 100.64.0.0/10, the shared range Tailscale gives each device.
  if (adapter.toLowerCase().contains('tailscale') ||
      (a == 100 && b >= 64 && b < 128)) {
    return PcAddressKind.tailscale;
  }
  if (_virtual.hasMatch(adapter)) return PcAddressKind.other;
  // VirtualBox's host-only network, whatever its adapter is called.
  if (a == 192 && b == 168 && parts[2] == 56) return PcAddressKind.other;
  final private =
      a == 10 || (a == 172 && b >= 16 && b < 32) || (a == 192 && b == 168);
  return private ? PcAddressKind.home : PcAddressKind.other;
}

/// [found] as (adapter, address), home first, then Tailscale, then the
/// rest; Windows' own order kept within each.
List<PcAddress> sortPcAddresses(Iterable<(String, String)> found) {
  final all = [
    for (final (adapter, address) in found)
      PcAddress(
        address: address,
        adapter: adapter,
        kind: pcAddressKind(adapter, address),
      ),
  ];
  return [
    for (final kind in PcAddressKind.values)
      ...all.where((a) => a.kind == kind),
  ];
}
