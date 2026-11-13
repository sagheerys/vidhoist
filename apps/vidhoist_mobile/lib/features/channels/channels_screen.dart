import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../shared/error_text.dart';
import 'channel_card.dart';
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
    final l10n = context.vhl;
    final asked = ref.watch(channelsProvider);
    final subs = asked.valueOrNull;
    final Widget body;
    if (subs == null) {
      body = Center(
        child: asked.hasError
            ? VhEmptyFrame(
                title: l10n.failed,
                message: errorText(l10n, asked.error!),
                actionLabel: l10n.retry,
                onAction: () => ref.invalidate(channelsProvider),
              )
            : const VhSpinner(),
      );
    } else if (subs.isEmpty) {
      body = Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(VhSpace.pagePad),
          child: VhEmptyFrame(
            title: l10n.subscriptionsEmpty,
            message: l10n.mobileChannelsEmptyBody,
            actionLabel: l10n.followChannel,
            onAction: () => unawaited(showFollowSheet(context)),
          ),
        ),
      );
    } else {
      body = VhReadableWidth(
        child: ListView(
          // Clear of "Follow a channel" and the navigation buttons under
          // it, which would otherwise sit on the last card.
          padding: EdgeInsets.only(
            top: VhSpace.xs,
            bottom: vhFabClearance(context),
          ),
          children: [for (final sub in subs) ChannelCard(sub: sub)],
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
                  ? const VhSpinner(size: 18)
                  : const VhIcon(VhIcons.refresh),
            ),
        ],
      ),
      floatingActionButton: (subs?.isNotEmpty ?? false)
          ? FloatingActionButton.extended(
              onPressed: () => unawaited(showFollowSheet(context)),
              icon: const VhIcon(VhIcons.plus),
              label: Text(l10n.followChannel),
            )
          : null,
      body: body,
    );
  }
}
