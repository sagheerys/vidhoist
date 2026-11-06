import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/data/sidecar_import.dart';

/// yt-dlp writes a clip's subtitles beside it (`<name>.<language>.vtt`);
/// read once the download is done, they become the clip's transcripts,
/// with no second trip to the site.
void main() {
  late Directory folder;
  setUp(() async => folder = await Directory.systemTemp.createTemp('vh_subs_'));
  tearDown(() => folder.delete(recursive: true));

  const vtt =
      'WEBVTT\n\n00:00:01.000 --> 00:00:03.000\nHello there\n\n'
      '00:00:04.000 --> 00:00:06.000\nGeneral Kenobi\n';

  File put(String name, String text) =>
      File('${folder.path}\\$name')..writeAsStringSync(text);

  test('each language beside the clip, as a transcript of it', () async {
    final clip = put('Clip [abc].mp4', 'media');
    put('Clip [abc].en.vtt', vtt);
    put('Clip [abc].ar.vtt', vtt.replaceAll('Hello there', 'مرحباً'));
    put('Other [xyz].en.vtt', vtt);
    final found = await readSidecarTranscripts(
      mediaPath: clip.path,
      canonicalUrl: 'https://www.youtube.com/watch?v=abc',
    );
    expect(found.map((t) => t.language).toSet(), {'en', 'ar'});
    final arabic = found.firstWhere((t) => t.language == 'ar');
    expect(arabic.canonicalUrl, 'https://www.youtube.com/watch?v=abc');
    expect(arabic.segments.first.text, 'مرحباً');
    expect(arabic.segments, hasLength(2));
  });

  test("YouTube's original-language track is named by its language", () async {
    final clip = put('Clip [abc].mp4', 'media');
    put('Clip [abc].en-orig.vtt', vtt);
    final found = await readSidecarTranscripts(
      mediaPath: clip.path,
      canonicalUrl: 'u',
    );
    expect(found.single.language, 'en');
  });

  test('an empty or unreadable track is skipped', () async {
    final clip = put('Clip [abc].mp4', 'media');
    put('Clip [abc].en.vtt', 'WEBVTT\n');
    final found = await readSidecarTranscripts(
      mediaPath: clip.path,
      canonicalUrl: 'u',
    );
    expect(found, isEmpty);
  });
}
