import 'package:vh_core/vh_core.dart';

import 'background_status.dart';

/// **One check made while the app is closed**: what the followed channels
/// have that is new, and whether a new version is out. It only tells;
/// the clips download when the app opens and its own check finds them.
class BackgroundCheck {
  BackgroundCheck({
    required this.peek,
    required this.status,
    required this.notifyNews,
    required this.newVersion,
    required this.notifyUpdate,
    DateTime Function()? clock,
    this.onLog,
  }) : _clock = clock ?? DateTime.now;

  final ChannelPeek peek;
  final BackgroundStatusFile status;

  /// One notice for all of it, never one per clip.
  final Future<void> Function(List<ChannelNews> news) notifyNews;

  /// The version out and not yet installed or skipped; null for none, or
  /// where the user turned the update check off.
  final Future<String?> Function() newVersion;
  final Future<void> Function(String version) notifyUpdate;

  final void Function(String message)? onLog;
  final DateTime Function() _clock;

  /// An update is looked for no more than this often.
  static const updateEvery = Duration(days: 1);

  /// The clips it told of this time.
  Future<int> run() async {
    final now = _clock();
    var saved = await status.read();

    final told = saved.notified.toSet();
    final fresh = <ChannelNews>[];
    for (final channel in await peek.due(now)) {
      final ids = <String>[];
      final titles = <String>[];
      for (var i = 0; i < channel.ids.length; i++) {
        if (told.contains(channel.ids[i])) continue;
        ids.add(channel.ids[i]);
        titles.add(channel.titles[i]);
      }
      if (ids.isNotEmpty) {
        fresh.add((channel: channel.channel, ids: ids, titles: titles));
      }
    }
    final count = fresh.fold(0, (sum, c) => sum + c.ids.length);
    if (fresh.isNotEmpty) {
      await notifyNews(fresh);
      final all = [...saved.notified, for (final c in fresh) ...c.ids];
      saved = saved.copyWith(
        notified: all.length > BackgroundStatus.notifiedCap
            ? all.sublist(all.length - BackgroundStatus.notifiedCap)
            : all,
      );
    }

    final checked = saved.updateCheckedAt;
    if (checked == null || now.difference(checked) >= updateEvery) {
      saved = saved.copyWith(updateCheckedAt: now);
      try {
        final version = await newVersion();
        if (version != null && version != saved.updateNotified) {
          await notifyUpdate(version);
          saved = saved.copyWith(updateNotified: version);
        }
      } on Object catch (e) {
        onLog?.call('background update check failed: ${e.runtimeType}');
      }
    }

    await status.write(saved.copyWith(lastRun: now, lastNew: count));
    onLog?.call('background check: $count new');
    return count;
  }
}
