import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/downloads_library/widgets/library_chips.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

/// A test shell in the phone app's identity with its localisations, and
/// with no audio.
Widget host(Widget child, {List<Override> overrides = const []}) =>
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: vhTheme(VhVariant.phone, Brightness.light),
        locale: const Locale('ar'),
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );

LocalItem sample(String name, {MediaPlatform? platform}) => LocalItem(
  key: platform == MediaPlatform.youtube
      ? 'https://youtu.be/$name'
      : '$phoneMediaDir/$name.mp4',
  path: '$phoneMediaDir/$name.mp4',
  canonicalUrl: platform == MediaPlatform.youtube
      ? 'https://youtu.be/$name'
      : null,
  title: name,
  sizeBytes: 10,
  modified: DateTime(2026),
);

void main() {
  final store = MemoryKeyValueStore();

  List<Override> base(List<LocalItem> items) => [
    keyValueStoreProvider.overrideWithValue(store),
    secretStoreProvider.overrideWithValue(MemorySecretStore()),
    initialSettingsProvider.overrideWithValue(const PhoneSettings()),
    localMediaProvider.overrideWith((ref) async => items),
  ];

  testWidgets('the platform chips disappear when the library is one platform', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const PlatformFilterChips(),
        overrides: base([sample('a'), sample('b')]),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ChoiceChip), findsNothing);
  });

  testWidgets(
    'the platform chips appear with live counts when there are several',
    (tester) async {
      await tester.pumpWidget(
        host(
          const PlatformFilterChips(),
          overrides: base([
            sample('a'),
            sample('b', platform: MediaPlatform.youtube),
          ]),
        ),
      );
      await tester.pumpAndSettle();
      // "All sites" plus one chip per platform actually present.
      expect(find.byType(ChoiceChip), findsNWidgets(3));
      expect(find.textContaining('1'), findsWidgets);
    },
  );

  testWidgets('the filter row shows favourites and shorts', (tester) async {
    await tester.pumpWidget(
      host(const LibraryFilterChips(), overrides: base([sample('a')])),
    );
    await tester.pumpAndSettle();
    // Named in words, without the heart and lightning glyphs (audit
    // 2026-10-30: symbols inside labels, coloured on the chrome).
    expect(find.text('المفضلة'), findsOneWidget);
    expect(find.text('قِصار'), findsOneWidget);
    expect(find.textContaining('♥'), findsNothing);
    expect(find.textContaining('⚡'), findsNothing);
  });
}
