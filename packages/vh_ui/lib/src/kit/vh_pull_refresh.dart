import 'package:flutter/material.dart';

import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import '../widgets/vh_polish.dart';
import 'vh_progress.dart';

/// Pull to refresh with the app's ring: the ring with its gap and ember
/// at the top of the list, turning while the refresh runs, with no floating
/// disc beneath it. Faint while the pull has not yet gone far enough, whole
/// once letting go would refresh.
class VhPullRefresh extends StatefulWidget {
  const VhPullRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
    this.semanticsLabel,
  });

  final RefreshCallback onRefresh;
  final Widget child;
  final String? semanticsLabel;

  @override
  State<VhPullRefresh> createState() => _VhPullRefreshState();
}

class _VhPullRefreshState extends State<VhPullRefresh> {
  RefreshIndicatorStatus? _status;

  double get _opacity => switch (_status) {
    RefreshIndicatorStatus.drag => 0.45,
    RefreshIndicatorStatus.armed ||
    RefreshIndicatorStatus.snap ||
    RefreshIndicatorStatus.refresh => 1,
    _ => 0,
  };

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      RefreshIndicator.noSpinner(
        onRefresh: widget.onRefresh,
        semanticsLabel: widget.semanticsLabel,
        onStatusChange: (status) {
          if (mounted) setState(() => _status = status);
        },
        child: widget.child,
      ),
      PositionedDirectional(
        top: VhSpace.md,
        start: 0,
        end: 0,
        child: IgnorePointer(
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: vhMotionDuration(context, VhMotion.tap),
            // Hidden, the ring stops turning rather than spin unseen.
            child: TickerMode(
              enabled: _opacity > 0,
              child: Center(
                // A flat patch of the ground under the ring, no shadow and
                // no lift: over a chip's label the bare ring blurred into
                // the letters.
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: VhThemeX.of(context).palette.bg,
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(VhSpace.xs + 2),
                    child: VhSpinner(size: 28),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
