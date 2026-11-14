import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../../di.dart';
import '../subtitle_languages.dart';
import 'settings_fields.dart';

/// Settings › Downloads, under "Download subtitles" while it is on: the
/// languages fetched, and whether they also go inside the video.
///
/// Every language in sight at once, each a chip: a list behind a row
/// would hide what is chosen, and there are few enough to fit.
class SubtitleDownloadFields extends ConsumerWidget {
  const SubtitleDownloadFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final text = Theme.of(context).textTheme;
    final p = VhThemeX.of(context).palette;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final chosen = settings.subtitleLangs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.subtitleLangs, style: text.bodyMedium),
        const SizedBox(height: VhSpace.xxs),
        Text(l10n.subtitleLangsHelp, style: text.bodySmall),
        const SizedBox(height: VhSpace.sm),
        Wrap(
          spacing: VhSpace.xs,
          runSpacing: VhSpace.xs,
          children: [
            for (final MapEntry(key: code, value: name)
                in subtitleLanguageNames.entries)
              FilterChip(
                label: Text(name),
                selected: chosen.contains(code),
                showCheckmark: false,
                // The last one left stays: none would be the switch above
                // turned off, said in a stranger way.
                onSelected: chosen.length == 1 && chosen.contains(code)
                    ? null
                    : (_) => notifier.toggleSubtitleLang(code),
                labelStyle: text.labelMedium!.copyWith(
                  color: chosen.contains(code) ? p.bg : p.ink2,
                ),
              ),
          ],
        ),
        SettingsSwitchTile(
          title: l10n.embedSubtitles,
          subtitle: l10n.embedSubtitlesHelp,
          value: settings.embedSubtitles,
          onChanged: notifier.setEmbedSubtitles,
        ),
      ],
    );
  }
}
