import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_transcripts/vh_transcripts.dart';

import '../../di.dart';
import '../downloads_library/download_wiring.dart';
import '../downloads_library/library_providers.dart';
import '../storage/phone_volumes.dart';
import 'pc_link_state.dart';

/// Where a copy from the computer goes: the phone's media folder, where its
/// own downloads are, so the library lists it as one of them. Replaced in
/// tests.
final pcCopyDirProvider = Provider<String>(
  (ref) => ref.watch(libraryDirsProvider).first,
);

/// One copy under way: its share done, 0 to 1, or null while the size is
/// not known yet.
class PcCopy {
  const PcCopy({this.progress});

  final double? progress;
}

/// How a copy ended.
enum PcCopyEnd { copied, stopped, failed }

/// **The computer's clip, copied into the phone's library**: the file, the
/// transcripts beside it as subtitle files (as a download writes them, so
/// the player shows them), and the same indexes a download fills. The
/// copies under way, by the computer's clip id.
final pcCopiesProvider = NotifierProvider<PcCopies, Map<String, PcCopy>>(
  PcCopies.new,
);

class PcCopies extends Notifier<Map<String, PcCopy>> {
  final _stopped = <String>{};

  @override
  Map<String, PcCopy> build() => const {};

  /// Ends the copy of [id] at the next piece; what was written goes.
  void stop(String id) {
    if (state.containsKey(id)) _stopped.add(id);
  }

  Future<PcCopyEnd> copy(PcItem item) async {
    final client = ref.read(pcClientProvider);
    if (client == null || state.containsKey(item.id)) return PcCopyEnd.failed;
    _set(item.id, const PcCopy());
    final dir = Directory(ref.read(pcCopyDirProvider));
    final extension = item.extension ?? (item.isAudio ? 'm4a' : 'mp4');
    final path =
        '${dir.path}/'
        '${buildLocalFilename(item.title, serverFilename: 'x.$extension')}';
    // Written beside under another name and renamed whole, so the library
    // never lists half a clip.
    final part = File('$path.part');
    IOSink? sink;
    try {
      final answer = await client.file(item.id);
      if (answer.statusCode != HttpStatus.ok) {
        await answer.body.drain<void>();
        return _end(item.id, PcCopyEnd.failed);
      }
      final total = answer.length ?? item.sizeBytes;
      await dir.create(recursive: true);
      sink = part.openWrite();
      var received = 0;
      var shown = -1;
      await for (final chunk in answer.body) {
        if (_stopped.contains(item.id)) break;
        sink.add(chunk);
        received += chunk.length;
        // A redraw a percent, not one a piece of 64 KB.
        final percent = total == null || total == 0
            ? null
            : (received * 100 ~/ total);
        if (percent != null && percent != shown) {
          shown = percent;
          _set(item.id, PcCopy(progress: received / total!));
        }
      }
      await sink.close();
      sink = null;
      if (_stopped.contains(item.id)) {
        await _delete(part);
        return _end(item.id, PcCopyEnd.stopped);
      }
      if (total != null && received != total) {
        await _delete(part);
        return _end(item.id, PcCopyEnd.failed);
      }
      await part.rename(path);
    } on Object {
      await sink?.close().catchError((Object _) {});
      await _delete(part);
      return _end(item.id, PcCopyEnd.failed);
    }
    await _subtitles(client, item, path);
    await _index(item, path);
    return _end(item.id, PcCopyEnd.copied);
  }

  /// Each language as `<name>.<language>.vtt` beside the clip. A clip
  /// without transcripts, or a computer that cannot be asked, still copies.
  Future<void> _subtitles(PcLinkApi client, PcItem item, String path) async {
    try {
      final stem = path.substring(0, path.lastIndexOf('.'));
      for (final raw in await client.transcripts(item.id)) {
        final transcript = Transcript.fromJson(raw);
        final language = transcript?.language ?? '';
        if (transcript == null ||
            transcript.isEmpty ||
            !RegExp(r'^[A-Za-z0-9-]{1,20}$').hasMatch(language)) {
          continue;
        }
        await File('$stem.$language.vtt')
            .writeAsString(transcriptToVtt(transcript), flush: true);
      }
    } on Object catch (e) {
      await ref
          .read(loggerProvider)
          .error('copy: transcripts not copied', cause: e, tag: 'pc');
    }
  }

  /// What a download does when it ends: the clip under its link, its
  /// title and its web cover, the gallery told, the library read again.
  Future<void> _index(PcItem item, String path) async {
    final url = item.url;
    final key = url ?? path;
    try {
      if (url != null) await ref.read(offlineIndexProvider).put(url, path);
      await ref.read(titleIndexProvider).put(key, item.title);
      if (item.thumbnail case final thumb?) {
        await ref.read(artworkIndexProvider).put(key, thumb);
      }
      await ref.read(mediaStoreProvider).scanFile(path);
    } on Object catch (e) {
      // The file is there and the library scans the folder.
      await ref
          .read(loggerProvider)
          .error('copy: indexing failed', cause: e, tag: 'pc');
    }
    ref.invalidate(localMediaProvider);
  }

  void _set(String id, PcCopy copy) => state = {...state, id: copy};

  PcCopyEnd _end(String id, PcCopyEnd end) {
    _stopped.remove(id);
    state = {...state}..remove(id);
    return end;
  }

  static Future<void> _delete(File file) async {
    try {
      if (await file.exists()) await file.delete();
    } on FileSystemException {
      // Nothing left to clear.
    }
  }
}
