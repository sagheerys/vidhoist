import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';

/// A button on a Windows notification.
typedef NoticeAction = ({String label, void Function() onPressed});

/// A Windows notification, as the app asks for one.
class EmberNotice {
  const EmberNotice({
    required this.title,
    required this.body,
    this.actions = const [],
    this.onClick,
  });

  final String title;
  final String body;
  final List<NoticeAction> actions;
  final void Function()? onClick;
}

/// Where notices go: Windows' own in main, nowhere in tests.
abstract class NoticePort {
  Future<void> show(EmberNotice notice);
}

class NoNotices implements NoticePort {
  const NoNotices();

  @override
  Future<void> show(EmberNotice notice) async {}
}

final noticePortProvider = Provider<NoticePort>((ref) => const NoNotices());

/// Whether the window is in front, where the downloads panel already says
/// what a notice would; main asks Windows.
final windowInFrontProvider = Provider<Future<bool> Function()>(
  (ref) =>
      () async => false,
);

/// Brings the window back from the tray or from behind, for a notice's
/// click; main puts Windows' in.
final bringWindowBackProvider = Provider<Future<void> Function()>(
  (ref) => () async {},
);

/// The tasks that reached an end since [before] (their phases by id), in
/// the order of [now]. A task first seen already ended is not news: it
/// ended before this run was watching.
List<DownloadTask> newlyEnded(
  Map<String, TaskPhase> before,
  List<DownloadTask> now,
) => [
  for (final task in now)
    if ((task.phase == TaskPhase.completed || task.phase == TaskPhase.failed) &&
        before.containsKey(task.id) &&
        before[task.id] != task.phase)
      task,
];
