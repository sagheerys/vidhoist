import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_media/library.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import '../data/backup_data.dart';
import '../data/channels_data.dart';
import '../data/covers/covers_data.dart';
import '../data/shapes/shapes_data.dart';
import '../data/library_data.dart';
import '../data/folder_watch.dart';
import '../data/keep_awake_data.dart';
import '../data/taskbar_data.dart';
import '../data/lists_data.dart';
import '../data/saved_searches.dart';
import '../data/engine_fetch_data.dart';
import '../di.dart';
import '../features/add/add_dialog.dart';
import '../features/add/add_entry.dart';
import '../features/add/outside_links.dart';
import '../features/clip/clip_state.dart';
import '../features/downloads/downloads_button.dart';
import '../features/folders/folder_tree.dart';
import '../features/listening/listening_layer.dart';
import '../features/listening/listening_room.dart';
import '../features/library/library_state.dart';
import '../features/notices/copied_links_wiring.dart';
import '../features/notices/notices_wiring.dart';
import '../features/palette/palette_entry.dart';
import '../features/palette/palette_grow.dart';
import '../features/settings/backup_actions.dart';
import '../features/welcome/startup_offers.dart';
import '../router.dart';
import 'content_bar.dart';
import 'focus_regions.dart';
import 'keyboard.dart';
import 'mini_window.dart';
import 'nav_history.dart';
import 'panel_fold.dart';
import 'panel_reveal.dart';
import 'panel/transcript_view.dart';
import 'player_bar.dart';
import 'right_panel.dart';
import 'shell_layout.dart';
import 'shell_metrics.dart';
import 'shell_state.dart';
import 'sidebar.dart';
import 'sidebar_items.dart';
import 'title_bar.dart';

part 'desktop_shell_frame.dart';

/// The window's frame around every place: title bar, sidebar, content,
/// side panel and the player bar. Built once for the life of the app (it
/// is the router's shell), so nothing it holds restarts on navigation.
class DesktopShell extends ConsumerStatefulWidget {
  const DesktopShell({super.key, required this.location, required this.child});

  final Uri location;
  final Widget child;

  @override
  ConsumerState<DesktopShell> createState() => _DesktopShellState();
}

/// The id of the saved list whose page [location] is, if it is one.
String? _openList(Uri location) => switch (location.pathSegments) {
  ['playlists', final id] => id,
  _ => null,
};

class _DesktopShellState extends ConsumerState<DesktopShell> {
  NavHistory? _history;
  PanelTab _tab = PanelTab.transcript;

  /// The panel as a layer over the content, in a narrow window only. Not
  /// saved: a layer left open would cover the content on the next start.
  bool _overlayOpen = false;

  /// Whether the panel stands beside the content; folded while idle.
  late final PanelFold _fold;

  /// The panel opened by hand in the reading room, where it is folded:
  /// the article is the transcript, and the panel showed it a second time
  /// beside it. Let go on any move, so each visit starts folded.
  bool _readingPanel = false;

  @override
  void didUpdateWidget(DesktopShell old) {
    super.didUpdateWidget(old);
    if (old.location != widget.location) _readingPanel = false;
  }

  @override
  void initState() {
    super.initState();
    _fold = PanelFold(ref.read(playerProvider))
      ..addListener(() => setState(() {}));
    // The welcome or what is new: one at most (see there).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(startupOffers(context, ref));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _history ??= NavHistory.of(GoRouter.of(context));
  }

  @override
  void dispose() {
    _history?.dispose();
    _fold.dispose();
    super.dispose();
  }

  void _togglePanel(ShellArrangement arranged, ShellLayout layout) {
    if (arranged.panelBeside && isReadingRoom(widget.location)) {
      setState(() => _readingPanel = !_readingPanel);
    } else if (arranged.panelBeside) {
      _fold.toggle(
        layout,
        ref.read(shellLayoutProvider.notifier).setPanelHidden,
        clipPage: placeOf(widget.location) == DesktopPlace.item,
      );
    } else {
      setState(() => _overlayOpen = !_overlayOpen);
    }
  }

