import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';

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

/// One followed channel: its picture and name, what it is set to, and how
/// its last check went. A tap opens what can be done to it.
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
