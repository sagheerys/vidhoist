part of 'desktop_shell.dart';

/// The window laid out for its width: the sidebar, the content, the side
/// panel beside it or over it, and the player bar.
extension _Frame on _DesktopShellState {
  Widget _framed(
    BuildContext context,
    ShellLayout layout,
    bool theater,
    DesktopPlayerBar Function(ShellArrangement) playerBar,
  ) {
    final player = ref.read(playerProvider);
    final controls = ref.read(windowControlsProvider);
    final router = GoRouter.of(context);
    return LayoutBuilder(
      builder: (context, box) {
        final arranged = arrangeShell(box.maxWidth, layout);
        final place = placeOf(widget.location);
        final folder = ref.watch(libraryViewProvider).folder;
        final library = ref.watch(libraryItemsProvider).valueOrNull ?? const [];
        final pageUrl = clipPageUrl(widget.location);
        final panelShown =
            !theater &&
            (!arranged.panelBeside
                ? _overlayOpen
                : isReadingRoom(widget.location)
                ? _readingPanel
                : _fold.shown(layout, clipPage: place == DesktopPlace.item));
        final panel = inRegion(
          DesktopRegion.panel,
          StreamBuilder<VhPlayerState>(
            stream: player.states,
            initialData: player.state,
            builder: (context, snap) {
              final state = snap.data ?? player.state;
              return DesktopRightPanel(
                tab: _tab,
                onTab: (tab) => _pickTab(tab),
                state: state,
                player: player,
                page: _pageClip(pageUrl, state, library),
              );
            },
          ),
        );
        return regionsInOrder(
          Column(
            children: [
              DesktopTitleBar(
                controls: controls,
                startWidth: arranged.sidebarWidth,
                sidebarToggle: arranged.canWidenSidebar
                    ? inRegion(
                        DesktopRegion.sidebar,
                        SidebarToggle(
                          narrow: arranged.sidebarNarrow,
                          onTap: () => ref
                              .read(shellLayoutProvider.notifier)
                              .setSidebarNarrow(!layout.sidebarNarrow),
                        ),
                      )
                    : null,
                tools: inRegion(
                  DesktopRegion.contentBar,
                  DesktopContentBar(
                    history: _history!,
                    onSearch: _openPalette,
                    searchKey: _searchBox,
                    panelShown: panelShown,
                    onTogglePanel: () => _togglePanel(arranged, layout),
                    downloads: const DownloadsButton(),
                  ),
                ),
              ),
              Expanded(
                child: ListeningLayer(
                  full: false,
                  onClose: () => toggleListening(ref),
                  bar: inRegion(DesktopRegion.playerBar, playerBar(arranged)),
                  child: Row(
                    children: [
                      inRegion(
                        DesktopRegion.sidebar,
                        DesktopSidebar(
                          narrow: arranged.sidebarNarrow,
                          current: place,
                          pinned: ref.watch(pinnedPlaylistsProvider),
                          currentList: _openList(widget.location),
                          folders: sidebarFolders(library, folder),
                          currentFolder: place == DesktopPlace.library
                              ? folder
                              : null,
                          onFolder: (path) {
                            // The chosen folder again goes up a level.
                            final view = ref.read(libraryViewProvider.notifier);
                            view.setFolder(
                              path == folder && place == DesktopPlace.library
                                  ? parentFolder(path)
                                  : path,
                            );
                            router.go(DesktopRoutes.library);
                          },
                          onGo: (to) => router.go(to),
                          searches:
                              ref.watch(savedSearchesProvider).valueOrNull ??
                              const [],
                          onSavedSearch: (search) => _openPalette(search.query),
                          onSavedSearchMenu: (search, at) => unawaited(
                            savedSearchMenu(context, ref, search, at),
                          ),
                          onAdd: () => unawaited(_addFromButton()),
                        ),
                      ),
                      // The layer opens over the content only, under the
                      // title bar with its toggle.
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: inRegion(
                                DesktopRegion.content,
                                widget.child,
                                focus: ref.watch(contentFocusProvider),
                              ),
                            ),
                            if (!arranged.panelBeside && !theater)
                              ...overlayPanel(
                                open: _overlayOpen,
                                onClose: () => _closeOverlay(),
                                panel: panel,
                              ),
                          ],
                        ),
                      ),
                      if (arranged.panelBeside)
                        PanelReveal(shown: panelShown, child: panel),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// The clip whose page is open, for the panel to be about: the playing
  /// one when it is that clip, else the library's; null off a clip's page,
  /// or for a page of something the library no longer holds.
  PlaylistItem? _pageClip(
    String? url,
    VhPlayerState state,
    List<LibraryItem> library,
  ) {
    if (url == null) return null;
    if (state.current case final current? when current.canonicalUrl == url) {
      return current;
    }
    final entry = library.where((i) => i.canonicalUrl == url).firstOrNull;
    return entry == null ? null : toPlaylistItem(entry);
  }
}
