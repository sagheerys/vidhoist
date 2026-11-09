import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/appearance_data.dart';
import '../../data/channels_data.dart';
import '../../data/choices_data.dart';
import '../../data/engine_data.dart';
import '../../data/pc_link_data.dart';
import '../../data/update_data.dart';
import '../../router.dart';
import '../../shell/ui_zoom.dart';
import 'simple_panes.dart';
import 'transcripts_pane.dart';

/// The line under a section's name in the list: the setting as it stands,
/// not a description. Null when there is nothing short and certain to say,
/// rather than a guess or a blank.
String? paneValue(
  BuildContext context,
  WidgetRef ref,
  DesktopSettingsPane pane,
) {
  final l = context.vhl;
  switch (pane) {
    case DesktopSettingsPane.engine:
      if (!ref.watch(enginePathsProvider).ready) return l.settingsValueNotSet;
      final version = ref.watch(engineVersionProvider).valueOrNull?.ytDlp;
      return version == null ? null : vhLtrRun('yt-dlp $version');
    case DesktopSettingsPane.subscriptions:
      final channels = ref.watch(channelsProvider).valueOrNull?.subscriptions;
      return channels == null ? null : l.settingsValueChannels(channels.length);
    case DesktopSettingsPane.downloads:
      final quality = ref.watch(defaultQualityProvider);
      return qualityLabels(l).firstWhere((q) => q.$1 == quality).$2;
    case DesktopSettingsPane.appearance:
      final look = ref.watch(appearanceProvider);
      return vhMetaLine([
        switch (look.theme) {
          ThemeMode.system => l.themeSystem,
          ThemeMode.light => l.themeLight,
          ThemeMode.dark => l.themeDark,
        },
        // Following Windows, it names the language in use: "System" twice
        // over would say nothing.
        vhLanguageName(
          look.locale ?? Localizations.localeOf(context).languageCode,
        ),
        ref.watch(uiZoomProvider).percent,
      ]);
    case DesktopSettingsPane.transcripts:
      final summary = ref.watch(transcriptsSummaryProvider).valueOrNull;
      return summary == null ? null : l.transcriptsClips(summary.$1);
    case DesktopSettingsPane.updates:
      if (ref.watch(updateProvider).release case final release?) {
        return l.updateVersionAvailable(release.version.toString());
      }
      return ref.watch(installedVersionProvider).valueOrNull;
    case DesktopSettingsPane.about:
      final version = ref.watch(installedVersionProvider).valueOrNull;
      return version == null ? null : '${l.version} $version';
    case DesktopSettingsPane.phone:
      if (!ref.watch(pcLinkEnabledProvider)) return l.pcLinkOff;
      final devices = ref.watch(pcLinkDevicesProvider).valueOrNull?.length;
      return devices == null ? null : l.pcLinkPhones(devices);
    default:
      return null;
  }
}
