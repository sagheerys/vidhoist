import 'pc_link_wire.dart';

/// What the computer's pairing QR code carries: every address it may be
/// reached at, the port, the code, and **its certificate's fingerprint**.
/// Read through the camera, the fingerprint is pinned before the phone
/// connects at all, so nothing on the network can stand in for the
/// computer; the owner still allows the phone on the computer's screen.
///
/// `vidhoist://pair?v=1&h=192.168.1.24,100.101.102.103&p=47321&c=123456&f=<hex>`
class PcPairOffer {
  const PcPairOffer({
    required this.hosts,
    required this.port,
    required this.code,
    required this.fingerprint,
  });

  /// In the order to try: the home network's first.
  final List<String> hosts;
  final int port;
  final String code;

  /// SHA-256 of the certificate, 64 lowercase hex digits.
  final String fingerprint;

  static const scheme = 'vidhoist';
  static const version = '1';

  /// Enough for a computer's real adapters; more makes the code dense
  /// without a phone needing them.
  static const maxHosts = 6;

  String toUri() => Uri(
    scheme: scheme,
    host: 'pair',
    queryParameters: {
      'v': version,
      'h': hosts.take(maxHosts).join(','),
      'p': '$port',
      'c': code,
      'f': fingerprint,
    },
  ).toString();

  static final _ipv4 = RegExp(r'^[0-9]{1,3}(\.[0-9]{1,3}){3}$');
  static final _name = RegExp(r'^[A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?$');
  static final _hex = RegExp(r'^[0-9a-f]{64}$');

  /// Null for anything but a well-formed offer of this version: a code
  /// scanned off a poster or a crafted one gives the phone nothing to dial.
  static PcPairOffer? parse(String text) {
    final Uri uri;
    try {
      uri = Uri.parse(text.trim());
    } on FormatException {
      return null;
    }
    if (uri.scheme != scheme || uri.host != 'pair') return null;
    final q = uri.queryParameters;
    if (q['v'] != version) return null;
    final port = int.tryParse(q['p'] ?? '');
    final code = q['c'] ?? '';
    final fingerprint = (q['f'] ?? '').toLowerCase();
    final hosts = [
      for (final h in (q['h'] ?? '').split(','))
        if (_isHost(h)) h,
    ];
    if (port == null || port < 1 || port > 65535) return null;
    if (code.length != PcLink.codeLength || int.tryParse(code) == null) {
      return null;
    }
    if (!_hex.hasMatch(fingerprint) || hosts.isEmpty) return null;
    return PcPairOffer(
      hosts: hosts.take(maxHosts).toList(),
      port: port,
      code: code,
      fingerprint: fingerprint,
    );
  }

  static bool _isHost(String h) {
    if (_ipv4.hasMatch(h)) {
      return h.split('.').every((part) => int.parse(part) <= 255);
    }
    return h.length <= 253 && h.split('.').every(_name.hasMatch);
  }
}
