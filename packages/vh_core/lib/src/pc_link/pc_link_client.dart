import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'pc_certificate.dart';
import 'pc_link_models.dart';
import 'pc_link_wire.dart';

/// Why a call to the computer failed, in the terms the phone shows.
enum PcLinkFailure {
  /// Off, asleep, on another network, or a firewall in the way.
  unreachable,

  /// Something answered with another certificate: not our computer, or a
  /// machine in the middle. Nothing was sent.
  wrongCertificate,

  /// The computer forgot this phone; pair again.
  unauthorized,

  /// No pairing window on the computer (no code shown, or it expired).
  pairingClosed,
  wrongCode,

  /// The owner refused on the computer, or did not answer in time.
  pairingDenied,

  /// The computer would not take the link.
  refused,
  badResponse,
}

class PcLinkException implements Exception {
  const PcLinkException(this.failure, [this.detail]);

  final PcLinkFailure failure;
  final String? detail;

  @override
  String toString() =>
      'PcLinkException(${failure.name}${detail == null ? '' : ': $detail'})';
}

/// What the phone asks of the computer once paired; [PcLinkClient] over the
/// network, a fake in tests.
abstract interface class PcLinkApi {
  Future<PcStatus> status();
  Future<List<PcTask>> tasks();
  Future<PcTask> submit(String url, String quality);
  Future<bool> cancel(String id);
  Future<PcLibraryPage> library({
    int offset = 0,
    int limit = 100,
    String? query,
  });
  Future<Uint8List?> cover(String id);
  void close();
}

/// The phone's end of the link. **It trusts one certificate, the one it saw
/// when it paired**: no authority, no system store. Anything else fails the
/// handshake before a byte of the request leaves the phone.
class PcLinkClient implements PcLinkApi {
  PcLinkClient(this.pairing, {this.timeout = const Duration(seconds: 6)}) {
    _http = _pinnedClient((fp) {
      final match = fp == pairing.fingerprint;
      if (!match) _sawWrongCertificate = true;
      return match;
    }, timeout);
  }

  final PcPairing pairing;
  final Duration timeout;
  late final HttpClient _http;
  var _sawWrongCertificate = false;

