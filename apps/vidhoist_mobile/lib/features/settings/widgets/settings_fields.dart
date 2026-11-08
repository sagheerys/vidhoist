import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../../di.dart';
import 'help_button.dart';
import '../../player/caption_style.dart';

/// A row that opens one of the settings screens.
class SettingsNavTile extends StatelessWidget {
  const SettingsNavTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final VhIconData icon;
  final String title;
  final String subtitle;
  final String route;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: VhIcon(icon),
    title: Text(title),
    subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
    trailing: const VhIcon(VhIcons.forward, matchTextDirection: true),
    onTap: () => context.go(route),
  );
}

/// A setting turned on or off, with what it does under its name.
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
    subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
    value: value,
    onChanged: onChanged,
  );
}

/// How a download is made: its quality, and when it may start.
class DownloadFields extends ConsumerWidget {
  const DownloadFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownMenu<Quality>(
                trailingIcon: const VhIcon(VhIcons.chevronDown),
                selectedTrailingIcon: const VhIcon(VhIcons.chevronUp),
                initialSelection: settings.quality,
                label: Text(l10n.defaultQuality),
                expandedInsets: EdgeInsets.zero,
                dropdownMenuEntries: [
                  DropdownMenuEntry(
                    value: Quality.best,
                    label: l10n.qualityBest,
                  ),
                  DropdownMenuEntry(
                    value: Quality.q1080,
                    label: l10n.quality1080,
                  ),
                  DropdownMenuEntry(
                    value: Quality.q720,
                    label: l10n.quality720,
                  ),
                  DropdownMenuEntry(
                    value: Quality.q480,
                    label: l10n.quality480,
                  ),
                  DropdownMenuEntry(
                    value: Quality.q360,
                    label: l10n.quality360,
                  ),
                  DropdownMenuEntry(
                    value: Quality.audio,
                    label: l10n.audioOnly,
                  ),
                ],
                onSelected: (q) => q == null ? null : notifier.setQuality(q),
              ),
            ),
            HelpButton(title: l10n.defaultQuality, body: l10n.qualityHelper),
          ],
        ),
        // **The default quality used to be a setting with no effect**: it
        // filled in the add sheet and the user re-chose it every time. With
        // "quick download" it becomes the actual decision, and the sheet is
        // skipped entirely.
        SettingsSwitchTile(
          title: l10n.quickDownload,
          subtitle: l10n.quickDownloadHelp,
          value: settings.quickDownload,
          onChanged: notifier.setQuickDownload,
        ),
        SettingsSwitchTile(
          title: l10n.wifiOnly,
          subtitle: l10n.wifiOnlyHelp,
          value: settings.wifiOnly,
          onChanged: notifier.setWifiOnly,
        ),
        SettingsSwitchTile(
          title: l10n.autoRetry,
          subtitle: l10n.autoRetryHelp,
          value: settings.autoRetry,
          onChanged: notifier.setAutoRetry,
        ),
        SettingsSwitchTile(
          title: l10n.mobileSubtitles,
          subtitle: l10n.mobileSubtitlesHelp,
          value: settings.subtitles,
          onChanged: notifier.setSubtitles,
        ),
      ],
    );
  }
}

/// How a clip plays: the compatible format, picture in picture, and the
/// subtitles' size and background.
class PlaybackFields extends ConsumerWidget {
  const PlaybackFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final settings = ref.watch(settingsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSwitchTile(
          title: l10n.compatiblePlayback,
          subtitle: l10n.compatiblePlaybackHelp,
          value: settings.compatiblePlayback,
          onChanged: ref.read(settingsProvider.notifier).setCompatiblePlayback,
        ),
        SettingsSwitchTile(
          title: l10n.pictureInPicture,
          subtitle: l10n.pictureInPictureHelp,
          value: settings.pictureInPicture,
          onChanged: ref.read(settingsProvider.notifier).setPictureInPicture,
        ),
        const SizedBox(height: VhSpace.lg),
        VhSectionHeader(title: l10n.subtitles),
        const SizedBox(height: VhSpace.sm),
        const CaptionStyleFields(),
        const SizedBox(height: VhSpace.sm),
        Text(
          l10n.mobileSubtitleStyleHelp,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: VhThemeX.of(context).palette.ink3),
        ),
      ],
    );
  }
}

/// The theme and the language.
class AppearanceFields extends ConsumerWidget {
  const AppearanceFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final settings = ref.watch(settingsProvider);
    final title = Theme.of(context).textTheme.titleSmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.theme, style: title),
        const SizedBox(height: VhSpace.xs),
        SegmentedButton<ThemeMode>(
          segments: [
            ButtonSegment(
              value: ThemeMode.system,
              label: Text(l10n.themeSystem),
            ),
            ButtonSegment(value: ThemeMode.light, label: Text(l10n.themeLight)),
            ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeDark)),
          ],
          selected: {settings.themeMode},
          onSelectionChanged: (selection) =>
              ref.read(settingsProvider.notifier).setThemeMode(selection.first),
        ),
        const SizedBox(height: VhSpace.lg),
        Text(l10n.language, style: title),
        const SizedBox(height: VhSpace.xs),
        // **"System" is a choice, not an implicit state.** An empty value
        // did mean "follow the phone", but the switch displayed it as
        // "Arabic", so someone with an English device read an English
        // interface beside a switch claiming Arabic, and the first touch
        // pinned a language with no way back.
        // **A row that opens a screen, not a segmented button** (requested
        // 2026-09-08): `SegmentedButton` divides the width by the number of
        // options, so three fit 360dp **and six break**, and the declared
        // plan is to support the common languages.
        SettingsNavTile(
          icon: VhIcons.globe,
          title: l10n.language,
          subtitle: settings.localeCode == null
              ? l10n.languageSystem
              : vhLanguageName(settings.localeCode!),
          route: '/settings/language',
        ),
      ],
    );
  }
}
