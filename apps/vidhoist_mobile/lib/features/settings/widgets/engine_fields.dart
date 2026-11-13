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
///
/// **The version is the news, so it comes first and largest** (design round
/// 2026-11-11), in a card with how it stands. Under it the two actions in
/// one shape, full width: the filled one for the update, the outlined one
/// for the repair, whose explanation sits under the button it explains.
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
    final x = VhThemeX.of(context);
    final p = x.palette;
    final text = Theme.of(context).textTheme;
    final settings = ref.watch(settingsProvider);
    final preparer = ref.read(enginePreparerProvider);
    final status =
        ref.watch(engineStatusProvider).valueOrNull ?? preparer.status;
    final busy = status.isBusy;
    const action = Size.fromHeight(VhEmphasis.action);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Card(
          child: _Version(status: status, updateEvery: preparer.updateEvery),
        ),
        const SizedBox(height: VhSpace.md),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: action),
          onPressed: busy ? null : () => unawaited(_update(context)),
          icon: const VhIcon(VhIcons.refresh, size: 20),
          label: Text(
            busy && !_repairing
                ? l10n.mobileEngineUpdating
                : l10n.mobileEngineUpdate,
          ),
        ),
        const SizedBox(height: VhSpace.sm),
        OutlinedButton.icon(
          // The second action in the first one's shape, in the ink: the
          // accent stays with the update alone.
          style: OutlinedButton.styleFrom(
            minimumSize: action,
            foregroundColor: p.ink,
            side: BorderSide(color: p.line2, width: x.hairline),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(VhRadius.field),
            ),
            textStyle: text.labelLarge,
          ),
          onPressed: busy ? null : () => unawaited(_repair(context)),
          icon: const VhIcon(VhIcons.bolt, size: 20),
          label: Text(_repairing ? l10n.engineRepairing : l10n.engineRepair),
        ),
        const SizedBox(height: VhSpace.xs),
        Text(
          l10n.engineRepairHint,
          style: text.bodySmall?.copyWith(
            color: p.ink2,
            fontSize: VhEmphasis.explain,
          ),
        ),
        const SizedBox(height: VhSpace.md),
        _Card(
          child: SettingsSwitchTile(
            title: l10n.mobileEngineIpv4,
            subtitle: l10n.mobileEngineIpv4Help,
            value: settings.forceIpv4,
            onChanged: ref.read(settingsProvider.notifier).setForceIpv4,
          ),
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

/// A white card on the page's ground, as the settings home groups its rows.
class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final x = VhThemeX.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: x.palette.card,
        borderRadius: BorderRadius.circular(VhRadius.card),
        border: Border.all(color: x.palette.line, width: x.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: VhSpace.lg,
          vertical: VhSpace.md,
        ),
        // A tile paints its ink on the nearest Material: its own here, so
        // the switch row's press stays inside the card.
        child: Material(type: MaterialType.transparency, child: child),
      ),
    );
  }
}

/// yt-dlp's version as the page's one figure, with how it stands beside
/// its label and when it was last updated beneath.
class _Version extends StatelessWidget {
  const _Version({required this.status, required this.updateEvery});

  final EngineStatus status;

  /// How often the app updates yt-dlp by itself: an update older than this
  /// is no longer called "updated".
  final Duration updateEvery;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final quiet = text.bodySmall?.copyWith(
      color: p.ink2,
      fontSize: VhEmphasis.explain,
    );
    final at = status.updatedAt;
    // **Only what the app knows**: "updated" means the last update worked
    // and is within the app's own weekly round, not that no newer yt-dlp
    // exists this minute.
    final fresh =
        at != null &&
        !status.updateFailed &&
        DateTime.now().difference(at) < updateEvery;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(l10n.mobileEngineVersionLabel, style: quiet)),
            if (status.updateFailed)
              VhStatusPill(label: l10n.mobileEngineUpdateMissed, good: false)
            else if (fresh)
              VhStatusPill(label: l10n.mobileEngineUpdated, good: true),
          ],
        ),
        const SizedBox(height: VhSpace.xxs),
        if (status.version case final version?)
          VhFigure(version.toString(), size: VhEmphasis.figureInCard)
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: VhSpace.xs),
            child: Text(l10n.mobileEngineVersionUnknown, style: text.bodyLarge),
          ),
        if (at != null)
          Text(
            l10n.mobileEngineLastUpdate(vhTimeAgo(context, at)),
            style: quiet,
          ),
      ],
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
