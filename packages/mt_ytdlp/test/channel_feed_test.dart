import 'package:mt_ytdlp/mt_ytdlp.dart';
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
