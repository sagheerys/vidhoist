import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import 'settings_page.dart';
import 'settings_sections.dart';

/// **Settings in two panes** on a tablet held sideways (2026-10-10): the
/// rows of the phone's home page on one side, the chosen section open on
/// the other, the way Android's own settings read on a tablet.
class SettingsHub extends ConsumerWidget {
  const SettingsHub({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final SettingsPane selected;
  final ValueChanged<SettingsPane> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
    children: [
      SizedBox(
        width: VhBreakpoint.sidePanel,
        child: Scaffold(
          appBar: AppBar(title: Text(context.vhl.settings)),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(
              VhSpace.md,
              0,
              VhSpace.md,
              VhSpace.xl,
            ),
            children: [
              for (final (title, entries) in settingsGroups(context, ref))
                VhSettingsGroup(
                  title: title,
                  divided: false,
                  rows: [
                    for (final e in entries)
                      VhSettingsRow(
                        icon: e.icon,
                        title: e.title,
                        value: e.value,
                        selected: e.pane == selected,
                        chevron: false,
                        onTap: () => onSelect(e.pane),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
      VerticalDivider(
        width: 1,
        thickness: 1,
        color: VhThemeX.of(context).palette.line,
      ),
      Expanded(
        child: KeyedSubtree(
          key: ValueKey(selected),
          child: SettingsPage(selected),
        ),
      ),
    ],
  );
}
