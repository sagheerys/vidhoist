import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:share_plus/share_plus.dart';

import '../../di.dart';
import '../downloads_library/library_providers.dart';
import '../playlists/playlists_providers.dart';
import '../shared/error_report.dart';
import '../storage/media_folder_rename.dart';
import 'auto_backup.dart';
import 'widgets/backup_picker.dart';

/// Backup and restore: **plain text, rotating, with no key** (decision
/// 2026-09-04). Seven dated copies that refresh themselves, a restore from
/// any of them, and an export for sharing.
///
/// **The concept of a backup key was removed from the product entirely**
/// (decided the same day): no export, no import, and no "keep it like a
/// password" warning. The backup is no longer encrypted, and what does not
/// exist can be neither forgotten nor lost.
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;
  List<BackupFile> _backups = const [];

  BackupService get _service => ref.read(backupServiceProvider);
  AutoBackup get _backup => ref.read(autoBackupProvider);

  @override
  void initState() {
    super.initState();
    unawaited(_refreshList());
  }

  Future<void> _refreshList() async {
    final all = await _backup.list();
    if (mounted) setState(() => _backups = all);
  }

  Future<void> _run(
    Future<String> Function(VhLocalizations l10n) action,
  ) async {
    final l10n = context.vhl;
    setState(() => _busy = true);
    try {
      final message = await action(l10n);
      if (mounted) showVhSnack(context, message, type: VhSnackType.success);
    } on BackupCancelledException {
      // A user cancelling is not an error.
    } catch (e) {
      if (mounted) {
        showErrorSnack(context, ref, e, tag: 'backup');
      }
    } finally {
      await _refreshList();
      if (mounted) setState(() => _busy = false);
    }
  }

  /// **Read through the system picker (SAF):** Android 11+ refuses to read
  /// a file the app did not create, even in the same folder (`errno 13`),
  /// and a migration backup comes from another device by definition.
  Future<String?> _pickFileContents() async {
    final picked = await FilePicker.platform.pickFiles(withData: true);
    final file = picked?.files.singleOrNull;
    if (file == null) return null;
    if (file.bytes case final Uint8List bytes) return utf8.decode(bytes);
    final path = file.path;
    return path == null ? null : File(path).readAsString();
  }

  /// **An export for sharing is a separate file from the rotation**: a
  /// dated name with the share chooser opening on it immediately, which is
  /// its only purpose. Conflating it with the automatic backup made "back
  /// up now" overwrite a file while suggesting it had exported it.
  Future<String> _exportAndShare(VhLocalizations l10n) async {
    final stamp = BackupRotation.stampOf(DateTime.now());
    final file = File('$phoneBackupDir/share_${phoneBackupPrefix}_$stamp.json');
    await file.parent.create(recursive: true);
    await file.writeAsString(await _service.exportToString(), flush: true);
    await Share.shareXFiles([XFile(file.path)]);
    return l10n.backupSuccess(vhLtrRun(file.path));
  }

  Future<String> _importPicked(VhLocalizations l10n) async {
    final contents = await _pickFileContents();
    if (contents == null) throw const BackupCancelledException();
    return _applyRestore(l10n, await _service.importFromString(contents));
  }

  Future<String> _restoreFrom(VhLocalizations l10n, BackupFile file) async =>
      _applyRestore(l10n, await _backup.restore(file));

  Future<String> _applyRestore(
    VhLocalizations l10n,
    ImportResult result,
  ) async {
    await _refreshEverything();
    return '${l10n.restoreSuccess} · ${result.keysRestored}';
  }

  /// Everything the backup may have changed is reloaded (rule 8, step 1).
  Future<void> _refreshEverything() async {
    // A picked file may predate the folder's `VidHoist` spelling.
    await rewriteStoredPaths(
      ref.read(keyValueStoreProvider),
      ref.read(prefsMutexProvider),
    );
    await ref.read(settingsProvider.notifier).reloadFromStore();
    ref.invalidate(localMediaProvider);
    ref.invalidate(playlistsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;

    ListTile tile(
      VhIconData icon,
      String title,
      String subtitle,
      VoidCallback onTap,
    ) => ListTile(
      contentPadding: EdgeInsets.zero,
      enabled: !_busy,
      leading: VhIcon(icon, color: p.ink2),
      title: Text(title),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      onTap: onTap,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupSettings)),
      body: VhReadableWidth(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            VhSpace.pagePad,
            0,
            VhSpace.pagePad,
            VhSpace.xxl,
          ),
          children: [
            // **No section header repeating the screen title** (review
            // 2026-09-05): the app bar says "back up all data" and directly
            // beneath it sat "backup and restore", two lines with one
            // meaning.
            const SizedBox(height: VhSpace.md),
            BackupStatusLine(backups: _backups),
            const SizedBox(height: VhSpace.md),
            tile(
              VhIcons.share,
              l10n.exportShare,
              l10n.exportShareSubtitle,
              () => _run(_exportAndShare),
            ),
            tile(
              VhIcons.folder,
              l10n.pickAnotherFile,
              l10n.pickAnotherFileSubtitle,
              () => _run(_importPicked),
            ),
            const SizedBox(height: VhSpace.lg),
            // **The copies are shown rather than hidden behind a button**
            // (review 2026-09-05): two thirds of the screen was empty and the
            // only useful information, when each copy was made and how large
            // it is, sat behind a sheet with nothing to hint at it.
            VhSectionHeader(title: l10n.restoreData),
            const SizedBox(height: VhSpace.sm),
            if (_backups.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: VhSpace.md),
                child: Text(
                  l10n.noBackupsYet,
                  style: Theme.of(context).textTheme.bodySmall!
                      .copyWith(color: p.ink3),
                ),
              )
            else
              for (final (index, file) in _backups.indexed)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  enabled: !_busy,
                  leading: VhIcon(
                    index == 0 ? VhIcons.clock : VhIcons.clock,
                    color: index == 0 ? p.accent : p.ink3,
                  ),
                  title: Text(vhTimeAgo(context, file.at)),
                  subtitle: Text(
                    '${(file.sizeBytes / 1024).toStringAsFixed(1)} KB',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: TextButton(
                    onPressed: _busy
                        ? null
                        : () => _run((l10n) => _restoreFrom(l10n, file)),
                    child: Text(l10n.restoreData),
                  ),
                ),
            const SizedBox(height: VhSpace.lg),
            Text(
              l10n.backupNote,
              style: Theme.of(context).textTheme.bodySmall!
                  .copyWith(color: p.ink3),
            ),
          ],
        ),
      ),
    );
  }
}

/// The user cancelled the file picker: a quiet message, not a loud error.
class BackupCancelledException implements Exception {
  const BackupCancelledException();
}
