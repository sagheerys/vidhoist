import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'pc_pairing_store.dart';

/// What a route is called on the phone: the home network or Tailscale.
String pcRouteName(VhLocalizations l10n, PcPairing pairing, String host) {
  final kind = [
    for (final r in pairing.routes)
      if (r.address == host) r.kind,
  ].firstOrNull;
  return switch (kind ?? pcAddressKind('', host)) {
    PcAddressKind.home => l10n.pcRouteHome,
    PcAddressKind.tailscale => l10n.pcRouteTailscale,
    PcAddressKind.other => l10n.pcRouteOther,
  };
}

/// Tailscale is known but another route is in use: away from home, the
/// user's way back to the computer.
bool pcTailscaleUnused(PcPairing pairing) => pairing.routes.any(
  (r) => r.kind == PcAddressKind.tailscale && r.address != pairing.host,
);

/// **Settings › Computer › Connect through**: the user picks the route,
/// the home network or Tailscale away from home; the phone never switches
/// on its own. The adapters other programs
/// add on the computer are left out, unless one is the route in use.
class PcRoutePicker extends ConsumerWidget {
  const PcRoutePicker({super.key, required this.pairing});

  final PcPairing pairing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final routes = [
      for (final r in pairing.routes)
        if (r.kind != PcAddressKind.other || r.address == pairing.host) r,
    ];
    final listed = routes.any((r) => r.address == pairing.host);
    Widget tile(String host, String detail) => ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(pcRouteName(l10n, pairing, host)),
      subtitle: Text(
        vhLtrRun(detail.isEmpty ? host : '$host · $detail'),
        style: text.bodySmall?.copyWith(color: p.ink2),
      ),
      trailing: host == pairing.host
          ? VhIcon(VhIcons.check, color: p.ink)
          : null,
      onTap: host == pairing.host
          ? null
          : () =>
                unawaited(ref.read(pcPairingProvider.notifier).useRoute(host)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.pcRouteTitle, style: text.bodySmall?.copyWith(color: p.ink2)),
        if (!listed) tile(pairing.host, ''),
        for (final r in routes) tile(r.address, r.adapter),
        if (pairing.routes.isEmpty || routes.length > 1)
          Text(
            pairing.routes.isEmpty ? l10n.pcRouteWaiting : l10n.pcRouteHint,
            style: text.labelSmall?.copyWith(color: p.ink3),
          ),
      ],
    );
  }
}
