import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/channels_data.dart';
import '../../router.dart';
import '../../shell/error_text.dart';
import '../../shell/pill.dart';
import '../../shell/section_header.dart';
import 'channel_commands.dart';
import 'channel_match.dart';
import 'channel_row.dart';
import 'follow_dialog.dart';

/// The followed channels, sorted so the ones needing attention come
/// first and moving to their new place when their state changes; then the
/// channels the library has clips from that nobody follows yet.
class ChannelsPage extends ConsumerWidget {
  const ChannelsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final text = Theme.of(context).textTheme;
    final asked = ref.watch(channelsProvider);
    final state = asked.valueOrNull;
    final match = ref.watch(channelMatchProvider).valueOrNull;
    final configured = ref.watch(channelSourceProvider) != null;
    final subs = state?.sorted ?? const <ChannelSubscription>[];
    final supported = state?.supported ?? false;

    Widget fill(Widget child) => Padding(
      padding: const EdgeInsets.symmetric(vertical: VhSpace.xxl * 2),
      child: Center(child: child),
    );

    final Widget body;
    if (!configured) {
      body = fill(
        VhEmptyFrame(
          title: l.desktopChannelsLater,
          message: l.desktopChannelsLaterBody,
        ),
      );
    } else if (state == null) {
      body = fill(
        asked.hasError
            ? VhEmptyFrame(
                title: l.failed,
                message: errorText(l, asked.error!),
                actionLabel: l.retry,
                onAction: () => ref.invalidate(channelsProvider),
              )
            : const VhSpinner(),
      );
    } else if (subs.isEmpty) {
      body = fill(
        VhEmptyFrame(
          title: l.subscriptionsEmpty,
          message: l.subscriptionsEmptyBody,
          actionLabel: l.followChannel,
          onAction: () => unawaited(showFollowDialog(context)),
        ),
      );
    } else {
      body = VhReorderMotion(
        children: [
          for (final sub in subs)
            ChannelRow(
              key: ValueKey(sub.id),
              sub: sub,
              stats: match?.stats[sub.id],
              onOpen: () => context.go(DesktopRoutes.channel(sub.id)),
            ),
        ],
      );
    }

    final unfollowed = supported ? match?.unfollowed ?? const [] : const [];
    return LayoutBuilder(
      builder: (context, box) {
        final side = math.max(
          VhSpace.xl,
          (box.maxWidth - VhBreakpoint.readable) / 2,
        );
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(side, VhSpace.sm, side, VhSpace.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: VhSpace.md,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        Text(l.desktopChannels, style: text.headlineSmall),
                        if (subs.isNotEmpty)
                          Text(
                            l.settingsValueChannels(subs.length),
                            style: text.bodySmall?.copyWith(
                              color: VhThemeX.of(context).palette.ink3,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (supported)
                    // The actions wrap under each other before the title
                    // gives way, under a large font.
                    Flexible(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          spacing: VhSpace.xs,
                          runSpacing: VhSpace.xs,
                          children: [
                            if (subs.isNotEmpty)
                              DesktopPill(
                                label: l.desktopCheckAll,
                                selected: false,
                                onTap: () =>
                                    unawaited(checkChannels(context, ref)),
                              ),
                            DesktopPill(
                              label: l.followChannel,
                              icon: VhIcons.plus,
                              selected: false,
                              onTap: () => unawaited(showFollowDialog(context)),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: VhSpace.lg),
              body,
              if (unfollowed.isNotEmpty) ...[
                const SizedBox(height: VhSpace.xl),
                DesktopSectionHeader(title: l.desktopChannelsInLibrary),
                const SizedBox(height: VhSpace.sm),
                for (final channel in unfollowed)
                  _Unfollowed(
                    channel: channel,
                    onFollow: () => unawaited(
                      showFollowDialog(
                        context,
                        name: channel.name,
                        url: channel.latestUrl,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// A channel the library knows and nobody follows: its name, how many of
/// its clips are here, and "Follow".
class _Unfollowed extends StatelessWidget {
  const _Unfollowed({required this.channel, required this.onFollow});

  final LibraryChannel channel;
  final VoidCallback onFollow;

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: VhSpace.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              channel.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: vhTextDirectionOf(
                channel.name,
                Directionality.of(context),
              ),
              style: text.bodySmall?.copyWith(color: p.ink),
            ),
          ),
          Text(
            l.desktopInLibrary(channel.count),
            style: text.labelSmall?.copyWith(color: p.ink3),
          ),
          const SizedBox(width: VhSpace.md),
          VhLinkButton(label: l.follow, onPressed: onFollow),
        ],
      ),
    );
  }
}
