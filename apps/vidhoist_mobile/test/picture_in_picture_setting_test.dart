import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/settings/widgets/settings_fields.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart' show VhPictureInPicture;
import 'package:vh_ui/vh_ui.dart';

/// **Guard: picture in picture is off until turned on.** Its switch in
/// the playback settings is kept, and the
/// player hears of it.
void main() {
  tearDown(VhPictureInPicture.instance.reset);

  testWidgets('**the guard**: off at first; the switch turns it on and '
      'keeps it', (tester) async {
    final store = MemoryKeyValueStore();
    final container = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        secretStoreProvider.overrideWithValue(MemorySecretStore()),
        prefsMutexProvider.overrideWithValue(PrefsMutex()),
        initialSettingsProvider.overrideWithValue(
          await tester.runAsync(() => PhoneSettings.load(store)) ??
              const PhoneSettings(),
        ),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: vhTheme(VhVariant.desktop, Brightness.light),
          locale: const Locale('en'),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: const Scaffold(body: PlaybackFields()),
        ),
      ),
    );
    expect(container.read(settingsProvider).pictureInPicture, isFalse);
    expect(VhPictureInPicture.instance.enabled.value, isFalse);
    await tester.tap(find.text('Picture in picture'));
    await tester.pumpAndSettle();
    expect(VhPictureInPicture.instance.enabled.value, isTrue);
    expect(await store.getBool('picture_in_picture'), isTrue);
  });
}
