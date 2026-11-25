import 'dart:async';

import 'package:flutter/services.dart' show MethodChannel;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../background/background_notices.dart';
import '../downloads_library/item_reveal.dart';
import '../downloads_library/library_providers.dart';
import '../downloads_library/widgets/task_card_parts.dart';
import '../shared/error_text.dart';
import '../star/star_ask_prompt.dart';
import 'network_gate.dart';
import 'notifications.dart';

final notificationsProvider = Provider((ref) => DownloadNotifications());

/// Watches the engine's tasks and drives the notifications and the
/// background mode.
///
/// Background mode is enabled **only while tasks are active** and switched
/// off when they end: a permanent foreground service drains the battery and
/// angers Android.
final downloadWatcherProvider = Provider<void>((ref) {
  final notifications = ref.watch(notificationsProvider);
  final logger = ref.watch(loggerProvider);
  var backgroundOn = false;
  final notified = <String>{};

  /// **The fingerprint of the last notification posted per task**: a
  /// duplicate filter.
  ///
  /// The counter in the notification froze while the one in the app moved.
  /// [handle] walks **every** task
  /// on every broadcast, so seven parallel tasks meant seven posts for
  /// every change in any one of them, thousands of calls a minute on the
  /// platform channel. Android throttles excessive posting from a single
  /// app and what the user sees freezes. Here, nothing is posted unless its
  /// text or its percentage actually changed.
  final lastShown = <int, String>{};

  /// **Posting sequence**: `unawaited` on consecutive calls let an older
  /// one arrive after a newer one and put the percentage back.
  Future<void> chain = Future.value();

  VhLocalizations l10n() =>
      vhLocalizationsFor(ref.read(settingsProvider).localeCode);

  int idOf(DownloadTask task) => task.id.hashCode & 0x7fffffff;

  /// The engine's own foreground service (`EngineService.kt`), not
  /// flutter_background's: swiping the app away disposes the Flutter
  /// engine, and a service tied to it went too, taking the download with
  /// it (measured on the phone, 2026-11-06). This one lives in the
  /// process and also stays up while any yt-dlp run is going, whatever
  /// happens to Dart.
  Future<void> syncBackground(bool anyActive) async {
    if (anyActive == backgroundOn) return;
    backgroundOn = anyActive;
    try {
      final texts = l10n();
      await const MethodChannel('vidhoist/ytdlp').invokeMethod('keepAlive', {
        'on': anyActive,
        'title': texts.downloadingTitle,
        'text': texts.backgroundDownload,
      });
    } catch (e) {
      // A refused permission or a device that does not support it:
      // downloading continues as long as the app is open.
      backgroundOn = false;
      await logger.error('background mode failed', cause: e, tag: 'download');
    }
  }

  /// Posts a progress bar **if it changed** from what was last posted for
  /// this task.
  Future<void> showProgressIfChanged(
    int id, {
    required String title,
    required String channelName,
    required int? percent,
    required String body,
    String? taskId,
    List<NoticeAction> buttons = const [],
  }) async {
    final signature =
        '$title|$body|${percent ?? -1}|${buttons.map((b) => b.id).join()}';
    if (lastShown[id] == signature) return;
    lastShown[id] = signature;
    await notifications.showProgress(
      id,
      title: title,
      body: body,
      channelName: channelName,
      percent: percent,
      taskId: taskId,
      buttons: buttons,
    );
  }

  Future<void> handle(List<DownloadTask> tasks) async {
    final texts = l10n();
    for (final task in tasks) {
      final id = idOf(task);
      final wifiWait = ref.read(wifiPausedProvider).contains(task.id);
      switch (task.phase) {
        // A phase with no notification made
        // the app look idle, so every phase announces itself, in the
        // engine's own words. A phase with no known percentage gets an
        // indeterminate bar rather than a bar frozen at zero; the
        // percentage is in the text too, since a bar alone cannot be read
        // as a number.
        case TaskPhase.queued ||
            TaskPhase.preparing ||
            TaskPhase.downloading ||
            TaskPhase.postprocessing ||
            TaskPhase.paused ||
            TaskPhase.waitingForNetwork:
          await showProgressIfChanged(
            id,
            title: task.title ?? texts.downloadingTitle,
            body: taskNotificationText(texts, task, waitingForWifi: wifiWait),
            channelName: texts.activeDownloads,
            percent: _percentOf(task),
            taskId: task.id,
            buttons: [
              if (_pausable(task.phase)) (id: 'pause', label: texts.pause),
              if (task.phase == TaskPhase.paused)
                (id: 'resume', label: texts.engineResume),
            ],
          );
        case TaskPhase.completed:
          lastShown.remove(id);
          if (!notified.add(task.id)) break;
          unawaited(countFinishedDownload(ref));
          // **The peak moment**: the item arrives in the library with one
          // highlight that fades. Completion is the happiest moment in the
          // app and it used to pass with no celebration at all. It uses the
          // same mechanism as the notification-tap highlight: one path, not
          // two.
          final arrived = task.canonicalUrl ?? task.localPath;
          if (arrived != null) {
            ref.read(highlightedItemProvider.notifier).state = arrived;
          }
          await notifications.cancel(id);
          await notifications.showResult(
            id,
            title: texts.downloadCompleteTitle,
            body: task.title ?? task.effectiveUrl,
            channelName: texts.downloadComplete,
            // A notification tap highlights the item in the library.
            payload: task.canonicalUrl ?? task.localPath,
          );
        case TaskPhase.failed:
          lastShown.remove(id);
          if (!notified.add(task.id)) break;
          await notifications.cancel(id);
          await notifications.showResult(
            id,
            title: texts.downloadFailedTitle,
            body: task.error == null
                ? texts.failed
                : errorText(texts, task.error!),
            channelName: texts.downloadFailed,
            isError: true,
          );
        case TaskPhase.cancelled:
          lastShown.remove(id);
          await notifications.cancel(id);
      }
    }
    // A task can leave the list with no ending of its own: a rebuilt
    // engine forgets it. Its ongoing notice cannot be swiped away, so it
    // goes here.
    final listed = {for (final task in tasks) idOf(task)};
    for (final id in [...lastShown.keys.where((id) => !listed.contains(id))]) {
      lastShown.remove(id);
      await notifications.cancel(id);
    }
    // A download paused by hand needs no foreground service; one paused
    // for Wi-Fi does, to go on when Wi-Fi is back.
    final wifiPaused = ref.read(wifiPausedProvider);
    await syncBackground(
      tasks.any(
        (t) =>
            !t.isFinished &&
            (t.phase != TaskPhase.paused || wifiPaused.contains(t.id)),
      ),
    );
  }

  ref.listen<AsyncValue<List<DownloadTask>>>(engineTasksProvider, (_, next) {
    final tasks = next.valueOrNull ?? const <DownloadTask>[];
    chain = chain.then((_) => handle(tasks)).catchError((Object e) {
      unawaited(logger.error('notification failed', cause: e, tag: 'download'));
    });
  });
});

