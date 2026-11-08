import 'package:flutter/material.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

/// The automatic backup status line: confidence comes from seeing that the
/// thing is happening.
class BackupStatusLine extends StatelessWidget {
  const BackupStatusLine({super.key, required this.backups});

  final List<BackupFile> backups;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme.bodySmall!.copyWith(color: p.ink3);

    return Row(
      children: [
        VhIcon(VhIcons.refresh, size: 16, color: p.ink3),
        const SizedBox(width: VhSpace.xs),
        Expanded(
          child: Text(
            backups.isEmpty
                ? l10n.noBackupsYet
                : '${l10n.lastBackup(vhTimeAgo(context, backups.first.at))}'
                      ' · ${l10n.backupsKept(backups.length)}',
            style: text,
          ),
        ),
      ],
    );
  }
}
