import 'dart:convert';
import 'dart:io';
import 'dart:typed_data' show BytesBuilder, Uint8List;

/// A plain text fetch for external services (§4), **a client of its
/// own**, so no header set elsewhere in the app can ever leak to a
/// third-party platform.
typedef HttpGetString = Future<String> Function(Uri uri);

/// Posting JSON to external services: the same isolation, and specifically
/// for the InnerTube endpoint.
typedef HttpPostJson = Future<String> Function(Uri uri, Object body);

/// A desktop browser identity: YouTube and SoundCloud return different
/// pages, or refuse outright, depending on the agent, and `SOCS` clears the
/// European cookie-consent wall.
const _browserHeaders = {
  'user-agent':
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
  'accept-language': 'en-US,en;q=0.9',
};

/// The most [ioHttpGetString] reads when its caller names no ceiling of
/// its own. The connection timeout bounds only the connect, so a server
/// that kept sending (broken, or serving gigabytes under a release list's
/// name) grew the string until the phone ran out of memory. Everything it
/// fetches whole (a release list, a SoundCloud page, a language guess) is
/// well under a megabyte.
const int httpGetCeiling = 5 * 1024 * 1024;

/// The ceiling for InnerTube's answers: a playlist's browse answer runs to
/// one or two megabytes, so it gets room the plain fetch does not.
const int innerTubeCeiling = 16 * 1024 * 1024;

/// The body of [response], refused as soon as it passes [maxBytes]: a
/// declared length is checked before anything is read, and an undeclared
/// or false one is counted as it arrives. **Thrown, not truncated**: half a
/// JSON answer or half a release list is worse than none.
Future<Uint8List> readCappedResponse(
  HttpClientResponse response,
  int maxBytes, {
  Uri? uri,
}) async {
  if (response.contentLength > maxBytes) {
    throw HttpException('response over $maxBytes bytes', uri: uri);
  }
  final bytes = BytesBuilder(copy: false);
  await for (final chunk in response) {
    bytes.add(chunk);
    if (bytes.length > maxBytes) {
      throw HttpException('response over $maxBytes bytes', uri: uri);
    }
  }
  return bytes.takeBytes();
}

/// The default dart:io implementation: a short timeout and a fast failure.
/// Every resolver consuming it is fail-safe and returns null on any
/// problem. With [maxBytes] the read stops there: a whole web page is read
/// only for what its head names, and some run to hundreds of kilobytes.
/// Without it the whole answer is read, up to [httpGetCeiling].
Future<String> ioHttpGetString(Uri uri, {int? maxBytes}) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
  try {
    final request = await client.getUrl(uri);
    _browserHeaders.forEach(request.headers.set);
    request.headers.set('cookie', 'SOCS=CAI');
    request.followRedirects = true;
    final response = await request.close();
    if (response.statusCode != 200) {
      throw HttpException('HTTP ${response.statusCode}', uri: uri);
    }
    if (maxBytes == null) {
      return utf8.decode(
        await readCappedResponse(response, httpGetCeiling, uri: uri),
      );
    }
    final bytes = BytesBuilder(copy: false);
    await for (final chunk in response) {
      bytes.add(chunk);
      if (bytes.length >= maxBytes) break;
    }
    final read = bytes.takeBytes();
    return utf8.decode(
      read.length > maxBytes ? read.sublist(0, maxBytes) : read,
      allowMalformed: true,
    );
  } finally {
    client.close(force: true);
  }
}

Future<String> ioHttpPostJson(Uri uri, Object body) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
  try {
    final request = await client.postUrl(uri);
    _browserHeaders.forEach(request.headers.set);
    request.headers.contentType = ContentType.json;
    request.write(json.encode(body));
    final response = await request.close();
    if (response.statusCode != 200) {
      throw HttpException('HTTP ${response.statusCode}', uri: uri);
    }
    return utf8.decode(
      await readCappedResponse(response, innerTubeCeiling, uri: uri),
    );
  } finally {
    client.close(force: true);
  }
}
