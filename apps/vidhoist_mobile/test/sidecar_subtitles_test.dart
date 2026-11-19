import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_transcripts/vh_transcripts.dart' show maxSubtitleFileBytes;
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/player/sidecar_subtitles.dart';

/// The subtitles fetched with the download (`--write-subs`) land beside it
/// as `<name>.<language>.vtt`; the player reads them from there.
void main() {
  late Directory dir;
  const vtt = 'WEBVTT\n\n00:00:01.000 --> 00:00:02.500\nHello there\n';
  const arVtt = 'WEBVTT\n\n00:00:01.000 --> 00:00:02.000\nمرحباً\n';

  setUp(() => dir = Directory.systemTemp.createTempSync('vh_subs_'));
  tearDown(() => dir.deleteSync(recursive: true));

  String put(String name, [String content = '']) {
    final f = File('${dir.path}/$name')..writeAsStringSync(content);
    return f.path;
  }

  test('each language beside the file, in the reader\'s order', () async {
    final video = put('Clip [abc].mp4');
    put('Clip [abc].en.vtt', vtt);
    put('Clip [abc].ar.vtt', arVtt);
    put('Other [xyz].en.vtt', vtt);

    final tracks = await readSidecarSubtitles(video, preferred: const ['ar']);
    expect(tracks.keys, ['ar', 'en']);
    expect(tracks['en']!.single.text, 'Hello there');
    expect(tracks['en']!.single.start, const Duration(seconds: 1));
    expect(tracks['ar']!.single.text, 'مرحباً');
  });

  test('a clip with none, or only empty ones, has none', () async {
    final video = put('Clip [abc].mp4');
    expect(await readSidecarSubtitles(video), isEmpty);
    put('Clip [abc].en.vtt', 'WEBVTT\n');
    expect(await readSidecarSubtitles(video), isEmpty);
  });

  test('**the guard**: a file too large to be subtitles is skipped unread, '
      'and the others still show', () async {
    // Anything can sit beside a clip under a subtitle's name; read whole,
    // it sat in the phone's memory several times over.
    final video = put('Clip [abc].mp4');
    put('Clip [abc].en.vtt', vtt);
    put('Clip [abc].ar.vtt', '$arVtt${' ' * maxSubtitleFileBytes}');
    final tracks = await readSidecarSubtitles(video);
    expect(tracks.keys, ['en']);
  });

  test('the files to delete with a clip are its subtitles, nothing else', () {
    final video = put('Clip [abc].mp4');
    final en = put('Clip [abc].en.vtt', vtt);
    final ar = put('Clip [abc].ar-orig.srt', vtt);
    put('Clip [abc] 2.mp4');
    put('Other [xyz].en.vtt', vtt);
    String name(String path) => File(path).uri.pathSegments.last;
    expect(sidecarSubtitleFiles(video).map((f) => name(f.path)).toSet(), {
      name(en),
      name(ar),
    });
  });

  test('deleting a clip takes its subtitles with it', () async {
    final video = put('Clip [abc].mp4');
    put('Clip [abc].en.vtt', vtt);
    final other = put('Other [xyz].en.vtt', vtt);
    expect(await deleteSidecarSubtitles(video), 1);
    expect(sidecarSubtitleFiles(video), isEmpty);
    expect(File(other).existsSync(), isTrue);
  });

  // Found on a real phone 2026-11-07: a clip spoken in Arabic comes
  // with `ar` and `ar-orig`, byte for byte the same, and the switch offered
  // "AR" twice.
  test(
    'a copy of another language under a second name is one language',
    () async {
      final video = put('Clip [abc].mp4');
      put('Clip [abc].ar.vtt', arVtt);
      put('Clip [abc].ar-orig.vtt', arVtt);
      put('Clip [abc].en.vtt', vtt);

      final tracks = await readSidecarSubtitles(video, preferred: const ['ar']);
      expect(tracks.keys, ['ar', 'en']);
    },
  );

  test('two different tracks of one language are both kept', () async {
    final video = put('Clip [abc].mp4');
    put('Clip [abc].ar.vtt', arVtt);
    put(
      'Clip [abc].ar-orig.vtt',
      'WEBVTT\n\n00:00:01.000 --> 00:00:02.000\nأهلاً\n',
    );
    final tracks = await readSidecarSubtitles(video);
    expect(tracks, hasLength(2));
  });

  test('the player asks once per clip, and the answer comes back', () async {
    final video = put('Clip [abc].mp4');
    put('Clip [abc].en.vtt', vtt);
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        initialSettingsProvider.overrideWithValue(const PhoneSettings()),
      ],
    );
    addTearDown(c.dispose);
    c.read(subtitleCacheProvider.notifier)
      ..want(video)
      ..want(video);
    for (
      var i = 0;
      i < 100 && !c.read(subtitleCacheProvider).containsKey(video);
      i++
    ) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(c.read(subtitleCacheProvider)[video]!.keys, ['en']);
  });
}
