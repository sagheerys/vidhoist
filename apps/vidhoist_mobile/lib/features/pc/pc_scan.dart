import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

/// Opens the camera on the computer's pairing QR code and answers with what
/// it read, or null when the owner backed out. Android's own scanner screen
/// (zxing, open source), behind the media channel; replaced in tests.
typedef PcScanner = Future<String?> Function(String prompt);

const _channel = MethodChannel('vidhoist_mobile/media');

final pcScannerProvider = Provider<PcScanner>(
  (ref) =>
      (prompt) => _channel.invokeMethod<String>('scanQr', {'prompt': prompt}),
);

/// Pairs from a scanned offer: the first of its addresses that answers with
/// its certificate, then the pairing with that certificate pinned from the
/// first byte.
typedef PcOfferPairer = Future<PcPairing> Function({
  required PcPairOffer offer,
  required String phoneName,
  required void Function(String check) onCheck,
});

final pcOfferPairerProvider = Provider<PcOfferPairer>(
  (ref) => ({required offer, required phoneName, required onCheck}) async {
    final host = await PcLinkClient.reach(
      hosts: offer.hosts,
      port: offer.port,
      fingerprint: offer.fingerprint,
    );
    if (host == null) {
      throw const PcLinkException(PcLinkFailure.unreachable);
    }
    return PcLinkClient.pair(
      host: host,
      port: offer.port,
      code: offer.code,
      phoneName: phoneName,
      onCheck: onCheck,
      fingerprint: offer.fingerprint,
    );
  },
);
