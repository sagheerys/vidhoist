import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_transcripts/vh_transcripts.dart';

import 'clip_delete.dart';
import 'downloads_data.dart';
import 'library_data.dart';
import 'lists_data.dart';
import 'pc_link_data.dart';
import 'transcripts_data.dart';

/// What a paired phone sees of this computer: its downloads, the clips
/// that are files here, newest first, and the saved lists made of them.
/// Read fresh on each call, so the phone never sees a stale list.
class DesktopPcHost implements PcLinkHost {
  DesktopPcHost(
    this._ref, {
    required this.name,
    required this.version,
    List<PcAddress> Function()? addresses,
  }) : _addresses = addresses ?? (() => const []);

  final Ref _ref;
  final String name;
  final String version;

  /// This computer's addresses as they are now, for the phone's choice of
  /// route.
  final List<PcAddress> Function() _addresses;

  LocalDownloadEngine? get _engine => _ref.read(downloadEngineProvider);

  @override
  PcStatus status() => PcStatus(
    name: name,
    version: version,
    active: (_engine?.tasks ?? const []).where(isUnderWay).length,
    addresses: _addresses(),
    canDelete: _ref.read(pcLinkDeleteProvider),
    sorts: true,
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
    PcLibrarySort sort = PcLibrarySort.newest,
    PcLibraryKind kind = PcLibraryKind.all,
  }) async {
    final items = pcLibraryOrder(
      await _ref.read(libraryItemsProvider.future),
      query: query,
      sort: sort,
      kind: kind,
    );
    final page = items.skip(offset).take(limit);
    return PcLibraryPage(
      items: [for (final item in page) pcItemOf(item)],
      total: items.length,
    );
  }

  @override
  Future<File?> cover(String id) async {
    final thumb = (await _item(id))?.thumbnail;
    if (thumb == null || _isWeb(thumb)) return null;
    return File(thumb);
  }

  /// Only a clip of the library, by its id: the phone names no path.
  @override
  Future<File?> file(String id) async {
    final path = (await _item(id))?.localPath;
    return path == null ? null : File(path);
  }

  @override
  Future<List<Object?>> transcripts(String id) async {
    final item = await _item(id);
    final store = _ref.read(transcriptStoreProvider);
    if (item == null || store == null) return const [];
    return [for (final t in await store.readFor(item.canonicalUrl)) t.toJson()];
  }

  @override
  Future<List<PcList>> lists() async {
    final byUrl = await _filesByUrl();
    return [
      for (final list in await _ref.read(playlistsProvider.future))
        ?_listOf(list, byUrl, withItems: false),
    ];
  }

  @override
  Future<PcList?> list(String id) async {
    final lists = await _ref.read(playlistsProvider.future);
    final list = lists.where((l) => l.id == id).firstOrNull;
    if (list == null) return null;
    return _listOf(list, await _filesByUrl(), withItems: true);
  }

  /// [list] as the phone sees it: only the clips that are files here, in
  /// its order; null when none is, as there is nothing there to play.
  PcList? _listOf(
    SavedPlaylist list,
    Map<String, LibraryItem> byUrl, {
    required bool withItems,
  }) {
    final items = [for (final entry in list.items) ?byUrl[entry.canonicalUrl]];
    if (items.isEmpty) return null;
    final first = pcItemOf(items.first);
    return PcList(
      id: list.id,
      name: list.name,
      count: items.length,
      thumbnail: first.thumbnail,
      coverId: first.hasCover ? first.id : null,
      items: withItems ? [for (final item in items) pcItemOf(item)] : const [],
    );
  }

  Future<Map<String, LibraryItem>> _filesByUrl() async => {
    for (final item in pcLibraryOrder(
      await _ref.read(libraryItemsProvider.future),
    ))
      item.canonicalUrl: item,
  };

  /// **Asked again here, not trusted from the phone**: the user's switch,
  /// then a clip of the library by its id; its file goes to the Recycle Bin.
  @override
  Future<PcDeleteOutcome> delete(String id) async {
    if (!_ref.read(pcLinkDeleteProvider)) return PcDeleteOutcome.notAllowed;
    final item = await _item(id);
    if (item == null) return PcDeleteOutcome.missing;
    try {
      await deleteClipFile(_ref, item, fromPhone: true);
      return PcDeleteOutcome.deleted;
    } on NoRecycleBinException {
      return PcDeleteOutcome.noRecycleBin;
    } on Object {
      return PcDeleteOutcome.failed;
    }
  }

  Future<LibraryItem?> _item(String id) async {
    for (final item in pcLibraryOrder(
      await _ref.read(libraryItemsProvider.future),
    )) {
      if (pcItemId(item) == id) return item;
    }
    return null;
  }
}

/// The clips a phone may see (those with a file here), as it asked for
/// them. Every word of [query] must be in the title or the channel, folded
/// as the library's own search folds them, so a word typed without its
/// marks or hamza finds the title written with them.
List<LibraryItem> pcLibraryOrder(
  List<LibraryItem> all, {
  String? query,
  PcLibrarySort sort = PcLibrarySort.newest,
  PcLibraryKind kind = PcLibraryKind.all,
}) {
  final words = SearchText.wordsOf(query ?? '');
  final files = [
    for (final item in all)
      if (item.localPath != null &&
          switch (kind) {
            PcLibraryKind.all => true,
            PcLibraryKind.video => !item.isAudio,
            PcLibraryKind.audio => item.isAudio,
          } &&
          _says(item, words))
        item,
  ];
  final epoch = DateTime.fromMillisecondsSinceEpoch(0);
  int newest(LibraryItem a, LibraryItem b) =>
      (b.timestamp ?? epoch).compareTo(a.timestamp ?? epoch);
  files.sort(switch (sort) {
    PcLibrarySort.newest => newest,
    PcLibrarySort.oldest => (a, b) => newest(b, a),
    PcLibrarySort.title => (a, b) {
      final byTitle = SearchText.fold(a.title)
          .compareTo(SearchText.fold(b.title));
      return byTitle != 0 ? byTitle : newest(a, b);
    },
    // A clip whose size is not known goes last rather than first.
    PcLibrarySort.size => (a, b) {
      final bySize = (b.sizeBytes ?? -1).compareTo(a.sizeBytes ?? -1);
      return bySize != 0 ? bySize : newest(a, b);
    },
  });
  return files;
}

bool _says(LibraryItem item, List<String> words) {
  if (words.isEmpty) return true;
  final text = SearchText.fold('${item.title} ${item.uploader ?? ''}');
  return words.every(text.contains);
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
    // A clip added from a folder may be keyed by its path, which is not
    // the phone's to know.
    url: _isWeb(item.canonicalUrl) ? item.canonicalUrl : null,
    extension: switch (item.localPath) {
      final path? => extensionOf(path),
      null => null,
    },
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
