import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

import 'icon_finder.dart';

/// **Polish guards** (requested 2026-09-04). Motion is glimpsed, not
/// watched: durations come from `VhMotion`, and none of it runs when the
/// system asks to reduce motion.
void main() {
  Widget host(Widget child, {bool reduceMotion = false}) => MediaQuery(
    data: MediaQueryData(disableAnimations: reduceMotion),
    child: MaterialApp(
      theme: vhTheme(VhVariant.phone, Brightness.light),
      home: Scaffold(body: Center(child: child)),
    ),
  );

  group('VhIconSwap', () {
    testWidgets(
      'an icon change passes through a transition and settles on the new one',
      (tester) async {
        var icon = VhIcons.playFill;
        late StateSetter set;
        await tester.pumpWidget(
          host(
            StatefulBuilder(
              builder: (context, setState) {
                set = setState;
                return VhIconSwap(icon: icon);
              },
            ),
          ),
        );
        expect(byVhIcon(VhIcons.playFill), findsOneWidget);

        set(() => icon = VhIcons.pause);
        await tester.pump();
        await tester.pump(VhMotion.tap ~/ 2);
        // Halfway through, both are present: that is what a cross-fade is.
        expect(byVhIcon(VhIcons.playFill), findsOneWidget);
        expect(byVhIcon(VhIcons.pause), findsOneWidget);

        await tester.pumpAndSettle();
        expect(byVhIcon(VhIcons.playFill), findsNothing);
        expect(byVhIcon(VhIcons.pause), findsOneWidget);
      },
    );

    testWidgets(
      'with reduced motion the switch is immediate, with no transition',
      (tester) async {
        var icon = VhIcons.playFill;
        late StateSetter set;
        await tester.pumpWidget(
          host(
            StatefulBuilder(
              builder: (context, setState) {
                set = setState;
                return VhIconSwap(icon: icon);
              },
            ),
            reduceMotion: true,
          ),
        );
        set(() => icon = VhIcons.pause);
        await tester.pump();
        expect(byVhIcon(VhIcons.playFill), findsNothing);
        expect(byVhIcon(VhIcons.pause), findsOneWidget);
      },
    );
  });

  group('VhPressable', () {
    testWidgets(
      'it shrinks to pressScale while pressed and returns on release',
      (tester) async {
        await tester.pumpWidget(
          host(
            const VhPressable(
              child: SizedBox(width: 100, height: 40, child: Text('زر')),
            ),
          ),
        );
        AnimatedScale scaleOf() =>
            tester.widget<AnimatedScale>(find.byType(AnimatedScale));
        expect(scaleOf().scale, 1);

        final gesture = await tester.startGesture(
          tester.getCenter(find.text('زر')),
        );
        await tester.pump();
        expect(scaleOf().scale, VhMotion.pressScale);
        expect(
          scaleOf().scale,
          greaterThan(0.9),
          reason: 'انكماش يُلمَح لا يُشاهَد',
        );

        await gesture.up();
        await tester.pump();
        expect(scaleOf().scale, 1);
      },
    );
  });

  test('the polish durations stay under the agreed 320ms ceiling', () {
    expect(VhMotion.sheetPage.inMilliseconds, lessThanOrEqualTo(320));
    expect(VhMotion.tap.inMilliseconds, lessThanOrEqualTo(320));
    expect(VhMotion.reveal.inMilliseconds, lessThanOrEqualTo(320));
  });

  group('VhHiddenUnderRoutes', () {
    testWidgets(
      'a pure fade: no size changes, and no difference between the two directions',
      (tester) async {
        addTearDown(() => VhRouteDepth.depth.value = 0);
        VhRouteDepth.depth.value = 0;
        await tester.pumpWidget(
          host(
            const VhHiddenUnderRoutes(
              child: SizedBox(
                width: 100,
                height: 40,
                child: Text('أضف رابطاً'),
              ),
            ),
          ),
        );

        Finder inside(Type type) => find.descendant(
          of: find.byType(VhHiddenUnderRoutes),
          matching: find.byType(type),
        );
        AnimatedOpacity fade() =>
            tester.widget<AnimatedOpacity>(inside(AnimatedOpacity));
        expect(fade().opacity, 1);
        final showCurve = fade().curve;

        // **The guard**: no `AnimatedScale` anywhere on this path. The size
        // jump is what was described as "strange and uncomfortable"
        // (2026-09-05).
        expect(inside(AnimatedScale), findsNothing);

        VhRouteDepth.depth.value = 1;
        await tester.pump();
        expect(fade().opacity, 0);
        expect(fade().curve, showCurve, reason: 'منحنى واحد في الاتجاهين');

        // And it does not swallow taps while hidden.
        expect(
          tester.widget<IgnorePointer>(inside(IgnorePointer)).ignoring,
          isTrue,
        );
      },
    );

    testWidgets('visible false hides it without taking it out of the tree', (
      tester,
    ) async {
      addTearDown(() => VhRouteDepth.depth.value = 0);
      VhRouteDepth.depth.value = 0;
      await tester.pumpWidget(
        host(
          const VhHiddenUnderRoutes(
            visible: false,
            child: SizedBox(width: 100, height: 40, child: Text('أضف رابطاً')),
          ),
        ),
      );

      // **The guard**: removing it from the `Scaffold` slot by passing
      // `null` wakes the default animator, which rotates on appearance, and
      // that rotation is what was reported.
      expect(find.text('أضف رابطاً', skipOffstage: false), findsOneWidget);
      expect(
        tester
            .widget<AnimatedOpacity>(
              find.descendant(
                of: find.byType(VhHiddenUnderRoutes),
                matching: find.byType(AnimatedOpacity),
              ),
            )
            .opacity,
        0,
      );
    });
  });
}
