/// One of a followed channel's newest clips, as its last check listed it:
/// enough for the page to show what the channel posts, and to download
/// one of them by hand.
class ChannelClip {
  const ChannelClip({
    required this.id,
    required this.url,
    this.title,
    this.thumbnail,
    this.duration,
    this.published,
  });

  final String id;
  final String url;
  final String? title;
  final String? thumbnail;
  final Duration? duration;
  final DateTime? published;

  Map<String, Object?> toJson() => {
    'id': id,
    'url': url,
    if (title != null) 'title': title,
    if (thumbnail != null) 'thumb': thumbnail,
    if (duration != null) 'seconds': duration!.inSeconds,
    if (published != null) 'at': published!.millisecondsSinceEpoch,
  };

  /// Null for a row without an id or a link.
  static ChannelClip? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final id = raw['id'];
    final url = raw['url'];
    if (id is! String || id.isEmpty || url is! String || url.isEmpty) {
      return null;
    }
    String? text(String key) => switch (raw[key]) {
      final String s when s.isNotEmpty => s,
      _ => null,
    };
    return ChannelClip(
      id: id,
      url: url,
      title: text('title'),
      thumbnail: text('thumb'),
      duration: switch (raw['seconds']) {
        final int s when s > 0 => Duration(seconds: s),
        _ => null,
      },
      published: switch (raw['at']) {
        final int ms => DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true),
        _ => null,
      },
    );
  }
}
