import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/appearance_data.dart';
import '../../shell/context_menu.dart';

/// **The language list, shared by Appearance and the welcome window.**
///
/// It is read from [appearanceLocales], itself read from the translations,
/// so a new `app_<code>.arb` appears here without a hand-written entry: two
/// hand-written segments once hid ten finished translations on Windows.
/// Twelve names and System do not fit a row of segments, so a button opens
/// them as a menu. The app's own menu, a route, rather than Material's
/// [DropdownMenu]: that builds an `OverlayPortal`, which the app's screens
/// must not.
class DesktopLanguageChoice extends ConsumerWidget {
  const DesktopLanguageChoice({super.key});

  /// A menu entry needs a value, so System is the empty code.
  static const _system = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final chosen = ref.watch(appearanceProvider).locale;
    return Builder(
      builder: (context) => VhRowButton(
        label: chosen == null ? l.languageSystem : vhLanguageName(chosen),
        icon: VhIcons.chevronDown,
        onPressed: () async {
          // Opened under the button, as a menu from a field is.
          final box = context.findRenderObject()! as RenderBox;
          final at = box.localToGlobal(box.size.bottomLeft(Offset.zero));
          final picked = await showDesktopMenu<String>(context, at, [
            for (final code in [_system, ...appearanceLocales])
              DesktopMenuEntry(
                code,
                code == (chosen ?? _system) ? VhIcons.check : null,
                code == _system ? l.languageSystem : vhLanguageName(code),
              ),
          ]);
          if (picked == null || picked == (chosen ?? _system)) return;
          ref
              .read(appearanceProvider.notifier)
              .setLocale(picked == _system ? null : picked);
        },
      ),
    );
  }
}
