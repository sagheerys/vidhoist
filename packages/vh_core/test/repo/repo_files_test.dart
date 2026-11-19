import 'dart:io';

import 'package:test/test.dart';

/// The repository's own files, checked as the code is: a broken automation
/// entry or a private note slipping into git is caught by the tests, not by
/// whoever reads the repository after it opens.
void main() {
  // The tests run from packages/vh_core.
  final root = Directory.current.parent.parent;
  String path(String relative) =>
      '${root.path}${Platform.pathSeparator}$relative';

  test('every dependabot entry names a folder that exists', () {
    final lines = File(path('.github/dependabot.yml')).readAsLinesSync();
    final entries = <List<String>>[];
    for (final line in lines) {
      if (line.trimLeft().startsWith('- package-ecosystem:')) entries.add([]);
      if (entries.isNotEmpty) entries.last.add(line.trim());
    }
    expect(entries, isNotEmpty);
    for (final entry in entries) {
      // An entry without one is refused by dependabot, which then updates
      // nothing at all; one was left behind when an app was removed.
      final directory = entry.firstWhere(
        (line) => line.startsWith('directory:'),
        orElse: () => fail('no directory in: ${entry.first}'),
      );
      final folder = directory.substring('directory:'.length).trim();
      expect(
        Directory(path(folder.replaceFirst(RegExp('^/'), ''))).existsSync(),
        isTrue,
        reason: '$folder is not in the repository',
      );
    }
  });

  test('no internal note is tracked: the plans, the drafts and the '
      'assistant\'s instructions stay on the maintainer\'s disk', () async {
    final listed = await Process.run('git', [
      'ls-files',
    ], workingDirectory: root.path);
    if (listed.exitCode != 0) {
      markTestSkipped('not a git checkout');
      return;
    }
    final tracked = (listed.stdout as String).split('\n');
    const internal = [
      'CLAUDE.md',
      'docs/blueprint/',
      'docs/design/',
      'docs/adr/0001-',
    ];
    for (final prefix in internal) {
      expect(
        tracked.where((file) => file.startsWith(prefix)),
        isEmpty,
        reason: '$prefix is tracked',
      );
    }
    // The root publishes only the documents named here, so a working note
    // saved there never becomes part of the repository.
    const published = {
      'README.md',
      'README.ar.md',
      'CHANGELOG.md',
      'CONTRIBUTING.md',
      'CODE_OF_CONDUCT.md',
      'SECURITY.md',
    };
    final rootDocs = tracked.where(
      (file) => !file.contains('/') && file.toLowerCase().endsWith('.md'),
    );
    expect(rootDocs.toSet().difference(published), isEmpty);
  });

  test('no public document speaks of the project VidHoist came from: it '
      'stands as a project of its own', () async {
    final listed = await Process.run('git', [
      'ls-files',
      '*.md',
      '*.yml',
    ], workingDirectory: root.path);
    if (listed.exitCode != 0) {
      markTestSkipped('not a git checkout');
      return;
    }
    // The vendored plugins keep their own documents as their authors wrote
    // them.
    final documents = (listed.stdout as String)
        .split('\n')
        .where((file) => file.isNotEmpty && !file.startsWith('third_party/'));
    final naming = <String>[
      for (final file in documents)
        if (RegExp(
          'vidhoist',
          caseSensitive: false,
        ).hasMatch(File(path(file)).readAsStringSync()))
          file,
    ];
    expect(naming, isEmpty);
  });

  test('**the guard**: no package carries a placeholder licence, and the '
      'fonts travel with theirs', () {
    for (final dir in Directory(path('packages')).listSync()) {
      final licence = File('${dir.path}${Platform.pathSeparator}LICENSE');
      if (!licence.existsSync()) continue;
      // The licence page showed the template's placeholder sentence for two
      // of them; the root LICENSE covers the whole repository.
      expect(licence.readAsStringSync(), isNot(contains('TODO')));
    }
    final ofl = File(path('packages/vh_ui/assets/fonts/OFL.txt'));
    expect(ofl.readAsStringSync(), contains('SIL OPEN FONT LICENSE'));
  });

  test('**the guard**: the third-party page and the source fetcher name the '
      'versions the apps ship', () {
    final page = File(path('docs/THIRD-PARTY.md')).readAsStringSync();
    final fetcher = File(path('tool/fetch-third-party-sources.ps1'))
        .readAsStringSync();
    final gradle = File(
      path('apps/vidhoist_mobile/android/app/build.gradle.kts'),
    ).readAsStringSync();
    final engine = File(path('tool/fetch-engine.ps1')).readAsStringSync();
    final android = RegExp(r'youtubedl-android:library:([0-9.]+)')
        .firstMatch(gradle)!
        .group(1)!;
    final ytDlp = RegExp(r"Name = 'yt-dlp'; Version = '([0-9.]+)'")
        .firstMatch(engine)!
        .group(1)!;
    for (final version in [android, ytDlp]) {
      expect(page, contains(version), reason: 'docs/THIRD-PARTY.md');
      expect(fetcher, contains(version), reason: 'the source fetcher');
    }
  });
}
