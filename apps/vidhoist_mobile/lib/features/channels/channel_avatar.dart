import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';

/// A channel's round picture, or its first letter on the accent until a
/// check brings the picture, and wherever the site has none.
class ChannelAvatar extends StatelessWidget {
  const ChannelAvatar({super.key, required this.sub, this.size = 48});

  final ChannelSubscription sub;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = MTThemeX.of(context).palette;
    final letter = Container(
      color: p.accentSoft,
      alignment: Alignment.center,
      child: Text(
        sub.name.trim().characters.firstOrNull?.toUpperCase() ?? '',
        style: TextStyle(
          fontSize: size * 0.42,
          fontWeight: FontWeight.w700,
          color: p.accentInk,
          height: 1,
        ),
      ),
    );
    final url = sub.avatarUrl;
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: p.line, width: MTThemeX.of(context).hairline),
      ),
      child: url == null
          ? letter
          : CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              // A 900-pixel square drawn at 48: decoded at the size shown.
              memCacheWidth: (size * MediaQuery.devicePixelRatioOf(context))
                  .round(),
              placeholder: (_, _) => letter,
              errorWidget: (_, _, _) => letter,
            ),
    );
  }
}
