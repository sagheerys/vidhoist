import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/channels/channel_actions.dart';
import 'package:vidhoist_mobile/features/channels/channel_avatar.dart';
import 'package:vidhoist_mobile/features/channels/channel_card.dart';
import 'package:vidhoist_mobile/features/channels/channels_screen.dart';
import 'package:vidhoist_mobile/features/channels/channels_state.dart';
import 'package:vidhoist_mobile/features/channels/follow_sheet.dart';
import 'package:vidhoist_mobile/features/settings/auto_backup.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';

import 'device_matrix.dart';

const _videos = 'https://www.youtube.com/@Some/videos';

Map<String, Object?> _feed(List<String> ids, {String id = 'UC_some'}) => {
  '_type': 'playlist',
  'channel': 'Some Channel',
  'channel_id': id,
  'channel_follower_count': 1234567,
  'entries': [
    for (final v in ids)
      {
        'id': v,
        'url': 'https://www.youtube.com/watch?v=$v',
        'title': 'Episode $v',
        'duration': 754,
      },
  ],
};

/// **Channels on the phone** (batch 10): followed from Settings, read
/// through the phone's yt-dlp, what is new queued like a pasted link.
void main() {
  late MemoryKeyValueStore store;
  late FakeBackend backend;
  late LocalDownloadEngine engine;
  late _Backups backups;

  setUp(() {
    backups = _Backups();
    store = MemoryKeyValueStore();
    backend = FakeBackend(hold: true)..listings[_videos] = _feed(['a']);
    engine = LocalDownloadEngine(
      backend: backend,
      folderFor: (_) => Directory.systemTemp.path,
    );
  });
  tearDown(() => engine.dispose());

  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        secretStoreProvider.overrideWithValue(MemorySecretStore()),
        prefsMutexProvider.overrideWithValue(PrefsMutex()),
        initialSettingsProvider.overrideWithValue(
          const LiteSettings(quality: Quality.q720),
        ),
        loggerProvider.overrideWithValue(
          MTLogger(filePath: '${Directory.systemTemp.path}/vh_channels.log'),
        ),
        downloadBackendProvider.overrideWithValue(backend),
        downloadEngineProvider.overrideWithValue(engine),
        autoBackupProvider.overrideWithValue(backups),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  Widget app(ProviderContainer c, {String lang = 'en'}) =>
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp(
          theme: mtTheme(MTVariant.lite, Brightness.light),
          locale: Locale(lang),
          localizationsDelegates: MTLocalizations.localizationsDelegates,
          supportedLocales: MTLocalizations.supportedLocales,
          home: const ChannelsScreen(),
        ),
      );

  Future<void> followSome(ProviderContainer c) => c
      .read(channelsControllerProvider)
      .follow(
        'https://www.youtube.com/@Some',
        quality: Quality.q720,
        checkIntervalMinutes: 60,
      );

  test('following queues nothing; a check queues what is new', () async {
    final c = container();
    await followSome(c);
    expect(engine.tasks, isEmpty, reason: 'what was there stays there');

    backend.listings[_videos] = _feed(['b', 'a']);
    await c.read(channelsControllerProvider).checkNow();
    final task = engine.tasks.single;
    expect(task.inputUrl, 'https://www.youtube.com/watch?v=b');
    expect(task.quality, Quality.q720);
    expect(task.folder, isNull, reason: 'the phone keeps one folder');
  });

  testWidgets('nothing followed: the page says what following does', (
    tester,
  ) async {
    await tester.pumpWidget(app(container()));
    await tester.pumpAndSettle();
    expect(find.text('No channels followed yet'), findsOneWidget);
    expect(find.textContaining('in the background'), findsOneWidget);
  });

  testWidgets('**the guard**: the sheet follows a pasted link', (tester) async {
    final c = container();
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Follow a channel'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).first,
      'https://www.youtube.com/@Some',
    );
    await tester.pump();
    final follow = find.widgetWithText(FilledButton, 'Follow');
    await tester.ensureVisible(follow);
    await tester.pumpAndSettle();
    await tester.tap(follow);
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pumpAndSettle();
    expect(backend.listed, [_videos]);
    expect(backups.requests, 1, reason: 'a follow is backed up');
    expect(find.byType(ChannelCard), findsOneWidget);
    expect(find.textContaining('Now following'), findsOneWidget);
  });

  testWidgets('a channel is paused and resumed from its row', (tester) async {
    final c = container();
    await tester.runAsync(() => followSome(c));
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Some Channel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pause'));
    await tester.pumpAndSettle();
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    expect(find.textContaining('Paused'), findsOneWidget);
    final kept = await tester.runAsync(
      () => c.read(channelSourceProvider).list(),
    );
    expect(kept!.single.enabled, isFalse);
  });

  testWidgets('the card: its letter, who follows it, its newest clips', (
    tester,
  ) async {
    final c = container();
    await tester.runAsync(() => followSome(c));
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    final card = find.byType(ChannelCard);
    expect(
      find.descendant(of: card, matching: find.text('S')),
      findsOneWidget,
      reason: 'no picture yet: the first letter',
    );
    expect(find.textContaining('1.23M subscribers'), findsOneWidget);
    expect(find.textContaining('Every hour'), findsOneWidget);
    expect(find.textContaining('Episode a'), findsOneWidget);
    expect(find.text('12:34'), findsOneWidget);
  });

  testWidgets('a tap on a clip downloads it by hand', (tester) async {
    final c = container();
    await tester.runAsync(() => followSome(c));
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Episode a'));
    await tester.pumpAndSettle();
    expect(engine.tasks.single.inputUrl, 'https://www.youtube.com/watch?v=a');
    expect(find.textContaining('Download started'), findsOneWidget);
  });

  testWidgets('its sheet: what it is set to, and unfollow apart', (
    tester,
  ) async {
    final c = container();
    await tester.runAsync(() => followSome(c));
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Some Channel'));
    await tester.pumpAndSettle();
    for (final label in [
      'Check now',
      'Pause',
      'Edit',
      'Open channel',
      'Unfollow',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    await tester.tap(find.text('Unfollow'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget, reason: 'asked first');
  });

  testWidgets('a failed check shows on its row', (tester) async {
    final c = container();
    await tester.runAsync(() async {
      await followSome(c);
      backend.listings[_videos] = const YtDlpError(
        YtDlpErrorKind.network,
        'ERROR: Unable to download webpage',
      );
      await c.read(channelsControllerProvider).checkNow();
    });
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    expect(find.textContaining('Unable to download webpage'), findsOneWidget);
  });

  for (final lang in ['en', 'ar']) {
    testWidgets('fits every phone, $lang, empty and with channels', (
      tester,
    ) async {
      final empty = container();
      await expectNoOverflow(tester, () => app(empty, lang: lang));

      final full = container();
      await tester.runAsync(() async {
        await followSome(full);
        await full
            .read(channelSourceProvider)
            .update('UC_some', titleRegex: 'حلقة|episode');
        await full
            .read(channelSourceProvider)
            .update('UC_some', enabled: false);
      });
      await expectNoOverflow(tester, () => app(full, lang: lang));
    });

    testWidgets('the channel sheet fits every phone, $lang', (tester) async {
      final c = container();
      final sub = await tester.runAsync(() async {
        await followSome(c);
        return (await c.read(channelSourceProvider).list()).single;
      });
      await expectNoOverflow(
        tester,
        () => UncontrolledProviderScope(
          container: c,
          child: MaterialApp(
            theme: mtTheme(MTVariant.lite, Brightness.light),
            locale: Locale(lang),
            localizationsDelegates: MTLocalizations.localizationsDelegates,
            supportedLocales: MTLocalizations.supportedLocales,
            home: _OpensSheet(channel: sub),
          ),
        ),
      );
      expect(find.byType(ChannelAvatar), findsOneWidget);
    });

    testWidgets('the follow sheet fits every phone, $lang', (tester) async {
      final c = container();
      await expectNoOverflow(
        tester,
        () => UncontrolledProviderScope(
          container: c,
          child: MaterialApp(
            theme: mtTheme(MTVariant.lite, Brightness.light),
            locale: Locale(lang),
            localizationsDelegates: MTLocalizations.localizationsDelegates,
            supportedLocales: MTLocalizations.supportedLocales,
            home: const _OpensSheet(),
          ),
        ),
      );
      expect(find.byType(TextField), findsNWidgets(2));
    });
  }
}

/// Counts the backups asked for, writing none.
class _Backups implements AutoBackup {
  int requests = 0;

  @override
  Future<void> requestBackup() async => requests++;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Opens the follow sheet once it is on screen, so the matrix measures it.
class _OpensSheet extends ConsumerStatefulWidget {
  const _OpensSheet({this.channel});

  /// This channel's own sheet rather than the follow sheet.
  final ChannelSubscription? channel;

  @override
  ConsumerState<_OpensSheet> createState() => _OpensSheetState();
}

class _OpensSheetState extends ConsumerState<_OpensSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => switch (widget.channel) {
        final sub? => showChannelActions(context, ref, sub),
        null => showFollowSheet(context),
      },
    );
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}
