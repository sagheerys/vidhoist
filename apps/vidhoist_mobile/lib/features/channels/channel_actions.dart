import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';

import '../shared/error_text.dart';
import '../shared/open_web_link.dart';
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
  final l10n = context.mtl;
  final chosen = await showMTSheet<_Action>(
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
      showMTNotice(
        context,
        message: errorText(l10n, e),
        kind: MTNoticeKind.failed,
      );
    }
  }
}

class _ChannelSheet extends StatelessWidget {
  const _ChannelSheet({required this.sub});

  final ChannelSubscription sub;

  static const _avatar = 72.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.mtl;
    final p = MTThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    void pick(_Action a) => Navigator.of(context).pop(a);
    final banner = sub.bannerUrl;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        MTSpace.pagePad,
        0,
        MTSpace.pagePad,
        MTSpace.lg,
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
                borderRadius: BorderRadius.circular(MTRadius.card),
                child: AspectRatio(
                  aspectRatio: 4,
                  child: banner == null
                      ? ColoredBox(color: p.accentSoft)
                      : CachedNetworkImage(
                          imageUrl: banner,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) =>
                              ColoredBox(color: p.accentSoft),
                        ),
                ),
              ),
              PositionedDirectional(
                start: MTSpace.lg,
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
          const SizedBox(height: _avatar / 2 + MTSpace.sm),
          Text(
            mtName(sub.name),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            channelMeta(context, sub),
            style: text.bodySmall?.copyWith(color: p.ink3),
          ),
          const SizedBox(height: MTSpace.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(MTRadius.thumb),
            child: ChannelStatus(sub: sub),
          ),
          const SizedBox(height: MTSpace.lg),
          Row(
            children: [
              _Button(
                icon: MTIcons.refresh,
                label: l10n.checkNow,
                onTap: () => pick(_Action.check),
              ),
              const SizedBox(width: MTSpace.sm),
              sub.enabled
                  ? _Button(
                      icon: MTIcons.pause,
                      label: l10n.pauseSubscription,
                      onTap: () => pick(_Action.pause),
                    )
                  : _Button(
                      icon: MTIcons.play,
                      label: l10n.resumeSubscription,
                      onTap: () => pick(_Action.pause),
                    ),
              const SizedBox(width: MTSpace.sm),
              _Button(
                icon: MTIcons.edit,
                label: l10n.editSubscription,
                onTap: () => pick(_Action.edit),
              ),
            ],
          ),
          const SizedBox(height: MTSpace.sm),
          // The channel's own page, on YouTube or wherever it lives.
          OutlinedButton.icon(
            onPressed: () => unawaited(openWebLink(sub.url)),
            icon: MTIcon(MTIcons.external, size: 18, color: p.accent),
            label: Text(l10n.openChannel),
          ),
          const SizedBox(height: MTSpace.xs),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: p.err),
            onPressed: () => pick(_Action.unfollow),
            icon: MTIcon(MTIcons.trash, size: 18, color: p.err),
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

  final MTIconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = MTThemeX.of(context).palette;
    return Expanded(
      child: MTPressable(
        child: Material(
          color: p.cardAlt,
          borderRadius: BorderRadius.circular(MTRadius.card),
          child: InkWell(
            borderRadius: BorderRadius.circular(MTRadius.card),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: MTSpace.md,
                horizontal: MTSpace.xs,
              ),
              child: Column(
                children: [
                  MTIcon(icon, size: 22, color: p.accent),
                  const SizedBox(height: MTSpace.xs),
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
