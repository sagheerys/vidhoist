import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import '../playlists_providers.dart';

/// The smart playlists as **rows in one quiet group**: an icon, the name,
/// how many it holds, and play. Three dark cards with a glow each were the
/// loudest thing in the tab, for lists the app builds by itself.
class SmartListRows extends StatelessWidget {
  const SmartListRows({super.key, required this.lists, required this.onPlay});

  final List<SmartList> lists;
  final ValueChanged<SmartList> onPlay;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l10n = context.vhl;
    final text = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(VhRadius.card),
        border: Border.all(color: p.line, width: VhThemeX.of(context).hairline),
      ),
      child: Column(
        children: [
          for (final (i, list) in lists.indexed) ...[
            if (i > 0) const Divider(height: 1, indent: VhSpace.md),
            InkWell(
              onTap: () => onPlay(list),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: VhSpace.md,
                  vertical: VhSpace.sm + 2,
                ),
                child: Row(
                  children: [
                    VhIcon(
                      switch (list.kind) {
                        SmartListKind.favorites => VhIcons.favorite,
                        SmartListKind.latest => VhIcons.clock,
                      },
                      size: 20,
                      color: p.ink2,
                    ),
                    const SizedBox(width: VhSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            switch (list.kind) {
                              SmartListKind.favorites => l10n.favorites,
                              SmartListKind.latest => l10n.latestAdditions,
                            },
                            style: text.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            vhMetaLine([
                              l10n.queueItemsCount(list.count),
                              l10n.autoBuilt,
                            ]),
                            style: text.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    VhIcon(VhIcons.playFill, size: 22, color: p.ink2),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
