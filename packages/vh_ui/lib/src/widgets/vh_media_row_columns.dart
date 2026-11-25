part of 'vh_media_row.dart';

/// Which columns a library table shows. Decided once from the width the
/// header and the rows share, so every column lines up under its title.
class VhMediaColumns {
  const VhMediaColumns({
    this.size = false,
    this.added = false,
    this.location = false,
    this.channel = false,
  });

  final bool size;
  final bool added;
  final bool location;

  /// **A wide table gives the channel its own column**, after the title,
  /// and holds the title to [titleMax]: a title column that took all the
  /// rest left a long empty stretch between a short title and its figures.
  /// What the held title leaves goes before the actions, which keep the
  /// row's far edge.
  final bool channel;

  static const double thumbWidth = 112;
  static const double thumbHeight = 63;

  // Text columns, and the title's limits, are measured at a text scale of
  // 1 and grow with the user's font, so a large font drops a column
  // instead of clipping the title.
  static const double _length = 56;
  static const double _size = 72;
  static const double _added = 112;
  static const double _location = 96;
  static const double _channel = 160;
  static const double _actions = 88;
  static const double _titleMin = 220;
  static const double _titleMax = 520;

  static double _gap(int count) => VhSpace.lg * count;

  /// The padding at each end of a row and of the header.
  static const double _padding = VhSpace.xs * 2;

  /// How wide the title may grow, for [scaler]'s text.
  static double titleMax(TextScaler scaler) => scaler.scale(_titleMax);

  /// The columns that fit [width], dropping the least useful first: the
  /// source (the site, also in the clip's details), then the date, then
  /// the size. Null when even the title would be squeezed below a readable
  /// width; the caller then keeps the phone's row.
  static VhMediaColumns? forWidth(
    double width,
    TextScaler scaler, {
    required bool location,
  }) {
    double s(double w) => scaler.scale(w);
    final least = s(_titleMin);
    var used = thumbWidth + s(_length) + _actions + _gap(3);
    if (width - used < least) return null;
    bool fits(double column) => width - used - s(column) - _gap(1) >= least;
    final size = fits(_size);
    if (size) used += s(_size) + _gap(1);
    final added = size && fits(_added);
    if (added) used += s(_added) + _gap(1);
    final source = location && added && fits(_location);
    if (source) used += s(_location) + _gap(1);
    // A held title leaves no slack to take the row's own padding, which
    // the title's whole-row cell otherwise absorbs.
    final channel =
        added &&
        width - used - s(_channel) - _gap(1) - _padding >= s(_titleMax);
    return VhMediaColumns(
      size: size,
      added: added,
      location: source,
      channel: channel,
    );
  }
}

/// The title's cell: the rest of the row, or no more than
/// [VhMediaColumns.titleMax] on a table wide enough for the channel.
Widget _titleCell(BuildContext context, VhMediaColumns columns, Widget child) {
  if (!columns.channel) return Expanded(child: child);
  final most = VhMediaColumns.titleMax(MediaQuery.textScalerOf(context));
  return SizedBox(width: most, child: child);
}

/// The cells after the title, shared by the header and the rows so the two
/// cannot drift apart.
List<Widget> _cells(
  BuildContext context,
  VhMediaColumns columns, {
  required Widget channel,
  required Widget length,
  required Widget size,
  required Widget added,
  required Widget location,
  required Widget actions,
}) {
  final scaler = MediaQuery.textScalerOf(context);
  Widget cell(double width, Widget child) => Padding(
    padding: const EdgeInsetsDirectional.only(start: VhSpace.lg),
    child: SizedBox(width: scaler.scale(width), child: child),
  );
  return [
    if (columns.channel) cell(VhMediaColumns._channel, channel),
    cell(VhMediaColumns._length, length),
    if (columns.size) cell(VhMediaColumns._size, size),
    if (columns.added) cell(VhMediaColumns._added, added),
    if (columns.location) cell(VhMediaColumns._location, location),
    if (columns.channel) const Spacer(),
    Padding(
      padding: const EdgeInsetsDirectional.only(start: VhSpace.lg),
      child: SizedBox(width: VhMediaColumns._actions, child: actions),
    ),
  ];
}

Widget _figure(String? value, TextStyle style) => Text(
  value == null ? '' : vhLtrRun(value),
  maxLines: 1,
  softWrap: false,
  overflow: TextOverflow.fade,
  textAlign: TextAlign.end,
  style: style,
);

/// The table columns a header can sort by.
enum VhTableColumn { title, size, added }

/// Sorting from the table's header, for a mouse: a click on a title sorts
/// by that column and a second click turns the order around.
class VhTableSort {
  const VhTableSort({
    required this.column,
    required this.ascending,
    required this.onSort,
  });

  /// The column the table is sorted by now, or null for none of them.
  final VhTableColumn? column;
  final bool ascending;
  final ValueChanged<VhTableColumn> onSort;
}

/// The titles over a library table.
class VhMediaRowHeader extends StatelessWidget {
  const VhMediaRowHeader({super.key, required this.columns, this.sort});

  final VhMediaColumns columns;

  /// Null keeps plain titles, as on a tablet, where sorting lives in its
  /// own sheet.
  final VhTableSort? sort;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l10n = context.vhl;
    final style = Theme.of(context).textTheme.labelSmall!
        .copyWith(color: p.ink3, letterSpacing: vhLabelTracking(context, 0.6));
    Text label(String text, {TextAlign align = TextAlign.start}) => Text(
      text,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.fade,
      textAlign: align,
      style: style,
    );
    Widget sortable(VhTableColumn column, Text text) {
      final by = sort;
      if (by == null) return text;
      final current = by.column == column;
      return Semantics(
        button: true,
        child: InkWell(
          onTap: () => by.onSort(column),
          borderRadius: BorderRadius.circular(VhCorners.desktop.box),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: text.textAlign == TextAlign.end
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Flexible(child: text),
              if (current)
                Transform.flip(
                  flipY: by.ascending,
                  child: VhIcon(
                    VhIcons.chevronDown,
                    size: VhSpace.md,
                    color: p.ink2,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(
        VhSpace.xs,
        VhSpace.xs,
        VhSpace.xs,
        VhSpace.sm,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: p.line2,
            width: VhThemeX.of(context).hairline,
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: VhMediaColumns.thumbWidth + VhSpace.lg),
          _titleCell(
            context,
            columns,
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: sortable(VhTableColumn.title, label(l10n.titleLabel)),
            ),
          ),
          ..._cells(
            context,
            columns,
            channel: label(l10n.columnChannel),
            length: label(l10n.columnLength, align: TextAlign.end),
            size: sortable(
              VhTableColumn.size,
              label(l10n.size, align: TextAlign.end),
            ),
            added: sortable(VhTableColumn.added, label(l10n.columnAdded)),
            location: label(l10n.source),
            actions: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// The source column: the site, when the row is given one.
class _SourceCell extends StatelessWidget {
  const _SourceCell({required this.name, required this.style});

  final String? name;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (name case final name?)
        Text(
          name,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.fade,
          style: style,
        ),
    ],
  );
}

class _Tag extends StatelessWidget {
  const _Tag(this.tag);

  final String tag;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: VhSpace.xs - 1),
      decoration: BoxDecoration(
        border: Border.all(
          color: p.line2,
          width: VhThemeX.of(context).hairline,
        ),
        borderRadius: BorderRadius.circular(VhRadius.thumb),
      ),
      child: Text(
        vhName('#$tag'),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(color: p.ink2),
      ),
    );
  }
}
