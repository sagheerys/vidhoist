import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../icons/vh_icon.dart';
import '../icons/vh_icon_data.dart';
import '../icons/vh_icons.dart';
import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import '../widgets/vh_desktop_app.dart';
import '../widgets/vh_polish.dart';
import '../widgets/vh_route_motion.dart';

/// What a notice reports, which sets its colour.
enum VhNoticeKind { done, failed, info }

/// The app's notice at the foot of the window. The state is **a bar on the
/// edge**, not a coloured circle; the icon says the action itself (a check,
/// a cross, a copy); and a line along the bottom shrinks until the notice
/// leaves, so the user can see how long it will stay.
void showVhNotice(
  BuildContext context, {
  required String message,
  VhNoticeKind kind = VhNoticeKind.info,
  VhIconData? icon,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 4),
  double raise = 0,
}) {
  final p = VhThemeX.of(context).palette;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: duration,
        margin: _desktopPlace(context, raise),
        padding: EdgeInsets.zero,
        backgroundColor: p.miniBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VhCorners.desktop.card),
        ),
        content: VhNotice(
          message: message,
          kind: kind,
          icon: icon,
          actionLabel: actionLabel,
          onAction: onAction,
          duration: duration,
        ),
      ),
      // At the app's pace: in as a page comes, out as quickly as a hover.
      snackBarAnimationStyle: VhDesktopApp.isDesktop(context)
          ? AnimationStyle(
              duration: vhMotionDuration(context, VhMotion.page),
              reverseDuration: vhMotionDuration(context, VhMotion.fast),
            )
          : vhNoticeMotion(still: MediaQuery.disableAnimationsOf(context)),
    );
}

/// **On the computer, a card in the corner**, the width of a sentence and
/// above the player bar. Across the whole window it ran from edge to edge
/// over the play button, far longer than anything it says. Null on a
/// phone, which keeps its own. [raise] lifts it further, over something
/// else at the foot of the page that it would cover.
EdgeInsets? _desktopPlace(BuildContext context, double raise) {
  final lift = VhDesktopApp.noticeLiftOf(context);
  if (lift == null) return null;
  final width = MediaQuery.sizeOf(context).width;
  final away = math.max(VhSpace.xl, width - VhNotice.desktopWidth - VhSpace.xl);
  // Resolved here, in the page's direction: the messenger that lays the
  // notice out sits above the app's language and reads it as left to
  // right, which put an Arabic notice over the sidebar.
  final rtl = Directionality.of(context) == TextDirection.rtl;
  return EdgeInsets.only(
    left: rtl ? VhSpace.xl : away,
    right: rtl ? away : VhSpace.xl,
    bottom: lift + raise + VhSpace.sm,
  );
}

class VhNotice extends StatelessWidget {
  const VhNotice({
    super.key,
    required this.message,
    this.kind = VhNoticeKind.info,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.duration = const Duration(seconds: 4),
  });

  final String message;
  final VhNoticeKind kind;

  /// Defaults to a check for done, a cross for failed, nothing for info.
  final VhIconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// How long the bottom line takes to run out.
  final Duration duration;

  /// The widest a notice gets on the computer.
  static const double desktopWidth = 400;

  static Color stateColor(VhPalette p, VhNoticeKind kind) => switch (kind) {
    VhNoticeKind.done => p.ok,
    VhNoticeKind.failed => p.err,
    VhNoticeKind.info => p.accent,
  };

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final state = stateColor(p, kind);
    final shown =
        icon ??
        switch (kind) {
          VhNoticeKind.done => VhIcons.check,
          VhNoticeKind.failed => VhIcons.close,
          VhNoticeKind.info => null,
        };
    final text = Theme.of(context).textTheme;
    final desktop = VhDesktopApp.isDesktop(context);
    final corners = desktop ? VhCorners.desktop : VhCorners.mobile;
    return ClipRRect(
      borderRadius: BorderRadius.circular(corners.card),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              VhSpace.lg,
              VhSpace.sm,
              VhSpace.sm,
              VhSpace.md,
            ),
            child: Row(
              children: [
                if (shown != null) ...[
                  VhIcon(shown, size: 18, color: state),
                  const SizedBox(width: VhSpace.sm),
                ],
                Expanded(
                  child: Text(
                    message,
                    style: text.bodyMedium!.copyWith(
                      color: p.miniInk,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (actionLabel != null)
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
                      onAction?.call();
                    },
                    // Sized for a pointer on the computer: Material's
                    // 48-point touch target would make a notice with an
                    // action taller than one without. A finger keeps it.
                    style: TextButton.styleFrom(
                      foregroundColor: p.night ? p.accentInk : p.accent,
                      textStyle: text.labelLarge,
                      tapTargetSize: desktop
                          ? MaterialTapTargetSize.shrinkWrap
                          : MaterialTapTargetSize.padded,
                      minimumSize: desktop ? Size.zero : null,
                      padding: const EdgeInsets.symmetric(
                        horizontal: VhSpace.sm,
                      ),
                    ),
                    child: Text(actionLabel!),
                  ),
              ],
            ),
          ),
          // The state bar on the leading edge.
          PositionedDirectional(
            start: 0,
            top: VhSpace.sm,
            bottom: VhSpace.sm,
            child: Container(
              key: const ValueKey('state-bar'),
              width: 3,
              decoration: BoxDecoration(
                color: state,
                borderRadius: BorderRadiusDirectional.horizontal(
                  end: Radius.circular(corners.box / 2),
                ),
              ),
            ),
          ),
          // The time left, running out towards the start.
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1, end: 0),
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : duration,
              builder: (context, left, _) => Align(
                alignment: AlignmentDirectional.centerStart,
                child: FractionallySizedBox(
                  key: const ValueKey('time-left'),
                  widthFactor: left,
                  child: Container(
                    height: 1.5,
                    color: state.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
