import 'package:flutter/material.dart';
import 'package:vh_media/library.dart';
import 'package:vh_ui/vh_ui.dart';

export 'stats_breakdown.dart';

/// The library's figures in **one frame split by hairlines**, as many to a
/// row as fit. Four or five boxes of their own, each with its border and
/// corners, were one of the marks of a generated dashboard.
class StatsFigures extends StatelessWidget {
  const StatsFigures({super.key, required this.figures});

  final List<StatsTile> figures;

  /// Wide enough that five figures line up in two rows at most.
  static const double _minWidth = 160;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final rule = BorderSide(
      color: p.line,
      width: VhThemeX.of(context).hairline,
    );
    return LayoutBuilder(
      builder: (context, box) {
        final across = (box.maxWidth / _minWidth).floor().clamp(
          1,
          figures.length,
        );
        final rows = [
          for (var i = 0; i < figures.length; i += across)
            figures.sublist(i, (i + across).clamp(0, figures.length)),
        ];
        return DecoratedBox(
          decoration: BoxDecoration(
            color: p.card,
            borderRadius: BorderRadius.circular(VhCorners.desktop.card),
            border: Border.fromBorderSide(rule),
          ),
          child: Column(
            children: [
              for (final (r, row) in rows.indexed)
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(top: r == 0 ? BorderSide.none : rule),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var c = 0; c < across; c++)
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: BorderDirectional(
                                  start: c == 0 ? BorderSide.none : rule,
                                ),
                              ),
                              child: c < row.length
                                  ? row[c]
                                  : const SizedBox.shrink(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// One of the library's figures: the number large, what it counts beneath.
class StatsTile extends StatelessWidget {
  const StatsTile({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(VhSpace.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: text.headlineSmall?.tabular),
          const SizedBox(height: VhSpace.xxs),
          Text(label, style: text.labelMedium?.copyWith(color: p.ink3)),
        ],
      ),
    );
  }
}

/// What may deserve a look, with the first few clips it means; a click
/// opens a clip's page. Nothing is deleted from here.
class StatsSuggestion extends StatelessWidget {
  const StatsSuggestion({
    super.key,
    required this.title,
    required this.meta,
    required this.lead,
    required this.items,
    required this.detail,
    required this.onOpen,
  });

  final String title;

  /// How many, and how much room.
  final String meta;

  /// What the clips listed are: the largest, the newest.
  final String lead;
  final List<LibraryItem> items;
  final String? Function(LibraryItem) detail;
  final ValueChanged<LibraryItem> onOpen;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: VhSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: text.titleSmall?.copyWith(color: p.ink)),
          Text(meta, style: text.bodySmall?.copyWith(color: p.ink3)),
          const SizedBox(height: VhSpace.xs),
          Text(lead, style: text.labelSmall?.copyWith(color: p.ink3)),
          for (final item in items)
            Semantics(
              button: true,
              child: InkWell(
                onTap: () => onOpen(item),
                borderRadius: BorderRadius.circular(VhCorners.desktop.thumb),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: VhSpace.xs,
                    horizontal: VhSpace.xxs,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textDirection: vhTextDirectionOf(
                            item.title,
                            Directionality.of(context),
                          ),
                          style: text.bodyMedium?.copyWith(color: p.ink2),
                        ),
                      ),
                      if (detail(item) case final line?) ...[
                        const SizedBox(width: VhSpace.md),
                        Text(
                          line,
                          style: text.labelSmall?.tabular.copyWith(
                            color: p.ink3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
