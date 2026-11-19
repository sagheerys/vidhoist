import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';

import 'der.dart';

/// The computer's own TLS identity: a P-256 key and a certificate it signs
/// itself. No authority vouches for it; the phone trusts it because it
/// learned its [fingerprint] while the user watched the pairing, and
/// refuses any other certificate afterwards (pinning, as KDE Connect and
/// Syncthing do).
class PcCertificate {
  PcCertificate({required this.certPem, required this.keyPem})
    : fingerprint = fingerprintOf(_pemBody(certPem));

  /// A new key and certificate, valid until the end of 2049 so that a
  /// pairing never lapses on its own. The name inside says nothing about the
  /// app, so a scan of the network learns nothing from it.
  factory PcCertificate.generate({DateTime? now}) {
    final random = _secureRandom();
    final domain = ECDomainParameters('prime256v1');
    final generator = ECKeyGenerator()
      ..init(ParametersWithRandom(ECKeyGeneratorParameters(domain), random));
    final pair = generator.generateKeyPair();
    final private = pair.privateKey as ECPrivateKey;
    final public = (pair.publicKey as ECPublicKey).Q!.getEncoded(false);

    final ecdsaWithSha256 = Der.sequence([
      Der.oid([1, 2, 840, 10045, 4, 3, 2]),
    ]);
    final name = Der.sequence([
      Der.set([
        Der.sequence([
          Der.oid([2, 5, 4, 3]),
          Der.utf8String('localhost'),
        ]),
      ]),
    ]);
    final keyInfo = Der.sequence([
      Der.sequence([_ecPublicKey, _prime256v1]),
      Der.bits(public),
    ]);
    final start = (now ?? DateTime.now()).toUtc().subtract(
      const Duration(days: 1),
    );
    final serial = BigInt.parse(
      _hex(random.nextBytes(16)).replaceRange(0, 1, '1'),
      radix: 16,
    );
    final tbs = Der.sequence([
      Der.explicit(0, Der.smallInt(2)),
      Der.integer(serial),
      ecdsaWithSha256,
      name,
      Der.sequence([
        Der.utcTime(start),
        Der.utcTime(DateTime.utc(2049, 12, 31, 23, 59, 59)),
      ]),
      name,
      keyInfo,
    ]);

    // RFC 6979 nonces: the signature needs no randomness of its own.
    final signer = ECDSASigner(SHA256Digest(), HMac(SHA256Digest(), 64))
      ..init(true, PrivateKeyParameter<ECPrivateKey>(private));
    final sig = signer.generateSignature(tbs) as ECSignature;
    final cert = Der.sequence([
      tbs,
      ecdsaWithSha256,
      Der.bits(Der.sequence([Der.integer(sig.r), Der.integer(sig.s)])),
    ]);

    final sec1 = Der.sequence([
      Der.smallInt(1),
      Der.octets(Der.fixed(private.d!, 32)),
      Der.explicit(0, _prime256v1),
      Der.explicit(1, Der.bits(public)),
    ]);
    final pkcs8 = Der.sequence([
      Der.smallInt(0),
      Der.sequence([_ecPublicKey, _prime256v1]),
      Der.octets(sec1),
    ]);
    return PcCertificate(
      certPem: Der.pem('CERTIFICATE', cert),
      keyPem: Der.pem('PRIVATE KEY', pkcs8),
    );
  }

  final String certPem;
  final String keyPem;

  /// SHA-256 of the certificate, lowercase hex: what the phone pins.
  final String fingerprint;

  static final _ecPublicKey = Der.oid([1, 2, 840, 10045, 2, 1]);
  static final _prime256v1 = Der.oid([1, 2, 840, 10045, 3, 1, 7]);
}

/// SHA-256 of a certificate's DER bytes, lowercase hex.
String fingerprintOf(List<int> der) => sha256.convert(der).toString();

Uint8List _pemBody(String pem) => base64.decode(
  pem
      .split('\n')
      .where((line) => line.isNotEmpty && !line.startsWith('-----'))
      .join(),
);

String _hex(List<int> bytes) =>
    bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

SecureRandom _secureRandom() {
  final seed = Random.secure();
  return FortunaRandom()..seed(
    KeyParameter(
      Uint8List.fromList([for (var i = 0; i < 32; i++) seed.nextInt(256)]),
    ),
  );
}
