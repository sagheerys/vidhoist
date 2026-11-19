import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_transcripts/vh_transcripts.dart';
import 'package:vh_ui/vh_ui.dart';

import '../downloads_library/artwork_view.dart';
import '../downloads_library/library_providers.dart';
import '../downloads_library/local_item.dart';
import 'said_index.dart';
import 'said_moment.dart';

/// The clips in which the library's search words were **said**, with the
/// moments they were said at. Over the whole library, whatever chip is
/// chosen: a word is looked for in everything, as a title is not.
final saidResultsProvider = Provider<List<(LocalItem, ClipHits)>>((ref) {
  final query = ref.watch(libraryViewProvider.select((o) => o.query));
  if (query.trim().isEmpty) return const [];
  ref.watch(saidRevisionProvider);
  final index = ref.watch(saidIndexProvider).valueOrNull;
  final library = ref.watch(localMediaProvider).valueOrNull;
  if (index == null || library == null) return const [];

  final byKey = {for (final item in library) item.key: item};
  return [
    for (final clip in index.search(
      query,
      perClip: SaidResultsSliver.maxMoments,
    ))
      if (byKey[clip.canonicalUrl] case final item?) (item, clip),
  ].take(SaidResultsSliver.maxClips).toList();
});

/// Below the library's title matches: the clips in which the searched
/// words were said, each with the moments they were said at.
class SaidResultsSliver extends ConsumerWidget {
  const SaidResultsSliver({super.key});

  /// Enough to scan on a phone; a query this common is better narrowed.
  static const maxClips = 20;

  /// Moments shown per clip; the rest are counted under them.
  static const maxMoments = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(saidResultsProvider);
    if (results.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    final query = ref.watch(libraryViewProvider.select((o) => o.query));
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: VhSpace.pagePad),
      sliver: SliverList.list(
        children: [
          const SizedBox(height: VhSpace.lg),
          VhSectionHeader(title: context.vhl.transcriptsSaidInside),
          for (final (item, clip) in results)
            _ClipMoments(item: item, clip: clip, query: query),
        ],
      ),
    );
  }
}

class _ClipMoments extends StatelessWidget {
  const _ClipMoments({
    required this.item,
    required this.clip,
    required this.query,
  });

  final LocalItem item;
  final ClipHits clip;
  final String query;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final p = VhThemeX.of(context).palette;
    final (titleDirection, titleAlign) = vhForeignLine(context, item.title);
    final more = clip.total - clip.hits.length;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: VhSpace.sm),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: p.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // **Which clip, at a glance**: titles alone read alike in a
              // long list of results. Beside the title rather than above
              // it, so the moments below keep their place.
              _Thumb(item: item),
              const SizedBox(width: VhSpace.sm),
              Expanded(
                child: Text(
                  item.title,
                  textDirection: titleDirection,
                  textAlign: titleAlign,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          for (final hit in clip.hits)
            SaidMomentRow(
              item: item,
              start: hit.start,
              text: hit.text,
              next: hit.next,
              query: query,
            ),
          if (more > 0)
            Padding(
              padding: const EdgeInsets.only(top: VhSpace.xs),
              child: Text(
                context.vhl.transcriptSaidMore(more),
                style: text.bodySmall!.copyWith(color: p.ink3),
              ),
            ),
        ],
      ),
    );
  }
}

/// The clip's picture beside its title, the size of a line of text.
class _Thumb extends StatelessWidget {
  const _Thumb({required this.item});

  final LocalItem item;

  static const width = 64.0;
  static const height = 36.0;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final picture = artworkFor(
      item.thumbnail,
      decodeWidth: vhDecodeWidth(context, width, height),
    );
    return VhMediaThumb(
      width: width,
      height: height,
      child:
          picture ??
          VhIcon(
            item.isAudio ? VhIcons.music : VhIcons.video,
            size: 16,
            color: p.ink3,
          ),
    );
  }
}
