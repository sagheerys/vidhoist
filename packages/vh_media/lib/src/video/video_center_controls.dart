import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import 'vh_video_session.dart';

/// Screen centre: ten seconds back and forward around a play button in the
/// accent colour.
class VhVideoCenterControls extends StatelessWidget {
  const VhVideoCenterControls({super.key, required this.session});

  final VhVideoSession session;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l10n = context.vhl;
    // **Pinned left to right, like the timeline under them.** Media time
    // runs left to right in every language, so buttons that followed the
    // interface direction would read as reversed (see VhProgressSlider).
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Seek(
            icon: VhIcons.back10,
            label: l10n.seekBackward10,
            onTap: () => session.seekBy(const Duration(seconds: -10)),
          ),
          const SizedBox(width: VhSpace.xxl),
          Material(
            color: p.accent.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: session.playPause,
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 58,
                height: 58,
                child: VhIconSwap(
                  icon: session.isPlaying ? VhIcons.pause : VhIcons.playFill,
                  size: 26,
                  color: p.onAccent,
                ),
              ),
            ),
          ),
          const SizedBox(width: VhSpace.xxl),
          _Seek(
            icon: VhIcons.forward10,
            label: l10n.seekForward10,
            onTap: () => session.seekBy(const Duration(seconds: 10)),
          ),
        ],
      ),
    );
  }
}

class _Seek extends StatelessWidget {
  const _Seek({required this.icon, required this.label, required this.onTap});

  final VhIconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onTap,
    tooltip: label,
    icon: VhIcon(icon, size: 28, color: VhPalette.serverCardInk),
  );
}
