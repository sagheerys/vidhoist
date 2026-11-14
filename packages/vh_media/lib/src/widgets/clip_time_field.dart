import 'dart:async';

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
class ClipTimeField extends StatelessWidget {
  const ClipTimeField({
    super.key,
    required this.controller,
    required this.label,
    this.error,
    this.startAt,
  });

  final TextEditingController controller;
  final String label;
  final String? error;

  /// Where the arrows start while the field is empty: "to" starts from
  /// "from", so the first press lands a minute after the start.
  final Duration? Function()? startAt;

  void _step(int minutes) {
    final now =
        ClipRange.parseTime(controller.text) ??
        startAt?.call() ??
        Duration.zero;
    var next = now + Duration(minutes: minutes);
    if (next.isNegative) next = Duration.zero;
    final text = ClipRange.clock(next);
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    // ↑ and ↓ on a computer's keyboard step as the arrows do; the field
    // is one line, so they had nothing else to do there.
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowUp): () => _step(1),
        const SingleActivator(LogicalKeyboardKey.arrowDown): () => _step(-1),
      },
      child: _field(l10n),
    );
  }

  Widget _field(VhLocalizations l10n) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: const [ClipTimeFormatter()],
      // A time reads left to right in Arabic too.
      textDirection: TextDirection.ltr,
      decoration: InputDecoration(
        labelText: label,
        hintText: '0:00',
        errorText: error,
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
