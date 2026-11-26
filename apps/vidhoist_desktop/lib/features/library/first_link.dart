import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../shell/key_cap.dart';
import '../../shell/shell_metrics.dart';

/// **An empty library asks its one question in place**: the add dialog's
/// first row, drawn in the page, not a small link to a dialog that then
/// asks for the link. The filters and the layouts wait for a first clip;
/// there is nothing to sort yet.
///
/// It is the way into the dialog, not a second place to type: a click
/// opens the dialog with what the clipboard holds, as the sidebar's add
/// button does, and Ctrl+V anywhere in the window already opens it with
/// the link. One field for a link, so a link is never typed twice.
class FirstLink extends StatelessWidget {
  const FirstLink({super.key, required this.onAdd});

  /// Opens the add dialog, with the clipboard's links when it holds any.
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final corners = BorderRadius.circular(VhCorners.desktop.field);
    return ConstrainedBox(
      // As wide as the dialog it opens.
      constraints: const BoxConstraints(maxWidth: DesktopShellSize.addDialog),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l.desktopFirstLinkTitle,
            textAlign: TextAlign.center,
            style: text.titleLarge,
          ),
          const SizedBox(height: VhSpace.lg),
          Semantics(
            button: true,
            label: l.addLinkFab,
            hint: l.pasteUrlHint,
            excludeSemantics: true,
            child: Material(
              color: p.card,
              shape: RoundedRectangleBorder(
                borderRadius: corners,
                side: BorderSide(
                  color: p.accent,
                  width: VhThemeX.of(context).hairline * 1.5,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onAdd,
                child: SizedBox(
                  height: VhDensity.desktop.row + VhSpace.md,
                  child: Row(
                    children: [
                      const SizedBox(width: VhSpace.md),
                      VhIcon(
                        VhIcons.link,
                        size: VhDensity.desktop.icon,
                        color: p.ink3,
                      ),
                      const SizedBox(width: VhSpace.sm),
                      Expanded(
                        child: Text(
                          l.pasteUrlHint,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodyMedium?.copyWith(color: p.ink3),
                        ),
                      ),
                      _PasteMark(label: l.desktopFirstLinkPaste),
                      const SizedBox(width: VhSpace.xs),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: VhSpace.md),
          Text(
            l.desktopFirstLinkNote,
            textAlign: TextAlign.center,
            style: text.bodySmall?.copyWith(color: p.ink2),
          ),
          const SizedBox(height: VhSpace.sm),
          // The shortcut that already works anywhere, named once here.
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: VhSpace.xs,
            children: [
              const KeyCap(label: 'Ctrl V'),
              Text(
                l.desktopFirstLinkKeys,
                style: text.labelSmall?.copyWith(color: p.ink3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// "Paste" at the field's end, in the accent's soft fill. The whole field
/// is a single button; this is styled as part of it, not a second target.
class _PasteMark extends StatelessWidget {
  const _PasteMark({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: VhSpace.sm,
        vertical: VhSpace.xs,
      ),
      decoration: BoxDecoration(
        color: p.accentSoft,
        borderRadius: BorderRadius.circular(VhCorners.desktop.field),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VhIcon(VhIcons.paste, size: VhSpace.md, color: p.accentInk),
          const SizedBox(width: VhSpace.xxs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: p.accentInk, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
