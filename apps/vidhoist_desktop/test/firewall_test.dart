import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/data/firewall_data.dart';

/// What Windows' firewall makes of the link, read from the check script's
/// output as PowerShell prints it (measured on the owner's computer,
/// 2026-11-10: a home Wi-Fi Windows called "Public", let in on both).
void main() {
  PcFirewallRule rule(String output) => parseFirewallCheck(output).rule;

  test('let in on the kind of network in use', () {
    expect(
      parseFirewallCheck(
        '{"allow":["Private","Public"],"nets":["Public"],"block":[]}',
      ),
      (rule: PcFirewallRule.allowed, publicNetwork: false),
    );
    expect(
      rule('{"allow":"Private","nets":"Private","block":[]}'),
      PcFirewallRule.allowed,
    );
    expect(
      rule('{"allow":["Any"],"nets":["Private"],"block":[]}'),
      PcFirewallRule.allowed,
    );
  });

  test('**the guard**: a block outranks an allow', () {
    expect(
      rule('{"allow":["Private"],"nets":["Private"],"block":["Private"]}'),
      PcFirewallRule.blocked,
    );
    expect(
      rule('{"allow":["Private"],"nets":["Private"],"block":"Any"}'),
      PcFirewallRule.blocked,
    );
  });

  test('a public home network with no rule for it is named', () {
    expect(
      parseFirewallCheck('{"allow":["Private"],"nets":["Public"],"block":[]}'),
      (rule: PcFirewallRule.missing, publicNetwork: true),
    );
    expect(parseFirewallCheck('{"allow":[],"nets":["Private"],"block":[]}'), (
      rule: PcFirewallRule.missing,
      publicNetwork: false,
    ));
  });

  test('offline, the home network is assumed; junk reads as unknown', () {
    expect(
      rule('{"allow":["Private"],"nets":[],"block":[]}'),
      PcFirewallRule.allowed,
    );
    expect(
      rule('{"allow":["Domain"],"nets":"DomainAuthenticated","block":[]}'),
      PcFirewallRule.allowed,
    );
    for (final junk in ['', 'Access denied', '[]', '{"x":1}']) {
      expect(parseFirewallCheck(junk), pcFirewallUnknown, reason: junk);
    }
  });

  test('**the guard**: a path with a quote stays one literal', () {
    const exe = r"C:\Users\O'Neil\VidHoist\vidhoist_desktop.exe";
    for (final script in [firewallCheckScript(exe), firewallAllowScript(exe)]) {
      expect(
        script,
        contains(r"'C:\Users\O''Neil\VidHoist\vidhoist_desktop.exe'"),
      );
      expect(script, isNot(contains(r"'C:\Users\O'Neil")));
    }
  });

  test('the rule it adds: inbound, this app, private networks only', () {
    final script = firewallAllowScript(r'C:\A\vidhoist_desktop.exe');
    final add = script
        .split('\n')
        .singleWhere((l) => l.startsWith('New-NetFirewallRule'));
    expect(add, contains("-DisplayName '$pcFirewallRuleName'"));
    expect(add, contains('-Direction Inbound -Action Allow'));
    expect(add, contains(r"-Program 'C:\A\vidhoist_desktop.exe'"));
    expect(add, endsWith('-Profile Private | Out-Null'));
    // Only this app's own blocks are lifted.
    expect(
      script,
      contains(r"-ieq 'C:\A\vidhoist_desktop.exe' } | Get-NetFirewallRule"),
    );
  });
}
