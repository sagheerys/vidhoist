import 'dart:async';

/// **Asks the browser's jar, on a clock, whether the sign-in is there.**
///
/// A page load is not enough to hear it: X signs in inside one page that
/// never loads again, then moves on with the address alone, so a sign-in
/// screen that waited for a load stayed open on a blank page.
class SessionWatch {
  SessionWatch(this.check, {this.every = period});

  /// Often enough that the screen closes soon after the site lets the
  /// person in; each look is one call into Android's cookie jar.
  static const period = Duration(seconds: 2);

  final Future<void> Function() check;
  final Duration every;
  Timer? _timer;

  bool get watching => _timer != null;

  void start() => _timer ??= Timer.periodic(every, (_) => unawaited(check()));

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
