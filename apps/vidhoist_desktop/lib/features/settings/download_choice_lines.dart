import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/download_choices_data.dart';
import '../../shell/pill.dart';
import 'appearance_pane.dart';
import 'simple_panes.dart';

/// Settings › Downloads: what "audio only" is saved as, a speed limit, and
/// fast streams. Every choice in sight as a pill, as the quality above it:
/// a screen this wide has the room, and a menu would hide what is set.
class DownloadTuningLines extends ConsumerWidget {
  const DownloadTuningLines({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final choices = ref.watch(downloadChoicesProvider);
    final notifier = ref.read(downloadChoicesProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChoiceGroup(
          title: l.audioFormat,
          children: [
            for (final (format, label) in [
              (AudioFormat.m4a, l.audioFormatM4a),
              (AudioFormat.mp3, l.audioFormatMp3),
              (AudioFormat.original, l.audioFormatOriginal),
            ])
              DesktopPill(
                label: label,
                selected: choices.audioFormat == format,
                onTap: () => unawaited(notifier.setAudioFormat(format)),
              ),
          ],
        ),
        ChoiceGroup(
          title: l.rateLimit,
          children: [
            DesktopPill(
              label: l.rateLimitNone,
              selected: choices.rateLimit == null,
              onTap: () => unawaited(notifier.setRateLimit(null)),
            ),
            for (final rate in DownloadChoices.rateLimits)
              DesktopPill(
                label: l.rateLimitValue(
                  int.parse(rate.substring(0, rate.length - 1)),
                ),
                selected: choices.rateLimit == rate,
                onTap: () => unawaited(notifier.setRateLimit(rate)),
              ),
          ],
        ),
        SwitchLine(
          title: l.fastStreams,
          hint: l.fastStreamsHelp(DownloadChoices.fastPieces),
          value: choices.fastStreams,
          onChanged: (on) => unawaited(notifier.setFastStreams(on)),
        ),
      ],
    );
  }
}

/// Under "fetch its transcript first" while it is on: the languages
/// fetched, and whether they also go inside the video.
class SubtitleChoiceLines extends ConsumerWidget {
  const SubtitleChoiceLines({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final choices = ref.watch(downloadChoicesProvider);
    final chosen = ref.watch(subtitleLangsProvider);
    final notifier = ref.read(downloadChoicesProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChoiceGroup(
          title: l.subtitleLangs,
          hint: l.subtitleLangsHelp,
          children: [
            for (final MapEntry(key: code, value: name)
                in subtitleLanguageNames.entries)
              DesktopPill(
                label: name,
                selected: chosen.contains(code),
                onTap: () =>
                    unawaited(notifier.toggleSubtitleLang(code, chosen)),
              ),
          ],
        ),
        SwitchLine(
          title: l.embedSubtitles,
          hint: l.embedSubtitlesHelp,
          value: choices.embedSubtitles,
          onChanged: (on) => unawaited(notifier.setEmbedSubtitles(on)),
        ),
      ],
    );
  }
}
