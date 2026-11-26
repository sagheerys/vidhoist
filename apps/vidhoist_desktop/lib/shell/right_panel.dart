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

/// The side panel: a clip's transcript and details, and what comes next.
///
/// **On a clip's page it is about that clip**, playing or not, so a clip's
/// own words can be read without playing it and a page never stands
/// beside another clip's transcript. Everywhere else it follows the
/// player. What comes next is always the player's queue.
class DesktopRightPanel extends StatelessWidget {
  const DesktopRightPanel({
    super.key,
    required this.tab,
    required this.onTab,
    required this.state,
    required this.player,
    this.page,
  });

  final PanelTab tab;
  final ValueChanged<PanelTab> onTab;
  final VhPlayerState state;
  final VhPlayer player;

  /// The clip whose page is open, or null off a clip's page.
  final PlaylistItem? page;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l = context.vhl;
    final current = state.current;
    final subject = page ?? current;
    final playing =
        subject != null && subject.canonicalUrl == current?.canonicalUrl;
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
          if (subject == null)
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
            // The title names the clip only where the page does not: on a
            // clip's page it was said there already, a third time with the
            // player bar's.
            if (page == null) ...[
              _Title(title: subject.title),
              const SizedBox(height: VhSpace.md),
            ],
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
                      item: subject,
                      player: player,
                      follows: playing,
                    ),
                    PanelTab.upNext => QueueView(state: state, player: player),
                    PanelTab.details => DetailsView(
                      item: subject,
                      playing: playing,
                    ),
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

class _Title extends StatelessWidget {
  const _Title({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // Its own direction, the interface's side: a Latin title in the Arabic
    // panel sat on the far side otherwise.
    final (direction, align) = vhForeignLine(context, title);
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textDirection: direction,
      textAlign: align,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }
}
