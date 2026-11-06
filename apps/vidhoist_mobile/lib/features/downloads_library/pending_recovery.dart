import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di.dart';

/// **Going on, at launch, with what the last run left unfinished.**
///
/// A download stops with the app: killed from the recents list, stopped by
/// the battery manager, or the phone restarted. The engine wrote each one
/// down ([LocalPendingStore]), and here they are queued again; yt-dlp
/// continues each from its partial file. A paused one comes back paused.
///
/// **Silent by design.** Whoever opens the app is not shown a report: the
/// cards simply reappear and the diagnostic log says what happened.
final pendingRecoveryProvider = Provider<Future<void> Function()>(
  (ref) =>
      () => _recover(ref),
);

Future<void> _recover(Ref ref) async {
  final engine = ref.read(downloadEngineProvider);
  if (engine == null) return;
  final restored = await engine.restorePending();
  if (restored == 0) return;
  unawaited(
    ref
        .read(loggerProvider)
        .log('restored $restored unfinished downloads', tag: 'pending'),
  );
}
