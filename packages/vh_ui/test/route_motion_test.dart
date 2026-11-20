import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// **Guard: sheets, dialogs, notices and pages move at the app's pace.**
///
/// They ran at Flutter's defaults (a sheet 250/200, a dialog fading 150
/// both ways, a notice 250, a page 300 with the one beneath standing
/// still). The design gives each its own: a sheet 320 up and 200 down, a
/// dialog growing from 0.96 in 240 and gone in 160, a notice out in 160,
/// a page in 240 and back in 200 with the page beneath stepping back, and
/// Android's back swipe followed under the finger.
void main() {
  Widget host(Widget home) => MaterialApp(
    theme: vhTheme(VhVariant.desktop, Brightness.light),
    locale: const Locale('ar'),
    localizationsDelegates: VhLocalizations.localizationsDelegates,
    supportedLocales: VhLocalizations.supportedLocales,
    home: home,
  );

  /// The smallest scale among the transforms above [finder].
  double scaleAbove(WidgetTester tester, Finder finder) {
    var scale = 1.0;
    for (final t in tester.widgetList<Transform>(
      find.ancestor(of: finder, matching: find.byType(Transform)),
    )) {
      scale *= t.transform.entry(0, 0);
    }
    for (final t in tester.widgetList<ScaleTransition>(
      find.ancestor(of: finder, matching: find.byType(ScaleTransition)),
    )) {
      scale *= t.scale.value;
    }
    return scale;
  }

  testWidgets('a phone sheet rises in 320 and leaves in 200', (tester) async {
    late BuildContext captured;
    await tester.pumpWidget(
      host(
        Builder(
          builder: (context) {
            captured = context;
            return const SizedBox();
          },
        ),
      ),
    );
    final style = vhSheetMotion(captured)!;
    expect(style.duration, VhMotion.medium);
    expect(style.reverseDuration, VhMotion.leave);
    expect(style.curve, VhMotion.entrance);
  });

  testWidgets('the computer keeps its own sheet', (tester) async {
    late BuildContext captured;
    await tester.pumpWidget(
      host(
        VhDesktopApp(
          child: Builder(
            builder: (context) {
              captured = context;
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(vhSheetMotion(captured), isNull);
  });

  testWidgets('**the guard**: a sheet opened in a tab hides the add button', (
    tester,
  ) async {
    // A tab has its own navigator; the depth watches the root one only, so
    // a sheet left on the tab's was drawn under the add button.
    addTearDown(() => VhRouteDepth.depth.value = 0);
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [VhRouteDepth.instance],
        home: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showVhSheet<void>(
                  context: context,
                  builder: (_) => const Text('ورقة'),
                ),
                child: const Text('افتح'),
              ),
            ),
          ),
        ),
      ),
    );
    expect(VhRouteDepth.depth.value, 0);
    await tester.tap(find.text('افتح'));
    await tester.pumpAndSettle();
    expect(find.text('ورقة'), findsOneWidget);
    expect(VhRouteDepth.depth.value, 1);
  });

  testWidgets('a dialog grows from 0.96 and is gone in 160', (tester) async {
    await tester.pumpWidget(
      host(
        Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showVhDialog<void>(
                context: context,
                builder: (_) => const AlertDialog(content: Text('حوار')),
              ),
              child: const Text('افتح'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('افتح'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    final early = scaleAbove(tester, find.text('حوار'));
    expect(early, lessThan(1));
    expect(early, greaterThanOrEqualTo(VhMotion.recede));
    await tester.pumpAndSettle();
    expect(scaleAbove(tester, find.text('حوار')), 1);

    Navigator.of(tester.element(find.text('حوار'))).pop();
    await tester.pump();
    await tester.pump(VhMotion.fast + const Duration(milliseconds: 10));
    expect(find.text('حوار'), findsNothing);
  });

  testWidgets('a notice leaves in 160', (tester) async {
    await tester.pumpWidget(
      host(
        Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showVhSnack(context, 'إشعار'),
              child: const Text('اعرض'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('اعرض'));
    await tester.pumpAndSettle();
    ScaffoldMessenger.of(tester.element(find.text('اعرض')))
        .hideCurrentSnackBar();
    await tester.pump();
    await tester.pump(VhMotion.fast + const Duration(milliseconds: 10));
    expect(find.text('إشعار'), findsNothing);
  });

  Future<void> pushSecond(WidgetTester tester) async {
    await tester.pumpWidget(
      host(
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const Scaffold(body: Text('الثانية')),
                ),
              ),
              child: const Text('الأولى'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('الأولى'));
    await tester.pump();
  }

  testWidgets('the page beneath steps back and the new one is in by 240', (
    tester,
  ) async {
    await pushSecond(tester);
    await tester.pump(const Duration(milliseconds: 120));
    expect(scaleAbove(tester, find.text('الأولى')), lessThan(1));
    await tester.pump(VhMotion.page);
    expect(tester.hasRunningAnimations, isFalse);
    expect(find.text('الثانية'), findsOneWidget);
  });

  testWidgets('a back swipe shrinks the page under the finger', (tester) async {
    await pushSecond(tester);
    await tester.pumpAndSettle();

    Future<void> send(String method, [Object? arguments]) =>
        tester.binding.defaultBinaryMessenger.handlePlatformMessage(
          SystemChannels.backGesture.name,
          SystemChannels.backGesture.codec.encodeMethodCall(
            MethodCall(method, arguments),
          ),
          (_) {},
        );
    Map<String, Object> event(double progress) => {
      'touchOffset': <double>[5, 300],
      'progress': progress,
      'swipeEdge': 0,
    };

    await send('startBackGesture', event(0));
    await send('updateBackGestureProgress', event(0.5));
    await tester.pump();
    final pulled = scaleAbove(tester, find.text('الثانية'));
    expect(
      pulled,
      closeTo(1 - (1 - VhSlidePageTransition.swipeScale) / 2, 0.01),
    );
    // The page behind is in view while the finger is down.
    expect(find.text('الأولى'), findsOneWidget);

    await send('commitBackGesture');
    await tester.pumpAndSettle();
    expect(find.text('الثانية'), findsNothing);
  });

  test('no screen calls Flutter\'s sheet or dialog directly', () {
    final raw = RegExp(r'\bshow(Dialog|ModalBottomSheet)<');
    final offenders = [
      for (final file in Directory('lib').listSync(recursive: true))
        if (file is File &&
            file.path.endsWith('.dart') &&
            !file.path.endsWith('vh_route_motion.dart') &&
            raw.hasMatch(file.readAsStringSync()))
          file.path,
    ];
    expect(offenders, isEmpty);
  });
}
