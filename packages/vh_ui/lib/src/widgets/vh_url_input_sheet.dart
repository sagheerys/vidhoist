import 'package:flutter/material.dart';

import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import 'vh_platform_chip.dart';
import 'vh_system_bars.dart';

import '../icons/vh_icon.dart';
import '../icons/vh_icons.dart';

/// A quality option shown in the sheet. Values and labels come from the
/// app, since vh_ui does not know the download engine: numeric qualities
/// are only passed through when the link is a YouTube one.
class VhQualityOption {
  const VhQualityOption({required this.value, required this.label});
  final String value;
  final String label;
}

/// The "add link" bottom sheet: a URL field, a detected-platform badge,
/// quality chips and a start button. Paste and detection logic lives in the
/// app.
class VhUrlInputSheet extends StatelessWidget {
  const VhUrlInputSheet({
    super.key,
    required this.title,
    required this.urlHint,
    required this.controller,
    required this.qualities,
    required this.selectedQuality,
    required this.onQualitySelected,
    required this.startLabel,
    required this.onStart,
    this.platform,
    this.platformLabel,
    this.onUrlChanged,
    this.extra,
    this.preview,
  });

  final String title;
  final String urlHint;
  final TextEditingController controller;
  final List<VhQualityOption> qualities;
  final String selectedQuality;
  final ValueChanged<String> onQualitySelected;
  final String startLabel;
  final VoidCallback onStart;
  final VhPlatformKind? platform;
  final String? platformLabel;
  final ValueChanged<String>? onUrlChanged;

  /// One more choice under the qualities, such as a download folder;
  /// null for no extra row.
  final Widget? extra;

  /// What the link is, under the field: usually an [VhLinkPreview].
  final Widget? preview;

  @override
  Widget build(BuildContext context) {
    final x = VhThemeX.of(context);
    final p = x.palette;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: VhSpace.xl,
        right: VhSpace.xl,
        top: VhSpace.md,
        // Whichever is showing: the keyboard **or** the system button bar.
        bottom: vhSheetBottomPad(context),
      ),
      // **Scrolls when it must**: a short phone with the system font at its
      // largest leaves less room than the sheet's rows need, and a row too
      // many would push the start button off the screen. When everything
      // fits, nothing scrolls.
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // **No drag handle here**: the theme sets `showDragHandle: true`
            // for every bottom sheet, so drawing a second one showed two bars
            // stacked on top of each other (screenshot 2026-09-04).
            Text(title, style: text.titleLarge),
            const SizedBox(height: VhSpace.lg),
            TextField(
              controller: controller,
              onChanged: onUrlChanged,
              keyboardType: TextInputType.url,
              textDirection: TextDirection.ltr,
              style: text.bodyMedium,
              decoration: InputDecoration(
                hintText: urlHint,
                prefixIcon: VhIcon(VhIcons.link, size: 20, color: p.ink3),
                // The platform the link was recognised as, inside the
                // field it was read from, with a check: the field is
                // right, not a badge on the sheet's frame.
                suffixIcon:
                    platform == null ||
                        platform == VhPlatformKind.other ||
                        platformLabel == null
                    ? null
                    : Padding(
                        padding: const EdgeInsetsDirectional.only(
                          end: VhSpace.md,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              platformLabel!,
                              style: text.labelSmall!.copyWith(color: p.ok),
                            ),
                            const SizedBox(width: VhSpace.xxs),
                            VhIcon(VhIcons.check, size: 14, color: p.ok),
                          ],
                        ),
                      ),
              ),
            ),
            if (preview case final preview?) ...[
              const SizedBox(height: VhSpace.md),
              preview,
            ],
            const SizedBox(height: VhSpace.lg),
            Wrap(
              spacing: VhSpace.xs,
              runSpacing: VhSpace.xs,
              children: [
                for (final q in qualities)
                  ChoiceChip(
                    label: Text(q.label),
                    selected: q.value == selectedQuality,
                    onSelected: (_) => onQualitySelected(q.value),
                    showCheckmark: false,
                    labelStyle: text.labelMedium!.copyWith(
                      color: q.value == selectedQuality ? p.bg : p.ink2,
                    ),
                  ),
              ],
            ),
            if (extra case final extra?) ...[
              const SizedBox(height: VhSpace.md),
              extra,
            ],
            const SizedBox(height: VhSpace.xl),
            FilledButton.icon(
              onPressed: onStart,
              icon: const VhIcon(VhIcons.download, size: 18),
              label: Text(startLabel),
            ),
          ],
        ),
      ),
    );
  }
}

/// What a link is before it is downloaded: its picture, title and maker.
/// While [loading], grey blocks hold the place, so nothing jumps when the
/// answer arrives.
class VhLinkPreview extends StatelessWidget {
  const VhLinkPreview({
    super.key,
    this.thumbnail,
    this.title,
    this.subtitle,
    this.loading = false,
  });

  final Widget? thumbnail;
  final String? title;
  final String? subtitle;
  final bool loading;

  static const _thumb = Size(96, 54);

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    Widget block(double width) => Container(
      width: width,
      height: 10,
      decoration: BoxDecoration(
        color: p.cardAlt,
        borderRadius: BorderRadius.circular(VhRadius.badge),
      ),
    );
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(VhRadius.thumb),
          child: SizedBox.fromSize(
            size: _thumb,
            child: loading
                ? ColoredBox(color: p.cardAlt)
                : thumbnail ?? ColoredBox(color: p.cardAlt),
          ),
        ),
        const SizedBox(width: VhSpace.md),
        Expanded(
          child: loading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    block(double.infinity),
                    const SizedBox(height: VhSpace.xs),
                    block(90),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall!.copyWith(color: p.ink3),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
