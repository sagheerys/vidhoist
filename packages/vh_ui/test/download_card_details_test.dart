import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

import 'icon_finder.dart';

/// **The download card as the plan draws it** (mobile plan 2026-11-01): the
/// clip's picture, the server's speed beside the percentage, and a task
/// waiting its turn drawn still rather than as a moving bar.
void main() {
  Widget host(Widget child) => MaterialApp(
    localizationsDelegates: VhLocalizations.localizationsDelegates,
    supportedLocales: VhLocalizations.supportedLocales,
    theme: vhTheme(VhVariant.desktop, Brightness.light),
    home: Scaffold(body: child),
  );

  testWidgets('**the guard**: the speed shows beside the percentage', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        VhDownloadProgressCard(
          title: 'Clip',
          statusText: 'On the server',
          progress: 0.64,
          detail: vhFormatTransferRate(3.1 * 1024 * 1024),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('3.1 MB/s'), findsOneWidget);
    expect(find.text('64%'), findsOneWidget);
  });

  testWidgets('**the guard**: a waiting task is a still line, not a moving '
      'bar', (tester) async {
    await tester.pumpWidget(
      host(
        const VhDownloadProgressCard(
          title: 'Clip',
          statusText: 'Number 2 in line',
          waiting: true,
        ),
      ),
    );
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('the picture takes the place of the icon', (tester) async {
    await tester.pumpWidget(
      host(
        const VhDownloadProgressCard(
          title: 'Clip',
          statusText: 'On the server',
          progress: 0.1,
          thumbnail: ColoredBox(key: Key('cover'), color: Colors.teal),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cover')), findsOneWidget);
    expect(byVhIcon(VhIcons.download), findsNothing);
  });

  testWidgets('a second action beside the cancel: pause, then resume', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      host(
        VhDownloadProgressCard(
          title: 'Clip',
          statusText: 'Downloading',
          progress: 0.3,
          onCancel: () {},
          action: VhDownloadCardAction(
            icon: VhIcons.pause,
            tooltip: 'Pause',
            onTap: () => taps++,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(byVhIcon(VhIcons.close), findsOneWidget);
    await tester.tap(find.byTooltip('Pause'));
    expect(taps, 1);
  });

  testWidgets('a finished card has no action', (tester) async {
    await tester.pumpWidget(
      host(
        VhDownloadProgressCard(
          title: 'Clip',
          statusText: 'Done',
          done: true,
          action: VhDownloadCardAction(
            icon: VhIcons.pause,
            tooltip: 'Pause',
            onTap: () {},
          ),
        ),
      ),
    );
    expect(find.byTooltip('Pause'), findsNothing);
  });

  test('the speed reads in kilobytes under a megabyte a second', () {
    expect(vhFormatTransferRate(512 * 1024), contains('512 KB/s'));
    expect(vhFormatTransferRate(1.5 * 1024 * 1024), contains('1.5 MB/s'));
  });
}
