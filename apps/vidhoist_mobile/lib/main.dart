import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'di.dart';
import 'features/downloads_library/local_item.dart';
import 'features/settings/settings_state.dart';
import 'features/shared/error_report.dart';
import 'features/shared/stores.dart';
import 'features/update/update_state.dart';
import 'features/player/square_art.dart';

/// Bootstrap only: storage, the settings snapshot, the background audio
/// player, runApp.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // **On a phone the app is portrait and only the player rotates**
  // (decision 2026-09-05); `VhRotationScope` releases this lock while the
  // video player is open. A tablet is left free.
  VhOrientation.start();
  initVhL10n();

  final prefs = await SharedPreferences.getInstance();
  final store = SharedPrefsKeyValueStore(prefs);
  const secrets = SecureSecretStore();
  final initialSettings = await PhoneSettings.load(store);

  // One lock for all storage (rule 3), passed to everyone rather than
  // created twice. It was created above, before the seeding.
  final logsDir = await getApplicationSupportDirectory();
  final logger = VhLogger(filePath: '${logsDir.path}/logs/vidhoist_mobile.log');
  logEveryError(logger);

  // One lock for all storage (rule 3), passed to everyone rather than
  // created twice.
  final mutex = PrefsMutex();
  // Lite never streams: the endpoint stays `none`, so the golden rule
  // always ends at the local file.
  final resolver = PlaybackSourceResolver(endpoint: ServerStreamEndpoint.none);
  final handler = await AudioService.init(
    builder: () => VhAudioHandler(
      player: JustAudioPort(),
      resolver: resolver,
      positions: PlaybackPositionStore(store: store, mutex: mutex),
      prefs: PlaybackPrefs(store: store, mutex: mutex),
      stateStore: AudioStateStore(store: store, mutex: mutex),
    ),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.yasir.vidhoistlite.audio',
      androidNotificationChannelName: 'Vidhoist',
      // **`false` is forced by the package**, whose own assertion says an
      // ongoing flag "will make no effect with androidStopForegroundOnPause
      // set to false": a live foreground service already makes its
      // notification ongoing, so the flag only ever mattered in the paused,
      // unprotected state we are leaving behind.
      androidNotificationOngoing: false,
      // The white status-bar silhouette, as in the download notifications.
      androidNotificationIcon: 'drawable/ic_stat_vidhoist',
      // **`false`, against the package's default of `true`, after the
      // measurement of
      // 2026-09-19 on Super.** It used to be `true`, which leaves the
      // foreground service on every pause and releases the wake lock with
      // it. A phone call is the trap: the pause drops the app to `CAC`
      // (cached), and when the call ends and playback resumes the service
      // has to be started again **from the background** — which Android 12+
      // forbids outright (`ForegroundServiceStartNotAllowedException`).
      // Playback then carried on unprotected, the process was frozen, the
      // next item timed out and the session stopped itself a minute after
      // the call. Lite shares the handler, so it shared the defect.
      //
      // The cost, accepted by the owner: the notification stays while
      // paused (dismissible on Android 13+, sticky below it) and the wake
      // lock is held — which is why a paused session now stops itself after
      // [VhAudioHandler.pausedAutoStop].
      androidStopForegroundOnPause: false,
    ),
  );
  handler.squareArt = squareArtFor;
  await handler.loadPreferences();

  unawaited(logger.log('app started', tag: 'app'));
  final abis = await readDeviceAbis();

  // **Sweeping orphaned partials:** a download nobody will resume leaves
  // its pieces, and the library scan ignores them on purpose, so the space
  // is lost unseen. Three days, not hours: a paused download goes on from
  // its partial file. Startup never waits on a cleanup.
  unawaited(
    sweepPartialFiles(
      phoneMediaDir,
      olderThan: const Duration(days: 3),
    ).then((count) => count == 0 ? null : logger.log('swept $count partials')),
  );

  runApp(
    ProviderScope(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        secretStoreProvider.overrideWithValue(secrets),
        prefsMutexProvider.overrideWithValue(mutex),
        initialSettingsProvider.overrideWithValue(initialSettings),
        playbackResolverProvider.overrideWithValue(resolver),
        audioHandlerProvider.overrideWithValue(handler),
        loggerProvider.overrideWithValue(logger),
        deviceAbisProvider.overrideWithValue(abis),
      ],
      child: const PhoneApp(),
    ),
  );
}
