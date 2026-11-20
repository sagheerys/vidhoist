import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/features/shell/shell_tabs.dart';

/// **The guard**: every tab is an outline that fills where you are. The
/// bar showed the same glyph either way, three outlines and a solid
/// download, so only the pill said which tab was chosen.
void main() {
  test('each tab has a filled face apart from its outline', () {
    final l10n = lookupVhLocalizations(const Locale('en'));
    final items = shellNavItems(l10n, shellTabs(paired: true));
    expect(items, hasLength(4));
    for (final item in items) {
      expect(item.selectedIcon, isNot(item.icon), reason: item.label);
    }
    expect(items.first.icon, VhIcons.downloadOutline);
  });
}
