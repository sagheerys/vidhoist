import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../router.dart';
import 'about_pane.dart';
import 'appearance_pane.dart';
import 'backup_pane.dart';
import 'channels_pane.dart';
import 'cookies_pane.dart';
import 'engine_pane.dart';
import 'folders_pane.dart';
import 'keep_in_view.dart';
import 'logs_pane.dart';
import 'pane_entry.dart';
import 'phone_pane.dart';
import 'simple_panes.dart';
import 'transcripts_pane.dart';
import 'updates_pane.dart';

/// Settings in two panes, the tablet's layout: the sections on one side,
/// the chosen one open on the other. Each section has its own address
/// ([DesktopSettingsPane.route]), so a message can open the page that fixes
/// it.
class SettingsPlace extends ConsumerWidget {
  const SettingsPlace({super.key, required this.pane});

  final DesktopSettingsPane pane;

  static const double listWidth = 260;

  /// How far a section rises as it comes in, as a share of its height:
  /// a few points, glimpsed rather than watched.
  static const double _rise = 0.012;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = VhThemeX.of(context).palette;
    final l = context.vhl;
    final text = Theme.of(context).textTheme;
    final groups = [
      (
        l.desktopEngine,
        [
          DesktopSettingsPane.engine,
          DesktopSettingsPane.cookies,
          DesktopSettingsPane.subscriptions,
        ],
      ),
      (
        l.settingsGroupApp,
        const [
          DesktopSettingsPane.downloads,
          DesktopSettingsPane.folders,
          DesktopSettingsPane.appearance,
          DesktopSettingsPane.desktop,
          DesktopSettingsPane.transcripts,
        ],
      ),
      (
        l.settingsGroupData,
        [
          DesktopSettingsPane.backup,
          DesktopSettingsPane.updates,
          DesktopSettingsPane.logs,
          DesktopSettingsPane.about,
        ],
      ),
    ];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: listWidth,
          // Built whole, not lazily: a list of under twenty entries costs
          // nothing, and an entry below the fold that was never built could
          // never be brought into view.
          child: KeepChosenInView(
            chosen: pane,
            isChosen: (w) => w is PaneEntry && w.selected,
            padding: const EdgeInsets.all(VhSpace.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (title, panes) in groups) ...[
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      VhSpace.sm,
                      VhSpace.md,
                      VhSpace.sm,
                      VhSpace.xs,
                    ),
                    child: Text(
                      title,
                      style: text.labelMedium?.copyWith(color: p.ink3),
                    ),
                  ),
                  for (final entry in panes)
                    PaneEntry(
                      key: ValueKey(entry),
                      pane: entry,
                      selected: entry == pane,
                      onTap: () => context.go(entry.route),
                    ),
                ],
              ],
            ),
          ),
        ),
        VerticalDivider(width: 1, color: p.line),
        Expanded(
          // **The section changes, the page does not**: the new one rises a
          // little as it fades in, the old one fades out quickly, and the
          // list beside stays still.
          child: AnimatedSwitcher(
            duration: vhMotionDuration(context, VhMotion.medium),
            reverseDuration: vhMotionDuration(context, VhMotion.fast),
            switchInCurve: VhMotion.entrance,
            switchOutCurve: VhMotion.exit,
            transitionBuilder: (child, motion) => FadeTransition(
              opacity: motion,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, _rise),
                  end: Offset.zero,
                ).animate(motion),
                child: child,
              ),
            ),
            layoutBuilder: (current, previous) => Stack(
              alignment: AlignmentDirectional.topStart,
              children: [...previous, ?current],
            ),
            child: ListView(
              key: ValueKey(pane),
              padding: const EdgeInsets.all(VhSpace.xl),
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: ConstrainedBox(
                    // The appearance pane holds a preview beside its
                    // choices, so it is given the room for both.
                    constraints: BoxConstraints(
                      maxWidth: pane == DesktopSettingsPane.appearance
                          ? AppearancePane.maxWidth
                          : VhBreakpoint.readable,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          paneTitle(l, pane),
                          style: text.headlineSmall?.copyWith(color: p.ink),
                        ),
                        const SizedBox(height: VhSpace.lg),
                        switch (pane) {
                          DesktopSettingsPane.downloads =>
                            const DownloadsPane(),
                          DesktopSettingsPane.folders => const FoldersPane(),
                          DesktopSettingsPane.desktop => const DesktopPane(),
                          DesktopSettingsPane.phone => const PhonePane(),
                          DesktopSettingsPane.backup => const BackupPane(),
                          DesktopSettingsPane.cookies => const CookiesPane(),
                          DesktopSettingsPane.subscriptions =>
                            const SubscriptionsPane(),
                          DesktopSettingsPane.appearance =>
                            const AppearancePane(),
                          DesktopSettingsPane.transcripts =>
                            const TranscriptsPane(),
                          DesktopSettingsPane.updates => const UpdatesPane(),
                          DesktopSettingsPane.logs => const LogsPane(),
                          DesktopSettingsPane.about => const AboutPane(),
                          DesktopSettingsPane.engine => const EnginePane(),
                        },
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String paneTitle(VhLocalizations l, DesktopSettingsPane pane) => switch (pane) {
  DesktopSettingsPane.subscriptions => l.subscriptions,
  DesktopSettingsPane.cookies => l.cookies,
  DesktopSettingsPane.downloads => l.settingsDownloads,
  DesktopSettingsPane.folders => l.desktopFolders,
  DesktopSettingsPane.appearance => l.appearanceAndLanguage,
  DesktopSettingsPane.desktop => l.desktopDesktopSection,
  DesktopSettingsPane.phone => l.pcLinkTitle,
  DesktopSettingsPane.transcripts => l.settingsTranscripts,
  DesktopSettingsPane.backup => l.settingsBackup,
  DesktopSettingsPane.updates => l.updates,
  DesktopSettingsPane.logs => l.diagnosticLogs,
  DesktopSettingsPane.about => l.about,
  DesktopSettingsPane.engine => l.desktopEngine,
};
