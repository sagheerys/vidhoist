import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vh_ui/vh_ui.dart' show VhPalette;

/// A button on a download's notification: its id comes back to the app.
typedef NoticeAction = ({String id, String label});

/// Download notifications: progress while downloading, completion whose tap
/// opens the app and highlights the item, and errors. A silent channel for
/// progress and another for the result, so the phone does not ring at every
/// percentage.
class DownloadNotifications {
  DownloadNotifications({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const progressChannelId = 'com.yasir.vidhoist.progress';
  static const resultChannelId = 'com.yasir.vidhoist.result';

  final FlutterLocalNotificationsPlugin _plugin;

  /// What a progress notification carries, so its buttons know their task.
  static const _taskPrefix = 'task:';

  /// Called once at startup. [onOpenItem] carries the completed item's key
  /// for the app to show; [onTaskAction] a button pressed on a download's
  /// notification, with its task.
  Future<void> init({
    void Function(String itemKey)? onOpenItem,
    void Function(String action, String taskId)? onTaskAction,
  }) async {
    void answer(NotificationResponse response) {
      final payload = response.payload;
      if (payload == null || payload.isEmpty) return;
      if (payload.startsWith(_taskPrefix)) {
        final action = response.actionId;
        if (action != null) {
          onTaskAction?.call(action, payload.substring(_taskPrefix.length));
        }
        return;
      }
      onOpenItem?.call(payload);
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        // The status bar draws this icon from its alpha alone: a white
        // silhouette, like every other app's, not the coloured launcher
        // icon.
        android: AndroidInitializationSettings('@drawable/ic_stat_vidhoist'),
      ),
      onDidReceiveNotificationResponse: answer,
    );
    // **A tap that started the app** never reaches the callback above,
    // which only hears taps while the app runs: the app used to open on
    // its first screen as if the notification had not been tapped.
    final launch = await _plugin.getNotificationAppLaunchDetails();
    final response = launch?.notificationResponse;
    if ((launch?.didNotificationLaunchApp ?? false) && response != null) {
      answer(response);
    }
  }

  /// Android 13+ requires an explicit permission; a refusal fails nothing.
  Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  /// [percent] of null means an **indeterminate** bar, for a phase with no
  /// percentage: waiting in the queue, yt-dlp reading the link, ffmpeg
  /// merging the streams.
  /// The secondary text [body] says exactly where we are: "preparing" is
  /// not "downloading".
  Future<void> showProgress(
    int id, {
    required String title,
    required String channelName,
    required int? percent,
    String? body,
    String? taskId,
    List<NoticeAction> buttons = const [],
  }) => _plugin.show(
    id: id,
    title: title,
    body: body,
    payload: taskId == null ? null : '$_taskPrefix$taskId',
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        progressChannelId,
        channelName,
        importance: Importance.low,
        priority: Priority.low,
        onlyAlertOnce: true,
        showProgress: true,
        indeterminate: percent == null,
        maxProgress: 100,
        progress: (percent ?? 0).clamp(0, 100),
        ongoing: true,
        playSound: false,
        // Pause and resume without opening the app: the engine lives in
        // the same process while the foreground service holds it.
        actions: [
          for (final b in buttons)
            AndroidNotificationAction(b.id, b.label, cancelNotification: false),
        ],
      ),
    ),
  );

  Future<void> showResult(
    int id, {
    required String title,
    required String body,
    required String channelName,
    String? payload,
    bool isError = false,
  }) => _plugin.show(
    id: id,
    title: title,
    body: body,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        resultChannelId,
        channelName,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        color: isError ? VhPalette.notificationError : null,
      ),
    ),
    payload: payload,
  );

  Future<void> cancel(int id) => _plugin.cancel(id: id);
}
