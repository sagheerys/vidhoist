import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/appearance_data.dart';
import '../../shell/ui_zoom.dart';
import 'appearance_preview.dart';

/// Day or night, the language, and the interface size. Each follows
/// Windows (or 100%) until chosen, and each is this computer's alone.
///
/// The choices are joined buttons, and **beside them a small window shows
/// the theme and the size being chosen**; under them where the pane is too
/// narrow for both.
class AppearancePane extends ConsumerWidget {
  const AppearancePane({super.key});

  /// The pane's widest: the choices at a readable width, then the preview.
  static const double maxWidth =
      VhBreakpoint.readable + VhSpace.xxl + AppearancePreview.width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final look = ref.watch(appearanceProvider);
    final appearance = ref.read(appearanceProvider.notifier);
    final zoom = ref.watch(uiZoomProvider);
    final zooms = ref.read(uiZoomProvider.notifier);
    final tooLarge = uiZoomSteps.any((s) => !zooms.fits(s));
    final faded = uiZoomSteps
        .where((s) => !zooms.fits(s))
        .map((s) => vhLtrRun(UiZoom(s).percent))
        .join(' ');
    final choices = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChoiceGroup(
          title: l.theme,
          children: [
            DesktopSegments(
              items: [
                for (final (mode, label) in [
                  (ThemeMode.system, l.themeSystem),
                  (ThemeMode.light, l.themeLight),
                  (ThemeMode.dark, l.themeDark),
                ])
                  DesktopSegment(
                    label: label,
                    selected: look.theme == mode,
                    onTap: () => appearance.setTheme(mode),
                  ),
              ],
            ),
          ],
        ),
        ChoiceGroup(
          title: l.language,
          hint: look.locale == null ? l.desktopLanguageSystemHint : null,
          children: [
            DesktopSegments(
              items: [
                DesktopSegment(
                  label: l.languageSystem,
                  selected: look.locale == null,
                  onTap: () => appearance.setLocale(null),
                ),
                for (final code in appearanceLocales)
                  DesktopSegment(
                    label: vhLanguageName(code),
                    selected: look.locale == code,
                    onTap: () => appearance.setLocale(code),
                  ),
              ],
            ),
          ],
        ),
        ChoiceGroup(
          title: l.desktopUiSize,
          // Why a size is faded, said in the line itself and not only in a
          // tooltip; then the keys, each read left to right in Arabic too.
          hint: [
            if (tooLarge) '$faded: ${l.desktopUiSizeTooLarge}',
            l.desktopUiSizeHint(
              vhLtrRun('Ctrl+='),
              vhLtrRun('Ctrl+−'),
              vhLtrRun('Ctrl+0'),
            ),
          ].join('\n'),
          children: [
            DesktopSegments(
              items: [
                for (final step in uiZoomSteps)
                  DesktopSegment(
                    label: UiZoom(step).percent,
                    selected: zoom.value == step,
                    enabled: zooms.fits(step) || zoom.value == step,
                    onTap: () => zooms.set(step),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
    return LayoutBuilder(
      builder: (context, box) {
        final preview = AppearancePreview(theme: look.theme, zoom: zoom.value);
        // Beside the choices once they keep a readable width of their own;
        // under them where they would not.
        if (box.maxWidth < VhBreakpoint.readable) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              choices,
              const SizedBox(height: VhSpace.md),
              preview,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The choices as wide as their words, so the preview stands
            // beside them and not across an empty middle.
            Flexible(child: IntrinsicWidth(child: choices)),
            const SizedBox(width: VhSpace.xxl),
            Padding(
              padding: const EdgeInsets.only(top: VhSpace.lg),
              child: preview,
            ),
          ],
        );
      },
    );
  }
}

/// Choices joined on one ground, the chosen one lifted onto the card.
class DesktopSegments extends StatelessWidget {
  const DesktopSegments({super.key, required this.items});

  final List<DesktopSegment> items;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: p.cardAlt,
        borderRadius: BorderRadius.circular(VhCorners.desktop.chip),
      ),
      child: Padding(
        padding: const EdgeInsets.all(VhSpace.xxs / 2),
        child: Wrap(children: items),
      ),
    );
  }
}

/// One of [DesktopSegments]. A choice this screen cannot hold is faded, not
/// missing, and takes no click.
class DesktopSegment extends StatelessWidget {
  const DesktopSegment({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(
      VhCorners.desktop.chip - VhSpace.xxs / 2,
    );
    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Material(
          color: selected ? p.card : Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: enabled ? onTap : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: VhSpace.md,
                vertical: VhSpace.xs,
              ),
              child: Text(
                label,
                style: text.labelMedium?.copyWith(
                  color: selected ? p.ink : p.ink2,
                  fontWeight: selected ? FontWeight.w700 : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A setting chosen among a few: its name, the choices, and a line on
/// what it does.
class ChoiceGroup extends StatelessWidget {
  const ChoiceGroup({
    super.key,
    required this.title,
    required this.children,
    this.hint,
  });

  final String title;
  final String? hint;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: VhSpace.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: text.bodyLarge?.copyWith(color: p.ink)),
          const SizedBox(height: VhSpace.xs),
          Wrap(spacing: VhSpace.xs, runSpacing: VhSpace.xs, children: children),
          if (hint case final hint?) ...[
            const SizedBox(height: VhSpace.xs),
            Text(hint, style: text.labelSmall?.copyWith(color: p.ink3)),
          ],
        ],
      ),
    );
  }
}
