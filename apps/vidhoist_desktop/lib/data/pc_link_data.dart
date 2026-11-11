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

/// "Let the phone delete clips", off until the owner turns it on, and
/// device-only too: a backup must not carry that permission to another
/// computer.
const pcLinkDeleteKey = 'pc_link_allow_delete';

/// The keys a backup leaves out.
const pcLinkDeviceOnlyKeys = {
  pcLinkEnabledKey,
  pcLinkDevicesKey,
  pcLinkDeleteKey,
};

final pcLinkEnabledProvider = NotifierProvider<PcLinkSwitch, bool>(
  () => PcLinkSwitch(pcLinkEnabledKey),
);

final pcLinkDeleteProvider = NotifierProvider<PcLinkSwitch, bool>(
  () => PcLinkSwitch(pcLinkDeleteKey),
);

/// A switch of the link's, off until turned on, kept under [key].
class PcLinkSwitch extends Notifier<bool> {
  PcLinkSwitch(this.key);

  final String key;

  @override
  bool build() {
    ref
        .read(keyValueStoreProvider)
        .getBool(key)
        .then((saved) => state = saved ?? false, onError: (_) {});
    return false;
  }

  Future<void> set(bool on) {
    state = on;
    return ref
        .read(prefsMutexProvider)
        .run(() => ref.read(keyValueStoreProvider).setBool(key, on));
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
final FutureProvider<PcLinkSession?> pcLinkProvider =
    FutureProvider<PcLinkSession?>((ref) async {
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
        host: DesktopPcHost(
          ref,
          name: computerName(),
          version: version,
          // Read when the phone asks: the list is loaded by then, and a newer
          // one (a new Wi-Fi) is what the phone should learn.
          addresses: () =>
              ref.read(pcLinkAddressesProvider).valueOrNull ?? const [],
        ),
        pairing: pairing,
        name: computerName(),
        onLog: (message) => _log(ref, message),
      );
      final port = await server.start();
      // So a paired phone finds this computer again when the router gives it
      // another address, and a pairing phone finds it without typing.
      final finder = PcDiscoveryResponder(
        pairing: pairing,
        linkPort: port,
        name: computerName(),
        onLog: (message) => _log(ref, message),
      );
      await finder.start();
      ref.onDispose(() {
        finder.stop();
        unawaited(server.stop());
        unawaited(pairing.dispose());
      });
      return PcLinkSession(server: server, pairing: pairing, port: port);
    });

/// The paired phones as they change: the settings list reads its count,
/// which a value read once left at "No phone" after a pairing (2026-11-09).
final pcLinkDevicesProvider = StreamProvider<List<PcDevice>>((ref) async* {
  final session = await ref.watch(pcLinkProvider.future);
  if (session == null) return;
  final pairing = session.pairing;
  yield pairing.devices;
  await for (final _ in pairing.changes) {
    yield pairing.devices;
  }
});

/// This computer's IPv4 addresses, the one a phone at home dials first.
final FutureProvider<List<PcAddress>> pcLinkAddressesProvider =
    FutureProvider<List<PcAddress>>((ref) async {
      ref.watch(pcLinkProvider);
      // Looked at again each minute: a new Wi-Fi or a new address from the
      // router is what the phone should learn next time it asks.
      final again = Timer(const Duration(minutes: 1), ref.invalidateSelf);
      ref.onDispose(again.cancel);
      try {
        final interfaces = await NetworkInterface.list(
          type: InternetAddressType.IPv4,
        );
        return sortPcAddresses([
          for (final i in interfaces)
            for (final a in i.addresses)
              if (!a.isLoopback && !a.isLinkLocal) (i.name, a.address),
        ]);
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
