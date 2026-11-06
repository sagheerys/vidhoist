import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/platform/engine_fetcher.dart';
import 'package:vidhoist_desktop/platform/engine_locator.dart';
import 'package:vidhoist_desktop/platform/engine_pins.dart';

/// ffmpeg and Deno are fetched on first need, and yt-dlp when it updates:
/// the pinned file only, its SHA-256 checked before anything is unpacked,
/// with its progress shown, and an older copy kept until the new one is
/// whole. Nothing here reaches the network.
void main() {
  late Directory root;
  late EngineLocator locator;
  final archive = utf8.encode('an archive of the right bytes');
  final hash = sha256.convert(archive).toString();

  setUp(() async {
    root = await Directory.systemTemp.createTemp('vh_engine_');
    locator = EngineLocator(
      ownFolder: '${root.path}\\engine',
      pathFolders: const [],
    );
  });
  tearDown(() => root.delete(recursive: true));

  PinnedAsset pin(EnginePart part, {String? sha}) => PinnedAsset(
    part: part,
    version: '1.0',
    url: Uri.parse('https://example.com/${part.name}.zip'),
    sha256: sha ?? hash,
  );

  final asked = <Uri>[];

  /// Sends [archive] in two halves, with its length.
  Future<FetchBody> download(Uri url) async {
    asked.add(url);
    final half = archive.length ~/ 2;
    return (
      length: archive.length,
      bytes: Stream.fromIterable([
        archive.sublist(0, half),
        archive.sublist(half),
      ]),
    );
  }

  /// Unpacks as each real archive is laid out.
  Future<void> unpack(File zip, Directory into) async {
    expect(await zip.readAsBytes(), archive);
    void put(String path) => File('${into.path}\\$path')
      ..createSync(recursive: true)
      ..writeAsStringSync(path);
    if (zip.path.contains('deno')) put('deno.exe');
    if (zip.path.contains('ffmpeg')) {
      put(r'ffmpeg-9.0.2-essentials_build\bin\ffmpeg.exe');
      put(r'ffmpeg-9.0.2-essentials_build\bin\ffprobe.exe');
      put(r'ffmpeg-9.0.2-essentials_build\bin\ffplay.exe');
    }
    if (zip.path.contains('ytDlp')) {
      put('yt-dlp.exe');
      put(r'_internal\python314.dll');
    }
  }

  EngineFetcher fetcher({String? sha}) => EngineFetcher(
    locator: locator,
    pins: {for (final part in EnginePart.values) part: pin(part, sha: sha)},
    download: download,
    unpack: unpack,
    staging: Directory('${root.path}\\staging'),
  );

  test('Deno: fetched, checked, unpacked, with progress', () async {
    final progress = await fetcher().fetch(EnginePart.deno).toList();
    expect(asked.last, Uri.parse('https://example.com/deno.zip'));
    expect(progress.first.fraction, closeTo(0.5, 0.05));
    expect(progress.last.fraction, 1);
    expect(File(locator.locate().deno!).readAsStringSync(), 'deno.exe');
  });

  test('ffmpeg: the two tools out of the archive, ffplay left out', () async {
    await fetcher().fetch(EnginePart.ffmpeg).drain<void>();
    final dir = locator.locate().ffmpegDir!;
    expect(File('$dir\\ffmpeg.exe').existsSync(), isTrue);
    expect(File('$dir\\ffprobe.exe').existsSync(), isTrue);
    expect(File('$dir\\ffplay.exe').existsSync(), isFalse);
  });

  test('yt-dlp: the whole folder build replaces the older one', () async {
    final old = File('${locator.folderFor(EnginePart.ytDlp)}\\old.txt')
      ..createSync(recursive: true);
    await fetcher().fetch(EnginePart.ytDlp).drain<void>();
    final exe = locator.locate().ytDlp!;
    expect(File(exe).existsSync(), isTrue);
    expect(
      File('${File(exe).parent.path}\\_internal\\python314.dll').existsSync(),
      isTrue,
    );
    expect(old.existsSync(), isFalse);
  });

  test('a wrong hash installs nothing and keeps the old copy', () async {
    final old = File('${locator.folderFor(EnginePart.deno)}\\deno.exe')
      ..createSync(recursive: true)
      ..writeAsStringSync('old');
    await expectLater(
      fetcher(sha: '0' * 64).fetch(EnginePart.deno).drain<void>(),
      throwsA(
        isA<EngineFetchException>().having(
          (e) => e.reason,
          'reason',
          FetchFailure.corrupt,
        ),
      ),
    );
    expect(old.readAsStringSync(), 'old');
    expect(Directory('${root.path}\\staging').listSync(), isEmpty);
  });

  test('a download that breaks is a network failure', () async {
    final broken = EngineFetcher(
      locator: locator,
      pins: {EnginePart.deno: pin(EnginePart.deno)},
      download: (_) async => throw const SocketException('gone'),
      unpack: unpack,
      staging: Directory('${root.path}\\staging'),
    );
    await expectLater(
      broken.fetch(EnginePart.deno).drain<void>(),
      throwsA(
        isA<EngineFetchException>().having(
          (e) => e.reason,
          'reason',
          FetchFailure.network,
        ),
      ),
    );
  });

  test('the pins name official releases and a full SHA-256', () {
    for (final part in EnginePart.values) {
      final asset = enginePins[part]!;
      expect(asset.url.scheme, 'https');
      expect(asset.url.host, 'github.com');
      expect(asset.sha256, matches(RegExp(r'^[0-9a-f]{64}$')));
    }
    expect(enginePins[EnginePart.ytDlp]!.url.path, endsWith('yt-dlp_win.zip'));
  });
}
