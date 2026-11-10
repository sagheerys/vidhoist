import 'dart:io';

import 'pc_certificate.dart';

/// The first of [hosts], in their order, where the computer with
/// [fingerprint] answers on [port]; null when none does. Only a TLS
/// handshake is made, nothing is sent: a computer has several addresses
/// and the phone reaches only some of them.
Future<String?> pcReach({
  required List<String> hosts,
  required int port,
  required String fingerprint,
  Duration timeout = const Duration(seconds: 3),
}) async {
  Future<bool> answers(String host) async {
    try {
      final socket = await SecureSocket.connect(
        host,
        port,
        context: SecurityContext(withTrustedRoots: false),
        onBadCertificate: (cert) => fingerprintOf(cert.der) == fingerprint,
        timeout: timeout,
      );
      socket.destroy();
      return true;
    } on Object {
      return false;
    }
  }

  // All at once, so an address that does not answer costs one timeout,
  // not one each.
  final results = await Future.wait(hosts.map(answers));
  for (var i = 0; i < hosts.length; i++) {
    if (results[i]) return hosts[i];
  }
  return null;
}
