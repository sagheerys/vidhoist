import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/downloads_data.dart';
import 'download_glyph.dart';
import 'downloads_panel.dart';

/// The downloads button in the title bar, with the count of what is under
/// way on its corner and its arrow moving while anything is; it opens
/// [DownloadsPanel].
class DownloadsButton extends ConsumerWidget {
  const DownloadsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final active = ref.watch(activeDownloadsProvider);
    final label = active > 0
        ? '${l.desktopDownloads} · ${l.activeDownloadsCount(active)}'
        : l.desktopDownloads;
    return VhShortcutTooltip(
      message: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: VhSpace.xxs / 2),
        child: IconButton(
          onPressed: () => unawaited(showDownloadsPanel(context)),
          // The count beside the arrow's corner, not over the arrow: Material's
          // badge sat on the glyph and hid it.
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Semantics(
                label: label,
                child: DownloadGlyph(
                  active: active,
                  motion: ref.watch(downloadMotionProvider),
                  color: active > 0 ? p.accentInk : p.ink2,
                ),
              ),
              if (active > 0)
                PositionedDirectional(
                  top: -VhSpace.xs,
                  end: -VhSpace.sm,
                  child: ExcludeSemantics(child: _Count(active)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The small accent pill with the number under way.
class _Count extends StatelessWidget {
  const _Count(this.count);

  final int count;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return Container(
      constraints: const BoxConstraints(minWidth: VhSpace.lg),
      padding: const EdgeInsets.symmetric(horizontal: VhSpace.xxs),
      decoration: BoxDecoration(
        color: p.accent,
        borderRadius: BorderRadius.circular(VhSpace.lg),
        border: Border.all(color: p.bg, width: VhSpace.xxs / 2),
      ),
      // A new number rises into place from below as the old one leaves, so
      // the count is seen to change.
      child: ClipRect(
        child: AnimatedSwitcher(
          duration: vhMotionDuration(context, VhMotion.page),
          switchInCurve: VhMotion.entrance,
          switchOutCurve: VhMotion.exit,
          transitionBuilder: (child, motion) => FadeTransition(
            opacity: motion,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.6),
                end: Offset.zero,
              ).animate(motion),
              child: child,
            ),
          ),
          child: Text(
            '$count',
            key: ValueKey(count),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.tabular
                .copyWith(color: p.onAccent, height: 1.3),
          ),
        ),
      ),
    );
  }
}
