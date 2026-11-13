import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_transcripts/vh_transcripts.dart';

import '../di.dart';
import '../identity.dart';
import 'backup_folder.dart';
import 'backup_outcomes.dart';
import 'channels_data.dart';
import 'engine_data.dart';
import 'first_start.dart';
import 'folders_data.dart';
import 'library_data.dart';
import 'lists_data.dart';
import 'pc_link_data.dart';
import 'transcripts_data.dart';

export 'backup_outcomes.dart';

/// What a backup of this computer leaves out: when it last updated its
/// engine, and its paired phones and whether it receives from them; another
/// computer has its own.
const desktopBackupDeviceOnlyKeys = {
  ...EngineRefresh.deviceOnlyKeys,
  ...pcLinkDeviceOnlyKeys,
};

/// Where the dated backups of this computer are kept:
/// `Downloads\VidHoist\Backups` ([desktopBackupFolder]). Overridden in
/// main; null (tests) keeps none.
final backupFolderProvider = Provider<Directory?>((ref) => null);

final backupsProvider = Provider<DesktopBackups>(DesktopBackups.new);

/// One dated copy at each start (the rotation skips it when nothing
/// changed, and keeps one an hour): the phone backs up on every change,
/// a computer left open for days at least every launch. Watched by the
/// shell.
///
/// **Not before the first start is settled**: a fresh install backed up at
/// once wrote an empty copy that became the newest, the one a restore is
/// offered (2026-11-12), and seven such starts would push the real ones
/// out.
final startupBackupProvider = FutureProvider<void>((ref) async {
  final store = ref.read(keyValueStoreProvider);
  if (!(await store.getBool(welcomedKey) ?? false)) return;
  await ref.read(backupsProvider).backUpNow().then((_) {}, onError: (_) {});
});

/// This computer's backups (the phone's own format and rotation: the last
/// seven, an hour apart), importing a phone's, and exporting for it.
class DesktopBackups {
  DesktopBackups(this._ref);

  final Ref _ref;

  BackupRotation? get _rotation => switch (_ref.read(backupFolderProvider)) {
    final dir? => BackupRotation(directory: dir.path, prefix: 'vidhoist'),
    null => null,
  };

  BackupService get _service => BackupService(
    store: _ref.read(keyValueStoreProvider),
    mutex: _ref.read(prefsMutexProvider),
    variant: 'desktop',
    deviceOnlyKeys: desktopBackupDeviceOnlyKeys,
  );

  /// The saved transcripts beside the dated backups. They are files of
  /// their own in the app's data, not settings, so the backup itself does
  /// not carry them; one copy, kept current, is enough, since a restore
  /// only adds what is missing or older.
  File? get _transcriptsFile => switch (_ref.read(backupFolderProvider)) {
    final dir? => File('${dir.path}\\transcripts.json'),
    null => null,
  };

  /// A dated copy of everything here, skipped when nothing changed since
  /// the last; the oldest beyond seven go. The transcripts are copied
  /// beside it.
  Future<BackupFile?> backUpNow() async {
    final written = await _rotation?.write(await _service.exportToString());
    await _copyTranscripts();
    return written;
  }

  Future<void> _copyTranscripts() async {
    final file = _transcriptsFile;
    final store = _ref.read(transcriptStoreProvider);
    if (file == null || store == null) return;
    final all = await store.readAll().toList();
    if (all.isEmpty) return;
    final text = TranscriptBundle.encode(all);
    if (await file.exists() && await file.readAsString() == text) return;
    await file.parent.create(recursive: true);
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(text, flush: true);
    await tmp.rename(file.path);
  }

  Future<List<BackupFile>> list() async => await _rotation?.list() ?? const [];

  /// **Makes this computer what [file] says**, as a restore does on the
  /// phone: for this computer's own backups.
  Future<void> restore(BackupFile file) async =>
      restoreText(await File(file.path).readAsString());

  /// The same from a file's [contents], for a computer's backup chosen or
  /// dropped ([ComputerBackup]), then the transcripts kept beside the
  /// backups.
  Future<void> restoreText(String contents) async {
    await _service.importFromString(contents);
    if (await _transcriptsFile?.exists() ?? false) {
      final kept = TranscriptBundle.decode(
        await _transcriptsFile!.readAsString(),
      );
      if (kept != null) await _addTranscripts(kept);
    }
    _refresh();
  }

  /// **A transcripts file only**, for the Transcripts pane: what it added,
  /// or null when [contents] is not one. A backup chosen there is refused
  /// rather than restored, which belongs to the Backup pane.
  Future<int?> importTranscripts(String contents) async {
    final transcripts = TranscriptBundle.decode(contents);
    if (transcripts == null || _ref.read(transcriptStoreProvider) == null) {
      return null;
    }
    return _addTranscripts(transcripts);
  }

