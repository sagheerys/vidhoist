import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'pc_certificate.dart';
import 'pc_link_http.dart';
import 'pc_link_models.dart';
import 'pc_link_wire.dart';
import 'pc_pairing.dart';
import 'pc_range.dart';

/// What the server serves, answered by the app: its download engine and
/// its library. The server knows HTTP and pairing; the host knows clips.
abstract interface class PcLinkHost {
  PcStatus status();
  List<PcTask> tasks();

  /// Queues [url]; null when the app refuses it.
  PcTask? submit(String url, String quality);
  bool cancel(String id);
  Future<PcLibraryPage> library({
    int offset = 0,
    int limit = 100,
    String? query,
    PcLibrarySort sort = PcLibrarySort.newest,
    PcLibraryKind kind = PcLibraryKind.all,
  });

  /// The cover file kept for [id], or null.
  Future<File?> cover(String id);

  /// The clip's own file, for the phone to play or copy; null when [id]
  /// is not a file in the library.
  Future<File?> file(String id);

  /// Every transcript kept for [id], each as its JSON: the phone reads them
  /// with the transcripts package, which this one does not know.
  Future<List<Object?>> transcripts(String id);

  /// The saved lists with at least one clip that is a file here.
  Future<List<PcList>> lists();

  /// One list with those clips, in its order; null when there is none.
  Future<PcList?> list(String id);

  /// Deletes the library clip [id] **to the Recycle Bin**, and only if the
  /// user let phones delete; never anything else.
  Future<PcDeleteOutcome> delete(String id);
}

/// The computer's end of the link: HTTPS on the home network.
///
/// **A scan finds a closed door with no sign on it.** Every path answers an
/// empty 404 to anyone without a paired device's secret, the certificate
/// names nobody, and `/v1/pair` exists only while the user shows a code.
/// What a paired phone may do is narrow: read the downloads, library and
/// saved lists, queue a web link, cancel a download, fetch a cover, read a
/// library clip's file and transcripts by its id, and, only where the user
/// allowed it, send one library clip to the Recycle Bin. Nothing reaches
/// the computer's settings, files outside the library, or a command line.
class PcLinkServer {
  PcLinkServer({
    required this.certificate,
    required this.host,
    required this.pairing,
    required this.name,
    this.onLog,
  });

  final PcCertificate certificate;
  final PcLinkHost host;
  final PcPairingWindow pairing;

  /// The computer's name, given to a phone when it pairs.
  final String name;
  final void Function(String message)? onLog;

  HttpServer? _server;

  int? get port => _server?.port;
  bool get isRunning => _server != null;

  /// Listens on [address] (every IPv4 interface by default) at [port], or
  /// on any free port if that one is taken; the port in use.
  Future<int> start({
    InternetAddress? address,
    int port = PcLink.defaultPort,
  }) async {
    await stop();
    final context = SecurityContext()
      ..useCertificateChainBytes(utf8.encode(certificate.certPem))
      ..usePrivateKeyBytes(utf8.encode(certificate.keyPem));
    final bind = address ?? InternetAddress.anyIPv4;
    HttpServer server;
    try {
      server = await HttpServer.bindSecure(bind, port, context);
    } on SocketException {
      server = await HttpServer.bindSecure(bind, 0, context);
    }
    server
      ..autoCompress = false
      ..serverHeader = null
      ..idleTimeout = const Duration(seconds: 30);
    _server = server;
    server.listen(
      (request) => unawaited(_handle(request)),
      onError: (Object e) => onLog?.call('link: $e'),
    );
    onLog?.call('link: listening on ${server.port}');
    return server.port;
  }

  Future<void> stop() async {
    final server = _server;
    _server = null;
    await server?.close(force: true);
  }

  Future<void> _handle(HttpRequest request) async {
    final response = request.response;
    response.headers
      ..set(HttpHeaders.cacheControlHeader, 'no-store')
      ..set('x-content-type-options', 'nosniff');
    try {
      await _route(request, response);
    } on Object catch (e) {
      onLog?.call('link: ${request.method} ${request.uri.path} failed: $e');
      try {
        response.statusCode = HttpStatus.internalServerError;
      } on StateError {
        // The headers went out already; the close below ends it.
      }
    } finally {
      try {
        await response.close();
      } on Object {
        // The phone went away first.
      }
    }
  }

