import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/data/incoming_links.dart';

import 'support/shell_harness.dart';

void main() {
  group('a vidhoist:// address', () {
    test('**the guard**: carries a web link, encoded or not, whole', () {
      expect(
        linkFromProtocol(
          'vidhoist://add?url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3Dabc'
          '%26t%3D10',
        ),
        'https://www.youtube.com/watch?v=abc&t=10',
      );
      expect(
        linkFromProtocol(
          'vidhoist://add?url=https://www.youtube.com/watch?v=abc&t=10',
        ),
        'https://www.youtube.com/watch?v=abc&t=10',
      );
      expect(
        linkFromProtocol('vidhoist:add?url=https://youtu.be/abc'),
        'https://youtu.be/abc',
      );
    });

    test('**the guard**: anything but a web link to add is turned away', () {
      for (final address in [
        'vidhoist://add?url=javascript:alert(1)',
        'vidhoist://add?url=file:///C:/Windows/win.ini',
        'vidhoist://add?url=https://',
        'vidhoist://add?url=ftp://example.com/clip.mp4',
        'vidhoist://delete?url=https://youtu.be/abc',
        'vidhoist://add',
        'https://youtu.be/abc',
        '--startup',
      ]) {
        expect(linkFromProtocol(address), isNull, reason: address);
      }
      expect(
        linksFromArgs(['--startup', 'vidhoist://add?url=https://youtu.be/abc']),
        ['https://youtu.be/abc'],
      );
    });
  });

  test('a link that comes before the window waits for it', () {
    final links = IncomingLinks()..add('https://youtu.be/early');
    final opened = <String>[];
    links.listen(opened.add);
    links.add('https://youtu.be/later');
    expect(opened, ['https://youtu.be/early', 'https://youtu.be/later']);
  });

  testWidgets('**the guard**: a link from outside opens the add dialog with '
      'it, and sends nothing', (tester) async {
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
    final links = IncomingLinks()..add('https://www.youtube.com/watch?v=abc');
    final h = ShellHarness(
      library: const [],
      withEngine: true,
      overrides: [incomingLinksProvider.overrideWithValue(links)],
    );
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    expect(
      find.widgetWithText(TextField, 'https://www.youtube.com/watch?v=abc'),
      findsOneWidget,
    );
    expect(h.engine.submitted, isEmpty);
  });

  testWidgets('**the guard**: links from outside come one dialog at a time, '
      'none lost', (tester) async {
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
    final links = IncomingLinks();
    final h = ShellHarness(
      library: const [],
      withEngine: true,
      overrides: [incomingLinksProvider.overrideWithValue(links)],
    );
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    links
      ..add('https://youtu.be/first000000')
      ..add('https://youtu.be/second00000');
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(
      find.widgetWithText(TextField, 'https://youtu.be/first000000'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(
      find.widgetWithText(TextField, 'https://youtu.be/second00000'),
      findsOneWidget,
    );
  });
}
