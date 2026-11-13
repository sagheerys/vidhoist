import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/downloads_library/widgets/item_details_sheet.dart';
import 'package:vidhoist_mobile/features/shared/membership.dart';

/// The details sheet's title can be selected and copied, to look it up
/// elsewhere; the other rows stay plain text.
void main() {
  const title = 'Sourdough, Week 1 - The Starter';
  const media = MethodChannel('vidhoist_mobile/media');

  setUp(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(media, (_) async => null),
  );
  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(media, null),
  );

  testWidgets('**the guard**: the title row is selectable', (tester) async {
    tester.view.physicalSize = const Size(411, 914) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final item = LocalItem(
      key: 'https://www.youtube.com/watch?v=abc',
      path: '/storage/emulated/0/Download/VidHoist/a.mp4',
      title: title,
      sizeBytes: 12 << 20,
      modified: DateTime(2026, 11, 1),
      canonicalUrl: 'https://www.youtube.com/watch?v=abc',
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [membershipIndexProvider.overrideWith((_) async => {})],
        child: MaterialApp(
          theme: vhTheme(VhVariant.phone, Brightness.light),
          locale: const Locale('en'),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showItemDetailsSheet(context, item),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(
      find.ancestor(of: find.text(title), matching: find.byType(SelectionArea)),
      findsOneWidget,
    );
    expect(find.byType(SelectionArea), findsOneWidget);
  });
}
