import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import '../models/play_mode.dart';
import '../widgets/media_time.dart';
import '../widgets/vh_chapter_label.dart';
import '../widgets/vh_chapters.dart';
import '../widgets/vh_extra_button.dart';
import '../widgets/vh_player_controls_row.dart';
import '../widgets/vh_progress_slider.dart';
import 'vh_video_session.dart';
import 'video_buttons.dart';
import 'caption_buttons.dart';
import 'vh_captions.dart';
import 'vh_picture_in_picture.dart';

/// The top bar: back, the title and its position in the list, speed, lock,
/// full screen.
class VhVideoTopBar extends StatelessWidget {
  const VhVideoTopBar({
    super.key,
    required this.session,
    required this.onBack,
    required this.onToggleFullscreen,
    required this.fullscreen,
    this.onLock,
    this.playlistName,
    this.membershipLine,
    this.captions,
  });

  final VhVideoSession session;
  final VoidCallback onBack;

  /// Gives a CC button that shows and hides the subtitles; null for a clip
  /// without any.
  final VhCaptions? captions;
  final VoidCallback onToggleFullscreen;
  final bool fullscreen;
  final VoidCallback? onLock;
  final String? playlistName;

  /// **Where the clip belongs**: which tag it is under, or which playlist
  /// it was added to. Built in the app and shown
  /// under the title in landscape, where there is no info sheet at all.
  final String? membershipLine;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final text = Theme.of(context).textTheme;
    final item = session.current;
    final subtitleParts = [
      if (playlistName != null) '«$playlistName»',
      if (session.items.length > 1)
        vhLtrRun(
          l10n.playlistOf(session.currentIndex + 1, session.items.length),
        ),
      ?membershipLine,
    ];

    return Row(
      children: [
        VhVideoIconButton(
          icon: fullscreen ? VhIcons.back : VhIcons.chevronDown,
          onTap: onBack,
          tooltip: l10n.dismiss,
        ),
        const SizedBox(width: VhSpace.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              VhForeignText(
                item?.title ?? '',
                maxLines: 1,
                style: text.titleMedium!.copyWith(
                  color: VhPalette.serverCardInk,
                  fontSize: 13.5,
                ),
              ),
              if (subtitleParts.isNotEmpty)
                Text(
                  subtitleParts.join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelSmall!.copyWith(
                    color: VhPalette.serverCardInk.withValues(alpha: 0.45),
                  ),
                ),
            ],
          ),
        ),
        if (captions case final captions?) ...[
          const SizedBox(width: VhSpace.xs),
          VhCaptionButtons(captions: captions),
        ],
        // Only once the user has turned picture in picture on.
        ValueListenableBuilder(
          valueListenable: VhPictureInPicture.instance.enabled,
          builder: (context, on, _) => on
              ? Padding(
                  padding: const EdgeInsetsDirectional.only(start: VhSpace.xs),
                  child: VhVideoIconButton(
                    icon: VhIcons.pip,
                    onTap: () => VhPictureInPicture.instance.enter(
                      aspect: vhPictureShape(session),
                    ),
                    tooltip: l10n.pictureInPicture,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(width: VhSpace.xs),
        VhVideoSpeedButton(session: session),
        const SizedBox(width: VhSpace.xs),
        if (onLock != null) ...[
          VhVideoIconButton(
            icon: VhIcons.lock,
            onTap: onLock!,
            tooltip: l10n.lockTouch,
          ),
          const SizedBox(width: VhSpace.xs),
        ],
        VhVideoIconButton(
          icon: fullscreen ? VhIcons.collapse : VhIcons.fullscreen,
          onTap: onToggleFullscreen,
          tooltip: fullscreen ? l10n.exitFullscreen : l10n.enterFullscreen,
        ),
      ],
    );
  }
}

/// The bottom bar: progress, times, play modes and the queue button.
class VhVideoBottomBar extends StatelessWidget {
  const VhVideoBottomBar({
    super.key,
    required this.session,
    required this.onQueue,
    this.compactModes = false,
    this.extra,
    this.chapters = const [],
    this.onChapters,
  });

  final VhVideoSession session;
  final VoidCallback onQueue;
  final bool compactModes;

  /// A button the app adds before the queue button.
  final VhExtraAction? extra;

  /// The clip's chapters: cuts in the track, and the one playing beside
  /// the time, which opens the list through [onChapters].
  final List<VhChapter> chapters;
  final VoidCallback? onChapters;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final text = Theme.of(context).textTheme;
    final inkMuted = VhPalette.serverCardInk.withValues(alpha: 0.85);
    final value = session.controller?.value;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VhProgressSlider(
          position: session.position,
          duration: session.duration,
          buffered: value == null || value.buffered.isEmpty
              ? null
              : value.buffered.last.end,
          dark: true,
          showRemaining: false,
          marks: [for (final chapter in chapters) chapter.start],
          onSeek: session.seek,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: VhSpace.sm),
          child: Row(
            children: [
              Text(
                // Isolated left to right: in an Arabic line the pair read
                // "3:02 / 1:20", the length before the position (field
                // report 2026-10-04).
                vhLtrRun(
                  '${vhFormatDuration(session.position)} / '
                  '${vhFormatDuration(session.duration ?? Duration.zero)}',
                ),
                // A counter live on every frame. Without fixed-width digits
                // the text stretches and shrinks and the whole line dances
                // (review 2026-09-02).
                style: text.labelSmall!.copyWith(color: inkMuted).tabular,
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: chapters.isEmpty || onChapters == null
                      ? null
                      : VhChapterLabel(
                          chapters: chapters,
                          position: session.position,
                          onTap: onChapters!,
                        ),
                ),
              ),
              VhVideoIconButton(
                icon: vhPlayModeIcon(session.playMode),
                onTap: () => session.setPlayMode(session.playMode.next),
                tooltip: vhPlayModeLabel(context, session.playMode),
                size: 32,
                active: session.playMode != PlayMode.autoNext,
              ),
              const SizedBox(width: VhSpace.xxs + 2),
              VhVideoIconButton(
                icon: VhIcons.shuffle,
                onTap: () => session.setShuffle(!session.shuffleEnabled),
                tooltip: l10n.shuffle,
                size: 32,
                active: session.shuffleEnabled,
              ),
              if (extra case final extra?) ...[
                const SizedBox(width: VhSpace.xxs + 2),
                // In the style of its neighbours: beside repeat and shuffle,
                // which light up when on, a filled button read as switched
                // on.
                VhVideoIconButton(
                  icon: extra.icon,
                  onTap: extra.onTap,
                  tooltip: extra.label,
                  size: 32,
                ),
              ],
              const SizedBox(width: VhSpace.xxs + 2),
              VhVideoIconButton(
                icon: VhIcons.queue,
                onTap: onQueue,
                tooltip: l10n.queueLabel,
                size: 32,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
