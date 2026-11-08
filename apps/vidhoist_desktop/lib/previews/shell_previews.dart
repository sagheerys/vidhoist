import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_transcripts/vh_transcripts.dart';
import 'package:vh_ui/vh_ui.dart';

import '../data/transcripts_data.dart';
import '../router.dart';
import '../shell/player_bar.dart';
import '../shell/right_panel.dart';
import '../shell/shell_metrics.dart';
import '../shell/sidebar.dart';
import '../shell/sidebar_items.dart';
import '../shell/title_bar.dart';
import '../shell/window_controls.dart';
import 'still_player.dart';

// The shell's parts on their own, for the widget previewer
// (`flutter widget-preview start` in this folder, or the IDE's preview
// tab). Each comes in day and night, English and Arabic, as the app ships.
// Only the drawn widgets: nothing from `platform/`, which needs Windows,
// while the previewer runs in a browser.

/// Day and night, in both reading directions.
final class DesktopPreview extends MultiPreview {
  const DesktopPreview(this.name, {this.size});

  final String name;
  final Size? size;

  @override
  List<Preview> get previews => [
    for (final (wrapper, language) in [
      (inEnglish, 'English'),
      (inArabic, 'Arabic'),
    ])
      for (final brightness in Brightness.values)
        Preview(
          group: 'Desktop shell',
          name: '$name - $language, ${brightness.name}',
          size: size,
          wrapper: wrapper,
          brightness: brightness,
        ),
  ];
}

Widget inEnglish(Widget child) => _InDesktop(const Locale('en'), child);
Widget inArabic(Widget child) => _InDesktop(const Locale('ar'), child);

/// What the app puts around its pages: the desktop theme for the
/// previewer's brightness, the language, and a transcript to show.
class _InDesktop extends StatelessWidget {
  const _InDesktop(this.locale, this.child);

  final Locale locale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    return VhDesktopApp(
      child: ProviderScope(
        overrides: [
          transcriptForProvider.overrideWith((ref, key) async => _transcript),
        ],
        child: Theme(
          data: vhDesktopTheme(VhVariant.desktop, brightness),
          child: Localizations(
            locale: locale,
            delegates: VhLocalizations.localizationsDelegates,
            child: Builder(
              builder: (context) => Material(
                color: VhThemeX.of(context).palette.bg,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _url = 'https://youtu.be/aaaaaaaaaaa';

final _queue = [
  const PlaylistItem(
    canonicalUrl: _url,
    title: 'Homelab Hour - Ep. 12: snapshots are not backups',
    uploader: 'Homelab Hour',
    serverFilename: 'Homelab Hour [aaaaaaaaaaa].mp4',
    duration: Duration(minutes: 41, seconds: 5),
  ),
  const PlaylistItem(
    canonicalUrl: 'https://youtu.be/bbbbbbbbbbb',
    title: 'ساعة المختبر المنزلي: النسخ الاحتياطي في جهاز آخر',
    uploader: 'قناة المختبر',
    isAudio: true,
    duration: Duration(minutes: 12),
  ),
  const PlaylistItem(
    canonicalUrl: 'https://www.tiktok.com/@a/video/1',
    title: 'Tidepools at Dawn',
    uploader: 'Field Notes',
    duration: Duration(seconds: 48),
  ),
];

final _transcript = Transcript(
  canonicalUrl: _url,
  language: 'en',
  source: 'sidecar',
  fetchedAt: DateTime(2026, 10, 24),
  segments: [
    for (final (s, text) in [
      (0, 'First rule: a snapshot on the same pool is not a backup.'),
      (20, 'If the pool dies, the snapshots go with it.'),
      (40, 'So we replicate the snapshots to a second box every night.'),
      (60, 'And once a month, one copy leaves the house.'),
    ])
      TranscriptSegment(
        start: Duration(seconds: s),
        end: Duration(seconds: s + 19),
        text: text,
      ),
  ],
);

final _playing = VhPlayerState(
  items: _queue,
  ordered: _queue,
  index: 0,
  playing: true,
  phase: MediaPlaybackState.ready,
  duration: const Duration(minutes: 41, seconds: 5),
);

void _ignore([Object? _]) {}

@DesktopPreview('Title bar', size: Size(1280, DesktopShellSize.titleBar))
Widget titleBarPreview() => DesktopTitleBar(
  controls: InertWindowControls(),
  startWidth: DesktopShellSize.sidebarWide,
  sidebarToggle: SidebarToggle(narrow: false, onTap: _ignore),
);

@DesktopPreview('Sidebar, wide', size: Size(DesktopShellSize.sidebarWide, 640))
Widget sidebarPreview() =>
    DesktopSidebar(narrow: false, current: DesktopPlace.library, onGo: _ignore);

@DesktopPreview(
  'Sidebar, narrow',
  size: Size(DesktopShellSize.sidebarNarrow, 640),
)
Widget sidebarNarrowPreview() => DesktopSidebar(
  narrow: true,
  current: DesktopPlace.favorites,
  onGo: _ignore,
);

@DesktopPreview(
  'Player bar, playing',
  size: Size(1280, DesktopShellSize.playerBar),
)
Widget playerBarPreview() => DesktopPlayerBar(
  player: StillPlayer(_playing, const Duration(minutes: 7, seconds: 12)),
  onShowQueue: _ignore,
  onOpen: _ignore,
  onMini: _ignore,
  audioOnly: false,
  listening: false,
  onListen: _ignore,
);

@DesktopPreview(
  'Player bar, idle',
  size: Size(1280, DesktopShellSize.playerBar),
)
Widget playerBarIdlePreview() => DesktopPlayerBar(
  player: StillPlayer(),
  onShowQueue: _ignore,
  onOpen: _ignore,
  onMini: _ignore,
  audioOnly: false,
  listening: false,
  onListen: _ignore,
);

Widget _panel(PanelTab tab, VhPlayerState state) => DesktopRightPanel(
  tab: tab,
  onTab: _ignore,
  state: state,
  player: StillPlayer(state, const Duration(seconds: 25)),
);

@DesktopPreview('Panel, transcript', size: Size(DesktopShellSize.panel, 640))
Widget panelTranscriptPreview() => _panel(PanelTab.transcript, _playing);

@DesktopPreview('Panel, up next', size: Size(DesktopShellSize.panel, 640))
Widget panelUpNextPreview() => _panel(PanelTab.upNext, _playing);

@DesktopPreview('Panel, details', size: Size(DesktopShellSize.panel, 640))
Widget panelDetailsPreview() => _panel(PanelTab.details, _playing);

@DesktopPreview(
  'Panel, nothing playing',
  size: Size(DesktopShellSize.panel, 640),
)
Widget panelIdlePreview() => _panel(PanelTab.transcript, const VhPlayerState());

/// Every preview above, for the test that keeps them building.
final List<Widget Function()> shellPreviews = [
  titleBarPreview,
  sidebarPreview,
  sidebarNarrowPreview,
  playerBarPreview,
  playerBarIdlePreview,
  panelTranscriptPreview,
  panelUpNextPreview,
  panelDetailsPreview,
  panelIdlePreview,
];
