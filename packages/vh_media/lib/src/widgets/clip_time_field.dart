import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

/// **Digits in, a time out**, the way a microwave reads them: `1` is
/// `0:01`, `130` is `1:30`, `10305` is `1:03:05`.
///
/// Samsung's number pad has no colon (seen on the owner's phone), and the
/// full keyboard hides it a page away; the colon is therefore never
/// needed. Typed anyway, as on a computer, it changes nothing.
class ClipTimeFormatter extends TextInputFormatter {
  const ClipTimeFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = ClipRange.westernDigits(newValue.text)
        .replaceAll(RegExp(r'\D'), '')
        .replaceFirst(RegExp('^0+'), '');
    // Past 99:59:59 is no video; the last good time stays.
    if (digits.length > 6) return oldValue;
    final text = format(digits);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  /// The last two digits are seconds, the two before them minutes, and
  /// what is left hours.
  static String format(String digits) {
    if (digits.isEmpty) return '';
    final padded = digits.padLeft(3, '0');
    final seconds = padded.substring(padded.length - 2);
    final rest = padded.substring(0, padded.length - 2);
    if (rest.length <= 2) return '${int.parse(rest)}:$seconds';
    final minutes = rest.substring(rest.length - 2);
    final hours = rest.substring(0, rest.length - 2);
    return '${int.parse(hours)}:$minutes:$seconds';
  }
}

/// One of the two times: typed by hand, or moved a minute at a time with
/// the arrows beside it (held, they keep moving) or the keyboard's ↑ ↓.
class ClipTimeField extends StatefulWidget {
  const ClipTimeField({
    super.key,
    required this.controller,
    required this.label,
    this.error,
    this.startAt,
    this.max,
    this.fitsMax = false,
    this.onStepped,
  });

  final TextEditingController controller;
  final String label;
  final String? error;

  /// Where the arrows start while the field is empty: "to" starts from
  /// "from", so the first press lands a minute after the start.
  final Duration? Function()? startAt;

  /// The video's length, once known: the arrows go no further.
  final Duration? max;

  /// A time already past [max] when it arrives comes back to it: the end
  /// field's, since a start at the very end is no stretch at all and stays
  /// wrong, saying so.
  final bool fitsMax;

  /// An arrow moved the time: the end field fills an empty start with it.
  final VoidCallback? onStepped;

  @override
  State<ClipTimeField> createState() => _ClipTimeFieldState();
}

class _ClipTimeFieldState extends State<ClipTimeField>
    with SingleTickerProviderStateMixin {
  /// **An arrow pressed at the edge shakes the time and reddens it**
  /// (asked 2026-11-17): held at the video's end the number simply stopped
  /// changing, and nothing said why.
  late final _bump = AnimationController(vsync: this, duration: _bumpTime);

  static const _bumpTime = Duration(milliseconds: 520);

  @override
  void dispose() {
    _bump.dispose();
    super.dispose();
  }

  // The length is read while the times can already be typed; one typed
  // past it is brought back as an arrow held there would be, after the
  // frame, since the field above rebuilds on the change.
  @override
  void didUpdateWidget(ClipTimeField old) {
    super.didUpdateWidget(old);
    if (widget.fitsMax && old.max == null && widget.max != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fit());
    }
  }

  void _fit() {
    final max = widget.max;
    final now = ClipRange.parseTime(widget.controller.text);
    if (!mounted || max == null || now == null || now <= max) return;
    _bump.forward(from: 0);
    _show(max);
  }

  void _step(int minutes) {
    final now =
        ClipRange.parseTime(widget.controller.text) ??
        widget.startAt?.call() ??
        Duration.zero;
    var next = now + Duration(minutes: minutes);
    var held = false;
    if (next.isNegative) (next, held) = (Duration.zero, true);
    if (widget.max case final max? when next > max) (next, held) = (max, true);
    if (held) _bump.forward(from: 0);
    _show(next);
    widget.onStepped?.call();
  }

  void _show(Duration time) {
    final text = ClipRange.clock(time);
    widget.controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final still = MediaQuery.disableAnimationsOf(context);
    final red = VhThemeX.of(context).palette.err;
    // ↑ and ↓ on a computer's keyboard step as the arrows do; the field
    // is one line, so they had nothing else to do there.
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowUp): () => _step(1),
        const SingleActivator(LogicalKeyboardKey.arrowDown): () => _step(-1),
      },
      child: AnimatedBuilder(
        animation: _bump,
        builder: (context, field) {
          final t = _bump.value;
          final bumping = _bump.isAnimating;
          // Three swings that fade out; with reduced motion, the colour
          // alone says it.
          final dx = still || !bumping
              ? 0.0
              : math.sin(t * math.pi * 6) * 5 * (1 - t);
          return Transform.translate(
            offset: Offset(dx, 0),
            child: _field(l10n, bumping ? red : null),
          );
        },
      ),
    );
  }

  Widget _field(VhLocalizations l10n, Color? color) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: const [ClipTimeFormatter()],
      // A time reads left to right in Arabic too.
      textDirection: TextDirection.ltr,
      style: color == null ? null : TextStyle(color: color),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: '0:00',
        errorText: widget.error,
        errorMaxLines: 2,
        suffixIcon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Arrow(VhIcons.chevronUp, l10n.clipMinuteUp, () => _step(1)),
            _Arrow(VhIcons.chevronDown, l10n.clipMinuteDown, () => _step(-1)),
          ],
        ),
      ),
    );
  }
}

class _Arrow extends StatefulWidget {
  const _Arrow(this.icon, this.label, this.onStep);

  final VhIconData icon;
  final String label;
  final VoidCallback onStep;

  @override
  State<_Arrow> createState() => _ArrowState();
}

class _ArrowState extends State<_Arrow> {
  Timer? _repeat;

  void _stop() {
    _repeat?.cancel();
    _repeat = null;
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: widget.label,
    child: InkWell(
      borderRadius: BorderRadius.circular(VhRadius.iconButton),
      onTap: widget.onStep,
      // Minute 45 is forty-five presses; held, it is a few seconds.
      onLongPress: () => _repeat = Timer.periodic(
        const Duration(milliseconds: 110),
        (_) => widget.onStep(),
      ),
      onTapUp: (_) => _stop(),
      onTapCancel: _stop,
      child: Listener(
        onPointerUp: (_) => _stop(),
        onPointerCancel: (_) => _stop(),
        child: SizedBox(
          width: 44,
          height: 26,
          child: Center(child: VhIcon(widget.icon, size: 18)),
        ),
      ),
    ),
  );
}
