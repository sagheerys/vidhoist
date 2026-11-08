import 'package:flutter/material.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import 'panel/details_view.dart';
import 'panel/queue_view.dart';
import 'panel/transcript_view.dart';
import 'shell_metrics.dart';
import 'panel/panel_tabs.dart';

/// The panel's three faces.
enum PanelTab { transcript, upNext, details }

/// The side panel: the transcript following playback, what comes next,
/// and the clip's details.
class DesktopRightPanel extends StatelessWidget {
  const DesktopRightPanel({
    super.key,
    required this.tab,
    required this.onTab,
    required this.state,
    required this.player,
  });

  final PanelTab tab;
  final ValueChanged<PanelTab> onTab;
  final VhPlayerState state;
  final VhPlayer player;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l = context.vhl;
    final current = state.current;
    return Container(
      width: DesktopShellSize.panel,
      decoration: BoxDecoration(
        color: p.bg,
        border: BorderDirectional(
          start: BorderSide(
            color: p.line,
            width: VhThemeX.of(context).hairline,
          ),
        ),
      ),
      padding: const EdgeInsets.all(VhSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PanelTabs<PanelTab>(
            faces: [
              (PanelTab.transcript, l.transcript),
              (PanelTab.upNext, l.upNext),
              (PanelTab.details, l.details),
            ],
            chosen: tab,
            onChoose: onTab,
          ),
          const SizedBox(height: VhSpace.lg),
          if (current == null)
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: VhEmptyFrame(
                    title: l.desktopNothingPlaying,
                    message: l.desktopNothingPlayingHint,
                  ),
                ),
              ),
            )
          else ...[
            Builder(
              builder: (context) {
                // Its own direction, the interface's side: a Latin title
                // in the Arabic panel sat on the far side otherwise.
                final (direction, align) = vhForeignLine(
                  context,
                  current.title,
                );
                return Text(
                  current.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textDirection: direction,
                  textAlign: align,
                  style: Theme.of(context).textTheme.titleSmall,
                );
              },
            ),
            const SizedBox(height: VhSpace.md),
            Expanded(
              // One face gives way to the next with a short cross-fade and a
              // rise of a few points, not a cut.
              child: AnimatedSwitcher(
                duration: vhMotionDuration(context, VhMotion.fast),
                switchInCurve: VhMotion.entrance,
                switchOutCurve: VhMotion.exit,
                transitionBuilder: (child, motion) => FadeTransition(
                  opacity: motion,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 0.01),
                      end: Offset.zero,
                    ).animate(motion),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey(tab),
                  child: switch (tab) {
                    PanelTab.transcript => TranscriptView(
                      item: current,
                      player: player,
                    ),
                    PanelTab.upNext => QueueView(state: state, player: player),
                    PanelTab.details => DetailsView(item: current),
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
