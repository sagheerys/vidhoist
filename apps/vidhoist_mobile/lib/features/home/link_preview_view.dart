import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart' show vhFormatDuration;
import 'package:vh_ui/vh_ui.dart';

import '../downloads_library/artwork_view.dart';

/// The public-oEmbed resolver; a provider so tests answer for it.
final linkPreviewResolverProvider = Provider<ClipPreviewResolver>(
  (ref) => ClipPreviewResolver(),
);

/// One preview per link, dropped once the sheet closes or the link changes.
final linkPreviewProvider = FutureProvider.autoDispose
    .family<ClipPreview?, String>(
      (ref, url) => ref.read(linkPreviewResolverProvider).resolve(url),
    );

/// **The add sheet's preview** (mobile plan 2026-11-01): grey blocks while
/// it comes, the clip once it does, and nothing for a playlist, a platform
/// with no public endpoint, or no answer within the resolver's timeout.
/// The download never waits for it. Pictures come from the platform's own
/// servers, so they go with no headers at all.
Widget? linkPreviewFor(WidgetRef ref, String text) {
  final url = UrlKit.extractUrl(text);
  if (!url.startsWith('http') || PlaylistDetector.isPlaylist(url)) return null;
  if (!ClipPreviewResolver.supports(url)) return null;
  String? meta(ClipPreview preview) {
    final line = vhMetaLine([
      preview.author,
      if (preview.duration case final length?) vhFormatDuration(length),
    ]);
    return line.isEmpty ? null : line;
  }

  return switch (ref.watch(linkPreviewProvider(url))) {
    AsyncData(value: final preview?) => VhLinkPreview(
      thumbnail: artworkFor(preview.thumbnail, decodeWidth: 200),
      title: preview.title,
      subtitle: meta(preview),
    ),
    AsyncLoading() => const VhLinkPreview(loading: true),
    _ => null,
  };
}
