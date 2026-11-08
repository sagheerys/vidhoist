import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../router.dart';
import 'pane_values.dart';
import 'settings_place.dart';

/// One section in the list beside the settings: its icon, its name, and
/// the setting as it stands, so a look down the list answers most questions
/// without opening anything.
VhIconData _paneIcon(DesktopSettingsPane pane) => switch (pane) {
  DesktopSettingsPane.subscriptions => VhIcons.subscriptions,
  DesktopSettingsPane.cookies => VhIcons.cookie,
  DesktopSettingsPane.downloads => VhIcons.download,
  DesktopSettingsPane.folders => VhIcons.folder,
  DesktopSettingsPane.appearance => VhIcons.appearance,
  DesktopSettingsPane.desktop => VhIcons.monitor,
  DesktopSettingsPane.transcripts => VhIcons.transcript,
  DesktopSettingsPane.backup => VhIcons.backup,
  DesktopSettingsPane.updates => VhIcons.saveTo,
  DesktopSettingsPane.logs => VhIcons.list,
  DesktopSettingsPane.about => VhIcons.info,
  DesktopSettingsPane.engine => VhIcons.bolt,
};

class PaneEntry extends ConsumerWidget {
  const PaneEntry({
    super.key,
    required this.pane,
    required this.selected,
    required this.onTap,
  });

  final DesktopSettingsPane pane;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final ink = selected ? p.ink : p.ink2;
    final label = paneTitle(context.vhl, pane);
    final value = paneValue(context, ref, pane);
    return Padding(
      padding: const EdgeInsets.only(bottom: VhSpace.xxs),
      child: AnimatedContainer(
        // The fill eases from one choice to the next, as the border does.
        duration: vhMotionDuration(context, VhMotion.fast),
        decoration: ShapeDecoration(
          color: selected ? vhSelectedFill(p) : p.ink.withValues(alpha: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VhCorners.desktop.field),
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(VhCorners.desktop.field),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(VhCorners.desktop.field),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: VhSpace.sm,
                vertical: VhSpace.xs,
              ),
              child: Row(
                children: [
                  VhIcon(
                    _paneIcon(pane),
                    size: VhDensity.desktop.icon,
                    color: ink,
                  ),
                  const SizedBox(width: VhSpace.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodyMedium?.copyWith(
                            color: p.ink,
                            fontWeight: selected ? FontWeight.w700 : null,
                          ),
                        ),
                        // The setting as it stands, so a look down the list
                        // answers most questions without opening anything.
                        if (value != null)
                          Text(
                            value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.labelSmall?.copyWith(color: p.ink3),
                          ),
                      ],
                    ),
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
