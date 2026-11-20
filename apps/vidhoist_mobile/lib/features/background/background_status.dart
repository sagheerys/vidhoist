import 'dart:convert';
import 'dart:io';

/// **What the checks made while the app is closed remember**, in a file of
/// their own beside the log.
///
/// Not in the app's settings store: a check runs in an engine of its own,
/// and the app may open beside it. Each side would keep its own copy of
/// the settings in memory and write it back over the other's. The app only
/// reads this file, to say when the last check ran.
class BackgroundStatus {
  const BackgroundStatus({
    this.lastRun,
    this.lastNew = 0,
    this.notified = const [],
    this.updateCheckedAt,
    this.updateNotified,
  });

  /// When a check last ran to its end, and how many clips it told of.
  final DateTime? lastRun;
  final int lastNew;

  /// The clips already told of, so the next check, which still finds them
  /// until the app downloads them, does not tell of them again.
  final List<String> notified;

  /// The update is looked for once a day, and each version told of once.
  final DateTime? updateCheckedAt;
  final String? updateNotified;

  /// Enough for a few weeks of busy channels; the oldest go first.
  static const notifiedCap = 500;

  BackgroundStatus copyWith({
    DateTime? lastRun,
    int? lastNew,
    List<String>? notified,
    DateTime? updateCheckedAt,
    String? updateNotified,
  }) => BackgroundStatus(
    lastRun: lastRun ?? this.lastRun,
    lastNew: lastNew ?? this.lastNew,
    notified: notified ?? this.notified,
    updateCheckedAt: updateCheckedAt ?? this.updateCheckedAt,
    updateNotified: updateNotified ?? this.updateNotified,
  );

  Map<String, Object?> toJson() => {
    'last_run': lastRun?.toIso8601String(),
    'last_new': lastNew,
    'notified': notified,
    'update_checked_at': updateCheckedAt?.toIso8601String(),
    'update_notified': updateNotified,
  };

  /// Anything unreadable is a fresh start: at worst a clip is told of
  /// twice.
  static BackgroundStatus fromJson(Object? raw) {
    if (raw is! Map) return const BackgroundStatus();
    DateTime? at(Object? v) => v is String ? DateTime.tryParse(v) : null;
    return BackgroundStatus(
      lastRun: at(raw['last_run']),
      lastNew: raw['last_new'] is int ? raw['last_new'] as int : 0,
      notified: [
        if (raw['notified'] case final List ids)
          for (final id in ids)
            if (id is String) id,
      ],
      updateCheckedAt: at(raw['update_checked_at']),
      updateNotified: raw['update_notified'] is String
          ? raw['update_notified'] as String
          : null,
    );
  }
}

/// The status file. Only the check writes it.
class BackgroundStatusFile {
  const BackgroundStatusFile(this.path);

  final String path;

  Future<BackgroundStatus> read() async {
    try {
      final file = File(path);
      if (!file.existsSync()) return const BackgroundStatus();
      return BackgroundStatus.fromJson(jsonDecode(await file.readAsString()));
    } on Object {
      return const BackgroundStatus();
    }
  }

  /// Written whole to a side file and moved over the old one, so the app
  /// reading it meanwhile never meets half of it.
  Future<void> write(BackgroundStatus status) async {
    final side = File('$path.new');
    await side.parent.create(recursive: true);
    await side.writeAsString(jsonEncode(status.toJson()), flush: true);
    await side.rename(path);
  }
}
