import 'dart:convert';

import 'package:mt_ytdlp/mt_ytdlp.dart';

import '../models/download_task.dart';
import '../models/history_item.dart';
import '../models/history_response.dart';
import '../models/quality.dart';
import 'key_value_store.dart';

/// One finished download, as kept on this device.
class LocalHistoryEntry {
  const LocalHistoryEntry(this.item, {required this.path, this.infoJsonPath});

  /// The same fields the server's `/history` gave, so the library, the
  /// details and the statistics read it unchanged.
  final HistoryItem item;

  /// Where the file is.
  final String path;

  /// The `.info.json` written beside it, when yt-dlp wrote one.
  final String? infoJsonPath;
}

/// The history of downloads made on this device, in place of the server's
/// `/history`.
///
/// Each record carries the fields Vidhoist sent (`url`, `title`,
/// `filename`, `uploader`, `thumbnail`, `size`, `download_type`,
/// `folder`, `timestamp`), so [HistoryItem.fromJson] reads it, and the
/// screens built on [HistoryResponse] stay as they are. The link kept is
/// the one yt-dlp resolved (`webpage_url`), the same key every index uses.
class LocalHistoryStore {
  LocalHistoryStore(this.store, {PrefsMutex? mutex})
    : _mutex = mutex ?? PrefsMutex();

  /// Never renamed: a renamed key loses every record under it.
  static const key = 'local_history_v1';

  final KeyValueStore store;
  final PrefsMutex _mutex;

  /// Records [task], finished at [path]. A record for the same file
  /// replaces the older one, so downloading a clip again does not list it
  /// twice.
  Future<LocalHistoryEntry> record({
    required DownloadTask task,
    required String path,
    InfoJson? info,
    int? sizeBytes,
    String? infoJsonPath,
    DateTime? at,
  }) => _mutex.run(() async {
    final when = at ?? DateTime.now();
    final json = <String, Object?>{
      'id': task.id,
      'url': info?.webpageUrl ?? task.effectiveUrl,
      'title': info?.title ?? task.title,
      'filename': _basename(path),
      'uploader': info?.uploader,
      'thumbnail': info?.thumbnail ?? task.thumbnail,
      'status': 'finished',
      'timestamp': when.millisecondsSinceEpoch,
      'quality': task.quality.wire,
      'format': _extension(path),
      'size': sizeBytes ?? info?.size,
      'download_type': task.quality == Quality.audio ? 'audio' : 'video',
      'folder': task.folder,
      'path': path,
      'info_json': infoJsonPath,
    }..removeWhere((_, v) => v == null);
    final records = await _read();
    records
      ..removeWhere((r) => r['path'] == path)
      ..add(json);
    await _write(records);
    return _entry(json);
  });

  /// Every record, newest first.
  Future<List<LocalHistoryEntry>> entries() async {
    final list = [for (final r in await _read()) _entry(r)];
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    list.sort(
      (a, b) =>
          (b.item.timestamp ?? epoch).compareTo(a.item.timestamp ?? epoch),
    );
    return list;
  }

  /// The records as the server's history, all in `done`: what is still
  /// running lives in the engine, not here.
  Future<HistoryResponse> history() async =>
      HistoryResponse(done: [for (final e in await entries()) e.item]);

  /// Forgets the record [id]; the file itself is not touched.
  Future<bool> remove(String id) => _mutex.run(() async {
    final records = await _read();
    final before = records.length;
    records.removeWhere((r) => r['id'] == id);
    if (records.length == before) return false;
    await _write(records);
    return true;
  });

  Future<void> _write(List<Map<String, dynamic>> records) =>
      store.setStringList(key, [for (final r in records) jsonEncode(r)]);

  Future<List<Map<String, dynamic>>> _read() async {
    final raw = await store.getStringList(key) ?? const [];
    return [for (final line in raw) ?_decode(line)];
  }

  /// A damaged record is skipped rather than costing the whole history.
  static Map<String, dynamic>? _decode(String line) {
    try {
      final value = jsonDecode(line);
      return value is Map<String, dynamic> && value['path'] is String
          ? value
          : null;
    } on FormatException {
      return null;
    }
  }

  static LocalHistoryEntry _entry(Map<String, dynamic> r) => LocalHistoryEntry(
    HistoryItem.fromJson(r),
    path: r['path'] as String,
    infoJsonPath: r['info_json'] is String ? r['info_json'] as String : null,
  );

  static String _basename(String path) => path.split(RegExp(r'[\\/]')).last;

  static String? _extension(String path) {
    final name = _basename(path);
    final dot = name.lastIndexOf('.');
    return dot <= 0 ? null : name.substring(dot + 1).toLowerCase();
  }
}
