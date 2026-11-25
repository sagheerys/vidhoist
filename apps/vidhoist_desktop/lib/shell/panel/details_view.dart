import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/library_data.dart';
import '../../data/lists_data.dart';
import '../../features/clip/clip_facts.dart';
import '../../features/library/platform_label.dart';
import '../video_surface.dart';

/// What is known about the playing clip, with its link one click from the
/// clipboard (a phone hides this in a sheet; the panel has the room).
///
/// **The phone's details and more**: the size, the video and the sound as
/// the file really is (the history records "best", not what came), the
/// date it arrived, where it is kept, and the lists and tags it is in.
class DetailsView extends ConsumerWidget {
  const DetailsView({super.key, required this.item, this.playing = true});

  final PlaylistItem item;

  /// [item] is the clip in the player, whose picture and sound can be
  /// asked as they play; another clip has only what its file says.
  final bool playing;

  static Future<MediaQuality?> _unknown() async => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final url = item.canonicalUrl;
    final entry = (ref.watch(libraryItemsProvider).valueOrNull ?? const [])
        .where((i) => i.canonicalUrl == url)
        .firstOrNull;
    final lists = <String>[
      for (final list
          in ref.watch(playlistsProvider).valueOrNull ??
              const <SavedPlaylist>[])
        if (list.items.any((e) => e.canonicalUrl == url)) list.name,
    ];
    final tags = [
      for (final tag in entry?.tags ?? const <String>[])
        if (tag != VhConstants.favoritesSystemTag) tag,
    ];
    final folder = switch (item.serverFilename) {
      final name? => ServerPath.folderOf(name),
      null => '',
    };
    final size = entry?.sizeBytes;
    final format = entry == null ? null : fileFormatOf(entry);
    final when = entry?.timestamp;
    Widget row(String label, String value) => _Row(label: label, value: value);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Selectable, to copy it.
          _Row(label: l.titleLabel, value: item.title, selectable: true),
          if (item.uploader case final who?) row(l.desktopChannel, who),
          row(l.platform, platformLabel(l, MediaPlatform.detect(url))),
          if (item.duration case final length?)
            row(l.columnLength, vhLtrRun(vhFormatDuration(length))),
          if (size != null) row(l.fileSize, vhFormatSize(size)),
          if (format != null) row(l.format, format),
          VhQualityRows(
            // Asked afresh once the clip starts: before, there was nothing
            // playing to ask.
            key: ValueKey((url, playing)),
            cacheKey: url,
            row: row,
            sizeBytes: size,
            duration: item.duration,
            load: playing ? ref.read(videoSurfaceProvider).quality : _unknown,
          ),
          if (when != null) row(l.downloadDate, vhTimeAgo(context, when)),
          if (folder.isNotEmpty) row(l.folder, vhName(folder)),
          if (lists.isNotEmpty)
            row(l.inPlaylists, lists.map(vhName).join(l.listSeparator)),
          if (tags.isNotEmpty) row(l.tags, tags.join(l.listSeparator)),
          if (item.localPath != null) row(l.source, l.playingFromDevice),
          const SizedBox(height: VhSpace.md),
          _LinkRow(url: url),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.selectable = false,
  });

  final String label;
  final String value;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final line = Text(
      value,
      textDirection: vhTextDirectionOf(value, Directionality.of(context)),
      style: text.bodySmall?.copyWith(color: p.ink),
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: VhSpace.sm),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: p.line,
            width: VhThemeX.of(context).hairline,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: VhSpace.xxl * 3,
            child: Text(label, style: text.labelSmall?.copyWith(color: p.ink3)),
          ),
          Expanded(child: selectable ? VhSelectable(child: line) : line),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l = context.vhl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // An address reads left to right in any language.
        Directionality(
          textDirection: TextDirection.ltr,
          child: SelectableText(
            url,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: p.ink2),
          ),
        ),
        const SizedBox(height: VhSpace.xs),
        VhLinkButton(
          label: l.desktopCopyLink,
          icon: VhIcons.copy,
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: url));
            if (!context.mounted) return;
            showVhNotice(context, message: l.desktopLinkCopied);
          },
        ),
      ],
    );
  }
}
