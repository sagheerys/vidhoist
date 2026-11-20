/// The HTTP both ends of the link share: the phone's pinned client and its
/// reading of answers, the computer's reading of requests. Kept inside the
/// package; the client and the server are what others use.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../resolvers/http_fetch.dart';
import 'pc_certificate.dart';
import 'pc_link_wire.dart';

/// A client that trusts only what [accept] says of a certificate's
/// fingerprint. **No trusted roots**: every certificate goes through the
/// callback, so one some authority signed cannot slip past the pin.
HttpClient pcPinnedClient(bool Function(String fp) accept, Duration timeout) =>
    HttpClient(context: SecurityContext(withTrustedRoots: false))
      ..connectionTimeout = timeout
      ..idleTimeout = const Duration(seconds: 15)
      ..userAgent = null
      ..badCertificateCallback = (cert, host, port) =>
          accept(fingerprintOf(cert.der));

/// An answer from the computer, refused past [pcMaxAnswer]. The computer is
/// pinned, but a broken or replaced one that kept sending would otherwise
/// fill the phone's memory.
Future<Uint8List> pcReadBody(HttpClientResponse response) =>
    readCappedResponse(response, pcMaxAnswer);

/// Far above any answer the computer gives: its answers are short JSON
/// lists, and a ceiling this loose never cuts a real one.
const int pcMaxAnswer = 16 * 1024 * 1024;

/// The JSON in [body], or null for none or a malformed one.
Object? pcDecodeJson(Uint8List body) {
  if (body.isEmpty) return null;
  try {
    return jsonDecode(utf8.decode(body));
  } on FormatException {
    return null;
  }
}

String? pcBearer(HttpRequest request) {
  final value = request.headers.value(HttpHeaders.authorizationHeader);
  if (value == null || !value.startsWith('Bearer ')) return null;
  return value.substring(7).trim();
}

bool pcIsWebLink(String url) {
  final uri = Uri.tryParse(url.trim());
  return uri != null &&
      (uri.isScheme('http') || uri.isScheme('https')) &&
      uri.host.isNotEmpty;
}

/// A request's JSON object, or null when it is too big, malformed or not
/// an object: the body is never read past [PcLink.maxBody].
Future<Map<String, Object?>?> pcReadJsonRequest(HttpRequest request) async {
  if ((request.contentLength) > PcLink.maxBody) return null;
  final bytes = <int>[];
  await for (final chunk in request) {
    bytes.addAll(chunk);
    if (bytes.length > PcLink.maxBody) return null;
  }
  try {
    final value = jsonDecode(utf8.decode(bytes));
    return value is Map<String, Object?> ? value : null;
  } on FormatException {
    return null;
  }
}

/// Discards what is left of a refused request, whose status is already
/// set. A body larger than any request the link makes, or one of no stated
/// length, is not read at all: the answer goes out and the connection is
/// cut, so nobody on the network can keep the computer reading for as long
/// as they keep sending. Dart's server would otherwise read it to its end
/// before closing, however the response is marked.
Future<void> pcDrain(HttpRequest request) async {
  final length = request.contentLength;
  if (length > PcLink.maxBody || (length < 0 && request.method != 'GET')) {
    final response = request.response
      ..persistentConnection = false
      ..contentLength = 0;
    try {
      final socket = await response.detachSocket();
      await socket.flush();
      socket.destroy();
    } on Object {
      // The other end went away first.
    }
    return;
  }
  try {
    await request.drain<void>();
  } on Object {
    // Nothing to keep.
  }
}

Future<void> pcWriteJson(HttpResponse response, Object value) async {
  response.headers.contentType = ContentType.json;
  response.write(jsonEncode(value));
}
