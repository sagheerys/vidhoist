import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import 'vh_captions.dart';
import 'video_buttons.dart';

/// The subtitles' buttons in the top bar: the language, while the subtitles
/// show and the clip has more than one, then CC, whose long press opens
/// [VhCaptions.onOptions].
class VhCaptionButtons extends StatelessWidget {
  const VhCaptionButtons({super.key, required this.captions});

  final VhCaptions captions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    return ListenableBuilder(
      listenable: Listenable.merge([captions.shown, captions.language]),
      builder: (context, _) {
        final shown = captions.shown.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (shown && captions.switchable) ...[
              _LanguageButton(captions: captions),
              const SizedBox(width: VhSpace.xs),
            ],
            VhVideoIconButton(
              icon: shown ? VhIcons.captions : VhIcons.captionsOff,
              onTap: () => captions.shown.value = !shown,
              tooltip: shown ? l10n.subtitlesHide : l10n.subtitlesShow,
              active: shown,
              onLongPress: switch (captions.onOptions) {
                final open? => () => open(context),
                null => null,
              },
              longPressHint: l10n.mobileSubtitleOptions,
            ),
          ],
        );
      },
    );
  }
}

/// The language on screen as its short code; a tap moves to the next.
class _LanguageButton extends StatelessWidget {
  const _LanguageButton({required this.captions});

  final VhCaptions captions;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: context.vhl.subtitlesLanguage,
    child: Material(
      color: Colors.black.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(VhRadius.field - 1),
      child: InkWell(
        onTap: captions.nextLanguage,
        borderRadius: BorderRadius.circular(VhRadius.field - 1),
        child: SizedBox(
          height: 36,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: VhSpace.sm),
            child: Center(
              child: Text(
                (captions.current ?? '').split('-').first.toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: VhPalette.serverCardInk,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
