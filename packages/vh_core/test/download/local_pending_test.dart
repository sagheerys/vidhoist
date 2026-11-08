import 'dart:io';

import 'package:vh_core/vh_core.dart';
import 'package:test/test.dart';

void main() {
  group('pending downloads', () {
    late MemoryKeyValueStore store;
    late LocalPendingStore pending;

    setUp(() {
      store = MemoryKeyValueStore();
      pending = LocalPendingStore(store);
    });

    test('a task reads back as it was left', () async {
      final task = DownloadTask(
        id: 'a',
        inputUrl: 'https://x',
        quality: Quality.q480,
        folder: 'f',
        isBatchMember: true,
        title: 'T',
        thumbnail: 'https://t',
        createdAt: DateTime(2026, 11, 6),
      );
      await pending.put(task);
      final back = (await pending.load()).single;
      expect(back.id, 'a');
      expect(back.inputUrl, 'https://x');
      expect(back.quality, Quality.q480);
      expect(back.folder, 'f');
      expect(back.isBatchMember, isTrue);
      expect(back.title, 'T');
      expect(back.thumbnail, 'https://t');
      expect(back.phase, TaskPhase.queued);
      expect(back.createdAt, DateTime(2026, 11, 6));
    });

    test('an update replaces the record, a pause is kept', () async {
      final task = DownloadTask(id: 'a', inputUrl: 'u', quality: Quality.best);
      await pending.put(task);
      await pending.put(task.copyWith(phase: TaskPhase.paused));
      final back = await pending.load();
      expect(back, hasLength(1));
      expect(back.single.phase, TaskPhase.paused);
      expect(back.single.isBatchMember, isFalse);
      expect(back.single.folder, isNull);
    });

    test('removing, and removing what is not there', () async {
      await pending.put(
        DownloadTask(id: 'a', inputUrl: 'u', quality: Quality.best),
      );
      await pending.remove('b');
      expect(await pending.load(), hasLength(1));
      await pending.remove('a');
      expect(await pending.load(), isEmpty);
    });

    test('damaged records are skipped', () async {
      await store.setStringList(LocalPendingStore.key, [
        'nope',
        '[1]',
        '{"id": 5}',
        '{"id": "ok", "url": "u"}',
      ]);
      final back = await pending.load();
      expect(back.single.id, 'ok');
      expect(back.single.quality, Quality.best);
    });
  });

  group('yt-dlp leftovers', () {
    test('its work files are leftovers, finished files are not', () {
      for (final name in [
        'a [id].mp4.part',
        'a [id].mp4.ytdl',
        'a [id].mp4.part-Frag12',
        'a [id].mp4.part-Frag12.part',
        'a [id].f399.mp4',
        'a [id].f251-drc.webm',
        'a [id].temp.mp4',
      ]) {
        expect(isLeftover(name), isTrue, reason: name);
      }
      for (final name in [
        'a [id].mp4',
        'a [id].m4a',
        'track.f1.mp3',
        'a [id].info.json',
        'a [id].jpg',
      ]) {
        expect(isLeftover(name), isFalse, reason: name);
      }
    });

    test('old ones are swept, recent ones and media stay', () async {
      final dir = await Directory.systemTemp.createTemp('vh-sweep-');
      addTearDown(() => dir.delete(recursive: true));
      final old = DateTime.now().subtract(const Duration(days: 1));
      File old0(String name) => File('${dir.path}/$name')
        ..writeAsStringSync('x')
        ..setLastModifiedSync(old);
      final stream = old0('a [id].f399.mp4');
      final frag = old0('a [id].mp4.part-Frag3');
      final media = old0('a [id].mp4');
      final fresh = File('${dir.path}/b [id].mp4.ytdl')..writeAsStringSync('y');

      expect(await sweepPartialFiles(dir.path), 2);
      expect(stream.existsSync(), isFalse);
      expect(frag.existsSync(), isFalse);
      expect(media.existsSync(), isTrue);
      expect(fresh.existsSync(), isTrue);
    });
  });
}
