import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/home/download_watcher.dart';
import 'package:vidhoist_mobile/features/home/notifications.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

/// Posts nothing; remembers what is showing.
class _Notices extends DownloadNotifications {
  final showing = <int>{};
  final bodies = <String?>[];
  final actions = <List<String>>[];

  @override
  Future<void> showProgress(
    int id, {
    required String title,
    required String channelName,
    required int? percent,
    String? body,
    String? taskId,
    List<NoticeAction> buttons = const [],
  }) async {
    showing.add(id);
    bodies.add(body);
    actions.add([for (final b in buttons) b.id]);
  }

  @override
  Future<void> showResult(
    int id, {
    required String title,
    required String body,
    required String channelName,
    String? payload,
    bool isError = false,
  }) async => showing.add(id);

  @override
  Future<void> cancel(int id) async => showing.remove(id);
}

/// A replaced engine's tasks leave the list with no ending of their own.
/// An ongoing notice, which cannot
/// be swiped away, must still go.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final background = <bool>[];

  setUp(() {
    background.clear();
    // The engine's own foreground service, answered so the watcher's chain
    // moves on.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('vidhoist/ytdlp'), (
          call,
        ) async {
          if (call.method == 'keepAlive') {
            background.add((call.arguments as Map)['on'] as bool);
          }
          return true;
        });
  });

  ({_Notices notices, StreamController<List<DownloadTask>> tasks}) watch() {
    final notices = _Notices();
    final tasks = StreamController<List<DownloadTask>>();
    addTearDown(tasks.close);
    final container = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        prefsMutexProvider.overrideWithValue(PrefsMutex()),
        initialSettingsProvider.overrideWithValue(const PhoneSettings()),
        loggerProvider.overrideWithValue(
          VhLogger(filePath: '${Directory.systemTemp.path}/mtf_test.log'),
        ),
        notificationsProvider.overrideWithValue(notices),
        engineTasksProvider.overrideWith((ref) => tasks.stream),
      ],
    );
    addTearDown(container.dispose);
    container.read(downloadWatcherProvider);
    return (notices: notices, tasks: tasks);
  }

  final l10n = lookupVhLocalizations(const Locale('en'));
  DownloadTask at(TaskPhase phase) => DownloadTask(
    inputUrl: 'https://youtu.be/abc',
    quality: Quality.best,
  ).copyWith(phase: phase, progress: 0.42);

  test('the phone engine phases in its own words, with pause and '
      'resume', () async {
    final w = watch();
    w.tasks.add([at(TaskPhase.downloading)]);
    await pumpEventQueue();
    expect(w.notices.bodies.last, l10n.engineDownloadingProgress('42'));
    expect(w.notices.actions.last, ['pause']);

    w.tasks.add([at(TaskPhase.paused)]);
    await pumpEventQueue();
    expect(w.notices.bodies.last, l10n.enginePaused);
    expect(w.notices.actions.last, ['resume']);

    w.tasks.add([at(TaskPhase.preparing)]);
    await pumpEventQueue();
    expect(w.notices.bodies.last, l10n.enginePreparing);
  });

  test(
    'a download paused by hand does not keep the foreground service',
    () async {
      final w = watch();
      w.tasks.add([at(TaskPhase.downloading)]);
      await pumpEventQueue();
      expect(background, [true]);
      w.tasks.add([at(TaskPhase.paused)]);
      await pumpEventQueue();
      expect(background.last, isFalse);
    },
  );

  test('a task gone from the list takes its notice with it', () async {
    final notices = _Notices();
    final tasks = StreamController<List<DownloadTask>>();
    addTearDown(tasks.close);
    final container = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(MemoryKeyValueStore()),
        prefsMutexProvider.overrideWithValue(PrefsMutex()),
        initialSettingsProvider.overrideWithValue(const PhoneSettings()),
        loggerProvider.overrideWithValue(
          VhLogger(filePath: '${Directory.systemTemp.path}/mtf_test.log'),
        ),
        notificationsProvider.overrideWithValue(notices),
        engineTasksProvider.overrideWith((ref) => tasks.stream),
      ],
    );
    addTearDown(container.dispose);
    container.read(downloadWatcherProvider);

    final adding = DownloadTask(
      inputUrl: 'https://youtu.be/abc',
      quality: Quality.best,
    ).copyWith(phase: TaskPhase.preparing);
    tasks.add([adding]);
    await pumpEventQueue();
    expect(notices.showing, hasLength(1));

    // The new engine's list, without the moved task.
    tasks.add(const []);
    await pumpEventQueue();
    expect(notices.showing, isEmpty);
  });
}
