import 'package:mt_core/mt_core.dart';
import 'package:test/test.dart';

DownloadTask taskFor(
  String url, {
  Quality quality = Quality.best,
  String? folder,
}) => DownloadTask(inputUrl: url, quality: quality, folder: folder);

void main() {
  late MemoryKeyValueStore store;
  late LocalHistoryStore history;

  setUp(() {
    store = MemoryKeyValueStore();
    history = LocalHistoryStore(store);
  });

  test('a record reads back as the server history did', () async {
    final info = InfoJson.parse(
      '{"id": "aqz", "title": "Big Buck Bunny", "uploader": "Blender",'
      ' "webpage_url": "https://www.youtube.com/watch?v=aqz",'
      ' "thumbnail": "https://i.ytimg.com/vi/aqz/max.jpg",'
      ' "filesize_approx": 99}',
    );
    final task = taskFor('https://youtu.be/aqz', folder: 'films');
    final entry = await history.record(
      task: task,
      path: r'C:\out\films\Big Buck Bunny [aqz].MP4',
      info: info,
      sizeBytes: 1234,
      infoJsonPath: r'C:\out\films\Big Buck Bunny [aqz].info.json',
      at: DateTime(2026, 11, 6, 12),
    );

    final item = entry.item;
    expect(item.id, task.id);
    expect(item.canonicalUrl, 'https://www.youtube.com/watch?v=aqz');
    expect(item.title, 'Big Buck Bunny');
    expect(item.uploader, 'Blender');
    expect(item.filename, 'Big Buck Bunny [aqz].MP4');
    expect(item.format, 'mp4');
    expect(item.sizeBytes, 1234);
    expect(item.downloadType, 'video');
    expect(item.folder, 'films');
    expect(item.thumbnail, 'https://i.ytimg.com/vi/aqz/max.jpg');
    expect(item.isCompleted, isTrue);
    expect(item.timestamp, DateTime(2026, 11, 6, 12));
    expect(entry.infoJsonPath, endsWith('.info.json'));

    final response = await history.history();
    expect(response.done.single.id, task.id);
    expect(response.queue, isEmpty);
  });

  test('without a reading the task gives what it knows', () async {
    final task = taskFor(
      'https://soundcloud.com/a/b',
      quality: Quality.audio,
    ).copyWith(title: 'Song');
    final entry = await history.record(task: task, path: '/m/Song.m4a');
    expect(entry.item.canonicalUrl, 'https://soundcloud.com/a/b');
    expect(entry.item.title, 'Song');
    expect(entry.item.downloadType, 'audio');
    expect(entry.item.sizeBytes, isNull);
    expect(entry.infoJsonPath, isNull);
  });

  test('newest first, and the same file is listed once', () async {
    await history.record(task: taskFor('a'), path: '/a', at: DateTime(2026));
    await history.record(task: taskFor('b'), path: '/b', at: DateTime(2027));
    await history.record(task: taskFor('a2'), path: '/a', at: DateTime(2028));
    final paths = [for (final e in await history.entries()) e.path];
    expect(paths, ['/a', '/b']);
    expect((await history.entries()).first.item.canonicalUrl, 'a2');
  });

  test('a record can be forgotten', () async {
    final entry = await history.record(task: taskFor('a'), path: '/a');
    expect(await history.remove('missing'), isFalse);
    expect(await history.remove(entry.item.id), isTrue);
    expect(await history.entries(), isEmpty);
  });

  test('a damaged record costs itself, not the history', () async {
    await history.record(task: taskFor('a'), path: '/a');
    final raw = await store.getStringList(LocalHistoryStore.key);
    await store.setStringList(LocalHistoryStore.key, [
      ...raw!,
      'not json',
      '{"no": "path"}',
      '[1]',
    ]);
    expect(await history.entries(), hasLength(1));
  });

  test('a name with no extension has no format', () async {
    final entry = await history.record(task: taskFor('a'), path: '/out/clip');
    expect(entry.item.format, isNull);
  });
}
