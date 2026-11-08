import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

import 'media_time.dart';
import 'vh_chapter_track.dart';

/// The progress bar with a handle, from the Wahaj reference: a 5px track,
/// an accent-coloured fill and a 15px ink handle. Used in the audio
/// screen and in both portrait and landscape video.
class VhProgressSlider extends StatefulWidget {
  const VhProgressSlider({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
    this.buffered,
    this.dark = false,
    this.showRemaining = true,
    this.marks = const [],
  });

  final Duration position;
  final Duration? duration;
  final Duration? buffered;
  final ValueChanged<Duration> onSeek;

  /// Over dark video: light ink instead of the brown ink.
  final bool dark;

  /// The audio screen shows the remaining time as a negative; video shows
  /// the full duration.
  final bool showRemaining;

  /// Where chapters begin: the track is cut there.
  final List<Duration> marks;

  @override
  State<VhProgressSlider> createState() => _VhProgressSliderState();
}

class _VhProgressSliderState extends State<VhProgressSlider> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final total = widget.duration ?? Duration.zero;
    final maxMs = total.inMilliseconds.toDouble();
    final positionMs = widget.position.inMilliseconds
        .clamp(0, maxMs < 1 ? 1 : maxMs.toInt())
        .toDouble();
    final value = _dragValue ?? positionMs;
    final onDark = widget.dark;
    final trackInactive = onDark
        ? p.miniInk.withValues(alpha: 0.25)
        : p.ink.withValues(alpha: 0.1);
    final timeColor = onDark ? p.miniInkMuted : p.ink3;

    // **Media time runs left to right in every language** (field report
    // 2026-09-25). A timeline is a tape moving past, not a sentence being read:
    // Samsung Music, the system's media notification buttons, the lock screen,
    // car head units, YouTube and Spotify all keep it left to right in Arabic,
    // and Material's bidirectionality guidance says the same. Mirrored, the
    // bar ran leftwards while "next" pointed right, and the buttons read
    // as reversed.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderTheme(
            data: SliderThemeData(
              trackHeight: onDark ? 4 : 5,
              activeTrackColor: p.accent,
              inactiveTrackColor: trackInactive,
              secondaryActiveTrackColor: trackInactive,
              thumbColor: onDark ? p.miniInk : p.ink,
              // A neutral veil under the finger, not an orange halo.
              overlayColor: p.ink.withValues(alpha: vhPressVeil),
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: onDark ? 5.5 : 7.5,
              ),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              trackShape: VhChapterTrackShape([
                if (maxMs >= 1)
                  for (final mark in widget.marks)
                    if (mark.inMilliseconds > 0 && mark.inMilliseconds < maxMs)
                      mark.inMilliseconds / maxMs,
              ]),
            ),
            child: Slider(
              value: maxMs < 1 ? 0 : value.clamp(0, maxMs),
              max: maxMs < 1 ? 1 : maxMs,
              secondaryTrackValue: widget.buffered?.inMilliseconds
                  .clamp(0, maxMs < 1 ? 1 : maxMs.toInt())
                  .toDouble(),
              onChanged: maxMs < 1
                  ? null
                  : (v) => setState(() => _dragValue = v),
              onChangeEnd: (v) {
                widget.onSeek(Duration(milliseconds: v.round()));
                setState(() => _dragValue = null);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: VhSpace.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  vhFormatDuration(Duration(milliseconds: value.round())),
                  style: _timeStyle(context, timeColor),
                ),
                Text(
                  widget.showRemaining
                      ? vhFormatRemaining(
                          Duration(milliseconds: value.round()),
                          widget.duration,
                        )
                      : vhFormatDuration(total),
                  style: _timeStyle(context, timeColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// **It used to ask for `tabularFigures` and never get them**: the style
  /// inherits the Tajawal body font, which has no `tnum` table at all
  /// (binary inspection 2026-09-02), so the feature was silently ignored
  /// and the counter kept dancing. `.tabular` moves it to the heading font,
  /// which genuinely supports it.
  TextStyle _timeStyle(BuildContext context, Color color) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(color: color).tabular;
}
