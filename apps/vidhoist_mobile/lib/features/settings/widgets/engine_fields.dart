import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_ui/mt_ui.dart';

import '../../../di.dart';
import '../../engine/engine_preparer.dart';
import 'settings_fields.dart';

/// The download engine, in place of the server settings: yt-dlp's
/// version, an update on demand (YouTube breaks old builds within months,
/// `docs/ENGINE.md` finding 12), and IPv4.
class EngineFields extends ConsumerWidget {
  const EngineFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.mtl;
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
          leading: const MTIcon(MTIcons.bolt),
          title: const Text('yt-dlp'),
          subtitle: Text(
            status.version?.toString() ?? l10n.mobileEngineVersionUnknown,
            textDirection: status.version == null ? null : TextDirection.ltr,
            style: text.bodySmall,
          ),
        ),
        if (status.updatedAt case final at?)
          Text(
            l10n.mobileEngineLastUpdate(mtTimeAgo(context, at)),
            style: text.bodySmall,
          ),
        const SizedBox(height: MTSpace.sm),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: FilledButton.tonal(
            onPressed: busy ? null : () => unawaited(_update(context, ref)),
            child: Text(
              busy ? l10n.mobileEngineUpdating : l10n.mobileEngineUpdate,
            ),
          ),
        ),
        const SizedBox(height: MTSpace.md),
        SettingsSwitchTile(
          title: l10n.mobileEngineIpv4,
          subtitle: l10n.mobileEngineIpv4Help,
          value: settings.forceIpv4,
          onChanged: ref.read(settingsProvider.notifier).setForceIpv4,
        ),
      ],
    );
  }

  Future<void> _update(BuildContext context, WidgetRef ref) async {
    final l10n = context.mtl;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await ref.read(enginePreparerProvider).update();
    showMTSnackOn(
      messenger,
      ok ? l10n.mobileEngineUpToDate : l10n.mobileEngineUpdateFailed,
      type: ok ? MTSnackType.success : MTSnackType.error,
    );
  }
}

/// The engine's line on the settings home: its version, or why there is
/// none yet.
String engineSummary(MTLocalizations l10n, EngineStatus status) =>
    switch (status) {
      EngineStatus(:final version?) => 'yt-dlp $version',
      EngineStatus(isBusy: true) => l10n.mobileEngineNotReady,
      _ => l10n.mobileEngineVersionUnknown,
    };
