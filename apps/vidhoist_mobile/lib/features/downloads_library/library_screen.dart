import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../home/network_gate.dart';
import '../shared/error_text.dart';
import '../player/playback_providers.dart';
import '../storage/phone_volumes.dart';
import '../transcripts/said_results.dart';
import 'item_reveal.dart';
import 'library_providers.dart';
import 'local_item.dart';
import 'media_access.dart';
import 'widgets/media_access_view.dart';
import 'widgets/downloads_sheet.dart';
import 'widgets/task_card_parts.dart';
import 'widgets/library_cards.dart';
import 'widgets/library_app_bars.dart';
import 'widgets/library_chips.dart';

/// "My downloads", the local library: live cards only while something is
/// active, plus a counter badge in the header that opens the management
/// sheet. Search is always visible.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  /// The highlight from a completion-notification tap is **temporary**. It
  /// used to be set and never cleared, so the item kept a "selected" look
  /// forever.
  static const highlightDuration = Duration(seconds: 6);
  Timer? _highlightTimer;

  /// The search field is open in the bar's place.
  bool _searchOpen = false;

  final _scroll = ScrollController();

  /// The item a notification tap asked for, and the key its card carries
  /// so the list can scroll to it once it is built.
  String? _revealing;
  final _revealTarget = GlobalKey();

  void _clearHighlight() {
    _highlightTimer?.cancel();
    _highlightTimer = null;
    if (ref.read(highlightedItemProvider) != null) {
      ref.read(highlightedItemProvider.notifier).state = null;
    }
  }

  @override
  void initState() {
    super.initState();
    // The first screen is where the media permission is asked; the reason
    // is with [ensureMediaAccessOnStart].
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => unawaited(ensureMediaAccessOnStart(ref)),
    );
  }

  @override
  void dispose() {
    _highlightTimer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  /// A tap on a "download complete" notification: the item is found, made
  /// part of the list if a search or a filter hid it, scrolled to, and lit.
  Future<void> _reveal(ItemReveal request) async {
    ref.read(itemRevealProvider.notifier).state = null;
    final messenger = ScaffoldMessenger.of(context);
    final gone = context.vhl.notificationClipGone;
    List<LocalItem> all;
    try {
      all = await ref.read(localMediaProvider.future);
      // Tapped the moment it finished: the folder may not be read again
      // yet, so once more before calling it gone.
      if (!all.any((item) => item.key == request.key)) {
        ref.invalidate(localMediaProvider);
        all = await ref.read(localMediaProvider.future);
      }
    } on Object {
      return; // the library shows its own error
    }
    if (!mounted) return;
    if (_searchOpen) setState(() => _searchOpen = false);
    final found = showInLibrary(
      ref.read(libraryViewProvider.notifier),
      ref.read(libraryViewProvider),
      all,
      request.key,
    );
    if (!found) {
      showVhSnackOn(messenger, gone);
      return;
    }
    setState(() => _revealing = request.key);
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    final visible = ref.read(visibleLibraryProvider).valueOrNull ?? const [];
    final index = visible.indexWhere((item) => item.key == request.key);
    if (index >= 0) {
      await scrollToItem(
        _scroll,
        _revealTarget,
        index: index,
        count: visible.length,
      );
    }
    if (!mounted) return;
    // Highlighted again for the full highlight time, even if the download
    // finishing highlighted it a moment ago.
    final highlight = ref.read(highlightedItemProvider.notifier);
    highlight.state = null;
    highlight.state = request.key;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    ref.listen<String?>(highlightedItemProvider, (_, next) {
      _highlightTimer?.cancel();
      if (next == null) return;
      _highlightTimer = Timer(highlightDuration, () {
        if (mounted) _clearHighlight();
      });
    });
    ref.listen<ItemReveal?>(itemRevealProvider, (_, next) {
      if (next != null) unawaited(_reveal(next));
    });
    final options = ref.watch(libraryViewProvider);
    final active = ref.watch(activeTasksProvider);

    final searching = _searchOpen || options.query.isNotEmpty;
    void closeSearch() {
      setState(() => _searchOpen = false);
      ref.read(libraryViewProvider.notifier).setQuery('');
    }

    // Back undoes a selection, then closes the search, before it leaves
    // the app: a selection lost by leaving takes the ticks made with it.
    return PopScope(
      canPop: !searching && !options.selecting,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (options.selecting) {
          ref.read(libraryViewProvider.notifier).clearSelection();
        } else {
          closeSearch();
        }
      },
      child: Scaffold(
        // Selecting swaps the bar with a short fade rather than a cut.
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: VhAnimatedSwap(
            child: KeyedSubtree(
              key: ValueKey(options.selecting),
              child: options.selecting
                  ? librarySelectionBar(context, ref, options)
                  : libraryMainBar(
                      context,
                      ref,
                      activeCount: active.length,
                      searching: searching,
                      onSearch: () => setState(() => _searchOpen = true),
                      onCloseSearch: closeSearch,
                    ),
            ),
          ),
        ),
        // No setup to invite any more: the engine is on the phone, readied
        // by the welcome screen.
        body: VhPullRefresh(
          onRefresh: () async {
            // A failed refresh is shown by the library itself in its
            // empty state, and
            // rethrowing here escapes the `RefreshIndicator` with
            // nobody to catch
            // it.
            // A card put in since the start shows its files on a pull.
            await ref.read(phoneVolumesProvider.notifier).refresh();
            ref.invalidate(localMediaProvider);
            try {
              await ref.read(localMediaProvider.future);
            } on VhApiException {
              // Shown in the empty state.
            }
          },
          // One calm appearance of the content on the first build,
          // rather than motion per card, which made the list bounce
          // throughout the scroll.
          // A wide grid gains columns, and a tablet spreads every mode
          // across its width; a phone's rows and cards keep theirs.
          child: VhRevealOnce(
            child:
                options.mode == LibraryViewMode.grid ||
                    VhAdaptiveScaffold.hasRail(context)
                ? _body(l10n, options, active)
                : VhReadableWidth(child: _body(l10n, options, active)),
          ),
        ),
      ),
    );
  }

  /// **Lazy building is mandatory** (a performance lesson):
  /// the header is a sliver and the items are a `SliverList.builder` that
  /// builds only what is visible.
  Widget _body(
    VhLocalizations l10n,
    LibraryViewOptions options,
    List<DownloadTask> active,
  ) {
    final itemsAsync = ref.watch(visibleLibraryProvider);
    // A search that matches no title may still match what was said.
    final said = ref.watch(saidResultsProvider).isNotEmpty;
    return CustomScrollView(
      controller: _scroll,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: VhSpace.pagePad),
          sliver: SliverList.list(
            children: [
              const SizedBox(height: VhSpace.xs),
              const LibraryFilterChips(),
              const SizedBox(height: VhSpace.md),
              ..._activeStrip(l10n, active),
            ],
          ),
        ),
        // **The order of the cases is deliberate**: every library invalidation
        // passes through
        // `AsyncLoading` **while keeping the previous data**, and matching
        // that first replaced the list with a spinner for a fraction of a
        // second, a continuous flicker during downloads, when the library
        // refreshes repeatedly. Existing data always wins, and a spinner
        // appears only on the very first load.
        ...switch (itemsAsync) {
          AsyncValue(valueOrNull: final value?) when value.isNotEmpty => [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: VhSpace.pagePad),
              // No "where is it" column: every item here is on the device.
              sliver: VhLibrarySliver(
                layout: options.mode.layout,
                itemCount: value.length,
                itemBuilder: (context, index, columns) =>
                    _itemCard(value[index], columns),
              ),
            ),
          ],
          // The page keeps its shape while the first answer comes.
          AsyncLoading() => [
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: VhSpace.pagePad),
              sliver: VhRowsSkeleton(),
            ),
          ],
          // The message comes from the error itself rather than from a
          // fixed string.
          // A folder Android refuses to read is not an error to report but
          // a permission to ask for, and it has its own screen.
          AsyncError(error: MediaAccessDeniedException()) => [
            const SliverToBoxAdapter(child: MediaAccessView()),
          ],
          AsyncError(:final error) => [
            SliverToBoxAdapter(
              child: VhEmptyState(
                title: l10n.tryAgain,
                message: errorText(l10n, error),
                actionLabel: l10n.retry,
                onAction: () => ref.invalidate(localMediaProvider),
              ),
            ),
          ],
          AsyncValue(valueOrNull: final value?) when value.isEmpty && said =>
            const <Widget>[],
          AsyncValue(valueOrNull: final value?) when value.isEmpty => [
            SliverToBoxAdapter(
              // **Say why it is empty**: a filter that hides
              // everything is not an empty library.
              child: switch (options) {
                LibraryViewOptions(query: final q) when q.isNotEmpty =>
                  VhEmptyState(
                    title: l10n.noResults,
                    message: l10n.noResultsMessage,
                  ),
                LibraryViewOptions(narrowed: true) => VhEmptyState(
                  title: l10n.emptyFilteredTitle,
                  message: l10n.emptyFilteredMessage,
                ),
                _ => VhEmptyState(
                  title: l10n.noDownloads,
                  message: l10n.noDownloadsMessage,
                ),
              },
            ),
          ],
          _ => const <Widget>[],
        },
        const SaidResultsSliver(),
        const SliverToBoxAdapter(child: SizedBox(height: 140)),
      ],
    );
  }

  /// **One task shows its full card; more than one collapses into a single
  /// summary line.**
  ///
  /// Several downloads all appeared in the library while a button for them
  /// already sits in the header, crowding one place.
  List<Widget> _activeStrip(VhLocalizations l10n, List<DownloadTask> active) {
    if (active.isEmpty) return const [];
    return [
      if (active.length == 1)
        _taskCard(l10n, active.first)
      else
        VhActiveDownloadsBar(
          label: l10n.activeDownloadsCount(active.length),
          actionLabel: l10n.viewAll,
          progress: averageTaskProgress(active),
          onTap: () => showDownloadsSheet(context),
        ),
      const SizedBox(height: VhSpace.sm),
    ];
  }

  Widget _taskCard(VhLocalizations l10n, DownloadTask task) {
    final engine = ref.read(downloadEngineProvider);
    final statusText = taskStatusText(
      l10n,
      task,
      waitingForWifi: ref.watch(wifiPausedProvider).contains(task.id),
    );
    return VhDownloadProgressCard(
      key: ValueKey('${task.id}-${task.phase.name}'),
      title: task.title ?? task.effectiveUrl,
      thumbnail: taskThumbnail(task),
      detail: taskSpeed(task),
      waiting: task.phase == TaskPhase.queued,
      statusText: statusText,
      progress: task.hasKnownProgress ? task.progress : null,
      isError: task.phase == TaskPhase.failed,
      action: taskCardAction(l10n, task, engine),
      onCancel: () => engine?.cancel(task.id),
    );
  }

  /// Tapping an item. Audio plays in the background immediately;
  /// video opens `/player`, and a short portrait clip opens reels. The
  /// internal play queue is **the library as displayed** at the moment of
  /// the tap, with the same sorting and filtering.
  Future<void> _play(LocalItem tapped) async {
    final visible = ref.read(visibleLibraryProvider).valueOrNull ?? const [];
    final items = [for (final item in visible) toPlaylistItem(item)];
    final index = visible.indexWhere((i) => i.key == tapped.key);
    if (items.isEmpty || index < 0) return;

    if (tapped.isAudio) {
      await ref.read(audioHandlerProvider).playItems(items, startIndex: index);
      return;
    }
    ref.read(playbackRequestProvider.notifier).state = PlaybackRequest(
      items: items,
      startIndex: index,
    );
    if (!mounted) return;
    context.push(tapped.isShortForm ? '/reels' : '/player');
  }

  /// The card reads the mode from the options itself; it is not passed
  /// twice.
  Widget _itemCard(LocalItem item, VhMediaColumns? columns) {
    final card = LibraryItemCard(
      item: item,
      columns: columns,
      onPlay: () => _play(item),
      onClearHighlight: _clearHighlight,
    );
    return item.key == _revealing
        ? KeyedSubtree(key: _revealTarget, child: card)
        : card;
  }
}
