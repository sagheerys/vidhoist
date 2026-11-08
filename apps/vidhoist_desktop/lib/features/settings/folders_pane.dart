import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/choices_data.dart';
import '../../data/folders_data.dart';
import 'simple_panes.dart';

/// The download folder of this computer, with a change and an Explorer
/// button, and whether Explorer opens on a file once it is done.
class FoldersPane extends ConsumerWidget {
  const FoldersPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final notifier = ref.read(folderSettingsProvider.notifier);
    final folders = ref.read(desktopFoldersProvider);
    final download = ref.watch(downloadFolderProvider).valueOrNull;

    Future<void> change(
      String? current,
      Future<void> Function(String) set,
    ) async {
      final picked = await folders.pick(initial: current);
      if (picked != null) await set(picked);
    }

    // Apart enough to read as two buttons: at the narrow gap the pair read
    // as one phrase ("Change… Open in Explorer").
    Widget actions(String? path, Future<void> Function(String) set) => Wrap(
      spacing: VhSpace.xl,
      children: [
        VhLinkButton(
          label: l.desktopChangeFolder,
          onPressed: () => unawaited(change(path, set)),
        ),
        VhLinkButton(
          label: l.desktopOpenInExplorer,
          onPressed: path == null ? null : () => unawaited(folders.open(path)),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingLine(
          title: l.desktopDownloadFolder,
          value: download ?? l.desktopFolderUnavailable,
          hint: l.desktopDownloadFolderHint,
        ),
        actions(download, notifier.setDownload),
        SwitchLine(
          title: l.desktopRevealAfterDownload,
          hint: l.desktopRevealAfterDownloadHint,
          value: ref.watch(revealAfterDownloadProvider),
          onChanged: (on) =>
              unawaited(ref.read(revealAfterDownloadProvider.notifier).set(on)),
        ),
      ],
    );
  }
}
