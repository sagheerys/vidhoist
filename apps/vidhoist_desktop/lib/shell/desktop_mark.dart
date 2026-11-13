import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The app's mark (a strip of film folded into the letter V, its back arm
/// in the accent) on its espresso tile, from the brand files
/// `tool/icons/vidhoist_kit.py` draws: one source for the Windows icon, the
/// tray and the app itself.
///
/// Below [smallBelow] points the small cut is drawn, as the icon is:
/// without the perforations, which blur into a smudge there, and with a
/// wider gap along the fold. Both carry a faint light rim, so the dark tile
/// does not melt into the night theme.
class DesktopMark extends StatelessWidget {
  const DesktopMark({super.key, required this.size});

  final double size;

  static const smallBelow = 24.0;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SvgPicture.asset(
      size < smallBelow
          ? 'brand/vidhoist-symbol-small.svg'
          : 'brand/vidhoist-symbol-dark.svg',
      width: size,
      height: size,
    ),
  );
}
