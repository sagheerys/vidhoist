import '../pc/pc_settings_fields.dart';

import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import '../accounts/accounts_fields.dart';
import '../channels/channels_screen.dart';
import '../update/update_section.dart';
import 'about_screen.dart';
import 'backup_screen.dart';
import 'logs_screen.dart';
import 'settings_sections.dart';
import 'widgets/engine_fields.dart';
import 'widgets/settings_fields.dart';

/// A section's page: pushed on a phone, open beside the list on a tablet
/// held sideways. The screens that existed before the home page open as
/// they are.
class SettingsPage extends StatelessWidget {
  const SettingsPage(this.pane, {super.key});

  final SettingsPane pane;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    return switch (pane) {
      SettingsPane.engine => VhSettingsPage(
        title: l10n.mobileSettingsEngine,
        child: const EngineFields(),
      ),
      SettingsPane.accounts => VhSettingsPage(
        title: l10n.settingsAccounts,
        child: const AccountsFields(),
      ),
      SettingsPane.channels => const ChannelsScreen(),
      SettingsPane.downloads => VhSettingsPage(
        title: l10n.settingsDownloads,
        child: const DownloadFields(),
      ),
      SettingsPane.pc => VhSettingsPage(
        title: l10n.pcTab,
        child: const PcSettingsFields(),
      ),
      SettingsPane.playback => VhSettingsPage(
        title: l10n.settingsPlayback,
        child: const PlaybackFields(),
      ),
      SettingsPane.appearance => VhSettingsPage(
        title: l10n.appearanceAndLanguage,
        child: const AppearanceFields(),
      ),
      SettingsPane.backup => const BackupScreen(),
      SettingsPane.updates => VhSettingsPage(
        title: l10n.updates,
        child: const UpdateSection(),
      ),
      SettingsPane.logs => const LogsScreen(),
      SettingsPane.about => const AboutScreen(),
    };
  }
}
