import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../data/engine_data.dart';
import '../data/engine_fetch_data.dart';
import 'engine_locator.dart';
import 'engine_updater.dart';
import 'process_tree_windows.dart';
import 'ytdlp_process.dart';

/// The engine on this computer, for main: found in the app's own folder
/// under [roaming], then the installer's `tools`, then PATH; probes kept
/// under [local]'s cache.
List<Override> engineOverrides({
  required String roaming,
  required String local,
  required VhLogger logger,
}) {
  final locator = EngineLocator(
    ownFolder: '$roaming${Platform.pathSeparator}engine',
    installFolder:
        '${File(Platform.resolvedExecutable).parent.path}'
        '${Platform.pathSeparator}tools',
  );
  final tree = WindowsProcessTree();
  void log(String message) => unawaited(logger.log(message, tag: 'engine'));
  return [
    engineLocatorProvider.overrideWithValue(locator),
    cookiesFileTargetProvider.overrideWithValue(
      '$local${Platform.pathSeparator}cookies.txt',
    ),
    downloadBackendProvider.overrideWith((ref) {
      late final ProcessYtDlpBackend backend;
      final updater = EngineUpdater(
        locate: locator.locate,
        currentVersion: () async => (await backend.version()).ytDlp,
        install: (asset) async {
          final fetch = ref.read(engineFetchProvider.notifier);
          if (!await fetch.install(asset)) {
            throw StateError('yt-dlp ${asset.version} was not installed');
          }
        },
      );
      backend = ProcessYtDlpBackend(
        engine: () async {
          // ffmpeg and Deno the first time a download needs them; a
          // failed fetch leaves the download to try without.
          await ref.read(engineFetchProvider.notifier).ensure();
          return engineRunFor(
            ref.read(enginePathsProvider),
            ref.read(engineOptionsProvider),
          );
        },
        probeFolder: Directory(
          '$local${Platform.pathSeparator}cache'
          '${Platform.pathSeparator}probes',
        ),
        tree: tree,
        updater: updater.update,
        repairer: updater.repair,
        onLog: log,
      );
      return backend;
    }),
  ];
}
