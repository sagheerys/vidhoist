import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_media/mt_media.dart';
import 'package:path_provider/path_provider.dart';

import 'features/downloads_library/download_wiring.dart';
import 'features/engine/channel_backend.dart';
import 'features/engine/engine_preparer.dart';
import 'features/engine/ytdlp_bridge.dart';
import 'features/downloads_library/local_item.dart';
import 'features/home/handled_links.dart';
import 'features/home/network_gate.dart';
import 'features/settings/auto_backup.dart';
import 'features/settings/settings_state.dart';
import 'features/shared/stores.dart';

/// Riverpod injection (TRD §3.1): a settings change rebuilds the client and
/// the engine automatically, with no Completers and no manual
/// synchronisation.

/// Overridden in main once SharedPreferences is ready.
final keyValueStoreProvider = Provider<KeyValueStore>(
  (ref) => throw UnimplementedError('overridden in main'),
);

final secretStoreProvider = Provider<SecretStore>(
  (ref) => const SecureSecretStore(),
);

final prefsMutexProvider = Provider((ref) => PrefsMutex());

/// The initial snapshot loaded before runApp; overridden in main.
final initialSettingsProvider = Provider<LiteSettings>(
  (ref) => throw UnimplementedError('overridden in main'),
);

final settingsProvider = NotifierProvider<SettingsNotifier, LiteSettings>(
  SettingsNotifier.new,
);

/// The server's client, **never built any more**: downloads run on the
/// phone. It stays until the server layer is deleted (phase 1, batch 6) so
/// what still names it compiles, and with it null every server path is off.
final apiClientProvider = Provider<VidhoistApiClient?>((ref) => null);

// The indexes (§5.5: all of them keyed by the unified item key).

