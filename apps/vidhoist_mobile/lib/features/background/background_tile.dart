import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import 'background_state.dart';

/// **The switch for the check while the app is closed**, at the head of
/// the channels it checks. Under it, when the last one ran: Android picks
/// the moment, so this line is the only way to know it does.
class BackgroundChecksTile extends ConsumerStatefulWidget {
  const BackgroundChecksTile({super.key});

  @override
  ConsumerState<BackgroundChecksTile> createState() =>
      _BackgroundChecksTileState();
}

class _BackgroundChecksTileState extends ConsumerState<BackgroundChecksTile> {
  /// Back from the background, where the check runs, the line is read
  /// again.
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () => ref.invalidate(backgroundStatusProvider),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final on = ref.watch(backgroundChecksProvider);
    final last = ref.watch(backgroundStatusProvider).valueOrNull?.lastRun;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: VhSpace.pagePad),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.backgroundChecks, style: text.bodyMedium),
        subtitle: Text(
          [
            l10n.backgroundChecksHelp,
            if (on)
              last == null
                  ? l10n.backgroundNotRunYet
                  : l10n.backgroundLastRun(vhTimeAgo(context, last)),
          ].join('\n'),
          style: text.bodySmall?.copyWith(color: p.ink2),
        ),
        value: on,
        onChanged: (v) =>
            unawaited(ref.read(backgroundChecksProvider.notifier).set(v)),
      ),
    );
  }
}

/// **Asked once, after the first channel is followed**: the moment the
/// check has something to look at. A refusal is final; the switch stays
/// on the channels page.
Future<void> offerBackgroundChecks(BuildContext context) async {
  final checks = ProviderScope.containerOf(
    context,
    listen: false,
  ).read(backgroundChecksProvider.notifier);
  if (!await checks.takeOffer() || !context.mounted) return;
  final l10n = context.vhl;
  final yes = await showVhConfirm(
    context,
    title: l10n.backgroundOfferTitle,
    message: l10n.backgroundOfferBody,
    confirmLabel: l10n.backgroundOfferYes,
    cancelLabel: l10n.backgroundOfferNo,
  );
  if (yes) await checks.set(true);
}
