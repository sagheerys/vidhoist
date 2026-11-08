import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';
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

/// Riverpod injection (TRD §3.1): a settings change rebuilds the engine
/// automatically, with no Completers and no manual synchronisation.

/// Overridden in main once SharedPreferences is ready.
final keyValueStoreProvider = Provider<KeyValueStore>(
  (ref) => throw UnimplementedError('overridden in main'),
);

final secretStoreProvider = Provider<SecretStore>(
  (ref) => const SecureSecretStore(),
);

final prefsMutexProvider = Provider((ref) => PrefsMutex());

/// The initial snapshot loaded before runApp; overridden in main.
final initialSettingsProvider = Provider<PhoneSettings>(
  (ref) => throw UnimplementedError('overridden in main'),
);

final settingsProvider = NotifierProvider<SettingsNotifier, PhoneSettings>(
  SettingsNotifier.new,
);

// The indexes (§5.5: all of them keyed by the unified item key).

/// canonicalUrl to the local path, filled after every finished download,
/// so a clip's link stays tied to its file.
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

/// Display titles, under a stored key that must never change:
/// `video_title_metadata`.
final titleIndexProvider = Provider(
  (ref) => TitleIndex(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

/// The phone app has no user tags; this is used for the system
/// "favourites" tag alone.
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
/// `/sets/`, so it passed as a single clip and was expanded into twenty. The engine resolves for itself later, and resolving what is
/// already resolved costs nothing (`needsResolution` returns false
/// immediately).
final shortLinkResolverProvider = Provider((ref) => ShortLinkResolver());

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

/// Every download finished on this phone, kept as its download history.
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
  var alive = true;
  final engine = LocalDownloadEngine(
    backend: ref.watch(downloadBackendProvider),
    folderFor: (_) => phoneMediaDir,
    history: ref.watch(localHistoryProvider),
    pending: ref.watch(localPendingProvider),
    // A site that moved on without yt-dlp: the engine updates and the
    // download tries once more, without a word to the person.
    refresh: EngineRefresh(
      backend: ref.watch(downloadBackendProvider),
      store: ref.watch(keyValueStoreProvider),
      mutex: ref.watch(prefsMutexProvider),
      onLog: (message) => unawaited(logger.log(message, tag: 'engine')),
    ),
    onCompleted: (task) {
      // A download can end as the app closes, after this provider has gone.
      if (!alive) return;
      unawaited(collector.onFinished(task));
      unawaited(onDownloadCompleted(ref, task, alive: () => alive));
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
  ref.onDispose(() {
    alive = false;
    engine.dispose();
  });
  noteSubmittedLinks(ref, engine);
  return engine;
});

/// A live snapshot of the engine's tasks, refreshed on every state update.
///
/// **The first `yield engine.tasks` is the fix for the ghost tasks:** a
/// StreamProvider keeps its previous value while rebuilding, and the new
/// engine does not broadcast until the first `submit`, so the dead engine's
/// tasks stayed on display — and **the foreground service never switched
/// off**, because it follows the live task count.
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

/// Backups: Vidhoist's plain JSON format, written and read.
final backupServiceProvider = Provider(
  (ref) => BackupService(
    store: ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
    variant: 'phone',
    // When this install last updated its engine: restored on a new phone
    // it would skip the update the shipped yt-dlp needs.
    deviceOnlyKeys: EngineRefresh.deviceOnlyKeys,
  ),
);

/// The diagnostic log; overridden in main with a path from path_provider.
final loggerProvider = Provider<VhLogger>(
  (ref) => throw UnimplementedError('overridden in main'),
);

// Playback (vh_media is reused in full).

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

/// Overridden in main. **The phone app never streams**: its library is entirely
/// local, so the endpoint stays `none` and the golden rule always ends at
/// the local file.
final playbackResolverProvider = Provider<PlaybackSourceResolver>(
  (ref) => throw UnimplementedError('overridden in main'),
);

/// The background audio handler; overridden in main after
/// `AudioService.init`.
final audioHandlerProvider = Provider<VhAudioHandler>(
  (ref) => throw UnimplementedError('overridden in main'),
);
