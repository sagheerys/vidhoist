import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';

/// The download choices both apps save under one set of keys, so a backup
/// moves them between the phone and the computer.
void main() {
  test('nothing saved reads as the defaults', () async {
    final choices = await DownloadChoices.load(MemoryKeyValueStore());
    expect(choices.audioFormat, AudioFormat.m4a);
    expect(choices.rateLimit, isNull);
    expect(choices.fastStreams, isFalse);
    expect(choices.subtitleLangs, isNull);
    expect(choices.embedSubtitles, isFalse);
  });

  test('what was saved is read back', () async {
    final store = MemoryKeyValueStore();
    await store.setString(DownloadChoices.audioFormatKey, 'mp3');
    await store.setString(DownloadChoices.rateLimitKey, '2M');
    await store.setBool(DownloadChoices.fastStreamsKey, true);
    await store.setStringList(DownloadChoices.subtitleLangsKey, ['fr', 'ar']);
    await store.setBool(DownloadChoices.embedSubtitlesKey, true);
    final choices = await DownloadChoices.load(store);
    expect(choices.audioFormat, AudioFormat.mp3);
    expect(choices.rateLimit, '2M');
    expect(choices.fastStreams, isTrue);
    expect(choices.subtitleLangs, ['fr', 'ar']);
    expect(choices.embedSubtitles, isTrue);
  });

  test('what a later build no longer offers reads as unset', () async {
    final store = MemoryKeyValueStore();
    await store.setString(DownloadChoices.audioFormatKey, 'flac');
    await store.setString(DownloadChoices.rateLimitKey, '3M');
    await store.setStringList(DownloadChoices.subtitleLangsKey, ['xx']);
    final choices = await DownloadChoices.load(store);
    expect(choices.audioFormat, AudioFormat.m4a);
    expect(choices.rateLimit, isNull);
    expect(choices.subtitleLangs, isNull);
  });

  test('the tuning: fast streams are four pieces, and nothing is embedded '
      'without subtitles', () {
    const choices = DownloadChoices(fastStreams: true, embedSubtitles: true);
    expect(choices.tuning(subtitles: true).concurrentFragments, 4);
    expect(choices.tuning(subtitles: true).embedSubtitles, isTrue);
    expect(choices.tuning(subtitles: false).embedSubtitles, isFalse);
    expect(
      const DownloadChoices().tuning(subtitles: true).concurrentFragments,
      isNull,
    );
  });

  test('a language toggles, and the last one stays', () {
    expect(DownloadChoices.toggled(['ar'], 'en'), ['ar', 'en']);
    expect(DownloadChoices.toggled(['ar', 'en'], 'ar'), ['en']);
    expect(DownloadChoices.toggled(['en'], 'en'), ['en']);
  });

  test('every language offered is one yt-dlp can be asked for', () {
    for (final code in subtitleLanguageNames.keys) {
      expect(code, matches(RegExp(r'^[a-z]{2}$')), reason: code);
    }
  });
}
