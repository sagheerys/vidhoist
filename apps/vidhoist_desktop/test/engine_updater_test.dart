import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_desktop/platform/engine_locator.dart';
import 'package:vidhoist_desktop/platform/engine_pins.dart';
import 'package:vidhoist_desktop/platform/engine_updater.dart';

/// yt-dlp's folder build cannot update itself (`-U` refuses it), so the
/// app fetches the newer release itself, checked against that release's
/// own SHA2-256SUMS. A yt-dlp found on PATH is the one-file build, which
/// does update itself.
void main() {
  const sums =
      'aaaa000000000000000000000000000000000000000000000000000000000000  yt-dlp.exe\n'
      'fd51b212cf8380c7a52ee08c0d6be7f3c59b2f2c832eaf7b45acfae6eab57419  yt-dlp_win.zip\n';

  late List<Uri> asked;
  late List<PinnedAsset> installed;
  late List<List<String>> ran;

  setUp(() {
    asked = [];
    installed = [];
    ran = [];
  });

  EngineUpdater updater({
    required bool managed,
    String latest = '2026.11.01',
    String current = '2026.10.26',
    String selfUpdate = 'Updated yt-dlp to stable@2026.11.01',
  }) => EngineUpdater(
    locate: () => EnginePaths(
      ytDlp: managed ? r'C:\own\yt-dlp\yt-dlp.exe' : r'C:\bin\yt-dlp.exe',
      managed: managed,
    ),
    currentVersion: () async => EngineVersion.tryParse(current),
    getText: (url) async {
      asked.add(url);
      return url.path.endsWith('SHA2-256SUMS')
          ? sums
          : '{"tag_name": "$latest", "name": "yt-dlp $latest"}';
    },
    install: (asset) async => installed.add(asset),
    run: (exe, args) async {
      ran.add([exe, ...args]);
      return (code: 0, output: selfUpdate);
    },
  );

  test('a newer release is fetched against its own checksums', () async {
    final outcome = await updater(managed: true).update(EngineChannel.stable);
    expect(outcome.updated, isTrue);
    expect(outcome.version.toString(), '2026.11.01');
    expect(asked.first.path, '/repos/yt-dlp/yt-dlp/releases/latest');
    final asset = installed.single;
    expect(asset.part, EnginePart.ytDlp);
    expect(
      asset.url.toString(),
      'https://github.com/yt-dlp/yt-dlp/releases/download/2026.11.01/yt-dlp_win.zip',
    );
    expect(
      asset.sha256,
      'fd51b212cf8380c7a52ee08c0d6be7f3c59b2f2c832eaf7b45acfae6eab57419',
    );
    expect(ran, isEmpty);
  });

  test('already current: nothing is fetched', () async {
    final outcome = await updater(
      managed: true,
      latest: '2026.10.26',
    ).update(EngineChannel.stable);
    expect(outcome.updated, isFalse);
    expect(outcome.version.toString(), '2026.10.26');
    expect(installed, isEmpty);
  });

  test('nightly reads the nightly repository', () async {
    await updater(managed: true).update(EngineChannel.nightly);
    expect(
      asked.first.path,
      '/repos/yt-dlp/yt-dlp-nightly-builds/releases/latest',
    );
    expect(
      installed.single.url.path,
      startsWith('/yt-dlp/yt-dlp-nightly-builds/'),
    );
  });

  test('a release with no checksum for the build is refused', () async {
    final refusing = EngineUpdater(
      locate: () =>
          const EnginePaths(ytDlp: r'C:\own\yt-dlp.exe', managed: true),
      currentVersion: () async => EngineVersion.tryParse('2026.10.26'),
      getText: (url) async => url.path.endsWith('SHA2-256SUMS')
          ? 'abc  yt-dlp.exe\n'
          : '{"tag_name": "2026.11.01"}',
      install: (asset) async => installed.add(asset),
      run: (_, _) async => (code: 0, output: ''),
    );
    final outcome = await refusing.update(EngineChannel.stable);
    expect(outcome.updated, isFalse);
    expect(outcome.error, isNotNull);
    expect(installed, isEmpty);
  });

  test('the one-file build on PATH updates itself', () async {
    final outcome = await updater(managed: false).update(EngineChannel.stable);
    expect(ran.single, [r'C:\bin\yt-dlp.exe', '-U']);
    expect(outcome.updated, isTrue);
    expect(outcome.version.toString(), '2026.11.01');
    expect(asked, isEmpty);
  });

  test('the one-file build already current says so', () async {
    final outcome = await updater(
      managed: false,
      selfUpdate: 'Current version: stable@2026.10.26\nyt-dlp is up to date',
    ).update(EngineChannel.stable);
    expect(outcome.updated, isFalse);
  });

  test('no engine: nothing to update', () async {
    final none = EngineUpdater(
      locate: () => const EnginePaths(),
      currentVersion: () async => null,
      getText: (_) async => '',
      install: (_) async {},
      run: (_, _) async => (code: 0, output: ''),
    );
    final outcome = await none.update(EngineChannel.stable);
    expect(outcome.updated, isFalse);
    expect(outcome.error, isNotNull);
  });

  group('repair — the cache cleared, then a fresh copy', () {
    test('the managed copy: --rm-cache-dir first, then the current release '
        'fetched even though the version there says it is current, since a '
        'damaged copy reports the right number', () async {
      final outcome = await updater(
        managed: true,
        latest: '2026.10.26',
      ).repair();
      expect(ran.single, [r'C:\own\yt-dlp\yt-dlp.exe', '--rm-cache-dir']);
      expect(installed.single.version, '2026.10.26');
      expect(outcome.updated, isTrue);
      expect(outcome.error, isNull);
    });

    test(
      'a yt-dlp on PATH belongs to its owner: the cache, then its own -U',
      () async {
        final outcome = await updater(managed: false).repair();
        expect(ran, [
          [r'C:\bin\yt-dlp.exe', '--rm-cache-dir'],
          [r'C:\bin\yt-dlp.exe', '-U'],
        ]);
        expect(installed, isEmpty);
        expect(outcome.updated, isTrue);
      },
    );

    test('no network: the cache is cleared, the copy in use stays, and the '
        'outcome says the rest failed', () async {
      final offline = EngineUpdater(
        locate: () => const EnginePaths(
          ytDlp: r'C:\own\yt-dlp\yt-dlp.exe',
          managed: true,
        ),
        currentVersion: () async => EngineVersion.tryParse('2026.10.26'),
        getText: (url) async => throw const SocketExceptionLike(),
        install: (asset) async => installed.add(asset),
        run: (exe, args) async {
          ran.add([exe, ...args]);
          return (code: 0, output: '');
        },
      );
      final outcome = await offline.repair();
      expect(ran.single.last, '--rm-cache-dir');
      expect(installed, isEmpty);
      expect(outcome.updated, isFalse);
      expect(outcome.error, isNotNull);
      expect(outcome.version.toString(), '2026.10.26');
    });

    test('no yt-dlp at all is said, not thrown', () async {
      final none = EngineUpdater(
        locate: () => const EnginePaths(managed: false),
        currentVersion: () async => null,
        install: (asset) async {},
      );
      expect((await none.repair()).error, 'no yt-dlp to repair');
    });
  });
}

/// A network failure, as the fetch would throw it.
class SocketExceptionLike implements Exception {
  const SocketExceptionLike();
}
