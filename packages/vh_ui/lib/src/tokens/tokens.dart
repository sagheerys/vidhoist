import 'package:flutter/widgets.dart';

export 'palette.dart';
export 'shadows.dart';

/// **Three corners, not nine**: 8 on what is touched
/// or shown small (a thumbnail, a field, a chip, a button), 16 on what
/// floats or gathers (a sheet, a dialog, a settings group, the mini player)
/// and full pills on round controls; 4 on the small badges. Nine near
/// values between 6 and 28 read as "everything medium", one of the marks of
/// a generated screen.
abstract final class VhRadius {
  static const double sheet = 16;
  static const double card = 16;
  static const double cardLg = 16;
  static const double field = 8;
  static const double iconButton = 8;
  static const double thumb = 8;
  static const double chip = 8;
  static const double fab = 16;
  static const double mini = 16;
  static const double badge = 4;
  static const double pill = 999;
}

/// The spacing scale, taken from the rhythm of the design references: page
/// gutter 18, content gap 13.
abstract final class VhSpace {
  static const double xxs = 4;
  static const double xs = 7;
  static const double sm = 10;
  static const double md = 13;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 26;
  static const double pagePad = 18;
  static const double gap = 13;
}

/// The side rail that replaces the bottom bar from medium width.
abstract final class VhRail {
  /// Wide enough for the longest label in either language under its icon.
  static const double width = 88;
}

/// Motion: the app's single curve.
abstract final class VhMotion {
  static const Curve ease = Cubic(0.32, 0.72, 0, 1);
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration medium = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 640);

  // Motion. **Softened on request: "unbalanced, calm it down and make it
  // smoother".**
  //
  // The principle: **quick on the way out, calm on the way in**. Motion is
  // glimpsed, not watched. The app's is a calm editorial identity, not a
  // game interface.
  //
  // The lesson from the first attempt: **distance tires the eye, not
  // duration.** A 14-point card slide and a page slide of 0.22 of the
  // screen width both read as a jump. The values are now roughly half of
  // that, and the work is carried mostly by the fade.

  /// A confident entrance: accelerates, then settles without overshoot.
  static const Curve entrance = Cubic(0.2, 0, 0, 1);

  /// A decisive exit. What is leaving does not deserve attention.
  static const Curve exit = Cubic(0.3, 0, 1, 1);

  /// A small element's pulse: badge, button, chip.
  static const Duration tap = Duration(milliseconds: 160);

  /// Half a breath of a placeholder while the first answer is awaited:
  /// slow enough to read as waiting, not as an alarm.
  static const Duration wait = Duration(milliseconds: 900);

  /// A full screen transition.
  static const Duration page = Duration(milliseconds: 240);

  /// Content appearing inside a screen.
  static const Duration reveal = Duration(milliseconds: 220);

  /// The way back, and anything closing that came up in [medium]: out
  /// faster than it came in.
  static const Duration leave = Duration(milliseconds: 200);

  /// How small the page underneath gets while another is pushed over it,
  /// and the size a dialog grows from.
  static const double recede = 0.96;

  /// Slide offset for an element inside a screen, in points. Small on
  /// purpose.
  static const double slideNudge = 7;

  /// Page slide distance as a fraction of the page width.
  static const double pageSlide = 0.06;

  // How far an element shrinks while pressed. Glimpsed, not watched.

  /// A screen that rises like a sheet from the bottom, such as the audio
  /// screen opened from the mini player: at a sheet's pace, longer than
  /// [page] because it travels the full distance. It goes down in [leave].
  static const Duration sheetPage = medium;

  /// How far an element shrinks while pressed. Glimpsed, not watched.
  static const double pressScale = 0.97;

  /// How far the outgoing icon shrinks when two icons swap.
  static const double iconSwapScale = 0.6;

  /// A downward drag past this distance closes the audio screen, in points.
  static const double dismissDragDistance = 120;

  /// Or a velocity past this, in points per second: a short flick is
  /// enough.
  static const double dismissFlingVelocity = 700;
}

/// The approved typography: Noto Kufi Arabic for headings (700/500) and
/// Tajawal for body text.
abstract final class VhType {
  static const String display = 'NotoKufiArabic';
  static const String body = 'Tajawal';

  /// The fonts live inside the vh_ui package, so every TextStyle has to
  /// pass `package`.
  static const String package = 'vh_ui';
}

/// The corner scale a theme is built with.
///
/// The phones keep [VhRadius] exactly. The Windows app steps every corner
/// down: on a large screen at arm's length, Material's soft corners read
/// as a phone app blown up.
class VhCorners {
  const VhCorners({
    required this.sheet,
    required this.card,
    required this.dialog,
    required this.field,
    required this.thumb,
    required this.fab,
    required this.chip,
    required this.iconButton,
    required this.tooltip,
    required this.box,
    required this.button,
  });

