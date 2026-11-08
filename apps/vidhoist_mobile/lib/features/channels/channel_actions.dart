import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';

import '../shared/error_text.dart';
import 'channels_state.dart';
import 'follow_sheet.dart';

enum _Action { check, pause, edit, unfollow }

/// What can be done to one channel, from its row.
Future<void> showChannelActions(
  BuildContext context,
  WidgetRef ref,
  ChannelSubscription sub,
) async {
  final l10n = context.mtl;
  final chosen = await showMTSheet<_Action>(
    context: context,
    showDragHandle: true,
    builder: (sheet) {
      ListTile row(_Action action, MTIconData icon, String label) => ListTile(
        leading: MTIcon(icon),
        title: Text(label),
        onTap: () => Navigator.of(sheet).pop(action),
      );
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: MTSpace.pagePad),
              child: Text(
                mtName(sub.name),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(sheet).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: MTSpace.sm),
            row(_Action.check, MTIcons.refresh, l10n.checkNow),
            sub.enabled
                ? row(_Action.pause, MTIcons.pause, l10n.pauseSubscription)
                : row(_Action.pause, MTIcons.play, l10n.resumeSubscription),
            row(_Action.edit, MTIcons.edit, l10n.editSubscription),
            row(_Action.unfollow, MTIcons.trash, l10n.unfollow),
          ],
        ),
      );
    },
  );
  if (chosen == null || !context.mounted) return;
  final controller = ref.read(channelsControllerProvider);
  try {
    switch (chosen) {
      case _Action.check:
        await controller.checkNow(only: sub);
      case _Action.pause:
        await controller.setEnabled(sub, !sub.enabled);
      case _Action.edit:
        await showFollowSheet(context, editing: sub);
      case _Action.unfollow:
        if (await _confirmUnfollow(context, sub)) {
          await controller.unfollow(sub);
        }
    }
  } on Object catch (e) {
    if (context.mounted) {
      showMTNotice(
        context,
        message: errorText(l10n, e),
        kind: MTNoticeKind.failed,
      );
    }
  }
}

/// Unfollowing forgets what was seen; pausing keeps it, so the dialog says
/// which is which.
Future<bool> _confirmUnfollow(
  BuildContext context,
  ChannelSubscription sub,
) async {
  final l10n = context.mtl;
  final yes = await showMTDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      title: Text(l10n.unfollowConfirm(mtName(sub.name))),
      content: Text(l10n.unfollowConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialog).pop(false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialog).pop(true),
          child: Text(l10n.unfollow),
        ),
      ],
    ),
  );
  return yes ?? false;
}
