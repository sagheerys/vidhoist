import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../home/quick_download.dart';
import 'channel_actions.dart';
import 'channel_avatar.dart';

/// "Every hour", "Every 30 minutes": how often a channel is read.
String channelIntervalLabel(VhLocalizations l10n, int minutes) =>
    minutes < 60 ? l10n.every30Minutes : l10n.everyHours(minutes ~/ 60);

/// Who follows it, how often it is read and at what quality.
String channelMeta(BuildContext context, ChannelSubscription sub) {
  final l10n = context.vhl;
  return vhMetaLine([
    if (sub.followers case final n?)
      l10n.channelFollowers(vhCompactCount(context, n)),
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
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final dim = sub.enabled ? 1.0 : 0.45;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: VhSpace.pagePad,
        vertical: VhSpace.xs,
      ),
      child: Material(
        color: p.card,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VhRadius.card),
          side: BorderSide(color: p.line, width: VhThemeX.of(context).hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () => unawaited(showChannelActions(context, ref, sub)),
              child: Padding(
                padding: const EdgeInsets.all(VhSpace.md),
                child: Row(
                  children: [
                    Opacity(
                      opacity: dim,
                      child: ChannelAvatar(sub: sub),
                    ),
                    const SizedBox(width: VhSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vhName(sub.name),
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
                    VhIcon(VhIcons.moreVert, size: 18, color: p.ink3),
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

/// How the channel stands, along the card's foot: paused or not, and when
/// it was last read. A check that failed says so in a calm sentence, not
/// in yt-dlp's words or in red: it is tried again by itself, and nothing
/// needs doing. No network says nothing at all ([LocalChannelSource]).
/// With [detail], the sheet adds yt-dlp's words, small, for whoever asks.
class ChannelStatus extends StatelessWidget {
  const ChannelStatus({super.key, required this.sub, this.detail = false});

  final ChannelSubscription sub;
  final bool detail;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final color = p.ink3;
    final line = sub.hasError
        ? l10n.channelCheckFailed
        : vhMetaLine([
            if (!sub.enabled) l10n.subscriptionPaused,
            switch (sub.lastChecked) {
              final at? => l10n.lastCheckedAt(vhTimeAgo(context, at)),
              null => l10n.neverChecked,
            },
            if (sub.titleRegex case final filter?) vhLtrRun(filter),
          ]);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: VhSpace.md,
        vertical: VhSpace.sm,
      ),
      decoration: BoxDecoration(
        color: p.cardAlt,
        border: Border(
          top: BorderSide(color: p.line, width: VhThemeX.of(context).hairline),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VhIcon(
            sub.hasError
                ? VhIcons.alert
                : (sub.enabled ? VhIcons.clock : VhIcons.pause),
            size: 14,
            color: color,
          ),
          const SizedBox(width: VhSpace.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: color),
                ),
                if (detail && sub.hasError)
                  Text(
                    vhLtrRun(sub.error!),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: p.ink3),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
