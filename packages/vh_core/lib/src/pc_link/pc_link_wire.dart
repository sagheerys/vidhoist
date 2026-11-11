import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'pc_addresses.dart';
import 'pc_link_models.dart';

/// "Download on the computer": the words both ends agree on. The computer
/// runs a small HTTPS server on the home network; the phone pairs once, then
/// sends links and reads the computer's downloads and library. See
/// docs/PC-LINK.md for the whole design and its security.
abstract final class PcLink {
  static const defaultPort = 47321;

  static const pairPath = '/v1/pair';
  static const statusPath = '/v1/status';
  static const downloadsPath = '/v1/downloads';
  static const libraryPath = '/v1/library';

  /// The saved lists; `/v1/lists/<id>` one with its clips.
  static const listsPath = '/v1/lists';

  /// `DELETE /v1/library/<id>` answers in these, so the phone can say why.
  static const deleteRefusals = {
    'notAllowed': PcDeleteOutcome.notAllowed,
    'noRecycleBin': PcDeleteOutcome.noRecycleBin,
    'failed': PcDeleteOutcome.failed,
  };

  /// `/v1/library/<id>/file`: a clip's file, ranges honoured.
  static const fileSegment = 'file';

  /// Who is asking: the device id, beside `Authorization: Bearer <secret>`.
  static const deviceHeader = 'x-vh-device';

  /// The code the computer shows: six digits, two minutes, five tries, then
  /// a new code. Five guesses out of a million is one chance in 200,000, and
  /// the owner must still allow the phone on the computer's screen.
  static const codeLength = 6;
  static const pairWindow = Duration(minutes: 2);
  static const maxAttempts = 5;

  /// How long a pairing request waits for the owner's answer on the computer.
  static const approvalWait = Duration(seconds: 90);

  static const maxBody = 64 * 1024;
}

/// The four digits both screens show during a pairing. The phone computes
/// them from the certificate it actually reached, the computer from its own:
/// a machine in the middle presents another certificate, fixed before it
/// sees the code or the phone's nonce, so its four digits differ and the
/// owner refuses it.
String pairingCheck({
  required String fingerprint,
  required String code,
  required String nonce,
}) {
  final digest = sha256.convert(utf8.encode('$fingerprint:$code:$nonce'));
  final value =
      ByteData.sublistView(Uint8List.fromList(digest.bytes)).getUint32(0) %
      10000;
  return value.toString().padLeft(4, '0');
}

String newPairingCode([Random? random]) {
  final r = random ?? Random.secure();
  return [for (var i = 0; i < PcLink.codeLength; i++) r.nextInt(10)].join();
}

/// 32 random bytes, base64url without padding: a device's secret, or a nonce.
String newSecret([Random? random]) {
  final r = random ?? Random.secure();
  return base64Url
      .encode([for (var i = 0; i < 32; i++) r.nextInt(256)])
      .replaceAll('=', '');
}

/// What the computer keeps instead of a secret, so that its saved settings
/// alone let nobody in.
String secretHash(String secret) =>
    sha256.convert(utf8.encode(secret)).toString();

/// Compares in time that does not depend on where the strings differ.
bool constantTimeEquals(String a, String b) {
  if (a.length != b.length) return false;
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return diff == 0;
}

/// What the phone keeps after pairing: where the computer is, the
/// certificate it must present, and the phone's own id and secret.
class PcPairing {
  const PcPairing({
    required this.host,
    required this.port,
    required this.fingerprint,
    required this.deviceId,
    required this.secret,
    required this.name,
    this.routes = const [],
  });

  /// The address in use: the owner's choice among [routes].
  final String host;
  final int port;
  final String fingerprint;
  final String deviceId;
  final String secret;

  /// The computer's name, as it gave it.
  final String name;

  /// Every address the computer last said it has (home network, Tailscale…),
  /// for the owner to switch [host] between; empty until it first answers.
  final List<PcAddress> routes;

  PcPairing copyWith({
    String? host,
    int? port,
    String? name,
    List<PcAddress>? routes,
  }) => PcPairing(
    host: host ?? this.host,
    port: port ?? this.port,
    fingerprint: fingerprint,
    deviceId: deviceId,
    secret: secret,
    name: name ?? this.name,
    routes: routes ?? this.routes,
  );

  Map<String, Object?> toJson() => {
    'host': host,
    'port': port,
    'fingerprint': fingerprint,
    'deviceId': deviceId,
    'secret': secret,
    'name': name,
    if (routes.isNotEmpty) 'routes': [for (final r in routes) r.toJson()],
  };

  static PcPairing? fromJson(Object? json) {
    if (json is! Map) return null;
    final host = json['host'];
    final port = json['port'];
    final fingerprint = json['fingerprint'];
    final deviceId = json['deviceId'];
    final secret = json['secret'];
    if (host is! String ||
        port is! int ||
        fingerprint is! String ||
        deviceId is! String ||
        secret is! String) {
      return null;
    }
    return PcPairing(
      host: host,
      port: port,
      fingerprint: fingerprint,
      deviceId: deviceId,
      secret: secret,
      name: json['name'] as String? ?? host,
      routes: PcAddress.listFromJson(json['routes']),
    );
  }
}

/// A paired phone, as the computer remembers it: never its secret.
class PcDevice {
  const PcDevice({
    required this.id,
    required this.name,
    required this.secretHash,
    required this.pairedAt,
    this.lastSeen,
  });

  final String id;
  final String name;
  final String secretHash;
  final DateTime pairedAt;
  final DateTime? lastSeen;

  PcDevice seen(DateTime when) => PcDevice(
    id: id,
    name: name,
    secretHash: secretHash,
    pairedAt: pairedAt,
    lastSeen: when,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'hash': secretHash,
    'paired': pairedAt.millisecondsSinceEpoch,
    if (lastSeen != null) 'seen': lastSeen!.millisecondsSinceEpoch,
  };

  static PcDevice? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final hash = json['hash'];
    final paired = json['paired'];
    if (id is! String || hash is! String || paired is! int) return null;
    final seen = json['seen'];
    return PcDevice(
      id: id,
      name: json['name'] as String? ?? '',
      secretHash: hash,
      pairedAt: DateTime.fromMillisecondsSinceEpoch(paired),
      lastSeen: seen is int ? DateTime.fromMillisecondsSinceEpoch(seen) : null,
    );
  }
}
