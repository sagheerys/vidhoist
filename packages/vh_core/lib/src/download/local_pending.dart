import 'dart:convert';

import 'package:vh_ytdlp/vh_ytdlp.dart' show ClipRange;

import '../models/download_task.dart';
import '../models/quality.dart';
import '../storage/key_value_store.dart';

/// The downloads not finished yet, written down so they survive the app:
/// killed from the recents list, stopped by the battery manager, or the
/// computer restarted. At the next launch they are queued again and yt-dlp
/// continues each from its partial file (`--continue`).
///
/// A paused download comes back paused. A failed or cancelled one is not
/// written: the person saw it end, and it is theirs to retry.
class LocalPendingStore {
  LocalPendingStore(this.store, {PrefsMutex? mutex})
    : _mutex = mutex ?? PrefsMutex();

  /// Never renamed: a renamed key loses every record under it.
  static const key = 'local_pending_v1';

  final KeyValueStore store;
  final PrefsMutex _mutex;

  /// Writes [task] down, or updates its record (a pause, a resume).
  Future<void> put(DownloadTask task) => _mutex.run(() async {
    final records = await _read()
      ..removeWhere((r) => r['id'] == task.id);
    records.add({
      'id': task.id,
      'url': task.inputUrl,
      'quality': task.quality.wire,
      'folder': ?task.folder,
      'clip': ?task.clip?.wire,
      if (task.isBatchMember) 'batch': true,
      if (task.phase == TaskPhase.paused) 'paused': true,
      'title': ?task.title,
      'thumbnail': ?task.thumbnail,
      'media': ?task.mediaId,
      'created': task.createdAt.millisecondsSinceEpoch,
    });
    await _write(records);
  });

  Future<void> remove(String taskId) => _mutex.run(() async {
    final records = await _read();
    final before = records.length;
    records.removeWhere((r) => r['id'] == taskId);
    if (records.length != before) await _write(records);
  });

  /// The tasks written down, in the order they were added, each queued or
  /// paused as it was left.
  Future<List<DownloadTask>> load() async => [
    for (final r in await _read())
      if (r case {'id': final String id, 'url': final String url})
        DownloadTask(
          id: id,
          inputUrl: url,
          quality: Quality.fromWire(r['quality'] as String?),
          folder: r['folder'] as String?,
          clip: ClipRange.fromWire(r['clip'] as String?),
          isBatchMember: r['batch'] == true,
          phase: r['paused'] == true ? TaskPhase.paused : TaskPhase.queued,
          title: r['title'] as String?,
          thumbnail: r['thumbnail'] as String?,
          mediaId: r['media'] as String?,
          createdAt: r['created'] is int
              ? DateTime.fromMillisecondsSinceEpoch(r['created'] as int)
              : null,
        ),
  ];

  Future<void> _write(List<Map<String, Object?>> records) =>
      store.setStringList(key, [for (final r in records) jsonEncode(r)]);

  Future<List<Map<String, Object?>>> _read() async => [
    for (final line in await store.getStringList(key) ?? const <String>[])
      ?_decode(line),
  ];

  static Map<String, Object?>? _decode(String line) {
    try {
      final value = jsonDecode(line);
      return value is Map<String, Object?> ? value : null;
    } on FormatException {
      return null;
    }
  }
}
