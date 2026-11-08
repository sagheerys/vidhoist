import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/subtitles_data.dart';
import '../../shell/context_menu.dart';
import '../../shell/pill.dart';
import '../../shell/player_controls.dart';
import '../settings/appearance_pane.dart';

/// The subtitles [item] has, as the player draws them: every language it
/// comes in (the switch walks them), at the size and over the background
/// chosen. Null for a clip with no transcript.
VhCaptions? desktopCaptionsFor(WidgetRef ref, PlaylistItem item) {
  final tracks = ref.watch(captionTracksProvider(item.canonicalUrl));
  if (tracks == null) return null;
  final subtitles = ref.watch(desktopSubtitlesProvider);
  return VhCaptions(
    lines: tracks.values.first,
    tracks: tracks,
    language: subtitles.language,
    shown: subtitles.shown,
    scale: subtitles.scale,
    background: subtitles.backdrop,
  );
}

/// The subtitles' buttons on the picture, as on the phone: the language
/// on screen ("AR", "EN"; a click moves to the next) while they show and
/// the clip has more than one, CC, and a menu of the size, the background
/// and the language.
class DesktopCaptionButtons extends ConsumerWidget {
  const DesktopCaptionButtons({super.key, required this.item});

  final PlaylistItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitles = ref.watch(desktopSubtitlesProvider);
    return ListenableBuilder(
      listenable: Listenable.merge([
        subtitles.shown,
        subtitles.language,
        subtitles.size,
        subtitles.background,
      ]),
      builder: (context, _) {
        final captions = desktopCaptionsFor(ref, item);
        if (captions == null) return const SizedBox.shrink();
        final l = context.vhl;
        final accent = VhThemeX.of(context).palette.accent;
        final on = subtitles.shown.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (on && captions.switchable)
              VhShortcutTooltip(
                message: l.subtitlesLanguage,
                child: TextButton(
                  onPressed: captions.nextLanguage,
                  child: Text(
                    _code(captions.current),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            DesktopPlayerControl(
              icon: VhIcons.captions,
              label: on ? l.subtitlesHide : l.subtitlesShow,
              shortcut: 'C',
              selected: on,
              ink: Colors.white,
              color: accent,
              onTap: subtitles.toggle,
            ),
            Builder(
              builder: (button) => DesktopPlayerControl(
                icon: VhIcons.chevronDown,
                label: l.desktopSubtitleOptions,
                ink: Colors.white,
                onTap: () => unawaited(_menu(button, captions, subtitles)),
              ),
            ),
          ],
        );
      },
    );
  }

  static String _code(String? language) =>
      (language ?? '').split('-').first.toUpperCase();

  /// The size, the background and the language, the chosen ones ticked,
  /// opened under the button.
  static Future<void> _menu(
    BuildContext button,
    VhCaptions captions,
    DesktopSubtitles subtitles,
  ) async {
    final l = button.vhl;
    final box = button.findRenderObject()! as RenderBox;
    final at = box.localToGlobal(box.size.bottomCenter(Offset.zero));
    VhIconData? tick(bool chosen) => chosen ? VhIcons.check : null;
    final choice = await showDesktopMenu<String>(button, at, [
      for (final (i, size) in _sizes(l).indexed)
        DesktopMenuEntry(
          's$i',
          tick(subtitles.size.value == i),
          '${l.subtitlesSize} · $size',
        ),
      const DesktopMenuEntry.divider(),
      for (final (i, kind) in _backgrounds(l).indexed)
        DesktopMenuEntry(
          'b$i',
          tick(subtitles.background.value == i),
          '${l.subtitlesBackground} · $kind',
        ),
      if (captions.tracks.length > 1) ...[
        const DesktopMenuEntry.divider(),
        for (final code in captions.tracks.keys)
          DesktopMenuEntry(
            'l$code',
            tick(captions.current == code),
            '${l.subtitlesLanguage} · ${_code(code)}',
          ),
      ],
    ]);
    if (choice == null) return;
    final rest = choice.substring(1);
    switch (choice[0]) {
      case 's':
        subtitles.size.value = int.parse(rest);
      case 'b':
        subtitles.background.value = int.parse(rest);
      case 'l':
        subtitles.language.value = rest;
    }
  }
}

List<String> _sizes(VhLocalizations l) => [
  l.subtitlesSizeSmall,
  l.subtitlesSizeMedium,
  l.subtitlesSizeLarge,
];

List<String> _backgrounds(VhLocalizations l) => [
  l.subtitlesBackgroundSolid,
  l.subtitlesBackgroundFaint,
  l.subtitlesBackgroundNone,
];

/// The subtitles' size and background in Settings, the phone's choices.
class CaptionStyleChoices extends ConsumerWidget {
  const CaptionStyleChoices({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final subtitles = ref.watch(desktopSubtitlesProvider);
    return ListenableBuilder(
      listenable: Listenable.merge([subtitles.size, subtitles.background]),
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChoiceGroup(
            title: l.subtitlesSize,
            children: [
              for (final (i, label) in _sizes(l).indexed)
                DesktopPill(
                  label: label,
                  selected: subtitles.size.value == i,
                  onTap: () => subtitles.size.value = i,
                ),
            ],
          ),
          ChoiceGroup(
            title: l.subtitlesBackground,
            hint: l.subtitlesBackgroundHelp,
            children: [
              for (final (i, label) in _backgrounds(l).indexed)
                DesktopPill(
                  label: label,
                  selected: subtitles.background.value == i,
                  onTap: () => subtitles.background.value = i,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
