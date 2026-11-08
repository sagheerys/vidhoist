import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import 'engine_locator.dart';
import 'engine_pins.dart';

/// A response's length, when the server said, and its bytes.
typedef FetchBody = ({int? length, Stream<List<int>> bytes});

/// How far a fetch has come.
class FetchProgress {
  const FetchProgress(this.received, this.total);

  final int received;
  final int? total;

  /// 0 to 1; null while the size is unknown.
  double? get fraction => switch (total) {
    final t? when t > 0 => (received / t).clamp(0, 1).toDouble(),
    _ => null,
  };
}

enum FetchFailure {
  /// The download did not arrive.
  network,

  /// It arrived, but not as the release published it.
  corrupt,

  /// Windows could not unpack it.
  unpack,

  /// The older copy is in use (a download running) and cannot be replaced.
  inUse,
}

class EngineFetchException implements Exception {
  const EngineFetchException(this.reason, this.detail);

  final FetchFailure reason;
  final String detail;

  @override
  String toString() => 'EngineFetchException(${reason.name}): $detail';
}

/// Fetches a part of the engine into the app's own folder: the pinned
/// file, its SHA-256 checked before it is unpacked, and the older copy
/// replaced only once the new one is whole.
class EngineFetcher {
  EngineFetcher({
    required this.locator,
    Map<EnginePart, PinnedAsset>? pins,
    Future<FetchBody> Function(Uri url)? download,
    Future<void> Function(File archive, Directory into)? unpack,
    Directory? staging,
  }) : pins = pins ?? enginePins,
       _download = download ?? httpDownload,
       _unpack = unpack ?? tarUnpack,
       staging = staging ?? Directory('${locator.ownFolder}\\.staging');

  final EngineLocator locator;
  final Map<EnginePart, PinnedAsset> pins;
  final Future<FetchBody> Function(Uri url) _download;
  final Future<void> Function(File archive, Directory into) _unpack;

  /// Beside the engine folder, so the last step is a rename on one disk.
  final Directory staging;

  /// Fetches the pinned [part].
  Stream<FetchProgress> fetch(EnginePart part) => install(pins[part]!);

  /// Fetches [asset] and puts it in place; the stream ends once it is.
  Stream<FetchProgress> install(PinnedAsset asset) async* {
    await staging.create(recursive: true);
    final work = await staging.createTemp('${asset.part.name}-');
    try {
      final archive = File('${work.path}\\${asset.part.name}.zip');
      final FetchBody body;
      try {
        body = await _download(asset.url);
      } on Object catch (e) {
        throw EngineFetchException(FetchFailure.network, '$e');
      }
      Digest? digest;
      final hasher = sha256.startChunkedConversion(
        ChunkedConversionSink<Digest>.withCallback((d) => digest = d.single),
      );
      final sink = archive.openWrite();
      var received = 0;
      var shown = -1;
      try {
        await for (final chunk in body.bytes) {
          sink.add(chunk);
          hasher.add(chunk);
          received += chunk.length;
          final progress = FetchProgress(received, body.length);
          // One event per percent: a 115 MB file arrives in thousands of
          // chunks, and each event redraws the bar.
          final percent = ((progress.fraction ?? 0) * 100).floor();
          if (percent != shown || body.length == null) {
            shown = percent;
            yield progress;
          }
        }
      } on Object catch (e) {
        throw EngineFetchException(FetchFailure.network, '$e');
      } finally {
        await sink.close();
      }
      hasher.close();
      if (digest.toString() != asset.sha256) {
        throw EngineFetchException(
          FetchFailure.corrupt,
          '${asset.url.pathSegments.last}: sha256 $digest',
        );
      }
      final unpacked = await Directory('${work.path}\\unpacked').create();
      try {
        await _unpack(archive, unpacked);
      } on Object catch (e) {
        throw EngineFetchException(FetchFailure.unpack, '$e');
      }
      await _place(asset.part, unpacked, work);
    } finally {
      await work.delete(recursive: true);
    }
  }

  /// Builds the folder exactly as it will stand, then swaps it in.
  Future<void> _place(
    EnginePart part,
    Directory unpacked,
    Directory work,
  ) async {
    final Directory ready;
    if (part == EnginePart.ytDlp) {
      // The folder build is the executable and its `_internal` folder.
      ready = (await _find(unpacked, 'yt-dlp.exe')).parent;
    } else {
      ready = await Directory('${work.path}\\ready').create();
      final names = part == EnginePart.ffmpeg
          ? const ['ffmpeg.exe', 'ffprobe.exe']
          : const ['deno.exe'];
      for (final name in names) {
        await (await _find(unpacked, name)).rename('${ready.path}\\$name');
      }
    }
    final target = Directory(locator.folderFor(part));
    final old = Directory('${target.path}.old');
    try {
      if (await old.exists()) await old.delete(recursive: true);
      if (await target.exists()) await target.rename(old.path);
      await target.parent.create(recursive: true);
      await ready.rename(target.path);
    } on FileSystemException catch (e) {
      if (!await target.exists() && await old.exists()) {
        await old.rename(target.path);
      }
      throw EngineFetchException(FetchFailure.inUse, e.message);
    }
    if (await old.exists()) {
      try {
        await old.delete(recursive: true);
      } on FileSystemException {
        // Left for the next fetch to clear.
      }
    }
  }

  static Future<File> _find(Directory root, String name) async {
    await for (final entry in root.list(recursive: true)) {
      if (entry is File &&
          entry.uri.pathSegments.last.toLowerCase() == name.toLowerCase()) {
        return entry;
      }
    }
    throw EngineFetchException(FetchFailure.unpack, '$name not in the archive');
  }

  /// A plain GET that follows GitHub's redirect to its file host.
  static Future<FetchBody> httpDownload(Uri url) async {
    final client = HttpClient()..userAgent = 'VidHoist';
    final response = await (await client.getUrl(url)).close();
    if (response.statusCode != HttpStatus.ok) {
      client.close();
      throw HttpException('HTTP ${response.statusCode}', uri: url);
    }
    final length = response.contentLength;
    return (
      length: length < 0 ? null : length,
      bytes: response.transform(
        StreamTransformer<List<int>, List<int>>.fromHandlers(
          handleDone: (sink) {
            client.close();
            sink.close();
          },
        ),
      ),
    );
  }

  /// Windows' own tar, which reads zip files (Windows 10 1803 and later).
  static Future<void> tarUnpack(File archive, Directory into) async {
    final root = Platform.environment['SystemRoot'] ?? r'C:\Windows';
    final result = await Process.run('$root\\System32\\tar.exe', [
      '-xf',
      archive.path,
      '-C',
      into.path,
    ]);
    if (result.exitCode != 0) {
      throw ProcessException('tar', [], '${result.stderr}');
    }
  }
}
