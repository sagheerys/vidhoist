import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';

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
String updateOutcomeText(MTLocalizations l, UpdateOutcome outcome) {
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
    final p = MTThemeX.of(context).palette;
    final l = context.mtl;
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
        ? MTIcon(
            MTIcons.bolt,
            key: const ValueKey('engine-quiet'),
            size: MTSpace.md,
            color: p.ink3,
          )
        : Container(
            key: const ValueKey('engine-dot'),
            width: MTSpace.xs,
            height: MTSpace.xs,
            decoration: BoxDecoration(color: p.err, shape: BoxShape.circle),
          );
    return MTShortcutTooltip(
      message: status,
      child: Semantics(
        button: true,
        label: '${l.desktopEngine}: $status',
        excludeSemantics: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(MTCorners.desktop.chip),
          onTapUp: (tap) => unawaited(_menu(context, ref, tap.globalPosition)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: MTSpace.sm,
              vertical: MTSpace.xs,
            ),
            child: narrow
                ? Center(child: mark)
                : Row(
                    children: [
                      mark,
                      const SizedBox(width: MTSpace.sm),
                      Expanded(
                        child: Text(
                          // A version reads left to right in either
                          // language.
                          fetching.isEmpty && paths.ready
                              ? mtLtrRun(label)
                              : label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.labelSmall?.copyWith(color: p.ink2),
                        ),
                      ),
                      MTIcon(MTIcons.moreVert, size: MTSpace.md, color: p.ink3),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _menu(BuildContext context, WidgetRef ref, Offset at) async {
    final l = context.mtl;
    final ipv4 = ref.read(engineOptionsProvider).forceIpv4;
    final chosen = await showEmberMenu<String>(context, at, [
      EmberMenuEntry('update', MTIcons.refresh, l.desktopEngineUpdate),
      EmberMenuEntry(
        'ipv4',
        ipv4 ? MTIcons.check : MTIcons.globe,
        l.desktopEngineIpv4,
      ),
      const EmberMenuEntry.divider(),
      EmberMenuEntry('settings', MTIcons.settings, l.desktopEngine),
    ]);
    if (!context.mounted) return;
    switch (chosen) {
      case 'update':
        final outcome = await ref.read(engineUpdateProvider.notifier).update();
        if (outcome != null && context.mounted) {
          showMTNotice(
            context,
            message: updateOutcomeText(context.mtl, outcome),
            kind: outcome.error == null
                ? MTNoticeKind.done
                : MTNoticeKind.failed,
          );
        }
      case 'ipv4':
        await ref.read(engineOptionsProvider.notifier).setForceIpv4(!ipv4);
      case 'settings':
        context.go(EmberSettingsPane.engine.route);
    }
  }
}
