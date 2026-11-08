import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';

import 'channel_art.dart';

/// A channel's round picture, kept on the phone ([ChannelArt]), or its
/// first letter on the accent until one is kept, and wherever the site
/// has none.
class ChannelAvatar extends ConsumerWidget {
  const ChannelAvatar({super.key, required this.sub, this.size = 48});

  final ChannelSubscription sub;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final file = ref
        .watch(
          channelArtFileProvider(channelArtKey(sub, ChannelArtKind.avatar)),
        )
        .valueOrNull;
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: p.line, width: MTThemeX.of(context).hairline),
      ),
      child: file == null
          ? letter
          : Image.file(
              file,
              fit: BoxFit.cover,
              // A 900-pixel square drawn at 48: decoded at the size shown.
              cacheWidth: (size * MediaQuery.devicePixelRatioOf(context))
                  .round(),
              errorBuilder: (_, _, _) => letter,
            ),
    );
  }
}
