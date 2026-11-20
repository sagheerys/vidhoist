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
        final panelShown =
            !theater &&
            (arranged.panelBeside
                ? _fold.shown(layout, clipPage: place == DesktopPlace.item)
                : _overlayOpen);
        final panel = inRegion(
          DesktopRegion.panel,
          StreamBuilder<VhPlayerState>(
            stream: player.states,
            initialData: player.state,
            builder: (context, snap) => DesktopRightPanel(
              tab: _tab,
              onTab: (tab) => _pickTab(tab),
              state: snap.data ?? player.state,
              player: player,
            ),
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
                          folders: sidebarFolders(
                            ref.watch(libraryItemsProvider).valueOrNull ??
                                const [],
                            folder,
                          ),
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
                          onGo: (to) => to == DesktopRoutes.search
                              ? _openPalette()
                              : router.go(to),
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
}
