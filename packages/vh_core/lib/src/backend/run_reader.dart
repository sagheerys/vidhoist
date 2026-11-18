import 'dart:io';

import 'package:vh_ytdlp/vh_ytdlp.dart';

import 'download_backend.dart';

/// The end of a yt-dlp run: its exit code and everything it wrote on
/// stderr.
typedef RunExit = ({int exitCode, String stderr});

/// Turns a download run's stdout, read line by line, and its exit into
/// [BackendEvent]s: the part both backends share, so each only starts the
/// process its own way and hands the lines over.
///
/// A run that exits 0 without naming its file has failed: the app has
/// nothing to record or to open.
///
/// A stretch [clip] long moves by ffmpeg's progress: yt-dlp says nothing
/// of it but `finished`, and the sizes it announces are the whole video's.
Stream<BackendEvent> readDownloadRun(
  Stream<String> stdoutLines,
  Future<RunExit> exit, {
  Duration? clip,
}) async* {
  final tracker = ProgressTracker();
  final stretch = clip == null ? null : ClipProgress(clip);
  String? path;
  await for (final raw in stdoutLines) {
    switch (YtDlpLine.parse(raw)) {
      case FfmpegLine line:
        if (stretch?.add(line) case final progress?) {
          yield BackendProgress(progress);
        }
      case PartsLine _ when stretch != null:
        break;
      case ProgressLine line when stretch != null:
        if (line.isFinished) yield BackendProgress(stretch.finished());
      case PartsLine parts:
        tracker.expectParts(parts);
      // Subtitles come first and are not among the announced parts.
      case ProgressLine(isSideFile: true):
        break;
      case ProgressLine line:
        yield BackendProgress(tracker.add(line));
      case PostprocessLine(status: 'started', :final postprocessor):
        yield BackendPostprocessing(postprocessor);
      case FileLine(path: final file):
        path = file;
      case PostprocessLine() || OtherLine():
        break;
    }
  }
  final end = await exit;
  if (end.exitCode != 0) {
    yield BackendFailed(ErrorClassifier.classify(end.stderr));
  } else if (path case final file? when stretch?.pastEnd ?? false) {
    // A few broken seconds, not the stretch: kept, it would sit in the
    // library as if it were.
    await _discard(file);
    yield BackendFailed(
      YtDlpError(
        YtDlpErrorKind.clipPastEnd,
        'the stretch starts after the video ends',
        length: ClipProgress.inputLength(end.stderr),
      ),
    );
  } else if (path case final file?) {
    yield BackendFinished(file);
  } else {
    yield BackendFailed(
      YtDlpError(
        YtDlpErrorKind.failed,
        'yt-dlp finished without naming a file\n${end.stderr}'.trim(),
      ),
    );
  }
}

Future<void> _discard(String path) async {
  try {
    await File(path).delete();
  } on FileSystemException {
    // Already gone.
  }
}
