import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;

import '../l10n/bidi.dart';
import '../l10n/l10n.dart';
import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import '../kit/vh_hover_lift.dart';
import 'vh_favorite.dart';
import 'vh_highlight_surface.dart';
import 'vh_media_grid_cover.dart';
import 'vh_platform_chip.dart';

/// The library card **led by its cover**: a 16:9 thumbnail first, with two
/// lines of title underneath. It serves two modes:
///
/// - **Grid**, the default: two columns, so a row shows twice what the
/// list shows and scanning video visually is far quicker.
/// - **Cards** ([feed], the YouTube pattern): one
/// column with a wide cover and larger text, for unhurried browsing.
///
/// **The two modes share the cover on purpose**: duration, favourite and
/// "more" all live over the thumbnail, and two copies of that would
/// diverge at the first edit. The only difference is the text sizes.
///
/// Presentation only, exactly like [VhMediaCard]: it knows nothing of the
/// downloads or an index.
class VhMediaGridCard extends StatelessWidget {
  const VhMediaGridCard({
    super.key,
    required this.title,
    this.thumbnail,
    this.duration,
    this.platform = VhPlatformKind.other,
    this.subtitle,
    this.selected = false,
    this.highlighted = false,
    this.playing = false,
    this.paused = false,
    this.favorite = false,
    this.audio = false,
    this.feed = false,
    this.onTap,
    this.onLongPress,
    this.onFavoriteToggle,
    this.onMore,
  });

  final String title;
  final Widget? thumbnail;
  final String? duration;
  final VhPlatformKind platform;
  final String? subtitle;
  final bool selected;
  final bool highlighted;
  final bool playing;

  /// [playing] means "this is the current item"; [paused] means it is
  /// suspended, so the indicator shows still instead of dancing over a clip
  /// that is not running.
  final bool paused;
  final bool favorite;

  /// An audio file: its cover carries a music-note mark.
  final bool audio;

  /// Cards mode: a single column, so there is room for larger text.
  final bool feed;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onMore;

  String _semanticsLabel(VhLocalizations l10n) => [
    title,
    ?subtitle,
    // The length is on the cover only, which the reader is not given.
    ?duration,
    if (audio) l10n.filterAudio,
    if (favorite) l10n.favorites,
    if (playing) l10n.nowPlaying,
  ].join(l10n.listSeparator);

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l10n = context.vhl;
    final text = Theme.of(context).textTheme;
    final (titleDirection, titleAlign) = vhForeignLine(context, title);

    // One node that is the button: its name, and the tap and focus of the
    // ink well beneath, which a split node had read out as an image. What
    // the card shows is in the name already, so the reader skips it; the
    // cover's own buttons stay apart, each with its own tap.
    return Semantics(
      container: true,
      button: onTap != null,
      selected: selected,
      label: _semanticsLabel(l10n),
      child: VhHoverLift(
        borderRadius: BorderRadius.circular(VhRadius.card),
        builder: (context, hovered) => VhHighlightSurface(
          selected: selected,
          highlighted: highlighted,
          borderRadius: BorderRadius.circular(VhRadius.card),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(VhRadius.card),
            onLongPress: onLongPress == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onLongPress!();
                  },
            child: Padding(
              padding: const EdgeInsets.all(VhSpace.xxs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  VhMediaGridCover(
                    hovered: hovered,
                    duration: duration,
                    playing: playing,
                    paused: paused,
                    favorite: favorite,
                    audio: audio,
                    onFavoriteToggle: onFavoriteToggle,
                    onMore: onMore,
                    child: thumbnail,
                  ),
                  SizedBox(height: feed ? VhSpace.sm : VhSpace.xs),
                  ExcludeSemantics(
                    child: Text(
                      title,
                      textDirection: titleDirection,
                      textAlign: titleAlign,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: (feed ? text.bodyMedium! : text.bodySmall!)
                          .copyWith(
                            color: p.ink,
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                          ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  ExcludeSemantics(
                    child: Row(
                      children: [
                        if (favorite && onFavoriteToggle == null)
                          const VhFavoriteMark(),
                        // No platform letters under the title: on a computer
                        // the pills above the grid say it, and a phone card
                        // carries one mark at most.
                        if (subtitle != null)
                          Flexible(
                            child: Text(
                              subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: (feed ? text.bodySmall! : text.labelSmall!)
                                  .copyWith(color: p.ink3),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
