import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../engine/channel_backend.dart';
import '../engine/ytdlp_bridge.dart';
import '../settings/settings_state.dart';
import '../shared/stores.dart';
import 'background_check.dart';
import 'background_notices.dart';
import 'background_state.dart';
import 'background_status.dart';

/// **The check made while the app is closed**, in the engine Android's
/// scheduler starts for it (`BackgroundCheck.kt`), or in the app's own
/// engine when the app is alive but out of sight. Built from the same
/// pieces as the app, minus everything that downloads: it reads, tells,
/// and says it is done, whatever happens, so the engine is let go.
Future<void> runBackgroundCheck({bool ownEngine = true}) async {
  const channel = MethodChannel(backgroundChannel);
  try {
    if (ownEngine) {
      WidgetsFlutterBinding.ensureInitialized();
      DartPluginRegistrant.ensureInitialized();
      initVhL10n();
    }
    await _check(ownEngine: ownEngine);
  } on Object catch (e) {
    // Nothing to show it to; the next check tries again.
    debugPrint('background check failed: $e');
  } finally {
    if (ownEngine) {
      try {
        await channel.invokeMethod<void>('done');
      } on Object {
        // An engine started some other way has no one to tell.
      }
    }
  }
}

Future<void> _check({required bool ownEngine}) async {
  final prefs = await SharedPreferences.getInstance();
  // An engine of its own reads what the app wrote since it started. The
  // app's engine has it already, and a reload there could drop a write
  // still on its way.
  if (ownEngine) await prefs.reload();
  final store = SharedPrefsKeyValueStore(prefs);
  if (!await readBackgroundChecks(store)) return;

  final support = await getApplicationSupportDirectory();
  final logger = VhLogger(filePath: '${support.path}/logs/vidhoist_mobile.log');
  void log(String message) => unawaited(logger.log(message, tag: 'background'));

  final settings = await PhoneSettings.load(store);
  final l = vhLocalizationsFor(settings.localeCode);
  final cookies = '${support.path}/cookies.txt';
  final backend = ChannelYtDlpBackend(
    bridge: MethodChannelYtDlpBridge(),
    cacheDir: () async => (await getTemporaryDirectory()).path,
    forceIpv4: () => settings.forceIpv4,
    cookiesFile: () => File(cookies).existsSync() ? cookies : null,
    // Unpacked by the app before any channel was followed; updating yt-dlp
    // is the app's to do, never two engines at once.
    ready: () async {},
  );
  final notices = BackgroundNotices(l);
  // The app's engine has set them up with its own tap handling, which a
  // second set-up would replace.
  if (ownEngine) await notices.init();
  final updates = UpdatePrefs(store: store, mutex: PrefsMutex());

  await BackgroundCheck(
    peek: ChannelPeek(store: store, backend: backend, onLog: log),
    status: BackgroundStatusFile(backgroundStatusPath(support.path)),
    notifyNews: notices.news,
    newVersion: () async {
      if (!await updates.autoCheck()) return null;
      final release =
          await UpdateChecker(
            fetch: ioHttpGetString,
            assetMarker: 'vidhoist',
          ).check(
            currentVersion: (await PackageInfo.fromPlatform()).version,
            skippedVersion: await updates.skippedVersion(),
          );
      return release?.version.toString();
    },
    notifyUpdate: notices.update,
    onLog: log,
  ).run();
}
