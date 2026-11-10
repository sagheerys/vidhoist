import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'pc_link_api.dart';
import 'pc_link_wire.dart';

/// **How the phone's player plays a clip that is on the computer.**
///
/// Android's players (ExoPlayer, under both video_player and just_audio)
/// make their own connections and know nothing of the computer's
/// certificate: pinned in Dart, it cannot be handed to them, and trusting
/// any certificate there would undo the pin. So the player is given an
/// address on this phone, `http://127.0.0.1:<port>/<token>/<id>`, and this
/// proxy fetches each request through the pinned link, ranges included, so
/// seeking works as on a file.
///
/// **Only this app's player can use it.** It listens on the loopback
/// address alone, so nothing off the phone reaches it, and every path
/// starts with a token of 32 random bytes made for this run: another app on
/// the phone that finds the port still has nothing to ask it for. The
/// bytes travel unencrypted only inside the phone.
class PcStreamProxy {
  PcStreamProxy(this._api, {String Function()? newToken})
    : _newToken = newToken ?? newSecret;

  /// The link as it is now: the owner may change the route while a clip
  /// plays, and the next request takes the new one.
  final PcLinkApi? Function() _api;
  final String Function() _newToken;

  HttpServer? _server;
  String? _token;
  Future<void>? _starting;

  /// What an item's `PlaylistItem.serverFilename` starts with when it
  /// plays from the computer: anything else is not this proxy's.
  static const prefix = 'vh-pc:';

  bool get isRunning => _server != null;

  /// Starts listening, once; later calls wait for the first.
  Future<void> start() => _starting ??= _start();

  Future<void> _start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server
      ..autoCompress = false
      ..serverHeader = null
      // A paused clip's connection is let go, and the player opens another
      // from where it stopped.
      ..idleTimeout = const Duration(seconds: 30);
    _token = _newToken();
    _server = server;
    server.listen((request) => unawaited(_handle(request)));
  }

  Future<void> stop() async {
    final server = _server;
    _server = null;
    _starting = null;
    await server?.close(force: true);
  }

  /// The address the player opens for the computer's clip [id]; null until
  /// [start] has finished.
  Uri? urlFor(String id) {
    final server = _server;
    if (server == null) return null;
    return Uri(
      scheme: 'http',
      host: InternetAddress.loopbackIPv4.address,
      port: server.port,
      pathSegments: [_token!, id],
    );
  }

  /// The address of the cover the computer keeps for clip [id], for the
  /// players' lists and the media notification, which load images by
  /// address; null until [start] has finished. It changes with each run,
  /// so it is never worth keeping.
  Uri? coverUrlFor(String id) {
    final clip = urlFor(id);
    return clip?.replace(pathSegments: [_token!, _cover, id]);
  }

  static const _cover = 'cover';

  /// The id in a [prefix]ed name, or null for any other.
  static String? idOf(String serverFilename) =>
      serverFilename.startsWith(prefix) && serverFilename.length > prefix.length
      ? serverFilename.substring(prefix.length)
      : null;

  Future<void> _handle(HttpRequest request) async {
    final response = request.response;
    final segments = request.uri.pathSegments;
    final method = request.method;
    try {
      final cover = segments.length == 3 && segments[1] == _cover;
      if ((method != 'GET' && method != 'HEAD') ||
          (segments.length != 2 && !cover) ||
          segments[0] != _token) {
        response.statusCode = HttpStatus.notFound;
        return;
      }
      final api = _api();
      if (api == null) {
        response.statusCode = HttpStatus.serviceUnavailable;
        return;
      }
      if (cover) return await _sendCover(api, segments[2], response);
      final PcFileResponse answer;
      try {
        answer = await api.file(
          segments[1],
          range: request.headers.value(HttpHeaders.rangeHeader),
        );
      } on PcLinkException {
        response.statusCode = HttpStatus.badGateway;
        return;
      }
      response.statusCode = answer.statusCode;
      answer.headers.forEach(response.headers.set);
      if (method == 'HEAD') {
        await answer.body.listen(null).cancel();
        return;
      }
      // Paced by the player: addStream holds the computer's bytes back
      // while the player's buffer is full, and the player leaving (a seek,
      // a stop) cancels the transfer rather than leaving the computer
      // sending a whole film nobody reads.
      await response.addStream(answer.body);
    } on Object {
      // The player went away first; nothing to answer.
    } finally {
      try {
        await response.close();
      } on Object {
        // Already closed by the player.
      }
    }
  }

  /// A cover is small and whole: read through the link, then handed on.
  Future<void> _sendCover(
    PcLinkApi api,
    String id,
    HttpResponse response,
  ) async {
    final Uint8List? bytes;
    try {
      bytes = await api.cover(id);
    } on PcLinkException {
      response.statusCode = HttpStatus.badGateway;
      return;
    }
    if (bytes == null) {
      response.statusCode = HttpStatus.notFound;
      return;
    }
    response.headers.contentType = _imageType(bytes);
    response.add(bytes);
  }

  /// PNG by its signature, JPEG otherwise: what the computer keeps.
  static ContentType _imageType(Uint8List bytes) =>
      bytes.length > 3 && bytes[0] == 0x89 && bytes[1] == 0x50
      ? ContentType('image', 'png')
      : ContentType('image', 'jpeg');
}
