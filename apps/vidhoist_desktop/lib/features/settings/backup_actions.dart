import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_transcripts/vh_transcripts.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/backup_data.dart';
import '../../data/folders_data.dart';

/// Whether dropped or pasted [text] is a phone's backup or transcripts
/// file, which goes to the import rather than the add dialog.
bool isBackupText(String text) =>
    BackupMerge.looksLikeBackup(text) || TranscriptBundle.decode(text) != null;

/// Adds a phone's file to this computer and says what it brought; a
/// computer's own backup is restored whole once the person says so.
Future<ImportOutcome> importFromPhone(
  BuildContext context,
  WidgetRef ref,
  String contents,
) async {
  final outcome = await ref.read(backupsProvider).importFile(contents);
  if (!context.mounted) return outcome;
  final l = context.vhl;
  if (outcome case ComputerBackup(:final contents)) {
    final sure = await showVhConfirm(
      context,
      title: l.desktopRestoreTitle,
      message: l.desktopRestoreBody,
      confirmLabel: l.desktopRestore,
      cancelLabel: l.cancel,
    );
    if (!sure || !context.mounted) return outcome;
    await ref.read(backupsProvider).restoreText(contents);
    if (context.mounted) showVhNotice(context, message: l.desktopRestored);
    return outcome;
  }
  final (message, kind) = switch (outcome) {
    ComputerBackup() => (l.desktopRestored, VhNoticeKind.done),
    MergedBackup(:final result) when result.changedNothing => (
      l.desktopImportedNothing,
      VhNoticeKind.info,
    ),
    MergedBackup(:final result) => (
      l.desktopImportedBackup(
        result.tagged,
        result.playlists,
        result.positions,
      ),
      VhNoticeKind.done,
    ),
    MergedTranscripts(:final added) => (
      l.desktopImportedTranscripts(added),
      VhNoticeKind.done,
    ),
    NotABackup() => (l.desktopNotABackup, VhNoticeKind.failed),
  };
  showVhNotice(context, message: message, kind: kind);
  return outcome;
}

/// Windows' open dialog for a phone's file, then [importFromPhone].
Future<ImportOutcome?> chooseAndImport(
  BuildContext context,
  WidgetRef ref,
) async {
  final text = await ref
      .read(desktopFoldersProvider)
      .openText(extensions: const ['json']);
  if (text == null || !context.mounted) return null;
  return importFromPhone(context, ref, text);
}
