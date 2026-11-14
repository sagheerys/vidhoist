import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vh_ui/vh_ui.dart';

/// **Whether battery saving leaves the app's downloads alone.** A long
/// download goes on with the app out of sight, and Samsung's battery
/// manager stops such an app well before it ends; the app then finds the
/// download half done at its next start. Android asks the person once,
/// in its own dialog, to exempt the app.
abstract interface class BatteryFreedom {
  Future<bool> isFree();

  /// Shows Android's dialog; whether the app is exempt afterwards.
  Future<bool> ask();
}

class PermissionBatteryFreedom implements BatteryFreedom {
  const PermissionBatteryFreedom();

  /// Free when it cannot be known (no plugin, as in tests): a card asking
  /// for what may already be given is worse than none.
  @override
  Future<bool> isFree() async {
    try {
      return await Permission.ignoreBatteryOptimizations.isGranted;
    } on Object {
      return true;
    }
  }

  @override
  Future<bool> ask() async {
    try {
      return await Permission.ignoreBatteryOptimizations.request().isGranted;
    } on Object {
      return false;
    }
  }
}

final batteryFreedomProvider = Provider<BatteryFreedom>(
  (ref) => const PermissionBatteryFreedom(),
);

/// Read again on each return to the app: the exemption can be given or
/// taken back in Android's settings while the app is away.
final batteryFreeProvider = FutureProvider<bool>(
  (ref) => ref.watch(batteryFreedomProvider).isFree(),
);

/// **Settings › Downloads › Advanced: whether battery saving may stop a
/// download**, in the page's own row: a state pill, and while restricted
/// an "Allow" that opens Android's dialog. Kept off the settings home: a
/// standing banner there shouted about something most people set once.
///
/// Read again whenever the app comes back, since the exemption can be
/// given or taken back in Android's settings while it is away.
class BatteryTile extends ConsumerStatefulWidget {
  const BatteryTile({super.key});

  @override
  ConsumerState<BatteryTile> createState() => _BatteryTileState();
}

class _BatteryTileState extends ConsumerState<BatteryTile> {
  late final _lifecycle = AppLifecycleListener(
    onResume: () => ref.invalidate(batteryFreeProvider),
  );

  @override
  void initState() {
    super.initState();
    _lifecycle;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _ask() async {
    await ref.read(batteryFreedomProvider).ask();
    ref.invalidate(batteryFreeProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final text = Theme.of(context).textTheme;
    final p = VhThemeX.of(context).palette;
    final free = ref.watch(batteryFreeProvider).valueOrNull;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: VhSpace.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The pill goes under the title when both do not fit: beside it,
          // the largest text on the narrowest phone ran past the edge.
          OverflowBar(
            spacing: VhSpace.sm,
            overflowSpacing: VhSpace.xxs,
            alignment: MainAxisAlignment.spaceBetween,
            overflowAlignment: OverflowBarAlignment.start,
            children: [
              Text(l10n.batteryTitle, style: text.bodyMedium),
              if (free != null)
                VhStatusPill(
                  label: free
                      ? l10n.batteryStateFree
                      : l10n.batteryStateLimited,
                  good: free,
                ),
            ],
          ),
          const SizedBox(height: VhSpace.xxs),
          Text(
            free == false ? l10n.batteryRestricted : l10n.batteryFree,
            style: text.bodySmall,
          ),
          if (free == false) ...[
            const SizedBox(height: VhSpace.sm),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: p.accentSoft,
                  foregroundColor: p.accentInk,
                ),
                onPressed: () => unawaited(_ask()),
                child: Text(l10n.batteryAllow),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
