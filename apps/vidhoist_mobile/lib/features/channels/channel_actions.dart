import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../shared/error_text.dart';
import '../shared/open_web_link.dart';
import 'channel_art.dart';
import 'channel_avatar.dart';
import 'channel_card.dart';
import 'channels_state.dart';
import 'follow_sheet.dart';

enum _Action { check, pause, edit, unfollow }

/// One channel's own sheet, from its card: its banner and picture, what
/// it is set to, and what can be done to it, unfollowing kept apart.
Future<void> showChannelActions(
  BuildContext context,
  WidgetRef ref,
  ChannelSubscription sub,
) async {
  final l10n = context.vhl;
  final chosen = await showVhSheet<_Action>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheet) => _ChannelSheet(sub: sub),
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
      showVhNotice(
        context,
        message: errorText(l10n, e),
        kind: VhNoticeKind.failed,
      );
    }
  }
}

class _ChannelSheet extends ConsumerWidget {
  const _ChannelSheet({required this.sub});

  final ChannelSubscription sub;

  static const _avatar = 72.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    void pick(_Action a) => Navigator.of(context).pop(a);
    final banner = ref
        .watch(
          channelArtFileProvider(channelArtKey(sub, ChannelArtKind.banner)),
        )
        .valueOrNull;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        VhSpace.pagePad,
        0,
        VhSpace.pagePad,
        vhSheetBottomPad(context, VhSpace.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The banner, with the picture standing on its lower edge; a
          // channel without one gets the accent's wash instead.
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(VhRadius.card),
                child: AspectRatio(
                  aspectRatio: 4,
                  child: banner == null
                      ? ColoredBox(color: p.accentSoft)
                      : Image.file(
                          banner,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              ColoredBox(color: p.accentSoft),
                        ),
                ),
              ),
              PositionedDirectional(
                start: VhSpace.lg,
                bottom: -_avatar / 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: p.card, width: 3),
                  ),
                  child: ChannelAvatar(sub: sub, size: _avatar),
                ),
              ),
            ],
          ),
          const SizedBox(height: _avatar / 2 + VhSpace.sm),
          Text(
            vhName(sub.name),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            channelMeta(context, sub),
            style: text.bodySmall?.copyWith(color: p.ink3),
          ),
          const SizedBox(height: VhSpace.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(VhRadius.thumb),
            child: ChannelStatus(sub: sub, detail: true),
          ),
          const SizedBox(height: VhSpace.lg),
          Row(
            children: [
              _Button(
                icon: VhIcons.refresh,
                label: l10n.checkNow,
                onTap: () => pick(_Action.check),
              ),
              const SizedBox(width: VhSpace.sm),
              sub.enabled
                  ? _Button(
                      icon: VhIcons.pause,
                      label: l10n.pauseSubscription,
                      onTap: () => pick(_Action.pause),
                    )
                  : _Button(
                      icon: VhIcons.play,
                      label: l10n.resumeSubscription,
                      onTap: () => pick(_Action.pause),
                    ),
              const SizedBox(width: VhSpace.sm),
              _Button(
                icon: VhIcons.edit,
                label: l10n.editSubscription,
                onTap: () => pick(_Action.edit),
              ),
            ],
          ),
          const SizedBox(height: VhSpace.sm),
          // The channel's own page, on YouTube or wherever it lives.
          OutlinedButton.icon(
            onPressed: () => unawaited(openWebLink(sub.url)),
            icon: VhIcon(VhIcons.external, size: 18, color: p.accent),
            label: Text(l10n.openChannel),
          ),
          const SizedBox(height: VhSpace.xs),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: p.err),
            onPressed: () => pick(_Action.unfollow),
            icon: VhIcon(VhIcons.trash, size: 18, color: p.err),
            label: Text(l10n.unfollow),
          ),
        ],
      ),
    );
  }
}

/// One of the sheet's three actions: an icon over its name, the three
/// sharing the row equally in either language.
class _Button extends StatelessWidget {
  const _Button({required this.icon, required this.label, required this.onTap});

  final VhIconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return Expanded(
      child: VhPressable(
        child: Material(
          color: p.cardAlt,
          borderRadius: BorderRadius.circular(VhRadius.card),
          child: InkWell(
            borderRadius: BorderRadius.circular(VhRadius.card),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: VhSpace.md,
                horizontal: VhSpace.xs,
              ),
              child: Column(
                children: [
                  VhIcon(icon, size: 22, color: p.accent),
                  const SizedBox(height: VhSpace.xs),
                  Text(
                    label,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(color: p.ink),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Unfollowing forgets what was seen; pausing keeps it, so the dialog says
/// which is which.
Future<bool> _confirmUnfollow(
  BuildContext context,
  ChannelSubscription sub,
) async {
  final l10n = context.vhl;
  final yes = await showVhDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      title: Text(l10n.unfollowConfirm(vhName(sub.name))),
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
