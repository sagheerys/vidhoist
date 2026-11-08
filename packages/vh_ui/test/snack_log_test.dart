import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

void main() {
  Future<BuildContext> host(WidgetTester tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        theme: vhTheme(VhVariant.desktop, Brightness.light),
        home: Scaffold(
          body: Builder(
            builder: (c) {
              context = c;
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    return context;
  }

  // Owner's request 2026-10-15: every error that shows also reaches the
  // log, including the ones nobody logged on purpose.
  testWidgets('an error shown is written down once, and only errors', (
    tester,
  ) async {
    final written = <String>[];
    vhErrorSnackLog = written.add;
    addTearDown(() => vhErrorSnackLog = null);
    final context = await host(tester);

    showVhSnack(context, 'it broke', type: VhSnackType.error);
    showVhSnack(
      context,
      'logged already',
      type: VhSnackType.error,
      logged: true,
    );
    showVhSnack(context, 'saved', type: VhSnackType.success);
    showVhSnack(context, 'note');

    expect(written, ['it broke']);
  });

  // Progress read in steps jumped from one figure to the next.
  testWidgets('the progress glides to a new reading', (tester) async {
    Widget card(double progress) => MaterialApp(
      theme: vhTheme(VhVariant.desktop, Brightness.light),
      home: Scaffold(
        body: VhDownloadProgressCard(
          title: 'clip',
          statusText: 'on the server',
          progress: progress,
        ),
      ),
    );
    await tester.pumpWidget(card(0.3));
    expect(find.text('30%'), findsOneWidget);

    await tester.pumpWidget(card(0.9));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('30%'), findsNothing);
    expect(find.text('90%'), findsNothing);

    await tester.pumpAndSettle();
    expect(find.text('90%'), findsOneWidget);
  });
}
