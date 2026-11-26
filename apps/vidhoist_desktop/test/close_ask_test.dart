import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_desktop/data/close_guard.dart';

import 'desktop_matrix.dart';
import 'support/shell_harness.dart';

/// Closing the app with downloads still going: asked first, with what is
/// going; with nothing going, closed at once.
void main() {
  const reel = 'https://www.instagram.com/reel/abc/';
  final l = lookupVhLocalizations(const Locale('en'));

  late CloseGuard guard;

  Future<ShellHarness> open(WidgetTester tester) async {
    ShellHarness.useWindow(tester, const Size(1440, 900));
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => call.method == 'Clipboard.getData'
          ? <String, Object?>{'text': ''}
          : null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    guard = CloseGuard();
    final h = ShellHarness(
      library: const [],
      withEngine: true,
      overrides: [closeGuardProvider.overrideWithValue(guard)],
    );
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    return h;
  }

  /// The user's close, as the window passes it on; its answer once given.
  Future<bool?> close(WidgetTester tester) async {
    bool? answer;
    guard.mayClose().then((a) => answer = a);
    await tester.pumpAndSettle();
    return answer;
  }

  testWidgets('nothing downloading: closed at once, nothing asked', (
    tester,
  ) async {
    await open(tester);
    expect(await close(tester), isTrue);
    expect(find.byType(VhConfirmDialog), findsNothing);
  });

  testWidgets('**the guard**: a download going asks first, with the clip '
      'and how many more; "Keep downloading" keeps the app open', (
    tester,
  ) async {
    final h = await open(tester);
    final a = h.engine.submit(reel, Quality.best);
    h.engine.advance(a, 0.42);
    h.engine.submit('${reel}2', Quality.best);
    await tester.pumpAndSettle();
    expect(await close(tester), isNull, reason: 'still asking');
    expect(find.text(l.desktopCloseTitle(2)), findsOneWidget);
    expect(find.text(l.desktopCloseMore(1)), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    bool? answer;
    // The question already open: a second close is the same question.
    guard.mayClose().then((x) => answer = x);
    await tester.pumpAndSettle();
    expect(answer, isFalse);
    expect(find.byType(VhConfirmDialog), findsOneWidget);
    await tester.tap(find.text(l.desktopCloseKeep));
    await tester.pumpAndSettle();
    expect(find.byType(VhConfirmDialog), findsNothing);
  });

  testWidgets('"Close" lets the close through', (tester) async {
    final h = await open(tester);
    h.engine.submit(reel, Quality.best);
    await tester.pumpAndSettle();
    bool? answer;
    guard.mayClose().then((x) => answer = x);
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.desktopCloseAnyway));
    await tester.pumpAndSettle();
    expect(answer, isTrue);
  });

  testWidgets('a paused download is not going: closed at once', (tester) async {
    final h = await open(tester);
    final a = h.engine.submit(reel, Quality.best);
    h.engine.put(a.copyWith(phase: TaskPhase.paused, progress: 0.3));
    await tester.pumpAndSettle();
    expect(await close(tester), isTrue);
  });

  testWidgets('**desktop matrix**: the question fits every window and text '
      'size, in both languages', (tester) async {
    await expectNoOverflow(
      tester,
      () => MaterialApp(
        theme: vhTheme(VhVariant.desktop, Brightness.light),
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final l = context.vhl;
              return Center(
                child: VhConfirmDialog(
                  title: l.desktopCloseTitle(12),
                  message: l.desktopCloseBody(12),
                  confirmLabel: l.desktopCloseAnyway,
                  cancelLabel: l.desktopCloseKeep,
                  preview: VhDialogClip(
                    title:
                        'A rather long title for a clip still on its way down',
                    progress: 0.42,
                    note: l.desktopCloseMore(11),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  });
}
