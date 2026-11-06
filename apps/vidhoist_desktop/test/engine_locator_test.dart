import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/platform/engine_locator.dart';

/// Where yt-dlp, ffmpeg and Deno are found: the app's own engine folder
/// first (what it fetched or updated), then the installer's `tools`
/// folder, then PATH.
void main() {
  const own = r'C:\Users\me\AppData\Roaming\Vidhoist\engine';
  const tools = r'C:\Program Files\Vidhoist\tools';

  EngineLocator locator(Set<String> files, {List<String> path = const []}) =>
      EngineLocator(
        ownFolder: own,
        installFolder: tools,
        pathFolders: path,
        exists: files.contains,
      );

  test('nothing anywhere: not ready', () {
    final paths = locator({}).locate();
    expect(paths.ready, isFalse);
    expect(paths.ytDlp, isNull);
    expect(paths.ffmpegDir, isNull);
    expect(paths.deno, isNull);
  });

  test("the installer's yt-dlp is found, and can be replaced", () {
    final paths = locator({'$tools\\yt-dlp\\yt-dlp.exe'}).locate();
    expect(paths.ytDlp, '$tools\\yt-dlp\\yt-dlp.exe');
    expect(paths.ready, isTrue);
    expect(paths.managed, isTrue);
  });

  test("the app's own copy wins over the installer's", () {
    final paths = locator({
      '$tools\\yt-dlp\\yt-dlp.exe',
      '$own\\yt-dlp\\yt-dlp.exe',
      '$own\\ffmpeg\\ffmpeg.exe',
      '$own\\deno\\deno.exe',
    }).locate();
    expect(paths.ytDlp, '$own\\yt-dlp\\yt-dlp.exe');
    expect(paths.ffmpeg, '$own\\ffmpeg\\ffmpeg.exe');
    expect(paths.ffmpegDir, '$own\\ffmpeg');
    expect(paths.deno, '$own\\deno\\deno.exe');
  });

  test('PATH is the last place, and its yt-dlp updates itself', () {
    const bin = r'C:\bin';
    final paths = locator(
      {'$bin\\yt-dlp.exe', '$bin\\ffmpeg.exe', '$bin\\deno.exe'},
      path: [r'C:\Windows', bin],
    ).locate();
    expect(paths.ytDlp, '$bin\\yt-dlp.exe');
    expect(paths.managed, isFalse);
    expect(paths.ffmpegDir, bin);
    expect(paths.deno, '$bin\\deno.exe');
  });

  test('PATH folders are read from the variable, quotes and blanks out', () {
    expect(
      EngineLocator.splitPath(r'C:\Windows;"C:\Program Files\x";;C:\bin\'),
      [r'C:\Windows', r'C:\Program Files\x', r'C:\bin'],
    );
  });

  test('the folders the fetcher installs into', () {
    final l = locator({});
    expect(l.folderFor(EnginePart.ytDlp), '$own\\yt-dlp');
    expect(l.folderFor(EnginePart.ffmpeg), '$own\\ffmpeg');
    expect(l.folderFor(EnginePart.deno), '$own\\deno');
  });
}
