import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../../di.dart';

/// Where the computer is and the certificate it must show: device-only
/// settings, never in a backup.
const pcPairingKey = 'pc_link_pairing';

/// What the computer had last time, for the page while it is away.
const pcCacheKey = 'pc_link_cache';

/// The phone's secret for the computer, in Android's encrypted store.
const pcSecretKey = 'pc_link_secret';

/// The add sheet's last choice between the computer and this phone, so the
/// next link goes where the last one went.
const pcSendToPcKey = 'pc_link_send_to_pc';

/// The keys a phone backup leaves out: a pairing belongs to this phone.
const pcDeviceOnlyKeys = {pcPairingKey, pcCacheKey, pcSendToPcKey};

/// Reads the pairing at startup, so the "Computer" tab is there or not
/// from the first frame; null when this phone has never paired.
Future<PcPairing?> loadPcPairing(
  KeyValueStore store,
  SecretStore secrets,
) async {
  try {
    final raw = await store.getString(pcPairingKey);
    final secret = await secrets.read(pcSecretKey);
    if (raw == null || raw.isEmpty || secret == null) return null;
    final json = jsonDecode(raw);
    if (json is! Map) return null;
    return PcPairing.fromJson({...json, 'secret': secret});
  } on Object {
    return null;
  }
}

/// Overridden in main with what [loadPcPairing] read.
final initialPcPairingProvider = Provider<PcPairing?>((ref) => null);

/// The computer this phone is paired with. **Null for most people**, and
/// then nothing of the feature shows: no tab, no choice in the add sheet.
final pcPairingProvider = NotifierProvider<PcPairingNotifier, PcPairing?>(
  PcPairingNotifier.new,
);

class PcPairingNotifier extends Notifier<PcPairing?> {
  @override
  PcPairing? build() => ref.read(initialPcPairingProvider);

  Future<void> save(PcPairing pairing) async {
    await ref.read(secretStoreProvider).write(pcSecretKey, pairing.secret);
    await _keep(pairing);
  }

  /// The computer's addresses as it last gave them. The route in use stays
  /// the owner's to change, never switched behind their back (owner's
  /// choice, 2026-11-10).
  Future<void> learnRoutes(List<PcAddress> routes) async {
    if (state case final pairing?) {
      await _keep(pairing.copyWith(routes: routes));
    }
  }

  /// The owner's route: the home network, or Tailscale away from home.
  Future<void> useRoute(String host) async {
    if (state case final pairing?) await _keep(pairing.copyWith(host: host));
  }

  /// Saves all but the secret, which stays in the encrypted store.
  Future<void> _keep(PcPairing pairing) async {
    final store = ref.read(keyValueStoreProvider);
    final json = pairing.toJson()..remove('secret');
    await ref
        .read(prefsMutexProvider)
        .run(() => store.setString(pcPairingKey, jsonEncode(json)));
    state = pairing;
  }

  /// Unpairs on this side; the computer forgets the phone from its own list.
  Future<void> forget() async {
    final store = ref.read(keyValueStoreProvider);
    await ref.read(secretStoreProvider).delete(pcSecretKey);
    await ref.read(prefsMutexProvider).run(() async {
      await store.remove(pcPairingKey);
      await store.remove(pcCacheKey);
    });
    state = null;
  }
}

/// The phone's name as its owner set it, for the computer's list.
Future<String> phoneName() async {
  try {
    final name = await const MethodChannel('vidhoist_mobile/media')
        .invokeMethod<String>('deviceName');
    if (name != null && name.trim().isNotEmpty) return name.trim();
  } on Object {
    // No channel in tests.
  }
  return 'Android';
}

/// "192.168.1.24:47321" or "192.168.1.24" as typed: the host and port, or
/// null when it is not an address on a home network.
(String, int)? parsePcAddress(String text) {
  final trimmed = text.trim().replaceFirst(RegExp(r'^https?://'), '');
  final match = RegExp(
    r'^([0-9]{1,3}(?:\.[0-9]{1,3}){3}|[A-Za-z0-9.-]+)(?::([0-9]{1,5}))?/?$',
  ).firstMatch(trimmed);
  if (match == null) return null;
  final port = match.group(2) == null
      ? PcLink.defaultPort
      : int.parse(match.group(2)!);
  if (port < 1 || port > 65535) return null;
  final host = match.group(1)!;
  final parts = host.split('.');
  if (parts.length == 4 && parts.every((p) => int.tryParse(p) != null)) {
    if (parts.any((p) => int.parse(p) > 255)) return null;
  }
  return (host, port);
}
