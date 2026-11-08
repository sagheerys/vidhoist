import 'package:flutter/material.dart';

import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';

/// The app's empty state: an honest heading in Kufi, the next step in one
/// sentence, and at most one action in the ink.
///
/// **No icon on a disc**: an emblem over an empty page
/// was one of the marks of a generated screen, and the accent on its action
/// competed with the screen's own add button.
class VhEmptyState extends StatelessWidget {
  const VhEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final x = VhThemeX.of(context);
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(VhSpace.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: text.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: VhSpace.xs),
            Text(
              message,
              style: text.bodyMedium!.copyWith(color: x.palette.ink2),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: VhSpace.md),
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