/// canonicalUrl to the local path. In Lite it is filled after every
/// successful pull, so the URL stays associated with the file even after it
/// is deleted from the server, which it always is.
final offlineIndexProvider = Provider(
  (ref) => OfflineIndex(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

final artworkIndexProvider = Provider(
  (ref) => ArtworkIndex(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
    // The covers the app draws are in filesDir/thumbs; nothing outside
    // the app's files is deleted with an entry.
    ownFolder: () async => (await getApplicationSupportDirectory()).path,
  ),
);

/// Online covers kept as files on the phone (see CoverKeeper).
final keptCoverIndexProvider = Provider(
  (ref) => KeptCoverIndex(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

/// Clips whose cover was gone with nothing to stand in for it, left alone
/// for a day.
final probeFailureIndexProvider = Provider(
  (ref) => ProbeFailureIndex(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

/// Display titles, under the same key as the old Lite:
/// `video_title_metadata`.
final titleIndexProvider = Provider(
  (ref) => TitleIndex(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

/// Lite has no user tags (that is a Super feature); this is used for the
/// system "favourites" tag alone.
final tagsIndexProvider = Provider(
  (ref) => TagsIndex(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
    // **A single choke point for the automatic backup** (2026-09-04):
    // every tag write, from any screen, requests a backup, so no screen
    // can be forgotten.
    onChanged: () => unawaited(ref.read(autoBackupProvider).requestBackup()),
  ),
);

final playlistsStoreProvider = Provider(
  (ref) => PlaylistsStore(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
    // **A counter that invalidates the playlists cache** when they are
    // written from outside their own screen. Without it, an automatically
    // collected playlist stayed invisible until the app restarted
    // (confirmed
    // on the emulator 2026-09-03: the file on disk was correct and the
    // screen
    // was empty).
    onChanged: () => unawaited(ref.read(autoBackupProvider).requestBackup()),
  ),
);

/// Collects a playlist download into one saved playlist (asked 2026-09-02).
final batchCollectorProvider = Provider(
  (ref) => BatchPlaylistCollector(
    playlists: ref.watch(playlistsStoreProvider),
    onChanged: () => ref.read(playlistsRevisionProvider.notifier).state++,
  ),
);

/// **A counter that invalidates the playlists cache** when they are
/// written from outside their own screen. Without it, an automatically
/// collected playlist stayed invisible until the app was restarted: the
/// file on disk correct, the screen empty.
final playlistsRevisionProvider = StateProvider<int>((ref) => 0);

/// **Resolving short links before the routing decision** (field report
/// 2026-09-08): `on.soundcloud.com/…` is an album that contains no
/// `/sets/`, so it passed as a single clip and the server expanded it into
/// twenty. The engine resolves for itself later, and resolving what is
/// already resolved costs nothing (`needsResolution` returns false
/// immediately).
final shortLinkResolverProvider = Provider((ref) => ShortLinkResolver());

/// The server engine's records of unfinished pulls; unused since the
/// engine runs on the phone, kept until the server layer goes (batch 6).
final pendingDownloadsProvider = Provider(
  (ref) => PendingDownloadsStore(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

/// See [TrashcanProbe]: whether the server is really deleting the files.
final trashcanProbeProvider = Provider<TrashcanProbe?>((ref) {
  final api = ref.watch(apiClientProvider);
  if (api == null) return null;
  return TrashcanProbe(
    api: api,
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  );
});

/// Whether the last cleanup found the server keeping its files.
final serverKeepsFilesProvider = FutureProvider<bool>((ref) async {
  final probe = ref.watch(trashcanProbeProvider);
  return await probe?.serverKeepsFiles ?? false;
});

/// youtubedl-android, through `YtDlpBridge.kt`.
final ytDlpBridgeProvider = Provider<YtDlpBridge>(
  (ref) => MethodChannelYtDlpBridge(),
);

/// Unpacks the engine and keeps yt-dlp current; the welcome screen and the
/// engine settings show its state.
final enginePreparerProvider = Provider((ref) {
  final preparer = EnginePreparer(
    bridge: ref.watch(ytDlpBridgeProvider),
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
    // Read, not watched: a new preparer would forget the engine is ready.
    onLog: (message) =>
        unawaited(ref.read(loggerProvider).log(message, tag: 'engine')),
  );
  ref.onDispose(preparer.dispose);
  return preparer;
});

/// Listening starts here, at once: a generator would subscribe only after
/// its first value was taken, and a step finished in between was lost.
final engineStatusProvider = StreamProvider<EngineStatus>((ref) {
  final preparer = ref.watch(enginePreparerProvider);
  final statuses = StreamController<EngineStatus>()..add(preparer.status);
  final heard = preparer.statuses.listen(statuses.add);
  ref.onDispose(() {
    unawaited(heard.cancel());
    unawaited(statuses.close());
  });
  return statuses.stream;
});

final downloadBackendProvider = Provider<DownloadBackend>(
  (ref) => ChannelYtDlpBackend(
    bridge: ref.watch(ytDlpBridgeProvider),
    // The app's private cache: a probe's JSON holds links signed for this
    // phone's address.
    cacheDir: () async => (await getTemporaryDirectory()).path,
    forceIpv4: () => ref.read(settingsProvider).forceIpv4,
    ready: ref.watch(enginePreparerProvider).ensure,
  ),
);

/// Every download finished on this phone, with the fields the server's
/// history had.
final localHistoryProvider = Provider(
  (ref) => LocalHistoryStore(
    ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

/// The downloads not finished yet, queued again at the next launch.
final localPendingProvider = Provider(
  (ref) => LocalPendingStore(
    ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

/// yt-dlp on the phone, one download at a time: each runs Python and
/// often ffmpeg, which is all a phone should carry at once.
///
/// Never null in the app; null stays in the type for the screens that ask.
final downloadEngineProvider = Provider<LocalDownloadEngine?>((ref) {
  final logger = ref.watch(loggerProvider);
  final collector = ref.watch(batchCollectorProvider);
  final engine = LocalDownloadEngine(
    backend: ref.watch(downloadBackendProvider),
    folderFor: (_) => liteMediaDir,
    history: ref.watch(localHistoryProvider),
    pending: ref.watch(localPendingProvider),
    onCompleted: (task) {
      unawaited(collector.onFinished(task));
      unawaited(onDownloadCompleted(ref, task));
    },
    onLog: (message) => unawaited(logger.log(message, tag: 'download')),
    // "Wi-Fi only" holds the start; losing Wi-Fi mid-way pauses
    // (`wifiPauseProvider`).
    startGate: () {
      if (!ref.read(settingsProvider).wifiOnly) return true;
      return ref.read(networkGateProvider).onWifi;
    },
    // Field report 2026-09-03: YouTube at "best" gives AV1 or VP9 and the
    // clip looks torn on phones. This asks for H.264/AAC instead.
    compatibleVideo: () => ref.read(settingsProvider).compatiblePlayback,
    subtitleLanguages: () => ref.read(settingsProvider).subtitleLanguages,
  );
  ref.onDispose(engine.dispose);
  noteSubmittedLinks(ref, engine);
  return engine;
});

/// A live snapshot of the engine's tasks, refreshed on every state update.
///
/// **The first `yield engine.tasks` is the fix for the ghost tasks:** a
/// StreamProvider keeps its previous value while rebuilding, and the new
/// engine does not broadcast until the first `submit`, so the dead engine's
/// tasks stayed on display — and in Lite **the foreground service never
/// switched off**, because it follows the live task count.
final engineTasksProvider = StreamProvider<List<DownloadTask>>((ref) async* {
  final engine = ref.watch(downloadEngineProvider);
  if (engine == null) {
    yield const [];
    return;
  }
  yield engine.tasks;
  yield* engine.updates.map((_) => engine.tasks);
});

/// **Tells the collector which batch members dropped out** (failed or
/// cancelled), so the collected playlist does not hang waiting for them,
/// and is deleted if every one of its items drops.
final batchDropWatcherProvider = Provider<void>((ref) {
  final collector = ref.watch(batchCollectorProvider);
  ref.listen<AsyncValue<List<DownloadTask>>>(engineTasksProvider, (_, next) {
    for (final task in next.valueOrNull ?? const <DownloadTask>[]) {
      if (!task.isBatchMember) continue;
      if (task.phase == TaskPhase.failed || task.phase == TaskPhase.cancelled) {
        unawaited(collector.onDropped(task.id));
      }
    }
  });
});

/// The unfinished tasks: the live library cards and the header badge.
final activeTasksProvider = Provider<List<DownloadTask>>((ref) {
  final tasks = ref.watch(engineTasksProvider).valueOrNull ?? const [];
  return tasks.where((t) => !t.isFinished).toList();
});

/// Backups: writes the current format and reads the legacy ones.
final backupServiceProvider = Provider(
  (ref) => BackupService(
    store: ref.watch(keyValueStoreProvider),
    secrets: ref.watch(secretStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
    variant: 'lite',
  ),
);

/// The diagnostic log; overridden in main with a path from path_provider.
final loggerProvider = Provider<MTLogger>(
  (ref) => throw UnimplementedError('overridden in main'),
);

// Playback (mt_media is reused in full).

final playbackPrefsProvider = Provider(
  (ref) => PlaybackPrefs(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

final playbackPositionsProvider = Provider(
  (ref) => PlaybackPositionStore(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

/// Clip dimensions, filled opportunistically on first play.
final mediaShapeIndexProvider = Provider(
  (ref) => MediaShapeIndex(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

final audioStateStoreProvider = Provider(
  (ref) => AudioStateStore(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

/// Overridden in main. **Lite never streams**: its library is entirely
/// local, so the endpoint stays `none` and the golden rule always ends at
/// the local file.
final playbackResolverProvider = Provider<PlaybackSourceResolver>(
  (ref) => throw UnimplementedError('overridden in main'),
);

/// The background audio handler; overridden in main after
/// `AudioService.init`.
final audioHandlerProvider = Provider<MTAudioHandler>(
  (ref) => throw UnimplementedError('overridden in main'),
);
