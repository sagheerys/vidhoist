import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../data/firewall_data.dart';

/// Windows' firewall through PowerShell's own commands, whose output is the
/// same in every Windows language (netsh's is translated).
class WindowsFirewall implements FirewallPort {
  const WindowsFirewall();

  String get _exe => Platform.resolvedExecutable;

  @override
  Future<PcFirewall> check() async {
    try {
      final result = await Process.run('powershell.exe', [
        '-NoProfile',
        '-NonInteractive',
        '-EncodedCommand',
        _encoded(firewallCheckScript(_exe)),
      ]);
      return parseFirewallCheck('${result.stdout}');
    } on Object {
      return pcFirewallUnknown;
    }
  }

  @override
  Future<bool> allow() async {
    // Windows asks the user (UAC) before the elevated PowerShell starts;
    // a "No" there ends Start-Process with an error, and nothing changes.
    final elevated =
        "Start-Process powershell.exe -Verb RunAs -Wait -WindowStyle Hidden "
        "-ArgumentList '-NoProfile','-NonInteractive','-EncodedCommand',"
        "'${_encoded(firewallAllowScript(_exe))}'";
    try {
      await Process.run('powershell.exe', [
        '-NoProfile',
        '-NonInteractive',
        '-Command',
        'try { $elevated -ErrorAction Stop } catch { exit 1 }',
      ]);
    } on Object {
      return false;
    }
    return (await check()).rule == PcFirewallRule.allowed;
  }

  /// `-EncodedCommand` takes UTF-16LE in base64: no quoting of the path to
  /// get wrong.
  static String _encoded(String script) {
    final bytes = Uint8List(script.length * 2);
    for (var i = 0; i < script.length; i++) {
      final unit = script.codeUnitAt(i);
      bytes[2 * i] = unit & 0xff;
      bytes[2 * i + 1] = unit >> 8;
    }
    return base64.encode(bytes);
  }
}
