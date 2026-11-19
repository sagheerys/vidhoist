import 'dart:convert';
import 'dart:io';

import 'pc_link_api.dart';
import 'pc_link_http.dart';
import 'pc_link_wire.dart';

/// Pairs with the computer at [host]:[port] using the [code] on its
/// screen; see `PcLinkClient.pair`.
Future<PcPairing> pcPair({
  required String host,
  required int port,
  required String code,
  required String phoneName,
  required void Function(String check) onCheck,
  String? fingerprint,
}) async {
  final nonce = newSecret();
  String? seen;
  var wrong = false;
  final http = pcPinnedClient((fp) {
    if (fingerprint != null && fp != fingerprint) {
      wrong = true;
      return false;
    }
    // Typed by hand, any certificate is accepted *for comparison*: the
    // user compares the four digits it yields with the computer's.
    if (seen == null) {
      seen = fp;
      onCheck(pairingCheck(fingerprint: fp, code: code, nonce: nonce));
    }
    return fp == seen;
  }, const Duration(seconds: 6));
  try {
    final request = await http
        .postUrl(
          Uri(scheme: 'https', host: host, port: port, path: PcLink.pairPath),
        )
        .timeout(const Duration(seconds: 8));
    request.headers.contentType = ContentType.json;
    request.write(
      jsonEncode({'code': code, 'nonce': nonce, 'name': phoneName}),
    );
    final response = await request.close().timeout(
      PcLink.approvalWait + const Duration(seconds: 10),
    );
    final body = await pcReadBody(response);
    if (response.statusCode == HttpStatus.notFound) {
      throw const PcLinkException(PcLinkFailure.pairingClosed);
    }
    final json = pcDecodeJson(body);
    if (response.statusCode == HttpStatus.forbidden) {
      throw PcLinkException(switch (json is Map ? json['error'] : null) {
        'wrongCode' => PcLinkFailure.wrongCode,
        'closed' => PcLinkFailure.pairingClosed,
        _ => PcLinkFailure.pairingDenied,
      });
    }
    if (response.statusCode != HttpStatus.ok || json is! Map || seen == null) {
      throw PcLinkException(
        PcLinkFailure.badResponse,
        '${response.statusCode}',
      );
    }
    final deviceId = json['deviceId'];
    final secret = json['secret'];
    if (deviceId is! String || secret is! String) {
      throw const PcLinkException(PcLinkFailure.badResponse);
    }
    return PcPairing(
      host: host,
      port: port,
      fingerprint: seen!,
      deviceId: deviceId,
      secret: secret,
      name: json['name'] as String? ?? host,
    );
  } on PcLinkException {
    rethrow;
  } on Object catch (e) {
    if (wrong) throw const PcLinkException(PcLinkFailure.wrongCertificate);
    throw PcLinkException(PcLinkFailure.unreachable, '$e');
  } finally {
    http.close(force: true);
  }
}
