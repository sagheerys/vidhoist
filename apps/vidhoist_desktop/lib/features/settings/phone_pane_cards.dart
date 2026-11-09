import 'package:flutter/material.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../shell/folded_text.dart';
import 'phone_qr.dart';

/// The QR code to scan on the phone, and beside it the code to type there
/// instead, large and spaced, with its countdown.
class PhoneCodeCard extends StatelessWidget {
  const PhoneCodeCard({
    super.key,
    required this.code,
    required this.qrData,
    required this.secondsLeft,
    required this.onCancel,
  });

  final String code;

  /// What the QR code carries ([PcPairOffer.toUri]).
  final String qrData;
  final int secondsLeft;
  final VoidCallback onCancel;

  /// Below this width the code goes under the QR code, not beside it.
  static const _sideBySide = 440.0;

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final typed = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.pcLinkCodeTitle, style: text.titleSmall?.copyWith(color: p.ink)),
        const SizedBox(height: VhSpace.sm),
        Text(
          code.split('').join(' '),
          textDirection: TextDirection.ltr,
          style: text.headlineMedium?.copyWith(
            color: p.ink,
            fontFeatures: const [FontFeature.tabularFigures()],
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: VhSpace.xs),
        Text(
          l.pcLinkCodeLeft(secondsLeft.clamp(0, 999)),
          style: text.bodySmall?.copyWith(color: p.ink2),
        ),
        const SizedBox(height: VhSpace.sm),
        FoldedText(
          l.pcLinkCodeHint,
          style: text.labelSmall?.copyWith(color: p.ink3),
        ),
      ],
    );
    final qr = PhoneQr(data: qrData);
    return _Card(
      children: [
        LayoutBuilder(
          builder: (context, box) => box.maxWidth >= _sideBySide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    qr,
                    const SizedBox(width: VhSpace.lg),
                    Expanded(child: typed),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    qr,
                    const SizedBox(height: VhSpace.md),
                    typed,
                  ],
                ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: VhLinkButton(label: l.cancel, onPressed: onCancel),
        ),
      ],
    );
  }
}

/// A phone that typed the code, waiting for the owner: its name and the
/// four digits to compare with the phone's own.
class PhoneRequestCard extends StatelessWidget {
  const PhoneRequestCard({super.key, required this.request});

  final PcPairingRequest request;

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return _Card(
      children: [
        Text(
          l.pcLinkRequest(request.name),
          style: text.titleSmall?.copyWith(color: p.ink),
        ),
        const SizedBox(height: VhSpace.sm),
        Text(
          request.check.split('').join(' '),
          textDirection: TextDirection.ltr,
          style: text.headlineMedium?.copyWith(
            color: p.accentInk,
            fontFeatures: const [FontFeature.tabularFigures()],
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: VhSpace.xs),
        Text(
          l.pcLinkRequestHint,
          style: text.bodySmall?.copyWith(color: p.ink2),
        ),
        const SizedBox(height: VhSpace.md),
        Wrap(
          spacing: VhSpace.sm,
          runSpacing: VhSpace.xs,
          children: [
            FilledButton(onPressed: request.allow, child: Text(l.pcLinkAllow)),
            OutlinedButton(onPressed: request.deny, child: Text(l.pcLinkDeny)),
          ],
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: VhSpace.md),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: p.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VhCorners.desktop.card),
            side: BorderSide(
              color: p.line,
              width: VhThemeX.of(context).hairline,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(VhSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
