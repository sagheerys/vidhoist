import 'info_json.dart';

/// What a followed channel offers, read from a flat listing
/// (`CommandBuilder.playlist`).
class ChannelFeed {
  const ChannelFeed({
    required this.id,
    required this.name,
    required this.entries,
  });

  /// The listing as yt-dlp printed it.
  ///
  /// A channel's front page comes as its tabs (videos, live, Shorts), each
  /// a list of its own: their clips are gathered here in order, newest
  /// first within each tab, and a clip found under two tabs counts once.
  factory ChannelFeed.of(InfoJson info) {
    final raw = info.raw;
    final seen = <String>{};
    final entries = <FlatEntry>[];
    void gather(InfoJson list) {
      for (final e in list.entries) {
        if (seen.add(e.id)) entries.add(e);
      }
    }

    gather(info);
    if (raw['entries'] case final List tabs) {
      for (final tab in tabs) {
        if (tab is Map<String, Object?> && tab['_type'] == 'playlist') {
          gather(InfoJson.fromMap(tab));
        }
      }
    }
    String? text(String key) => switch (raw[key]) {
      final String s when s.trim().isNotEmpty => s.trim(),
      _ => null,
    };
    return ChannelFeed(
      // The channel's own id outlives a renamed handle or a link pasted in
      // another form.
      id: text('channel_id') ?? text('uploader_id') ?? info.id ?? '',
      // "NASA", not the tab's "NASA - Videos".
      name: text('channel') ?? info.uploader ?? info.title ?? '',
      entries: entries,
    );
  }

  final String id;
  final String name;
  final List<FlatEntry> entries;
}

final _youTubeChannel = RegExp(
  r'^https?://(?:www\.|m\.)?youtube\.com/'
  r'(@[^/?#]+|channel/[^/?#]+|c/[^/?#]+|user/[^/?#]+)/?(?:[?#].*)?$',
  caseSensitive: false,
);

/// The link a channel is followed by: a YouTube channel's front page
/// becomes its videos tab, since following means its new videos, and the
/// front page also lists its Shorts and live streams, which would flood
/// the folder. A tab or any other link is kept as pasted, so whoever
/// wants the Shorts follows `/shorts`.
String channelFeedUrl(String url) {
  final trimmed = url.trim();
  final match = _youTubeChannel.firstMatch(trimmed);
  if (match == null) return trimmed;
  return 'https://www.youtube.com/${match.group(1)}/videos';
}
