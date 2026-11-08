import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../di.dart';
import '../platform/engine_locator.dart';
import '../platform/ytdlp_process.dart';

/// What the person chose about how yt-dlp runs.
class EngineOptions {
  const EngineOptions({
    this.forceIpv4 = true,
    this.cookiesFile,
    this.cookiesBrowser,
  });

  /// `-4`, on unless turned off: a broken IPv6 route stalls each download
  /// by about 20 s (`docs/ENGINE.md`, finding 7). Off only for a network
  /// that has IPv6 alone.
  final bool forceIpv4;

  /// A Netscape cookies file on this computer, for sites that need a
  /// signed-in session.
  final String? cookiesFile;

  /// A browser whose own cookies yt-dlp reads (`firefox`, `chrome`,
  /// `edge`); chosen over [cookiesFile] when both are set.
  final String? cookiesBrowser;

  EngineOptions copyWith({
    bool? forceIpv4,
    String? Function()? cookiesFile,
    String? Function()? cookiesBrowser,
  }) => EngineOptions(
    forceIpv4: forceIpv4 ?? this.forceIpv4,
    cookiesFile: cookiesFile == null ? this.cookiesFile : cookiesFile(),
    cookiesBrowser: cookiesBrowser == null
        ? this.cookiesBrowser
        : cookiesBrowser(),
  );
}

/// The browsers `--cookies-from-browser` is offered for on Windows.
const cookieBrowsers = ['edge', 'chrome', 'firefox', 'brave', 'opera'];

final engineOptionsProvider =
    NotifierProvider<EngineOptionsNotifier, EngineOptions>(
      EngineOptionsNotifier.new,
    );

class EngineOptionsNotifier extends Notifier<EngineOptions> {
  static const ipv4Key = 'desktop_engine_ipv4';
  static const cookiesFileKey = 'desktop_cookies_file';
  static const cookiesBrowserKey = 'desktop_cookies_browser';

  @override
  EngineOptions build() {
    _load();
    return const EngineOptions();
  }

  Future<void> _load() async {
    final store = ref.read(keyValueStoreProvider);
    try {
      final file = await store.getString(cookiesFileKey);
      final browser = await store.getString(cookiesBrowserKey);
      state = EngineOptions(
        forceIpv4: await store.getBool(ipv4Key) ?? true,
        cookiesFile: (file?.isEmpty ?? true) ? null : file,
        cookiesBrowser: (browser?.isEmpty ?? true) ? null : browser,
      );
    } on Object {
      // Unreadable settings are the defaults, never a failed start.
    }
  }

  Future<void> setForceIpv4(bool on) {
    state = state.copyWith(forceIpv4: on);
    return _save((s) => s.setBool(ipv4Key, on));
  }

  Future<void> setCookiesFile(String? path) {
    state = state.copyWith(cookiesFile: () => path);
    return _save((s) => s.setString(cookiesFileKey, path ?? ''));
  }

  Future<void> setCookiesBrowser(String? browser) {
    state = state.copyWith(cookiesBrowser: () => browser);
    return _save((s) => s.setString(cookiesBrowserKey, browser ?? ''));
  }

  Future<void> _save(Future<void> Function(KeyValueStore store) write) => ref
      .read(prefsMutexProvider)
      .run(() => write(ref.read(keyValueStoreProvider)));
}

/// Where a cookies file chosen in Settings is kept for yt-dlp: the app's
/// local folder, which no backup and no roaming profile carries, since it
/// holds live sign-ins. Overridden in main; null in tests that do not ask.
final cookiesFileTargetProvider = Provider<String?>((ref) => null);

/// yt-dlp's command for what was found and what was chosen; null with no
/// yt-dlp on this computer.
EngineRun? engineRunFor(EnginePaths paths, EngineOptions options) {
  final ytDlp = paths.ytDlp;
  if (ytDlp == null) return null;
  return EngineRun(
    ytDlp: ytDlp,
    ffmpeg: paths.ffmpeg,
    deno: paths.deno,
    setup: EngineSetup(
      platform: HostPlatform.windows,
      ffmpegDir: paths.ffmpegDir,
      jsRuntime: switch (paths.deno) {
        final deno? => 'deno:$deno',
        null => null,
      },
      forceIpv4: options.forceIpv4,
      cookiesFromBrowser: options.cookiesBrowser,
      cookiesFile: options.cookiesBrowser == null ? options.cookiesFile : null,
    ),
  );
}

/// Finds the engine; overridden in main with the app's folders. Null in
/// tests, where nothing is found.
final engineLocatorProvider = Provider<EngineLocator?>((ref) => null);

/// Where each part of the engine is now; [EnginePathsNotifier.refresh]
/// after a fetch or an update.
final enginePathsProvider = NotifierProvider<EnginePathsNotifier, EnginePaths>(
  EnginePathsNotifier.new,
);

class EnginePathsNotifier extends Notifier<EnginePaths> {
  @override
  EnginePaths build() =>
      ref.watch(engineLocatorProvider)?.locate() ?? const EnginePaths();

  void refresh() =>
      state = ref.read(engineLocatorProvider)?.locate() ?? const EnginePaths();
}

/// yt-dlp on this computer; the process backend in main, a fake in
/// tests, null where there is none.
final downloadBackendProvider = Provider<DownloadBackend?>((ref) => null);

/// The versions in use, for the engine line and its settings.
final engineVersionProvider = FutureProvider<BackendVersion>((ref) async {
  ref.watch(enginePathsProvider);
  final backend = ref.watch(downloadBackendProvider);
  return await backend?.version() ?? const BackendVersion();
});

/// The downloads recorded on this computer.
final localHistoryStoreProvider = Provider(
  (ref) => LocalHistoryStore(
    ref.watch(keyValueStoreProvider),
    mutex: ref.watch(prefsMutexProvider),
  ),
);

/// The recorded downloads whose file is still there: one deleted or moved
/// outside the app leaves the library rather than failing to play.
final localLibraryProvider = FutureProvider<List<LocalHistoryEntry>>((
  ref,
) async {
  final entries = await ref.watch(localHistoryStoreProvider).entries();
  return [
    for (final entry in entries)
      if (await File(entry.path).exists()) entry,
  ];
});
