import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_ui/vh_ui.dart';

import '../update/update_pending_row.dart';
import 'settings_hub.dart';
import 'settings_sections.dart';

/// **The settings home**: three short groups whose rows show each setting as it stands, each
/// opening its own page. It used to be one long page that grew with every
/// feature. On a tablet held sideways the same rows open in two panes
/// ([SettingsHub]).
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  /// Kept here, above both shapes, so turning the tablet does not lose the
  /// open section.
  SettingsPane _pane = SettingsPane.engine;

  @override
  Widget build(BuildContext context) {
    if (VhAdaptiveScaffold.hasEndPane(context)) {
      return SettingsHub(
        selected: _pane,
        onSelect: (pane) => setState(() => _pane = pane),
      );
    }
    final l10n = context.vhl;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: VhReadableWidth(
        child: ListView(
          // Neither the mini player nor the add button shows on this tab,
          // so the list ends just past its last card; the system's own bar
          // is added where no bottom bar takes it (an upright tablet).
          padding: EdgeInsets.fromLTRB(
            VhSpace.pagePad,
            0,
            VhSpace.pagePad,
            VhSpace.xl + MediaQuery.paddingOf(context).bottom,
          ),
          children: [
            const UpdatePendingRow(),
            for (final (title, entries) in settingsGroups(context, ref))
              VhSettingsGroup(
                title: title,
                rows: [
                  for (final e in entries)
                    VhSettingsRow(
                      icon: e.icon,
                      title: e.title,
                      value: e.value,
                      onTap: () => context.go(e.pane.route),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
