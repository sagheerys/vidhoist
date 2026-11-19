import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/home/handled_links.dart';
import 'package:vidhoist_mobile/features/home/reception.dart';

/// The clipboard bar used to keep offering a link that
/// had already been downloaded, on every return to the app and after a
/// restart, and an older clipboard read could overwrite a newer one.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  const copied = 'https://youtu.be/dQw4w9WgXcQ';

  late MemoryKeyValueStore store;
  late List<Completer<String?>> clipboardAnswers;

  setUp(() {
    store = MemoryKeyValueStore();
    clipboardAnswers = [];
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method != 'Clipboard.getData') return null;
      final answer = Completer<String?>();
      clipboardAnswers.add(answer);
      final text = await answer.future;
      return text == null ? null : {'text': text};
    });
  });

  tearDown(
    () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
  );

  final refresh = Provider(
    (ref) =>
        () => refreshClipboardUrl(ref),
  );

  ProviderContainer build() {
    final container = ProviderContainer(
      overrides: [keyValueStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// Reads the clipboard, answering with [text] once the read is waiting.
  Future<void> readClipboard(ProviderContainer container, String? text) async {
    final read = container.read(refresh)();
    await pumpEventQueue();
    clipboardAnswers.last.complete(text);
    await read;
  }

  test('a fresh link in the clipboard is offered', () async {
    final container = build();
    await readClipboard(container, copied);
    expect(container.read(clipboardUrlProvider), copied);
  });

  test('a link already sent is not offered again', () async {
    final container = build();
    await container
        .read(handledLinksProvider)
        .add('https://www.youtube.com/watch?v=dQw4w9WgXcQ&si=abc');

    await readClipboard(container, copied);

    expect(
      container.read(clipboardUrlProvider),
      isNull,
      reason: 'the same clip, written another way',
    );
  });

  test('a link sent before a restart is still not offered', () async {
    await build().read(handledLinksProvider).add(copied);

    final restarted = build();
    await readClipboard(restarted, copied);

    expect(restarted.read(clipboardUrlProvider), isNull);
  });

  test('an older read finishing last does not overwrite a newer one', () async {
    final container = build();
    final older = container.read(refresh)();
    final newer = container.read(refresh)();
    await pumpEventQueue();

    clipboardAnswers[1].complete('https://youtu.be/bbbbbbbbbbb');
    await newer;
    clipboardAnswers[0].complete('https://youtu.be/aaaaaaaaaaa');
    await older;

    expect(container.read(clipboardUrlProvider), contains('bbbbbbbbbbb'));
  });

  test('the list keeps the newest links only', () async {
    final links = build().read(handledLinksProvider);
    for (var i = 0; i < HandledLinks.limit + 5; i++) {
      await links.add('https://example.com/clip/$i');
    }
    final saved = await store.getStringList(HandledLinks.storageKey);
    expect(saved, hasLength(HandledLinks.limit));
    expect(saved!.first, 'https://example.com/clip/${HandledLinks.limit + 4}');
  });

  group('a link given to the download engine', () {
    late ProviderContainer container;
    late LocalDownloadEngine engine;

    setUp(() {
      container = build();
      // Held at its first event: nothing here is about finishing.
      engine = LocalDownloadEngine(
        backend: FakeBackend(hold: true),
        folderFor: (_) => '/downloads',
      );
      final wiring = Provider((ref) => noteSubmittedLinks(ref, engine));
      container.read(wiring);
      addTearDown(engine.dispose);
    });

    test('folds the clipboard bar away when it offers that link', () async {
      await readClipboard(container, copied);
      expect(container.read(clipboardUrlProvider), copied);

      engine.submit(copied, Quality.best);
      await pumpEventQueue();

      expect(container.read(clipboardUrlProvider), isNull);
      expect(container.read(handledLinksProvider).contains(copied), isTrue);
    });

    test('leaves the bar alone when it offers another link', () async {
      await readClipboard(container, copied);

      engine.submit('https://youtu.be/bbbbbbbbbbb', Quality.best);
      await pumpEventQueue();

      expect(container.read(clipboardUrlProvider), copied);
    });
  });
}
