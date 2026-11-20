import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import '../di.dart';
import '../router.dart';
import '../features/clip/clip_state.dart';
import '../features/library/artwork.dart';
import 'shell_state.dart';
import 'video_surface.dart';
import 'window_controls.dart';

part 'mini_window_parts.dart';

/// The small card's two sizes: sound alone, and a picture at 16:9. The
/// picture is where it starts: its edges stretch it up to half the screen.
abstract final class DesktopMiniSize {
  static const audio = Size(360, 96);
  static const video = Size(360, 203);
}

/// The clip whose page was open on the clip playing when the card took the
/// window's place; null when another page was.
String? _miniFrom;

/// Ctrl+M and the player bar's button: the small card above every window,
/// sized for what plays, or the full window again.
///
/// **Back from the card, the page goes with the player**, as it does in
/// the window: the card stands in for the whole window, the clip's page
/// included, so a next pressed on the card went unheard and the window came
/// back on the clip that had ended, its cover still as a frozen picture.
void toggleMiniWindow(WidgetRef ref, GoRouter router) {
  final controls = ref.read(windowControlsProvider);
  final current = ref.read(playerProvider).state.current;
  if (controls.mini.value) {
    controls.setMini(null);
    final from = _miniFrom;
    _miniFrom = null;
    if (from != null && current != null && current.canonicalUrl != from) {
      router.go(DesktopRoutes.item(current.canonicalUrl));
    }
    return;
  }
  final path = router.routerDelegate.currentConfiguration.uri.path;
  _miniFrom =
      current != null && path == DesktopRoutes.item(current.canonicalUrl)
      ? current.canonicalUrl
      : null;
  final picture = miniShowsPicture(
    ref.read(playerProvider).state,
    audioOnly: ref.read(audioOnlyProvider),
  );
  controls.setMini(
    picture ? DesktopMiniSize.video : DesktopMiniSize.audio,
    stretch: picture,
  );
}

/// Whether the card shows a picture: a video playing with its picture on.
bool miniShowsPicture(VhPlayerState state, {required bool audioOnly}) {
  final item = state.current;
  return item != null && !item.isAudio && !audioOnly;
}

/// **The small card above every window** (Ctrl+M): what plays, play and
/// next, and a hairline of progress, in the mini player's colours (dark by
/// day, the card's by night). A video shows its picture. The card is
/// carried by any press on it; a double click, Ctrl+M or Esc brings the
/// full window back.
class DesktopMiniWindow extends ConsumerStatefulWidget {
  const DesktopMiniWindow({
    super.key,
    required this.player,
    required this.controls,
    required this.onRestore,
  });

  final VhPlayer player;
  final WindowControls controls;
  final VoidCallback onRestore;

  @override
  ConsumerState<DesktopMiniWindow> createState() => _DesktopMiniWindowState();
}

class _DesktopMiniWindowState extends ConsumerState<DesktopMiniWindow> {
  /// The size last asked of the window, so it is asked again only when
  /// what plays turns from sound to picture or back.
  Size? _asked;

  void _fit(Size size) {
    if (size == _asked) return;
    _asked = size;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.controls.mini.value) {
        widget.controls.setMini(size, stretch: size == DesktopMiniSize.video);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioOnly = ref.watch(audioOnlyProvider);
    return StreamBuilder<VhPlayerState>(
      stream: widget.player.states,
      initialData: widget.player.state,
      builder: (context, snap) {
        final state = snap.data ?? widget.player.state;
        final picture = miniShowsPicture(state, audioOnly: audioOnly);
        _fit(picture ? DesktopMiniSize.video : DesktopMiniSize.audio);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: widget.onRestore,
          onPanStart: (_) => widget.controls.startDragging(),
          child: picture
              ? _Picture(state: state, widget: widget)
              : _Sound(state: state, widget: widget),
        );
      },
    );
  }
}

class _Sound extends ConsumerWidget {
  const _Sound({required this.state, required this.widget});

  final VhPlayerState state;
  final DesktopMiniWindow widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = VhThemeX.of(context).palette;
    final item = state.current;
    final side = DesktopMiniSize.audio.height - VhSpace.xl;
    return ColoredBox(
      color: p.miniBg,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: VhSpace.sm),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      VhCorners.desktop.thumb,
                    ),
                    child: SizedBox.square(
                      dimension: side,
                      child:
                          artworkFor(
                            ref,
                            context,
                            item?.artworkUrl,
                            width: side,
                            height: side,
                          ) ??
                          ColoredBox(
                            color: p.miniInk.withValues(alpha: 0.12),
                            child: Center(
                              child: VhIcon(
                                VhIcons.headphones,
                                size: VhSpace.xl,
                                color: p.miniInkMuted,
                              ),
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(width: VhSpace.sm),
                  Expanded(child: _Titles(item: item)),
                  _Buttons(state: state, widget: widget, ink: p.miniInk),
                ],
              ),
            ),
          ),
          _Progress(player: widget.player, state: state),
        ],
      ),
    );
  }
}

class _Picture extends ConsumerWidget {
  const _Picture({required this.state, required this.widget});

  final VhPlayerState state;
  final DesktopMiniWindow widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      color: VhPalette.fullscreenScrim,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ref.watch(videoSurfaceProvider).build(context),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The buttons on the picture's own shade, as the clip
                // page's do.
                DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, VhPalette.fullscreenScrim],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: VhSpace.sm,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _Titles(item: state.current, onPicture: true),
                        ),
                        _Buttons(
                          state: state,
                          widget: widget,
                          ink: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                _Progress(player: widget.player, state: state),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
