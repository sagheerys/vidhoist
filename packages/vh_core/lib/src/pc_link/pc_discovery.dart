import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';

import 'pc_addresses.dart';
import 'pc_link_wire.dart';
import 'pc_pairing.dart';

/// **Finding the computer on the home network** without typing its address:
/// one UDP datagram sent to the whole network, one answer back.
///
/// The computer stays silent unless the asker has a reason to know it is
/// there: a phone paired with it, which proves so with a code made from its
/// secret, or anyone while the owner shows a pairing code (two minutes),
/// told only the computer's name and port. A stranger's probe gets nothing,
/// as a scan of the HTTPS port gets an empty 404. The answer only says where
/// to dial; the certificate pin and the secret decide everything after it.
abstract final class PcDiscovery {
  /// UDP, the same number as the link's TCP port.
  static const port = PcLink.defaultPort;

  /// Larger datagrams are not ours and are dropped unread.
  static const maxDatagram = 512;

  /// How long the phone listens for answers.
  static const wait = Duration(seconds: 2);
}

/// What only the phone and the computer can make: the computer keeps the
/// secret's hash, so the hash is the key.
String _proof(String secretHashHex, String text) => Hmac(
  sha256,
  utf8.encode(secretHashHex),
).convert(utf8.encode(text)).toString();

/// A computer that answered.
class PcFound {
  const PcFound({required this.host, required this.port, this.name});

  /// The address the answer came from: the one that reaches it.
  final String host;
  final int port;

  /// Given only to a phone pairing.
  final String? name;

  @override
  bool operator ==(Object other) =>
      other is PcFound &&
      other.host == host &&
      other.port == port &&
      other.name == name;

  @override
  int get hashCode => Object.hash(host, port, name);

  @override
  String toString() => 'PcFound($host:$port)';
}

/// The computer's end: answers on UDP while "receive from the phone" is on.
class PcDiscoveryResponder {
  PcDiscoveryResponder({
    required this.pairing,
    required this.linkPort,
    required this.name,
    this.onLog,
    this.perSecond = 20,
  });

  final PcPairingWindow pairing;

  /// The HTTPS port the phone should dial.
  final int linkPort;
  final String name;
  final void Function(String message)? onLog;

  /// Answers at most this many datagrams a second: a flood gets the rest
  /// dropped, not a reply each.
  final int perSecond;

  RawDatagramSocket? _socket;
  var _second = 0;
  var _answered = 0;

  int? get port => _socket?.port;

  /// Listens on [port]; null when another program holds it, and then the
  /// phone types the address as before.
  Future<int?> start({InternetAddress? address, int? port}) async {
    stop();
    try {
      final socket = await RawDatagramSocket.bind(
        address ?? InternetAddress.anyIPv4,
        port ?? PcDiscovery.port,
      );
      _socket = socket;
      socket.listen((event) {
        if (event == RawSocketEvent.read) _read(socket);
      });
      return socket.port;
    } on SocketException catch (e) {
      onLog?.call('find: not listening: $e');
      return null;
    }
  }

  void stop() {
    _socket?.close();
    _socket = null;
  }

  void _read(RawDatagramSocket socket) {
    final datagram = socket.receive();
    if (datagram == null || !_allowed()) return;
    final reply = answer(datagram.data);
    if (reply == null) return;
    try {
      socket.send(reply, datagram.address, datagram.port);
    } on SocketException {
      // The asker's network went away; it asks again.
    }
  }

  bool _allowed() {
    final second = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (second != _second) {
      _second = second;
      _answered = 0;
    }
    return ++_answered <= perSecond;
  }

  /// The reply to [datagram], or null for silence.
  List<int>? answer(List<int> datagram) {
    final json = _decode(datagram);
    if (json == null) return null;
    switch (json['vh']) {
      case 'find':
        final id = json['id'];
        final nonce = json['n'];
        final proof = json['m'];
        if (id is! String || nonce is! String || proof is! String) return null;
        if (nonce.isEmpty || nonce.length > 64) return null;
        final device = pairing.devices.where((d) => d.id == id).firstOrNull;
        if (device == null) return null;
        final expected = _proof(device.secretHash, 'find:$id:$nonce');
        if (!constantTimeEquals(expected, proof)) return null;
        return _encode({
          'vh': 'here',
          'n': nonce,
          'port': linkPort,
          'm': _proof(device.secretHash, 'here:$id:$nonce:$linkPort'),
        });
      case 'find-pair':
        if (!pairing.isOpen) return null;
        return _encode({'vh': 'pairable', 'port': linkPort, 'name': name});
    }
    return null;
  }
}

