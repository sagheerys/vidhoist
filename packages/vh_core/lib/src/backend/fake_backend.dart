import 'dart:async';
import 'dart:convert';

import 'package:vh_ytdlp/vh_ytdlp.dart';

import 'download_backend.dart';

/// A [DownloadBackend] for tests: no process, every answer scripted.
///
/// By default a probe answers with a title made from the link, and a
/// download reports half, then the whole, then finishes at
/// `<folder>/<task id>.mp4`. [scripts] replaces that per link; [hold]
/// keeps every download open after its first event until [release] or
/// [cancel], so a test can act while a download is running.
class FakeBackend implements DownloadBackend {
  FakeBackend({Map<String, FakeScript>? scripts, this.hold = false})
    : scripts = scripts ?? {};

  final Map<String, FakeScript> scripts;
  bool hold;

  /// Every probe and download asked for, in order.
  final List<String> probes = [];
  final List<DownloadRequest> requests = [];

  /// The task ids [cancel] was called with.
  final List<String> cancelled = [];

  final Map<String, Completer<void>> _held = {};

  /// Lets a held download of [taskId] go on.
  void release(String taskId) => _held.remove(taskId)?.complete();

  /// Whether a download of [taskId] is waiting to be released.
  bool isHeld(String taskId) => _held.containsKey(taskId);

  @override
  Future<ProbeResult> probe(String url) async {
    probes.add(url);
    final script = scripts[url];
    if (script?.probeError case final error?) throw error;
    final info =
        script?.info ??
        {
          'id': 'id-${probes.length}',
          'title': 'Title of $url',
          'webpage_url': url,
        };
    return ProbeResult(
      InfoJson.parse(jsonEncode(info)),
      infoJsonPath: (script?.keepsInfoJson ?? true) ? '$url.info.json' : null,
    );
  }

  /// What [list] answers, by link: the listing as yt-dlp prints it, or
  /// the error it throws. A link with neither lists nothing.
  final Map<String, Object> listings = {};

  /// Every link [list] was asked for, in order.
  final List<String> listed = [];

  @override
  Future<InfoJson> list(String url, {int? limit}) async {
    listed.add(url);
    final answer = listings[url];
    if (answer is Exception) throw answer;
    if (answer is Error) throw answer;
    final raw = answer is Map<String, Object?>
        ? answer
        : <String, Object?>{'_type': 'playlist', 'entries': const []};
    final entries = raw['entries'];
    return InfoJson.fromMap({
      ...raw,
      if (limit != null && entries is List && entries.length > limit)
        'entries': entries.take(limit).toList(),
    });
  }

  @override
  Stream<BackendEvent> download(DownloadRequest request) async* {
    requests.add(request);
    final script = scripts[request.url];
    final events =
        script?.events?.call(request) ??
        [
          const BackendProgress(
            DownloadProgress(fraction: 0.5, downloadedBytes: 50, part: 1),
          ),
          const BackendProgress(
            DownloadProgress(fraction: 1, downloadedBytes: 100, part: 1),
          ),
          BackendFinished('${request.folder}/${request.taskId}.mp4'),
        ];
    for (var i = 0; i < events.length; i++) {
      if (cancelled.contains(request.taskId)) return;
      yield events[i];
      if (i == 0 && hold) {
        final gate = _held[request.taskId] = Completer<void>();
        await gate.future;
        if (cancelled.contains(request.taskId)) return;
      }
    }
  }

  @override
  Future<void> cancel(String taskId) async {
    cancelled.add(taskId);
    release(taskId);
  }

  /// What [version] answers.
  BackendVersion currentVersion = BackendVersion(
    ytDlp: EngineVersion.tryParse('2026.10.26'),
  );

  @override
  Future<BackendVersion> version() async => currentVersion;

  /// How many times [updateEngine] was called.
  int updates = 0;

  /// What [updateEngine] answers; null means "already current".
  UpdateOutcome? updateOutcome;

  @override
  Future<UpdateOutcome> updateEngine({
    EngineChannel channel = EngineChannel.stable,
  }) async {
    updates++;
    return updateOutcome ??
        UpdateOutcome(updated: false, version: currentVersion.ytDlp);
  }

  /// How many times [repairEngine] was called.
  int repairs = 0;

  /// What [repairEngine] answers; null means a clean, current copy.
  UpdateOutcome? repairOutcome;

  @override
  Future<UpdateOutcome> repairEngine() async {
    repairs++;
    return repairOutcome ??
        UpdateOutcome(updated: true, version: currentVersion.ytDlp);
  }
}

/// How [FakeBackend] answers for one link.
class FakeScript {
  const FakeScript({
    this.info,
    this.probeError,
    this.events,
    this.keepsInfoJson,
  });

  /// The info JSON the probe returns.
  final Map<String, Object?>? info;

  /// Thrown by the probe instead.
  final Object? probeError;

  /// What a download of this link reports, given its request (a retry at
  /// another quality can answer differently).
  final List<BackendEvent> Function(DownloadRequest request)? events;

  /// False for a backend that keeps no info JSON.
  final bool? keepsInfoJson;
}
