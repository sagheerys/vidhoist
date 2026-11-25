import 'features/pc/pc_lists_screen.dart';
import 'features/pc/pc_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_ui/vh_ui.dart';

import 'di.dart';
import 'features/accounts/login_screen.dart';
import 'features/accounts/login_sites.dart';
import 'features/audio/audio_screen.dart';
import 'features/batch/batch_screen.dart';
import 'features/settings/language_screen.dart';
import 'features/downloads_library/library_screen.dart';
import 'features/engine/welcome_screen.dart';
import 'features/player/player_screen.dart';
import 'features/player/reels_screen.dart';
import 'features/playlists/playlist_add_clips_screen.dart';
import 'features/playlists/playlist_details_screen.dart';
import 'features/playlists/playlists_screen.dart';
import 'features/settings/settings_page.dart';
import 'features/settings/settings_screen.dart';
import 'features/settings/settings_sections.dart';
import 'features/shell/shell_screen.dart';
import 'features/star/star_ask_prompt.dart';

/// The single route table. No direct Navigator.push.
final router = GoRouter(
  // Tells the shell what has opened above it so it can hide the floating
  // add button, which used to be drawn over every bottom sheet and dialog,
  // covering their content.
  observers: [VhRouteDepth.instance],
  // A first run readies the engine before anything else opens.
  redirect: (context, state) => welcomeRedirect(
    welcomed: ProviderScope.containerOf(
      context,
      listen: false,
    ).read(settingsProvider).welcomed,
    location: state.matchedLocation,
  ),
  routes: [
    GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
    StatefulShellRoute(
      builder: (context, state, navigationShell) =>
          ShellScreen(navigationShell: navigationShell),
      // The sections fade into one another rather than cut.
      navigatorContainerBuilder: (context, navigationShell, children) =>
          VhTabStack(index: navigationShell.currentIndex, children: children),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const StarAskPrompt(child: LibraryScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/playlists',
              builder: (_, _) => const PlaylistsScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (_, state) => PlaylistDetailsScreen(
                    playlistId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (_, _) => const SettingsScreen(),
              routes: [
                // A route per section, so a message can open the page
                // that fixes its problem.
                for (final pane in SettingsPane.values)
                  GoRoute(
                    path: pane.name,
                    builder: (_, _) => SettingsPage(pane),
                  ),
                GoRoute(
                  path: 'language',
                  builder: (_, _) => const LanguageScreen(),
                ),
                // A site's sign-in page, pushed over Settings › Accounts
                // so that leaving it lands back on the accounts.
                GoRoute(
                  path: 'login/:site',
                  builder: (_, state) => LoginScreen(
                    LoginSite.byName(state.pathParameters['site'] ?? '') ??
                        LoginSite.youtube,
                  ),
                ),
              ],
            ),
          ],
        ),
        // The paired computer, last so that the branches before it keep
        // their numbers; the shell shows its tab only once paired.
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/pc',
              builder: (_, _) => const PcScreen(),
              routes: [
                GoRoute(
                  path: 'lists',
                  builder: (_, _) => const PcListsScreen(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (_, state) =>
                          PcListScreen(id: state.pathParameters['id']!),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    // The batch screen: the URL is passed through `extra` by automatic
    // routing.
    GoRoute(
      path: '/batch',
      builder: (_, state) =>
          BatchScreen(playlistUrl: (state.extra ?? '').toString()),
    ),
    // Opened over the whole shell, not inside the playlists tab: inside it,
    // the screen's own add button would sit between the mini player and
    // the shell's add-link button.
    GoRoute(
      path: '/playlist-add/:id',
      builder: (_, state) =>
          PlaylistAddClipsScreen(playlistId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/player', builder: (_, _) => const PlayerScreen()),
    GoRoute(path: '/reels', builder: (_, _) => const ReelsScreen()),
    // **The audio screen rises out of the mini player like a sheet** and is
    // dragged down to return to it, rather than the
    // horizontal slide used for every other route, because the relationship
    // here is "expanding" rather than "going deeper".
    GoRoute(
      path: '/audio',
      pageBuilder: (_, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const AudioScreen(),
        // **Non-opaque**: what is beneath stays drawn, so dragging it down
        // shows the cover and the mini player behind it rather than a black
        // background.
        opaque: false,
        transitionDuration: VhMotion.sheetPage,
        reverseTransitionDuration: VhMotion.leave,
        transitionsBuilder: vhSheetPageTransition,
      ),
    ),
  ],
);
