import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/channels/channel_actions.dart';
import 'package:vidhoist_mobile/features/channels/channel_art.dart';
import 'package:vidhoist_mobile/features/channels/channel_avatar.dart';
import 'package:vidhoist_mobile/features/channels/channel_card.dart';
import 'package:vidhoist_mobile/features/channels/channels_screen.dart';
import 'package:vidhoist_mobile/features/channels/channels_state.dart';
import 'package:vidhoist_mobile/features/channels/follow_sheet.dart';
import 'package:vidhoist_mobile/features/settings/auto_backup.dart';
import 'package:vidhoist_mobile/features/shared/choice_chip_row.dart';
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

/// **Channels on the phone**: followed from Settings, read
/// through the phone's yt-dlp, what is new queued like a pasted link.
void main() {
  late MemoryKeyValueStore store;
  late FakeBackend backend;
  late LocalDownloadEngine engine;
  late _Backups backups;
  late _Art art;

  setUp(() {
    backups = _Backups();
    art = _Art();
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
          const PhoneSettings(quality: Quality.q720),
        ),
        loggerProvider.overrideWithValue(
          VhLogger(filePath: '${Directory.systemTemp.path}/vh_channels.log'),
        ),
        downloadBackendProvider.overrideWithValue(backend),
        downloadEngineProvider.overrideWithValue(engine),
        autoBackupProvider.overrideWithValue(backups),
        channelArtProvider.overrideWithValue(art),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  Widget app(ProviderContainer c, {String lang = 'en'}) =>
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp(
          theme: vhTheme(VhVariant.phone, Brightness.light),
          locale: Locale(lang),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
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

  for (final editing in [false, true]) {
    testWidgets('**the guard**: how often and at what quality each stand in '
        'one row that slides (${editing ? 'editing' : 'following'})', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final c = container();
      // Read every 24 hours: the last chip, past the edge until scrolled.
      const edited = ChannelSubscription(
        id: 'UC_some',
        name: 'Some Channel',
        url: 'https://www.youtube.com/@Some',
        enabled: true,
        checkIntervalMinutes: 1440,
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c,
          child: MaterialApp(
            theme: vhTheme(VhVariant.phone, Brightness.light),
            localizationsDelegates: VhLocalizations.localizationsDelegates,
            supportedLocales: VhLocalizations.supportedLocales,
            home: _OpensSheet(editing: editing ? edited : null),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final rows = find.byType(ChoiceChipRow);
      expect(rows, findsNWidgets(2));
      for (final row in rows.evaluate()) {
        final tops = {
          for (final chip
              in find
                  .descendant(
                    of: find.byWidget(row.widget),
                    matching: find.byType(ChoiceChip),
                  )
                  .evaluate())
            tester.getRect(find.byWidget(chip.widget)).top,
        };
        expect(tops, hasLength(1), reason: 'wrapped onto ${tops.length} rows');
      }
      if (editing) {
        // The last interval, chosen, is brought into view, not left past
        // the edge of the screen.
        final chosen = tester.getRect(find.text('Every 24 hours'));
        expect(chosen.right, lessThanOrEqualTo(360));
        expect(chosen.left, greaterThanOrEqualTo(0));
      }
    });
  }

  testWidgets('**the guard**: on a tablet a choice in sight leaves its row '
      'where it starts: the first chip whole, not pushed half off by a '
      'choice drawn to the middle', (tester) async {
    tester.view.physicalSize = const Size(1366, 854);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container(),
        child: MaterialApp(
          theme: vhTheme(VhVariant.phone, Brightness.light),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: const _OpensSheet(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final row = tester.getRect(find.byType(ChoiceChipRow).first);
    final first = tester.getRect(find.text('Every 30 minutes'));
    expect(first.left, greaterThanOrEqualTo(row.left));
    expect(first.right, lessThanOrEqualTo(row.right));
  });

  testWidgets("**the guard**: the quality is changed from the channel's "
      'sheet, and the next clip found downloads at it', (tester) async {
    final c = container();
    await tester.runAsync(() => followSome(c));
    final sub = (await tester.runAsync(() => c.read(channelsProvider.future)))!
        .single;
    expect(sub.quality, Quality.q720.wire);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp(
          theme: vhTheme(VhVariant.phone, Brightness.light),
          localizationsDelegates: VhLocalizations.localizationsDelegates,
          supportedLocales: VhLocalizations.supportedLocales,
          home: _OpensSheet(editing: sub),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final audio = find.text('Audio only');
    await tester.ensureVisible(audio);
    await tester.pumpAndSettle();
    await tester.tap(audio);
    await tester.pumpAndSettle();
    final save = find.widgetWithText(FilledButton, 'Save settings');
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    await tester.tap(save);
    // The save is real work on the store: given real time, frame by frame.
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
    expect(find.text('Save settings'), findsNothing, reason: 'saved, closed');

    backend.listings[_videos] = _feed(['b', 'a']);
    await tester.runAsync(() => c.read(channelsControllerProvider).checkNow());
    expect(engine.tasks.single.quality, Quality.audio);
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

  testWidgets('**the guard**: scrolled to the end, the last card clears '
      '"Follow a channel" above the navigation buttons', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(384, 823);
    // The buttons are both padding and view padding, as on a device: the
    // floating button stands above the latter.
    tester.view.padding = const FakeViewPadding(bottom: 48);
    tester.view.viewPadding = const FakeViewPadding(bottom: 48);
    addTearDown(tester.view.reset);
    final c = container();
    await tester.runAsync(() => followSome(c));
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    // The list's end is its bottom padding above the screen's edge: the
    // last card stops there once scrolled all the way.
    final list = tester.widget<ListView>(find.byType(ListView));
    final listEnd =
        tester.getRect(find.byType(ListView)).bottom -
        list.padding!.resolve(TextDirection.ltr).bottom;
    final fab = tester.getRect(find.byType(FloatingActionButton));
    expect(listEnd, lessThanOrEqualTo(fab.top));
  });

  testWidgets('the card: its letter and name, no clips', (tester) async {
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
    expect(
      find.textContaining('Episode a'),
      findsNothing,
      reason: 'the user wants the channel alone, not its videos',
    );
  });

  testWidgets('**the guard**: its sheet ends above three-button '
      'navigation, so "Unfollow" is not under the buttons', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(384, 823);
    tester.view.padding = const FakeViewPadding(bottom: 48);
    tester.view.viewPadding = const FakeViewPadding(bottom: 48);
    addTearDown(tester.view.reset);
    final c = container();
    await tester.runAsync(() => followSome(c));
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Some Channel'));
    await tester.pumpAndSettle();
    final scroll = tester.widget<SingleChildScrollView>(
      find
          .descendant(
            of: find.byType(BottomSheet),
            matching: find.byType(SingleChildScrollView),
          )
          .first,
    );
    expect(
      scroll.padding!.resolve(TextDirection.ltr).bottom,
      greaterThanOrEqualTo(48),
    );
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

  testWidgets('**the guard**: a failed check says so calmly, not in '
      "yt-dlp's words; its sheet has them, small", (tester) async {
    final c = container();
    await tester.runAsync(() async {
      await followSome(c);
      backend.listings[_videos] = const YtDlpError(
        YtDlpErrorKind.unavailable,
        'ERROR: [youtube:tab] @Some: This channel does not exist.',
      );
      await c.read(channelsControllerProvider).checkNow();
    });
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    expect(find.textContaining('tries again by itself'), findsOneWidget);
    expect(find.textContaining('does not exist'), findsNothing);
    await tester.tap(find.textContaining('Some Channel'));
    await tester.pumpAndSettle();
    expect(find.textContaining('does not exist'), findsOneWidget);
  });

  testWidgets('no network: the card stays as it was, nothing said', (
    tester,
  ) async {
    final c = container();
    await tester.runAsync(() async {
      await followSome(c);
      backend.listings[_videos] = const YtDlpError(
        YtDlpErrorKind.network,
        'ERROR: [youtube:tab] @Some/videos: Unable to download API page: '
        '[Errno 7] No address associated with host',
      );
      await c.read(channelsControllerProvider).checkNow();
    });
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    expect(find.textContaining('tries again'), findsNothing);
    expect(find.textContaining('Errno'), findsNothing);
    expect(find.textContaining('Last checked'), findsOneWidget);
  });

  testWidgets("unfollowing forgets the channel's pictures", (tester) async {
    final c = container();
    await tester.runAsync(() => followSome(c));
    await tester.pumpWidget(app(c));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Some Channel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Unfollow'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Unfollow').last);
    await tester.pumpAndSettle();
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    expect(art.forgotten, ['UC_some']);
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
            theme: vhTheme(VhVariant.phone, Brightness.light),
            locale: Locale(lang),
            localizationsDelegates: VhLocalizations.localizationsDelegates,
            supportedLocales: VhLocalizations.supportedLocales,
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
            theme: vhTheme(VhVariant.phone, Brightness.light),
            locale: Locale(lang),
            localizationsDelegates: VhLocalizations.localizationsDelegates,
            supportedLocales: VhLocalizations.supportedLocales,
            home: const _OpensSheet(),
          ),
        ),
      );
      expect(find.byType(TextField), findsNWidgets(2));
    });
  }
}

/// Keeps no picture and fetches none, and notes what was forgotten.
class _Art extends ChannelArt {
  _Art() : super(root: () async => Directory.systemTemp.path);

  final forgotten = <String>[];

  @override
  Future<File?> file(String id, ChannelArtKind kind, String? url) async => null;

  @override
  Future<void> forget(String id) async => forgotten.add(id);
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
  const _OpensSheet({this.channel, this.editing});

  /// This channel's own sheet rather than the follow sheet.
  final ChannelSubscription? channel;

  /// The follow sheet changing this channel rather than following one.
  final ChannelSubscription? editing;

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
        null => showFollowSheet(context, editing: widget.editing),
      },
    );
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}
