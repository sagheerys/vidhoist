import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';

import 'downloads_data.dart';
import 'library_data.dart';

/// What a paired phone sees of this computer: its downloads and the clips
/// that are files here, newest first. Read fresh on each call, so the phone
/// never sees a stale list.
class DesktopPcHost implements PcLinkHost {
  DesktopPcHost(this._ref, {required this.name, required this.version});

  final Ref _ref;
  final String name;
  final String version;

  LocalDownloadEngine? get _engine => _ref.read(downloadEngineProvider);

  @override
  PcStatus status() => PcStatus(
    name: name,
    version: version,
    active: (_engine?.tasks ?? const []).where(isUnderWay).length,
  );

  @override
  List<PcTask> tasks() {
    final all = [...?_engine?.tasks]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    // What is under way, then the most recent finished ones: enough for the
    // phone's "on the computer now" without the whole session's history.
    final live = all.where((t) => !t.isFinished);
    final done = all.where((t) => t.isFinished).take(20);
    return [
      for (final task in [...live, ...done]) pcTaskOf(task),
    ];
  }

  @override
  PcTask? submit(String url, String quality) {
    final engine = _engine;
    // A playlist opens a choice on this computer; from the phone only
    // single links come, and the phone offers the computer for those alone.
    if (engine == null || PlaylistDetector.isPlaylist(url)) return null;
    return pcTaskOf(engine.submit(url, Quality.fromWire(quality)));
  }

  @override
  bool cancel(String id) {
    final engine = _engine;
    final task = engine?.taskById(id);
    if (engine == null || task == null || task.isFinished) return false;
    engine.cancel(id);
    return true;
  }

  @override
  Future<PcLibraryPage> library({
    int offset = 0,
    int limit = 100,
    String? query,
  }) async {
    final items = await _files(query);
    final page = items.skip(offset).take(limit);
    return PcLibraryPage(
      items: [for (final item in page) pcItemOf(item)],
      total: items.length,
    );
  }

  @override
  Future<File?> cover(String id) async {
    for (final item in await _files(null)) {
      if (pcItemId(item) != id) continue;
      final thumb = item.thumbnail;
      if (thumb == null || _isWeb(thumb)) return null;
      return File(thumb);
    }
    return null;
  }

  Future<List<LibraryItem>> _files(String? query) async {
    final all = await _ref.read(libraryItemsProvider.future);
    final q = query?.trim().toLowerCase() ?? '';
    final files = [
      for (final item in all)
        if (item.localPath != null &&
            (q.isEmpty ||
                item.title.toLowerCase().contains(q) ||
                (item.uploader?.toLowerCase().contains(q) ?? false)))
          item,
    ];
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    files.sort(
      (a, b) => (b.timestamp ?? epoch).compareTo(a.timestamp ?? epoch),
    );
    return files;
  }
}

/// A clip's id on the link: stable for its link, and saying nothing about
/// where its file is.
String pcItemId(LibraryItem item) =>
    sha256.convert(utf8.encode(item.canonicalUrl)).toString().substring(0, 20);

PcItem pcItemOf(LibraryItem item) {
  final thumb = item.thumbnail;
  return PcItem(
    id: pcItemId(item),
    title: item.title,
    uploader: item.uploader,
    thumbnail: thumb != null && _isWeb(thumb) ? thumb : null,
    hasCover: thumb != null && !_isWeb(thumb),
    duration: item.duration,
    sizeBytes: item.sizeBytes,
    added: item.timestamp,
    isAudio: item.isAudio,
  );
}

PcTask pcTaskOf(DownloadTask task) {
  final thumb = task.thumbnail;
  return PcTask(
    id: task.id,
    url: task.canonicalUrl ?? task.resolvedUrl ?? task.inputUrl,
    phase: task.phase.name,
    title: task.title,
    thumbnail: thumb != null && _isWeb(thumb) ? thumb : null,
    // The engine counts 0 to 1; the link speaks percent.
    progress: task.progress * 100,
    speed: task.speed,
    eta: task.eta,
    quality: task.quality.wire,
    error: task.error?.runtimeType.toString(),
  );
}

bool _isWeb(String value) =>
    value.startsWith('https://') || value.startsWith('http://');
