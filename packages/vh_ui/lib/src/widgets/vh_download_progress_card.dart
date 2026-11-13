import 'package:flutter/material.dart';

import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import 'vh_done_motion.dart';
import 'vh_polish.dart';

import '../icons/vh_icon.dart';
import '../icons/vh_icon_data.dart';
import '../icons/vh_icons.dart';
import '../kit/vh_progress.dart';

/// A live download card: a soft accent ground, a progress bar and a
/// cancel. The status text, whether a phase or an error, arrives already
/// translated from the app.
class VhDownloadProgressCard extends StatelessWidget {
  const VhDownloadProgressCard({
    super.key,
    required this.title,
    required this.statusText,
    this.progress,
    this.isError = false,
    this.onCancel,
    this.thumbnail,
    this.detail,
    this.waiting = false,
    this.done = false,
    this.action,
  });

  /// A second button before the cancel, such as pause or resume.
  final VhDownloadCardAction? action;

  final String title;
  final String statusText;

  /// 0 to 1, or null while indeterminate during the add and wait phases.
  final double? progress;
  final bool isError;
  final VoidCallback? onCancel;
  final Widget? thumbnail;

  /// A figure beside the percentage, such as the download speed.
  final String? detail;

  /// Waiting its turn: a still, dashed line rather than a moving bar, which
  /// would claim work is being done.
  final bool waiting;

  /// Just finished: the bar full and a check drawn where the cancel was.
  final bool done;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    // **Colour for the data alone**: the bar and its
    // figure in the accent, a failure's sentence in the error colour. The
    // card itself stays neutral; tinted and framed in the accent, every
    // download looked like an alert, and a failure wore three marks.
    final tint = isError ? p.err : p.accent;
    final softInk = isError ? p.err : p.ink3;
    final hairline = VhThemeX.of(context).hairline;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: VhSpace.md + 1,
        vertical: VhSpace.md,
      ),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(VhRadius.card),
        border: Border.all(color: p.line, width: hairline),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: p.cardAlt,
              borderRadius: BorderRadius.circular(VhRadius.thumb),
            ),
            child:
                thumbnail ??
                VhIcon(
                  isError ? VhIcons.alert : VhIcons.download,
                  size: 22,
                  color: p.ink3,
                ),
          ),
          const SizedBox(width: VhSpace.md - 1),
          Expanded(
            // **The bar and the number glide to each new reading** (field
            // report 2026-10-15) instead of jumping to it, so a figure
            // that arrives in steps still reads as a count.
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                end: done ? 1 : progress?.clamp(0, 1).toDouble() ?? 0,
              ),
              duration: vhMotionDuration(
                context,
                const Duration(milliseconds: 450),
              ),
              curve: Curves.easeOut,
              builder: (context, shown, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: isError
                            ? VhExpandableText(
                                statusText,
                                style: text.bodySmall!.copyWith(color: softInk),
                              )
                            : Text(
                                statusText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: text.bodySmall!.copyWith(color: softInk),
                              ),
                      ),
                      // **The percentage follows every phase that knows its
                      // progress**: an element of its own rather than part
                      // of one phase's string, so every phase shows its
                      // number without a separate string per phase.
                      if (!isError && detail != null) ...[
                        const SizedBox(width: VhSpace.sm),
                        // It yields before the percentage does: on the
                        // narrowest phone the speed ran 10 px past the card.
                        Flexible(
                          child: Text(
                            detail!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall!.copyWith(color: p.ink3),
                          ),
                        ),
                      ],
                      if (!isError && progress != null) ...[
                        const SizedBox(width: VhSpace.sm),
                        Text(
                          '${(shown * 100).round()}%',
                          style: text.bodySmall!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: tint,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!isError && waiting) ...[
                    const SizedBox(height: VhSpace.xs + 1),
                    _DashedLine(color: p.line2),
                  ] else if (!isError && progress == null) ...[
                    // Under way with no measure yet: the film strip, not
                    // Material's sliding bar.
                    const SizedBox(height: VhSpace.xs + 1),
                    const VhFilmStrip(),
                  ] else if (!isError) ...[
                    const SizedBox(height: VhSpace.xs + 1),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: shown,
                        minHeight: 5,
                        backgroundColor: p.line,
                        valueColor: AlwaysStoppedAnimation(tint),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (done) ...[
            const SizedBox(width: VhSpace.sm),
            SizedBox.square(
              dimension: 32,
              child: Center(child: VhDrawnCheck(color: p.ok)),
            ),
          ] else ...[
            if (action case final a?) ...[
              const SizedBox(width: VhSpace.sm),
              Tooltip(
                message: a.tooltip,
                child: _CardButton(icon: a.icon, onTap: a.onTap),
              ),
            ],
            if (onCancel != null) ...[
              const SizedBox(width: VhSpace.sm),
              _CardButton(icon: VhIcons.close, onTap: onCancel!),
            ],
          ],
        ],
      ),
    );
  }
}

/// The still line of a task waiting its turn.
/// A button the app adds to a download card: what it shows, what a long
/// press or a screen reader says, and what it does.
class VhDownloadCardAction {
  const VhDownloadCardAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final VhIconData icon;
  final String tooltip;
  final VoidCallback onTap;
}

/// The card's small square buttons, cancel and the app's own.
class _CardButton extends StatelessWidget {
  const _CardButton({required this.icon, required this.onTap});

  final VhIconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(VhRadius.chip),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: p.card.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(VhRadius.chip),
        ),
        child: VhIcon(icon, size: 16, color: p.ink3),
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 5,
    width: double.infinity,
    child: CustomPaint(painter: _Dashes(color)),
  );
}

class _Dashes extends CustomPainter {
  const _Dashes(this.color);

  final Color color;

  static const double _dash = 6;
  static const double _gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final y = size.height / 2;
    for (var x = 1.0; x < size.width; x += _dash + _gap) {
      canvas.drawLine(
        Offset(x, y),
        Offset((x + _dash).clamp(0, size.width - 1), y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_Dashes old) => old.color != color;
}

/// One line that opens to its whole text on a tap, and closes on another.
///
/// **For a failure's reason**: cut to one line, yt-dlp's error read
/// "ERROR: [youtube] dQw4w9WgXcQ: Sign in to…" and the part that said what
/// was wrong was never seen.
class VhExpandableText extends StatefulWidget {
  const VhExpandableText(
    this.text, {
    super.key,
    this.style,
    this.collapsedLines = 1,
  });

  final String text;
  final TextStyle? style;
  final int collapsedLines;

  @override
  State<VhExpandableText> createState() => _VhExpandableTextState();
}

class _VhExpandableTextState extends State<VhExpandableText> {
  bool _open = false;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    expanded: _open,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _open = !_open),
      // A pointer says it can be clicked, on the computer.
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedSize(
          duration: vhMotionDuration(
            context,
            const Duration(milliseconds: 180),
          ),
          alignment: AlignmentDirectional.topStart,
          child: Text(
            widget.text,
            maxLines: _open ? null : widget.collapsedLines,
            overflow: _open ? TextOverflow.visible : TextOverflow.ellipsis,
            style: widget.style,
          ),
        ),
      ),
    ),
  );
}
