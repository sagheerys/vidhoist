import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_ui/vh_ui.dart';

import 'data/appearance_data.dart';
import 'data/system_media.dart';
import 'features/library/artwork.dart';
import 'identity.dart';
import 'features/channels/channel_page.dart';
import 'features/channels/channels_page.dart';
import 'features/clip/clip_page.dart';
import 'features/reading/reading_room.dart';
import 'features/library/library_page.dart';
import 'features/lists/lists_page.dart';
import 'features/lists/playlist_page.dart';
import 'features/settings/settings_place.dart';
import 'features/stats/stats_page.dart';
import 'router.dart';
import 'shell/shell_metrics.dart';
import 'shell/desktop_shell.dart';
import 'shell/key_gate.dart';
import 'shell/zoom_frame.dart';

/// The Vidhoist root: the desktop theme, day or night, and the language
/// as chosen in Appearance (Windows' own by default), plus the router.
class DesktopApp extends ConsumerStatefulWidget {
  const DesktopApp({super.key, this.router, this.locale, this.initialLocation});

  /// For tests; the app builds its own otherwise.
  final GoRouter? router;

  /// A language chosen for development (`--lab-locale`), over the one
  /// chosen in Appearance.
  final Locale? locale;

  /// The page to open on, for development (`--lab-route`); null opens the
  /// library.
  final String? initialLocation;

  @override
  ConsumerState<DesktopApp> createState() => _DesktopAppState();
}

class _DesktopAppState extends ConsumerState<DesktopApp> {
  @override
  void initState() {
    super.initState();
    // Windows' media flyout reads the clip's cover from this computer.
    ref.read(systemMediaBridgeProvider)?.coverFile = (url, artwork) =>
        coverFileOf(ref, url, artwork);
  }

  // Built once for the life of the app: a router rebuilt with the widget
  // would reset the navigation and everything living under the shell.
  late final GoRouter _router =
      widget.router ??
      buildDesktopRouter(
        initialLocation: widget.initialLocation ?? DesktopRoutes.library,
        shell: (_, state, child) =>
            DesktopShell(location: state.uri, child: child),
        library: (only) =>
            LibraryPage(key: ValueKey(only), scope: LibraryPage.scopeOf(only)),
        item: (url) => ClipPage(key: ValueKey(url), canonicalUrl: url ?? ''),
        reading: (url) =>
            ReadingRoom(key: ValueKey(url), canonicalUrl: url ?? ''),
        playlists: (id) => id == null
            ? const ListsPage()
            : PlaylistPage(key: ValueKey(id), id: id),
        channels: (id) => id == null
            ? const ChannelsPage()
            : ChannelPage(key: ValueKey(id), id: id),
        stats: (_) => const StatsPage(),
        settings: (pane) => SettingsPlace(
          pane:
              DesktopSettingsPane.values.asNameMap()[pane] ??
              DesktopSettingsPane.engine,
        ),
      );

  @override
  Widget build(BuildContext context) {
    // Declares this the Windows app, the only place that does, so shared
    // layouts may take their desktop branch here and never on a phone.
    final look = ref.watch(appearanceProvider);
    final chosen = look.locale;
    return VhDesktopApp(
      noticeLift: DesktopShellSize.playerBar,
      child: MaterialApp.router(
        title: DesktopIdentity.displayName,
        debugShowCheckedModeBanner: false,
        theme: vhDesktopTheme(VhVariant.desktop, Brightness.light),
        darkTheme: vhDesktopTheme(VhVariant.desktop, Brightness.dark),
        // Chosen by Flutter itself while Windows' high contrast is on.
        highContrastTheme: vhDesktopTheme(
          VhVariant.desktop,
          Brightness.light,
          highContrast: true,
        ),
        highContrastDarkTheme: vhDesktopTheme(
          VhVariant.desktop,
          Brightness.dark,
          highContrast: true,
        ),
        themeMode: look.theme,
        locale: widget.locale ?? (chosen == null ? null : Locale(chosen)),
        localizationsDelegates: VhLocalizations.localizationsDelegates,
        supportedLocales: VhLocalizations.supportedLocales,
        localeListResolutionCallback: vhLocaleResolution,
        routerConfig: _router,
        builder: (context, child) => KeyGate(
          child: DesktopZoomFrame(
            onChangeZoom: () =>
                _router.go(DesktopSettingsPane.appearance.route),
            child: child!,
          ),
        ),
      ),
    );
  }
}

/// The vh_ui component sheet for review by eye (`--gallery`, with
/// `--night` and `--ltr`), outside the app's storage and player.
class DesktopGalleryApp extends StatelessWidget {
  const DesktopGalleryApp({super.key, this.night = false, this.arabic = true});

  final bool night;
  final bool arabic;

  @override
  Widget build(BuildContext context) {
    return VhDesktopApp(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: vhDesktopTheme(VhVariant.desktop, Brightness.light),
        darkTheme: vhDesktopTheme(VhVariant.desktop, Brightness.dark),
        themeMode: night ? ThemeMode.dark : ThemeMode.light,
        home: VhGallery(arabic: arabic),
      ),
    );
  }
}
