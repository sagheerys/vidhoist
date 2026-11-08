import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../channels/channels_state.dart';
import '../update/update_state.dart';
import 'widgets/engine_fields.dart';
import '../update/whats_new_prompt.dart';
import 'auto_backup.dart';
import 'settings_state.dart';

/// The settings sections, in the order both shapes list them. The download
/// engine comes first.
enum SettingsPane {
  engine,
  channels,
  downloads,
  playback,
  appearance,
  backup,
  updates,
  logs,
  about;

  /// **Each section has its own address**, so a message about a problem
  /// can open the very page that fixes it rather than the settings home.
  String get route => '/settings/$name';
}

/// One row of the settings home: what it opens, and what it says.
class SettingsEntry {
  const SettingsEntry(this.pane, this.icon, this.title, this.value);

  final SettingsPane pane;
  final VhIconData icon;
  final String title;

  /// The setting as it stands, not a description of the section.
  final String value;
}

/// The three groups the phone's home page and the tablet's list share, so
/// one order is learnt once on either device.
List<(String, List<SettingsEntry>)> settingsGroups(
  BuildContext context,
  WidgetRef ref,
) {
  final l10n = context.vhl;
  final v = _Values(context, ref);
  return [
    (
      l10n.mobileSettingsGroupEngine,
      [
        SettingsEntry(
          SettingsPane.engine,
          VhIcons.bolt,
          l10n.mobileSettingsEngine,
          v.engine(),
        ),
        SettingsEntry(
          SettingsPane.channels,
          VhIcons.subscriptions,
          l10n.desktopChannels,
          v.channels(),
        ),
      ],
    ),
    (
      l10n.settingsGroupApp,
      [
        SettingsEntry(
          SettingsPane.downloads,
          VhIcons.download,
          l10n.settingsDownloads,
          v.downloads(),
        ),
        SettingsEntry(
          SettingsPane.playback,
          VhIcons.playback,
          l10n.settingsPlayback,
          v.playback(),
        ),
        SettingsEntry(
          SettingsPane.appearance,
          VhIcons.appearance,
          l10n.appearanceAndLanguage,
          v.appearance(),
        ),
      ],
    ),
    (
      l10n.settingsGroupData,
      [
        SettingsEntry(
          SettingsPane.backup,
          VhIcons.backup,
          l10n.settingsBackup,
          v.backup(),
        ),
        SettingsEntry(
          SettingsPane.updates,
          VhIcons.saveTo,
          l10n.updates,
          v.updates(),
        ),
        SettingsEntry(
          SettingsPane.logs,
          VhIcons.list,
          l10n.diagnosticLogs,
          l10n.diagnosticLogsSubtitle,
        ),
        SettingsEntry(
          SettingsPane.about,
          VhIcons.info,
          l10n.aboutApp,
          v.about(),
        ),
      ],
    ),
  ];
}

/// Each row's line. Something not known yet (a value still loading, a
/// folder not read) falls back to what the section is for, never to a
/// blank or a guess.
class _Values {
  _Values(this.context, this.ref)
    : l10n = context.vhl,
      s = ref.watch(settingsProvider);

  final BuildContext context;
  final WidgetRef ref;
  final VhLocalizations l10n;
  final PhoneSettings s;

  String engine() => engineSummary(
    l10n,
    ref.watch(engineStatusProvider).valueOrNull ??
        ref.read(enginePreparerProvider).status,
  );

  /// How many are followed, or what the section is for while reading.
  String channels() => switch (ref.watch(channelsProvider).valueOrNull) {
    final subs? when subs.isNotEmpty => l10n.settingsValueChannels(subs.length),
    _ => l10n.mobileChannelsHint,
  };

  String downloads() => vhMetaLine([
    switch (s.quality) {
      Quality.best => l10n.qualityBest,
      Quality.q1080 => l10n.quality1080,
      Quality.q720 => l10n.quality720,
      Quality.q480 => l10n.quality480,
      Quality.q360 => l10n.quality360,
      Quality.audio => l10n.audioOnly,
    },
    if (s.wifiOnly) l10n.settingsValueWifiOnly,
    if (s.quickDownload) l10n.settingsValueQuick,
  ]);

  String playback() => s.compatiblePlayback
      ? l10n.settingsValueCompatOn
      : l10n.settingsValueCompatOff;

  String appearance() => vhMetaLine([
    switch (s.themeMode) {
      ThemeMode.system => l10n.themeSystem,
      ThemeMode.light => l10n.themeLight,
      ThemeMode.dark => l10n.themeDark,
    },
    // Following the phone, it names the language in use: "System" twice
    // over said nothing.
    vhLanguageName(
      s.localeCode ?? Localizations.localeOf(context).languageCode,
    ),
  ]);

  String backup() => switch (ref.watch(latestBackupProvider).valueOrNull) {
    final at? => l10n.lastBackup(vhTimeAgo(context, at)),
    null => l10n.backupSettingsSubtitle,
  };

  String updates() {
    final state = ref.watch(updateControllerProvider);
    if (state.release case final release?) {
      return l10n.updateVersionAvailable(release.version.toString());
    }
    return vhMetaLine([
      ref.watch(installedVersionProvider).valueOrNull?.$1,
      if (state.autoCheck) l10n.autoCheckUpdates,
    ]);
  }

  String about() => switch (ref.watch(installedVersionProvider).valueOrNull) {
    (final version, _) => '${l10n.version} $version',
    null => l10n.aboutDescriptionPhone,
  };
}
