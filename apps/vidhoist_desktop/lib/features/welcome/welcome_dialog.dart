import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/appearance_data.dart';
import '../../data/engine_data.dart';
import '../../data/engine_fetch_data.dart';
import '../../data/folders_data.dart';
import '../../data/hints_data.dart';
import '../../platform/engine_locator.dart';
import '../../shell/desktop_dialog.dart';
import '../../shell/engine_line.dart';
import '../../shell/shell_metrics.dart';
import '../settings/appearance_pane.dart';
import '../settings/engine_pane.dart';
import '../settings/simple_panes.dart';

/// **The first start**: where downloads go, the language, and the engine, with ffmpeg and Deno offered at once
/// rather than at the first download.
Future<void> showWelcomeDialog(BuildContext context) {
  // The session's one interruption: no tip after it.
  ProviderScope.containerOf(context).read(hintsProvider.notifier).interrupted();
  return showDesktopDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const WelcomeDialog(),
  );
}

class WelcomeDialog extends ConsumerWidget {
  const WelcomeDialog({super.key});

  static const _helpers = [EnginePart.ffmpeg, EnginePart.deno];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final folder = ref.watch(downloadFolderProvider).valueOrNull;
    final look = ref.watch(appearanceProvider);
    final appearance = ref.read(appearanceProvider.notifier);
    final paths = ref.watch(enginePathsProvider);
    final version = ref.watch(engineVersionProvider).valueOrNull?.ytDlp;
    final fetches = ref.watch(engineFetchProvider);
    final missing = [
      for (final part in _helpers)
        if (!paths.has(part)) part,
    ];
    final busy = missing.any((part) => fetches[part]?.running ?? false);

    String? fetchLine(EnginePart part) => switch (fetches[part]) {
      PartFetch(running: true, :final fraction) =>
        '${enginePartName(part)} · '
            '${l.desktopEngineFetching(((fraction ?? 0) * 100).round())}',
      PartFetch(:final failure?) =>
        '${enginePartName(part)} · ${fetchFailureText(l, failure)}',
      _ => null,
    };

    return AlertDialog(
      title: Text(l.desktopWelcomeTitle),
      content: SizedBox(
        width: DesktopShellSize.addDialog,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.desktopWelcomeMessage,
                style: text.bodyMedium?.copyWith(color: p.ink2),
              ),
              const SizedBox(height: VhSpace.md),
              SettingLine(
                title: l.desktopDownloadFolder,
                value: folder,
                trailing: VhLinkButton(
                  label: l.desktopChangeFolder,
                  icon: VhIcons.folder,
                  onPressed: () => unawaited(_pickFolder(ref, folder)),
                ),
              ),
              ChoiceGroup(
                title: l.language,
                children: [
                  DesktopSegments(
                    items: [
                      DesktopSegment(
                        label: l.languageSystem,
                        selected: look.locale == null,
                        onTap: () => appearance.setLocale(null),
                      ),
                      for (final code in appearanceLocales)
                        DesktopSegment(
                          label: vhLanguageName(code),
                          selected: look.locale == code,
                          onTap: () => appearance.setLocale(code),
                        ),
                    ],
                  ),
                ],
              ),
              SettingLine(
                title: l.desktopEngine,
                value: paths.ready
                    ? vhLtrRun('yt-dlp${version == null ? '' : ' $version'}')
                    : l.desktopEngineMissing,
              ),
              if (missing.isNotEmpty) ...[
                const SizedBox(height: VhSpace.sm),
                Text(
                  l.desktopWelcomeHelpers,
                  style: text.labelSmall?.copyWith(color: p.ink3),
                ),
                for (final part in missing)
                  if (fetchLine(part) case final line?)
                    Padding(
                      padding: const EdgeInsets.only(top: VhSpace.xxs),
                      child: Text(
                        line,
                        style: text.labelSmall?.copyWith(color: p.ink2),
                      ),
                    ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        if (missing.isNotEmpty)
          TextButton(
            onPressed: busy ? null : () => unawaited(_fetch(ref, missing)),
            child: Text(l.desktopWelcomeFetchNow),
          ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.desktopWelcomeStart),
        ),
      ],
    );
  }

  Future<void> _pickFolder(WidgetRef ref, String? current) async {
    final picked = await ref
        .read(desktopFoldersProvider)
        .pick(initial: current);
    if (picked != null) {
      await ref.read(folderSettingsProvider.notifier).setDownload(picked);
    }
  }

  /// One after the other: two large downloads at once would only share the
  /// same line.
  Future<void> _fetch(WidgetRef ref, List<EnginePart> parts) async {
    final fetch = ref.read(engineFetchProvider.notifier);
    for (final part in parts) {
      await fetch.fetch(part);
    }
  }
}