  Future<void> _route(HttpRequest request, HttpResponse response) async {
    final path = request.uri.path;
    final method = request.method;
    if (method == 'POST' && path == PcLink.pairPath) {
      return _pair(request, response);
    }

    final device = pairing.verify(
      request.headers.value(PcLink.deviceHeader),
      pcBearer(request),
    );
    if (device == null) {
      // A phone that was paired and then forgotten learns so; anyone else
      // learns nothing.
      final claimed = request.headers.value(PcLink.deviceHeader) != null;
      response.statusCode = claimed
          ? HttpStatus.unauthorized
          : HttpStatus.notFound;
      await pcDrain(request);
      return;
    }
    unawaited(pairing.touch(device));

    final segments = request.uri.pathSegments;
    if (method == 'GET' && path == PcLink.statusPath) {
      return pcWriteJson(response, host.status().toJson());
    }
    if (method == 'GET' && path == PcLink.downloadsPath) {
      return pcWriteJson(response, {
        'tasks': [for (final task in host.tasks()) task.toJson()],
      });
    }
    if (method == 'POST' && path == PcLink.downloadsPath) {
      final body = await pcReadJsonRequest(request);
      final url = body?['url'];
      final quality = body?['quality'];
      if (url is! String || !pcIsWebLink(url)) {
        response.statusCode = HttpStatus.badRequest;
        return;
      }
      final task = host.submit(url, quality is String ? quality : 'best');
      if (task == null) {
        response.statusCode = HttpStatus.unprocessableEntity;
        return;
      }
      onLog?.call('link: ${device.name} queued a link');
      return pcWriteJson(response, task.toJson());
    }
    if (method == 'POST' &&
        segments.length == 4 &&
        '/${segments[0]}/${segments[1]}' == PcLink.downloadsPath &&
        segments[3] == 'cancel') {
      response.statusCode = host.cancel(segments[2])
          ? HttpStatus.noContent
          : HttpStatus.notFound;
      return;
    }
    if (method == 'GET' && path == PcLink.libraryPath) {
      final q = request.uri.queryParameters;
      final page = await host.library(
        offset: int.tryParse(q['offset'] ?? '')?.clamp(0, 1 << 30) ?? 0,
        limit: int.tryParse(q['limit'] ?? '')?.clamp(1, 500) ?? 100,
        query: q['q'],
        sort:
            PcLibrarySort.values.asNameMap()[q['sort']] ?? PcLibrarySort.newest,
        kind: PcLibraryKind.values.asNameMap()[q['kind']] ?? PcLibraryKind.all,
      );
      return pcWriteJson(response, page.toJson());
    }
    if (method == 'GET' && path == PcLink.listsPath) {
      return pcWriteJson(response, {
        'lists': [for (final list in await host.lists()) list.toJson()],
      });
    }
    if (method == 'GET' &&
        segments.length == 3 &&
        '/${segments[0]}/${segments[1]}' == PcLink.listsPath) {
      final list = await host.list(segments[2]);
      if (list == null) {
        response.statusCode = HttpStatus.notFound;
        return;
      }
      return pcWriteJson(response, list.toJson());
    }
    if (method == 'DELETE' &&
        segments.length == 3 &&
        '/${segments[0]}/${segments[1]}' == PcLink.libraryPath) {
      return _delete(segments[2], device, response);
    }
    final inLibrary =
        segments.length == 4 &&
        '/${segments[0]}/${segments[1]}' == PcLink.libraryPath;
    if (method == 'GET' && inLibrary && segments[3] == 'cover') {
      return _cover(segments[2], response);
    }
    if ((method == 'GET' || method == 'HEAD') &&
        inLibrary &&
        segments[3] == PcLink.fileSegment) {
      return _file(segments[2], request, response);
    }
    if (method == 'GET' && inLibrary && segments[3] == 'transcripts') {
      return pcWriteJson(response, {
        'transcripts': await host.transcripts(segments[2]),
      });
    }
    response.statusCode = HttpStatus.notFound;
  }

  Future<void> _pair(HttpRequest request, HttpResponse response) async {
    if (!pairing.isOpen) {
      response.statusCode = HttpStatus.notFound;
      await pcDrain(request);
      return;
    }
    final body = await pcReadJsonRequest(request);
    final code = body?['code'];
    final nonce = body?['nonce'];
    final phone = body?['name'];
    if (code is! String || nonce is! String || nonce.length < 16) {
      response.statusCode = HttpStatus.badRequest;
      return;
    }
    final result = await pairing.attempt(
      code: code,
      name: phone is String ? phone : '',
      nonce: nonce,
    );
    if (result.refusal != null) {
      onLog?.call('link: pairing refused (${result.refusal!.name})');
      response.statusCode = HttpStatus.forbidden;
      return pcWriteJson(response, {'error': result.refusal!.name});
    }
    onLog?.call('link: paired ${result.device!.name}');
    return pcWriteJson(response, {
      'deviceId': result.device!.id,
      'secret': result.secret,
      'name': name,
    });
  }

  Future<void> _delete(
    String id,
    PcDevice device,
    HttpResponse response,
  ) async {
    final outcome = await host.delete(id);
    switch (outcome) {
      case PcDeleteOutcome.deleted:
        onLog?.call('link: ${device.name} deleted a clip to the Recycle Bin');
        response.statusCode = HttpStatus.noContent;
      case PcDeleteOutcome.missing:
        response.statusCode = HttpStatus.notFound;
      case PcDeleteOutcome.notAllowed:
      case PcDeleteOutcome.noRecycleBin:
      case PcDeleteOutcome.failed:
        response.statusCode = outcome == PcDeleteOutcome.notAllowed
            ? HttpStatus.forbidden
            : HttpStatus.conflict;
        return pcWriteJson(response, {'error': outcome.name});
    }
  }

  Future<void> _cover(String id, HttpResponse response) async {
    final file = await host.cover(id);
    if (file == null || !await file.exists()) {
      response.statusCode = HttpStatus.notFound;
      return;
    }
    final ext = file.path.split('.').last.toLowerCase();
    response.headers.contentType = switch (ext) {
      'png' => ContentType('image', 'png'),
      'webp' => ContentType('image', 'webp'),
      _ => ContentType('image', 'jpeg'),
    };
    await response.addStream(file.openRead());
  }

  Future<void> _file(
    String id,
    HttpRequest request,
    HttpResponse response,
  ) async {
    final file = await host.file(id);
    if (file == null || !await file.exists()) {
      response.statusCode = HttpStatus.notFound;
      return;
    }
    await servePcFile(file, request, response);
  }
}
