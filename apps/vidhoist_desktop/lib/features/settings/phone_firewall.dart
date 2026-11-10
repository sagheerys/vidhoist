import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/firewall_data.dart';
import 'simple_panes.dart';

/// Windows' firewall as the phone meets it: nothing while it lets the app
/// in; otherwise why the phone cannot reach this computer, and one button
/// that asks Windows (an administrator prompt) for home networks only.
class PhoneFirewallLine extends ConsumerStatefulWidget {
  const PhoneFirewallLine({super.key});

  @override
  ConsumerState<PhoneFirewallLine> createState() => _PhoneFirewallLineState();
}

class _PhoneFirewallLineState extends ConsumerState<PhoneFirewallLine> {
  var _asking = false;

  Future<void> _allow() async {
    final l = context.vhl;
    setState(() => _asking = true);
    final done = await ref.read(firewallPortProvider).allow();
    if (!mounted) return;
    setState(() => _asking = false);
    ref.invalidate(pcFirewallProvider);
    if (!done) {
      showVhNotice(
        context,
        message: l.pcFirewallRefused,
        kind: VhNoticeKind.failed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final firewall = ref.watch(pcFirewallProvider).valueOrNull;
    if (firewall == null) return const SizedBox.shrink();
    final hint = switch (firewall.rule) {
      PcFirewallRule.missing => l.pcFirewallMissing,
      PcFirewallRule.blocked => l.pcFirewallBlocked,
      PcFirewallRule.allowed || PcFirewallRule.unknown => null,
    };
    if (hint == null) return const SizedBox.shrink();
    return SettingLine(
      title: l.pcFirewallTitle,
      hint: firewall.publicNetwork ? '$hint\n${l.pcFirewallPublic}' : hint,
      trailing: FilledButton(
        onPressed: _asking ? null : () => unawaited(_allow()),
        child: Text(l.pcFirewallAllow),
      ),
    );
  }
}
