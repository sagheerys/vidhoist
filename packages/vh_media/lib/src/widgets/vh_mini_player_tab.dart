import 'dart:async';
import 'dart:math' as math;

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import '../playback/audio_handler.dart';
import 'vh_mini_player.dart';
import 'vh_up_next_list.dart';

/// The mini player folded into a small tab at the screen's edge, for a
/// screen with no room for the bar (settings): something is playing, and
/// stopping it or skipping is one tap away instead of a trip back to the
/// library.
///
/// **At the edge where lines start** (the right in Arabic, the left in
/// English): a settings row keeps its switch at the other end, so the tab
/// covers at most a row's leading icon, never a control. It is tapped,
/// never dragged, since a swipe from the screen's edge is Android's back
/// gesture.
///
/// A tap opens the very bar the other screens show; it folds back after
/// [foldAfter] untouched, or at any touch outside it, which includes the
/// start of a scroll. It steps aside while the keyboard is open, and when
/// nothing plays it is not there at all.
class VhMiniPlayerTab extends StatefulWidget {
  const VhMiniPlayerTab({
    super.key,
    required this.handler,
    required this.onOpen,
    this.artwork,
    this.visible = true,
    this.foldAfter = const Duration(seconds: 4),
  });

  final VhAudioHandler handler;
  final VoidCallback onOpen;
  final VhArtworkBuilder? artwork;
  final bool visible;
  final Duration foldAfter;

  @override
  State<VhMiniPlayerTab> createState() => _VhMiniPlayerTabState();
}

class _VhMiniPlayerTabState extends State<VhMiniPlayerTab> {
  bool _open = false;
  Timer? _fold;

  void _setOpen(bool open) {
    _fold?.cancel();
    if (open) _fold = Timer(widget.foldAfter, () => _setOpen(false));
    if (mounted && open != _open) setState(() => _open = open);
  }

  /// A touch inside the open bar counts as use: the countdown starts over.
  void _touched() {
    if (_open) _setOpen(true);
  }

  @override
  void didUpdateWidget(VhMiniPlayerTab old) {
    super.didUpdateWidget(old);
    // Left and come back: it comes back folded.
    if (!widget.visible && _open) _setOpen(false);
  }

  @override
  void dispose() {
    _fold?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typing = MediaQuery.viewInsetsOf(context).bottom > 0;
    return StreamBuilder<MediaItem?>(
      stream: widget.handler.mediaItem,
      builder: (context, snapshot) {
        final item = widget.visible && !typing ? snapshot.data : null;
        final child = switch (item) {
          null => const SizedBox.shrink(key: ValueKey('tab-none')),
          final item when _open => _OpenBar(
            key: const ValueKey('tab-open'),
            onOutside: () => _setOpen(false),
            onTouched: _touched,
            child: VhMiniPlayerBar(
              handler: widget.handler,
              onOpen: () {
                _setOpen(false);
                widget.onOpen();
              },
              artwork: widget.artwork,
              title: item.title,
              subtitle: item.artist,
              current: widget.handler.currentItem,
            ),
          ),
          final item => _Handle(
            key: const ValueKey('tab-folded'),
            handler: widget.handler,
            title: item.title,
            onTap: () => _setOpen(true),
          ),
        };
        return AnimatedSwitcher(
          duration: vhMotionDuration(context, VhMotion.page),
          reverseDuration: vhMotionDuration(context, VhMotion.fast),
          switchInCurve: VhMotion.entrance,
          switchOutCurve: VhMotion.exit,
          layoutBuilder: (current, previous) => Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [...previous, ?current],
          ),
          transitionBuilder: (child, animation) =>
              _FromEdge(animation: animation, child: child),
          child: child,
        );
      },
    );
  }
}

/// In and out through the edge it is attached to, whichever side that is.
class _FromEdge extends StatelessWidget {
  const _FromEdge({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final towardEdge = Directionality.of(context) == TextDirection.rtl
        ? 1.0
        : -1.0;
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween(
          begin: Offset(towardEdge, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}

class _OpenBar extends StatelessWidget {
  const _OpenBar({
    super.key,
    required this.onOutside,
    required this.onTouched,
    required this.child,
  });

  final VoidCallback onOutside;
  final VoidCallback onTouched;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = math.min(
      MediaQuery.sizeOf(context).width - VhSpace.md * 2,
      420.0,
    );
    return TapRegion(
      onTapOutside: (_) => onOutside(),
      child: Listener(
        onPointerDown: (_) => onTouched(),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: VhSpace.md),
          child: SizedBox(width: width, child: child),
        ),
      ),
    );
  }
}

/// The folded tab: a short rounded strip out of the edge, with bars that
/// move while something plays and rest while it is paused. The strip is
/// narrow; what answers a tap is wider, a finger's width.
class _Handle extends StatelessWidget {
  const _Handle({
    super.key,
    required this.handler,
    required this.title,
    required this.onTap,
  });

  static const visibleWidth = 18.0;
  static const height = 56.0;

  final VhAudioHandler handler;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return Semantics(
      button: true,
      label: context.vhl.miniPlayerTab(title),
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: height,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              width: visibleWidth,
              height: height,
              decoration: BoxDecoration(
                color: p.miniBg,
                borderRadius: const BorderRadiusDirectional.horizontal(
                  end: Radius.circular(VhRadius.thumb + 4),
                ).resolve(Directionality.of(context)),
                boxShadow: VhShadow.mini(p),
              ),
              child: StreamBuilder<PlaybackState>(
                stream: handler.playbackState,
                builder: (context, snapshot) => _Bars(
                  playing: snapshot.data?.playing ?? false,
                  color: p.accent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Three small level bars: they move while playing, unless the system
/// asks for no motion, and lie still at rest.
class _Bars extends StatefulWidget {
  const _Bars({required this.playing, required this.color});

  final bool playing;
  final Color color;

  @override
  State<_Bars> createState() => _BarsState();
}

class _BarsState extends State<_Bars> with SingleTickerProviderStateMixin {
  late final _beat = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  void _follow() {
    final still = MediaQuery.disableAnimationsOf(context);
    if (widget.playing && !still) {
      if (!_beat.isAnimating) _beat.repeat();
    } else {
      _beat.stop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _follow();
  }

  @override
  void didUpdateWidget(_Bars old) {
    super.didUpdateWidget(old);
    _follow();
  }

  @override
  void dispose() {
    _beat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _beat,
    builder: (context, _) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++) ...[
          if (i > 0) const SizedBox(width: 1.5),
          Container(
            width: 2.5,
            height: widget.playing
                ? 6 +
                      8 *
                          (0.5 +
                              0.5 *
                                  math.sin((_beat.value + i / 3) * 2 * math.pi))
                : 5,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ],
    ),
  );
}
