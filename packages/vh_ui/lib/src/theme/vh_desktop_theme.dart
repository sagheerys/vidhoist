import 'package:flutter/material.dart';

import '../tokens/tokens.dart';
import '../widgets/vh_motion.dart';
import 'vh_theme.dart';
import 'vh_theme_controls.dart';

/// The Windows app's theme: the app's theme with the desktop type and
/// corner scales, and the app's own components in place of Material's
/// defaults.
///
/// **A separate entry point, not options on [vhTheme]**: the phone app
/// calls [vhTheme] and gets exactly what it had; nothing here can reach
/// it.
ThemeData vhDesktopTheme(
  VhVariant variant,
  Brightness brightness, {
  bool highContrast = false,
}) {
  const corners = VhCorners.desktop;
  // With Windows' high contrast on, every rule and border is drawn twice
  // as thick: thin lines are the first thing such eyes lose.
  final line = highContrast ? 2.0 : 1.0;
  final base = vhTheme(
    variant,
    brightness,
    type: VhTypeScale.desktop,
    corners: corners,
    hairline: line,
  );
  final p = VhPalette.of(variant, brightness);
  final hairline = BorderSide(color: p.line2, width: 1.6 * line);

  return base.copyWith(
    // A page's title (Library, Channels, Settings) is the headline of the
    // display face at its full weight. Left undefined, it fell back to
    // Material's 24 at the regular weight, and every title read thin.
    textTheme: base.textTheme.copyWith(
      headlineSmall: base.textTheme.headlineLarge,
    ),
    // "Warmth" instead of Material's sparkle: a press fills with the soft
    // accent and fades, with no ripple travelling across the control.
    splashFactory: NoSplash.splashFactory,
    // Every platform, so tests (which run as Android) see what Windows
    // shows.
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        for (final platform in TargetPlatform.values)
          platform: const VhDesktopPageTransition(),
      },
    ),
    highlightColor: p.accentSoft,
    // **A veil of the ink, never an opaque fill**: hovered, a button over
    // a picture or the accent (a play button, the controls on a video)
    // kept its glyph in sight. The opaque card fill covered a white glyph
    // in the day and turned a dark square at night.
    hoverColor: p.ink.withValues(alpha: vhHoverVeil),
    // No filled square on keyboard focus: the ring drawn by
    // VhFocusRingLayer marks it instead, and only for the keyboard.
    focusColor: Colors.transparent,
    // A thin thumb that comes with the mouse or a scroll and leaves
    // again, darker while dragged; never Windows' wide grey bar.
    scrollbarTheme: ScrollbarThemeData(
      thickness: WidgetStatePropertyAll(VhDensity.desktop.scrollbar),
      radius: Radius.circular(VhDensity.desktop.scrollbar / 2),
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.dragged) ? p.ink3 : p.line2,
      ),
      thumbVisibility: const WidgetStatePropertyAll(false),
      trackVisibility: const WidgetStatePropertyAll(false),
      interactive: true,
    ),
    // Square icon buttons with small corners; pressed, they warm up.
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        fixedSize: WidgetStatePropertyAll(
          Size.square(VhDensity.desktop.iconButton),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(corners.iconButton),
          ),
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.pressed) ? p.accentInk : p.ink2,
        ),
        // A button that is on (a panel shown, a mode chosen) is filled
        // with the ink, as a chosen sidebar row is.
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? vhSelectedFill(p) : null,
        ),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed)
              ? p.accent.withValues(alpha: vhPressVeil)
              : states.contains(WidgetState.hovered)
              ? p.ink.withValues(alpha: vhHoverVeil)
              : null,
        ),
      ),
    ),
    // A hairline square with small corners; on, it fills with the accent.
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(corners.box),
      ),
      side: WidgetStateBorderSide.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? BorderSide(color: p.accent, width: 1.6 * line)
            : hairline,
      ),
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? p.accent
            : Colors.transparent,
      ),
      checkColor: WidgetStatePropertyAll(p.onAccent),
    ),
    // The accent in a ring: the ring stays a hairline until chosen.
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? p.accent : p.line2,
      ),
    ),
    // A charcoal card rather than Material's grey slab, with room for a
    // shortcut beside the label (see VhShortcutTooltip).
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: p.miniBg,
        borderRadius: BorderRadius.circular(corners.tooltip),
        boxShadow: [
          BoxShadow(
            color: p.ink.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
            spreadRadius: -12,
          ),
        ],
      ),
      textStyle: base.textTheme.labelMedium!.copyWith(color: p.miniInk),
      padding: const EdgeInsets.symmetric(
        horizontal: VhSpace.sm,
        vertical: VhSpace.xs,
      ),
      waitDuration: const Duration(milliseconds: 600),
    ),
    // **One coloured action per dialog**: the filled one. A text button
    // beside it (Cancel, Done) is in the ink; in the accent it took the
    // colour while the filled button waited greyed out for a link.
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: p.ink,
        textStyle: base.textTheme.labelLarge,
      ),
    ),
    // Not yet possible, the filled button stays the accent, pale, so it
    // still reads as the one action of the dialog.
    filledButtonTheme: FilledButtonThemeData(
      style: base.filledButtonTheme.style?.copyWith(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? p.accent.withValues(alpha: vhDisabledAccent)
              : p.accent,
        ),
        // The accent's own dark ink on its pale tint: legible by day and
        // by night, as a disabled control must stay.
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.disabled) ? p.accentInk : p.onAccent,
        ),
      ),
    ),
    // The Windows app keeps the accent on a focused field, its one mark of
    // where typing goes in a window full of panels.
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(corners.field),
        borderSide: BorderSide(color: p.accent, width: 1.4 * line),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: p.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(corners.dialog),
        side: BorderSide(color: p.line2, width: line),
      ),
    ),
  );
}