  /// Pairs with the computer at [host]:[port] using the [code] on its
  /// screen. [onCheck] receives the four digits to compare with the
  /// computer's as soon as the connection is made; the call then waits,
  /// up to [PcLink.approvalWait], for the owner to allow the phone there.
  static Future<PcPairing> pair({
    required String host,
    required int port,
    required String code,
    required String phoneName,
    required void Function(String check) onCheck,
  }) async {
    final nonce = newSecret();
    String? seen;
    final http = _pinnedClient((fp) {
      // While pairing, any certificate is accepted *for comparison*: the
      // owner compares the four digits it yields with the computer's.
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
      final body = await _readBody(response);
      if (response.statusCode == HttpStatus.notFound) {
        throw const PcLinkException(PcLinkFailure.pairingClosed);
      }
      final json = _decode(body);
      if (response.statusCode == HttpStatus.forbidden) {
        throw PcLinkException(switch (json is Map ? json['error'] : null) {
          'wrongCode' => PcLinkFailure.wrongCode,
          'closed' => PcLinkFailure.pairingClosed,
          _ => PcLinkFailure.pairingDenied,
        });
      }
      if (response.statusCode != HttpStatus.ok ||
          json is! Map ||
          seen == null) {
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
      throw PcLinkException(PcLinkFailure.unreachable, '$e');
    } finally {
      http.close(force: true);
    }
  }

  @override
  Future<PcStatus> status() async {
    final status = PcStatus.fromJson(await _getJson(PcLink.statusPath));
    if (status == null) throw const PcLinkException(PcLinkFailure.badResponse);
    return status;
  }

  @override
  Future<List<PcTask>> tasks() async {
    final json = await _getJson(PcLink.downloadsPath);
    final raw = json is Map ? json['tasks'] : null;
    return [
      if (raw is List)
        for (final entry in raw) ?PcTask.fromJson(entry),
    ];
  }

  @override
  Future<PcTask> submit(String url, String quality) async {
    final (code, body) = await _send(
      'POST',
      PcLink.downloadsPath,
      body: {'url': url, 'quality': quality},
    );
    if (code == HttpStatus.badRequest ||
        code == HttpStatus.unprocessableEntity) {
      throw const PcLinkException(PcLinkFailure.refused);
    }
    final task = PcTask.fromJson(_decode(body));
    if (code != HttpStatus.ok || task == null) {
      throw PcLinkException(PcLinkFailure.badResponse, '$code');
    }
    return task;
  }

  @override
  Future<bool> cancel(String id) async {
    final (code, _) = await _send(
      'POST',
      '${PcLink.downloadsPath}/${Uri.encodeComponent(id)}/cancel',
    );
    return code == HttpStatus.noContent;
  }

  @override
  Future<PcLibraryPage> library({
    int offset = 0,
    int limit = 100,
    String? query,
  }) async => PcLibraryPage.fromJson(
    await _getJson(PcLink.libraryPath, {
      'offset': '$offset',
      'limit': '$limit',
      if (query != null && query.isNotEmpty) 'q': query,
    }),
  );

  /// A cover kept on the computer, or null.
  @override
  Future<Uint8List?> cover(String id) async {
    final (code, body) = await _send(
      'GET',
      '${PcLink.libraryPath}/${Uri.encodeComponent(id)}/cover',
    );
    return code == HttpStatus.ok ? body : null;
  }

  @override
  void close() => _http.close(force: true);

  Future<Object?> _getJson(String path, [Map<String, String>? query]) async {
    final (code, body) = await _send('GET', path, query: query);
    if (code != HttpStatus.ok) {
      throw PcLinkException(PcLinkFailure.badResponse, '$code');
    }
    return _decode(body);
  }

  Future<(int, Uint8List)> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
  }) async {
    _sawWrongCertificate = false;
    try {
      final uri = Uri(
        scheme: 'https',
        host: pairing.host,
        port: pairing.port,
        path: path,
        queryParameters: query,
      );
      final request = await _http.openUrl(method, uri).timeout(timeout);
      request.headers
        ..set(HttpHeaders.authorizationHeader, 'Bearer ${pairing.secret}')
        ..set(PcLink.deviceHeader, pairing.deviceId);
      if (body != null) {
        request.headers.contentType = ContentType.json;
        request.write(jsonEncode(body));
      }
      final response = await request.close().timeout(timeout);
      final bytes = await _readBody(response).timeout(timeout * 4);
      if (response.statusCode == HttpStatus.unauthorized) {
        throw const PcLinkException(PcLinkFailure.unauthorized);
      }
      return (response.statusCode, bytes);
    } on PcLinkException {
      rethrow;
    } on Object catch (e) {
      throw PcLinkException(
        _sawWrongCertificate
            ? PcLinkFailure.wrongCertificate
            : PcLinkFailure.unreachable,
        '$e',
      );
    }
  }

  static HttpClient _pinnedClient(
    bool Function(String fp) accept,
    Duration timeout,
  ) {
    // No trusted roots: every certificate goes through the callback, so a
    // certificate some authority signed cannot slip past the pin.
    return HttpClient(context: SecurityContext(withTrustedRoots: false))
      ..connectionTimeout = timeout
      ..idleTimeout = const Duration(seconds: 15)
      ..userAgent = null
      ..badCertificateCallback = (cert, host, port) =>
          accept(fingerprintOf(cert.der));
  }

  static Future<Uint8List> _readBody(HttpClientResponse response) async {
    final builder = BytesBuilder(copy: false);
    await for (final chunk in response) {
      builder.add(chunk);
    }
    return builder.takeBytes();
  }

  static Object? _decode(Uint8List body) {
    if (body.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(body));
    } on FormatException {
      return null;
    }
  }
}
