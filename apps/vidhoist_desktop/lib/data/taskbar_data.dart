import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'downloads_data.dart';

/// What the taskbar button says of the downloads: how many are under way,
/// and how far they are together, or null while none has a known share
/// (all waiting), when the button shows a moving bar instead of a false 0%.
typedef TaskbarDownloads = ({int count, double? progress});

/// The downloads under way, as the downloads button counts them: a paused
/// one is not moving.
final taskbarDownloadsProvider = Provider<TaskbarDownloads>((ref) {
  final tasks = [
    for (final t in ref.watch(engineTasksProvider).valueOrNull ?? const [])
      if (isUnderWay(t)) t,
  ];
  final shares = [
    for (final t in tasks)
      if (t.hasKnownProgress) t.progress,
  ];
  return (
    count: tasks.length,
    progress: shares.isEmpty
        ? null
        : shares.reduce((a, b) => a + b) / shares.length,
  );
});

/// The taskbar button, as the app tells it things; Windows' own in main,
/// nothing in tests.
abstract class TaskbarPort {
  Future<void> showDownloads(TaskbarDownloads downloads);
}

class NoTaskbar implements TaskbarPort {
  const NoTaskbar();

  @override
  Future<void> showDownloads(TaskbarDownloads downloads) async {}
}

final taskbarPortProvider = Provider<TaskbarPort>((ref) => const NoTaskbar());

/// Keeps the taskbar button in step with the downloads, for the life of
/// the shell.
final taskbarDownloadsWiringProvider = Provider<void>((ref) {
  ref.listen(
    taskbarDownloadsProvider,
    (_, downloads) => ref.read(taskbarPortProvider).showDownloads(downloads),
    fireImmediately: true,
  );
});
