import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../downloads_library/local_item.dart';
import 'pc_pairing_store.dart';

Future<bool> readSendToPc(KeyValueStore store) async =>
    await store.getBool(pcSendToPcKey) ?? false;

Future<void> writeSendToPc(WidgetRef ref, bool toPc) => ref
    .read(prefsMutexProvider)
    .run(() => ref.read(keyValueStoreProvider).setBool(pcSendToPcKey, toPc));

/// "Save to": the paired computer or this phone, side by side. Shown in the
/// add sheet once the computer was asked, never for a playlist; a computer
/// away takes the link when it is back.
class PcDestination extends StatelessWidget {
  const PcDestination({
    super.key,
    required this.pcName,
    required this.toPc,
    required this.onChanged,
    this.away = false,
  });

  final String pcName;
  final bool toPc;
  final ValueChanged<bool> onChanged;

  /// It did not answer just now: the link waits on this phone for it.
  final bool away;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.storageLocation,
          style: text.bodySmall?.copyWith(color: p.ink2),
        ),
        const SizedBox(height: VhSpace.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Choice(
                icon: VhIcons.monitor,
                title: pcName,
                subtitle: away ? l10n.pcWillSend : l10n.pcConnected,
                selected: toPc,
                onTap: () => onChanged(true),
              ),
            ),
            const SizedBox(width: VhSpace.sm),
            Expanded(
              child: _Choice(
                icon: VhIcons.offline,
                title: l10n.pcDestPhone,
                subtitle: 'Download/${phoneMediaDir.split('/').last}',
                selected: !toPc,
                onTap: () => onChanged(false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final VhIconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(VhCorners.mobile.field);
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? p.accentSoft : p.card,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: selected ? p.accent : p.line2,
            width: selected ? 2 : VhThemeX.of(context).hairline,
          ),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(VhSpace.sm),
            child: Row(
              children: [
                VhIcon(icon, color: selected ? p.accentInk : p.ink),
                const SizedBox(width: VhSpace.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodyMedium?.copyWith(
                          color: p.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.labelSmall?.copyWith(color: p.ink2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Whether the add sheet offers the computer at all: paired, and not a
/// playlist, which has its own screen on the phone.
bool offerPc(WidgetRef ref, String url) =>
    ref.read(pcPairingProvider) != null && !PlaylistDetector.isPlaylist(url);