  /// Removes the copy kept beside the backups, with "Delete all": left
  /// there, a later restore would bring back what was deleted on purpose.
  /// An empty store never rewrites it (a fresh install's first backups
  /// must not wipe the copy a restore needs), so it goes here.
  Future<void> forgetTranscripts() async {
    final file = _transcriptsFile;
    try {
      if (file != null && await file.exists()) await file.delete();
    } on FileSystemException {
      // Left; the next backup with transcripts replaces it.
    }
  }

  /// Those of [transcripts] this computer lacks, or holds older.
  Future<int> _addTranscripts(List<Transcript> transcripts) async {
    final store = _ref.read(transcriptStoreProvider);
    if (store == null) return 0;
    var added = 0;
    for (final t in transcripts) {
      final mine = await store.read(t.canonicalUrl, t.language);
      if (mine != null && !t.fetchedAt.isAfter(mine.fetchedAt)) continue;
      await keepTranscript(_ref, store, t);
      added++;
    }
    return added;
  }

  /// A file dropped or chosen: a computer's full backup is offered for a
  /// restore ([ComputerBackup]); a phone's backup is **added** to what is
  /// here (a union, the later change winning); a transcripts file adds what
  /// this computer lacked.
  Future<ImportOutcome> importFile(String contents) async {
    if (_isComputerBackup(contents)) return ComputerBackup(contents);
    if (BackupMerge.looksLikeBackup(contents)) {
      final result = await BackupMerge(
        store: _ref.read(keyValueStoreProvider),
        mutex: _ref.read(prefsMutexProvider),
      ).mergeFrom(contents);
      _refresh();
      return MergedBackup(result);
    }
    return switch (await importTranscripts(contents)) {
      final added? => MergedTranscripts(added),
      null => const NotABackup(),
    };
  }

  /// Writes the two files a phone takes (this computer's tags, playlists
  /// and positions as a backup, and its transcripts) into
  /// `Downloads\Vidhoist\For the phone`, and returns that folder.
  Future<String?> exportForPhone({DateTime? at}) async {
    final base = await _ref.read(downloadFolderProvider.future);
    if (base == null) return null;
    final now = at ?? DateTime.now();
    final stamp = BackupRotation.stampOf(now);
    final dir = Directory('$base\\For the phone');
    await dir.create(recursive: true);
    await File('${dir.path}\\vidhoist_$stamp.json').writeAsString(
      await BackupMerge.exportShared(
        _ref.read(keyValueStoreProvider),
        now: now,
      ),
    );
    if (_ref.read(transcriptStoreProvider) case final store?) {
      final all = await store.readAll().toList();
      if (all.isNotEmpty) {
        await File('${dir.path}\\transcripts_$stamp.json')
            .writeAsString(TranscriptBundle.encode(all));
      }
    }
    return dir.path;
  }

  /// **Puts back in the library the clips already in the download folder**
  /// that it no longer lists ([LibraryRecovery]): after a reinstall, or a
  /// restore older than the downloads. A file's link comes from what
  /// yt-dlp left beside it, then from the playlists, which keep each
  /// clip's file name, then from the id in its name for YouTube; a file
  /// with none of these is left out and counted. Null with no download
  /// folder.
  Future<LibraryRecoveryResult?> recoverLibrary() async {
    final chosen = await _ref.read(downloadFolderProvider.future);
    if (chosen == null) return null;
    final downloads = await _ref.read(desktopFoldersProvider).downloads();
    final standard = downloads == null
        ? null
        : '$downloads\\${DesktopIdentity.displayName}';
    final history = _ref.read(localHistoryStoreProvider);
    final entries = await history.entries();
    final present = [
      for (final e in entries)
        if (await File(e.path).exists()) e,
    ];
    final playlists = await _ref.read(playlistsStoreProvider).readAll();
    final names = {
      for (final p in playlists)
        for (final e in p.items)
          if (e.serverFilename case final name? when e.canonicalUrl.isNotEmpty)
            name: e.canonicalUrl,
    };
    final knownUrls = {for (final e in present) e.item.canonicalUrl};
    var added = 0;
    var unknown = 0;
    for (final folder in {chosen, ?standard}) {
      final scan = await LibraryRecovery.scan(
        folder,
        knownPaths: {for (final e in entries) e.path},
        knownUrls: knownUrls,
        linksByName: names,
      );
      added += await history.recordRecovered(scan.found);
      knownUrls.addAll(scan.found.map((f) => f.url));
      unknown += scan.unknown.length;
    }
    _refresh();
    return LibraryRecoveryResult(added: added, unknown: unknown);
  }

  void _refresh() {
    _ref
      ..invalidate(localLibraryProvider)
      ..invalidate(libraryItemsProvider)
      ..invalidate(playlistsProvider)
      ..invalidate(tagCountsProvider)
      ..invalidate(channelsProvider);
  }
}

/// Whether [contents] is a computer's full backup ([BackupService] with
/// the `desktop` variant), as against a phone's or the shared part a
/// computer exports for the phone.
bool _isComputerBackup(String contents) {
  if (!BackupMerge.looksLikeBackup(contents)) return false;
  try {
    final decoded = json.decode(contents);
    return decoded is Map && decoded['variant'] == 'desktop';
  } on FormatException {
    return false;
  }
}
