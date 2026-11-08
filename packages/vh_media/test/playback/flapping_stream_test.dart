import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart';

import 'fake_player_port.dart';

/// **A stream that loads and then drops, over and over.**
///
/// Retrying a dropped stream was the right answer to a hiccup. The budget
/// for it, though, was returned by any **successful load** — and a tunnel,
/// a failing disk or a source under load produces the one pattern that
/// defeats that: load, play a second, drop. Each failure was answered by a
/// retry and each retry refilled the budget, so the pair repeated for
/// ever, holding a wake lock and hammering the source, with nothing on
/// screen to say anything was wrong.
///
/// The budget now comes back for **playing**, not for loading.
PlaylistItem _item(String id) => PlaylistItem(
  canonicalUrl: 'https://x/$id',
  title: id,
  serverFilename: '$id.mp3',
  isAudio: true,
);

void main() {
  late FakePlayerPort player;
  late MemoryKeyValueStore store;
  late PrefsMutex mutex;
  late VhAudioHandler handler;

  String streamOf(String id) => 'https://srv/download/$id.mp3';

  VhAudioHandler build() {
    player = FakePlayerPort();
    return VhAudioHandler(
      player: player,
      resolver: PlaybackSourceResolver(
        endpoint: ServerStreamEndpoint(
          buildUrl: (name) => 'https://srv/download/$name',
          headers: const {'Authorization': 'Basic k'},
        ),
        fileExists: (_) => false,
      ),
      positions: PlaybackPositionStore(store: store, mutex: mutex),
      prefs: PlaybackPrefs(store: store, mutex: mutex),
      stateStore: AudioStateStore(store: store, mutex: mutex),
      saveInterval: const Duration(hours: 1),
      networkRetryBackoff: const [Duration.zero, Duration.zero],
      pausedAutoStop: const Duration(hours: 1),
    );
  }

  setUp(() {
    store = MemoryKeyValueStore();
    mutex = PrefsMutex();
  });

  tearDown(() => handler.dispose());

  /// One drop of a stream that is playing happily: the player reports an
  /// error, and the load that follows succeeds.
  Future<void> drop() async {
    player.emitError(Exception('connection reset'));
    await pumpEventQueue();
  }

  test('a stream that keeps dropping without playing runs out of retries '
      'and the queue moves on', () async {
    handler = build();
    await handler.playItems([_item('a'), _item('b')]);
    expect(player.loaded.single.uri.toString(), streamOf('a'));

    // Three drops: two are inside the budget, the third is not.
    await drop();
    await drop();
    await drop();

    expect(
      handler.currentItem?.canonicalUrl,
      'https://x/b',
      reason: 'على الكود القديم كان كل تحميل ناجح يعيد الرصيد فلا ينتهي أبداً',
    );
    // Two retries of 'a', then 'b'.
    expect(player.loaded.map((s) => s.uri.toString()), [
      streamOf('a'),
      streamOf('a'),
      streamOf('a'),
      streamOf('b'),
    ]);
  });

  test('but a clip that actually played gets its retries back, so a hiccup '
      'an hour in is still waited for', () async {
    handler = build();
    await handler.playItems([_item('a'), _item('b')]);

    await drop();
    await drop();
    // It recovered and played on.
    player.position = VhAudioHandler.retryBudgetProgress * 2;
    await drop();
    await drop();

    expect(
      handler.currentItem?.canonicalUrl,
      'https://x/a',
      reason: 'تقدُّمٌ حقيقي يعني عطلاً جديداً لا العطل نفسه يتكرر',
    );
  });

  test('progress shorter than the threshold is not progress', () async {
    handler = build();
    await handler.playItems([_item('a'), _item('b')]);

    await drop();
    player.position =
        VhAudioHandler.retryBudgetProgress - const Duration(seconds: 1);
    await drop();
    await drop();

    expect(handler.currentItem?.canonicalUrl, 'https://x/b');
  });

  test('the budget belongs to the item: what one clip spent is not owed by '
      'the next one', () async {
    handler = build();
    await handler.playItems([_item('a'), _item('b')]);

    // 'a' spends one retry and survives, then the listener moves on by
    // hand — which is the case the queue's own skip does not cover,
    // because giving up on an item clears the count anyway.
    await drop();
    await handler.skipToNext();
    expect(handler.currentItem?.canonicalUrl, 'https://x/b');

    // 'b' should now have its **whole** budget: two drops are survivable.
    await drop();
    await drop();

    expect(
      handler.currentItem?.canonicalUrl,
      'https://x/b',
      reason: 'ولو ورث b ما أنفقه a لسقط من أول انقطاعين',
    );
  });
}
