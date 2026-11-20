import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart' show SavedPlaylist;
import 'package:vh_ui/vh_ui.dart';

import '../data/saved_searches.dart';
import '../data/update_data.dart';
import '../features/folders/folder_tree.dart';
import '../router.dart';
import 'engine_line.dart';
import 'shell_metrics.dart';
import 'sidebar_items.dart';

/// The sidebar: adding a link on top, the places, then settings at the
/// foot. 240 wide with labels, or 72 with icons alone and the labels in
/// tooltips.
class DesktopSidebar extends StatelessWidget {
  const DesktopSidebar({
    super.key,
    required this.narrow,
    required this.current,
    required this.onGo,
    this.onAdd,
    this.pinned = const [],
    this.currentList,
    this.folders = const [],
    this.currentFolder,
    this.onFolder,
    this.searches = const [],
    this.onSavedSearch,
    this.onSavedSearchMenu,
  });

  /// The saved searches, under "Search", each opening the palette on its
  /// query.
  final List<SavedSearch> searches;
  final ValueChanged<SavedSearch>? onSavedSearch;
  final void Function(SavedSearch search, Offset at)? onSavedSearchMenu;

  final bool narrow;
  final DesktopPlace current;
  final ValueChanged<String> onGo;

  /// null until the add dialog exists; the button stays, dimmed.
  final VoidCallback? onAdd;

  /// The pinned lists, under "Playlists", each a place of its own.
  final List<SavedPlaylist> pinned;

  /// The id of the list whose page is open, if one is.
  final String? currentList;

  /// The folders the library's clips sit in, unfolded along the
  /// chosen one; a click filters the library by it.
  final List<SidebarFolder> folders;

  /// The folder the library is filtered by, when the library is on show.
  final String? currentFolder;
  final ValueChanged<String>? onFolder;

  /// The places' width inside the wide sidebar's padding.
  static const _wideInside = DesktopShellSize.sidebarWide - 2 * _pad;
  static const _pad = VhSpace.md;

  /// The hairline at its edge, which the container keeps out of the places
  /// too, and a little more for rounding.
  static const _border = 2.0;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return AnimatedContainer(
      duration: vhMotionDuration(context, VhMotion.medium),
      curve: VhMotion.ease,
      width: narrow
          ? DesktopShellSize.sidebarNarrow
          : DesktopShellSize.sidebarWide,
      decoration: BoxDecoration(
        color: p.bg,
        border: BorderDirectional(
          end: BorderSide(color: p.line, width: VhThemeX.of(context).hairline),
        ),
      ),
      padding: const EdgeInsets.all(_pad),
      // Widening, the places keep their narrow form until the sidebar has
      // room for their names: laid out wide in a width still growing, a
      // line with a count ran over its end (the window's own resizing
      // widens it too).
      child: LayoutBuilder(
        builder: (context, box) =>
            _places(context, narrow || box.maxWidth < _wideInside - _border),
      ),
    );
  }

  Widget _places(BuildContext context, bool narrow) {
    final l = context.vhl;
    final onPinned = pinned.any((list) => list.id == currentList);
    Widget item(
      DesktopPlace place,
      VhIconData icon,
      VhIconData filled,
      String label,
      String to,
    ) => SidebarItem(
      icon: icon,
      selectedIcon: filled,
      label: label,
      narrow: narrow,
      selected: current == place && !onPinned,
      onTap: () => onGo(to),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SidebarAddButton(narrow: narrow, label: l.addLinkFab, onTap: onAdd),
        const SizedBox(height: VhSpace.lg),
        // The places scroll, so pinned lists never push settings off a
        // short window.
        Expanded(
          child: ListView(
            children: [
              item(
                DesktopPlace.library,
                VhIcons.library,
                VhIcons.libraryFill,
                l.navLibrary,
                DesktopRoutes.library,
              ),
              item(
                DesktopPlace.favorites,
                VhIcons.favorite,
                VhIcons.favoriteOn,
                l.favorites,
                DesktopRoutes.favorites,
              ),
              item(
                DesktopPlace.search,
                VhIcons.search,
                VhIcons.searchFill,
                l.desktopSearch,
                DesktopRoutes.search,
              ),
              for (final search in searches)
                SidebarItem(
                  key: ValueKey('search-${search.id}'),
                  icon: VhIcons.search,
                  label: search.name,
                  narrow: narrow,
                  indent: true,
                  selected: false,
                  onTap: () => onSavedSearch?.call(search),
                  onMenu: onSavedSearchMenu == null
                      ? null
                      : (at) => onSavedSearchMenu!(search, at),
                ),
              const SizedBox(height: VhSpace.lg),
              item(
                DesktopPlace.playlists,
                VhIcons.queue,
                VhIcons.queueFill,
                l.navPlaylists,
                DesktopRoutes.playlists,
              ),
              for (final list in pinned)
                SidebarItem(
                  key: ValueKey('pinned-${list.id}'),
                  icon: VhIcons.queue,
                  selectedIcon: VhIcons.queueFill,
                  label: list.name,
                  narrow: narrow,
                  indent: true,
                  selected: list.id == currentList,
                  onTap: () => onGo(DesktopRoutes.playlist(list.id)),
                ),
              item(
                DesktopPlace.channels,
                VhIcons.subscriptions,
                VhIcons.subscriptionsFill,
                l.desktopChannels,
                DesktopRoutes.channels,
              ),
              if (folders.isNotEmpty && onFolder != null) ...[
                const SizedBox(height: VhSpace.lg),
                for (final folder in folders)
                  // Narrow, only the top level: icons alone cannot show
                  // nesting.
                  if (!narrow || folder.depth == 0)
                    SidebarItem(
                      key: ValueKey('folder-${folder.path}'),
                      icon: VhIcons.folder,
                      label: vhName(folder.path.split('/').last),
                      trailing: '${folder.count}',
                      narrow: narrow,
                      depth: folder.depth,
                      selected: folder.path == currentFolder,
                      onTap: () => onFolder!(folder.path),
                    ),
              ],
            ],
          ),
        ),
        SidebarEngineLine(narrow: narrow),
        // Its toggle is in the title bar, above it. A dot while an update
        // waits, which the notice at start said only for a few seconds.
        Consumer(
          builder: (context, ref, _) {
            final release = ref.watch(updateProvider).release;
            return SidebarItem(
              icon: VhIcons.settings,
              selectedIcon: VhIcons.settingsFill,
              label: l.navSettings,
              narrow: narrow,
              selected: current == DesktopPlace.settings && !onPinned,
              onTap: () => onGo(DesktopRoutes.settings),
              dot: release == null
                  ? null
                  : l.updateVersionAvailable(release.version.toString()),
            );
          },
        ),
      ],
    );
  }
}
