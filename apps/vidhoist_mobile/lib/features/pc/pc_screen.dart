import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'pc_errors.dart';
import 'pc_downloads.dart';
import 'pc_browse.dart';
import 'pc_library_section.dart';
import 'pc_link_state.dart';
import 'pc_lists.dart';
import 'pc_lists_screen.dart';
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

  Future<void> _refresh() {
    ref.invalidate(pcListsProvider);
    return _view.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final view = ref.watch(pcViewProvider);
    final pairing = ref.watch(pcPairingProvider);
    // The lists are asked for again when the computer is back.
    ref.listen(pcViewProvider.select((v) => v.online), (was, now) {
      if (now && was == false) ref.invalidate(pcListsProvider);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pcTab),
        actions: [
          IconButton(
            tooltip: l10n.refresh,
            onPressed: () => unawaited(_refresh()),
            icon: const VhIcon(VhIcons.refresh),
          ),
        ],
      ),
      body: VhPullRefresh(
        onRefresh: _refresh,
        // A column of reading width on a tablet, as the other pages keep:
        // stretched, a row's title and its menu stood a screen apart.
        child: VhReadableWidth(
          // Near the end of the list, the next page of the library.
          child: NotificationListener<ScrollNotification>(
            onNotification: (event) => pcLoadMoreNear(event, ref),
            child: CustomScrollView(
              slivers: [
                SliverList.list(
                  children: [
                    _StatusCard(
                      view: view,
                      name: view.status?.name ?? pairing?.name ?? '',
                      route: pairing == null
                          ? null
                          : l10n.pcVia(
                              pcRouteName(l10n, pairing, pairing.host),
                            ),
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
                                  if (pairing != null &&
                                      pcTailscaleUnused(pairing))
                                    l10n.pcOfflineRoute,
                                ].join(' ')
                              : pcFailureText(l10n, view.failure!),
                          style: text.bodySmall?.copyWith(color: p.ink2),
                        ),
                      ),
                    const PcDownloadsStrip(),
                    const PcListsLine(),
                  ],
                ),
                ...pcLibrarySlivers(
                  context,
                  ref,
                  browse: ref.watch(pcBrowseProvider),
                  sorts: view.status?.sorts ?? false,
                ),
                // Clear of the navigation buttons under the page.
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.view, required this.name, this.route});

  final PcView view;
  final String name;

  /// "Through Tailscale": the route the user chose.
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
                        VhStatusPill(
                          label: view.online
                              ? l10n.pcConnected
                              : l10n.pcOffline,
                          good: view.online,
                        ),
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
