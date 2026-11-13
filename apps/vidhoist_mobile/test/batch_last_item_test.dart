import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/batch/batch_providers.dart';
import 'package:vidhoist_mobile/features/batch/batch_screen.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';

/// The last item of a playlist can be unticked: "Download selected" floats
/// over the bottom of the list.
void main() {
  const url = 'https://www.youtube.com/playlist?list=PLtest';
  final preview = PlaylistPreview(
    kind: PlaylistKind.youtube,
    title: 'A long course',
    tracks: [
      for (var i = 1; i <= 14; i++)
        PlaylistTrack(
          url: 'https://www.youtube.com/watch?v=clip$i',
          title: 'Lesson $i',
          duration: const Duration(minutes: 12),
        ),
    ],
  );

  testWidgets('**the guard**: scrolled to the end, the last checkbox sits '
      'above the floating button and takes a tap', (tester) async {
    // A phone with the three navigation buttons, which take the bottom.
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(384, 823);
    // The buttons are both padding and view padding, as on a device: the
    // floating button stands above the latter.
    tester.view.padding = const FakeViewPadding(bottom: 48);
    tester.view.viewPadding = const FakeViewPadding(bottom: 48);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
          secretStoreProvider.overrideWithValue(MemorySecretStore()),
          prefsMutexProvider.overrideWithValue(PrefsMutex()),
          initialSettingsProvider.overrideWithValue(const PhoneSettings()),
          loggerProvider.overrideWithValue(
            VhLogger(filePath: '${Directory.systemTemp.path}/vh_batch.log'),
          ),
          playlistPreviewProvider(url).overrideWith((_) async => preview),
        ],
        child: MaterialApp(
          theme: vhTheme(VhVariant.phone, Brightness.light),
          locale: const Locale('en'),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: const BatchScreen(playlistUrl: url),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView).last, const Offset(0, -3000));
    await tester.pumpAndSettle();

    final last = find.byType(Checkbox).last;
    final fab = tester.getRect(find.byType(FloatingActionButton));
    expect(tester.getRect(last).bottom, lessThanOrEqualTo(fab.top));

    await tester.tap(last);
    await tester.pump();
    expect(tester.widget<Checkbox>(last).value, isFalse);
  });
}
