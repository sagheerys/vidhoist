import 'package:flutter/material.dart';

import '../tokens/tokens.dart';
import 'vh_desktop_app.dart';

/// Sheets, dialogs and notices on the phones move at the app's own pace
/// rather than Flutter's: they come in on the entrance curve and leave
/// faster than they came. The computer keeps what it has.
///
/// Null on the computer; no motion at all when the system asks for none.
AnimationStyle? vhSheetMotion(BuildContext context) {
  if (VhDesktopApp.isDesktop(context)) return null;
  if (MediaQuery.disableAnimationsOf(context)) {
    return AnimationStyle.noAnimation;
  }
  return const AnimationStyle(
    duration: VhMotion.medium,
    reverseDuration: VhMotion.leave,
    curve: VhMotion.entrance,
    reverseCurve: VhMotion.exit,
  );
}

/// The notice at the foot of a phone screen: in with a page, out quickly.
AnimationStyle vhNoticeMotion({required bool still}) => still
    ? AnimationStyle.noAnimation
    : const AnimationStyle(
        duration: VhMotion.page,
        reverseDuration: VhMotion.fast,
      );

/// Every bottom sheet in the phone apps goes through here, so none of them
/// rises at Flutter's default pace.
Future<T?> showVhSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool useSafeArea = false,
  BoxConstraints? constraints,
  bool? showDragHandle,
  Color? barrierColor,
}) => showModalBottomSheet<T>(
  context: context,
  builder: builder,
  isScrollControlled: isScrollControlled,
  useRootNavigator: useRootNavigator,
  useSafeArea: useSafeArea,
  constraints: constraints,
  showDragHandle: showDragHandle,
  barrierColor: barrierColor,
  sheetAnimationStyle: vhSheetMotion(context),
);

/// Every dialog in the phone apps goes through here: it grows a little
/// from [VhMotion.recede] as it fades in, and goes back faster. The
/// computer keeps Flutter's dialog.
Future<T?> showVhDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  if (VhDesktopApp.isDesktop(context)) {
    return showDialog<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
    );
  }
  final navigator = Navigator.of(context, rootNavigator: true);
  return navigator.push<T>(
    _VhDialogRoute<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: DialogTheme.of(context).barrierColor ?? Colors.black54,
      themes: InheritedTheme.capture(from: context, to: navigator.context),
      still: MediaQuery.disableAnimationsOf(context),
    ),
  );
}

class _VhDialogRoute<T> extends DialogRoute<T> {
  _VhDialogRoute({
    required super.context,
    required super.builder,
    required super.barrierDismissible,
    required super.barrierColor,
    required super.themes,
    required this.still,
  }) : super(
         animationStyle: still
             ? AnimationStyle.noAnimation
             : const AnimationStyle(
                 duration: VhMotion.page,
                 curve: VhMotion.entrance,
                 reverseCurve: VhMotion.exit,
               ),
       );

  final bool still;

  // A dialog route closes at its opening pace unless told otherwise.
  @override
  Duration get reverseTransitionDuration =>
      still ? Duration.zero : VhMotion.fast;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final faded = super.buildTransitions(
      context,
      animation,
      secondaryAnimation,
      child,
    );
    if (still) return faded;
    if (_grow?.parent != animation) {
      _grow?.dispose();
      _grow = CurvedAnimation(
        parent: animation,
        curve: VhMotion.entrance,
        reverseCurve: VhMotion.exit,
      );
    }
    return ScaleTransition(
      scale: Tween(begin: VhMotion.recede, end: 1.0).animate(_grow!),
      child: faded,
    );
  }

  // Kept across builds: a curve made per build would leave a listener on
  // the route's animation every frame.
  CurvedAnimation? _grow;

  @override
  void dispose() {
    _grow?.dispose();
    super.dispose();
  }
}
