import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/player/playback_providers.dart';
import 'package:vidhoist_mobile/features/playlists/widgets/playlist_cards.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

/// **Guards from a device review**: two visual flaws seen on
/// the device, each with a root in a single line.
void main() {
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

  testWidgets(
    "a playlist card cover fills the cover's height, not a band across its middle",
    (tester) async {
      const marker = Key('cover-0');
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 200,
            height: 260,
            child: PlaylistCard(
              playlist: SavedPlaylist(
                id: 'p1',
                name: 'قائمة',
                items: const [],
                createdAt: DateTime(2026),
              ),
              thumbnails: const [
                ColoredBox(key: marker, color: Color(0xFF123456)),
              ],
              onTap: () {},
              onPlay: () {},
              onLongPress: () {},
            ),
          ),
        ),
      );

      final cover = tester.getSize(find.byKey(marker)).height;
      // The root: `Row` defaults to `center`, so the image took its natural
      // height and centred itself, a thin strip in the middle of an empty
      // card.
      expect(
        cover,
        greaterThan(120),
        reason: 'الغلاف يشغل ما تبقى من البطاقة بعد الاسم والعدّاد',
      );
    },
  );

  testWidgets(
    'the cover builder returns null for an item with no cover, never an empty widget',
    (tester) async {
      Widget? built = const SizedBox.shrink();
      await tester.pumpWidget(
        host(
          Consumer(
            builder: (context, ref, _) {
              built = artworkBuilderFor(ref)(
                context,
                const PlaylistItem(
                  canonicalUrl: 'https://x/a',
                  title: 'بلا غلاف',
                  localPath: '/media/a.mp3',
                  isAudio: true,
                ),
              );
              return const SizedBox.shrink();
            },
          ),
          overrides: [
            keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
            secretStoreProvider.overrideWithValue(MemorySecretStore()),
            initialSettingsProvider.overrideWithValue(const PhoneSettings()),
          ],
        ),
      );

      // `?? const SizedBox.shrink()` here killed the fallback icon in the
      // audio player and the mini player: a blank square with nothing in it.
      expect(built, isNull);
    },
  );
}
