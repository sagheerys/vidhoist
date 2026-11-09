import 'package:vh_ui/vh_ui.dart';

/// The router's branches by number; the computer's comes last so that the
/// others kept theirs when it arrived.
abstract final class ShellBranch {
  static const library = 0;
  static const playlists = 1;
  static const settings = 2;
  static const pc = 3;
}

/// The branches in the order the bar shows them. **The computer's tab is
/// there only once this phone is paired**, before settings; most people
/// never pair and see the three tabs they always had.
List<int> shellTabs({required bool paired}) => [
  ShellBranch.library,
  ShellBranch.playlists,
  if (paired) ShellBranch.pc,
  ShellBranch.settings,
];

List<VhNavItem> shellNavItems(VhLocalizations l10n, List<int> tabs) => [
  for (final branch in tabs)
    switch (branch) {
      ShellBranch.library => VhNavItem(
        icon: VhIcons.download,
        selectedIcon: VhIcons.download,
        label: l10n.navMyDownloads,
      ),
      ShellBranch.playlists => VhNavItem(
        icon: VhIcons.queue,
        selectedIcon: VhIcons.queue,
        label: l10n.navPlaylists,
      ),
      ShellBranch.pc => VhNavItem(
        icon: VhIcons.monitor,
        selectedIcon: VhIcons.monitor,
        label: l10n.pcTab,
      ),
      _ => VhNavItem(
        icon: VhIcons.settings,
        selectedIcon: VhIcons.settings,
        label: l10n.navSettings,
      ),
    },
];
