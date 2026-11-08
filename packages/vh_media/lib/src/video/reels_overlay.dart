import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import '../models/playlist_item.dart';
import '../screens/vh_video_screen.dart';
import '../widgets/media_time.dart';

/// The reels top bar: back, "shorts 3 / 14", and more.
class VhReelsTopBar extends StatelessWidget {
  const VhReelsTopBar({
    super.key,
    required this.position,
    required this.total,
    required this.onBack,
    this.onMore,
  });

  final int position;
  final int total;
  final VoidCallback onBack;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final ink = VhPalette.serverCardInk;
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          tooltip: l10n.dismiss,
          icon: VhIcon(VhIcons.chevronDown, color: ink),
        ),
        Expanded(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: VhSpace.md,
                vertical: VhSpace.xxs + 1,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(VhRadius.chip),
              ),
              child: Text(
                // The counter is isolated: "2 / 40" used to render as "40 /
                // 2".
                '⚡ ${l10n.shortsFilter}   ${vhLtrRun('$position / $total')}',
                style: Theme.of(context).textTheme.labelSmall!
                    .copyWith(color: ink, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        if (onMore != null)
          IconButton(
            onPressed: onMore,
            tooltip: l10n.details,
            icon: VhIcon(VhIcons.moreVert, color: ink),
          )
        else
          const SizedBox(width: 48),
      ],
    );
  }
}

/// The side action column, within thumb reach: details, add to, share.
///
/// **The favourite button is optional** (field report 2026-09-04): both
/// apps offer an "add to…" button instead, which gathers favourites, tags
/// and playlists in one place, so a separate heart repeated an action that
/// already existed. `onToggleFavorite = null` means no heart, and the
/// double tap on the clip stays as it was.
class VhReelsRail extends StatelessWidget {
  const VhReelsRail({
    super.key,
    this.favorite = false,
    this.onToggleFavorite,
    this.actions = const [],
  });

  final bool favorite;
  final VoidCallback? onToggleFavorite;
  final List<VhPlayerAction> actions;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l10n = context.vhl;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onToggleFavorite != null)
          _RailButton(
            icon: favorite ? VhIcons.favoriteOn : VhIcons.favorite,
            label: l10n.favorites,
            onTap: onToggleFavorite!,
            background: favorite ? p.favorite : null,
          ),
        for (final action in actions) ...[
          if (action != actions.first || onToggleFavorite != null)
            const SizedBox(height: VhSpace.lg),
          _RailButton(
            icon: action.icon,
            label: action.label,
            onTap: action.onTap,
            background: action.highlighted ? p.accent : null,
          ),
        ],
      ],
    );
  }
}

class _RailButton extends StatelessWidget {
  const _RailButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.background,
  });

  final VhIconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final ink = VhPalette.serverCardInk;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: background ?? Colors.black.withValues(alpha: 0.42),
          borderRadius: BorderRadius.circular(VhRadius.card),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(VhRadius.card),
            child: SizedBox(
              width: 46,
              height: 46,
              child: Center(
                child: VhIconSwap(icon: icon, size: 20, color: ink),
              ),
            ),
          ),
        ),
        const SizedBox(height: VhSpace.xxs),
        SizedBox(
          width: 62,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall!
                .copyWith(color: ink, fontSize: 9.5),
          ),
        ),
      ],
    );
  }
}

/// The information block at the bottom: the source and duration chip, the
/// title, the uploader.
class VhReelsInfo extends StatelessWidget {
  const VhReelsInfo({super.key, required this.item, this.subtitle});

  final PlaylistItem item;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final ink = VhPalette.serverCardInk;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.duration != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: VhSpace.sm,
              vertical: VhSpace.xxs,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(VhRadius.badge + 2),
            ),
            child: Text(
              vhFormatDuration(item.duration!),
              style: text.labelSmall!
                  .copyWith(color: ink, fontWeight: FontWeight.w700)
                  .tabular,
            ),
          ),
        const SizedBox(height: VhSpace.xs),
        VhForeignText(
          item.title,
          maxLines: 2,
          style: text.titleMedium!.copyWith(color: ink, fontSize: 14.5),
        ),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: VhSpace.xxs),
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.labelSmall!.copyWith(color: ink.withValues(alpha: 0.7)),
          ),
        ],
      ],
    );
  }
}

/// The end-of-lane card: "shorts finished", with back or continue with the
/// rest of the list.
class VhReelsEndCard extends StatelessWidget {
  const VhReelsEndCard({
    super.key,
    required this.onBack,
    this.onContinueRest,
    this.onReplay,
  });

  final VoidCallback onBack;
  final VoidCallback? onContinueRest;
  final VoidCallback? onReplay;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l10n = context.vhl;
    return Center(
      child: Container(
        margin: const EdgeInsets.all(VhSpace.xxl),
        padding: const EdgeInsets.all(VhSpace.xl),
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: BorderRadius.circular(VhRadius.sheet),
          border: Border.all(color: p.line),
          boxShadow: VhShadow.card,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VhIcon(VhIcons.bolt, size: 34, color: p.accent),
            const SizedBox(height: VhSpace.sm),
            Text(
              l10n.reelsEndTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: VhSpace.lg),
            if (onContinueRest != null)
              FilledButton(
                onPressed: onContinueRest,
                child: Text(l10n.reelsEndContinue),
              ),
            if (onReplay != null)
              TextButton(onPressed: onReplay, child: Text(l10n.reelsEndReplay)),
            TextButton(onPressed: onBack, child: Text(l10n.reelsEndBack)),
          ],
        ),
      ),
    );
  }
}
