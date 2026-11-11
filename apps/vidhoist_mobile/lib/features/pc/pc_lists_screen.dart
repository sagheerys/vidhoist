import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../shared/error_text.dart';
import 'pc_item_row.dart';
import 'pc_lists.dart';

/// **One line for all the computer's lists**, under its downloads: however
/// many there are, the page stays as short; the lists open on their own
/// page. Nothing while it has none.
class PcListsLine extends ConsumerWidget {
  const PcListsLine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(pcListsProvider).valueOrNull ?? const [];
    if (lists.isEmpty) return const SizedBox.shrink();
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: VhSpace.lg),
      leading: VhIcon(VhIcons.queue, color: p.ink2),
      title: Text(l10n.pcLists),
      trailing: Text(
        '${lists.length}',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: p.ink2),
      ),
      onTap: () => unawaited(context.push('/pc/lists')),
    );
  }
}

/// The computer's lists, each with its first clip's cover and how many of
/// its clips are there.
class PcListsScreen extends ConsumerWidget {
  const PcListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final lists = ref.watch(pcListsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.pcLists)),
      body: VhPullRefresh(
        onRefresh: () => ref.refresh(pcListsProvider.future),
        child: switch (lists) {
          AsyncData(:final value) when value.isEmpty => _Empty(
            l10n.pcListsEmpty,
          ),
          AsyncData(:final value) => ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              for (final list in value)
                VhMediaCard(
                  title: list.name,
                  subtitle: l10n.queueItemsCount(list.count),
                  thumbnail: PcThumb(
                    url: list.thumbnail,
                    coverId: list.coverId,
                  ),
                  onTap: () => unawaited(
                    context.push('/pc/lists/${Uri.encodeComponent(list.id)}'),
                  ),
                ),
            ],
          ),
          AsyncError(:final error) => _Empty(errorText(l10n, error)),
          _ => const Center(child: VhSpinner()),
        },
      ),
    );
  }
}

/// One computer list: play it all or shuffled, or a clip from it; each
/// clip's menu as in the computer's library.
class PcListScreen extends ConsumerWidget {
  const PcListScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final list = ref.watch(pcListProvider(id));
    final name = list.valueOrNull?.name ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: VhPullRefresh(
        onRefresh: () => ref.refresh(pcListProvider(id).future),
        child: switch (list) {
          AsyncData(value: final list?) when list.items.isNotEmpty => ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              _Actions(items: list.items),
              for (final item in list.items)
                PcItemRow(item: item, items: list.items),
            ],
          ),
          AsyncData() => _Empty(l10n.pcListEmpty),
          AsyncError(:final error) => _Empty(errorText(l10n, error)),
          _ => const Center(child: VhSpinner()),
        },
      ),
    );
  }
}

class _Actions extends ConsumerWidget {
  const _Actions({required this.items});

  final List<PcItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    Future<void> start({bool shuffle = false}) async {
      try {
        await playPcList(context, ref, items, shuffle: shuffle);
      } on Object catch (e) {
        if (context.mounted) showVhSnack(context, errorText(l10n, e));
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        VhSpace.pagePad,
        VhSpace.sm,
        VhSpace.pagePad,
        VhSpace.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.queueItemsCount(items.length),
            style: Theme.of(context).textTheme.bodySmall!
                .copyWith(color: p.ink3),
          ),
          const SizedBox(height: VhSpace.sm),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => unawaited(start()),
                  icon: const VhIcon(VhIcons.playFill, size: 18),
                  label: Text(l10n.playAll),
                ),
              ),
              const SizedBox(width: VhSpace.xs),
              IconButton.outlined(
                tooltip: l10n.shuffle,
                onPressed: () => unawaited(start(shuffle: true)),
                icon: const VhIcon(VhIcons.shuffle, size: 19),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A word in the middle of a page that can still be pulled to refresh.
class _Empty extends StatelessWidget {
  const _Empty(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      Padding(
        padding: const EdgeInsets.all(VhSpace.xl),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: VhThemeX.of(context).palette.ink2),
        ),
      ),
    ],
  );
}
