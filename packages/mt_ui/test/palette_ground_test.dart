import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_ui/mt_ui.dart';

/// The ground under everything: warm stone by day and warm charcoal by
/// night, never the yellowed cream and brown-tinted black that read as a
/// generated palette beside the ember.
void main() {
  int red(Color c) => (c.r * 255).round();
  int blue(Color c) => (c.b * 255).round();

  test('**the guard**: the day ground is stone, the same in both apps', () {
    final superDay = MTPalette.of(MTVariant.superApp, Brightness.light);
    final liteDay = MTPalette.of(MTVariant.lite, Brightness.light);
    expect(liteDay.bg, superDay.bg);
    // Cream leaned a dozen steps from red to blue; stone barely leans.
    expect(red(superDay.bg) - blue(superDay.bg), lessThanOrEqualTo(8));
    expect(superDay.card, const Color(0xFFFFFFFF));
  });

  test('**the guard**: by day the cards stand on a ground a step below '
      'them', () {
    // White cards on a white ground read as one glaring sheet (owner,
    // 2026-11-06). A soft stone ground, as grouped lists do, lifts the cards
    // by their own lightness; too dark a ground goes grey and dull.
    for (final variant in MTVariant.values) {
      final p = MTPalette.of(variant, Brightness.light);
      final step = p.card.computeLuminance() - p.bg.computeLuminance();
      expect(step, inInclusiveRange(0.06, 0.14), reason: '$variant');
      expect(
        p.bg.computeLuminance() - p.cardAlt.computeLuminance(),
        greaterThan(0.03),
        reason: 'the secondary ground stays a step below the ground',
      );
    }
  });

  test('**the guard**: the night ground is charcoal, not espresso', () {
    final night = MTPalette.of(MTVariant.superApp, Brightness.dark);
    expect(red(night.bg) - blue(night.bg), lessThanOrEqualTo(5));
    expect(red(night.card) - blue(night.card), lessThanOrEqualTo(7));
  });

  test('text stays readable on every ground', () {
    double contrast(Color a, Color b) {
      final (x, y) = (a.computeLuminance(), b.computeLuminance());
      final (hi, lo) = x > y ? (x, y) : (y, x);
      return (hi + 0.05) / (lo + 0.05);
    }

    for (final variant in MTVariant.values) {
      for (final brightness in Brightness.values) {
        final p = MTPalette.of(variant, brightness);
        expect(contrast(p.ink, p.bg), greaterThan(12), reason: '$p');
        expect(contrast(p.ink, p.card), greaterThan(12), reason: '$p');
      }
    }
  });
}
