import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

/// The library while its first answer is on the way: **flat grey cards at
/// the size the real ones will have**, so the page has its shape at once
/// and nothing jumps when the clips land. They breathe together while they
/// wait ([VhSkeletonPulse]); no light sweeps across them, a moving light on
/// a placeholder being one of the marks of a generated screen.
class LibrarySkeleton extends StatelessWidget {
  const LibrarySkeleton({super.key, this.count = 8});

  final int count;

  /// About the width of a grid card at the usual window size.
  static const double _card = 220;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    Widget bar(double width, double height) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: p.cardAlt,
        borderRadius: BorderRadius.circular(VhCorners.desktop.box),
      ),
    );
    return Semantics(
      label: context.vhl.desktopLibraryLoading,
      child: ExcludeSemantics(
        child: VhSkeletonPulse(
          child: Wrap(
            spacing: VhSpace.lg,
            runSpacing: VhSpace.xl,
            children: [
              for (var i = 0; i < count; i++)
                SizedBox(
                  width: _card,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: _card * 9 / 16,
                        decoration: BoxDecoration(
                          color: p.cardAlt,
                          borderRadius: BorderRadius.circular(
                            VhCorners.desktop.thumb,
                          ),
                        ),
                      ),
                      const SizedBox(height: VhSpace.sm),
                      bar(_card * 0.85, VhSpace.sm),
                      const SizedBox(height: VhSpace.xs),
                      bar(_card * 0.5, VhSpace.xs),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
