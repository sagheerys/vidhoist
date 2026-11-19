import 'package:uuid/uuid.dart';
import 'package:vh_ytdlp/vh_ytdlp.dart' show ClipRange, InfoJson;

import '../api/api_exceptions.dart';
import 'quality.dart';

const _uuid = Uuid();

/// The phases of a download task, as yt-dlp on the device goes through
/// them (`LocalDownloadEngine`): preparing, downloading, post-processing,
/// with [paused] keeping the partial file for later.
enum TaskPhase {
  queued,

  /// yt-dlp reads the link: title, formats, YouTube's challenge. No
  /// percentage yet, and on a phone it can take most of a minute.
  preparing,

  /// The file is arriving; [DownloadTask.progress] moves.
  downloading,

  /// ffmpeg merges the streams or converts the sound; quick, with no
  /// percentage of its own.
  postprocessing,

  /// Stopped by the person with the partial file kept; resuming continues
  /// from where it stopped.
  paused,

  /// **Held waiting for Wi-Fi** before it starts ("Wi-Fi only").
  ///
  /// A phase of its own, on purpose: progress does not move here, and the
  /// reason is not a slow network but the user's own choice. Showing it as
  /// "downloading 0%" is a lie that suggests the app has hung, and showing
  /// it as "failed" is another one.
  waitingForNetwork,
  completed,
  failed,
  cancelled,
}

/// A single download task, identified by a uuid v4 rather than the
/// fragile `url.hashCode`. Immutable; the download engine advances it
/// through [copyWith].
class DownloadTask {
  DownloadTask({
    String? id,
    required this.inputUrl,
    required this.quality,
    this.resolvedUrl,
    this.canonicalUrl,
    this.title,
    this.thumbnail,
    this.localPath,
    this.phase = TaskPhase.queued,
    this.progress = 0,
    this.speed,
    this.eta,
    this.error,
    this.isBatchMember = false,
    this.folder,
    this.clip,
    DateTime? createdAt,
  }) : id = id ?? _uuid.v4(),
       createdAt = createdAt ?? DateTime.now();

  final String id;

  /// As the user entered it, for display and for retrying.
  final String inputUrl;

  /// After the short link is resolved. This is what yt-dlp is given.
  final String? resolvedUrl;

  /// yt-dlp's `webpage_url`. The **only** value valid for indexing.
  final String? canonicalUrl;

  /// The title and artwork yt-dlp read. Used for the title and artwork
  /// indexes and the completion notification. **Neither is invented** when
  /// missing (`docs/ENGINE.md`, Storage).
  final String? title;
  final String? thumbnail;
  final String? localPath;
  final Quality quality;
  final TaskPhase phase;

  /// 0 to 1, across every part of a merged download.
  final double progress;

  /// The download speed in bytes per second while bytes arrive, or null
  /// when nothing is downloading (waiting, between streams, merging).
  final double? speed;

  /// Seconds left for the part being downloaded, when yt-dlp knows.
  final int? eta;

  /// The classified error on failure. The app turns its type into
  /// translated text.
  final VhApiException? error;

  /// A single item outranks members of a batch in the queue.
  final bool isBatchMember;

  /// The folder below the download folder asked for, or null for the top.
  /// Fixed for the task's life, so a retry saves where the first attempt
  /// was meant to.
  final String? folder;

  /// A stretch of the video alone; null for all of it. Fixed for the
  /// task's life, like [folder].
  final ClipRange? clip;
  final DateTime createdAt;

  /// **Does this phase have known progress?** A waiting task and one held
  /// by the network gate do not move, so showing "0%" over them is a lie
  /// that suggests a hang (the same reasoning as `waitingForNetwork`).
  ///
  /// A stretch is cut by ffmpeg, which may say nothing of how far it has
  /// come; until a figure arrives, it moves without one rather than sit at
  /// a "0%" that reads as stuck.
  bool get hasKnownProgress =>
      phase != TaskPhase.queued &&
      phase != TaskPhase.waitingForNetwork &&
      phase != TaskPhase.preparing &&
      !(clip != null && phase == TaskPhase.downloading && progress == 0);

  bool get isFinished =>
      phase == TaskPhase.completed ||
      phase == TaskPhase.failed ||
      phase == TaskPhase.cancelled;

  String get effectiveUrl => resolvedUrl ?? inputUrl;

  DownloadTask copyWith({
    Quality? quality,
    String? resolvedUrl,
    String? canonicalUrl,
    String? title,
    String? thumbnail,
    String? localPath,
    TaskPhase? phase,
    double? progress,
    double? Function()? speed,
    int? Function()? eta,
    VhApiException? error,
    ClipRange? clip,
  }) => DownloadTask(
    id: id,
    inputUrl: inputUrl,
    quality: quality ?? this.quality,
    resolvedUrl: resolvedUrl ?? this.resolvedUrl,
    canonicalUrl: canonicalUrl ?? this.canonicalUrl,
    title: title ?? this.title,
    thumbnail: thumbnail ?? this.thumbnail,
    localPath: localPath ?? this.localPath,
    phase: phase ?? this.phase,
    progress: progress ?? this.progress,
    speed: speed == null ? this.speed : speed(),
    eta: eta == null ? this.eta : eta(),
    error: error ?? this.error,
    isBatchMember: isBatchMember,
    folder: folder,
    clip: clip ?? this.clip,
    createdAt: createdAt,
  );
}

/// The mean progress of a group of tasks (0 to 1), for the summary bar at
/// the top of the library when several downloads run at once
/// (2026-09-03).
///
/// Tasks with no known progress count as **zero rather than being
/// excluded**: excluding them made "3 downloads" show 90% because only one
/// was running and the rest were queued. An empty group, or one with no
/// progress at all, yields `null` for an indeterminate bar.
extension DownloadTaskProbe on DownloadTask {
  /// What yt-dlp read of the link. A stretch takes the whole video's
  /// link marked with its range as its key ([ClipRange.tagUrl]) and its
  /// range after the title, so the library holds it beside the whole
  /// video, never in its place.
  ///
  /// The stretch is fitted inside the length read ([ClipRange.within]):
  /// its end brought back to it, or [ClipPastEndException] when it starts
  /// at the end or past it. The add screen stops both once it knows the
  /// length; this catches a stretch asked before it did.
  DownloadTask withProbe(InfoJson info) {
    final length = info.duration;
    final asked = this.clip;
    final clip = asked == null || length == null
        ? asked
        : asked.within(length) ?? (throw ClipPastEndException(length));
    final url = info.webpageUrl;
    final title = info.title;
    return copyWith(
      title: clip == null || title == null ? title : '$title · ${clip.label}',
      thumbnail: info.thumbnail,
      canonicalUrl: clip == null || url == null ? url : clip.tagUrl(url),
      clip: clip,
    );
  }
}

double? averageTaskProgress(List<DownloadTask> tasks) {
  if (tasks.isEmpty) return null;
  if (!tasks.any((t) => t.hasKnownProgress)) return null;
  var sum = 0.0;
  for (final task in tasks) {
    if (task.hasKnownProgress) sum += task.progress.clamp(0, 1);
  }
  return sum / tasks.length;
}
