import 'package:vh_ytdlp/vh_ytdlp.dart';
import 'package:test/test.dart';

import 'fixtures.dart';

void main() {
  group('a YouTube video', () {
    final info = InfoJson.parse(fixture('probe-json.stdout.txt'));

    test('what the library and the cards show', () {
      expect(info.isPlaylist, isFalse);
      expect(info.id, 'aqz-KE-bpKQ');
      expect(info.title, startsWith('Big Buck Bunny 60fps 4K'));
      expect(info.uploader, 'Blender');
      expect(info.extractor, 'Youtube');
      expect(info.webpageUrl, 'https://www.youtube.com/watch?v=aqz-KE-bpKQ');
      expect(info.thumbnail, contains('aqz-KE-bpKQ'));
      expect(info.duration, const Duration(seconds: 635));
      expect(info.published, DateTime.utc(2014, 11, 10, 14, 5, 55));
      expect(info.isLive, isFalse);
      expect(info.size, 743212891);
    });

    test('the heights offered, highest first', () {
      expect(info.heights.first, 2160);
      expect(info.heights, containsAllInOrder([2160, 1440, 1080, 720, 480]));
      expect(info.heights.toSet().length, info.heights.length);
      expect(info.hasVideo, isTrue);
    });

    test('H.264 exists up to 1080p, not at 2160p alone', () {
      expect(info.offersH264(), isTrue);
      expect(info.offersH264(maxHeight: 1080), isTrue);
      expect(info.offersH264(maxHeight: 100), isFalse);
    });

    test('no subtitles on this one', () {
      expect(info.subtitles, isEmpty);
      expect(info.automaticCaptions, isEmpty);
      expect(info.entries, isEmpty);
    });
  });

  test('a flat channel listing', () {
    final list = InfoJson.parse(fixture('playlist-flat.stdout.txt'));
    expect(list.isPlaylist, isTrue);
    expect(list.title, 'Blender - Videos');
    expect(list.entries, hasLength(5));
    final first = list.entries.first;
    expect(first.title, 'Making of: The Blender Open Movies Exhibition');
    expect(first.url, startsWith('https://www.youtube.com/watch?v='));
    expect(first.id, isNotEmpty);
    expect(first.duration, const Duration(seconds: 280));
  });

  group('tolerant reading', () {
    test('missing and mistyped fields read as absent', () {
      final info = InfoJson.parse(
        '{"id": 5, "title": "", "duration": "long", "timestamp": "x",'
        ' "formats": "none", "subtitles": [], "entries": [{"id": "a"}, 3]}',
      );
      expect(info.id, isNull);
      expect(info.title, isNull);
      expect(info.duration, isNull);
      expect(info.published, isNull);
      expect(info.heights, isEmpty);
      expect(info.subtitles, isEmpty);
      expect(info.entries, isEmpty);
      expect(info.size, isNull);
    });

    test('names fall back the way sites differ', () {
      final info = InfoJson.parse(
        '{"channel": "C", "original_url": "o", "extractor": "generic",'
        ' "upload_date": "20240229", "filesize": 12.6,'
        ' "subtitles": {"ar": [], "live_chat": []},'
        ' "automatic_captions": {"en": []}}',
      );
      expect(info.uploader, 'C');
      expect(info.webpageUrl, 'o');
      expect(info.extractor, 'generic');
      expect(info.published, DateTime(2024, 2, 29));
      expect(info.size, 13);
      expect(info.subtitles, {'ar'});
      expect(info.automaticCaptions, {'en'});
    });

    test('a bad upload date is no date', () {
      expect(InfoJson.parse('{"upload_date": "2024"}').published, isNull);
    });

    test('live and upcoming', () {
      expect(InfoJson.parse('{"live_status": "is_live"}').isLive, isTrue);
      expect(InfoJson.parse('{"live_status": "is_upcoming"}').isLive, isTrue);
      expect(InfoJson.parse('{"is_live": true}').isLive, isTrue);
      expect(InfoJson.parse('{"live_status": "was_live"}').isLive, isFalse);
    });

    test('sound alone has no picture', () {
      final song = InfoJson.parse(
        '{"formats": [{"vcodec": "none", "acodec": "opus"},'
        ' {"acodec": "mp3"}]}',
      );
      expect(song.hasVideo, isFalse);
      expect(song.heights, isEmpty);
      expect(InfoJson.parse('{"vcodec": "none"}').hasVideo, isFalse);
      expect(InfoJson.parse('{"vcodec": "h264"}').hasVideo, isTrue);
    });

    test('what is not an object is refused', () {
      expect(() => InfoJson.parse('[1]'), throwsFormatException);
      expect(() => InfoJson.parse('not json'), throwsFormatException);
    });
  });
}
