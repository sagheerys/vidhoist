import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_actions.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';

/// Sharing a downloaded clip puts a line on screen before the file is
/// handed over: Android copies the whole file first, and with a large clip
/// the app stood still for seconds with nothing saying why.
void main() {
  const channel = MethodChannel('dev.fluttercommunity.plus/share');
  late Directory temp;
  late BuildContext host;

  setUp(() => temp = Directory.systemTemp.createTempSync('vh_share_notice'));
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    temp.deleteSync(recursive: true);
  });

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

  testWidgets('**the guard**: the notice is up when the file reaches the '
      'share menu, and gone after', (tester) async {
    final file = File('${temp.path}/clip.mp4')..writeAsBytesSync(const [0]);
    final item = LocalItem(
      key: 'clip',
      path: file.path,
      title: 'clip',
      sizeBytes: 1,
      modified: DateTime(2026, 11, 12),
    );
    final shown = <bool>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          shown.add(find.byType(VhShareOpening).evaluate().isNotEmpty);
          return 'dev.fluttercommunity.plus/share/unavailable';
        });
    final box = ProviderContainer();
    addTearDown(box.dispose);
    await tester.pumpWidget(app());

    final done = box.read(libraryActionsProvider).share(host, [item]);
    await tester.pump();
    await tester.pump();
    await tester.pumpAndSettle();
    await done;

    expect(shown, [isTrue]);
    expect(find.byType(VhShareOpening), findsNothing);
  });

  testWidgets('nothing to share shows nothing', (tester) async {
    final item = LocalItem(
      key: 'gone',
      path: '${temp.path}/gone.mp4',
      title: 'gone',
      sizeBytes: 1,
      modified: DateTime(2026, 11, 12),
    );
    final box = ProviderContainer();
    addTearDown(box.dispose);
    await tester.pumpWidget(app());

    await box.read(libraryActionsProvider).share(host, [item]);
    await tester.pump();
    expect(find.byType(VhShareOpening), findsNothing);
  });
}
