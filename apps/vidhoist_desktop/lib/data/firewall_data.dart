import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pc_link_data.dart';

/// The rule the app adds when the user lets the phone in; the uninstaller
/// removes it by this name (installer_test).
const pcFirewallRuleName = 'VidHoist phone link';

/// What Windows' firewall makes of the link, as far as the app can read it.
enum PcFirewallRule {
  /// An inbound rule lets the app in on private networks.
  allowed,

  /// No rule: Windows asks once on its own, or blocks without asking.
  missing,

  /// A rule blocks it, typically a "Cancel" on Windows' own question.
  blocked,

  /// Not read (not Windows, or the check failed): nothing is shown.
  unknown,
}

typedef PcFirewall = ({PcFirewallRule rule, bool publicNetwork});

const PcFirewall pcFirewallUnknown = (
  rule: PcFirewallRule.unknown,
  publicNetwork: false,
);

/// Reads Windows' firewall and, on the user's word, adds the rule; Windows'
/// own in main, nothing in tests.
abstract class FirewallPort {
  Future<PcFirewall> check();

  /// One administrator prompt from Windows; true once the rule is there.
  Future<bool> allow();
}

class NoFirewall implements FirewallPort {
  const NoFirewall();

  @override
  Future<PcFirewall> check() async => pcFirewallUnknown;

  @override
  Future<bool> allow() async => false;
}

final firewallPortProvider = Provider<FirewallPort>(
  (ref) => const NoFirewall(),
);

/// Read once each time the link starts, and again after the user allows.
final pcFirewallProvider = FutureProvider<PcFirewall>((ref) async {
  final session = await ref.watch(pcLinkProvider.future);
  if (session == null) return pcFirewallUnknown;
  return ref.read(firewallPortProvider).check();
});

/// A literal for a PowerShell script: single quotes, which expand nothing.
String _quoted(String text) => "'${text.replaceAll("'", "''")}'";

/// The inbound rules that name [exe], however Windows spelled its path.
String _rulesFor(String exe) =>
    'Get-NetFirewallApplicationFilter | Where-Object { '
    '[Environment]::ExpandEnvironmentVariables(\$_.Program) -ieq ${_quoted(exe)} '
    "} | Get-NetFirewallRule | Where-Object { \$_.Direction -eq 'Inbound' }";

/// Reads, without administrator rights, the network kinds (profiles) the
/// rules naming [exe] allow and block, and the kinds of the networks with
/// internet in use now. Prints one line of JSON.
String firewallCheckScript(String exe) =>
    '''
\$ErrorActionPreference = 'SilentlyContinue'
\$rules = @(${_rulesFor(exe)} | Where-Object { \$_.Enabled -eq 'True' })
function Kinds(\$action) { @(\$rules | Where-Object { "\$(\$_.Action)" -eq \$action } | ForEach-Object { "\$(\$_.Profile)" -split ', ' } | Sort-Object -Unique) }
\$nets = @(Get-NetConnectionProfile | Where-Object { "\$(\$_.IPv4Connectivity)" -eq 'Internet' } | ForEach-Object { "\$(\$_.NetworkCategory)" })
@{ allow = @(Kinds 'Allow'); block = @(Kinds 'Block'); nets = \$nets } | ConvertTo-Json -Compress
''';

/// Run as administrator: lifts this app's blocks on private networks (a
/// block outranks any allow) and adds the app's own rule, private networks
/// only. Nothing else in the firewall is touched.
String firewallAllowScript(String exe) =>
    '''
\$ErrorActionPreference = 'SilentlyContinue'
${_rulesFor(exe)} | Where-Object { "\$(\$_.Action)" -eq 'Block' -and "\$(\$_.Profile)" -match 'Private|Any' } | Remove-NetFirewallRule
Get-NetFirewallRule -DisplayName ${_quoted(pcFirewallRuleName)} -ErrorAction SilentlyContinue | Remove-NetFirewallRule
New-NetFirewallRule -DisplayName ${_quoted(pcFirewallRuleName)} -Description 'Lets a paired phone reach VidHoist on home networks.' -Direction Inbound -Action Allow -Program ${_quoted(exe)} -Profile Private | Out-Null
''';

/// PowerShell prints a list of one as the bare value.
Set<String> _kinds(Object? json) => {
  if (json is String) json,
  if (json is List)
    for (final kind in json)
      if (kind is String) kind,
};

/// What [firewallCheckScript] printed, for the networks in use: blocked if
/// a rule blocks any of them, allowed if rules allow them all. Unknown when
/// it is not that output.
PcFirewall parseFirewallCheck(String output) {
  final Object? json;
  try {
    json = jsonDecode(output.trim());
  } on FormatException {
    return pcFirewallUnknown;
  }
  if (json is! Map || !json.containsKey('allow')) return pcFirewallUnknown;
  final allow = _kinds(json['allow']);
  final block = _kinds(json['block']);
  // A network's kind is named as its rule profile is, but for a domain's.
  final nets = {
    for (final kind in _kinds(json['nets']))
      kind == 'DomainAuthenticated' ? 'Domain' : kind,
  };
  // Offline, the next network is most likely the home one.
  if (nets.isEmpty) nets.add('Private');
  bool covers(Set<String> kinds, String net) =>
      kinds.contains(net) || kinds.contains('Any');
  final rule = nets.any((n) => covers(block, n))
      ? PcFirewallRule.blocked
      : nets.every((n) => covers(allow, n))
      ? PcFirewallRule.allowed
      : PcFirewallRule.missing;
  return (
    rule: rule,
    publicNetwork: rule != PcFirewallRule.allowed && nets.contains('Public'),
  );
}
