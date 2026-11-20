import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

/// The two notices of a check made while the app is closed, each in a
/// channel of its own in Android's settings, so either can be turned off
/// without losing the other or the downloads' own.
class BackgroundNotices {
  BackgroundNotices(this.l, {FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final VhLocalizations l;
  final FlutterLocalNotificationsPlugin _plugin;

  static const newsChannelId = 'com.yasir.vidhoist.news';
  static const updatesChannelId = 'com.yasir.vidhoist.updates';

  /// One id each: a later check replaces its notice rather than stacking
  /// a second beside it. Clear of the downloads', which count from a
  /// task's hash, by being negative.
  static const newsId = -7401;
  static const updateId = -7402;

  /// The clips' names, at most this many, under the notice's first line.
  static const titlesShown = 5;

  Future<void> init() => _plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_stat_vidhoist'),
    ),
  );

  /// "3 new videos", the channels after it, and the first titles when
  /// opened out. No payload: a tap opens the app, whose own check
  /// downloads them a moment later.
  Future<void> news(List<ChannelNews> news) {
    final count = news.fold(0, (sum, c) => sum + c.ids.length);
    final body = l.newVideosBody(news.map((c) => c.channel).join(' · '));
    final titles = [
      for (final c in news)
        for (final t in c.titles)
          if (t.trim().isNotEmpty) t.trim(),
    ].take(titlesShown);
    return _plugin.show(
      id: newsId,
      title: l.newVideosNotice(count),
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          newsChannelId,
          l.noticeChannelNewVideos,
          importance: Importance.defaultImportance,
          styleInformation: BigTextStyleInformation(
            [body, ...titles].join('\n'),
          ),
        ),
      ),
    );
  }

  Future<void> update(String version) => _plugin.show(
    id: updateId,
    title: l.updateVersionAvailable(version),
    body: l.updateNoticeBody,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        updatesChannelId,
        l.noticeChannelUpdates,
        // Once a version, and nothing urgent about it: no sound.
        importance: Importance.low,
        priority: Priority.low,
      ),
    ),
  );
}
