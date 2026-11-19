import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import 'update_sheet.dart';
import 'update_state.dart';

/// The update on offer, at the top of Settings until it is installed or
/// skipped: whoever closed the sheet finds it again where the dot on the
/// Settings tab leads, not inside the Updates section. Nothing when no
/// update is offered.
class UpdatePendingRow extends ConsumerWidget {
  const UpdatePendingRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = ref.watch(updatePendingProvider);
    if (version == null) return const SizedBox.shrink();
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: VhSpace.sm, bottom: VhSpace.md),
      child: Material(
        color: p.accentSoft,
        borderRadius: BorderRadius.circular(VhCorners.mobile.card),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: VhIcon(VhIcons.saveTo, color: p.accentInk),
          title: Text(
            l10n.updateVersionAvailable(version),
            style: text.titleSmall?.copyWith(color: p.accentInk),
          ),
          subtitle: Text(
            l10n.updateWhatsNew,
            style: text.bodySmall?.copyWith(color: p.accentInk),
          ),
          trailing: VhIcon(
            VhIcons.forward,
            color: p.accentInk,
            matchTextDirection: true,
          ),
          onTap: () => showUpdateSheet(context),
        ),
      ),
    );
  }
}
