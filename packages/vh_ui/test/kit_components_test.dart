import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

double _radius(ShapeBorder? shape) =>
    ((shape! as RoundedRectangleBorder).borderRadius as BorderRadius).topLeft.x;

void main() {
  group('corner scales', () {
    test('**the guard**: the phones take three corners, 8 · 16 · pill', () {
      // Literal numbers on purpose: editing the mobile scale fails here
      // before it reaches every card and sheet on the phones. Changed from
      // 16 · 10 · 28 · 13 by the owner's decision of 2026-10-31.
      final t = vhTheme(VhVariant.desktop, Brightness.light);
      expect(_radius(t.cardTheme.shape), 16);
      expect(_radius(t.chipTheme.shape), 8);
      expect(_radius(t.bottomSheetTheme.shape), 16);
      expect(_radius(t.dialogTheme.shape), 16);
      final field = t.inputDecorationTheme.border! as OutlineInputBorder;
      expect(field.borderRadius.topLeft.x, 8);
      final button = t.filledButtonTheme.style!.shape!.resolve({})!;
      expect(_radius(button), 8);
      expect(VhRadius.badge, 4);
    });

    test('the Windows theme takes two corners: 8 resting, 12 floating', () {
      final t = vhDesktopTheme(VhVariant.desktop, Brightness.light);
      expect(_radius(t.cardTheme.shape), 8);
      expect(_radius(t.chipTheme.shape), 8);
      expect(_radius(t.bottomSheetTheme.shape), 12);
      expect(_radius(t.dialogTheme.shape), 12);
      expect(t.textTheme.bodyLarge!.fontSize, 14);
      // **The guard**: a page title is the display face at its full
      // weight, never Material's regular fallback.
      expect(t.textTheme.headlineSmall!.fontWeight, FontWeight.w700);
      expect(t.textTheme.headlineSmall!.fontSize, 24);
    });
  });

  group('the accent is for the action', () {
    for (final variant in VhVariant.values) {
      for (final brightness in Brightness.values) {
        test('**the guard**: ${variant.name} ${brightness.name}: the chosen '
            'thing in the chrome is the ink, the filled button the accent', () {
          final t = vhTheme(variant, brightness);
          final p = VhPalette.of(variant, brightness);
          const on = {WidgetState.selected};
          expect(t.switchTheme.trackColor!.resolve(on), p.ink);
          expect(t.switchTheme.thumbColor!.resolve(on), p.bg);
          expect(t.navigationBarTheme.iconTheme!.resolve(on)!.color, p.ink);
          expect(t.navigationBarTheme.indicatorColor, vhSelectedFill(p));
          expect(t.navigationRailTheme.selectedIconTheme!.color, p.ink);
          expect(
            t.segmentedButtonTheme.style!.backgroundColor!.resolve(on),
            p.ink,
          );
          expect(t.radioTheme.fillColor!.resolve(on), p.ink);
          expect(t.textButtonTheme.style!.foregroundColor!.resolve({}), p.ink);
          final focused =
              t.inputDecorationTheme.focusedBorder! as OutlineInputBorder;
          expect(focused.borderSide.color, p.ink);
          final filled = t.filledButtonTheme.style!;
          expect(filled.backgroundColor!.resolve({}), p.accent);
          expect(
            filled.backgroundColor!.resolve({WidgetState.disabled}),
            p.accent.withValues(alpha: vhDisabledAccent),
          );
        });
      }
    }

    test('**the guard**: Ember keeps what it had: a pill button, the ember '
        'on a focused field', () {
      final t = vhDesktopTheme(VhVariant.desktop, Brightness.light);
      final p = VhPalette.of(VhVariant.desktop, Brightness.light);
      final button = t.filledButtonTheme.style!.shape!.resolve({})!;
      expect(_radius(button), VhRadius.pill);
      final focused =
          t.inputDecorationTheme.focusedBorder! as OutlineInputBorder;
      expect(focused.borderSide.color, p.accent);
      expect(
        t.checkboxTheme.fillColor!.resolve({WidgetState.selected}),
        p.accent,
      );
      expect(t.radioTheme.fillColor!.resolve({WidgetState.selected}), p.accent);
    });

    testWidgets('**the guard**: Arabic labels are set solid, Latin ones '
        'tracked', (tester) async {
      late double rtl, ltr;
      await tester.pumpWidget(
        Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Builder(
                builder: (c) {
                  rtl = vhLabelTracking(c, 1.6);
                  return const SizedBox();
                },
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Builder(
                builder: (c) {
                  ltr = vhLabelTracking(c, 1.6);
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      );
      expect(rtl, 0);
      expect(ltr, 1.6);
    });
  });

  Widget host(Widget child, {TextDirection dir = TextDirection.ltr}) =>
      MaterialApp(
        theme: vhDesktopTheme(VhVariant.desktop, Brightness.light),
        home: Directionality(
          textDirection: dir,
          child: Scaffold(body: Center(child: child)),
        ),
      );

  group('VhSwitch', () {
    testWidgets('**the guard**: on is the ink, with no glow and no accent', (
      tester,
    ) async {
      await tester.pumpWidget(host(VhSwitch(value: true, onChanged: (_) {})));
      final p = VhPalette.of(VhVariant.desktop, Brightness.light);
      final boxes = tester
          .widgetList<AnimatedContainer>(
            find.descendant(
              of: find.byType(VhSwitch),
              matching: find.byType(AnimatedContainer),
            ),
          )
          .map((c) => c.decoration! as BoxDecoration)
          .toList();
      expect(boxes.first.color, p.ink);
      for (final b in boxes) {
        expect(b.boxShadow, isNull);
        expect(b.color, isNot(p.accent));
      }
    });

    testWidgets('a click and the keyboard both toggle it', (tester) async {
      final seen = <bool>[];
      await tester.pumpWidget(
        host(VhSwitch(value: false, onChanged: seen.add, semanticLabel: 'x')),
      );

      await tester.tap(find.byType(VhSwitch));
      expect(seen, [true]);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(seen, [true, true]);
    });

    testWidgets('without a callback it is disabled and ignores taps', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const VhSwitch(value: true, onChanged: null)),
      );
      await tester.tap(find.byType(VhSwitch));
      expect(
        tester.getSemantics(find.byType(VhSwitch)),
        matchesSemantics(
          hasToggledState: true,
          isToggled: true,
          hasEnabledState: true,
        ),
      );
    });
  });

  testWidgets('a badge caps its count', (tester) async {
    await tester.pumpWidget(host(const VhBadge(count: 120)));
    expect(find.text('99+'), findsOneWidget);
    // It hugs its count instead of spreading across whatever holds it.
    await tester.pumpWidget(host(const Wrap(children: [VhBadge(count: 3)])));
    expect(tester.getSize(find.byType(VhBadge)).width, lessThan(40));

    // Arabic does not turn the count into "+99".
    await tester.pumpWidget(
      host(const VhBadge(count: 120), dir: TextDirection.rtl),
    );
    expect(
      tester.widget<Text>(find.text('99+')).textDirection,
      TextDirection.ltr,
    );
  });

  group('showVhConfirm', () {
    Future<bool?> run(WidgetTester tester, String tap) async {
      bool? result;
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async => result = await showVhConfirm(
                context,
                title: 'Delete the clip?',
                message: 'It is removed from the server for good.',
                confirmLabel: 'Delete',
                cancelLabel: 'Cancel',
                destructive: true,
                preview: const VhDialogClip(title: 'Trip to the valley'),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      // The clip is in the dialog before anything is deleted.
      expect(find.text('Trip to the valley'), findsOneWidget);
      await tester.tap(find.text(tap));
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets('confirming resolves true', (tester) async {
      expect(await run(tester, 'Delete'), isTrue);
    });

    testWidgets('cancelling resolves false', (tester) async {
      expect(await run(tester, 'Cancel'), isFalse);
    });

    testWidgets('**the guard**: two long labels at a large text size take '
        'a second line instead of overflowing', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showVhConfirm(
                context,
                title: 'Forget this device',
                message: 'Its transcripts move here first.',
                confirmLabel: 'Forget this device',
                cancelLabel: 'Keep it for now',
                destructive: true,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Keep it for now'), findsOneWidget);
    });
  });

  group('VhBoxedRow', () {
    Future<VhIcon> chevron(WidgetTester tester, TextDirection dir) async {
      await tester.pumpWidget(
        host(
          VhBoxedGroup(
            title: 'Playback',
            rows: [
              VhBoxedRow(
                icon: VhIcons.playback,
                title: 'Quality',
                value: '1080p',
                onTap: () {},
              ),
            ],
          ),
          dir: dir,
        ),
      );
      return tester.widgetList<VhIcon>(find.byType(VhIcon)).last;
    }

    testWidgets('the chevron points the way the page slides in', (
      tester,
    ) async {
      expect((await chevron(tester, TextDirection.ltr)).icon, VhIcons.forward);
      expect((await chevron(tester, TextDirection.rtl)).icon, VhIcons.back);
      expect(find.text('1080p'), findsOneWidget);
    });
  });
}
