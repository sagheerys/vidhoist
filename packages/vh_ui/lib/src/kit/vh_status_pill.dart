import 'package:flutter/material.dart';

import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';

/// How something stands, in two words beside its name: a dot and a label
/// in a soft pill. [good] is the settled state (connected, updated), in the
/// olive the app keeps for "all is well"; otherwise it is muted, never red:
/// the pill reports, the screen's own message says what to do.
class VhStatusPill extends StatelessWidget {
  const VhStatusPill({super.key, required this.label, required this.good});

  final String label;
  final bool good;

  static const _dot = 7.0;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: good ? p.offlineSoft : p.cardAlt,
        borderRadius: BorderRadius.circular(VhRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: VhSpace.sm,
          vertical: VhSpace.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: good ? p.ok : p.ink3,
                shape: BoxShape.circle,
              ),
              child: const SizedBox.square(dimension: _dot),
            ),
            const SizedBox(width: VhSpace.xs),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: good ? p.offlineInk : p.ink2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
