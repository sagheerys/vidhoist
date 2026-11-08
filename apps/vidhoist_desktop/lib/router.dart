import 'package:flutter/material.dart' show MaterialPage;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// The settings sections: the phone app's, plus the two only a computer
/// has (the desktop habits, and the offline and download folders).
enum DesktopSettingsPane {
  engine,
  subscriptions,
  cookies,
  downloads,
  folders,
  appearance,
  desktop,
  transcripts,
  backup,
  sync,
  updates,
  logs,
  about;

  /// **Each section has its own address**, so a message about a problem
  /// can open the very page that fixes it.
  String get route => '/settings/$name';
}

/// The addresses of the app's places.
abstract final class DesktopRoutes {
  static const library = '/library';

  /// Favourites are the library seen through a filter, so the filter chip
  /// and this sidebar entry are one state.
  static const favorites = '/library?only=favorites';
  static const search = '/search';
  static const playlists = '/playlists';
  static const channels = '/channels';
  static const settings = '/settings';

  /// The library counted: by site, channel and month.
  static const stats = '/stats';

  /// One clip's page. The key is a canonical URL, full of slashes and
  /// question marks, so it travels percent-encoded as one path segment.
  static String item(String canonicalUrl) =>
      '/item/${Uri.encodeComponent(canonicalUrl)}';

  /// One clip's reading room, its transcript as an article.
  static String reading(String canonicalUrl) =>
      '/read/${Uri.encodeComponent(canonicalUrl)}';

  /// One saved list's page, by its id.
  static String playlist(String id) => '$playlists/${Uri.encodeComponent(id)}';

  /// One followed channel's page, by its id.
  static String channel(String id) => '$channels/${Uri.encodeComponent(id)}';
}

/// The places the sidebar can show as current.
enum DesktopPlace {
  library,
  favorites,
  search,
  playlists,
  channels,
  settings,
  item,
}

/// Which place [location] is, for the sidebar's highlight.
DesktopPlace placeOf(Uri location) {
  final first = location.pathSegments.firstOrNull;
  return switch (first) {
    'library' => switch (location.queryParameters['only']) {
      'favorites' => DesktopPlace.favorites,
      _ => DesktopPlace.library,
    },
    'search' => DesktopPlace.search,
    'playlists' => DesktopPlace.playlists,
    'channels' => DesktopPlace.channels,
    'settings' => DesktopPlace.settings,
    // The library seen as figures: its place stays lit.
    'stats' => DesktopPlace.library,
    _ => DesktopPlace.item,
  };
}

/// Builds the shell around every place; the drawn shell replaces the
/// pass-through default.
typedef DesktopShellBuilder = Widget Function(
  BuildContext context,
  GoRouterState state,
  Widget child,
);

Widget _bare(BuildContext context, GoRouterState state, Widget child) => child;

/// Builds a place from its query argument.
typedef DesktopPlaceBuilder = Widget Function(String? argument);

Widget _pendingLibrary(String? only) => PendingPlace('library', argument: only);

Widget _pendingItem(String? canonicalUrl) =>
    PendingPlace('item', argument: canonicalUrl);

Widget _pendingReading(String? canonicalUrl) =>
    PendingPlace('read', argument: canonicalUrl);

Widget _pendingPlaylists(String? id) => PendingPlace('playlists', argument: id);

Widget _pendingChannels(String? id) => PendingPlace('channels', argument: id);

Widget _pendingStats(String? _) => const PendingPlace('stats');

Widget _pendingSettings(String? pane) =>
    PendingPlace('settings', argument: pane);

/// The single route table. One router per app, built once, so the shell
/// and the player under it live through every navigation.
GoRouter buildEmberRouter({
  String initialLocation = DesktopRoutes.library,
  DesktopShellBuilder shell = _bare,
  DesktopPlaceBuilder library = _pendingLibrary,
  DesktopPlaceBuilder item = _pendingItem,
  DesktopPlaceBuilder reading = _pendingReading,
  DesktopPlaceBuilder playlists = _pendingPlaylists,
  DesktopPlaceBuilder channels = _pendingChannels,
  DesktopPlaceBuilder settings = _pendingSettings,
  DesktopPlaceBuilder stats = _pendingStats,
}) => GoRouter(
  initialLocation: initialLocation,
  // An address that names no place (an old link, a typo in a protocol
  // link) lands on the library rather than an error page.
  onException: (_, _, router) => router.go(DesktopRoutes.library),
  routes: [
    GoRoute(path: '/', redirect: (_, _) => DesktopRoutes.library),
    ShellRoute(
      builder: shell,
      routes: [
        GoRoute(
          path: DesktopRoutes.library,
          pageBuilder: (_, state) => _ownPage(
            state.uri.queryParameters['only'] ?? '',
            library(state.uri.queryParameters['only']),
          ),
        ),
        // Search lives in the command palette, which the sidebar opens; an
        // address for it (a link from outside) lands on the library rather
        // than on a blank page.
        GoRoute(
          path: DesktopRoutes.search,
          redirect: (_, _) => DesktopRoutes.library,
        ),
        // A null argument is the place itself; an id is one list or one
        // channel in it.
        for (final (path, build) in [
          (DesktopRoutes.playlists, playlists),
          (DesktopRoutes.channels, channels),
        ])
          GoRoute(
            path: path,
            builder: (_, _) => build(null),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, state) => build(state.pathParameters['id']),
              ),
            ],
          ),
        GoRoute(
          path: '/item/:id',
          pageBuilder: (_, state) => _ownPage(
            'item ${state.pathParameters['id']}',
            item(state.pathParameters['id']),
          ),
        ),
        GoRoute(
          path: '/read/:id',
          pageBuilder: (_, state) => _ownPage(
            'read ${state.pathParameters['id']}',
            reading(state.pathParameters['id']),
          ),
        ),
        GoRoute(path: DesktopRoutes.stats, builder: (_, _) => stats(null)),
        // **One page for every section**, under one key: moving between
        // sections updates the page in place, so the list of sections
        // stays still and only the open section changes (with its own
        // fade, see SettingsPlace). As routes nested in one another, each
        // section was a new page sliding in whole.
        GoRoute(
          path: DesktopRoutes.settings,
          pageBuilder: (_, _) => _settingsPage(settings(null)),
        ),
        GoRoute(
          path: '${DesktopRoutes.settings}/:pane',
          // A section that does not exist names no place.
          redirect: (_, state) =>
              DesktopSettingsPane.values.asNameMap().containsKey(
                state.pathParameters['pane'],
              )
              ? null
              : DesktopRoutes.library,
          pageBuilder: (_, state) =>
              _settingsPage(settings(state.pathParameters['pane'])),
        ),
      ],
    ),
  ],
);

/// A page keyed by what it shows, not by the route's pattern: **one clip to
/// another, or the library to its favourites, is a change of page** and
/// moves as the rest do. Keyed by the pattern, only the content was swapped,
/// in one frame.
Page<void> _ownPage(String key, Widget child) =>
    MaterialPage(key: ValueKey(key), child: child);

Page<void> _settingsPage(Widget child) =>
    MaterialPage(key: const ValueKey('settings'), child: child);

/// Stands in for a place whose screen comes in a later step; it draws
/// nothing, and tests find it by [place] and [argument].
class PendingPlace extends StatelessWidget {
  const PendingPlace(this.place, {this.argument, super.key});

  final String place;
  final String? argument;

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}
