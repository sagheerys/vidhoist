import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'pc_pairing_store.dart';
import 'pc_route_picker.dart';

/// Settings › Computer once paired: the computer, the route to it, the
/// certificate it must show, and the way to unpair.
class PcPairedView extends ConsumerWidget {
  const PcPairedView({super.key, required this.pairing});

  final PcPairing pairing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final fp = pairing.fingerprint.toUpperCase();
    final groups = [for (var i = 0; i < 16; i += 4) fp.substring(i, i + 4)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(pairing.name, style: text.titleMedium?.copyWith(color: p.ink)),
        const SizedBox(height: VhSpace.md),
        PcRoutePicker(pairing: pairing),
        const SizedBox(height: VhSpace.md),
        Text(
          l10n.pcCertificate,
          style: text.bodySmall?.copyWith(color: p.ink2),
        ),
        Text(
          groups.join(' '),
          textDirection: TextDirection.ltr,
          style: text.bodyMedium?.copyWith(
            color: p.ink,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: VhSpace.lg),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: p.err),
            onPressed: () =>
                unawaited(ref.read(pcPairingProvider.notifier).forget()),
            icon: const VhIcon(VhIcons.linkOff),
            label: Text(l10n.pcLinkRevoke),
          ),
        ),
      ],
    );
  }
}
