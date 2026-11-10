import 'package:flutter/material.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'pc_errors.dart';
import 'pc_link_state.dart';
import 'pc_outbox.dart';

/// What became of links sent to the computer: those it took ([tasks]),
/// those waiting on this phone for it, and why the rest did not go.
typedef PcSendResult = ({
  List<PcTask> tasks,
  int queued,
  int asked,
  PcLinkFailure? failure,
});

/// **Sends [urls] to the computer, in order**: the add sheet's one link,
/// the batch screen's selection, a quick download. The first that does not
/// reach it waits on this phone with all after it, as does everything when
/// it was [away] already; one it refuses is told and the next goes on;
/// any other failure (no longer paired) stops.
Future<PcSendResult> sendLinksToPc({
  required PcViewNotifier view,
  required PcOutbox outbox,
  required List<String> urls,
  required String quality,
  bool away = false,
}) async {
  final tasks = <PcTask>[];
  PcLinkFailure? failure;
  var next = 0;
  for (; next < urls.length && !away; next++) {
    try {
      tasks.add(await view.submit(urls[next], quality));
    } on PcLinkException catch (e) {
      if (e.failure == PcLinkFailure.unreachable) {
        away = true;
        break;
      }
      failure = e.failure;
      if (e.failure != PcLinkFailure.refused) {
        return (tasks: tasks, queued: 0, asked: urls.length, failure: failure);
      }
    }
  }
  final waiting = urls.sublist(next);
  if (away && waiting.isNotEmpty) await outbox.addAll(waiting, quality);
  return (
    tasks: tasks,
    queued: away ? waiting.length : 0,
    asked: urls.length,
    failure: failure,
  );
}

/// The word after sending to [name]: waiting, sent, or why not. [action]
/// goes with "sent" only, as the quick download's undo.
void showPcSendResult(
  ScaffoldMessengerState messenger,
  VhLocalizations l10n,
  PcSendResult result,
  String name, {
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final single = result.asked == 1;
  final sent = result.tasks.length;
  if (result.queued > 0) {
    showVhSnackOn(
      messenger,
      single ? l10n.pcQueued(name) : l10n.pcQueuedMany(result.queued, name),
    );
  } else if (sent > 0) {
    showVhSnackOn(
      messenger,
      single ? l10n.pcSent(name) : l10n.pcSentMany(sent, name),
      type: VhSnackType.success,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  } else if (result.failure case final failure?) {
    showVhSnackOn(
      messenger,
      pcFailureText(l10n, failure),
      type: VhSnackType.error,
    );
  }
}