  final double sheet;
  final double card;
  final double dialog;
  final double field;
  final double thumb;
  final double fab;
  final double chip;
  final double iconButton;
  final double tooltip;

  /// Checkboxes and count badges.
  final double box;

  /// A filled button with a label.
  final double button;

  static const mobile = VhCorners(
    sheet: VhRadius.sheet,
    card: VhRadius.card,
    dialog: VhRadius.card,
    field: VhRadius.field,
    thumb: VhRadius.thumb,
    fab: VhRadius.fab,
    chip: VhRadius.chip,
    iconButton: VhRadius.iconButton,
    tooltip: 8,
    box: 2,
    button: VhRadius.field,
  );

  /// **Two corners, not nine**: 8 on everything that rests and 12 on what
  /// floats over it (a dialog, a sheet), stepping down as they nest; the
  /// filled actions are full pills. Nine near values between 6 and 20 read
  /// as "everything medium", one of the marks of a generated screen.
  static const desktop = VhCorners(
    sheet: 12,
    card: 8,
    dialog: 12,
    field: 8,
    thumb: 8,
    fab: VhRadius.pill,
    chip: 8,
    iconButton: 8,
    tooltip: 6,
    box: 4,
    button: VhRadius.pill,
  );
}

/// The three type sizes that differ between the phone and the computer.
///
/// A desktop screen is read from further away but with a finer pointer, so
/// body text is a step smaller and secondary text a step larger than on a
/// phone, where it sits a hand's length from the eye.
class VhTypeScale {
  const VhTypeScale({
    required this.headline,
    required this.body,
    required this.secondary,
  });

  /// Screen titles, in the heading font at 700.
  final double headline;

  /// Running text, in the body font at 400.
  final double body;

  /// Captions and metadata under a title.
  final double secondary;

  /// The phones' scale, exactly the sizes they always had.
  static const mobile = VhTypeScale(headline: 24, body: 15, secondary: 11.5);

  /// The Windows app's scale.
  static const desktop = VhTypeScale(headline: 24, body: 14, secondary: 12.5);
}

/// What a screen puts first (design round 2026-11-11): the one number it
/// is about, its one main action, and the paragraph that explains a choice.
/// Used only on the screens drawn around it, so the rest of the app keeps
/// the sizes above.
abstract final class VhEmphasis {
  /// The number a sheet is about: a percent while something downloads.
  static const double figure = 56;

  /// The same inside a card, or where other text shares the line: a version.
  static const double figureInCard = 40;

  /// The main action's height, full width: one shape wherever it appears.
  static const double action = 56;

  /// A paragraph that decides something, a step above [VhTypeScale.secondary]
  /// so it is read rather than skimmed.
  static const double explain = 13;
}

/// Spacing for a pointer rather than a finger: rows a mouse can still hit
/// comfortably at a third less height than a thumb needs.
class VhDensity {
  const VhDensity({
    required this.row,
    required this.icon,
    required this.iconButton,
    required this.gap,
    required this.scrollbar,
    required this.focusRing,
  });

  /// The height of a list or table row.
  final double row;

  /// An icon on its own in a bar or a list: a little larger than the
  /// body text, so a glyph reads at a glance.
  final double icon;

  /// The square an icon button occupies, its hit area included.
  final double iconButton;

  /// The space between neighbouring controls.
  final double gap;

  /// How thick a scrollbar's thumb is: a thin line, not Windows' bar.
  final double scrollbar;

  /// How thick the keyboard focus ring is.
  final double focusRing;

  /// The Windows app. The phones keep their own spacing (`VhSpace`).
  static const desktop = VhDensity(
    row: 36,
    icon: 18,
    iconButton: 32,
    gap: 12,
    scrollbar: 6,
    focusRing: 2,
  );
}

/// **Fixed-width digits** for live counters.
///
/// **A documented trap:** adding `FontFeature.tabularFigures()` on its own
/// does nothing here. Inspecting the font binaries proved that **Tajawal
/// has no `tnum` table** while Noto Kufi Arabic does. A counter drawn in
/// the body font keeps dancing with every passing second, however loudly
/// the feature is requested.
///
/// So counters are drawn in the **heading** font, which actually supports
/// the feature, and only on changing numbers: time, size, speed. Never on
/// prose.
extension VhTabularFigures on TextStyle {
  TextStyle get tabular => copyWith(
    fontFamily: VhType.display,
    package: VhType.package,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

/// **Tracking for a small label, in Latin script only.** Spacing letters
/// apart pulls Arabic's joined letters away from each other (the Arabic
/// "Now playing" read as broken glyphs), so a right-to-left label is set
/// solid.
double vhLabelTracking(BuildContext context, double latin) =>
    Directionality.of(context) == TextDirection.rtl ? 0 : latin;
