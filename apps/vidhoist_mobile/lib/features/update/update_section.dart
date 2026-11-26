import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import 'update_sheet.dart';
import 'update_state.dart';
import 'whats_new_prompt.dart';

/// The "updates" section in settings, added as one widget so the settings
/// screen stays under the 400-line limit.
class UpdateSection extends ConsumerWidget {
  const UpdateSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final state = ref.watch(updateControllerProvider);
    final controller = ref.read(updateControllerProvider.notifier);
    final hasUpdate = state.release != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: VhIcon(
            hasUpdate ? VhIcons.saveTo : VhIcons.refresh,
            // **The accent colour when an update exists**, read from the
            // palette so no other app's accent leaks into the petrol bay.
            color: hasUpdate ? p.accent : p.ink2,
          ),
          title: Text(
            hasUpdate ? l10n.updateAvailable : l10n.checkForUpdates,
            style: hasUpdate
                ? text.bodyLarge!.copyWith(
                    color: p.accent,
                    fontWeight: FontWeight.w700,
                  )
                : null,
          ),
          subtitle: Text(
            _subtitle(context, state),
            style: text.bodySmall!.copyWith(color: p.ink3),
          ),
          trailing: state.phase == UpdatePhase.checking
              ? const VhSpinner(size: 18)
              : VhIcon(
                  hasUpdate ? VhIcons.forward : VhIcons.refresh,
                  matchTextDirection: hasUpdate,
                ),
          onTap: state.busy
              ? null
              : () async {
                  if (hasUpdate) {
                    showUpdateSheet(context);
                    return;
                  }
                  await controller.checkNow();
                  // After a manual check: an update opens the sheet
                  // immediately, and its
                  // absence is said plainly. Silence looks like a fault.
                  if (!context.mounted) return;
                  final after = ref.read(updateControllerProvider);
                  if (after.release != null) {
                    showUpdateSheet(context);
                  } else if (after.failure == UpdateFailure.check) {
                    showVhSnack(
                      context,
                      l10n.updateCheckFailed,
                      type: VhSnackType.error,
                    );
                  } else if (after.upToDate) {
                    showVhSnack(
                      context,
                      l10n.updateUpToDate,
                      type: VhSnackType.success,
                    );
                  }
                },
        ),
        // What the running version brought, for whoever closed the sheet
        // after the update, or never saw it.
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: VhIcon(VhIcons.sparkle, color: p.ink2),
          title: Text(l10n.whatsNewThisVersion),
          trailing: const VhIcon(VhIcons.forward, matchTextDirection: true),
          onTap: () => showWhatsNewNow(context, ref),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.autoCheckUpdates, style: text.bodyMedium),
          subtitle: Text(l10n.autoCheckUpdatesHelp, style: text.bodySmall),
          value: state.autoCheck,
          onChanged: controller.setAutoCheck,
        ),
      ],
    );
  }

  String _subtitle(BuildContext context, UpdateState state) {
    final l10n = context.vhl;
    final release = state.release;
    if (release != null) return release.version.toString();
    if (state.phase == UpdatePhase.checking) return l10n.updateChecking;
    final at = state.checkedAt;
    return l10n.lastCheckedAt(
      at == null ? l10n.updateNever : vhTimeAgo(context, at),
    );
  }
}