/// Initialises the notifications once and wires the completion tap to the
/// item highlight.
/// **It never lets a fault escape into the startup chain**: the platform
/// call throws in an environment with no channel,
/// and what follows it in `initState` has nothing to do with notifications.
Future<void> initDownloadNotifications(WidgetRef ref) async {
  final notifications = ref.read(notificationsProvider);
  try {
    await notifications.init(
      onOpenItem: (key) =>
          ref.read(itemRevealProvider.notifier).state = ItemReveal(key),
      onTaskAction: (action, taskId) {
        final engine = ref.read(downloadEngineProvider);
        if (action == 'pause') engine?.pause(taskId);
        if (action == 'resume') engine?.resume(taskId);
      },
    );
    await notifications.requestPermission();
    // What a check while closed told of: the app's own check is about to
    // download it.
    await notifications.cancel(BackgroundNotices.newsId);
  } on Object catch (e) {
    // The logging itself is defensive: the logger may not be injected in a
    // test environment.
    try {
      unawaited(
        ref
            .read(loggerProvider)
            .error('notifications init failed', cause: e, tag: 'download'),
      );
    } on Object {
      // An environment with no logger: only the notifications are missing
      // and downloading works.
    }
  }
}

/// The notification's bar: a percentage only where one is known.
int? _percentOf(DownloadTask task) => switch (task.phase) {
  TaskPhase.downloading ||
  TaskPhase.postprocessing ||
  TaskPhase.paused => (task.progress * 100).round(),
  _ => null,
};

bool _pausable(TaskPhase phase) =>
    phase == TaskPhase.preparing ||
    phase == TaskPhase.downloading ||
    phase == TaskPhase.waitingForNetwork;
