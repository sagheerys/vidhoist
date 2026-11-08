import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import 'vh_markdown_text.dart';
import 'vh_system_bars.dart';
import 'vh_route_motion.dart';

import '../icons/vh_icon.dart';
import '../icons/vh_icons.dart';

/// "What's new", shown once after an update. [notes] is already in the
/// reader's language; when empty, the sheet says the notes are on the
/// release page, which [onOpenPage] opens.
void showVhWhatsNewSheet(
  BuildContext context, {
  required String version,
  required String notes,
  required VoidCallback onOpenPage,
}) {
  showVhSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) =>
        VhWhatsNewSheet(version: version, notes: notes, onOpenPage: onOpenPage),
  );
}

class VhWhatsNewSheet extends StatelessWidget {
  const VhWhatsNewSheet({
    super.key,
    required this.version,
    required this.notes,
    required this.onOpenPage,
  });

  final String version;
  final String notes;
  final VoidCallback onOpenPage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final body = notes.trim();
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          VhSpace.xl,
          VhSpace.lg,
          VhSpace.xl,
          vhSheetBottomPad(context, VhSpace.xxl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The notes scroll and the buttons stay in sight, as in the
            // update sheet: long notes at a large text size must not push
            // "got it" off the screen.
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        VhIcon(VhIcons.sparkle, color: p.ink2),
                        const SizedBox(width: VhSpace.sm),
                        Expanded(
                          child: Text(
                            l10n.whatsNewTitle(version),
                            style: text.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: VhSpace.md),
                    if (body.isEmpty)
                      Text(
                        l10n.whatsNewUnavailable,
                        style: text.bodyMedium!.copyWith(color: p.ink2),
                      )
                    else
                      VhMarkdownText(
                        source: body,
                        style: text.bodySmall!.copyWith(color: p.ink2),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: VhSpace.xl),
            OverflowBar(
              alignment: MainAxisAlignment.end,
              overflowAlignment: OverflowBarAlignment.end,
              spacing: VhSpace.sm,
              children: [
                TextButton(
                  onPressed: onOpenPage,
                  child: Text(l10n.whatsNewReleasePage),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.whatsNewGotIt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
