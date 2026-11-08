import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/backup_data.dart';
import '../../data/folders_data.dart';
import 'backup_actions.dart';
import 'simple_panes.dart';

/// This computer's backups, importing a phone's, and exporting for it.
class BackupPane extends ConsumerStatefulWidget {
  const BackupPane({super.key});

  @override
  ConsumerState<BackupPane> createState() => _BackupPaneState();
}

class _BackupPaneState extends ConsumerState<BackupPane> {
  late Future<List<BackupFile>> _list = ref.read(backupsProvider).list();

  void _reload() => setState(() => _list = ref.read(backupsProvider).list());

  Future<void> _backUpNow() async {
    await ref.read(backupsProvider).backUpNow();
    _reload();
  }

  Future<void> _restore(BackupFile file) async {
    final l = context.vhl;
    final sure = await showVhConfirm(
      context,
      title: l.desktopRestoreTitle,
      message: l.desktopRestoreBody,
      confirmLabel: l.desktopRestore,
      cancelLabel: l.cancel,
    );
    if (!sure || !mounted) return;
    await ref.read(backupsProvider).restore(file);
    if (mounted) showVhNotice(context, message: l.desktopRestored);
  }

  Future<void> _export() async {
    final folder = await ref.read(backupsProvider).exportForPhone();
    if (folder == null || !mounted) return;
    showVhNotice(context, message: context.vhl.desktopSavedIn(folder));
    unawaited(ref.read(desktopFoldersProvider).open(folder));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingLine(
          title: l.desktopImportFromPhone,
          hint: l.desktopImportHint,
          trailing: VhLinkButton(
            label: l.desktopSetupChooseFile,
            onPressed: () => unawaited(chooseAndImport(context, ref)),
          ),
        ),
        SettingLine(
          title: l.desktopExportForPhone,
          hint: l.desktopExportForPhoneHint,
          trailing: VhLinkButton(
            label: l.desktopExportForPhone,
            onPressed: () => unawaited(_export()),
          ),
        ),
        const SizedBox(height: VhSpace.lg),
        SettingLine(
          title: l.settingsBackup,
          hint: l.desktopBackupHint,
          trailing: VhLinkButton(
            label: l.desktopBackUpNow,
            onPressed: () => unawaited(_backUpNow()),
          ),
        ),
        FutureBuilder<List<BackupFile>>(
          future: _list,
          builder: (context, snap) {
            final files = snap.data ?? const [];
            if (snap.connectionState == ConnectionState.done && files.isEmpty) {
              return Text(
                l.desktopBackupsNone,
                style: text.bodySmall?.copyWith(color: p.ink3),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final file in files)
                  SettingLine(
                    title: vhTimeAgo(context, file.at),
                    hint: vhFormatSize(file.sizeBytes),
                    trailing: VhLinkButton(
                      label: l.desktopRestore,
                      onPressed: () => unawaited(_restore(file)),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
