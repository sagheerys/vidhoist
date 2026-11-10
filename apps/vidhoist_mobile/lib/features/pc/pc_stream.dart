import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';

import '../../di.dart';
import '../downloads_library/library_providers.dart';
import '../player/playback_providers.dart';
import 'pc_link_state.dart';

/// The proxy the phone's player opens for a clip on the computer, started
/// on the first such clip and kept for the run. It reads the link as it is
/// at each request, so a route changed mid-clip is taken at the next seek.
final pcStreamProxyProvider = Provider<PcStreamProxy>((ref) {
  final proxy = PcStreamProxy(() => ref.read(pcClientProvider));
  ref.onDispose(() => unawaited(proxy.stop()));
  return proxy;
});

/// The resolver's stream source: a computer clip's name becomes the
/// proxy's address, and **any other name stays unplayable**, as before, so
/// a phone file deleted from outside is still "not there" rather than an
/// address that fails.
ServerStreamEndpoint pcStreamEndpoint(PcStreamProxy proxy) =>
    ServerStreamEndpoint(
      buildUrl: (name) {
        final id = PcStreamProxy.idOf(name);
        final url = id == null ? null : proxy.urlFor(id);
        if (url == null) throw const UnsafeFilenameException();
        return url.toString();
      },
      headers: const {},
    );

/// A computer clip as the players take it. Its key is the clip's web link
/// when the computer gave it, so a resume position, and a copy on the phone,
/// are the same clip's; [onPhone] is that copy's path, which the golden
/// rule then plays instead of the network.
PlaylistItem pcPlaylistItem(PcItem item, {String? onPhone}) => PlaylistItem(
  canonicalUrl: item.url ?? '${PcStreamProxy.prefix}${item.id}',
  title: item.title,
  uploader: item.uploader,
  artworkUrl: item.thumbnail,
  localPath: onPhone,
  serverFilename: '${PcStreamProxy.prefix}${item.id}',
  isAudio: item.isAudio,
  duration: item.duration,
);

/// Where each computer clip already copied to the phone is, by its link.
Map<String, String> pcCopiesOnPhone(WidgetRef ref) => {
  for (final local in ref.read(localMediaProvider).valueOrNull ?? const [])
    ?local.canonicalUrl: local.path,
};

/// Plays [tapped] from the computer's list [items], in their order, as the
/// library plays its own: audio in the background, a video in the player.
Future<void> playFromPc(
  BuildContext context,
  WidgetRef ref,
  List<PcItem> items,
  PcItem tapped,
) async {
  final proxy = ref.read(pcStreamProxyProvider);
  await proxy.start();
  ref.read(playbackResolverProvider).endpoint = pcStreamEndpoint(proxy);
  final copies = pcCopiesOnPhone(ref);
  final queue = [
    for (final item in items) pcPlaylistItem(item, onPhone: copies[item.url]),
  ];
  final index = items.indexWhere((i) => i.id == tapped.id);
  if (index < 0) return;
  if (tapped.isAudio) {
    await ref.read(audioHandlerProvider).playItems(queue, startIndex: index);
    return;
  }
  ref.read(playbackRequestProvider.notifier).state = PlaybackRequest(
    items: queue,
    startIndex: index,
  );
  if (!context.mounted) return;
  unawaited(context.push('/player'));
}
