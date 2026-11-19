import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../downloads_library/artwork_view.dart';
import '../downloads_library/library_providers.dart';
import '../player/playback_providers.dart';
import '../shared/error_report.dart';
import 'playlist_dialogs.dart';
import 'playlists_providers.dart';
import 'widgets/playlist_cards.dart';
import 'widgets/smart_list_rows.dart';

/// The playlists tab has **two sections**: pinned smart playlists, then
/// your playlists. There is no tags section: the phone app has no user
/// tags.
class PlaylistsScreen extends ConsumerWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final smart = ref.watch(smartListsProvider);
    final playlists = ref.watch(playlistsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navPlaylists),
        actions: [
          IconButton(
            tooltip: l10n.createPlaylist,
            onPressed: () => showCreatePlaylistDialog(context, ref),
            icon: const VhIcon(VhIcons.plus),
          ),
        ],
      ),
      body: VhReadableWidth(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            VhSpace.pagePad,
            0,
            VhSpace.pagePad,
            140,
          ),
          children: [
            VhSectionHeader(title: l10n.smartPlaylists),
            const SizedBox(height: VhSpace.sm),
            SmartListRows(
              lists: smart,
              onPlay: (list) => _playSmart(context, ref, list),
            ),
            const SizedBox(height: VhSpace.xl),
            VhSectionHeader(
              title: l10n.yourPlaylists,
              trailing: '${l10n.sortedByLastPlayed} ↓',
            ),
            const SizedBox(height: VhSpace.sm),
            playlists.when(
              loading: () => const Center(child: VhSpinner()),
              error: (_, _) => VhEmptyState(
                title: l10n.tryAgain,
                message: l10n.noPlaylistsMessage,
              ),
              data: (all) => _Grid(playlists: all),
            ),
          ],
        ),
      ),
    );
  }

  /// Tapping a smart playlist plays it in full.
  Future<void> _playSmart(
    BuildContext context,
    WidgetRef ref,
    SmartList list,
  ) async {
    final items = [for (final item in list.items) toPlaylistItem(item)];
    final visual = await ref.read(playlistPlayerProvider).play(items);
    if (visual && context.mounted) context.push('/player');
  }
}

class _Grid extends ConsumerWidget {
  const _Grid({required this.playlists});

  final List<SavedPlaylist> playlists;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final library = ref.watch(localMediaProvider).valueOrNull ?? const [];
    final byKey = {for (final item in library) item.key: item};

    List<Widget> coversOf(SavedPlaylist playlist) => [
      for (final entry in playlist.items.take(4))
        if ((byKey[entry.canonicalUrl]?.thumbnail ?? entry.cachedThumb)
            case final String url)
          ?artworkFor(url),
    ];

    // An explicit empty state (audit 8.1): a bare "+" tile explains
    // nothing.
    if (playlists.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: VhSpace.sm),
            child: Text(
              l10n.noPlaylistsMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!
                  .copyWith(color: VhThemeX.of(context).palette.ink3),
            ),
          ),
          SizedBox(
            height: 150,
            child: _NewPlaylistTile(
              label: l10n.newPlaylistAction,
              onTap: () => showCreatePlaylistDialog(context, ref),
            ),
          ),
        ],
      );
    }

    return GridView.extent(
      // Two up on every phone; a wide window adds columns.
      maxCrossAxisExtent: VhBreakpoint.gridTile,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: VhSpace.md - 1,
      crossAxisSpacing: VhSpace.md - 1,
      childAspectRatio: 0.78,
      children: [
        for (final playlist in playlists)
          PlaylistCard(
            playlist: playlist,
            thumbnails: coversOf(playlist),
            onTap: () => context.push('/playlists/${playlist.id}'),
            onPlay: () => _play(context, ref, playlist),
            onLongPress: () => showPlaylistActionsSheet(context, ref, playlist),
          ),
        _NewPlaylistTile(
          label: l10n.newPlaylistAction,
          onTap: () => showCreatePlaylistDialog(context, ref),
        ),
      ],
    );
  }

  Future<void> _play(
    BuildContext context,
    WidgetRef ref,
    SavedPlaylist playlist,
  ) async {
    // **A failure is stated rather than thrown**: building a playlist goes
    // through the library, which reads the media folder, so a failure there
    // would otherwise escape the tap handler in silence.
    try {
      final items = await ref.read(playlistItemsProvider(playlist.id).future);
      final visual = await ref
          .read(playlistPlayerProvider)
          .play(items, playlistId: playlist.id, playlistName: playlist.name);
      if (visual && context.mounted) context.push('/player');
    } on VhApiException catch (e) {
      if (context.mounted) {
        showErrorSnack(context, ref, e, tag: 'playlist');
      }
    }
  }
}

class _NewPlaylistTile extends StatelessWidget {
  const _NewPlaylistTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(VhRadius.cardLg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(VhRadius.cardLg),
          border: Border.all(color: p.line2, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: p.accentSoft,
                borderRadius: BorderRadius.circular(VhRadius.field - 1),
              ),
              child: VhIcon(VhIcons.plus, size: 17, color: p.accentInk),
            ),
            const SizedBox(height: VhSpace.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall!
                  .copyWith(color: p.ink3),
            ),
          ],
        ),
      ),
    );
  }
}
