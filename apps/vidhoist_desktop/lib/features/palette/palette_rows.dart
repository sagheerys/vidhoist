import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_media/library.dart';
import 'package:vh_media/vh_media.dart' show vhFormatDuration;
import 'package:vh_transcripts/vh_transcripts.dart';
import 'package:vh_ui/vh_ui.dart';

import '../library/artwork.dart';
import 'palette_model.dart';

/// What the palette shows when nothing matches.
class PaletteEmpty extends StatelessWidget {
  const PaletteEmpty({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(VhSpace.lg),
    child: Text(
      context.vhl.noResults,
      style: Theme.of(context).textTheme.bodyMedium
          ?.copyWith(color: VhThemeX.of(context).palette.ink3),
    ),
  );
}

/// A kind of result's name above its rows.
class PaletteHeader extends StatelessWidget {
  const PaletteHeader(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(
      VhSpace.md,
      VhSpace.sm,
      VhSpace.md,
      VhSpace.xxs,
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelMedium
          ?.copyWith(color: VhThemeX.of(context).palette.ink3),
    ),
  );
}

/// Tells a screen reader which row the arrows reached: the focus stays in
/// the search field, so a moving highlight is otherwise silent.
void announceRow(BuildContext context, String said) => unawaited(
  SemanticsService.sendAnnouncement(
    View.of(context),
    said,
    Directionality.of(context),
  ),
);

/// A row the mouse can open too; to a screen reader, a button, and the
/// chosen one marked as selected.
class PaletteRowTap extends StatelessWidget {
  const PaletteRowTap({
    super.key,
    required this.onTap,
    this.selected = false,
    required this.child,
  });

  final VoidCallback onTap;
  final bool selected;
  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: InkWell(onTap: onTap, child: child),
  );
}

/// The frame of every row: the chosen one is drawn as the sidebar draws
/// the current place.
class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.selected,
    required this.child,
    this.lead,
  });

  final VhIconData icon;
  final bool selected;
  final Widget child;

  /// Drawn in place of the icon (a moment's time).
  final Widget? lead;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return Container(
      color: selected ? vhSelectedFill(p) : null,
      padding: const EdgeInsets.symmetric(
        horizontal: VhSpace.md,
        vertical: VhSpace.xs,
      ),
      child: Row(
        children: [
          lead ??
              VhIcon(
                icon,
                size: VhDensity.desktop.icon,
                color: selected ? p.ink : p.ink2,
              ),
          const SizedBox(width: VhSpace.sm),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// A clip's cover at the start of its row, as the phone's results show it.
/// The placeholder takes the same box, so the text lines up with or without
/// a cover.
class PaletteCover extends ConsumerWidget {
  const PaletteCover({super.key, required this.item});

  static const double width = 64;
  static const double height = 36;

  final LibraryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ExcludeSemantics(
    child: VhMediaThumb(
      width: width,
      height: height,
      audio: item.isAudio,
      child: artworkFor(
        ref,
        context,
        item.thumbnail,
        width: width,
        height: height,
      ),
    ),
  );
}

class TitleRow extends StatelessWidget {
  const TitleRow({super.key, required this.item, required this.selected});

  /// What the row says when the arrows reach it.
  static String spoken(VhLocalizations l, LibraryItem item) =>
      [item.title, ?item.uploader].join(l.listSeparator);

  final LibraryItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return _Row(
      icon: item.isAudio ? VhIcons.headphones : VhIcons.play,
      selected: selected,
      lead: PaletteCover(item: item),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.bodyMedium?.copyWith(color: p.ink),
          ),
          if (item.uploader case final uploader? when uploader.isNotEmpty)
            Text(
              uploader,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.labelSmall?.copyWith(color: p.ink3),
            ),
        ],
      ),
    );
  }
}

/// A moment: when it was said, the line with the query's words lit, and
/// the clip it is in.
class SaidRow extends StatelessWidget {
  const SaidRow({
    super.key,
    required this.match,
    required this.query,
    required this.selected,
  });

  final SaidMatch match;
  final String query;
  final bool selected;

  /// What the row says when the arrows reach it: when, what, and where.
  static String spoken(VhLocalizations l, SaidMatch match) => [
    vhFormatDuration(match.hit.start),
    match.hit.text,
    match.item.title,
  ].join(l.listSeparator);

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final line = match.hit.text;
    final base = text.bodyMedium?.copyWith(color: p.ink);
    var at = 0;
    final spans = <TextSpan>[];
    for (final (start, end) in SearchText.matchRanges(line, query)) {
      if (start > at) spans.add(TextSpan(text: line.substring(at, start)));
      spans.add(
        TextSpan(
          text: line.substring(start, end),
          style: TextStyle(color: p.accentInk, fontWeight: FontWeight.w700),
        ),
      );
      at = end;
    }
    if (at < line.length) spans.add(TextSpan(text: line.substring(at)));
    return _Row(
      icon: VhIcons.transcript,
      selected: selected,
      lead: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PaletteCover(item: match.item),
          const SizedBox(width: VhSpace.sm),
          // A time reads left to right in either language.
          Text(
            vhLtrRun(vhFormatDuration(match.hit.start)),
            style: text.labelMedium?.tabular.copyWith(
              color: p.accentInk,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(style: base, children: spans),
            textDirection: vhForeignLine(context, line).$1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            match.item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.labelSmall?.copyWith(color: p.ink3),
          ),
        ],
      ),
    );
  }
}

class CommandRow extends StatelessWidget {
  const CommandRow({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
  });

  final VhIconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return _Row(
      icon: icon,
      selected: selected,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: p.ink),
      ),
    );
  }
}
