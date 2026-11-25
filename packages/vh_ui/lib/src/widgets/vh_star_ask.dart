import 'package:flutter/material.dart';

import '../icons/vh_icon.dart';
import '../icons/vh_icon_data.dart';
import '../icons/vh_icons.dart';
import '../l10n/l10n.dart';
import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';

/// **The question for a star on GitHub**, put once a user has seen the app
/// work: what the app is, a star, a place for ideas and problems, and two
/// ways to say no. Each choice is its own callback; the app keeps the
/// count, opens the pages and closes what holds this.
///
/// The phone shows it in a sheet, centred. The computer shows it as a
/// small [card] in a corner, over nothing being used: set to the start,
/// with a cross that closes it as "later", and the two answers on a line.
class VhStarAsk extends StatelessWidget {
  const VhStarAsk({
    super.key,
    required this.onStar,
    required this.onIdeas,
    required this.onLater,
    required this.onNever,
    this.card = false,
  });

  final VoidCallback onStar;
  final VoidCallback onIdeas;
  final VoidCallback onLater;
  final VoidCallback onNever;
  final bool card;

  // The sheet's answer is a pill as wide as eight steps, tall enough for a
  // thumb; the card's sits at the computer's button height.
  static const double _pillHeight = 46;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l = context.vhl;
    final text = Theme.of(context).textTheme;
    final align = card ? TextAlign.start : TextAlign.center;
    final title = Text(
      l.starAskTitle,
      textAlign: align,
      style: card ? text.titleLarge : text.headlineMedium,
    );
    final later = OutlinedButton(
      onPressed: onLater,
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        side: BorderSide(color: p.line2, width: VhThemeX.of(context).hairline),
        foregroundColor: p.ink,
        minimumSize: Size(
          card ? 0 : VhSpace.xxl * 8,
          card ? VhDensity.desktop.iconButton : _pillHeight,
        ),
        textStyle: text.labelLarge,
      ),
      child: Text(l.starAskLater),
    );
    final never = TextButton(
      onPressed: onNever,
      style: TextButton.styleFrom(
        foregroundColor: p.ink3,
        textStyle: text.labelMedium,
      ),
      child: Text(l.starAskNever),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: card
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.center,
      children: [
        if (card)
          Row(
            children: [
              Expanded(child: title),
              IconButton(
                tooltip: l.starAskLater,
                onPressed: onLater,
                visualDensity: VisualDensity.compact,
                icon: VhIcon(VhIcons.close, size: VhSpace.lg, color: p.ink3),
              ),
            ],
          )
        else
          title,
        const SizedBox(height: VhSpace.xs),
        Text(
          l.starAskBody,
          textAlign: align,
          style: text.bodyMedium?.copyWith(color: p.ink2, height: 1.7),
        ),
        SizedBox(height: card ? VhSpace.md : VhSpace.xl),
        DecoratedBox(
          decoration: BoxDecoration(
            color: p.cardAlt,
            borderRadius: BorderRadius.circular(
              card ? VhRadius.field : VhRadius.card,
            ),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                _Link(
                  icon: VhIcons.star,
                  color: p.accentInk,
                  label: l.starAskStar,
                  card: card,
                  onTap: onStar,
                ),
                Divider(height: 1, indent: VhSpace.lg, endIndent: VhSpace.lg),
                _Link(
                  icon: VhIcons.bug,
                  color: p.ink2,
                  label: l.starAskIdeas,
                  card: card,
                  onTap: onIdeas,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: card ? VhSpace.md : VhSpace.xl),
        if (card)
          Row(
            children: [
              later,
              const SizedBox(width: VhSpace.sm),
              Flexible(child: never),
            ],
          )
        else ...[
          later,
          const SizedBox(height: VhSpace.xs),
          never,
        ],
      ],
    );
  }
}

/// One way out to GitHub: its glyph, what it does, and the mark of a page
/// that opens in the browser.
class _Link extends StatelessWidget {
  const _Link({
    required this.icon,
    required this.color,
    required this.label,
    required this.card,
    required this.onTap,
  });

  final VhIconData icon;
  final Color color;
  final String label;
  final bool card;
  final VoidCallback onTap;

  /// A row tall enough for a thumb on the phone, a little above the
  /// computer's own rows in the card.
  static const double _height = 56;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return Semantics(
      link: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: card ? VhDensity.desktop.row + VhSpace.xs : _height,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: card ? VhSpace.md : VhSpace.lg,
              vertical: VhSpace.xs,
            ),
            child: Row(
              children: [
                VhIcon(
                  icon,
                  size: card ? VhSpace.xl : VhSpace.xl + 2,
                  color: color,
                ),
                SizedBox(width: card ? VhSpace.sm : VhSpace.md),
                Expanded(
                  child: Text(
                    label,
                    style: (card ? text.bodyMedium : text.bodyLarge)?.copyWith(
                      color: p.ink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: VhSpace.sm),
                VhIcon(
                  VhIcons.external,
                  size: VhDensity.desktop.icon,
                  color: p.ink3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
