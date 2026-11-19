import 'dart:async';
import 'dart:math';

import 'pc_link_wire.dart';

/// Where the computer keeps its paired phones (secret hashes only).
abstract interface class PcDeviceStore {
  Future<List<PcDevice>> load();
  Future<void> save(List<PcDevice> devices);
}

class MemoryPcDeviceStore implements PcDeviceStore {
  List<PcDevice> devices = [];

  @override
  Future<List<PcDevice>> load() async => [...devices];

  @override
  Future<void> save(List<PcDevice> devices) async =>
      this.devices = [...devices];
}

/// A phone that typed the right code and now waits for the person at the
/// computer to allow it on its screen, where [check] is shown beside [name]
/// for comparison with the phone's.
class PcPairingRequest {
  PcPairingRequest({required this.name, required this.check});

  final String name;
  final String check;
  final _answer = Completer<bool>();

  Future<bool> get answer => _answer.future;
  bool get isOpen => !_answer.isCompleted;

  void allow() {
    if (isOpen) _answer.complete(true);
  }

  void deny() {
    if (isOpen) _answer.complete(false);
  }
}

/// Why a pairing attempt was refused, for the phone's message.
enum PcPairRefusal { closed, wrongCode, denied }

/// The pairing window and the list of paired phones. The window opens only
/// when the user asks for a code on the computer, shuts after
/// [PcLink.pairWindow] or [PcLink.maxAttempts] wrong codes or one success,
/// and nothing can pair while it is shut.
class PcPairingWindow {
  PcPairingWindow({
    required this.store,
    required this.fingerprint,
    DateTime Function()? clock,
    Random? random,
  }) : _clock = clock ?? DateTime.now,
       _random = random ?? Random.secure();

  final PcDeviceStore store;
  final String fingerprint;
  final DateTime Function() _clock;
  final Random _random;

  String? _code;
  DateTime? _expires;
  var _attempts = 0;
  List<PcDevice> _devices = [];
  final _requests = StreamController<PcPairingRequest>.broadcast();
  final _changes = StreamController<void>.broadcast();

  Future<void> load() async => _devices = await store.load();

  List<PcDevice> get devices => List.unmodifiable(_devices);

  /// Asks for the user's answer; the computer's screen listens.
  Stream<PcPairingRequest> get requests => _requests.stream;

  /// The window or the devices changed.
  Stream<void> get changes => _changes.stream;

  /// The code on the computer's screen while the window is open.
  String? get code => isOpen ? _code : null;
  DateTime? get expires => isOpen ? _expires : null;

  bool get isOpen =>
      _code != null && _expires != null && _clock().isBefore(_expires!);

  String open() {
    _code = newPairingCode(_random);
    _expires = _clock().add(PcLink.pairWindow);
    _attempts = 0;
    _changes.add(null);
    return _code!;
  }

  void close() {
    _code = null;
    _expires = null;
    _changes.add(null);
  }

  /// A phone's attempt: the device and its secret once the user allows
  /// it, or why not.
  Future<({PcDevice? device, String? secret, PcPairRefusal? refusal})> attempt({
    required String code,
    required String name,
    required String nonce,
  }) async {
    if (!isOpen) {
      return (device: null, secret: null, refusal: PcPairRefusal.closed);
    }
    if (!constantTimeEquals(code, _code!)) {
      _attempts++;
      if (_attempts >= PcLink.maxAttempts) close();
      return (device: null, secret: null, refusal: PcPairRefusal.wrongCode);
    }
    // One code, one pairing: a second phone needs a new code.
    final used = _code!;
    close();
    final request = PcPairingRequest(
      name: _clean(name),
      check: pairingCheck(fingerprint: fingerprint, code: used, nonce: nonce),
    );
    _requests.add(request);
    final allowed = await request.answer.timeout(
      PcLink.approvalWait,
      onTimeout: () => false,
    );
    request.deny();
    if (!allowed) {
      return (device: null, secret: null, refusal: PcPairRefusal.denied);
    }
    final secret = newSecret(_random);
    final device = PcDevice(
      id: newSecret(_random).substring(0, 16),
      name: request.name,
      secretHash: secretHash(secret),
      pairedAt: _clock(),
    );
    _devices = [..._devices, device];
    await store.save(_devices);
    _changes.add(null);
    return (device: device, secret: secret, refusal: null);
  }

  /// The paired device [id] presenting [secret], or null.
  PcDevice? verify(String? id, String? secret) {
    if (id == null || secret == null) return null;
    for (final device in _devices) {
      if (device.id == id &&
          constantTimeEquals(secretHash(secret), device.secretHash)) {
        return device;
      }
    }
    return null;
  }

  /// Notes that [device] was heard from; saved at most once a minute.
  Future<void> touch(PcDevice device) async {
    final now = _clock();
    final last = device.lastSeen;
    if (last != null && now.difference(last) < const Duration(minutes: 1)) {
      return;
    }
    _devices = [for (final d in _devices) d.id == device.id ? d.seen(now) : d];
    await store.save(_devices);
    _changes.add(null);
  }

  /// Forgets a phone: its secret stops working at once.
  Future<void> revoke(String id) async {
    _devices = [
      for (final d in _devices)
        if (d.id != id) d,
    ];
    await store.save(_devices);
    _changes.add(null);
  }

  Future<void> dispose() async {
    await _requests.close();
    await _changes.close();
  }

  static String _clean(String name) {
    final trimmed = name.replaceAll(RegExp(r'[\x00-\x1f]'), '').trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.length > 40 ? trimmed.substring(0, 40) : trimmed;
  }
}