Map<Object?, Object?>? _decode(List<int> datagram) {
  if (datagram.length > PcDiscovery.maxDatagram) return null;
  try {
    final json = jsonDecode(utf8.decode(datagram));
    return json is Map ? json : null;
  } on FormatException {
    return null;
  }
}

List<int> _encode(Map<String, Object?> json) => utf8.encode(jsonEncode(json));

int? _portOf(Object? value) =>
    value is int && value > 0 && value < 65536 ? value : null;

/// Looks for the computer [pairing] names, for when its address changed (a
/// router gives it another): where it answered from, or null. An answer
/// without the computer's proof is ignored.
Future<PcFound?> pcFindPaired(
  PcPairing pairing, {
  List<InternetAddress>? targets,
  int port = PcDiscovery.port,
  Duration wait = PcDiscovery.wait,
  Random? random,
}) async {
  final id = pairing.deviceId;
  final hash = secretHash(pairing.secret);
  final nonce = newSecret(random).substring(0, 22);
  PcFound? found;
  await _ask(
    {'vh': 'find', 'id': id, 'n': nonce, 'm': _proof(hash, 'find:$id:$nonce')},
    targets: targets,
    port: port,
    wait: wait,
    onReply: (datagram) {
      final json = _decode(datagram.data);
      final linkPort = _portOf(json?['port']);
      final proof = json?['m'];
      if (json?['vh'] != 'here' || json?['n'] != nonce) return false;
      if (linkPort == null || proof is! String) return false;
      final expected = _proof(hash, 'here:$id:$nonce:$linkPort');
      if (!constantTimeEquals(expected, proof)) return false;
      found = PcFound(host: datagram.address.address, port: linkPort);
      return true;
    },
  );
  return found;
}

/// The computers showing a pairing code on this network right now.
Future<List<PcFound>> pcFindPairable({
  List<InternetAddress>? targets,
  int port = PcDiscovery.port,
  Duration wait = PcDiscovery.wait,
}) async {
  final found = <PcFound>{};
  await _ask(
    {'vh': 'find-pair'},
    targets: targets,
    port: port,
    wait: wait,
    onReply: (datagram) {
      final json = _decode(datagram.data);
      final linkPort = _portOf(json?['port']);
      final name = json?['name'];
      if (json?['vh'] != 'pairable' || linkPort == null) return false;
      found.add(
        PcFound(
          host: datagram.address.address,
          port: linkPort,
          name: name is String && name.length <= 64 ? name : null,
        ),
      );
      return false;
    },
  );
  return found.toList();
}

/// Sends [probe] to [targets] (the whole network by default) twice, a
/// datagram lost on Wi-Fi being common, and passes each answer to
/// [onReply] until it returns true or [wait] runs out.
Future<void> _ask(
  Map<String, Object?> probe, {
  required List<InternetAddress>? targets,
  required int port,
  required Duration wait,
  required bool Function(Datagram datagram) onReply,
}) async {
  final RawDatagramSocket socket;
  try {
    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  } on SocketException {
    return;
  }
  socket.broadcastEnabled = true;
  final done = Completer<void>();
  void finish() {
    if (!done.isCompleted) done.complete();
  }

  socket.listen((event) {
    if (event != RawSocketEvent.read) return;
    final datagram = socket.receive();
    if (datagram != null && onReply(datagram)) finish();
  });
  final to = targets ?? await pcBroadcastTargets();
  final bytes = _encode(probe);
  void send() {
    for (final target in to) {
      try {
        socket.send(bytes, target, port);
      } on SocketException {
        // One network refusing a broadcast leaves the others.
      }
    }
  }

  send();
  final again = Timer(wait ~/ 4, send);
  final timeout = Timer(wait, finish);
  await done.future;
  again.cancel();
  timeout.cancel();
  socket.close();
}

/// Everyone on the phone's networks: the limited broadcast, and each home
/// network's own (taken as a /24, the size home routers hand out).
Future<List<InternetAddress>> pcBroadcastTargets() async {
  final targets = {'255.255.255.255'};
  try {
    for (final i in await NetworkInterface.list(
      type: InternetAddressType.IPv4,
    )) {
      for (final a in i.addresses) {
        if (pcAddressKind(i.name, a.address) != PcAddressKind.home) continue;
        final parts = a.address.split('.');
        targets.add('${parts[0]}.${parts[1]}.${parts[2]}.255');
      }
    }
  } on Object {
    // The limited broadcast alone still reaches most home networks.
  }
  return [for (final t in targets) InternetAddress(t)];
}
