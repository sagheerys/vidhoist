import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_media/mt_media.dart';
import 'package:mt_ui/mt_ui.dart';

import '../home/add_flow.dart';
import '../home/quick_download.dart';
import 'channel_actions.dart';
import 'channel_avatar.dart';

/// "Every hour", "Every 30 minutes": how often a channel is read.
String channelIntervalLabel(MTLocalizations l10n, int minutes) =>
    minutes < 60 ? l10n.every30Minutes : l10n.everyHours(minutes ~/ 60);

/// Who follows it, how often it is read and at what quality.
String channelMeta(BuildContext context, ChannelSubscription sub) {
  final l10n = context.mtl;
  return mtMetaLine([
    if (sub.followers case final n?)
      l10n.channelFollowers(mtCompactCount(context, n)),
    channelIntervalLabel(l10n, sub.checkIntervalMinutes),
    qualityLabel(l10n, Quality.fromWire(sub.quality ?? Quality.best.wire)),
  ]);
}

/// One followed channel: its picture and name, its newest clips to grab
/// by hand, and how its last check went. A tap on the head opens what can
/// be done to it.
class ChannelCard extends ConsumerWidget {
  const ChannelCard({super.key, required this.sub});

  final ChannelSubscription sub;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = MTThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final dim = sub.enabled ? 1.0 : 0.45;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MTSpace.pagePad,
        vertical: MTSpace.xs,
      ),
      child: Material(
        color: p.card,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MTRadius.card),
          side: BorderSide(
            color: sub.hasError ? p.err : p.line,
            width: MTThemeX.of(context).hairline,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () => unawaited(showChannelActions(context, ref, sub)),
              child: Padding(
                padding: const EdgeInsets.all(MTSpace.md),
                child: Row(
                  children: [
                    Opacity(
                      opacity: dim,
                      child: ChannelAvatar(sub: sub),
                    ),
                    const SizedBox(width: MTSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mtName(sub.name),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: sub.enabled ? null : p.ink3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            channelMeta(context, sub),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall?.copyWith(color: p.ink3),
                          ),
                        ],
                      ),
                    ),
                    MTIcon(MTIcons.moreVert, size: 18, color: p.ink3),
                  ],
                ),
              ),
            ),
            if (sub.recent.isNotEmpty)
              Opacity(opacity: dim, child: _ClipStrip(sub.recent)),
            ChannelStatus(sub: sub),
          ],
        ),
      ),
    );
  }
}

/// How the channel stands, along the card's foot: its error in red until
/// a check works, else paused or not, and when it was last read.
class ChannelStatus extends StatelessWidget {
  const ChannelStatus({super.key, required this.sub});

  final ChannelSubscription sub;

  @override
  Widget build(BuildContext context) {
    final l10n = context.mtl;
    final p = MTThemeX.of(context).palette;
    final color = sub.hasError ? p.err : p.ink3;
    final line = sub.hasError
        ? sub.error!
        : mtMetaLine([
            if (!sub.enabled) l10n.subscriptionPaused,
            switch (sub.lastChecked) {
              final at? => l10n.lastCheckedAt(mtTimeAgo(context, at)),
              null => l10n.neverChecked,
            },
            if (sub.recent.isEmpty) l10n.channelNoClipsYet,
            if (sub.titleRegex case final filter?) mtLtrRun(filter),
          ]);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MTSpace.md,
        vertical: MTSpace.sm,
      ),
      decoration: BoxDecoration(
        color: sub.hasError ? p.err.withValues(alpha: 0.08) : p.cardAlt,
        border: Border(
          top: BorderSide(color: p.line, width: MTThemeX.of(context).hairline),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MTIcon(
            sub.hasError
                ? MTIcons.alert
                : (sub.enabled ? MTIcons.clock : MTIcons.pause),
            size: 14,
            color: color,
          ),
          const SizedBox(width: MTSpace.xs),
          Expanded(
            child: Text(
              line,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

/// The channel's newest clips, side by side; a tap downloads one, as a
/// pasted link would, with the quality to change in the notice.
class _ClipStrip extends ConsumerWidget {
  const _ClipStrip(this.clips);

  final List<ChannelClip> clips;

  static const _width = 148.0;
  static const _thumb = _width * 9 / 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = MTThemeX.of(context).palette;
    final style = Theme.of(context).textTheme.bodySmall;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    // A row as tall as its tallest tile, so a large font never clips the
    // titles; eight tiles at most, so no lazy list is needed.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsetsDirectional.only(
        start: MTSpace.md,
        end: MTSpace.md,
        bottom: MTSpace.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (i, clip) in clips.indexed) ...[
            if (i > 0) const SizedBox(width: MTSpace.sm),
            SizedBox(
              width: _width,
              child: InkWell(
                borderRadius: BorderRadius.circular(MTRadius.thumb),
                onTap: () {
                  if (!startQuickDownload(
                    context,
                    ref,
                    clip.url,
                    explicit: true,
                  )) {
                    unawaited(openAddSheet(context, ref, initialUrl: clip.url));
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        MTMediaThumb(
                          width: _width,
                          height: _thumb,
                          duration: switch (clip.duration) {
                            final d? => mtFormatDuration(d),
                            null => null,
                          },
                          child: switch (clip.thumbnail) {
                            final url? => CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                              memCacheWidth: (_width * dpr).round(),
                              errorWidget: (_, _, _) => const SizedBox.shrink(),
                            ),
                            null => null,
                          },
                        ),
                        PositionedDirectional(
                          top: 5,
                          end: 5,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: p.ink.withValues(alpha: 0.7),
                              shape: BoxShape.circle,
                            ),
                            child: MTIcon(
                              MTIcons.download,
                              size: 13,
                              color: p.bg,
                              semanticLabel: context.mtl.download,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: MTSpace.xs),
                    Text(
                      mtName(clip.title ?? clip.url),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: style?.copyWith(color: p.ink2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
