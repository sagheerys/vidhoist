import 'package:flutter/material.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'clip_time_field.dart';

/// **Only a stretch of the video**, from one time to another: a minute of
/// a two-hour talk, without the two hours on the phone. Off each time the
/// sheet opens: a stretch is a choice for one link, not a habit.
///
/// The times are typed or stepped, not dragged: the sheet does not know a
/// video's length before yt-dlp has read it, and a typed `1:30` is exact.
class ClipFields extends StatelessWidget {
  const ClipFields({
    super.key,
    required this.on,
    required this.onChanged,
    required this.from,
    required this.to,
    this.showErrors = false,
  });

  final bool on;
  final ValueChanged<bool> onChanged;
  final TextEditingController from;
  final TextEditingController to;

  /// Set once a download was asked for with times that do not read: a
  /// field half typed is not yet wrong.
  final bool showErrors;

  /// The stretch typed, or null while the times do not read.
  static ClipRange? read(
    TextEditingController from,
    TextEditingController to,
  ) => ClipRange.tryParse(from.text, to.text);

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
    final start = ClipRange.parseTime(from.text);
    final end = ClipRange.parseTime(to.text);
    final fromError = showErrors && start == null ? l10n.clipTimeHint : null;
    final toError = !showErrors
        ? null
        : end == null
        ? l10n.clipTimeHint
        : start != null && end <= start
        ? l10n.clipEndAfterStart
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                ),
              ),
              const SizedBox(width: VhSpace.sm),
              Expanded(
                child: ClipTimeField(
                  controller: to,
                  label: l10n.clipTo,
                  error: toError,
                  startAt: () => ClipRange.parseTime(from.text),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
