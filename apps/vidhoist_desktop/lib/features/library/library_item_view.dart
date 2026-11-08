import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_media/vh_media.dart' show vhFormatDuration;
import 'package:vh_ui/vh_ui.dart';

import '../../data/clip_handover.dart';
import '../../data/library_data.dart';
import '../../shell/context_menu.dart';
import 'artwork.dart';
import 'clip_keys.dart';
import 'item_menu.dart';
import 'platform_label.dart';
import 'choose_mark.dart';
import 'selection.dart';

/// One library item in the current layout: a grid card, a table row, or a
/// compact row. The shared vh_ui pieces draw it; this only says what to
/// show.
class LibraryItemView extends ConsumerWidget {
  const LibraryItemView({
    super.key,
    required this.item,
    required this.mode,
    required this.columns,
    required this.playing,
    required this.paused,
    required this.onPlay,
    this.selected = false,
    this.choosing = false,
    this.onChoose,
    this.onToggle,
  });

  final LibraryItem item;
  final LibraryViewMode mode;

  /// Set for a row of the table.
  final VhMediaColumns? columns;

  /// This is the clip in the player; [paused] says it is not running.
  final bool playing;
  final bool paused;
  final VoidCallback onPlay;

  /// Chosen in the list's selection: framed in the accent.
  final bool selected;

  /// Some clip of the list is chosen, so a click chooses too.
  final bool choosing;

  /// A click with Ctrl or Shift, or any click while [choosing]; a plain
  /// click, Enter and a screen reader play. Null plays on every click.
  final VoidCallback? onChoose;

  /// The round mark on the clip: adds it to the choice or takes it out.
  final VoidCallback? onToggle;

  /// The cover boxes of the grid and the compact row (`VhLibrarySliver`
  /// and `VhMediaCard`), for decoding at the size actually drawn.
  static const double _gridCell = 210;
  static const double _compactWidth = 64;

  /// A right click, or the menu key, opens the clip's menu; a drag carries
  /// its file out of the window; the menu's keys work on it when focused.
  @override
  Widget build(BuildContext context, WidgetRef ref) => MenuKey(
    onMenu: (at) =>
        unawaited(showItemMenu(context, ref, at, item, onPlay: onPlay)),
    child: ClipKeyArea(item: item, child: _rightClick(context, ref)),
  );

  Widget _rightClick(BuildContext context, WidgetRef ref) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    // Only the right click is caught here; left in, Flutter would offer a
    // screen reader a "tap" on the whole area that does nothing.
    excludeFromSemantics: true,
    onSecondaryTapUp: (d) => unawaited(
      showItemMenu(context, ref, d.globalPosition, item, onPlay: onPlay),
    ),
    child: ref.watch(clipDragProvider)(item, _framed(context, ref)),
  );

  Widget _framed(BuildContext context, WidgetRef ref) {
    if (onChoose == null) return _view(context, ref, onPlay);
    final p = VhThemeX.of(context).palette;
    return Listener(
      onPointerDown: (e) {
        if (e.buttons == kPrimaryButton) ClickClock.pointerDown();
      },
      child: ChooseMark(
        chosen: selected,
        choosing: choosing,
        onToggle: onToggle,
        child: Container(
          foregroundDecoration: selected
              ? BoxDecoration(
                  border: Border.all(color: p.accent, width: 2),
                  borderRadius: BorderRadius.circular(VhCorners.desktop.card),
                )
              : null,
          child: _view(
            context,
            ref,
            () => switch (ClickClock.activate(
              item.canonicalUrl,
              choosing: choosing,
            )) {
              ClickMeaning.play => onPlay(),
              ClickMeaning.choose => onChoose!(),
              ClickMeaning.none => null,
            },
          ),
        ),
      ),
    );
  }

  Widget _view(BuildContext context, WidgetRef ref, VoidCallback onTap) {
    final l = context.vhl;
    final subtitle = vhMetaLine([
      item.uploader,
      if (item.timestamp != null && columns?.added != true)
        vhTimeAgo(context, item.timestamp!),
    ]);
    // No mark of where a clip is: every clip is a file on this computer,
    // so "offline" beside each title would say nothing. The platform has
    // its own filter, so no coloured letters beside every title either.
    const platform = VhPlatformKind.other;
    final duration = item.duration == null
        ? null
        : vhFormatDuration(item.duration!);

    Future<void> toggleFavorite() async {
      await ref
          .read(tagsIndexProvider)
          .toggleTag(item.canonicalUrl, VhConstants.favoritesSystemTag);
      ref.invalidate(libraryItemsProvider);
    }

    void favorite() => unawaited(toggleFavorite());

    Widget? cover(double width, double height) =>
        artworkFor(ref, context, item.thumbnail, width: width, height: height);

    if (columns case final columns?) {
      return VhMediaRow(
        columns: columns,
        title: item.title,
        subtitle: subtitle,
        thumbnail: cover(VhMediaColumns.thumbWidth, VhMediaColumns.thumbHeight),
        platform: platform,
        duration: duration,
        size: item.sizeBytes == null ? null : vhFormatSize(item.sizeBytes!),
        added: item.timestamp == null
            ? null
            : vhTimeAgo(context, item.timestamp!),
        tags: item.tags,
        sourceName: platformLabel(l, MediaPlatform.detect(item.canonicalUrl)),
        favorite: item.favorite,
        audio: item.isAudio,
        highlighted: playing,
        paused: paused,
        onFavoriteToggle: favorite,
        onTap: onTap,
      );
    }
    if (mode == LibraryViewMode.grid) {
      return VhMediaGridCard(
        title: item.title,
        subtitle: subtitle,
        // The grid's widest cell, so a cover is never decoded too small.
        thumbnail: cover(_gridCell, _gridCell * 9 / 16),
        platform: platform,
        duration: duration,
        favorite: item.favorite,
        audio: item.isAudio,
        playing: playing,
        paused: paused,
        onFavoriteToggle: favorite,
        onTap: onTap,
      );
    }
    return VhMediaCard(
      compact: true,
      title: item.title,
      subtitle: subtitle,
      thumbnail: cover(_compactWidth, _compactWidth * 10 / 16),
      platform: platform,
      duration: duration,
      favorite: item.favorite,
      audio: item.isAudio,
      playing: playing,
      paused: paused,
      onFavoriteToggle: favorite,
      onTap: onTap,
    );
  }
}
