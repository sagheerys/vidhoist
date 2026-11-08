import 'dart:io';

/// What yt-dlp really printed on Windows in the engine measurements
/// (`docs/ENGINE.md`), media links and local paths replaced.
String fixture(String name) =>
    File('test/fixtures/windows/$name').readAsStringSync();

/// The names of the runs kept, each with a `.stdout.txt` and `.stderr.txt`.
List<String> fixtureRuns() =>
    Directory('test/fixtures/windows')
        .listSync()
        .map((e) => e.uri.pathSegments.last)
        .where((n) => n.endsWith('.stdout.txt'))
        .map((n) => n.substring(0, n.length - '.stdout.txt'.length))
        .toList()
      ..sort();