  void _showTab(PanelTab tab, ShellArrangement arranged) {
    setState(() {
      _tab = tab;
      _fold.open();
      if (isReadingRoom(widget.location)) _readingPanel = true;
      if (!arranged.panelBeside) _overlayOpen = true;
    });
    if (arranged.panelBeside) {
      ref.read(shellLayoutProvider.notifier).setPanelHidden(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final layout = ref.watch(shellLayoutProvider);
    final player = ref.watch(playerProvider);
    final controls = ref.watch(windowControlsProvider);
    final router = GoRouter.of(context);
    ref.watch(sessionRestoreProvider);
    ref.watch(coverEnrichmentProvider);
    ref.watch(shapeEnrichmentProvider);
    ref.watch(startupBackupProvider);
    ref.watch(engineWeeklyUpdateProvider);
    // Followed channels are checked as they fall due, window or tray.
    ref.watch(channelTickerProvider);
    ref.watch(folderWatchProvider);
    ref.watch(taskbarDownloadsWiringProvider);
    ref.watch(keepAwakeWiringProvider);

    // Theater widens a clip's picture over the side panel's column too.
    final theater =
        ref.watch(theaterProvider) &&
        placeOf(widget.location) == DesktopPlace.item;
    final audioOnly = ref.watch(audioOnlyProvider);
    final listening = ref.watch(listeningProvider);
    DesktopPlayerBar playerBar(ShellArrangement? arranged) => DesktopPlayerBar(
      player: player,
      audioOnly: audioOnly,
      // Full screen is the room, while sound plays.
      listening: listening || arranged == null,
      onListen: () => toggleListening(ref),
      onShowQueue: () => arranged == null
          ? controls.setFullScreen(false)
          : _showTab(PanelTab.upNext, arranged),
      onOpen: (url) => router.go(DesktopRoutes.item(url)),
      onMini: _toggleMini,
    );

    final drop = ref.watch(linkDropProvider);
    // A Scaffold underneath, so notices (`showVhNotice`) have somewhere to
    // appear, above the player bar.
    final scaffold = Scaffold(
      backgroundColor: p.bg,
      body: ValueListenableBuilder<bool>(
        valueListenable: controls.fullScreen,
        builder: (context, full, _) => full
            // The whole screen for the picture, with its controls over it,
            // or the listening room for sound, with the player bar.
            ? ListeningLayer(
                full: true,
                onClose: () => toggleListening(ref),
                bar: playerBar(null),
                child: widget.child,
              )
            : _framed(context, layout, theater, playerBar),
      ),
    );
    // Links reach the add dialog from the button, Ctrl+V anywhere but a
    // text field, a drop on the window (where a phone's backup goes to the
    // import instead), and from outside: a `vidhoist://` link or a link
    // copied elsewhere, when the user asked to be offered those.
    return PaletteShortcut(
      onOpen: _openPalette,
      child: DesktopKeyboard(
        // In the reading room, Ctrl+F finds in its text.
        onSearch: () => (findHere(ref) ?? _openPalette)(),
        onMini: _toggleMini,
        inShortsLane: () =>
            placeOf(widget.location) == DesktopPlace.item &&
            (player.state.current?.isShortForm ?? false),
        child: NoticesWiring(
          child: OutsideLinks(
            child: CopiedLinksWiring(
              child: AddShortcut(
                onLinks: _openAdd,
                // The small card in place of the frame, the wirings above it
                // still listening.
                child: drop(
                  ValueListenableBuilder<bool>(
                    valueListenable: controls.mini,
                    builder: (context, mini, _) => mini
                        ? DesktopMiniWindow(
                            player: player,
                            controls: controls,
                            onRestore: _toggleMini,
                          )
                        : scaffold,
                  ),
                  _onDrop,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The palette is the search: Ctrl+K and the search box open it, and a
  /// saved search opens it on its query.
  void _openPalette([String initial = '']) => unawaited(
    openPalette(
      context,
      ref,
      onAdd: () => unawaited(_addFromButton()),
      initial: initial,
      from: paletteAnchor(_searchBox, context),
    ),
  );

  /// The title bar's search box, which the palette opens out of.
  final _searchBox = GlobalKey();

  void _toggleMini() => toggleMiniWindow(ref, GoRouter.of(context));

  void _openAdd([String text = '']) =>
      unawaited(openAddDialog(context, text: text));

  /// A dropped phone backup or transcripts file is imported; anything
  /// else is links for the add dialog.
  void _onDrop(String text) => isBackupText(text)
      ? unawaited(importFromPhone(context, ref, text))
      : _openAdd(text);

  /// The button offers what the clipboard holds, as the phone's does.
  Future<void> _addFromButton() async {
    final text = await clipboardLinks();
    if (mounted) _openAdd(text);
  }

  void _pickTab(PanelTab tab) => setState(() => _tab = tab);

  void _closeOverlay() => setState(() => _overlayOpen = false);
}
