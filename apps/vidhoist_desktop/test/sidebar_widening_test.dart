import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/shell/shell_layout.dart';
import 'package:vh_media/library.dart';
import 'package:vh_ui/vh_ui.dart';

import 'support/shell_harness.dart';

LibraryItem _in(String folder, String id) => LibraryItem(
  canonicalUrl: 'https://youtu.be/$id',
  title: id,
  serverFilename: '$folder/$id.mp4',
  timestamp: DateTime(2026, 10, 20),
);

void main() {
  testWidgets('**the guard**: widening the sidebar, a folder line with its '
      'count never runs over while the width grows', (tester) async {
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
    final h = ShellHarness(
      layout: const ShellLayout(sidebarNarrow: true),
      withEngine: true,
      library: [
        for (final folder in ['Ai', 'Games', 'Quran'])
          for (var i = 0; i < 12; i++) _in(folder, '$folder$i'),
      ],
    );
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    await tester.tap(
      find.byWidgetPredicate(
        (w) => w is VhShortcutTooltip && w.message == 'Expand sidebar',
      ),
    );
    // Every frame of the animation, not just its end.
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 16));
      expect(tester.takeException(), isNull, reason: 'frame $i');
    }
    await tester.pumpAndSettle();
    // Wide at the end: the folders show their names and counts.
    expect(find.text('12'), findsNWidgets(3));
  });
}
