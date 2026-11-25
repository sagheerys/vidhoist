import '../constants/vh_constants.dart';
import '../storage/key_value_store.dart';

/// **When to ask for a star on GitHub**, once a user has seen the app work:
/// after the third download that finished, and at most twice.
///
/// "Maybe later" brings the question back once, after [_again] more
/// finished downloads and [_wait] at least, so that someone who downloads
/// a lot in a day is not asked twice in a week; a star, "Don't show this again" or a second showing
/// ends it. Nothing leaves the device: the count is kept beside the
/// settings and read only here.
class StarAsk {
  StarAsk(this.store, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final KeyValueStore store;
  final DateTime Function() _now;

  static const String _countKey = 'star_ask_finished';
  static const String _shownKey = 'star_ask_shown';
  static const String _atKey = 'star_ask_shown_at';
  static const String _onKey = 'star_ask_shown_on';
  static const String _doneKey = 'star_ask_done';

  /// Finished downloads before the first question.
  static const int first = 3;

  /// Finished downloads after "Maybe later" before the second.
  static const int _again = 20;

  /// Time after "Maybe later" before the second, whatever the count.
  static const Duration _wait = Duration(days: 30);

  /// The repository's page, where the star is.
  static const String repoUrl = 'https://github.com/${VhConstants.updateRepo}';

  /// Where an idea or a problem is written: GitHub's choice of form.
  static const String ideasUrl = '$repoUrl/issues/new/choose';

  /// Counts one more download that finished.
  Future<void> countFinished() async {
    final count = await store.getInt(_countKey) ?? 0;
    await store.setInt(_countKey, count + 1);
  }

  /// Whether the question is due now.
  Future<bool> isDue() async {
    if (await store.getBool(_doneKey) ?? false) return false;
    final count = await store.getInt(_countKey) ?? 0;
    final shown = await store.getInt(_shownKey) ?? 0;
    return switch (shown) {
      0 => count >= first,
      1 =>
        count >= (await store.getInt(_atKey) ?? 0) + _again &&
            !_now().isBefore(
              DateTime.fromMillisecondsSinceEpoch(
                await store.getInt(_onKey) ?? 0,
              ).add(_wait),
            ),
      _ => false,
    };
  }

  /// Notes that the question was put, so that it is not put again on the
  /// next look at the library.
  Future<void> shown() async {
    final shown = await store.getInt(_shownKey) ?? 0;
    await store.setInt(_shownKey, shown + 1);
    await store.setInt(_atKey, await store.getInt(_countKey) ?? 0);
    await store.setInt(_onKey, _now().millisecondsSinceEpoch);
  }

  /// A star given, or "Don't show this again": never asked again.
  Future<void> end() => store.setBool(_doneKey, true);
}
