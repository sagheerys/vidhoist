import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../pc/pc_destination.dart';
import '../pc/pc_link_state.dart';
import '../pc/pc_outbox.dart';
import '../pc/pc_pairing_store.dart';
import '../pc/pc_send.dart';
import '../shared/error_text.dart';
import 'batch_providers.dart';

/// The batch download screen (rule 3): a playlist preview with checkboxes,
/// each item's duration and the selected total, a quality choice, then
/// enqueueing.
class BatchScreen extends ConsumerStatefulWidget {
  const BatchScreen({super.key, required this.playlistUrl});

  final String playlistUrl;

  @override
  ConsumerState<BatchScreen> createState() => _BatchScreenState();
}

class _BatchScreenState extends ConsumerState<BatchScreen> {
  final Set<String> _selected = {};
  bool _initialised = false;
  Quality? _quality;

  /// The source playlist's name; the items are collected under it into one
  /// saved playlist.
  String? _playlistName;

  /// The paired computer was asked (null until it answers or fails); the
  /// choice is offered either way, as in the add sheet.
  bool? _pcReachable;
  late var _toPc = ref.read(sendToPcProvider);

  bool get _sendsToPc =>
      ref.read(pcPairingProvider) != null && _pcReachable != null && _toPc;

  @override
  void initState() {
    super.initState();
    if (ref.read(pcPairingProvider) == null) return;
    unawaited(
      ref.read(pcViewProvider.notifier).probe().then((reachable) {
        if (mounted) setState(() => _pcReachable = reachable);
      }),
    );
  }

  /// **The selection goes to the computer one link at a time** (asked
  /// 2026-11-10), in the playlist's order: the computer takes single links
  /// from the phone, never a playlist.
  Future<void> _sendToPc(List<String> urls, String quality) async {
    // All read before leaving: this screen is gone once the links go.
    final l10n = context.vhl;
    final messenger = ScaffoldMessenger.of(context);
    final name = ref.read(pcPairingProvider)?.name ?? '';
    final view = ref.read(pcViewProvider.notifier);
    final outbox = ref.read(pcOutboxProvider.notifier);
    final away = _pcReachable == false;
    context.go('/');
    final result = await sendLinksToPc(
      view: view,
      outbox: outbox,
      urls: urls,
      quality: quality,
      away: away,
    );
    showPcSendResult(messenger, l10n, result, name);
  }

  /// The single video's URL when the input was `watch?v=…&list=…`.
  String? get _singleVideoUrl {
    final id = UrlKit.youtubeVideoId(widget.playlistUrl);
    return id == null ? null : 'https://www.youtube.com/watch?v=$id';
  }

