import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../shared/external_player.dart';
import '../../shared/membership.dart';
import '../../shared/platform_label.dart';
import '../local_item.dart';
import '../media_probe.dart';
import '../../shared/open_web_link.dart';

/// Item details, opened from the actions sheet and from the reels player
/// alike.
void showItemDetailsSheet(BuildContext context, LocalItem item) {
  showVhSheet<void>(
    context: context,
    useRootNavigator: true,
    builder: (_) => _DetailsSheet(item: item),
  );
}

/// The details sheet: the name, size, date, platform and URL, each copied
/// with one tap.
class _DetailsSheet extends ConsumerWidget {
  const _DetailsSheet({required this.item});

  final LocalItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final text = Theme.of(context).textTheme;
    final p = VhThemeX.of(context).palette;

    Widget row(String label, String value, {bool selectable = false}) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: VhSpace.xs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110,
                child: Text(
                  label,
                  style: text.bodySmall!.copyWith(color: p.ink3),
                ),
              ),
              Expanded(
                child: selectable
                    ? VhForeignText(
                        value,
                        overflow: null,
                        selectable: true,
                        style: text.bodyMedium,
                      )
                    : Text(value, style: text.bodyMedium),
              ),
            ],
          ),
        );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          VhSpace.xl,
          VhSpace.lg,
          VhSpace.xl,
          VhSpace.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VhSectionHeader(title: l10n.details),
            const SizedBox(height: VhSpace.sm),
            // Selectable, to copy it.
            row(l10n.titleLabel, item.title, selectable: true),
            row(l10n.fileSize, vhFormatSize(item.sizeBytes)),
            // **What the file actually is** (asked 2026-09-25), read from
            // its header.
            VhQualityRows(
              cacheKey: item.key,
              row: row,
              sizeBytes: item.sizeBytes,
              duration: item.duration,
              load: () => const MediaProbe().quality(item.path),
            ),
            row(l10n.downloadDate, vhTimeAgo(context, item.modified)),
            row(l10n.platform, platformLabel(l10n, item.platform)),
            // **Where it belongs** (field report 2026-09-04): which
            // playlists is this clip in? The information was in the store
            // and no screen displayed it.
            ...switch (ref
                .watch(membershipIndexProvider)
                .valueOrNull?[item.key]) {
              final ItemMembership m when m.playlists.isNotEmpty => [
                row(l10n.inPlaylists, m.playlists.join(l10n.listSeparator)),
              ],
              _ => const <Widget>[],
            },
            const SizedBox(height: VhSpace.sm),
            // **Two actions, not a third button in reels** (decision
            // 2026-09-05): the reels rail holds three buttons and a fourth
            // crowds them, and this sheet is opened from it by the
            // "details" button anyway.
            Row(
              children: [
                if (item.canonicalUrl case final String url)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => openWebLink(url),
                      icon: const VhIcon(VhIcons.external, size: 16),
                      label: Text(
                        l10n.openOriginalLink,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                if (item.canonicalUrl != null)
                  const SizedBox(width: VhSpace.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final opened = await const ExternalPlayer().open(
                        item.path,
                        audio: item.isAudio,
                      );
                      if (!opened && context.mounted) {
                        showVhSnack(
                          context,
                          l10n.noExternalPlayer,
                          type: VhSnackType.error,
                        );
                      }
                    },
                    icon: const VhIcon(VhIcons.playback, size: 16),
                    // A short label: two buttons side by side leave no room
                    // for a long one on a phone (seen on the device).
                    label: Text(
                      l10n.externalPlayerShort,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            // The original URL, copied with one tap. Files copied in by
            // hand have none, so their path is shown instead.
            OutlinedButton.icon(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: item.canonicalUrl ?? item.path),
                );
                if (context.mounted) {
                  showVhSnack(context, l10n.copiedToClipboard);
                }
              },
              icon: const VhIcon(VhIcons.copy, size: 16),
              label: Text(
                item.canonicalUrl ?? item.filename,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
