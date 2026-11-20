import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/data/update_data.dart';
import 'package:vidhoist_desktop/di.dart';
import 'package:vh_core/vh_core.dart';

/// `releases/latest` as GitHub answers it, for a release of all three
/// apps whose installer is served by [setupUrl].
String latest(
  String version,
  String setupUrl, {
  int size = 4000,
  String? digest,
}) => jsonEncode({
  'tag_name': 'v$version',
  'draft': false,
  'prerelease': false,
  'body': '## Fixed\n- Faster.',
  'html_url': 'https://github.com/x/y/releases/tag/v$version',
  'assets': [
    {
      'name': 'Vidhoist-v$version.apk',
      'browser_download_url':
          'https://github.com/x/y/releases/download/v1/super.apk',
      'size': 1,
    },
    {
      'name': installerNameFor(version),
      'browser_download_url': setupUrl,
      'size': size,
      'digest': ?digest,
    },
  ],
});

void main() {
  late HttpServer server;
  late Directory folder;
  late List<String> started;
  late bool launches;

  /// What the download serves; a Windows program unless a test says not.
  late List<int> served;

  setUp(() async {
    folder = Directory.systemTemp.createTempSync('ember_update_');
    started = [];
    launches = true;
    served = Uint8List(4000)..setAll(0, ApkDownloader.exeMagic);
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      request.response.add(served);
      await request.response.close();
    });
  });

  tearDown(() async {
    await server.close(force: true);
    folder.deleteSync(recursive: true);
  });

  String setupUrl() => 'http://127.0.0.1:${server.port}/setup.exe';

  ProviderContainer containerFor(
    String release, {
    String running = '0.1.0',
    MemoryKeyValueStore? store,
  }) {
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store ?? MemoryKeyValueStore()),
        installedVersionProvider.overrideWith((ref) async => running),
        updateCheckerProvider.overrideWithValue(
          UpdateChecker(
            assetMarker: 'vidhoist',
            assetExtension: '.exe',
            fetch: (_) async => release,
            // The installer comes from this test's own server.
            trustedAsset: (_) => true,
          ),
        ),
        updateFolderProvider.overrideWithValue(folder.path),
        installerLauncherProvider.overrideWithValue((path) async {
          started.add(path);
          return launches;
        }),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  /// The hash GitHub records for what [served] holds now: a release always
  /// carries one, and one without it is refused before any download.
  String digestOfServed() => 'sha256:${sha256.convert(served)}';

  test('**the guard**: a newer version is downloaded as the installer and '
      'started, never the phone app\'s APK', () async {
    final c = containerFor(
      latest('0.2.0', setupUrl(), digest: digestOfServed()),
    );
    final update = c.read(updateProvider.notifier);
    await update.checkNow();
    expect(c.read(updateProvider).phase, UpdatePhase.available);
    expect(c.read(updateProvider).release!.apkUrl, setupUrl());

    await update.install();
    final path = started.single;
    expect(path, endsWith(installerNameFor('0.2.0')));
    expect(File(path).readAsBytesSync().take(2), ApkDownloader.exeMagic);
  });

  test('**the guard**: the app itself asks for its installer and checks it '
      'is a program', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final checker = c.read(updateCheckerProvider);
    expect((checker.assetMarker, checker.assetExtension), ('vidhoist', '.exe'));
    expect(c.read(installerDownloaderProvider).magic, ApkDownloader.exeMagic);
    // From GitHub over https only: a file from anywhere else is no update.
    expect(checker.trustedAsset(Uri.parse('http://127.0.0.1/x.exe')), isFalse);
    expect(
      checker.trustedAsset(
        Uri.parse('https://github.com/a/b/releases/download/v1/x.exe'),
      ),
      isTrue,
    );
  });

  test('**the guard**: a release tag never makes the installer\'s path '
      'climb out of the temporary folder', () {
    final name = installerNameFor(
      AppVersion.tryParse(
        r'v9.9.9-..\..\Microsoft\Windows\Start Menu\Programs\Startup\x',
      ).toString(),
    );
    expect(name, isNot(contains(r'\')));
    expect(name, isNot(contains('/')));
    expect(name, isNot(contains(' ')));
    expect(installerNameFor('2.7.0'), 'Vidhoist-2.7.0-windows-x64-setup.exe');
  });

  test('what is not an installer is never started', () async {
    served = utf8.encode('<html>sign in</html>');
    // Its hash matches: the page is refused for what it is.
    final c = containerFor(
      latest('0.2.0', setupUrl(), size: 0, digest: digestOfServed()),
    );
    final update = c.read(updateProvider.notifier);
    await update.checkNow();
    await update.install();
    expect(started, isEmpty);
    expect(c.read(updateProvider).failure, UpdateFailure.download);
  });

  test('an installer Windows would not start says so', () async {
    launches = false;
    // The file is the release's, so what fails is the start alone.
    final c = containerFor(
      latest('0.2.0', setupUrl(), digest: digestOfServed()),
    );
    final update = c.read(updateProvider.notifier);
    await update.checkNow();
    await update.install();
    expect(c.read(updateProvider).failure, UpdateFailure.install);
  });

  test("**the guard**: an installer whose hash is not the release's is "
      'never started', () async {
    // The file is run as it is; one altered on the way keeps its `MZ` and
    // its size, so only the hash GitHub recorded at upload tells.
    final c = containerFor(
      latest('0.2.0', setupUrl(), digest: 'sha256:${'0' * 64}'),
    );
    final update = c.read(updateProvider.notifier);
    await update.checkNow();
    expect(c.read(updateProvider).release!.sha256, '0' * 64);
    await update.install();
    expect(started, isEmpty);
    expect(c.read(updateProvider).failure, UpdateFailure.download);
  });

  test("an installer matching the release's hash is started", () async {
    final hash = sha256.convert(served).toString().toUpperCase();
    final c = containerFor(latest('0.2.0', setupUrl(), digest: 'sha256:$hash'));
    final update = c.read(updateProvider.notifier);
    await update.checkNow();
    await update.install();
    expect(started, hasLength(1));
  });

  test('the same version or an older one is no update', () async {
    final c = containerFor(latest('0.1.0', setupUrl()));
    await c.read(updateProvider.notifier).checkNow();
    expect(c.read(updateProvider).release, isNull);
    expect(c.read(updateProvider).upToDate, isTrue);
  });

  test('a skipped version stays quiet at start-up, and the button still '
      'finds it', () async {
    final store = MemoryKeyValueStore();
    final first = containerFor(latest('0.2.0', setupUrl()), store: store);
    await first.read(updateProvider.notifier).checkNow();
    await first.read(updateProvider.notifier).skip();
    expect(first.read(updateProvider).release, isNull);

    // The next start: the check is due again.
    await store.remove(UpdatePrefs.lastCheckKey);
    final next = containerFor(latest('0.2.0', setupUrl()), store: store);
    await next.read(updateProvider.notifier).checkSilently();
    expect(next.read(updateProvider).release, isNull);
    await next.read(updateProvider.notifier).checkNow();
    expect(next.read(updateProvider).release, isNotNull);
  });

  test('turned off, the start-up check asks nothing', () async {
    final store = MemoryKeyValueStore();
    await store.setBool(UpdatePrefs.autoCheckKey, false);
    final c = containerFor(latest('0.2.0', setupUrl()), store: store);
    await c.read(updateProvider.notifier).checkSilently();
    expect(c.read(updateProvider).release, isNull);
  });

  test('the installer of the version now running is cleared away', () async {
    final store = MemoryKeyValueStore();
    await store.setString(UpdatePrefs.downloadedVersionKey, '0.2.0');
    final old = File(
      '${folder.path}${Platform.pathSeparator}${installerNameFor('0.2.0')}',
    )..writeAsBytesSync([0x4D, 0x5A]);
    final c = containerFor(
      latest('0.2.0', setupUrl()),
      running: '0.2.0',
      store: store,
    );
    c.read(updateProvider);
    // The sweep runs on its own after the state is first read.
    for (var i = 0; i < 20 && old.existsSync(); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    expect(old.existsSync(), isFalse);
  });
}
