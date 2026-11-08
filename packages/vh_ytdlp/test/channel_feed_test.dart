import 'package:vh_ytdlp/vh_ytdlp.dart';
import 'package:test/test.dart';

import 'fixtures.dart';

/// Recorded 2026-11-07 with `-J --flat-playlist --playlist-end 5`, the
/// thumbnails taken out.
void main() {
  group('a channel\'s videos tab', () {
    final feed = ChannelFeed.of(
      InfoJson.parse(fixture('channel-videos.stdout.txt')),
    );

    test('the channel\'s own name and id, not the tab\'s', () {
      expect(feed.name, 'NASA');
      expect(feed.id, 'UCLA_DiR1FfKNvjuUpBHmylQ');
    });

    test('its clips, newest first, each with a link to download', () {
      expect(feed.entries, hasLength(5));
      expect(feed.entries.first.id, '61S764A-TKo');
      expect(
        feed.entries.first.url,
        'https://www.youtube.com/watch?v=61S764A-TKo',
      );
      expect(feed.entries.first.title, 'Apply to Become A NASA Astronaut');
      expect(feed.entries.every((e) => !e.isPending), isTrue);
    });
  });

  group('a channel\'s front page', () {
    final feed = ChannelFeed.of(
      InfoJson.parse(fixture('channel-tabs.stdout.txt')),
    );

    test('the clips of every tab are gathered', () {
      // Videos, Live and Shorts, five each.
      expect(feed.entries, hasLength(15));
      expect(feed.name, 'NASA');
      expect(feed.id, 'UCLA_DiR1FfKNvjuUpBHmylQ');
    });

    test('a stream on the air or not begun is pending', () {
      final pending = feed.entries.where((e) => e.isPending).map((e) => e.id);
      expect(pending, ['MRg4uIpJ3xE', 'ROboUHfPUrU', 'M3HKLzjvKPc']);
      final over = feed.entries.firstWhere((e) => e.id == '25JEQqgv5I4');
      expect(over.liveStatus, 'was_live');
      expect(over.isPending, isFalse);
    });
  });

  test("a clip's link names its channel, to follow it by", () {
    // The channel fields of a real listing of one clip; the rest of its
    // eleven megabytes (formats, links) is left out.
    final feed = ChannelFeed.of(
      InfoJson.parse(fixture('channel-clip.stdout.txt')),
    );
    expect(feed.isClip, isTrue);
    expect(feed.channelUrl, 'https://www.youtube.com/@NASA');
    expect(feed.entries, isEmpty);

    final list = ChannelFeed.of(
      InfoJson.parse(fixture('channel-videos.stdout.txt')),
    );
    expect(list.isClip, isFalse);
  });

  test('a clip listed under two tabs counts once', () {
    final feed = ChannelFeed.of(
      InfoJson.parse('''
{"_type": "playlist", "channel": "C", "channel_id": "UC1", "entries": [
  {"_type": "playlist", "entries": [
    {"id": "a", "url": "https://www.youtube.com/watch?v=a"}]},
  {"_type": "playlist", "entries": [
    {"id": "a", "url": "https://www.youtube.com/watch?v=a"},
    {"id": "b", "url": "https://www.youtube.com/watch?v=b"}]}]}
'''),
    );
    expect(feed.entries.map((e) => e.id), ['a', 'b']);
  });

  group('what a channel looks like', () {
    // The shape yt-dlp 2026.10.26 gives a channel's listing, the addresses
    // made up.
    final feed = ChannelFeed.of(
      InfoJson.fromMap({
        '_type': 'playlist',
        'channel': 'Some',
        'channel_id': 'UC_some',
        'channel_follower_count': 1234567,
        'thumbnails': [
          {'url': 'https://img.test/banner-1060', 'width': 1060, 'height': 175},
          {'url': 'https://img.test/banner-1138', 'width': 1138, 'height': 188},
          {'url': 'https://img.test/banner-2560', 'width': 2560, 'height': 424},
          {'url': 'https://img.test/banner-full', 'id': 'banner_uncropped'},
          {'url': 'https://img.test/avatar-900', 'width': 900, 'height': 900},
          {'url': 'https://img.test/avatar-full', 'id': 'avatar_uncropped'},
        ],
        'entries': [
          {
            'id': 'a',
            'url': 'https://www.youtube.com/watch?v=a',
            'title': 'A',
            'timestamp': 1762560000,
            'thumbnails': [
              {'url': 'https://img.test/a-360', 'width': 360, 'height': 202},
              {'url': 'https://img.test/a-720', 'width': 720, 'height': 404},
              {'url': 'https://img.test/a-1280', 'width': 1280, 'height': 720},
            ],
          },
          {
            'id': 'b',
            'url': 'https://www.youtube.com/watch?v=b',
            'thumbnail': 'https://img.test/b',
          },
          {'id': 'c', 'url': 'https://www.youtube.com/watch?v=c'},
        ],
      }),
    );

    test('its square picture and its widest banner a phone needs', () {
      expect(feed.avatarUrl, 'https://img.test/avatar-900');
      expect(feed.bannerUrl, 'https://img.test/banner-1138');
      expect(feed.followers, 1234567);
    });

    test('each clip its frame at 720 at most, and its date', () {
      final [a, b, c] = feed.entries;
      expect(a.thumbnail, 'https://img.test/a-720');
      expect(a.published, DateTime.utc(2025, 11, 8));
      expect(b.thumbnail, 'https://img.test/b', reason: 'the single field');
      expect(c.thumbnail, isNull);
      expect(c.published, isNull);
    });

    test('a site without pictures has none, not a wrong one', () {
      final bare = ChannelFeed.of(
        InfoJson.fromMap({
          '_type': 'playlist',
          'title': 'Bare',
          'thumbnail': 'https://img.test/a-frame',
          'entries': [],
        }),
      );
      expect(bare.avatarUrl, isNull, reason: 'a frame is not an avatar');
      expect(bare.bannerUrl, isNull);
      expect(bare.followers, isNull);
    });
  });

  group('the link a channel is followed by', () {
    test('a YouTube front page becomes its videos tab', () {
      for (final url in [
        'https://www.youtube.com/@NASA',
        'https://youtube.com/@NASA/',
        'https://m.youtube.com/@NASA?si=x',
        'https://www.youtube.com/channel/UCLA_DiR1FfKNvjuUpBHmylQ',
        'https://www.youtube.com/c/NASA',
        'https://www.youtube.com/user/NASAtelevision',
      ]) {
        expect(channelFeedUrl(url), endsWith('/videos'), reason: url);
      }
      expect(
        channelFeedUrl(' https://youtube.com/@NASA '),
        'https://www.youtube.com/@NASA/videos',
      );
    });

    test('a tab, a playlist or another site is kept as pasted', () {
      for (final url in [
        'https://www.youtube.com/@NASA/shorts',
        'https://www.youtube.com/@NASA/streams',
        'https://www.youtube.com/playlist?list=PL123',
        'https://soundcloud.com/someone',
      ]) {
        expect(channelFeedUrl(url), url);
      }
    });
  });
}
