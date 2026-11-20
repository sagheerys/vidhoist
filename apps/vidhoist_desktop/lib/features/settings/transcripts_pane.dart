import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/backup_data.dart';
import '../../data/subtitles_data.dart';
import '../../data/transcripts_data.dart';
import '../../router.dart';
import '../clip/caption_controls.dart';
import 'simple_panes.dart';
import '../../shell/folded_text.dart';

/// How many clips have their words here, and the room they take; counted
/// again each time settings open, as transcripts arrive in the meantime.
final transcriptsSummaryProvider = FutureProvider.autoDispose<(int, int)>((
  ref,
) async {
  final store = ref.watch(transcriptStoreProvider);
  if (store == null) return (0, 0);
  final index = await ref.watch(transcriptIndexProvider.future);
  return (index.length, await store.sizeBytes());
});

/// The words kept for each clip: how many, and removing them all. Moving
/// them to and from a phone is under Backup alone: two imports, one here
/// and one there, left which to use a guess.
class TranscriptsPane extends ConsumerWidget {
  const TranscriptsPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final summary = ref.watch(transcriptsSummaryProvider).valueOrNull;
    final none = summary == null || summary.$1 == 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FoldedText(
          l.desktopTranscriptsHelp,
          style: text.bodyMedium?.copyWith(color: p.ink2),
        ),
        const SizedBox(height: VhSpace.md),
        ValueListenableBuilder<bool>(
          valueListenable: ref.watch(desktopSubtitlesProvider).shown,
          builder: (context, on, _) => SwitchLine(
            title: l.subtitlesShow,
            hint: l.subtitlesShowHelp,
            value: on,
            onChanged: (v) =>
                ref.read(desktopSubtitlesProvider).shown.value = v,
          ),
        ),
        const CaptionStyleChoices(),
        // The button on the line of what it deletes, at its end, as on
        // every other line: under it, it sat alone on the rule.
        SettingLine(
          title: l.transcriptsClips(summary?.$1 ?? 0),
          value: summary == null || none ? null : vhFormatSize(summary.$2),
          trailing: VhRowButton(
            label: l.transcriptsDeleteAll,
            danger: true,
            icon: VhIcons.trash,
            onPressed: none ? null : () => unawaited(_deleteAll(context, ref)),
          ),
        ),
        SettingLine(
          title: l.desktopTranscriptsMove,
          hint: l.desktopTranscriptsMoveHint,
          trailing: VhLinkButton(
            label: l.desktopOpenBackup,
            icon: VhIcons.backup,
            onPressed: () => context.go(DesktopSettingsPane.backup.route),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteAll(BuildContext context, WidgetRef ref) async {
    final l = context.vhl;
    final sure = await showVhConfirm(
      context,
      title: l.transcriptsDeleteTitle,
      message: l.desktopTranscriptsDeleteBody,
      confirmLabel: l.transcriptsDeleteAll,
      cancelLabel: l.cancel,
      destructive: true,
    );
    if (!sure) return;
    await ref.read(transcriptStoreProvider)?.clear();
    await ref.read(backupsProvider).forgetTranscripts();
    ref
      ..invalidate(transcriptIndexProvider)
      ..invalidate(transcriptForProvider)
      ..invalidate(transcriptsSummaryProvider);
  }
}
