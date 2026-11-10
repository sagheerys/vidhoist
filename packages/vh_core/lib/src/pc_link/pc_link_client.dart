import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'pc_certificate.dart';
import 'pc_link_api.dart';
import 'pc_link_models.dart';
import 'pc_reach.dart';
import 'pc_link_wire.dart';

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
  ///
  /// With [fingerprint], read from the computer's QR code, only that
  /// certificate is accepted: anything else fails the handshake with
  /// [PcLinkFailure.wrongCertificate] before the code is sent.
  static Future<PcPairing> pair({
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
    final http = _pinnedClient((fp) {
      if (fingerprint != null && fp != fingerprint) {
        wrong = true;
        return false;
      }
      // Typed by hand, any certificate is accepted *for comparison*: the
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
      if (wrong) throw const PcLinkException(PcLinkFailure.wrongCertificate);
      throw PcLinkException(PcLinkFailure.unreachable, '$e');
    } finally {
      http.close(force: true);
    }
  }

  /// The first of [hosts], in their order, where the computer with
  /// [fingerprint] answers on [port]; see [pcReach].
  static Future<String?> reach({
    required List<String> hosts,
    required int port,
    required String fingerprint,
    Duration timeout = const Duration(seconds: 3),
  }) => pcReach(
    hosts: hosts,
    port: port,
    fingerprint: fingerprint,
    timeout: timeout,
  );

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
  Future<PcFileResponse> file(String id, {String? range}) async {
    final response = await _open(
      'GET',
      '${PcLink.libraryPath}/${Uri.encodeComponent(id)}/${PcLink.fileSegment}',
      headers: {HttpHeaders.rangeHeader: ?range},
    );
    return PcFileResponse(
      statusCode: response.statusCode,
      headers: {
        for (final name in PcFileResponse.passed)
          name: ?response.headers.value(name),
      },
      body: response,
    );
  }

  @override
  Future<List<Object?>> transcripts(String id) async {
    final (code, body) = await _send(
      'GET',
      '${PcLink.libraryPath}/${Uri.encodeComponent(id)}/transcripts',
    );
    if (code == HttpStatus.notFound) return const [];
    if (code != HttpStatus.ok) {
      throw PcLinkException(PcLinkFailure.badResponse, '$code');
    }
    final json = _decode(body);
    final list = json is Map ? json['transcripts'] : null;
    return list is List ? list : const [];
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
    final response = await _open(method, path, query: query, body: body);
    try {
      return (
        response.statusCode,
        await _readBody(response).timeout(timeout * 4),
      );
    } on Object catch (e) {
      throw _failure(e);
    }
  }

  /// The computer's response with its body still to read; a forgotten
  /// phone learns so here.
  Future<HttpClientResponse> _open(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
    Map<String, String> headers = const {},
  }) async {
    _sawWrongCertificate = false;
    final HttpClientResponse response;
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
      headers.forEach(request.headers.set);
      if (body != null) {
        request.headers.contentType = ContentType.json;
        request.write(jsonEncode(body));
      }
      response = await request.close().timeout(timeout);
    } on Object catch (e) {
      throw _failure(e);
    }
    if (response.statusCode == HttpStatus.unauthorized) {
      unawaited(response.drain<void>().catchError((Object _) {}));
      throw const PcLinkException(PcLinkFailure.unauthorized);
    }
    return response;
  }

  PcLinkException _failure(Object e) => PcLinkException(
    _sawWrongCertificate
        ? PcLinkFailure.wrongCertificate
        : PcLinkFailure.unreachable,
    '$e',
  );

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
