import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../downloads_library/library_actions.dart';
import '../downloads_library/library_providers.dart';
import '../downloads_library/widgets/item_details_sheet.dart';
import '../player/playback_providers.dart';
import '../player/sidecar_subtitles.dart';
import 'audio_transcript.dart';

/// The full audio screen (`/audio`): the content comes from vh_media, and
/// the thumbnails and clip details from the app layer, since vh_media does
/// not know the library indexes.
class AudioScreen extends ConsumerWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handler = ref.watch(audioHandlerProvider);
    final library = ref.watch(localMediaProvider).valueOrNull ?? const [];
    // The subtitles beside each file, as the video player reads them: a
    // clip downloaded as sound brings them too, and a video heard as sound
    // keeps its own.
    final subtitles = ref.watch(subtitleCacheProvider);
    final language = ref.read(subtitleChoiceProvider).language;
    final label = context.vhl.mobileTranscript;
    Map<String, List<VhCaptionLine>>? tracksOf(PlaylistItem item) =>
        sidecarTracksFor(ref, subtitles, item);
    void open(PlaylistItem item, Map<String, List<VhCaptionLine>> tracks) =>
        unawaited(
          showPlayingTranscript(
            context,
            handler: handler,
            item: item,
            tracks: tracks,
            language: language,
          ),
        );

    return VhAudioScreen(
      handler: handler,
      artwork: artworkBuilderFor(ref),
      cover: coverBuilderFor(ref),
      // **No source chip** (field report 2026-09-04): "playing from your
      // device" carries no information here, because everything in the
      // library is on the device.
      showSourceChip: false,
      // **A details button instead of a queue button** (field report
      // 2026-09-05): the queue already has its visible button at the bottom
      // of
      // the screen.
      onDetails: () => _showDetails(context, ref, handler),
      extra: (item) => switch (tracksOf(item)) {
        final tracks? => VhExtraAction(
          icon: VhIcons.transcript,
          label: label,
          onTap: () => open(item, tracks),
        ),
        null => null,
      },
      // On a tall phone the line being said stands in for the button.
      peek: (item) => switch (tracksOf(item)) {
        final tracks? => TranscriptPeek(
          tracks: tracks,
          language: language,
          position: handler.positionStream,
          initial: handler.player.position,
          onOpen: () => open(item, tracks),
        ),
        null => null,
      },
      companion: (item) => switch (tracksOf(item)) {
        final tracks? => VhVideoPanel(
          icon: VhIcons.transcript,
          label: label,
          builder: (context, _) => PlayingTranscript(
            key: ValueKey(item.canonicalUrl),
            handler: handler,
            clip: item.canonicalUrl,
            tracks: tracks,
            language: language,
            closeWhenMoved: false,
          ),
        ),
        null => null,
      },
      // The one-tap heart lives here and in the video player; the library
      // cards show it on favourites alone.
      isFavorite: (item) => library.any(
        (candidate) => candidate.key == item.canonicalUrl && candidate.favorite,
      ),
      onFavorite: (item) =>
          ref.read(libraryActionsProvider).toggleFavorite(item.canonicalUrl),
    );
  }

  void _showDetails(
    BuildContext context,
    WidgetRef ref,
    VhAudioHandler handler,
  ) {
    final key = handler.currentItem?.canonicalUrl;
    if (key == null) return;
    final items = ref.read(localMediaProvider).valueOrNull ?? const [];
    for (final candidate in items) {
      if (candidate.key == key) {
        showItemDetailsSheet(context, candidate);
        return;
      }
    }
  }
}
