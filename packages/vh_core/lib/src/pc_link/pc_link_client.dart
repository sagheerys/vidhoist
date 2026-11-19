import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'pc_link_api.dart';
import 'pc_link_http.dart';
import 'pc_link_models.dart';
import 'pc_link_pair.dart';
import 'pc_reach.dart';
import 'pc_link_wire.dart';

/// The phone's end of the link. **It trusts one certificate, the one it saw
/// when it paired**: no authority, no system store. Anything else fails the
/// handshake before a byte of the request leaves the phone.
class PcLinkClient implements PcLinkApi {
  PcLinkClient(this.pairing, {this.timeout = const Duration(seconds: 6)}) {
    _http = pcPinnedClient((fp) {
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
  /// up to [PcLink.approvalWait], for the person at the computer to allow
  /// the phone there.
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
  }) => pcPair(
    host: host,
    port: port,
    code: code,
    phoneName: phoneName,
    onCheck: onCheck,
    fingerprint: fingerprint,
  );

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
    final task = PcTask.fromJson(pcDecodeJson(body));
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
    final json = pcDecodeJson(body);
    final list = json is Map ? json['transcripts'] : null;
    return list is List ? list : const [];
  }

  @override
  Future<List<PcList>> lists() async {
    final (code, body) = await _send('GET', PcLink.listsPath);
    // An older computer has no lists to give.
    if (code == HttpStatus.notFound) return const [];
    if (code != HttpStatus.ok) {
      throw PcLinkException(PcLinkFailure.badResponse, '$code');
    }
    final json = pcDecodeJson(body);
    final raw = json is Map ? json['lists'] : null;
    return [
      if (raw is List)
        for (final entry in raw) ?PcList.fromJson(entry),
    ];
  }

  @override
  Future<PcList?> list(String id) async {
    final (code, body) = await _send(
      'GET',
      '${PcLink.listsPath}/${Uri.encodeComponent(id)}',
    );
    if (code == HttpStatus.notFound) return null;
    if (code != HttpStatus.ok) {
      throw PcLinkException(PcLinkFailure.badResponse, '$code');
    }
    return PcList.fromJson(pcDecodeJson(body));
  }

  @override
  Future<PcDeleteOutcome> delete(String id) async {
    final (code, body) = await _send(
      'DELETE',
      '${PcLink.libraryPath}/${Uri.encodeComponent(id)}',
    );
    if (code == HttpStatus.noContent) return PcDeleteOutcome.deleted;
    if (code == HttpStatus.notFound) return PcDeleteOutcome.missing;
    final json = pcDecodeJson(body);
    final error = json is Map ? json['error'] : null;
    return PcLink.deleteRefusals[error] ??
        (code == HttpStatus.forbidden
            ? PcDeleteOutcome.notAllowed
            : PcDeleteOutcome.failed);
  }

  @override
  void close() => _http.close(force: true);

  Future<Object?> _getJson(String path, [Map<String, String>? query]) async {
    final (code, body) = await _send('GET', path, query: query);
    if (code != HttpStatus.ok) {
      throw PcLinkException(PcLinkFailure.badResponse, '$code');
    }
    return pcDecodeJson(body);
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
        await pcReadBody(response).timeout(timeout * 4),
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
}
