import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_media/library.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../router.dart';
import '../../shell/player_controls.dart';
import 'sort_button.dart';

/// The library's heading, **held at the top while the list scrolls**: the
/// title and counts, the sort, the figures and the layouts stay in reach
/// in the middle of a long library, as a file explorer's toolbar does.
/// The filters below it scroll away; two rows of chips held too would eat
/// the window.
///
/// A hairline comes in under it once something has scrolled beneath, so
/// the edge shows only when there is something to separate.
class PinnedLibraryHeading extends StatefulWidget {
  const PinnedLibraryHeading({super.key, required this.child});

  final Widget child;

  @override
  State<PinnedLibraryHeading> createState() => _PinnedLibraryHeadingState();
}

class _PinnedLibraryHeadingState extends State<PinnedLibraryHeading> {
  ScrollPosition? _position;
  bool _under = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (position == _position) return;
    _position?.removeListener(_onScroll);
    _position = position?..addListener(_onScroll);
  }

  void _onScroll() {
    final under = (_position?.pixels ?? 0) > 0;
    if (under != _under) setState(() => _under = under);
  }

  @override
  void dispose() {
    _position?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return AnimatedContainer(
      duration: vhMotionDuration(context, VhMotion.tap),
      curve: VhMotion.entrance,
      padding: const EdgeInsets.fromLTRB(
        VhSpace.xl,
        VhSpace.sm,
        VhSpace.xl,
        VhSpace.sm,
      ),
      decoration: BoxDecoration(
        color: p.bg,
        border: Border(
          bottom: BorderSide(
            color: _under ? p.line2 : p.line2.withValues(alpha: 0),
            width: VhThemeX.of(context).hairline,
          ),
        ),
      ),
      child: widget.child,
    );
  }
}

/// The title and its counts with the figures beside them, then the order
/// written out and the three layouts in one frame.
///
/// **Nothing here is a bare glyph that has to be hovered to be read.** Five
/// icons side by side (order, figures, three layouts) read as five
/// layouts: the figures sat between the order and the layouts. The figures
/// now stand by the count they break down, and the order says which it is.
class LibraryHeading extends StatelessWidget {
  const LibraryHeading({
    super.key,
    required this.title,
    required this.counts,
    required this.mode,
    required this.onMode,
    required this.sort,
    required this.onSort,
    this.tools = true,
    this.layouts = true,
  });

  final String title;
  final String? counts;
  final LibraryViewMode mode;
  final ValueChanged<LibraryViewMode> onMode;
  final LibrarySort sort;
  final ValueChanged<LibrarySort> onSort;

  /// The library holds clips: the figures and the order have something to
  /// work on.
  final bool tools;

  /// There is something to lay out, clips or clips on their way; an empty
  /// library offers no choice of how to show nothing.
  final bool layouts;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    // The title and its counts wrap under each other when the window or
    // the font leaves no room; the order and the layouts keep their place.
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Wrap(
              spacing: VhSpace.md,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Text(title, style: text.headlineSmall),
                if (counts case final line?)
                  Padding(
                    padding: const EdgeInsets.only(bottom: VhSpace.xxs),
                    child: Text(
                      line,
                      style: text.bodySmall?.copyWith(color: p.ink3),
                    ),
                  ),
                if (tools) const _FiguresLink(),
              ],
            ),
          ),
          // At its own width, and shortened only past two fifths of the
          // row: as a flexible share it was cut ("Sort b…") in a narrow
          // window with room to spare beside it.
          if (tools) ...[
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * .4),
              child: SortButton(sort: sort, onSort: onSort),
            ),
            const SizedBox(width: VhSpace.sm),
          ],
          if (layouts) _Layouts(mode: mode, onMode: onMode),
        ],
      ),
    );
  }
}

/// The figures, named, beside the count they break down: a page of their
/// own.
class _FiguresLink extends StatelessWidget {
  const _FiguresLink();

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l = context.vhl;
    return Padding(
      padding: const EdgeInsets.only(bottom: VhSpace.xxs / 2),
      child: Semantics(
        button: true,
        label: l.desktopStatsLink,
        excludeSemantics: true,
        child: InkWell(
          onTap: () => GoRouter.of(context).go(DesktopRoutes.stats),
          borderRadius: BorderRadius.circular(VhCorners.desktop.chip),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: VhSpace.xxs,
              vertical: VhSpace.xxs / 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                VhIcon(VhIcons.stats, size: VhSpace.md, color: p.ink3),
                const SizedBox(width: VhSpace.xxs),
                // Shortened, not spilled, where the heading is squeezed.
                Flexible(
                  child: Text(
                    l.desktopStatsLink,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(color: p.ink2),
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

/// The three layouts as one choice, in one hairline frame: three loose
/// glyphs beside the order read as three more buttons of the same kind.
class _Layouts extends StatelessWidget {
  const _Layouts({required this.mode, required this.onMode});

  final LibraryViewMode mode;
  final ValueChanged<LibraryViewMode> onMode;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l = context.vhl;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: p.line2,
          width: VhThemeX.of(context).hairline,
        ),
        borderRadius: BorderRadius.circular(VhCorners.desktop.field),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (m, icon, label) in [
            (LibraryViewMode.grid, VhIcons.grid, l.viewGrid),
            (LibraryViewMode.list, VhIcons.table, l.desktopViewTable),
            (LibraryViewMode.compact, VhIcons.list, l.desktopViewCompact),
          ])
            DesktopPlayerControl(
              icon: icon,
              label: label,
              selected: mode == m,
              onTap: () => onMode(m),
            ),
        ],
      ),
    );
  }
}

/// A sliver that fades in afresh whenever [value] changes: a new layout,
/// order or filter shows as the list arriving, not as a jump. Only the
/// incoming list fades, once; scrolling never animates anything.
class SliverFadeOnChange extends StatefulWidget {
  const SliverFadeOnChange({
    super.key,
    required this.value,
    required this.sliver,
  });

  final Object value;
  final Widget sliver;

  @override
  State<SliverFadeOnChange> createState() => _SliverFadeOnChangeState();
}

class _SliverFadeOnChangeState extends State<SliverFadeOnChange>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: VhMotion.reveal,
    value: 1,
  );
  late final _opacity = CurvedAnimation(
    parent: _controller,
    curve: VhMotion.entrance,
  );

  @override
  void didUpdateWidget(SliverFadeOnChange old) {
    super.didUpdateWidget(old);
    if (old.value == widget.value) return;
    if (MediaQuery.disableAnimationsOf(context)) return;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _opacity.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      SliverFadeTransition(opacity: _opacity, sliver: widget.sliver);
}
