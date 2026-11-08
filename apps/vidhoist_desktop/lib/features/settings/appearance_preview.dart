import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

/// **The setting shows what it makes**: a small window drawn in the theme
/// and at the size being chosen, beside the choices, so a click is seen
/// before the eye goes back to the app. It holds no words of its own.
class AppearancePreview extends StatelessWidget {
  const AppearancePreview({super.key, required this.theme, required this.zoom});

  final ThemeMode theme;

  /// The interface size, 1 for 100%.
  final double zoom;

  static const double width = 260;
  static const double _height = 200;

  @override
  Widget build(BuildContext context) {
    final variant = VhThemeX.of(context).variant;
    final brightness = switch (theme) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => MediaQuery.platformBrightnessOf(context),
    };
    final p = VhPalette.of(variant, brightness);
    final duration = vhMotionDuration(context, VhMotion.page);
    final hair = VhThemeX.of(context).hairline;
    // Stand-ins for covers, all from the palette: the preview shows the
    // frame, not anyone's pictures.
    final covers = [
      p.accentDeep,
      p.offline,
      p.ink2,
      p.accent,
      p.favorite,
      p.ink3,
      p.offlineInk,
      p.accentInk,
    ];
    final tile = VhSpace.xxl * 2 * zoom;
    return ExcludeSemantics(
      child: AnimatedContainer(
        duration: duration,
        width: width,
        height: _height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: p.bg,
          borderRadius: BorderRadius.circular(VhCorners.desktop.card),
          border: Border.all(color: p.line2, width: hair),
        ),
        child: Column(
          children: [
            // The title bar: the mark and a search field.
            Container(
              height: VhSpace.xl * zoom,
              padding: EdgeInsets.symmetric(horizontal: VhSpace.xs * zoom),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: p.line, width: hair),
                ),
              ),
              child: Row(
                children: [
                  _Block(p.accent, VhSpace.sm * zoom, VhSpace.sm * zoom),
                  SizedBox(width: VhSpace.lg * zoom),
                  _Block(p.line, VhSpace.xxl * 3 * zoom, VhSpace.xs * zoom),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // The sidebar: the add button, the chosen row, the rest.
                  Container(
                    width: VhSpace.xxl * 2.4 * zoom,
                    padding: EdgeInsets.all(VhSpace.xs * zoom),
                    decoration: BoxDecoration(
                      border: BorderDirectional(
                        end: BorderSide(color: p.line, width: hair),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Block(p.accent, null, VhSpace.md * zoom),
                        SizedBox(height: VhSpace.xs * zoom),
                        _Block(vhSelectedFill(p), null, VhSpace.sm * zoom),
                        for (var i = 0; i < 3; i++) ...[
                          SizedBox(height: VhSpace.xs * zoom),
                          _Block(p.line, null, VhSpace.xs * zoom),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(VhSpace.sm * zoom),
                      child: Wrap(
                        spacing: VhSpace.xs * zoom,
                        runSpacing: VhSpace.xs * zoom,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          for (final c in covers)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Block(
                                  c.withValues(alpha: 0.75),
                                  tile,
                                  tile * 0.56,
                                ),
                                SizedBox(height: VhSpace.xxs * zoom),
                                _Block(p.ink3, tile * 0.8, VhSpace.xxs * zoom),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A rounded bar of one colour; a null width fills the row.
class _Block extends StatelessWidget {
  const _Block(this.color, this.width, this.height);

  final Color color;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: vhMotionDuration(context, VhMotion.page),
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(VhCorners.desktop.box),
    ),
  );
}
