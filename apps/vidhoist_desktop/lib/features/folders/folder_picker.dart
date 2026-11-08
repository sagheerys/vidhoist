import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/downloads_data.dart';
import '../../shell/shell_metrics.dart';
import 'folder_widgets.dart';
import '../../shell/desktop_dialog.dart';

/// The server folder line of a form: what is chosen, and a click to choose
/// again. Shared by adding and following.
class FolderLine extends StatelessWidget {
  const FolderLine({
    super.key,
    required this.value,
    required this.onPick,
    this.label,
  });

  final String value;
  final VoidCallback onPick;

  /// Defaults to "Folder".
  final String? label;

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return Material(
      color: p.cardAlt,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VhCorners.desktop.field),
      ),
      clipBehavior: Clip.antiAlias,
      // A button to a screen reader, not two lines of text: it opens the
      // list of folders.
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: onPick,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: VhSpace.md,
              vertical: VhSpace.sm,
            ),
            child: Row(
              children: [
                VhIcon(VhIcons.folder, size: VhSpace.lg, color: p.ink2),
                const SizedBox(width: VhSpace.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label ?? l.folder,
                        style: text.labelSmall?.copyWith(color: p.ink3),
                      ),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(color: p.ink),
                      ),
                    ],
                  ),
                ),
                VhIcon(VhIcons.chevronDown, size: VhSpace.lg, color: p.ink3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// What [FolderLine] shows for [choice].
String folderLabel(VhLocalizations l, FolderChoice choice) => choice.channelName
    ? l.channelNameFolder
    : choice.isTop
    ? l.noFolder
    : vhName(choice.path);

/// Picks a folder below the download folder: the top, the channel's own
/// name when following, any folder the library uses, or a new one, nested
/// if typed so (`Ai/Lessons`). Null when dismissed.
Future<FolderChoice?> showFolderPicker(
  BuildContext context, {
  required FolderChoice current,
  bool offerTop = true,
  bool offerChannelName = false,
}) => showEmberDialog<FolderChoice>(
  context: context,
  builder: (_) => _FolderPicker(
    current: current,
    offerTop: offerTop,
    offerChannelName: offerChannelName,
  ),
);

class _FolderPicker extends ConsumerWidget {
  const _FolderPicker({
    required this.current,
    required this.offerTop,
    required this.offerChannelName,
  });

  final FolderChoice current;
  final bool offerTop;
  final bool offerChannelName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final folders = pickableFolders(ref.watch(libraryFolderPathsProvider));

    Widget option({
      required VhIconData icon,
      required String title,
      String? subtitle,
      required bool selected,
      required VoidCallback onTap,
      int depth = 0,
    }) => Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(VhCorners.desktop.chip),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: VhSpace.sm + VhSpace.lg * depth,
            end: VhSpace.sm,
            top: VhSpace.xs,
            bottom: VhSpace.xs,
          ),
          child: Row(
            children: [
              VhIcon(
                icon,
                size: VhSpace.lg,
                color: selected ? p.accent : p.ink2,
              ),
              const SizedBox(width: VhSpace.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(
                        color: p.ink,
                        fontWeight: selected ? FontWeight.w700 : null,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: text.labelSmall?.copyWith(color: p.ink3),
                      ),
                  ],
                ),
              ),
              if (selected)
                VhIcon(VhIcons.check, size: VhSpace.lg, color: p.accent),
            ],
          ),
        ),
      ),
    );

    Future<void> makeNew() async {
      final made = await askNewFolder(context, current.path);
      if (made != null && context.mounted) {
        Navigator.of(context).pop(FolderChoice(made));
      }
    }

    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(l.chooseFolder)),
          // What folders are and what the server needs, behind a button
          // that waits, grey, for whoever wants it.
          FolderHelp(
            label: l.helpAboutField,
            onTap: () => unawaited(
              showFolderHelp(context, l.chooseFolder, l.foldersHelp),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: DesktopShellSize.smallDialog,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (offerTop)
                      option(
                        icon: VhIcons.library,
                        title: l.noFolder,
                        subtitle: l.noFolderHint,
                        selected: current.isTop,
                        onTap: () =>
                            Navigator.of(context).pop(FolderChoice.top),
                      ),
                    if (offerChannelName)
                      option(
                        icon: VhIcons.subscriptions,
                        title: l.channelNameFolder,
                        selected: current.channelName,
                        onTap: () =>
                            Navigator.of(context).pop(FolderChoice.channel),
                      ),
                    for (final path in folders)
                      option(
                        icon: VhIcons.folder,
                        title: vhName(path.split('/').last),
                        selected: !current.channelName && current.path == path,
                        depth: path.split('/').length - 1,
                        onTap: () =>
                            Navigator.of(context).pop(FolderChoice(path)),
                      ),
                    option(
                      icon: VhIcons.plus,
                      title: l.newFolder,
                      selected: false,
                      onTap: () => unawaited(makeNew()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
      ],
    );
  }
}
