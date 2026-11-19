import 'package:flutter/material.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../shell/folded_text.dart';

/// The addresses a phone dials, the home network's first and named by its
/// adapter, then Tailscale's, and the adapters other programs added folded
/// away: six in a row read as a puzzle.
class PhoneAddresses extends StatefulWidget {
  const PhoneAddresses({
    super.key,
    required this.addresses,
    required this.port,
  });

  final List<PcAddress> addresses;
  final int port;

  @override
  State<PhoneAddresses> createState() => _PhoneAddressesState();
}

class _PhoneAddressesState extends State<PhoneAddresses> {
  var _showOthers = false;

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    List<PcAddress> of(PcAddressKind kind) => [
      for (final a in widget.addresses)
        if (a.kind == kind) a,
    ];
    final home = of(PcAddressKind.home);
    final tailscale = of(PcAddressKind.tailscale);
    final others = of(PcAddressKind.other);
    Widget line(PcAddress a) => Padding(
      padding: const EdgeInsets.only(top: VhSpace.xs),
      child: Wrap(
        spacing: VhSpace.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SelectableText(
            '${a.address}:${widget.port}',
            textDirection: TextDirection.ltr,
            style: text.bodyMedium?.copyWith(
              color: p.ink,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(a.adapter, style: text.labelSmall?.copyWith(color: p.ink3)),
        ],
      ),
    );
    Widget heading(String label) => Padding(
      padding: const EdgeInsets.only(top: VhSpace.sm),
      child: Text(label, style: text.bodySmall?.copyWith(color: p.ink2)),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: p.line,
            width: VhThemeX.of(context).hairline,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: VhSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.pcLinkAddress,
              style: text.bodyLarge?.copyWith(color: p.ink),
            ),
            if (widget.addresses.isEmpty)
              Text('—', style: text.bodyMedium?.copyWith(color: p.ink2)),
            ...home.map(line),
            if (tailscale.isNotEmpty) ...[
              heading(l.pcLinkAddressTailscale),
              ...tailscale.map(line),
            ],
            if (others.isNotEmpty) ...[
              const SizedBox(height: VhSpace.xs),
              VhLinkButton(
                label: l.pcLinkOtherAddresses(others.length),
                icon: _showOthers ? VhIcons.chevronUp : VhIcons.chevronDown,
                onPressed: () => setState(() => _showOthers = !_showOthers),
              ),
              if (_showOthers) ...[
                FoldedText(
                  l.pcLinkOtherAddressesHint,
                  style: text.labelSmall?.copyWith(color: p.ink3),
                ),
                ...others.map(line),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
