import 'package:flutter/material.dart';
import 'package:vh_core/vh_core.dart' show ClipRange;
import 'package:vh_ui/vh_ui.dart';

import 'clip_time_field.dart';

/// **Only a stretch of the video**, from one time to another: a minute of
/// a two-hour talk, without the two hours on the disk. Off each time the
/// phone's sheet or the computer's add dialog opens: a stretch is a
/// choice for one link, not a habit.
///
/// The times are typed or stepped, not dragged: a typed `1:30` is exact.
/// Once yt-dlp has read the video's [length], it is shown, the arrows stop
/// there, an end typed past it before it was known comes back to it, and
/// a time typed past it afterwards is wrong at once: a stretch past the
/// end fails in yt-dlp with no reason a person could act on.
class ClipFields extends StatelessWidget {
  const ClipFields({
    super.key,
    required this.on,
    required this.onChanged,
    required this.from,
    required this.to,
    this.showErrors = false,
    this.checkbox = false,
    this.length,
    this.readingLength = false,
    this.lengthUnknown = false,
  });

  final bool on;
  final ValueChanged<bool> onChanged;
  final TextEditingController from;
  final TextEditingController to;

  /// Set once a download was asked for with times that do not read: a
  /// field half typed is not yet wrong.
  final bool showErrors;

  /// A checkbox rather than a switch, as the computer's add dialog draws
  /// its other choice for one link, "fetch its transcript first".
  final bool checkbox;

  /// How long the video is, once read; null before, or when it cannot be.
  final Duration? length;

  /// The length is being read.
  final bool readingLength;

  /// It was read and the site gave none (Instagram, a live stream): said,
  /// so a time past the end is not taken for one checked.
  final bool lengthUnknown;

  /// The stretch typed, or null while the times do not read or run past
  /// the video's [length].
  static ClipRange? read(
    TextEditingController from,
    TextEditingController to, {
    Duration? length,
  }) {
    final range = ClipRange.tryParse(from.text, to.text);
    if (range == null || length == null) return range;
    return range.within(length) == range ? range : null;
  }

  /// **An end stepped with no start starts the stretch at 0:00** (asked
  /// 2026-11-18): the arrows already count the end from the beginning,
  /// and the start left empty was refused at Start.
  void _startAtZero() {
    if (from.text.trim().isNotEmpty) return;
    from.text = ClipRange.clock(Duration.zero);
  }

  // Rebuilt as the times are typed: a mistake shown stays only while it
  // is still a mistake.
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([from, to]),
    builder: (context, _) => _build(context),
  );

  Widget _build(BuildContext context) {
    final l10n = context.vhl;
    final text = Theme.of(context).textTheme;
    final p = VhThemeX.of(context).palette;
    final start = ClipRange.parseTime(from.text);
    final end = ClipRange.parseTime(to.text);
    final length = this.length;
    final pastEnd = length == null
        ? null
        : l10n.clipPastEnd(ClipRange.clock(length));
    final fromError = start != null && length != null && start >= length
        ? pastEnd
        : showErrors && start == null
        ? l10n.clipTimeHint
        : null;
    final toError = end != null && length != null && end > length
        ? pastEnd
        : !showErrors
        ? null
        : end == null
        ? l10n.clipTimeHint
        : start != null && end <= start
        ? l10n.clipEndAfterStart
        : null;
    final told = readingLength
        ? l10n.clipLengthReading
        : length != null
        ? l10n.clipLength(ClipRange.clock(length))
        : lengthUnknown
        ? l10n.clipLengthUnknown
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (checkbox)
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: on,
            onChanged: (on) => onChanged(on ?? false),
            title: Text(
              l10n.clipOnly,
              style: text.bodySmall?.copyWith(color: p.ink),
            ),
            subtitle: Text(
              l10n.clipOnlyHelp,
              style: text.labelSmall?.copyWith(color: p.ink3),
            ),
          )
        else
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const VhIcon(VhIcons.clock, size: 20),
            title: Text(l10n.clipOnly, style: text.bodyMedium),
            subtitle: Text(l10n.clipOnlyHelp, style: text.bodySmall),
            value: on,
            onChanged: onChanged,
          ),
        if (on) ...[
          const SizedBox(height: VhSpace.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipTimeField(
                  controller: from,
                  label: l10n.clipFrom,
                  error: fromError,
                  max: length,
                ),
              ),
              const SizedBox(width: VhSpace.sm),
              Expanded(
                child: ClipTimeField(
                  controller: to,
                  label: l10n.clipTo,
                  error: toError,
                  startAt: () => ClipRange.parseTime(from.text),
                  max: length,
                  fitsMax: true,
                  onStepped: _startAtZero,
                ),
              ),
            ],
          ),
          if (told != null)
            Padding(
              padding: const EdgeInsets.only(top: VhSpace.xs),
              child: Text(
                told,
                key: const ValueKey('clipLength'),
                style: text.labelSmall?.copyWith(color: p.ink3),
              ),
            ),
        ],
      ],
    );
  }
}
