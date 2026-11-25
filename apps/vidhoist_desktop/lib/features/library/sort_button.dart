import 'package:flutter/material.dart';
import 'package:vh_media/library.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../shell/context_menu.dart';

/// The library's order, as the phone's sort sheet offers it: newest,
/// oldest, by name either way, largest or smallest. Every layout has it;
/// the table's headers sort too, and both keep the same choice.
class SortButton extends StatelessWidget {
  const SortButton({super.key, required this.sort, required this.onSort});

  final LibrarySort sort;
  final ValueChanged<LibrarySort> onSort;

  static String labelOf(VhLocalizations l, LibrarySort sort) => switch (sort) {
    LibrarySort.newest => l.sortNewest,
    LibrarySort.oldest => l.sortOldest,
    LibrarySort.nameAZ => l.sortNameAZ,
    LibrarySort.nameZA => l.sortNameZA,
    LibrarySort.largest => l.sortLargest,
    LibrarySort.smallest => l.sortSmallest,
  };

  /// **The order is written, not only drawn**: a bare glyph said there was
  /// an order, never which one, until it was hovered.
  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final named = '${l.sortBy} · ${labelOf(l, sort)}';
    return Builder(
      builder: (context) => Semantics(
        button: true,
        label: named,
        excludeSemantics: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(VhCorners.desktop.field),
          onTap: () async {
            // Opened under the button, as a menu from a toolbar is.
            final box = context.findRenderObject()! as RenderBox;
            final at = box.localToGlobal(box.size.bottomCenter(Offset.zero));
            final picked = await showDesktopMenu<LibrarySort>(context, at, [
              for (final s in LibrarySort.values)
                DesktopMenuEntry(
                  s,
                  s == sort ? VhIcons.check : null,
                  labelOf(l, s),
                ),
            ]);
            if (picked != null && picked != sort) onSort(picked);
          },
          child: SizedBox(
            height: VhDensity.desktop.iconButton,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: VhSpace.sm),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VhIcon(
                    VhIcons.sort,
                    size: VhDensity.desktop.icon,
                    color: p.ink2,
                  ),
                  const SizedBox(width: VhSpace.xs),
                  // One run of text, so the order's name keeps its words
                  // and only the end of the line gives way when the room
                  // runs out.
                  Flexible(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${l.sortBy}: ',
                            style: text.labelMedium?.copyWith(color: p.ink3),
                          ),
                          TextSpan(
                            text: labelOf(l, sort),
                            style: text.labelMedium?.copyWith(color: p.ink),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: VhSpace.xxs),
                  VhIcon(VhIcons.chevronDown, size: VhSpace.md, color: p.ink3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
