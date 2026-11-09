import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../di.dart';
import '../platform/computer_name.dart';
import 'pc_link_host.dart';
import 'update_data.dart';

/// "Receive from the phone", off until the owner turns it on: until then no
/// port is open on this computer. Kept on this device only.
const pcLinkEnabledKey = 'pc_link_enabled';

/// The paired phones (secret hashes only), also device-only: a backup
/// restored elsewhere must not let a phone into another computer.
const pcLinkDevicesKey = 'pc_link_devices';

/// The certificate and its key, in Windows' encrypted store.
const _certSecret = 'pc_link_cert';
const _keySecret = 'pc_link_key';

/// The keys a backup leaves out.
const pcLinkDeviceOnlyKeys = {pcLinkEnabledKey, pcLinkDevicesKey};

final pcLinkEnabledProvider = NotifierProvider<PcLinkEnabledNotifier, bool>(
  PcLinkEnabledNotifier.new,
);

class PcLinkEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    ref
        .read(keyValueStoreProvider)
        .getBool(pcLinkEnabledKey)
        .then((saved) => state = saved ?? false, onError: (_) {});
    return false;
  }

  Future<void> set(bool on) {
    state = on;
    return ref
        .read(prefsMutexProvider)
        .run(
          () => ref.read(keyValueStoreProvider).setBool(pcLinkEnabledKey, on),
        );
  }
}

class PrefsPcDeviceStore implements PcDeviceStore {
  PrefsPcDeviceStore(this._store, this._mutex);

  final KeyValueStore _store;
  final PrefsMutex _mutex;

  @override
  Future<List<PcDevice>> load() async {
    final raw = await _store.getString(pcLinkDevicesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw);
      return [
        if (list is List)
          for (final entry in list) ?PcDevice.fromJson(entry),
      ];
    } on FormatException {
      return [];
    }
  }

  @override
  Future<void> save(List<PcDevice> devices) => _mutex.run(
    () => _store.setString(
      pcLinkDevicesKey,
      jsonEncode([for (final d in devices) d.toJson()]),
    ),
  );
}

/// This computer's certificate: made once, then read back, so a paired
/// phone keeps recognising it across restarts.
final pcCertificateProvider = FutureProvider<PcCertificate>((ref) async {
  final secrets = ref.read(secretStoreProvider);
  final cert = await secrets.read(_certSecret);
  final key = await secrets.read(_keySecret);
  if (cert != null && key != null) {
    try {
      return PcCertificate(certPem: cert, keyPem: key);
    } on Object {
      // Damaged: make a new one; the phones pair again.
    }
  }
  final made = await Future(PcCertificate.generate);
  await secrets.write(_certSecret, made.certPem);
  await secrets.write(_keySecret, made.keyPem);
  return made;
});

/// The server and its pairing window while "receive from the phone" is on.
class PcLinkSession {
  PcLinkSession({
    required this.server,
    required this.pairing,
    required this.port,
  });

  final PcLinkServer server;
  final PcPairingWindow pairing;
  final int port;
}

/// Null while the link is off; otherwise listening on every IPv4 interface.
final pcLinkProvider = FutureProvider<PcLinkSession?>((ref) async {
  if (!ref.watch(pcLinkEnabledProvider)) return null;
  final certificate = await ref.watch(pcCertificateProvider.future);
  final pairing = PcPairingWindow(
    store: PrefsPcDeviceStore(
      ref.read(keyValueStoreProvider),
      ref.read(prefsMutexProvider),
    ),
    fingerprint: certificate.fingerprint,
  );
  await pairing.load();
  final version = await ref
      .read(installedVersionProvider.future)
      .catchError((Object _) => '');
  final server = PcLinkServer(
    certificate: certificate,
    host: DesktopPcHost(ref, name: computerName(), version: version),
    pairing: pairing,
    name: computerName(),
    onLog: (message) => _log(ref, message),
  );
  final port = await server.start();
  ref.onDispose(() {
    unawaited(server.stop());
    unawaited(pairing.dispose());
  });
  return PcLinkSession(server: server, pairing: pairing, port: port);
});

/// The addresses a phone on this network can reach: private IPv4 only.
final pcLinkAddressesProvider = FutureProvider<List<String>>((ref) async {
  ref.watch(pcLinkProvider);
  try {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
    );
    return [
      for (final i in interfaces)
        for (final a in i.addresses)
          if (!a.isLoopback && !a.isLinkLocal) a.address,
    ];
  } on Object {
    return const [];
  }
});

void _log(Ref ref, String message) {
  try {
    unawaited(ref.read(loggerProvider).log(message, tag: 'link'));
  } on Object {
    // No log in tests.
  }
}
