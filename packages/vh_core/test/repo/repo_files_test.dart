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
    const internal = ['CLAUDE.md', 'docs/blueprint/', 'docs/design/'];
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
}