  void _downloadSingle() {
    final l10n = context.vhl;
    if (_sendsToPc) {
      unawaited(
        _sendToPc([_singleVideoUrl!], ref.read(settingsProvider).quality.wire),
      );
      return;
    }
    final count = ref.read(batchSubmitterProvider).submit([
      _singleVideoUrl!,
    ], ref.read(settingsProvider).quality);
    if (count == 0) {
      showVhSnack(context, l10n.noServerTitle, type: VhSnackType.error);
      return;
    }
    context.go('/');
    showVhSnack(context, l10n.addedNToServer(1), type: VhSnackType.success);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final preview = ref.watch(playlistPreviewProvider(widget.playlistUrl));
    final kind = PlaylistDetector.detect(widget.playlistUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.batchTitle),
        // **An exit for the ambiguous link.** `watch?v=X&list=Y` is a video
        // **inside** a playlist, and YouTube shares carry `list` very
        // often, so once playlists were genuinely readable it became easy
        // to find yourself facing 200 items when you wanted one. The button
        // appears only when the URL contains `v=`.
        actions: [
          if (_singleVideoUrl != null)
            TextButton(
              onPressed: _downloadSingle,
              child: Text(l10n.batchThisVideoOnly),
            ),
        ],
      ),
      floatingActionButton: preview.valueOrNull == null
          ? null
          : FloatingActionButton.extended(
              onPressed: _submit,
              icon: const VhIcon(VhIcons.download),
              label: Text(
                _sendsToPc ? l10n.pcSendToPc : l10n.batchDownloadSelected,
              ),
            ),
      body: VhReadableWidth(
        child: preview.when(
          loading: () => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const VhSpinner(),
                const SizedBox(height: VhSpace.md),
                Text(
                  l10n.batchLoading,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          error: (e, _) => VhEmptyState(
            title: l10n.failedToLoadPlaylist,
            message: errorText(l10n, e),
            actionLabel: l10n.retry,
            onAction: () =>
                ref.invalidate(playlistPreviewProvider(widget.playlistUrl)),
          ),
          data: (data) => data == null || data.tracks.isEmpty
              ? VhEmptyState(
                  title: l10n.failedToLoadPlaylist,
                  message: l10n.couldNotLoadPlaylist,
                )
              : _content(data, kind),
        ),
      ),
    );
  }

  /// Rule 3, step 2: enqueue the selection, then return to the main screen.
  void _submit() {
    final l10n = context.vhl;
    if (_selected.isEmpty) {
      showVhSnack(context, l10n.batchNothingSelected, type: VhSnackType.error);
      return;
    }
    if (_sendsToPc) {
      final tracks = ref
          .read(playlistPreviewProvider(widget.playlistUrl))
          .valueOrNull
          ?.tracks;
      unawaited(
        _sendToPc([
          for (final t in tracks ?? const <PlaylistTrack>[])
            if (_selected.contains(t.url)) t.url,
        ], (_quality ?? Quality.best).wire),
      );
      return;
    }
    final count = ref
        .read(batchSubmitterProvider)
        .submit(
          _selected.toList(),
          _quality ?? Quality.best,
          groupName: _playlistName,
        );
    if (count == 0) {
      showVhSnack(context, l10n.noServerTitle, type: VhSnackType.error);
      return;
    }
    context.go('/');
    showVhSnack(context, l10n.addedNToServer(count), type: VhSnackType.success);
  }

  Widget _content(PlaylistPreview preview, PlaylistKind kind) {
    if (!_initialised) {
      _initialised = true;
      _playlistName = preview.title;
      _selected.addAll(preview.tracks.map((t) => t.url));
      // SoundCloud is audio only (§4), so the quality is pinned and not
      // shown.
      _quality = kind == PlaylistKind.soundcloud
          ? Quality.audio
          : ref.read(settingsProvider).quality;
    }
    final selectedTracks = preview.tracks
        .where((t) => _selected.contains(t.url))
        .toList();
    final total = selectedTracks.fold(
      Duration.zero,
      (sum, t) => sum + (t.duration ?? Duration.zero),
    );

    return Column(
      children: [
        _Header(
          preview: preview,
          selectedCount: selectedTracks.length,
          totalDuration: total,
          allSelected: _selected.length == preview.tracks.length,
          onToggleAll: () => setState(() {
            if (_selected.length == preview.tracks.length) {
              _selected.clear();
            } else {
              _selected.addAll(preview.tracks.map((t) => t.url));
            }
          }),
        ),
        if (kind != PlaylistKind.soundcloud)
          _QualityRow(
            quality: _quality ?? Quality.best,
            heights: kind != PlaylistKind.soundcloud,
            onChanged: (q) => setState(() => _quality = q),
          ),
        if (ref.watch(pcPairingProvider) case final pc?
            when _pcReachable != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              VhSpace.pagePad,
              VhSpace.xs,
              VhSpace.pagePad,
              VhSpace.sm,
            ),
            child: PcDestination(
              pcName: pc.name,
              toPc: _toPc,
              away: _pcReachable == false,
              onChanged: (value) {
                setState(() => _toPc = value);
                unawaited(ref.read(sendToPcProvider.notifier).set(value));
              },
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              VhSpace.pagePad,
              0,
              VhSpace.pagePad,
              VhSpace.xxl,
            ),
            itemCount: preview.tracks.length,
            itemBuilder: (context, index) {
              final track = preview.tracks[index];
              return CheckboxListTile(
                value: _selected.contains(track.url),
                onChanged: (checked) => setState(
                  () => checked == true
                      ? _selected.add(track.url)
                      : _selected.remove(track.url),
                ),
                contentPadding: EdgeInsets.zero,
                title: Text(
                  track.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: track.duration == null
                    ? null
                    : Text(vhFormatDuration(track.duration!)),
                secondary: track.thumbnail == null
                    ? null
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(VhRadius.thumb - 2),
                        child: CachedNetworkImage(
                          imageUrl: track.thumbnail!,
                          width: 64,
                          height: 40,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => const SizedBox.shrink(),
                        ),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// A local copy of the formatting; vh_media provides widgets only and we do
/// not import its screens here.
String vhFormatDuration(Duration d) {
  final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return d.inHours > 0 ? '${d.inHours}:$minutes:$seconds' : '$minutes:$seconds';
}

class _Header extends StatelessWidget {
  const _Header({
    required this.preview,
    required this.selectedCount,
    required this.totalDuration,
    required this.allSelected,
    required this.onToggleAll,
  });

  final PlaylistPreview preview;
  final int selectedCount;
  final Duration totalDuration;
  final bool allSelected;
  final VoidCallback onToggleAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        VhSpace.pagePad,
        VhSpace.sm,
        VhSpace.pagePad,
        VhSpace.sm,
      ),
      child: Row(
        children: [
          if (preview.coverUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(VhRadius.thumb),
              child: CachedNetworkImage(
                imageUrl: preview.coverUrl!,
                width: 68,
                height: 68,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          const SizedBox(width: VhSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  preview.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: VhSpace.xxs),
                Text(
                  '${l10n.batchSelectedOf(selectedCount, preview.tracks.length)}'
                  ' · ${vhFormatDuration(totalDuration)}',
                  style: Theme.of(context).textTheme.bodySmall!
                      .copyWith(color: p.ink3),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onToggleAll,
            child: Text(allSelected ? l10n.deselectAll : l10n.selectAll),
          ),
        ],
      ),
    );
  }
}

class _QualityRow extends StatelessWidget {
  const _QualityRow({
    required this.quality,
    required this.heights,
    required this.onChanged,
  });

  final Quality quality;
  final bool heights;
  final ValueChanged<Quality> onChanged;

  @override
  Widget build(BuildContext context) {
    // Rule 2: no heights for sound alone (a SoundCloud set).
    final options = heights ? Quality.values : [Quality.best, Quality.audio];
    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: VhSpace.pagePad),
        children: [
          for (final option in options) ...[
            ChoiceChip(
              label: Text(option.wire),
              selected: option == quality,
              showCheckmark: false,
              onSelected: (_) => onChanged(option),
            ),
            const SizedBox(width: VhSpace.xs),
          ],
        ],
      ),
    );
  }
}
