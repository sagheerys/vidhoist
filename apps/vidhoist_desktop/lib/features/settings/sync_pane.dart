import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/folders_data.dart';
import '../../data/sync_data.dart';
import 'simple_panes.dart';
import '../../shell/folded_text.dart';

/// A device as the user knows it: the kind, and the short part of its name
/// that tells two phones apart.
String syncDeviceName(VhLocalizations l, String id) {
  final dash = id.indexOf('-');
  final tail = dash < 0 ? id : id.substring(dash + 1);
  return id.startsWith('phone')
      ? l.desktopSyncPhone(tail)
      : l.desktopSyncComputer(tail);
}

/// **Sync through a folder of the user's own** (off until a folder is
/// chosen): the folder, this computer's name in it, when each other device
/// last wrote, and forgetting one.
class SyncPane extends ConsumerWidget {
  const SyncPane({super.key});

  Future<void> _choose(WidgetRef ref) async {
    final settings = ref.read(syncSettingsProvider).valueOrNull;
    final picked = await ref
        .read(desktopFoldersProvider)
        .pick(initial: settings?.folder);
    if (picked == null) return;
    await ref.read(syncSettingsProvider.notifier).choose(picked);
    await ref.read(desktopSyncProvider).run();
  }

  Future<void> _forget(
    BuildContext context,
    WidgetRef ref,
    SyncDevice device,
  ) async {
    final l = context.vhl;
    final sure = await showVhConfirm(
      context,
      title: l.desktopSyncForget,
      message: l.desktopSyncForgetBody(syncDeviceName(l, device.id)),
      confirmLabel: l.desktopSyncForget,
      cancelLabel: l.cancel,
      destructive: true,
    );
    if (sure) await ref.read(desktopSyncProvider).forget(device);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final settings = ref.watch(syncSettingsProvider).valueOrNull;
    final report = ref.watch(syncReportProvider);
    final note = text.labelSmall?.copyWith(color: p.ink3);
    final on = settings?.on ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FoldedText(
          l.desktopSyncHint,
          style: text.bodyMedium?.copyWith(color: p.ink2),
        ),
        const SizedBox(height: VhSpace.sm),
        SettingLine(
          title: l.desktopSyncFolder,
          value: on ? settings!.folder : null,
          hint: on ? null : l.desktopSyncOff,
          trailing: Wrap(
            spacing: VhSpace.sm,
            runSpacing: VhSpace.xs,
            alignment: WrapAlignment.end,
            children: [
              VhLinkButton(
                label: l.desktopSyncChoose,
                icon: VhIcons.folder,
                onPressed: () => unawaited(_choose(ref)),
              ),
              if (on)
                VhLinkButton(
                  label: l.desktopSyncTurnOff,
                  onPressed: () => unawaited(
                    ref.read(syncSettingsProvider.notifier).turnOff(),
                  ),
                ),
            ],
          ),
        ),
        if (on) ...[
          SettingLine(
            title: l.desktopSyncThisComputer(
              syncDeviceName(l, settings!.deviceId!),
            ),
            hint: switch (report) {
              null => null,
              SyncReport(failed: true) => l.desktopSyncFailed,
              final r => l.desktopSyncLast(vhTimeAgo(context, r.at)),
            },
          ),
          if (report?.cameBack ?? false)
            Text(
              l.desktopSyncCameBack,
              style: text.bodySmall?.copyWith(color: p.accentInk),
            ),
          if (report != null && !report.failed && report.devices.isEmpty)
            Text(l.desktopSyncNoOthers, style: note),
          for (final device in report?.devices ?? const <SyncDevice>[])
            SettingLine(
              title: l.desktopSyncFrom(
                syncDeviceName(l, device.id),
                vhTimeAgo(
                  context,
                  DateTime.fromMillisecondsSinceEpoch(
                    device.snapshot.writtenAt,
                  ),
                ),
              ),
              hint: device.isQuietAt(DateTime.now()) ? l.syncDeviceQuiet : null,
              trailing: VhLinkButton(
                label: l.desktopSyncForget,
                icon: VhIcons.trash,
                onPressed: () => unawaited(_forget(context, ref, device)),
              ),
            ),
        ],
        const SizedBox(height: VhSpace.md),
        Text(l.desktopSyncGuide, style: note),
        const SizedBox(height: VhSpace.xs),
        Text(l.desktopSyncNotBackup, style: note),
      ],
    );
  }
}
