import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import 'pc_outbox.dart';

/// A section's title on the computer's page.
class PcHeader extends StatelessWidget {
  const PcHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      VhSpace.lg,
      VhSpace.md,
      VhSpace.lg,
      VhSpace.xs,
    ),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleSmall
          ?.copyWith(color: VhThemeX.of(context).palette.ink2),
    ),
  );
}

/// Links sent while the computer was away, at the top of its page: when
/// each was sent, any it would not take, and a way to take one back
/// before it goes. Nothing while none waits.
class PcOutboxSection extends ConsumerWidget {
  const PcOutboxSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queued = ref.watch(pcOutboxProvider);
    if (queued.isEmpty) return const SizedBox.shrink();
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PcHeader(title: l10n.pcOutboxTitle(queued.length)),
        for (final q in queued)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: VhSpace.lg),
            leading: VhIcon(VhIcons.clock, color: q.refused ? p.err : p.ink2),
            title: Text(
              q.url,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
            ),
            subtitle: Text(
              q.refused ? l10n.pcOutboxRefused : vhTimeAgo(context, q.at),
              style: TextStyle(color: q.refused ? p.err : p.ink2),
            ),
            trailing: IconButton(
              tooltip: l10n.remove,
              onPressed: () =>
                  unawaited(ref.read(pcOutboxProvider.notifier).remove(q)),
              icon: const VhIcon(VhIcons.close),
            ),
          ),
      ],
    );
  }
}
