import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import 'vh_polish.dart';

import '../icons/vh_icon.dart';
import '../icons/vh_icons.dart';

/// **A favourite's mark on a phone card**: a small crimson heart before the
/// channel name, a status rather than a button.
///
/// Phones show it instead of an empty heart on every card, which said
/// nothing on most of them and sat where a thumb reaches for play. Toggling
/// moves to the item menu and the players ([VhFavoriteTile],
/// [VhFavoriteButton]). The card's own label already says "favourite" to a
/// screen reader, so the mark is silent.
class VhFavoriteMark extends StatelessWidget {
  const VhFavoriteMark({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(end: VhSpace.xxs),
    child: ExcludeSemantics(
      child: VhIcon(
        VhIcons.favoriteOn,
        size: 12,
        color: VhThemeX.of(context).palette.favorite,
      ),
    ),
  );
}

/// The first row of an item menu: add to or remove from the favourites.
class VhFavoriteTile extends StatelessWidget {
  const VhFavoriteTile({
    super.key,
    required this.favorite,
    required this.onTap,
  });

  final bool favorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l10n = context.vhl;
    return ListTile(
      leading: VhIcon(
        favorite ? VhIcons.favoriteOn : VhIcons.favorite,
        color: favorite ? p.favorite : p.ink2,
      ),
      title: Text(
        favorite ? l10n.removeFromFavorites : l10n.addToFavorites,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: onTap,
    );
  }
}

/// The heart beside a player's title: one tap while listening, the moment
/// someone knows they liked a clip.
class VhFavoriteButton extends StatelessWidget {
  const VhFavoriteButton({
    super.key,
    required this.favorite,
    required this.onPressed,
  });

  final bool favorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final l10n = context.vhl;
    return IconButton(
      tooltip: favorite ? l10n.removeFromFavorites : l10n.addToFavorites,
      onPressed: onPressed,
      icon: VhIconSwap(
        icon: favorite ? VhIcons.favoriteOn : VhIcons.favorite,
        size: 22,
        color: favorite ? p.favorite : p.ink3,
      ),
    );
  }
}
