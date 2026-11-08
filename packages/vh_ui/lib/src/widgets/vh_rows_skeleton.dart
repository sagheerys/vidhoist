import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import 'vh_media_row.dart';
import 'vh_skeleton_pulse.dart';

/// The phone library while its first answer is on the way: **flat grey
/// rows the size of the real ones**, so the page has its shape at once and
/// nothing jumps when the clips land. A spinner in the middle of an empty
/// page gave way to a list in one frame. The rows breathe together while
/// they wait ([VhSkeletonPulse]), as the Windows app's own skeleton does;
/// no light sweeps across them.
class VhRowsSkeleton extends StatelessWidget {
  const VhRowsSkeleton({super.key, this.count = 6});

  final int count;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final hairline = VhThemeX.of(context).hairline;
    Widget block(double? width, double height, double radius) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: p.cardAlt,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    return SliverToBoxAdapter(
      child: Semantics(
        label: context.vhl.desktopLibraryLoading,
        child: ExcludeSemantics(
          child: VhSkeletonPulse(
            child: Column(
              children: [
                for (var i = 0; i < count; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: VhSpace.sm,
                      horizontal: VhSpace.xs,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: p.line, width: hairline),
                      ),
                    ),
                    child: Row(
                      children: [
                        block(
                          VhMediaColumns.thumbWidth,
                          VhMediaColumns.thumbHeight,
                          VhRadius.thumb,
                        ),
                        const SizedBox(width: VhSpace.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Rows of different lengths, as titles are.
                              FractionallySizedBox(
                                widthFactor: i.isEven ? 0.85 : 0.65,
                                child: block(null, VhSpace.md, VhRadius.chip),
                              ),
                              const SizedBox(height: VhSpace.sm),
                              FractionallySizedBox(
                                widthFactor: 0.4,
                                child: block(null, VhSpace.sm, VhRadius.chip),
                              ),
                            ],
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
