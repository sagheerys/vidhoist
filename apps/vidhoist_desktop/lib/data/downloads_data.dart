import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_transcripts/mt_transcripts.dart';

import '../di.dart';
import '../identity.dart';
import '../platform/user_folders.dart';
import 'appearance_data.dart';
import 'engine_data.dart';
import 'folders_data.dart';
import 'library_data.dart';
import 'local_copies.dart';
import 'lists_data.dart';
import 'sidecar_import.dart';
import 'transcripts_data.dart';

/// The saved key of "fetch the transcript first", the phone's own, so a
/// backup carries the choice either way.
const transcriptsFirstKey = 'transcripts_enabled';

/// Whether a clip's transcript is fetched with it; on unless turned off,
/// as on the phone.
final transcriptsFirstProvider =
    NotifierProvider<TranscriptsFirstNotifier, bool>(
      TranscriptsFirstNotifier.new,
    );

class TranscriptsFirstNotifier extends Notifier<bool> {
  @override
  bool build() {
    ref
        .read(keyValueStoreProvider)
        .getBool(transcriptsFirstKey)
        .then((saved) => state = saved ?? true, onError: (_) {});
    return true;
  }

  Future<void> set(bool on) {
    state = on;
    return ref
        .read(prefsMutexProvider)
        .run(
          () =>
              ref.read(keyValueStoreProvider).setBool(transcriptsFirstKey, on),
        );
  }
}

/// How captions are fetched from a server; a test puts its own in. Kept
/// with the server layer until it is removed.
final captionsFetcherFactoryProvider =
    Provider<CaptionsFetcher Function(VidhoistApi)>((ref) => CaptionsFetcher.new);

/// Collects a playlist's clips into one saved list as they arrive.
final batchCollectorProvider = Provider(
  (ref) => BatchPlaylistCollector(
    playlists: ref.watch(playlistsStoreProvider),
    onChanged: () => ref.invalidate(playlistsProvider),
  ),
);

/// The one download engine: yt-dlp on this computer, null where there is
/// no backend (a test that does not ask for one). What the last run left
/// unfinished is queued again as soon as it exists.
final downloadEngineProvider = Provider<LocalDownloadEngine?>((ref) {
  final backend = ref.watch(downloadBackendProvider);
  if (backend == null) return null;
  final collector = ref.watch(batchCollectorProvider);
  final engine = LocalDownloadEngine(
    backend: backend,
    folderFor: (task) => taskFolder(ref, task),
    history: ref.watch(localHistoryStoreProvider),
    pending: LocalPendingStore(
      ref.watch(keyValueStoreProvider),
      mutex: ref.watch(prefsMutexProvider),
    ),
    // The transcript comes with the clip itself, in the reader's language
    // then English, when "fetch the transcript" is on.
    subtitleLanguages: () => ref.read(transcriptsFirstProvider)
        ? [
            for (final language in readerLanguages(
              ref.read(appearanceProvider).locale,
            ))
              '$language.*',
          ]
        : const [],
    onCompleted: (task) {
      unawaited(collector.onFinished(task));
      ref.invalidate(localLibraryProvider);
      unawaited(importSidecarTranscripts(ref, task));
    },
    onLog: (message) => _log(ref, message),
  );
  unawaited(engine.restorePending());
  final dropped = engine.updates.listen((task) {
    if (task.phase == TaskPhase.failed || task.phase == TaskPhase.cancelled) {
      collector.onDropped(task.id);
    }
  });
  ref.onDispose(() {
    dropped.cancel();
    engine.dispose();
  });
  return engine;
});

void _log(Ref ref, String message) {
  try {
    unawaited(ref.read(loggerProvider).log(message, tag: 'engine'));
  } on Object {
    // No log in tests; a line lost is never a download lost.
  }
}

/// The folder a task's file goes to: the download folder, and below it the
/// folder chosen in the add dialog, if any.
String taskFolder(Ref ref, DownloadTask task) {
  final root =
      ref.read(downloadFolderProvider).valueOrNull ??
      fallbackDownloadFolder(EmberIdentity.displayName);
  return switch (task.folder) {
    final sub? when sub.isNotEmpty => '$root\\$sub',
    _ => root,
  };
}

/// The tasks whose file is to be saved on this computer once the server
/// has it ("then download it to this computer" in the add dialog), each
/// with the folder picked for it, or null for the download folder.
final pullAfterProvider = Provider<Map<String, String?>>((ref) => {});

/// A finished task asked to come to this computer goes to the copies; the
/// server keeps its own, as always here. Anything else is left alone.
void pullAfterFinished({
  required Map<String, String?> pulls,
  required LocalCopies copies,
  required DownloadTask task,
}) {
  if (!pulls.containsKey(task.id)) return;
  final into = pulls.remove(task.id);
  final path = task.serverFilename;
  final url = task.canonicalUrl;
  if (path == null || url == null) return;
  copies.download((
    canonicalUrl: url,
    title: task.title ?? ServerPath.basename(path),
    serverPath: path,
    thumbnail: task.thumbnail,
  ), into: into).ignore();
}

/// The engine's tasks, first as they are, then at each change.
final engineTasksProvider = StreamProvider<List<DownloadTask>>((ref) async* {
  final engine = ref.watch(downloadEngineProvider);
  if (engine == null) {
    yield const [];
    return;
  }
  yield engine.tasks;
  yield* engine.updates.map((_) => engine.tasks);
});

/// What the downloads button counts: clips being fetched or waiting their
/// turn, and copies coming to this computer. A paused one is not under
/// way.
final activeDownloadsProvider = Provider<int>((ref) {
  final tasks = ref.watch(engineTasksProvider).valueOrNull ?? const [];
  return tasks.where(isUnderWay).length + ref.watch(activeCopiesProvider);
});

/// Not finished, and not paused by the person.
bool isUnderWay(DownloadTask task) =>
    !task.isFinished && task.phase != TaskPhase.paused;

/// The folders the server would save into, asked when a picker opens and
/// forgotten when it closes, so a folder made since shows next time.
final serverFoldersProvider = FutureProvider.autoDispose<ServerFolders?>(
  (ref) async => ref.watch(apiClientProvider)?.fetchFolders(),
);

/// The folders the library's clips sit in.
final libraryFolderPathsProvider = Provider<Set<String>>((ref) {
  final items = ref.watch(libraryItemsProvider).valueOrNull ?? const [];
  return {for (final item in items) ?item.folderPath};
});

/// Whether the server ignores the chosen folder ([foldersIgnored]).
final foldersIgnoredProvider = Provider<bool>(
  (ref) =>
      foldersIgnored(ref.watch(historyProvider).valueOrNull?.done ?? const []),
);
