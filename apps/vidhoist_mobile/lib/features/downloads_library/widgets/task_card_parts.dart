import 'package:flutter/widgets.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';

import '../../home/add_flow.dart' show taskErrorText;
import '../artwork_view.dart';

/// The cover of a running download, as soon as the probe gives one; the
/// card falls back to its icon until then.
Widget? taskThumbnail(DownloadTask task) =>
    artworkFor(task.thumbnail, decodeWidth: 150);

/// The speed while bytes arrive, and nothing in any other phase.
String? taskSpeed(DownloadTask task) =>
    (task.phase == TaskPhase.downloading || task.phase == TaskPhase.polling) &&
        task.speed != null
    ? mtFormatTransferRate(task.speed!)
    : null;

/// What a card says a task is doing; the percentage is the card's own.
/// [waitingForWifi] is a pause "Wi-Fi only" made, not the person.
String taskStatusText(
  MTLocalizations l10n,
  DownloadTask task, {
  bool waitingForWifi = false,
}) => switch (task.phase) {
  TaskPhase.queued => l10n.queuedSection,
  TaskPhase.preparing => l10n.enginePreparing,
  TaskPhase.downloading => l10n.downloadingTitle,
  TaskPhase.postprocessing => l10n.enginePostprocessing,
  TaskPhase.paused when waitingForWifi => l10n.waitingForWifi,
  TaskPhase.paused => l10n.enginePaused,
  // The wait is the person's own setting, not a slow network.
  TaskPhase.waitingForNetwork => l10n.waitingForWifi,
  // The server engine's phases, until its layer is deleted (batch 6).
  TaskPhase.adding || TaskPhase.polling => l10n.onServerPhase,
  TaskPhase.pulling => l10n.pullingToDevice,
  TaskPhase.deleting => l10n.cleaningServer,
  TaskPhase.failed => taskErrorText(l10n, task),
  TaskPhase.cancelled => l10n.cancel,
  TaskPhase.completed => l10n.completed,
};

/// A notification's line: unlike a card, it carries the percentage in its
/// text, since a notification's bar alone cannot be read as a number.
String taskNotificationText(
  MTLocalizations l10n,
  DownloadTask task, {
  bool waitingForWifi = false,
}) {
  final percent = (task.progress * 100).toStringAsFixed(0);
  return switch (task.phase) {
    TaskPhase.downloading => l10n.engineDownloadingProgress(percent),
    TaskPhase.adding => l10n.addingToServer,
    TaskPhase.polling => l10n.onServerProgress(percent),
    TaskPhase.pulling => l10n.pullingToDeviceProgress(percent),
    _ => taskStatusText(l10n, task, waitingForWifi: waitingForWifi),
  };
}

/// Pause while a download runs or waits for Wi-Fi, resume once paused;
/// none for a task waiting its turn or already done.
MTDownloadCardAction? taskCardAction(
  MTLocalizations l10n,
  DownloadTask task,
  LocalDownloadEngine? engine,
) {
  if (engine == null) return null;
  return switch (task.phase) {
    TaskPhase.preparing ||
    TaskPhase.downloading ||
    TaskPhase.waitingForNetwork => MTDownloadCardAction(
      icon: MTIcons.pause,
      tooltip: l10n.pause,
      onTap: () => engine.pause(task.id),
    ),
    TaskPhase.paused => MTDownloadCardAction(
      icon: MTIcons.play,
      tooltip: l10n.engineResume,
      onTap: () => engine.resume(task.id),
    ),
    _ => null,
  };
}
