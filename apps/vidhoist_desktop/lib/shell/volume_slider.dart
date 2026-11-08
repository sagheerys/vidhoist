import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../data/volume.dart';
import 'desktop_slider.dart';

/// The player bar's volume: the speaker and a short slider. ↑ and ↓ move
/// the same level, so either way it is kept between runs.
class DesktopVolumeSlider extends ConsumerWidget {
  const DesktopVolumeSlider({super.key, this.onPicture = false});

  /// Light on the picture's dark shade, in full screen.
  final bool onPicture;

  static const double width = 96;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = VhThemeX.of(context).palette;
    final l = context.vhl;
    final level = ref.watch(volumeProvider);
    return VhShortcutTooltip(
      message: l.desktopVolume,
      shortcut: '↑ ↓',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VhIcon(
            VhIcons.volume,
            size: VhDensity.desktop.icon,
            color: onPicture
                ? (level == 0 ? Colors.white54 : Colors.white)
                : (level == 0 ? p.ink3 : p.ink2),
          ),
          // Low to high from left to right, as the seek bar runs, in
          // either language.
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: width,
              child: DesktopSlider(
                value: level,
                max: 100,
                label: l.desktopVolume,
                describe: (v) => l.desktopVolumeLevel(v.round()),
                step: VolumeLevel.step,
                inactive: onPicture ? Colors.white24 : null,
                onChanged: (v) =>
                    unawaited(ref.read(volumeProvider.notifier).set(v)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
