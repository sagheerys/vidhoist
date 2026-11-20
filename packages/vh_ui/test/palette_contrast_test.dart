import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// WCAG's ratio between two opaque colours.
double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final (hi, lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + 0.05) / (lo + 0.05);
}

/// The quiet inks carry real words (hints under settings, dates, sizes,
/// subtitles), so they are held to the 4.5:1 that body text needs, on
/// every ground they are laid on. The faintest was 2.7:1 by day.
void main() {
  for (final brightness in Brightness.values) {
    final p = VhPalette.of(VhVariant.phone, brightness);
    final grounds = {'bg': p.bg, 'card': p.card, 'cardAlt': p.cardAlt};

    for (final MapEntry(key: name, value: ground) in grounds.entries) {
      test('**the guard**: the quiet inks read on $name '
          '(${brightness.name})', () {
        final ink2 = _contrast(Color.alphaBlend(p.ink2, ground), ground);
        final ink3 = _contrast(Color.alphaBlend(p.ink3, ground), ground);
        expect(ink3, greaterThanOrEqualTo(4.5), reason: 'ink3 $ink3');
        // Still a step below ink2, or the two would be one ink.
        expect(ink2, greaterThan(ink3 + 1), reason: 'ink2 $ink2');
      });
    }
  }

  /// **The guard**: a translucent ink is painted stroke by stroke and glyph
  /// by glyph, so it was laid twice wherever two met: bright knots on an
  /// icon's joints and on joined Arabic letters, by night above all.
  for (final brightness in Brightness.values) {
    test('the inks that draw words and icons are opaque '
        '(${brightness.name})', () {
      final p = VhPalette.of(VhVariant.phone, brightness);
      for (final MapEntry(key: name, value: ink) in {
        'ink': p.ink,
        'ink2': p.ink2,
        'ink3': p.ink3,
        'miniInk': p.miniInk,
        'miniInkMuted': p.miniInkMuted,
        'accentInk': p.accentInk,
      }.entries) {
        expect(ink.a, 1.0, reason: '$name is translucent');
      }
    });
  }

  test('one palette for both apps', () {
    for (final brightness in Brightness.values) {
      expect(
        VhPalette.of(VhVariant.desktop, brightness),
        same(VhPalette.of(VhVariant.phone, brightness)),
      );
    }
  });
}
