import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart' show vhFormatDuration;
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../downloads_library/artwork_view.dart';
import '../downloads_library/library_providers.dart';
import '../downloads_library/local_item.dart';
import '../shared/choice_chip_row.dart';
import 'playlists_providers.dart';

/// Choosing clips from the library to add to one playlist, from inside it.
///
/// **The other way round was the only way**: a clip was added from the
/// library, one item or one selection at a time, so filling a playlist
/// meant leaving it, finding each clip, and coming back. Here the library
/// comes to the playlist: search, a type, tick, add. What the playlist
/// already holds is shown ticked and cannot be added twice; the rest is
/// added in the order it was ticked.
class PlaylistAddClipsScreen extends ConsumerStatefulWidget {
  const PlaylistAddClipsScreen({super.key, required this.playlistId});

  final String playlistId;

  @override
  ConsumerState<PlaylistAddClipsScreen> createState() =>
      _PlaylistAddClipsScreenState();
}

class _PlaylistAddClipsScreenState
    extends ConsumerState<PlaylistAddClipsScreen> {
  static const _types = [
    MediaTypeFilter.all,
    MediaTypeFilter.video,
    MediaTypeFilter.audio,
    MediaTypeFilter.shorts,
  ];

  String _query = '';
  MediaTypeFilter _type = MediaTypeFilter.all;

  /// In the order ticked, which is the order they are added in.
  final _chosen = <String, LocalItem>{};
  bool _adding = false;

  void _toggle(LocalItem item) => setState(
    () => _chosen.containsKey(item.key)
        ? _chosen.remove(item.key)
        : _chosen[item.key] = item,
  );

  Future<void> _add(SavedPlaylist playlist) async {
    if (_chosen.isEmpty || _adding) return;
    setState(() => _adding = true);
    final l10n = context.vhl;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final store = ref.read(playlistsStoreProvider);
    final entries = [for (final item in _chosen.values) toPlaylistEntry(item)];
    // The undo comes after this screen has closed, so it reaches the
    // providers through the app's container, not this screen's ref.
    final container = ProviderScope.containerOf(context, listen: false);
    await store.addItems(playlist.id, entries);
    void refresh() {
      container
        ..invalidate(playlistsProvider)
        ..invalidate(playlistItemsProvider(playlist.id));
    }

    refresh();
    navigator.pop();
    showVhSnackOn(
      messenger,
      l10n.addedToPlaylistCount(entries.length),
      type: VhSnackType.success,
      actionLabel: l10n.undo,
      onAction: () async {
        for (final entry in entries) {
          await store.removeItem(playlist.id, entry.canonicalUrl);
        }
        refresh();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final playlists = ref.watch(playlistsProvider).valueOrNull ?? const [];
    final playlist = playlists
        .where((p) => p.id == widget.playlistId)
        .firstOrNull;
    final library = ref.watch(localMediaProvider);
    if (playlist == null) return Scaffold(appBar: AppBar());

    final present = {for (final entry in playlist.items) entry.canonicalUrl};
    final shown = buildLocalLibraryView(
      library.valueOrNull ?? const [],
      type: _type,
      query: _query,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.playlistAddClipsTo(playlist.name))),
      body: VhReadableWidth(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                VhSpace.pagePad,
                VhSpace.xs,
                VhSpace.pagePad,
                VhSpace.sm,
              ),
              child: VhQuerySearchField(
                hint: l10n.searchVideos,
                query: _query,
                onChanged: (q) => setState(() => _query = q),
              ),
            ),
            ChoiceChipRow(
              labels: [
                l10n.filterAll,
                l10n.filterVideo,
                l10n.filterAudio,
                l10n.shortsFilter,
              ],
              chosen: _types.indexOf(_type),
              onChosen: (i) => setState(() => _type = _types[i]),
            ),
            const SizedBox(height: VhSpace.sm),
            Expanded(
              child: switch (library) {
                AsyncValue(valueOrNull: null, isLoading: true) => const Center(
                  child: VhSpinner(),
                ),
                _ when shown.isEmpty => VhEmptyState(
                  title: l10n.noResults,
                  message: l10n.noResultsMessage,
                ),
                _ => ListView.builder(
                  padding: const EdgeInsets.only(bottom: VhSpace.xl),
                  itemCount: shown.length,
                  itemBuilder: (context, index) {
                    final item = shown[index];
                    final there = present.contains(item.key);
                    return _ClipRow(
                      item: item,
                      already: there,
                      chosen: there || _chosen.containsKey(item.key),
                      onTap: there ? null : () => _toggle(item),
                    );
                  },
                ),
              },
            ),
          ],
        ),
      ),
      // Pinned under the list, out of the way of the keyboard's typing:
      // it rides above the keyboard rather than under it.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            VhSpace.pagePad,
            VhSpace.sm,
            VhSpace.pagePad,
            VhSpace.sm + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(VhEmphasis.action),
            ),
            onPressed: _chosen.isEmpty || _adding ? null : () => _add(playlist),
            icon: const VhIcon(VhIcons.plus, size: 18),
            label: Text(l10n.playlistAddCount(_chosen.length)),
          ),
        ),
      ),
    );
  }
}

class _ClipRow extends StatelessWidget {
  const _ClipRow({
    required this.item,
    required this.already,
    required this.chosen,
    required this.onTap,
  });

  final LocalItem item;
  final bool already;
  final bool chosen;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final detail = [
      if (item.duration != null) vhFormatDuration(item.duration!),
      vhFormatSize(item.sizeBytes),
    ].join(' · ');
    return Semantics(
      checked: chosen,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: VhSpace.pagePad,
            vertical: VhSpace.xs,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(VhRadius.thumb),
                child: SizedBox(
                  width: 88,
                  height: 50,
                  child: ColoredBox(
                    color: p.card,
                    child:
                        artworkFor(
                          item.thumbnail,
                          decodeWidth: vhDecodeWidth(context, 88, 50),
                        ) ??
                        Center(
                          child: VhIcon(
                            item.isAudio ? VhIcons.music : VhIcons.play,
                            color: p.ink3,
                          ),
                        ),
                  ),
                ),
              ),
              const SizedBox(width: VhSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodyMedium!.copyWith(
                        color: already ? p.ink3 : null,
                      ),
                    ),
                    Text(
                      already ? l10n.alreadyInPlaylist : detail,
                      style: text.bodySmall!.copyWith(color: p.ink3),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: chosen,
                onChanged: onTap == null ? null : (_) => onTap!(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
