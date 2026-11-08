import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;

import '../icons/vh_icon.dart';
import '../icons/vh_icons.dart';
import '../l10n/bidi.dart';
import '../l10n/l10n.dart';
import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import 'vh_desktop_app.dart';
import 'vh_favorite.dart';
import 'vh_highlight_surface.dart';
import 'vh_equalizer.dart';
import 'vh_media_thumb.dart';
import 'vh_platform_chip.dart';
import 'vh_polish.dart';

part 'vh_media_row_columns.dart';

/// A library item as a table row, for a tablet: the details a phone hides
/// in the item's sheet sit in their own columns. Presentation only, like
/// [VhMediaCard], whose taps and selection it repeats.
class VhMediaRow extends StatelessWidget {
  const VhMediaRow({
    super.key,
    required this.columns,
    required this.title,
    this.thumbnail,
    this.duration,
    this.size,
    this.added,
    this.platform = VhPlatformKind.other,
    this.subtitle,
    this.tags = const [],
    this.sourceName,
    this.selected = false,
    this.highlighted = false,
    this.paused,
    this.favorite = false,
    this.audio = false,
    this.onTap,
    this.onLongPress,
    this.onFavoriteToggle,
    this.onMore,
  });

  final VhMediaColumns columns;
  final String title;
  final Widget? thumbnail;
  final String? duration;
  final String? size;

  /// When the item arrived, shown in its own column when there is room.
  /// The caller leaves it out of [subtitle] in that case.
  final String? added;
  final VhPlatformKind platform;
  final String? subtitle;

  /// Shown under the title only on the widest table, beside the date.
  final List<String> tags;

  /// The site the clip came from, for the source column on the computer's
  /// table. Null (the phones) leaves that column empty.
  final String? sourceName;
  final bool selected;
  final bool highlighted;

  /// The playing row's bars by the heart, still when true; null (the
  /// phones) draws none.
  final bool? paused;
  final bool favorite;
  final bool audio;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onMore;

  String _semanticsLabel(VhLocalizations l10n) => [
    title,
    ?subtitle,
    ?duration,
    if (columns.size) ?size,
    if (columns.added) ?added,
    if (columns.location) ?sourceName,
    // The tags the row shows beside the source.
    if (columns.added)
      for (final tag in tags.take(3)) vhName('#$tag'),
    if (audio) l10n.filterAudio,
    if (favorite) l10n.favorites,
  ].join(l10n.listSeparator);

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l10n = context.vhl;
    final text = Theme.of(context).textTheme;
    final small = text.bodySmall!.copyWith(color: p.ink3);
    final figure = text.bodySmall!.copyWith(color: p.ink2);
    final (titleDirection, titleAlign) = vhForeignLine(context, title);
    final showTags = columns.added && tags.isNotEmpty;

    // One node that is the button, with the ink well's tap and focus; the
    // cells are in its name, so the reader skips them, and the buttons at
    // the end stay apart, each with its own tap.
    return Semantics(
      container: true,
      button: onTap != null,
      selected: selected,
      label: _semanticsLabel(l10n),
      child: VhHighlightSurface(
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
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: VhSpace.sm,
              horizontal: VhSpace.xs,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: p.line,
                  width: VhThemeX.of(context).hairline,
                ),
              ),
            ),
            child: Row(
              children: [
                ExcludeSemantics(
                  child: VhMediaThumb(
                    width: VhMediaColumns.thumbWidth,
                    height: VhMediaColumns.thumbHeight,
                    audio: audio,
                    child: thumbnail,
                  ),
                ),
                const SizedBox(width: VhSpace.lg),
                Expanded(
                  child: ExcludeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          textDirection: titleDirection,
                          textAlign: titleAlign,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: VhSpace.xxs),
                        Row(
                          children: [
                            // A favourite's mark where nothing toggles it
                            // here (phones); see [VhFavoriteMark].
                            if (favorite && onFavoriteToggle == null)
                              const VhFavoriteMark(),
                            // The platform letters stay on the computer's
                            // table; a phone row carries one mark at most
                            // (log §4, 2026-11-01), and the platform is in
                            // the details and the filter sheet.
                            if (platform != VhPlatformKind.other &&
                                VhDesktopApp.isDesktop(context)) ...[
                              VhPlatformChip(kind: platform),
                              const SizedBox(width: VhSpace.xxs),
                            ],
                            if (subtitle case final subtitle?
                                when subtitle.isNotEmpty)
                              Flexible(
                                child: Text(
                                  subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: small,
                                ),
                              ),
                            // Flexible, so with large text the tags shorten
                            // to an ellipsis instead of pushing out the row.
                            if (showTags)
                              for (final tag in tags.take(3))
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      start: VhSpace.xs,
                                    ),
                                    child: _Tag(tag),
                                  ),
                                ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ..._cells(
                  context,
                  columns,
                  length: ExcludeSemantics(child: _figure(duration, figure)),
                  size: ExcludeSemantics(child: _figure(size, figure)),
                  added: ExcludeSemantics(
                    child: Text(
                      added ?? '',
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: figure,
                    ),
                  ),
                  location: ExcludeSemantics(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: _SourceCell(name: sourceName, style: figure),
                    ),
                  ),
                  actions: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if ((highlighted, paused) case (true, final still?))
                        Padding(
                          padding: const EdgeInsets.all(VhSpace.xs),
                          child: VhEqualizer(animate: !still),
                        ),
                      if (onFavoriteToggle != null)
                        IconButton(
                          tooltip: favorite
                              ? l10n.removeFromFavorites
                              : l10n.addToFavorites,
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            onFavoriteToggle!();
                          },
                          visualDensity: VisualDensity.compact,
                          icon: VhIconSwap(
                            icon: favorite
                                ? VhIcons.favoriteOn
                                : VhIcons.favorite,
                            size: 20,
                            color: favorite ? p.favorite : p.ink3,
                          ),
                        ),
                      if (onMore != null)
                        IconButton(
                          tooltip: l10n.itemOptions,
                          onPressed: onMore,
                          visualDensity: VisualDensity.compact,
                          icon: VhIcon(
                            VhIcons.moreVert,
                            size: 20,
                            color: p.ink3,
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
    );
  }
}
