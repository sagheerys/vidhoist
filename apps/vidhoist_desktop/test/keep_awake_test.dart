import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_desktop/data/keep_awake_data.dart';
import 'package:vidhoist_desktop/data/taskbar_data.dart';
import 'package:vidhoist_desktop/di.dart';

class _Port implements SleepPort {
  final calls = <bool>[];

  @override
  void holdOffSleep(bool on) => calls.add(on);
}

/// A link sent from the phone stopped halfway when Windows slept: the app
/// holds off sleep while something downloads, and only then.
void main() {
  test('**the guard**: held while downloading, let go when done, off, or '
      'closed', () async {
    final port = _Port();
    final downloading = StateProvider<int>((ref) => 0);
    final container = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        sleepPortProvider.overrideWithValue(port),
        taskbarDownloadsProvider.overrideWith(
          (ref) => (count: ref.watch(downloading), progress: null),
        ),
      ],
    );
    container.read(keepAwakeWiringProvider);
    // The saved setting arrives after the first read.
    await Future<void>.delayed(Duration.zero);
    expect(port.calls, [false]);

    container.read(downloading.notifier).state = 2;
    container.read(keepAwakeWiringProvider);
    await Future<void>.delayed(Duration.zero);
    expect(port.calls.last, isTrue);

    container.read(downloading.notifier).state = 0;
    await Future<void>.delayed(Duration.zero);
    expect(port.calls.last, isFalse);

    container.read(downloading.notifier).state = 1;
    await Future<void>.delayed(Duration.zero);
    expect(port.calls.last, isTrue);
    await container.read(keepAwakeProvider.notifier).set(false);
    await Future<void>.delayed(Duration.zero);
    expect(port.calls.last, isFalse);

    await container.read(keepAwakeProvider.notifier).set(true);
    await Future<void>.delayed(Duration.zero);
    expect(port.calls.last, isTrue);
    container.dispose();
    expect(port.calls.last, isFalse);
  });

  test('on unless the owner turned it off', () async {
    final store = MemoryKeyValueStore();
    final container = ProviderContainer(
      overrides: [keyValueStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    expect(container.read(keepAwakeProvider), isTrue);
    await container.read(keepAwakeProvider.notifier).set(false);
    expect(await store.getBool(keepAwakeKey), isFalse);
  });
}
