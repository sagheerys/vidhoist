import 'dart:ui';

/// The two app variants: the phone app and the Windows app. They share one
/// palette and differ in type, corners and components.
enum VhVariant { phone, desktop }

/// The VidHoist palette. Values are copied **verbatim** from the approved
/// design references. Derived values, the ones not stated there, are marked
/// with a `derived` comment.
class VhPalette {
  const VhPalette({
    required this.bg,
    required this.card,
    required this.cardAlt,
    required this.ink,
    required this.ink2,
    required this.ink3,
    required this.line,
    required this.line2,
    required this.accent,
    required this.accentDeep,
    required this.accentSoft,
    required this.accentInk,
    required this.onAccent,
    required this.offline,
    required this.offlineSoft,
    required this.offlineInk,
    required this.onServerSoft,
    required this.onServerInk,
    required this.ok,
    required this.err,
    required this.favorite,
    required this.favoriteSoft,
    required this.grainOpacity,
    this.night = false,
  });

  final Color bg;
  final Color card;
  final Color cardAlt;
  final Color ink;
  final Color ink2;
  final Color ink3;

  /// Hairline rules, which replace boxes in this design.
  final Color line;
  final Color line2;

  /// The accent: blue, the same in both apps.
  final Color accent;
  final Color accentDeep;
  final Color accentSoft;
  final Color accentInk;
  final Color onAccent;

  /// Olive, which signals "offline".
  final Color offline;
  final Color offlineSoft;
  final Color offlineInk;

  /// A soft accent tint and the ink that reads on it; nothing draws with
  /// them today.
  final Color onServerSoft;
  final Color onServerInk;

  final Color ok;
  final Color err;

  /// Favourites are crimson, independent of either accent colour.
  final Color favorite;
  final Color favoriteSoft;

  /// Film grain.
  final double grainOpacity;

  /// Is this a night palette? Only the mini player reads it today.
  final bool night;

  /// **The mini player is inverted by day and consistent by night**
  /// (decision 2026-09-05, after seeing it on a device).
  ///
  /// It used to be inverted in both: an elegant dark bar under a light
  /// interface by day, and a **bright pale bar** under a black screen by
  /// night, a glare in a dark room. Inversion is a daylight idea by nature,
  /// so at night it follows the card instead.
  Color get miniBg => night ? card : ink;
  Color get miniInk => night ? ink : bg;
  Color get miniInkMuted => (night ? ink : bg).withValues(alpha: 0.55);

  /// A charcoal that stays dark in both themes, for what sits over video.
  static const Color serverCardBg = Color(0xFF211E1B);
  static const Color serverCardInk = Color(0xFFF0EBE4);

  // Always-dark constants. Full review 2026-09-02 found these hard-coded in
  // the screens, against the rule that every colour comes from tokens, no
  // literals.

  /// The far end of the charcoal playlist-card gradient, lighter than
  /// [serverCardBg].
  static const Color serverCardBgLift = Color(0xFF3B3631);

  /// The immersive landscape player scrim: near-opaque charcoal over video.
  static const Color fullscreenScrim = Color(0xEB121110);

  /// System notification red. Used outside the widget tree, where there is
  /// no `context` and no `VhThemeX`, so it has to be an explicit constant.
  static const Color notificationError = Color(0xFFB3261E);

  static VhPalette of(VhVariant variant, Brightness brightness) =>
      switch ((variant, brightness)) {
        (VhVariant.desktop, Brightness.light) => desktopDay,
        (VhVariant.desktop, Brightness.dark) => desktopNight,
        (VhVariant.phone, Brightness.light) => phoneDay,
        (VhVariant.phone, Brightness.dark) => phoneNight,
      };

  // VidHoist by day: white cards on a soft stone ground, the espresso
  // ink kept for warmth, and a blue accent. The ground was plain white at
  // first (2026-11-04); white on white glared and the cards had only their
  // hairline to stand on. Desktop and phone share one palette pair, so
  // desktopDay/phoneDay are aliases.
  static const VhPalette desktopDay = VhPalette(
    bg: Color(0xFFF2F1EE),
    card: Color(0xFFFFFFFF),
    cardAlt: Color(0xFFE8E6E2), // a secondary ground, one step below bg
    ink: Color(0xFF2B211B),
    ink2: Color(0xAD2B211B), // rgba(43,33,27,.68)
    ink3: Color(0x732B211B), // rgba(43,33,27,.45)
    line: Color(0x1F2B211B), // rgba(43,33,27,.12)
    line2: Color(0x332B211B), // rgba(43,33,27,.20)
    accent: Color(0xFF2457D6),
    accentDeep: Color(0xFF1B44AB),
    // Light enough that the drop wash keeps a white ground's lightness
    // (drop_frame_test holds it within 0.15 of luminance).
    accentSoft: Color(0xFFEAF0FC),
    accentInk: Color(0xFF173A8F),
    onAccent: Color(0xFFF4F7FF),
    offline: Color(0xFF6B7A3F),
    offlineSoft: Color(0xFFEBEDDD),
    offlineInk: Color(0xFF4E5A2B),
    onServerSoft: Color(0xFFEAF0FC),
    onServerInk: Color(0xFF173A8F),
    ok: Color(0xFF4E7A3F),
    err: Color(0xFFB0402F),
    favorite: Color(0xFFA83A3A),
    favoriteSoft: Color(0xFFFBE3E0),
    grainOpacity: 0.035,
  );

  // VidHoist by night: true black, with lifted cards so the hairlines
  // still read, and the blue brightened for dark ground.
  static const VhPalette desktopNight = VhPalette(
    bg: Color(0xFF000000),
    card: Color(0xFF121212),
    cardAlt: Color(0xFF1C1C1C),
    ink: Color(0xFFF0EBE4),
    ink2: Color(0xA8F0EBE4), // rgba(.66)
    ink3: Color(0x6BF0EBE4), // rgba(.42)
    line: Color(0x1FF0EBE4), // rgba(.12)
    line2: Color(0x2EF0EBE4), // rgba(.18)
    accent: Color(0xFF7FA3FF),
    accentDeep: Color(0xFF5F87EA),
    accentSoft: Color(0x297FA3FF), // rgba(127,163,255,.16)
    accentInk: Color(0xFFB3C6FF),
    onAccent: Color(
      0xFF0A1636,
    ), // text over the accent is dark at night, not white
    offline: Color(0xFF95A55E),
    offlineSoft: Color(0x2695A55E), // rgba(.15)
    offlineInk: Color(0xFFC9D49A),
    onServerSoft: Color(0x297FA3FF),
    onServerInk: Color(0xFFB3C6FF),
    ok: Color(0xFF7FAF6A),
    err: Color(0xFFE07A66),
    favorite: Color(0xFFFF9AA0),
    favoriteSoft: Color(
      0x24FF9AA0,
    ), // derived: a night soft in the same pattern as the rest
    grainOpacity: 0.04,
    night: true,
  );

  // The phone app uses the same pair: one identity, two form factors.
  static const VhPalette phoneDay = desktopDay;
  static const VhPalette phoneNight = desktopNight;
}
