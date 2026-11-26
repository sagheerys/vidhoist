import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lets the shell answer whether the app may close when the user closes
/// it: the window holds the close back, but only the shell knows what is
/// still downloading and has a place to ask.
class CloseGuard {
  /// Set by the shell while it is up; false keeps the app open.
  Future<bool> Function()? ask;

  /// Asks the shell, or lets the close through when nothing is set (the
  /// window opened before the shell, or the shell already gone).
  Future<bool> mayClose() async => await ask?.call() ?? true;
}

/// The guard the window consults; main puts its own in.
final closeGuardProvider = Provider<CloseGuard>((ref) => CloseGuard());
