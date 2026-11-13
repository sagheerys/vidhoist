import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';

/// The external fetches read an answer whole, and their timeout bounds only
/// the connect: a server that kept sending grew the string until the phone
/// ran out of memory. Each one now has a ceiling.
void main() {
  late HttpServer server;

  /// What the next request is answered with; set in each test.
  late Future<void> Function(HttpResponse) answer;

  setUp(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      try {
        await request.drain<void>();
        await answer(request.response);
        await request.response.close();
      } on Object {
        // The client hung up at its ceiling.
      }
    });
  });
  tearDown(() => server.close(force: true));

  Uri here() => Uri.parse('http://127.0.0.1:${server.port}/x');

  /// [count] blocks of 64KB of spaces, flushed one by one with no length
  /// declared, as a server that streams does.
  Future<void> Function(HttpResponse) streaming(int count) => (r) async {
    final block = Uint8List(64 * 1024)..fillRange(0, 64 * 1024, 0x20);
    for (var i = 0; i < count; i++) {
      r.add(block);
      await r.flush();
    }
  };

  test('**the guard**: an undeclared answer past the ceiling is refused, '
      'not read into memory', () async {
    answer = streaming(httpGetCeiling ~/ (64 * 1024) + 4);
    await expectLater(ioHttpGetString(here()), throwsA(isA<HttpException>()));
  });

  test('**the guard**: a declared length past the ceiling is refused before '
      'reading', () async {
    answer = (r) async {
      r.headers.contentLength = innerTubeCeiling + 1;
      r.add(Uint8List(1024));
      await r.flush();
    };
    await expectLater(
      ioHttpPostJson(here(), const {'a': 1}),
      throwsA(isA<HttpException>()),
    );
    await expectLater(ioHttpGetString(here()), throwsA(isA<HttpException>()));
  });

  test('InnerTube gets room for a browse answer of a few megabytes', () async {
    answer = streaming(2 * 1024 * 1024 ~/ (64 * 1024));
    expect((await ioHttpPostJson(here(), const {})).length, 2 * 1024 * 1024);
  });

  test('an ordinary answer is read whole', () async {
    answer = (r) async => r.write('{"tag_name": "v1.0.0"}');
    expect(await ioHttpGetString(here()), '{"tag_name": "v1.0.0"}');
  });

  test('an explicit maxBytes still cuts a page short rather than '
      'refusing it', () async {
    answer = streaming(8);
    final head = await ioHttpGetString(here(), maxBytes: 1000);
    expect(head.length, 1000);
  });
}
