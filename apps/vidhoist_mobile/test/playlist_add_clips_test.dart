import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/playlists/playlist_add_clips_screen.dart';
import 'package:vidhoist_mobile/features/playlists/playlists_providers.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'device_matrix.dart';

/// **Adding clips from inside a playlist**: tick in the library, add in
/// the order ticked, never twice, with an undo.
void main() {
  LocalItem clip(String name, {String ext = 'mp4'}) => LocalItem(
    key: 'https://v/$name',
    path: '/storage/emulated/0/Download/VidHoist/$name.$ext',
    title: name,
    sizeBytes: 1000000,
    modified: DateTime(2026, 11, 23),
  );

  final library = [
    clip('Morning walk'),
    clip('Rain sounds', ext: 'm4a'),
    clip('Evening talk'),
    clip('Night drive', ext: 'mp3'),
  ];

  late ProviderContainer container;
  late PlaylistsStore store;
  late SavedPlaylist playlist;

  Future<Widget Function()> hostFor(Locale locale) async {
    final kv = MemoryKeyValueStore();
    final mutex = PrefsMutex();
    store = PlaylistsStore(store: kv, mutex: mutex);
    playlist = await store.create(
      'Drive',
      items: [toPlaylistEntry(library[2])],
    );
    return () {
      container = ProviderContainer(
        overrides: [
          keyValueStoreProvider.overrideWithValue(kv),
          prefsMutexProvider.overrideWithValue(mutex),
          playlistsStoreProvider.overrideWithValue(store),
          localMediaProvider.overrideWith((ref) async => library),
        ],
      );
      addTearDown(container.dispose);
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          theme: vhTheme(VhVariant.phone, Brightness.light),
          home: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (_) => const Scaffold(body: Text('playlist')),
            ),
            initialRoute: '/',
            onGenerateInitialRoutes: (_, _) => [
              MaterialPageRoute<void>(
                builder: (_) => const Scaffold(body: Text('playlist')),
              ),
              MaterialPageRoute<void>(
                builder: (_) => PlaylistAddClipsScreen(playlistId: playlist.id),
              ),
            ],
          ),
        ),
      );
    };
  }

  Future<List<String>> saved() async => [
    for (final entry in (await store.byId(playlist.id))!.items)
      entry.canonicalUrl,
  ];

  testWidgets('adds what was ticked, in the order ticked, and undoes it', (
    tester,
  ) async {
    final host = await tester.runAsync(() => hostFor(const Locale('en')));
    await tester.pumpWidget(host!());
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(PlaylistAddClipsScreen)).vhl;

    // Nothing ticked: nothing to add.
    final add = find.widgetWithText(FilledButton, l10n.playlistAddCount(0));
    expect(tester.widget<FilledButton>(add).onPressed, isNull);

    await tester.tap(find.text('Night drive'));
    await tester.tap(find.text('Morning walk'));
    await tester.pump();
    await tester.tap(find.text(l10n.playlistAddCount(2)));
    await tester.pumpAndSettle();

    expect(await tester.runAsync(saved), [
      'https://v/Evening talk',
      'https://v/Night drive',
      'https://v/Morning walk',
    ]);
    expect(find.text('playlist'), findsOneWidget);
    expect(find.text(l10n.addedToPlaylistCount(2)), findsOneWidget);

    await tester.tap(find.text(l10n.undo));
    await tester.pumpAndSettle();
    expect(await tester.runAsync(saved), ['https://v/Evening talk']);
  });

  testWidgets('what the playlist holds is marked and cannot be ticked', (
    tester,
  ) async {
    final host = await tester.runAsync(() => hostFor(const Locale('en')));
    await tester.pumpWidget(host!());
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(PlaylistAddClipsScreen)).vhl;

    expect(find.text(l10n.alreadyInPlaylist), findsOneWidget);
    await tester.tap(find.text('Evening talk'));
    await tester.pump();
    expect(find.text(l10n.playlistAddCount(0)), findsOneWidget);
  });

  testWidgets('search and the type narrow the list', (tester) async {
    final host = await tester.runAsync(() => hostFor(const Locale('en')));
    await tester.pumpWidget(host!());
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(PlaylistAddClipsScreen)).vhl;

    await tester.tap(find.text(l10n.filterAudio));
    await tester.pumpAndSettle();
    expect(find.text('Morning walk'), findsNothing);
    expect(find.text('Rain sounds'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'night');
    await tester.pumpAndSettle();
    expect(find.text('Rain sounds'), findsNothing);
    expect(find.text('Night drive'), findsOneWidget);
  });

  testWidgets('**device matrix**: the picker never overflows', (tester) async {
    for (final locale in const [Locale('ar'), Locale('en')]) {
      final host = await tester.runAsync(() => hostFor(locale));
      await expectNoOverflow(tester, host!);
    }
  });
}
