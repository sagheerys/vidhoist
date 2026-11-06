import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mt_media/library.dart';
import 'package:mt_media/mt_media.dart';
import 'package:mt_ui/mt_ui.dart';

import '../../router.dart';
import '../lists/list_dialogs.dart';
import 'clip_actions.dart';
import 'clip_menu.dart';
import 'clip_state.dart';
import 'clip_watch_group.dart';
import 'tags_dialog.dart';

/// The clip page's actions, quiet: the favourite, the tags and a list as
/// round buttons named in their tooltips; the ways of watching as a quiet
/// group; and everything else behind "More", with the clip's own menu.
/// Ten pills of the same weight, side by side, said nothing about which
/// mattered.
class ClipActionRow extends ConsumerWidget {
  const ClipActionRow({
    super.key,
    required this.item,
    required this.entry,
    required this.isCurrent,
    required this.onFullScreen,
  });

  final PlaylistItem item;
  final LibraryItem? entry;
  final bool isCurrent;
  final VoidCallback onFullScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.mtl;
    final actions = ref.read(clipActionsProvider);
    final audioOnly = ref.watch(audioOnlyProvider);
    final theater = ref.watch(theaterProvider);
    final favorite = entry?.favorite ?? false;
    final url = item.canonicalUrl;
    return Wrap(
      spacing: MTSpace.sm,
      runSpacing: MTSpace.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        RoundAction(
          label: favorite ? l.removeFromFavorites : l.addToFavorites,
          icon: favorite ? MTIcons.favoriteOn : MTIcons.favorite,
          on: favorite,
          onTap: () => unawaited(actions.toggleFavorite(url)),
        ),
        RoundAction(
          label: l.tags,
          icon: MTIcons.tags,
          onTap: () => unawaited(showTagsDialog(context, url)),
        ),
        RoundAction(
          label: l.addToPlaylist,
          icon: MTIcons.queue,
          onTap: () => unawaited(showAddToPlaylistDialog(context, item)),
        ),
        WatchGroup(
          children: [
            if (isCurrent && !item.isAudio)
              WatchChoice(
                label: l.audioOnly,
                icon: MTIcons.headphones,
                on: audioOnly,
                onTap: () => unawaited(
                  ref.read(audioOnlyProvider.notifier).set(!audioOnly),
                ),
              ),
            if (!item.isAudio) ...[
              WatchChoice(
                label: l.desktopTheater,
                icon: MTIcons.theater,
                on: theater,
                onTap: () =>
                    ref.read(theaterProvider.notifier).state = !theater,
              ),
              WatchChoice(
                label: l.enterFullscreen,
                icon: MTIcons.fullscreen,
                onTap: onFullScreen,
              ),
            ],
            WatchChoice(
              label: l.desktopReadingRoom,
              icon: MTIcons.reading,
              onTap: () => GoRouter.of(context).go(EmberRoutes.reading(url)),
            ),
          ],
        ),
        Builder(
          builder: (button) => RoundAction(
            label: l.desktopMore,
            icon: MTIcons.more,
            onTap: () {
              final box = button.findRenderObject()! as RenderBox;
              unawaited(
                showClipMenu(
                  context,
                  ref,
                  box.localToGlobal(box.size.bottomLeft(Offset.zero)),
                  item,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// A round button that shows only its glyph and says its name in a tooltip
/// and to a screen reader. On, the favourite's own red.
class RoundAction extends StatelessWidget {
  const RoundAction({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.on = false,
  });

  final String label;
  final MTIconData icon;
  final VoidCallback onTap;
  final bool on;

  @override
  Widget build(BuildContext context) {
    final p = MTThemeX.of(context).palette;
    return MTShortcutTooltip(
      message: label,
      child: Semantics(
        button: true,
        selected: on,
        label: label,
        excludeSemantics: true,
        child: Material(
          color: Colors.transparent,
          shape: CircleBorder(
            side: BorderSide(
              color: p.line2,
              width: MTThemeX.of(context).hairline,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox.square(
              dimension: MTDensity.desktop.iconButton,
              child: Center(
                child: MTIconSwap(
                  icon: icon,
                  size: MTDensity.desktop.icon,
                  color: on ? p.favorite : p.ink2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
