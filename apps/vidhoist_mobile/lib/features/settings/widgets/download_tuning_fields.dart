import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../../di.dart';
import '../battery_freedom.dart';
import '../settings_state.dart';
import 'settings_fields.dart';

/// Settings › Downloads, under the everyday rows: what "audio only" is
/// saved as, a speed limit, pieces fetched together, and whether battery
/// saving may stop a download.
class DownloadTuningFields extends ConsumerWidget {
  const DownloadTuningFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: VhSpace.lg),
        VhSectionHeader(title: l10n.downloadsAdvanced),
        // Room for the menu's label, which sits on its top border.
        const SizedBox(height: VhSpace.lg),
        DropdownMenu<AudioFormat>(
          trailingIcon: const VhIcon(VhIcons.chevronDown),
          selectedTrailingIcon: const VhIcon(VhIcons.chevronUp),
          initialSelection: settings.audioFormat,
          label: Text(l10n.audioFormat),
          expandedInsets: EdgeInsets.zero,
          dropdownMenuEntries: [
            for (final format in AudioFormat.values)
              DropdownMenuEntry(
                value: format,
                label: switch (format) {
                  AudioFormat.m4a => l10n.audioFormatM4a,
                  AudioFormat.mp3 => l10n.audioFormatMp3,
                  AudioFormat.original => l10n.audioFormatOriginal,
                },
              ),
          ],
          onSelected: (f) => f == null ? null : notifier.setAudioFormat(f),
        ),
        const SizedBox(height: VhSpace.md),
        // "None" is the empty string here: a menu entry cannot hold null
        // and still be told apart from "nothing chosen".
        DropdownMenu<String>(
          trailingIcon: const VhIcon(VhIcons.chevronDown),
          selectedTrailingIcon: const VhIcon(VhIcons.chevronUp),
          initialSelection: settings.rateLimit ?? '',
          label: Text(l10n.rateLimit),
          expandedInsets: EdgeInsets.zero,
          dropdownMenuEntries: [
            DropdownMenuEntry(value: '', label: l10n.rateLimitNone),
            for (final rate in PhoneSettings.rateLimits)
              DropdownMenuEntry(
                value: rate,
                label: l10n.rateLimitValue(
                  int.parse(rate.substring(0, rate.length - 1)),
                ),
              ),
          ],
          onSelected: (rate) => rate == null
              ? null
              : notifier.setRateLimit(rate.isEmpty ? null : rate),
        ),
        SettingsSwitchTile(
          title: l10n.fastStreams,
          subtitle: l10n.fastStreamsHelp(PhoneSettings.fastPieces),
          value: settings.fastStreams,
          onChanged: notifier.setFastStreams,
        ),
        const BatteryTile(),
      ],
    );
  }
}
