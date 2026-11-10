import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'pc_errors.dart';
import 'pc_item_row.dart';
import 'pc_link_state.dart';
import 'pc_outbox_section.dart';
import 'pc_route_picker.dart';
import 'pc_pairing_store.dart';

/// **The "Computer" tab**, there only once this phone is paired: the
/// computer's state, what it downloads now, and its library. It asks the
/// computer only while the tab is on screen.
class PcScreen extends ConsumerStatefulWidget {
  const PcScreen({super.key});

  @override
  ConsumerState<PcScreen> createState() => _PcScreenState();
}

class _PcScreenState extends ConsumerState<PcScreen> {
  var _watching = false;

  /// Held from the start: a disposed widget may no longer read providers.
  late final PcViewNotifier _view = ref.read(pcViewProvider.notifier);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The tab stack turns tickers off on the tabs out of sight.
    final visible = TickerMode.valuesOf(context).enabled;
    if (visible == _watching) return;
    _watching = visible;
    visible ? _view.watch() : _view.stopWatching();
  }

  @override
  void dispose() {
    if (_watching) _view.stopWatching();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final view = ref.watch(pcViewProvider);
    final pairing = ref.watch(pcPairingProvider);
    final live = view.live;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pcTab),
        actions: [
          IconButton(
            tooltip: l10n.refresh,
            onPressed: () =>
                unawaited(ref.read(pcViewProvider.notifier).refresh()),
            icon: const VhIcon(VhIcons.refresh),
          ),
        ],
      ),
      body: VhPullRefresh(
        onRefresh: () => ref.read(pcViewProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            _StatusCard(
              view: view,
              name: view.status?.name ?? pairing?.name ?? '',
              route: pairing == null
                  ? null
                  : l10n.pcVia(pcRouteName(l10n, pairing, pairing.host)),
            ),
            if (!view.online && view.failure != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  VhSpace.lg,
                  0,
                  VhSpace.lg,
                  VhSpace.md,
                ),
                child: Text(
                  view.failure == PcLinkFailure.unreachable
                      ? [
                          l10n.pcOfflineMessage,
                          // Tailscale known but not in use: the way out.
                          if (pairing != null && pcTailscaleUnused(pairing))
                            l10n.pcOfflineRoute,
                        ].join(' ')
                      : pcFailureText(l10n, view.failure!),
                  style: text.bodySmall?.copyWith(color: p.ink2),
                ),
              ),
            const PcOutboxSection(),
            if (live.isNotEmpty) ...[
              PcHeader(title: '${l10n.pcNow} · ${live.length}'),
              for (final task in live) _TaskRow(task: task),
            ],
            PcHeader(
              title: view.total == 0
                  ? l10n.pcLibrary
                  : '${l10n.pcLibrary} · ${view.total}',
            ),
            if (view.items.isEmpty)
              Padding(
                padding: const EdgeInsets.all(VhSpace.xl),
                child: Text(
                  l10n.pcEmptyLibrary,
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(color: p.ink2),
                ),
              ),
            for (final item in view.items)
              PcItemRow(item: item, items: view.items),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.view, required this.name, this.route});

  final PcView view;
  final String name;

  /// "Through Tailscale": the route the owner chose.
  final String? route;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final seen = view.lastContact;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        VhSpace.lg,
        VhSpace.xs,
        VhSpace.lg,
        VhSpace.md,
      ),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: p.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VhCorners.mobile.card),
            side: BorderSide(
              color: p.line,
              width: VhThemeX.of(context).hairline,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(VhSpace.md),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: view.online ? p.accentSoft : p.cardAlt,
                  borderRadius: BorderRadius.circular(
                    VhCorners.mobile.field + 4,
                  ),
                ),
                child: SizedBox.square(
                  dimension: 44,
                  child: Center(
                    child: VhIcon(
                      VhIcons.monitor,
                      color: view.online ? p.accentInk : p.ink3,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: VhSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleSmall?.copyWith(color: p.ink),
                    ),
                    const SizedBox(height: VhSpace.xxs),
                    // Under the name rather than beside it: at the largest
                    // text on the narrowest phone there is no room beside.
                    Wrap(
                      spacing: VhSpace.sm,
                      runSpacing: VhSpace.xxs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _Pill(online: view.online),
                        if (route case final route?)
                          Text(
                            route,
                            style: text.bodySmall?.copyWith(color: p.ink2),
                          ),
                        if (seen != null)
                          Text(
                            l10n.pcLastContact(vhTimeAgo(context, seen)),
                            style: text.bodySmall?.copyWith(color: p.ink2),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.online});

  final bool online;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: online ? p.offlineSoft : p.cardAlt,
        borderRadius: BorderRadius.circular(VhRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: VhSpace.sm,
          vertical: VhSpace.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: online ? p.ok : p.ink3,
                shape: BoxShape.circle,
              ),
              child: const SizedBox.square(dimension: 7),
            ),
            const SizedBox(width: VhSpace.xs),
            Flexible(
              child: Text(
                online ? l10n.pcConnected : l10n.pcOffline,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.labelMedium?.copyWith(
                  color: online ? p.offlineInk : p.ink2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A download on the computer, drawn as the phone's own downloads are:
/// its progress, and a way to stop it.
class _TaskRow extends ConsumerWidget {
  const _TaskRow({required this.task});

  final PcTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final phase = task.phase;
    final measured = phase == 'downloading' || phase == 'postprocessing';
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: VhSpace.lg,
        vertical: VhSpace.xxs,
      ),
      child: VhDownloadProgressCard(
        // A new phase starts its own count, as on the phone's own cards.
        key: ValueKey('${task.id}-$phase'),
        title: task.title ?? task.url,
        statusText: switch (phase) {
          'queued' => l10n.queuedSection,
          'preparing' => l10n.enginePreparing,
          'postprocessing' => l10n.enginePostprocessing,
          'paused' => l10n.enginePaused,
          _ => l10n.downloadingTitle,
        },
        detail: phase == 'downloading' && task.speed != null
            ? vhFormatTransferRate(task.speed!)
            : null,
        progress: measured ? task.progress / 100 : null,
        waiting: phase == 'queued',
        thumbnail: PcThumb(url: task.thumbnail),
        onCancel: () =>
            unawaited(ref.read(pcViewProvider.notifier).cancel(task.id)),
      ),
    );
  }
}
