import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';

import '../shared/error_text.dart';
import 'channel_actions.dart';
import 'channels_state.dart';
import 'follow_sheet.dart';

/// The channels followed on this phone, from Settings.
class ChannelsScreen extends ConsumerStatefulWidget {
  const ChannelsScreen({super.key});

  @override
  ConsumerState<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends ConsumerState<ChannelsScreen> {
  bool _checking = false;

  /// A check takes as long as yt-dlp takes to read each channel, a few
  /// seconds apiece; the button waits with it.
  Future<void> _checkAll() async {
    setState(() => _checking = true);
    try {
      await ref.read(channelsControllerProvider).checkNow();
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.mtl;
    final asked = ref.watch(channelsProvider);
    final subs = asked.valueOrNull;
    final Widget body;
    if (subs == null) {
      body = Center(
        child: asked.hasError
            ? MTEmptyFrame(
                title: l10n.failed,
                message: errorText(l10n, asked.error!),
                actionLabel: l10n.retry,
                onAction: () => ref.invalidate(channelsProvider),
              )
            : const MTSpinner(),
      );
    } else if (subs.isEmpty) {
      body = Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(MTSpace.pagePad),
          child: MTEmptyFrame(
            title: l10n.subscriptionsEmpty,
            message: l10n.mobileChannelsEmptyBody,
            actionLabel: l10n.followChannel,
            onAction: () => unawaited(showFollowSheet(context)),
          ),
        ),
      );
    } else {
      body = MTReadableWidth(
        child: ListView(
          padding: const EdgeInsets.only(bottom: MTSpace.xxl * 2),
          children: [for (final sub in subs) ChannelTile(sub: sub)],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.desktopChannels),
        actions: [
          if (subs?.isNotEmpty ?? false)
            IconButton(
              tooltip: l10n.desktopCheckAll,
              onPressed: _checking ? null : () => unawaited(_checkAll()),
              icon: _checking
                  ? const MTSpinner(size: 18)
                  : const MTIcon(MTIcons.refresh),
            ),
        ],
      ),
      floatingActionButton: (subs?.isNotEmpty ?? false)
          ? FloatingActionButton.extended(
              onPressed: () => unawaited(showFollowSheet(context)),
              icon: const MTIcon(MTIcons.plus),
              label: Text(l10n.followChannel),
            )
          : null,
      body: body,
    );
  }
}

/// One channel: its name, and how its last check went.
class ChannelTile extends ConsumerWidget {
  const ChannelTile({super.key, required this.sub});

  final ChannelSubscription sub;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.mtl;
    final p = MTThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
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
    return ListTile(
      minTileHeight: 64,
      leading: MTIcon(
        sub.hasError ? MTIcons.alert : MTIcons.subscriptions,
        color: sub.hasError ? p.err : (sub.enabled ? p.accent : p.ink3),
      ),
      title: Text(
        mtName(sub.name),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: sub.enabled ? null : TextStyle(color: p.ink3),
      ),
      subtitle: Text(
        line,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: text.bodySmall?.copyWith(color: sub.hasError ? p.err : p.ink3),
      ),
      onTap: () => unawaited(showChannelActions(context, ref, sub)),
    );
  }
}
