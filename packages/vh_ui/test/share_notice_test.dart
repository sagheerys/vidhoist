import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// The notice shown while Android's share plugin copies a file before its
/// menu opens: on screen before the copy, gone once the menu covers the app.
void main() {
  late BuildContext host;

  Widget app() => MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: VhLocalizations.localizationsDelegates,
    supportedLocales: VhLocalizations.supportedLocales,
    theme: vhTheme(VhVariant.phone, Brightness.light),
    home: Builder(
      builder: (context) {
        host = context;
        return const Scaffold();
      },
    ),
  );

  testWidgets('the notice is on screen before the file is handed over', (
    tester,
  ) async {
    // The app once stood still for seconds with nothing saying why, while
    // a large file was copied.
    await tester.pumpWidget(app());
    var seenFirst = false;
    final send = Completer<void>();
    final done = vhShareWithNotice(host, () {
      seenFirst = find.text('Opening the share menu…').evaluate().isNotEmpty;
      return send.future;
    });
    await tester.pump();
    await tester.pump();
    expect(seenFirst, isTrue);

    send.complete();
    await tester.pumpAndSettle();
    await done;
    expect(find.text('Opening the share menu…'), findsNothing);
  });

  testWidgets('it goes as soon as the share menu covers the app', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    final send = Completer<void>();
    unawaited(vhShareWithNotice(host, () => send.future));
    await tester.pump();
    await tester.pump();
    expect(find.byType(VhShareOpening), findsOneWidget);

    // The menu is another window: the app is no longer the active one.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pumpAndSettle();
    expect(find.byType(VhShareOpening), findsNothing);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    send.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('a back press does not close it while the file is copied', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    final send = Completer<void>();
    unawaited(vhShareWithNotice(host, () => send.future));
    await tester.pump();
    await tester.pump();

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byType(VhShareOpening), findsOneWidget);

    send.complete();
    await tester.pumpAndSettle();
    expect(find.byType(VhShareOpening), findsNothing);
  });

  testWidgets('the notice fits both languages and both themes', (tester) async {
    for (final language in ['en', 'ar']) {
      for (final brightness in Brightness.values) {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(language),
            localizationsDelegates: VhLocalizations.localizationsDelegates,
            supportedLocales: VhLocalizations.supportedLocales,
            theme: vhTheme(VhVariant.phone, brightness),
            home: const Scaffold(body: VhShareOpening()),
          ),
        );
        expect(tester.takeException(), isNull);
      }
    }
  });
}
