import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../pc/pc_destination.dart';
import '../pc/pc_link_state.dart';
import '../pc/pc_outbox.dart';
import '../pc/pc_pairing_store.dart';
import '../pc/pc_send.dart';
import 'add_flow.dart';

/// The quality name as the user sees it: what was **actually applied**
/// rather than what was chosen.
String qualityLabel(VhLocalizations l10n, Quality quality) => switch (quality) {
  Quality.best => l10n.qualityBest,
  Quality.q1080 => l10n.quality1080,
  Quality.q720 => l10n.quality720,
  Quality.q480 => l10n.quality480,
  Quality.q360 => l10n.quality360,
  Quality.audio => l10n.audioOnly,
};

/// **Quick download**: the link downloads immediately at the default
/// quality with no sheet.
///
/// Three deliberate decisions:
/// 1. **Playlists are never downloaded silently**, whatever the setting. A
/// playlist URL opens the batch screen so the user decides; 200 clips do
/// not start on a blind tap.
/// 2. **The quality shown is the quality applied**: `Quality.applyRule`
/// forces numeric qualities to `best` outside YouTube (a yt-dlp
/// constraint), so showing "1080" for a TikTok link lies to the user. We
/// show exactly what went to the engine.
/// 3. **An undo, not a confirmation**: a confirmation dialog defeats the
/// meaning of "quick". Instead there is an action in the snack bar that
/// cancels the task and opens the sheet with the same URL.
///
/// **The setting is gated here rather than at the call site**: quick
/// download looked always on even when turned off. The condition used to be written into the share path alone,
/// while the floating add button and the launcher shortcut downloaded
/// immediately without asking, so the setting looked to have no effect.
/// Gating inside the function makes forgetting it impossible.
///
/// [explicit] is for an unambiguous deliberate action, the "download now"
/// button in the clipboard bar with "choose options" beside it, and that
/// works whatever the setting says.
///
/// Returns `false` when it cannot proceed (setting off, a playlist, no
/// engine yet), and the caller takes over with the sheet.
bool startQuickDownload(
  BuildContext context,
  WidgetRef ref,
  String url, {
  bool announce = true,
  bool explicit = false,
}) {
  if (PlaylistDetector.isPlaylist(url)) return false;
  if (!explicit && !ref.read(settingsProvider).quickDownload) return false;
  if (wantsPc(ref)) {
    unawaited(_quickToPc(context, ref, url));
    return true;
  }
  final engine = ref.read(downloadEngineProvider);
  if (engine == null) return false;

  final l10n = context.vhl;
  final messenger = ScaffoldMessenger.of(context);
  final chosen = ref.read(settingsProvider).quality;
  final effective = chosen.applyRule(url);
  final task = engine.submit(url, chosen);
  if (!announce) return true;

  showVhSnackOn(
    messenger,
    l10n.downloadStartedQuality(qualityLabel(l10n, effective)),
    type: VhSnackType.success,
    themeContext: context,
    actionLabel: l10n.changeQuality,
    onAction: () {
      engine.cancel(task.id);
      if (context.mounted) openAddSheet(context, ref, initialUrl: url);
    },
  );
  return true;
}

/// **The last link went to the computer, so this one does too** (asked
/// 2026-11-10): at the default quality, with an undo that takes it back
/// from the computer and opens the sheet on the same link. Away, it waits
/// on this phone like a link from the sheet.
Future<void> _quickToPc(BuildContext context, WidgetRef ref, String url) async {
  final l10n = context.vhl;
  final messenger = ScaffoldMessenger.of(context);
  final view = ref.read(pcViewProvider.notifier);
  final name = ref.read(pcPairingProvider)?.name ?? '';
  final result = await sendLinksToPc(
    view: view,
    outbox: ref.read(pcOutboxProvider.notifier),
    urls: [url],
    quality: ref.read(settingsProvider).quality.wire,
  );
  final task = result.tasks.firstOrNull;
  showPcSendResult(
    messenger,
    l10n,
    result,
    name,
    actionLabel: task == null ? null : l10n.undo,
    onAction: task == null
        ? null
        : () {
            unawaited(view.cancel(task.id));
            if (context.mounted) openAddSheet(context, ref, initialUrl: url);
          },
  );
}
