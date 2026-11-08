import 'package:flutter/material.dart';

import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';

import '../icons/vh_icon.dart';
import '../icons/vh_icons.dart';

/// **A summary bar for active downloads**, replacing one stacked card per
/// task at the top of the library.
///
/// Field report 2026-09-03: several downloads all appeared in the library
/// **while a button for them already sat in the header**, so they crowded
/// one place. Each live card is about 78 points tall, so three tasks
/// pushed the library off screen and left the user scrolling to reach
/// their own files.
///
/// The rule now: one task shows its full card; more than one collapses
/// into **this single line**, which summarises them and defers to the
/// management sheet the header button already opened.
class VhActiveDownloadsBar extends StatelessWidget {
  const VhActiveDownloadsBar({
    super.key,
    required this.label,
    required this.actionLabel,
    required this.onTap,
    this.progress,
  });

  /// "3 downloads in progress", translated by the app.
  final String label;

  /// "Show all".
  final String actionLabel;
  final VoidCallback onTap;

  /// Mean task progress from 0 to 1, or null when indeterminate.
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;

    return Material(
      color: p.accentSoft,
      borderRadius: BorderRadius.circular(VhRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(VhRadius.card),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: VhSpace.md + 1,
            vertical: VhSpace.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(VhRadius.card),
            border: Border.all(
              color: p.accent.withValues(alpha: 0.3),
              width: VhThemeX.of(context).hairline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  VhIcon(VhIcons.download, size: 20, color: p.accent),
                  const SizedBox(width: VhSpace.sm),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (progress != null)
                    Text(
                      '${(progress!.clamp(0, 1) * 100).round()}%',
                      style: text.bodySmall!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: p.accent,
                      ),
                    ),
                  const SizedBox(width: VhSpace.sm),
                  Text(
                    actionLabel,
                    style: text.labelSmall!.copyWith(
                      color: p.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: VhSpace.xs + 1),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: p.accent.withValues(alpha: 0.16),
                  valueColor: AlwaysStoppedAnimation(p.accent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
