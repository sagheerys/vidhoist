import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_transcripts/vh_transcripts.dart';
import 'package:vidhoist_desktop/data/backup_data.dart';
import 'package:vidhoist_desktop/data/channels_data.dart';
import 'package:vidhoist_desktop/data/engine_data.dart';
import 'package:vidhoist_desktop/data/transcripts_data.dart';
import 'package:vidhoist_desktop/di.dart';

Map<String, Object?> _feed(String name) => {
  '_type': 'playlist',
  'channel': name,
  'channel_id': 'UC_$name',
  'entries': [
    {'id': '${name}1', 'url': 'https://www.youtube.com/watch?v=${name}1'},
  ],
};

/// **A restore brings the followed channels back, at once and for good**,
/// as on the phone: the channels' source keeps what it read in memory, so
/// reloading the list alone showed the channels of before the restore, and
/// the source's next change wrote them over the restored ones.
void main() {
  late Directory root;
  late FakeBackend backend;
  late ProviderContainer c;

  setUp(() {
    root = Directory.systemTemp.createTempSync('vh_restore_channels_');
    backend = FakeBackend()
      ..listings['https://www.youtube.com/@Some/videos'] = _feed('Some')
      ..listings['https://www.youtube.com/@Other/videos'] = _feed('Other');
    c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        backupFolderProvider.overrideWithValue(
          Directory('${root.path}/backup'),
        ),
        transcriptStoreProvider.overrideWithValue(
          TranscriptStore(Directory('${root.path}/transcripts')),
        ),
        downloadBackendProvider.overrideWithValue(backend),
      ],
    );
  });
  tearDown(() {
    c.dispose();
    root.deleteSync(recursive: true);
  });

  test('**the guard**: the restored channel is listed at once, and the next '
      'follow keeps it', () async {
    final old = MemoryKeyValueStore();
    await LocalChannelSource(
      store: old,
      backend: backend,
      enqueue: (_, _, _) {},
    ).follow(
      'https://www.youtube.com/@Some',
      Quality.best,
      checkIntervalMinutes: 60,
    );
    final backup = await BackupService(
      store: old,
      mutex: PrefsMutex(),
      variant: 'desktop',
    ).exportToString();

    // The page has read the channels: none yet.
    expect((await c.read(channelsProvider.future)).subscriptions, isEmpty);

    await c.read(backupsProvider).restoreText(backup);
    final shown = (await c.read(channelsProvider.future)).subscriptions!;
    expect([for (final s in shown) s.name], ['Some']);

    await c
        .read(channelSourceProvider)!
        .follow(
          'https://www.youtube.com/@Other',
          Quality.best,
          checkIntervalMinutes: 60,
        );
    final kept = await c.read(channelSourceProvider)!.list();
    expect([for (final s in kept) s.name]..sort(), ['Other', 'Some']);
  });
}
