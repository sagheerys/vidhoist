import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';

/// **The language picker screen**.
///
/// The choice used to be a segmented button with three segments, and
/// `SegmentedButton` divides the width by the number of options: three fit
/// a 360dp screen, **and six break** — and the declared plan is to support
/// the common languages. A list extends without limit and without
/// breaking.
///
/// "Follow the system" comes first and carries no language code: it is
/// **the absence of a choice**, not a particular language. The languages
/// are read from [VhLocalizations.supportedLocales] rather than a
/// hand-written list, so adding an `app_xx.arb` makes its language appear
/// here automatically.
class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final selected = ref.watch(settingsProvider).localeCode;
    final notifier = ref.read(settingsProvider.notifier);

    Widget tile({
      required String title,
      required bool checked,
      required VoidCallback onTap,
      String? subtitle,
    }) => ListTile(
      title: Text(title),
      subtitle: subtitle == null
          ? null
          : Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: checked ? VhIcon(VhIcons.check, color: p.ink) : null,
      onTap: onTap,
    );

    final codes = [
      for (final locale in VhLocalizations.supportedLocales)
        locale.languageCode,
    ]..sort();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.language)),
      body: VhReadableWidth(
        child: ListView(
          padding: const EdgeInsets.only(bottom: VhSpace.xxl),
          children: [
            tile(
              title: l10n.languageSystem,
              subtitle: l10n.languageSystemHint,
              checked: selected == null,
              onTap: () => notifier.setLocale(null),
            ),
            const Divider(height: 1),
            for (final code in codes)
              tile(
                title: vhLanguageName(code),
                checked: selected == code,
                onTap: () => notifier.setLocale(code),
              ),
          ],
        ),
      ),
    );
  }
}
