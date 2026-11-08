import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../data/engine_data.dart';
import '../data/engine_fetch_data.dart';
import '../platform/engine_locator.dart';
import '../router.dart';
import 'context_menu.dart';

/// The name each part goes by, the same in every language.
String enginePartName(EnginePart part) => switch (part) {
  EnginePart.ytDlp => 'yt-dlp',
  EnginePart.ffmpeg => 'ffmpeg',
  EnginePart.deno => 'Deno',
};

/// What an engine update came to, in a sentence.
String updateOutcomeText(VhLocalizations l, UpdateOutcome outcome) {
  if (outcome.updated) {
    return l.desktopEngineUpdated(outcome.version?.toString() ?? '?');
  }
  return outcome.error == null
      ? l.desktopEngineUpToDate
      : l.desktopEngineUpdateFailed;
}

/// The foot of the sidebar: which yt-dlp downloads, and a fetch under way.
/// Its menu updates yt-dlp, turns IPv4 on or off, and opens the engine
/// settings.
///
/// **An engine that works is not announced**: its version beside a quiet
/// mark. Only a missing yt-dlp gets a coloured dot.
class SidebarEngineLine extends ConsumerWidget {
  const SidebarEngineLine({super.key, required this.narrow});

  final bool narrow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = VhThemeX.of(context).palette;
    final l = context.vhl;
    final text = Theme.of(context).textTheme;
    final paths = ref.watch(enginePathsProvider);
    final version = ref.watch(engineVersionProvider).valueOrNull?.ytDlp;
    final fetching = [
      for (final MapEntry(key: part, value: fetch)
          in ref.watch(engineFetchProvider).entries)
        if (fetch.running)
          '${enginePartName(part)} · '
              '${l.desktopEngineFetching(((fetch.fraction ?? 0) * 100).round())}',
    ];
    final label =
        fetching.firstOrNull ??
        (paths.ready
            ? 'yt-dlp${version == null ? '' : ' $version'}'
            : l.desktopEngine);
    final status = [
      if (!paths.ready) l.desktopEngineMissing,
      label,
    ].join(' · ');
    final mark = paths.ready
        ? VhIcon(
            VhIcons.bolt,
            key: const ValueKey('engine-quiet'),
            size: VhSpace.md,
            color: p.ink3,
          )
        : Container(
            key: const ValueKey('engine-dot'),
            width: VhSpace.xs,
            height: VhSpace.xs,
            decoration: BoxDecoration(color: p.err, shape: BoxShape.circle),
          );
    return VhShortcutTooltip(
      message: status,
      child: Semantics(
        button: true,
        label: '${l.desktopEngine}: $status',
        excludeSemantics: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(VhCorners.desktop.chip),
          onTapUp: (tap) => unawaited(_menu(context, ref, tap.globalPosition)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: VhSpace.sm,
              vertical: VhSpace.xs,
            ),
            child: narrow
                ? Center(child: mark)
                : Row(
                    children: [
                      mark,
                      const SizedBox(width: VhSpace.sm),
                      Expanded(
                        child: Text(
                          // A version reads left to right in either
                          // language.
                          fetching.isEmpty && paths.ready
                              ? vhLtrRun(label)
                              : label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.labelSmall?.copyWith(color: p.ink2),
                        ),
                      ),
                      VhIcon(VhIcons.moreVert, size: VhSpace.md, color: p.ink3),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _menu(BuildContext context, WidgetRef ref, Offset at) async {
    final l = context.vhl;
    final ipv4 = ref.read(engineOptionsProvider).forceIpv4;
    final chosen = await showEmberMenu<String>(context, at, [
      DesktopMenuEntry('update', VhIcons.refresh, l.desktopEngineUpdate),
      DesktopMenuEntry(
        'ipv4',
        ipv4 ? VhIcons.check : VhIcons.globe,
        l.desktopEngineIpv4,
      ),
      const DesktopMenuEntry.divider(),
      DesktopMenuEntry('settings', VhIcons.settings, l.desktopEngine),
    ]);
    if (!context.mounted) return;
    switch (chosen) {
      case 'update':
        final outcome = await ref.read(engineUpdateProvider.notifier).update();
        if (outcome != null && context.mounted) {
          showVhNotice(
            context,
            message: updateOutcomeText(context.vhl, outcome),
            kind: outcome.error == null
                ? VhNoticeKind.done
                : VhNoticeKind.failed,
          );
        }
      case 'ipv4':
        await ref.read(engineOptionsProvider.notifier).setForceIpv4(!ipv4);
      case 'settings':
        context.go(DesktopSettingsPane.engine.route);
    }
  }
}
