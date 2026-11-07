import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_media/mt_media.dart';
import 'package:mt_ui/mt_ui.dart';

import '../../di.dart';

/// The subtitles' size and background as chips: in the playback settings
/// and in the sheet a long press on CC opens. Chips rather than a
/// segmented button, which splits the width four ways and cuts the Arabic
/// at a large text size.
class CaptionStyleFields extends ConsumerWidget {
  const CaptionStyleFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.mtl;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final title = Theme.of(context).textTheme.titleSmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.subtitlesSize, style: title),
        const SizedBox(height: MTSpace.xs),
        CaptionChoiceChips(
          labels: [
            l10n.subtitlesSizeSmall,
            l10n.subtitlesSizeMedium,
            l10n.subtitlesSizeLarge,
            l10n.mobileSubtitlesSizeLarger,
          ],
          chosen: settings.captionSize,
          onChosen: (i) => unawaited(notifier.setCaptionSize(i)),
        ),
        const SizedBox(height: MTSpace.md),
        Text(l10n.subtitlesBackground, style: title),
        const SizedBox(height: MTSpace.xs),
        CaptionChoiceChips(
          labels: [
            l10n.subtitlesBackgroundSolid,
            l10n.subtitlesBackgroundFaint,
            l10n.subtitlesBackgroundNone,
          ],
          chosen: settings.captionBackground,
          onChosen: (i) => unawaited(notifier.setCaptionBackground(i)),
        ),
        const SizedBox(height: MTSpace.xs),
        Text(
          l10n.subtitlesBackgroundHelp,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: MTThemeX.of(context).palette.ink3),
        ),
      ],
    );
  }
}

/// One choice of several, as the library's sort sheet draws it.
class CaptionChoiceChips extends StatelessWidget {
  const CaptionChoiceChips({
    super.key,
    required this.labels,
    required this.chosen,
    required this.onChosen,
  });

  final List<String> labels;
  final int chosen;
  final ValueChanged<int> onChosen;

  @override
  Widget build(BuildContext context) {
    final p = MTThemeX.of(context).palette;
    final style = Theme.of(context).textTheme.labelMedium!;
    return Wrap(
      spacing: MTSpace.xs,
      runSpacing: MTSpace.xs,
      children: [
        for (final (i, label) in labels.indexed)
          ChoiceChip(
            label: Text(label),
            selected: chosen == i,
            showCheckmark: false,
            labelStyle: style.copyWith(color: chosen == i ? p.bg : p.ink2),
            onSelected: (_) => onChosen(i),
          ),
      ],
    );
  }
}

/// What a long press on CC opens: the size, the background, the language
/// when the clip has more than one, and the transcript.
class CaptionOptions extends StatelessWidget {
  const CaptionOptions({
    super.key,
    required this.captions,
    required this.onTranscript,
  });

  final MTCaptions captions;
  final VoidCallback onTranscript;

  @override
  Widget build(BuildContext context) {
    final l10n = context.mtl;
    final language = captions.language;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CaptionStyleFields(),
        if (captions.switchable)
          ValueListenableBuilder(
            valueListenable: language!,
            builder: (context, _, _) => Padding(
              padding: const EdgeInsets.only(top: MTSpace.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.subtitlesLanguage,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: MTSpace.xs),
                  CaptionChoiceChips(
                    labels: [
                      for (final code in captions.tracks.keys)
                        captionCode(code),
                    ],
                    chosen: captions.tracks.keys.toList().indexOf(
                      captions.current!,
                    ),
                    onChosen: (i) =>
                        language.value = captions.tracks.keys.elementAt(i),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: MTSpace.md),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const MTIcon(MTIcons.transcript),
          title: Text(l10n.mobileTranscriptOpen),
          onTap: onTranscript,
        ),
      ],
    );
  }
}

/// A language as the CC switch shows it: "AR", "EN".
String captionCode(String language) => language.split('-').first.toUpperCase();

/// Opens [CaptionOptions] from the bottom, over the player.
Future<void> showCaptionOptions(
  BuildContext context,
  MTCaptions captions, {
  required VoidCallback onTranscript,
}) => showMTSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (sheet) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(MTSpace.lg, 0, MTSpace.lg, MTSpace.lg),
    child: CaptionOptions(
      captions: captions,
      onTranscript: () {
        Navigator.of(sheet).pop();
        onTranscript();
      },
    ),
  ),
);
