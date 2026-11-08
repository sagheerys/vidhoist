import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/lists_data.dart';
import '../../shell/shell_metrics.dart';
import 'list_actions.dart';
import '../../shell/desktop_dialog.dart';

/// Every tag with its count, to rename or delete. Renaming onto a tag that
/// already exists merges the two; deleting takes the tag off the clips and
/// leaves the clips.
Future<void> showManageTagsDialog(BuildContext context) =>
    showEmberDialog<void>(
      context: context,
      builder: (_) => const _ManageTags(),
    );

class _ManageTags extends ConsumerWidget {
  const _ManageTags();

  Future<void> _rename(BuildContext context, WidgetRef ref, String tag) async {
    final l = context.vhl;
    final name = (await promptVhText(
      context,
      title: l.renameTag,
      confirmLabel: l.rename,
      initialValue: tag,
      hintText: l.newTagHint,
      maxLength: VhConstants.maxTagLength,
    ))?.trim();
    if (name == null || name.isEmpty || name == tag) return;
    await ref.read(listActionsProvider).renameTag(tag, name);
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String tag) async {
    final l = context.vhl;
    final sure = await showVhConfirm(
      context,
      title: l.deleteTag,
      message: l.deleteTagConfirm(vhName(tag)),
      confirmLabel: l.delete,
      cancelLabel: l.cancel,
      destructive: true,
    );
    if (sure) await ref.read(listActionsProvider).deleteTag(tag);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final counts = ref.watch(tagCountsProvider).valueOrNull ?? const {};
    final tags = counts.keys.toList()..sort();
    return AlertDialog(
      title: Text(l.manageTags),
      content: SizedBox(
        width: DesktopShellSize.smallDialog,
        child: tags.isEmpty
            ? Text(
                l.desktopNoTags,
                style: text.bodySmall?.copyWith(color: p.ink3),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final tag in tags)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: VhSpace.xxs,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                vhName('# $tag'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: text.bodySmall?.copyWith(color: p.ink),
                              ),
                            ),
                            Text(
                              '${counts[tag]}',
                              style: text.labelSmall?.tabular.copyWith(
                                color: p.ink3,
                              ),
                            ),
                            const SizedBox(width: VhSpace.md),
                            VhLinkButton(
                              label: l.rename,
                              onPressed: () =>
                                  unawaited(_rename(context, ref, tag)),
                            ),
                            const SizedBox(width: VhSpace.sm),
                            VhLinkButton(
                              label: l.delete,
                              danger: true,
                              onPressed: () =>
                                  unawaited(_delete(context, ref, tag)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.done),
        ),
      ],
    );
  }
}
