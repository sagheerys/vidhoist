import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart' show UpdateOutcome;
import 'package:vh_ui/vh_ui.dart';

import '../../data/engine_data.dart';
import '../../data/engine_fetch_data.dart';
import '../../platform/engine_fetcher.dart';
import '../../platform/engine_locator.dart';
import '../../shell/engine_line.dart';
import 'simple_panes.dart';

/// Why a fetch failed, in a sentence the person can act on.
String fetchFailureText(VhLocalizations l, FetchFailure failure) =>
    switch (failure) {
      FetchFailure.network || FetchFailure.unpack => l.desktopEngineFetchFailed,
      FetchFailure.corrupt => l.desktopEngineFetchCorrupt,
      FetchFailure.inUse => l.desktopEngineFetchInUse,
    };

/// What a repair came to, in a sentence (`EngineRepairNotifier`).
String repairOutcomeText(VhLocalizations l, UpdateOutcome outcome) =>
    switch (outcome) {
      UpdateOutcome(error: engineRepairBusy) => l.engineRepairBusy,
      UpdateOutcome(error: null) => l.engineRepaired(
        outcome.version?.toString() ?? '?',
      ),
      _ => l.engineRepairPartly,
    };

/// **The engine, part by part**: yt-dlp (shipped), and ffmpeg and Deno
/// (fetched on first need, or here); yt-dlp's update; IPv4; and the switch
/// that shows the features 1.0 holds back.
class EnginePane extends ConsumerWidget {
  const EnginePane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final paths = ref.watch(enginePathsProvider);
    final versions = ref.watch(engineVersionProvider).valueOrNull;
    final fetches = ref.watch(engineFetchProvider);
    final update = ref.watch(engineUpdateProvider);
    final repair = ref.watch(engineRepairProvider);
    final options = ref.watch(engineOptionsProvider);

    String? found(EnginePart part) => switch (part) {
      EnginePart.ytDlp => versions?.ytDlp?.toString(),
      EnginePart.ffmpeg => versions?.ffmpeg,
      EnginePart.deno => versions?.jsRuntime,
    };

    Widget partLine(EnginePart part, String hint) {
      final fetch = fetches[part];
      final here = paths.has(part);
      final value = switch (fetch) {
        PartFetch(running: true, :final fraction) => l.desktopEngineFetching(
          ((fraction ?? 0) * 100).round(),
        ),
        PartFetch(:final failure?) => fetchFailureText(l, failure),
        _ when here => switch (found(part)) {
          final version? => vhLtrRun(l.desktopEngineVersion(version)),
          null => null,
        },
        _ when part == EnginePart.ytDlp => l.desktopEngineMissing,
        _ => l.desktopEngineOnFirstUse,
      };
      return SettingLine(
        title: enginePartName(part),
        hint: hint,
        value: value,
        trailing: here || (fetch?.running ?? false)
            ? null
            : VhLinkButton(
                label: l.desktopEngineFetch,
                icon: VhIcons.download,
                onPressed: () => unawaited(
                  ref.read(engineFetchProvider.notifier).fetch(part),
                ),
              ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        partLine(EnginePart.ytDlp, l.desktopEngineYtDlpHint),
        partLine(EnginePart.ffmpeg, l.desktopEngineFfmpegHint),
        partLine(EnginePart.deno, l.desktopEngineDenoHint),
        SettingLine(
          title: l.desktopEngineUpdate,
          hint: l.desktopEngineUpdateHint,
          value: switch (update) {
            AsyncData(:final value?) => updateOutcomeText(l, value),
            _ => null,
          },
          trailing: VhLinkButton(
            label: update.isLoading
                ? l.desktopEngineUpdating
                : l.desktopEngineUpdate,
            icon: VhIcons.refresh,
            onPressed: update.isLoading || !paths.ready
                ? null
                : () => unawaited(
                    ref.read(engineUpdateProvider.notifier).update(),
                  ),
          ),
        ),
        // "Repair" beside "update": for downloads failing across sites when
        // an update alone did not help (plan item R5).
        SettingLine(
          title: l.engineRepair,
          hint: l.engineRepairHint,
          value: switch (repair) {
            AsyncData(:final value?) => repairOutcomeText(l, value),
            _ => null,
          },
          trailing: VhLinkButton(
            label: repair.isLoading ? l.engineRepairing : l.engineRepair,
            icon: VhIcons.shield,
            onPressed: repair.isLoading || update.isLoading || !paths.ready
                ? null
                : () => unawaited(
                    ref.read(engineRepairProvider.notifier).repair(),
                  ),
          ),
        ),
        SwitchLine(
          title: l.desktopEngineIpv4,
          hint: l.desktopEngineIpv4Hint,
          value: options.forceIpv4,
          onChanged: (on) => unawaited(
            ref.read(engineOptionsProvider.notifier).setForceIpv4(on),
          ),
        ),
      ],
    );
  }
}
