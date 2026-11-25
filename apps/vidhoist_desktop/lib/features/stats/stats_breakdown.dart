import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

/// One row of a breakdown: its name, the amount its bar is drawn to, and
/// that amount as words.
typedef StatsBar = ({String label, int measure, String value});

/// **A breakdown as bars**, one series in the accent: the name, a thin bar
/// against the largest, and the figures in ink beside it. The figures are
/// the reading; the bar only shows proportion, so the rows are a table to a
/// screen reader too.
///
/// **The bar gives way, not the figures.** In thirds, the figures were the
/// first cut ("462.…") with a large font while the names kept more room
/// than the longest of them. Now the names take the longest name, the
/// figures their whole width, and the bar what is left, every bar starting
/// at the same place.
class StatsBars extends StatelessWidget {
  const StatsBars({super.key, required this.rows});

  final List<StatsBar> rows;

  /// The shortest a bar gets before the names give up room instead.
  static const double _leastBar = VhSpace.xxl * 2;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final nameStyle = text.bodyMedium?.copyWith(color: p.ink);
    final valueStyle = text.labelMedium?.tabular.copyWith(color: p.ink2);
    final largest = rows.fold(1, (most, r) => math.max(most, r.measure));
    return LayoutBuilder(
      builder: (context, constraints) {
        final room = constraints.maxWidth - VhSpace.md * 2 - _leastBar;
        final value = math.min(
          _widest(context, [for (final r in rows) r.value], valueStyle),
          room / 2,
        );
        final name = math.max(
          0.0,
          math.min(
            _widest(context, [for (final r in rows) r.label], nameStyle),
            room - value,
          ),
        );
        return Column(
          children: [
            for (final row in rows)
              Semantics(
                label: '${row.label}: ${row.value}',
                excludeSemantics: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: VhSpace.xs),
                  child: Row(
                    children: [
                      SizedBox(
                        width: name,
                        child: Text(
                          row.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textDirection: vhTextDirectionOf(
                            row.label,
                            Directionality.of(context),
                          ),
                          textAlign: TextAlign.start,
                          style: nameStyle,
                        ),
                      ),
                      const SizedBox(width: VhSpace.md),
                      Expanded(child: _Bar(share: row.measure / largest)),
                      const SizedBox(width: VhSpace.md),
                      SizedBox(
                        width: value,
                        child: Text(
                          row.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: valueStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// The width of the widest of [texts] at the user's font, rounded up so
  /// that the widest is not cut by a fraction of a point.
  static double _widest(
    BuildContext context,
    List<String> texts,
    TextStyle? style,
  ) {
    var most = 0.0;
    for (final t in texts) {
      final painter = TextPainter(
        text: TextSpan(text: t, style: style),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: 1,
      )..layout();
      most = math.max(most, painter.width.ceilToDouble() + 1);
      painter.dispose();
    }
    return most;
  }
}

/// A thin bar on a quiet track, rounded at both ends, grown from the start.
class _Bar extends StatelessWidget {
  const _Bar({required this.share});

  final double share;

  static const double _thickness = 6;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final round = BorderRadius.circular(_thickness / 2);
    return Container(
      height: _thickness,
      decoration: BoxDecoration(color: p.cardAlt, borderRadius: round),
      alignment: AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
        // Never thinner than its own height, so a small share still shows.
        widthFactor: share.clamp(0, 1),
        child: Container(
          constraints: const BoxConstraints(minWidth: _thickness),
          decoration: BoxDecoration(color: p.accent, borderRadius: round),
        ),
      ),
    );
  }
}
