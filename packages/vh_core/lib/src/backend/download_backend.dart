import 'package:vh_ytdlp/vh_ytdlp.dart';

import '../models/quality.dart';

/// yt-dlp on this device, behind one interface for both apps.
///
/// Windows runs it as a process, Android through the youtubedl-android
/// library; each app supplies its own implementation, and the download
/// engine and every test see only this. [FakeBackend] stands in for it in
/// tests.
abstract interface class DownloadBackend {
  /// Reads what [url] offers without downloading it. The info JSON is kept
  /// at [ProbeResult.infoJsonPath] so the download that follows starts at
  /// once instead of reading the page again (`docs/ENGINE.md`, finding 19).
  Future<ProbeResult> probe(String url);

  /// Lists a channel or a playlist without reading each clip
  /// (`CommandBuilder.playlist`): its newest [limit] items, or all.
  Future<InfoJson> list(String url, {int? limit});

  /// Runs one download. The stream ends after one [BackendFinished] or
  /// [BackendFailed]; a download stopped by [cancel] ends without either.
  Stream<BackendEvent> download(DownloadRequest request);

  /// Stops the download of [taskId], with its process and every child.
  /// The partial file stays, so the same request continues from it.
  Future<void> cancel(String taskId);

  /// The versions in use, for the engine settings and the log.
  Future<BackendVersion> version();

  /// Updates yt-dlp itself; YouTube breaks old builds within months.
  Future<UpdateOutcome> updateEngine({
    EngineChannel channel = EngineChannel.stable,
  });
}

/// yt-dlp's release channels.
enum EngineChannel { stable, nightly }

/// A probe's result: the reading, and where its JSON was kept.
class ProbeResult {
  const ProbeResult(this.info, {this.infoJsonPath});

  final InfoJson info;

  /// Null when the backend did not keep the JSON; the download then reads
  /// the link again.
  final String? infoJsonPath;
}

/// One download as the engine asks for it.
class DownloadRequest {
  const DownloadRequest({
    required this.taskId,
    required this.url,
    required this.folder,
    this.quality = Quality.best,
    this.compatible = false,
    this.infoJsonPath,
    this.subtitleLanguages = const [],
    this.playlistItems,
  });

  /// The task this download belongs to, the key for [DownloadBackend.cancel].
  final String taskId;
  final String url;

  /// The folder the file is written to.
  final String folder;
  final Quality quality;

  /// H.264 and AAC, for players that cannot decode AV1 or VP9.
  final bool compatible;

  /// A probe's info JSON; when set, the download starts from it.
  final String? infoJsonPath;
  final List<String> subtitleLanguages;
  final List<int>? playlistItems;

  /// The quality in `vh_ytdlp`'s terms.
  FormatChoice get formatChoice => switch (quality) {
    Quality.best => FormatChoice.best,
    Quality.q1080 => FormatChoice.h1080,
    Quality.q720 => FormatChoice.h720,
    Quality.q480 => FormatChoice.h480,
    Quality.q360 => FormatChoice.h360,
    Quality.audio => FormatChoice.audio,
  };

  /// The download as `vh_ytdlp` builds its command line: from the probe's
  /// JSON when there is one, otherwise from the link.
  DownloadSpec toSpec({bool embedThumbnail = true}) => DownloadSpec(
    url: infoJsonPath == null ? url : null,
    infoJsonPath: infoJsonPath,
    folder: folder,
    choice: formatChoice,
    compatible: compatible,
    subtitleLanguages: subtitleLanguages,
    playlistItems: playlistItems,
    embedThumbnail: embedThumbnail,
  );

  DownloadRequest copyWith({
    Quality? quality,
    String? Function()? infoJsonPath,
  }) => DownloadRequest(
    taskId: taskId,
    url: url,
    folder: folder,
    quality: quality ?? this.quality,
    compatible: compatible,
    infoJsonPath: infoJsonPath == null ? this.infoJsonPath : infoJsonPath(),
    subtitleLanguages: subtitleLanguages,
    playlistItems: playlistItems,
  );
}

/// What a download reports while it runs.
sealed class BackendEvent {
  const BackendEvent();
}

/// Bytes are arriving.
final class BackendProgress extends BackendEvent {
  const BackendProgress(this.progress);

  final DownloadProgress progress;
}

/// ffmpeg is merging or converting: [postprocessor] is yt-dlp's name for
/// it, such as `Merger`.
final class BackendPostprocessing extends BackendEvent {
  const BackendPostprocessing(this.postprocessor);

  final String postprocessor;
}

/// The file is complete at [path], after any merge or conversion.
final class BackendFinished extends BackendEvent {
  const BackendFinished(this.path);

  final String path;
}

/// The run failed, classified from its error output.
final class BackendFailed extends BackendEvent {
  const BackendFailed(this.error);

  final YtDlpError error;
}

/// The versions of the engine's parts; null where a part is absent or did
/// not say.
class BackendVersion {
  const BackendVersion({this.ytDlp, this.ffmpeg, this.jsRuntime});

  final EngineVersion? ytDlp;
  final String? ffmpeg;

  /// Such as `quickjs` or `deno 2.9.8`.
  final String? jsRuntime;
}

/// How an engine update went.
class UpdateOutcome {
  const UpdateOutcome({required this.updated, this.version, this.error});

  /// False when it was already current, or when the update failed.
  final bool updated;
  final EngineVersion? version;

  /// Why it failed, for the log; null on success.
  final String? error;
}
