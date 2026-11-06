import 'package:mt_ytdlp/mt_ytdlp.dart';

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
Stream<BackendEvent> readDownloadRun(
  Stream<String> stdoutLines,
  Future<RunExit> exit,
) async* {
  final tracker = ProgressTracker();
  String? path;
  await for (final raw in stdoutLines) {
    switch (YtDlpLine.parse(raw)) {
      case PartsLine parts:
        tracker.expectParts(parts);
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
