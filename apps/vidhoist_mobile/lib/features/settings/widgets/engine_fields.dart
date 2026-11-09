import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../../di.dart';
import '../../engine/engine_preparer.dart';
import 'settings_fields.dart';

/// The download engine: yt-dlp's version, an update on demand (YouTube
/// breaks old builds within months,
/// `docs/ENGINE.md` finding 12), a repair for when that is not enough
/// (plan item R5), and IPv4.
class EngineFields extends ConsumerStatefulWidget {
  const EngineFields({super.key});

  @override
  ConsumerState<EngineFields> createState() => _EngineFieldsState();
}

class _EngineFieldsState extends ConsumerState<EngineFields> {
  /// The repair, not the update, is what keeps the engine busy: each
  /// button names its own work.
  bool _repairing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final text = Theme.of(context).textTheme;
    final settings = ref.watch(settingsProvider);
    final status =
        ref.watch(engineStatusProvider).valueOrNull ??
        ref.read(enginePreparerProvider).status;
    final busy = status.isBusy;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const VhIcon(VhIcons.bolt),
          title: const Text('yt-dlp'),
          subtitle: Text(
            status.version?.toString() ?? l10n.mobileEngineVersionUnknown,
            textDirection: status.version == null ? null : TextDirection.ltr,
            style: text.bodySmall,
          ),
        ),
        if (status.updatedAt case final at?)
          Text(
            l10n.mobileEngineLastUpdate(vhTimeAgo(context, at)),
            style: text.bodySmall,
          ),
        const SizedBox(height: VhSpace.sm),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: FilledButton.tonal(
            onPressed: busy ? null : () => unawaited(_update(context)),
            child: Text(
              busy && !_repairing
                  ? l10n.mobileEngineUpdating
                  : l10n.mobileEngineUpdate,
            ),
          ),
        ),
        const SizedBox(height: VhSpace.md),
        Text(l10n.engineRepairHint, style: text.bodySmall),
        const SizedBox(height: VhSpace.xs),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: OutlinedButton(
            onPressed: busy ? null : () => unawaited(_repair(context)),
            child: Text(_repairing ? l10n.engineRepairing : l10n.engineRepair),
          ),
        ),
        const SizedBox(height: VhSpace.md),
        SettingsSwitchTile(
          title: l10n.mobileEngineIpv4,
          subtitle: l10n.mobileEngineIpv4Help,
          value: settings.forceIpv4,
          onChanged: ref.read(settingsProvider.notifier).setForceIpv4,
        ),
      ],
    );
  }

  /// Refused while something downloads: the repair replaces the yt-dlp a
  /// running download reads.
  Future<void> _repair(BuildContext context) async {
    final l10n = context.vhl;
    final messenger = ScaffoldMessenger.of(context);
    if (ref.read(downloadEngineProvider)?.hasActiveWork ?? false) {
      showVhSnackOn(messenger, l10n.engineRepairBusy);
      return;
    }
    setState(() => _repairing = true);
    final preparer = ref.read(enginePreparerProvider);
    final ok = await preparer.repair();
    if (mounted) setState(() => _repairing = false);
    showVhSnackOn(
      messenger,
      ok
          ? l10n.engineRepaired(preparer.status.version?.toString() ?? '?')
          : l10n.engineRepairPartly,
      type: ok ? VhSnackType.success : VhSnackType.error,
    );
  }

  Future<void> _update(BuildContext context) async {
    final l10n = context.vhl;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await ref.read(enginePreparerProvider).update();
    showVhSnackOn(
      messenger,
      ok ? l10n.mobileEngineUpToDate : l10n.mobileEngineUpdateFailed,
      type: ok ? VhSnackType.success : VhSnackType.error,
    );
  }
}

/// The engine's line on the settings home: its version, or why there is
/// none yet.
String engineSummary(VhLocalizations l10n, EngineStatus status) =>
    switch (status) {
      EngineStatus(:final version?) => 'yt-dlp $version',
      EngineStatus(isBusy: true) => l10n.mobileEngineNotReady,
      _ => l10n.mobileEngineVersionUnknown,
    };
