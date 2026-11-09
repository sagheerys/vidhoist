import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vidhoist_mobile/features/engine/channel_backend.dart';
import 'package:vidhoist_mobile/features/engine/ytdlp_bridge.dart';

/// The phone's side of the channel, scripted: what each run prints and how
/// it ends, and every call it was given.
class FakePhone {
  FakePhone() {
    messenger.setMockMethodCallHandler(
      MethodChannelYtDlpBridge.methods,
      _onCall,
    );
    messenger.setMockStreamHandler(
      MethodChannelYtDlpBridge.lineChannel,
      MockStreamHandler.inline(
        onListen: (_, sink) => _sink = sink,
        onCancel: (_) => _sink = null,
      ),
    );
  }

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  MockStreamHandlerEventSink? _sink;
  final calls = <MethodCall>[];

  /// What `execute` prints, per run id, before it ends.
  List<String> Function(String id) printed = (_) => const [];

  /// How each run ends.
  Map<String, Object?> Function(String id) ending = (_) => {
    'exitCode': 0,
    'stderr': '',
  };

  /// What a probe writes, when the run asks for its stdout to be kept.
  String probeJson = jsonEncode({
    'id': 'abc',
    'title': 'A clip',
    'webpage_url': 'https://www.youtube.com/watch?v=abc',
  });

  /// Holds every run open until released, so a test can cancel it.
  Completer<void>? hold;

  void dispose() {
    messenger.setMockMethodCallHandler(MethodChannelYtDlpBridge.methods, null);
    messenger.setMockStreamHandler(MethodChannelYtDlpBridge.lineChannel, null);
  }

  Iterable<MethodCall> named(String method) =>
      calls.where((c) => c.method == method);

  Future<Object?> _onCall(MethodCall call) async {
    calls.add(call);
    switch (call.method) {
      case 'execute':
        final args = call.arguments as Map;
        final id = args['id'] as String;
        for (final line in printed(id)) {
          _sink?.success({'id': id, 'line': line});
        }
        if (hold case final gate?) await gate.future;
        if (args['stdoutFile'] case final String path) {
          File(path).writeAsStringSync(probeJson);
        }
        _sink?.success({'id': id, 'done': true});
        return ending(id);
      case 'cancel':
        return true;
      case 'version':
        return '2026.10.26';
      case 'update':
        return {'status': 'DONE', 'version': '2026.11.01'};
      case 'init':
        return {'ms': 4200};
    }
    return null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakePhone phone;
  late Directory cache;
  late ChannelYtDlpBackend backend;
  var ipv4 = true;
  String? cookies;
  var readies = 0;
  Completer<void>? readyGate;

  setUp(() {
    phone = FakePhone();
    cache = Directory.systemTemp.createTempSync('vh_backend_');
    ipv4 = true;
    cookies = null;
    readies = 0;
    readyGate = null;
    backend = ChannelYtDlpBackend(
      bridge: MethodChannelYtDlpBridge(),
      cacheDir: () async => cache.path,
      forceIpv4: () => ipv4,
      cookiesFile: () => cookies,
      ready: () async {
        readies++;
        await readyGate?.future;
      },
    );
  });

  tearDown(() {
    phone.dispose();
    cache.deleteSync(recursive: true);
  });

  const request = DownloadRequest(
    taskId: 't1',
    url: 'https://www.youtube.com/watch?v=abc',
    folder: '/storage/emulated/0/Download/Vidhoist',
    quality: Quality.q720,
  );

  List<String> argsOf(MethodCall call) =>
      ((call.arguments as Map)['args'] as List).cast<String>();

  group('a download', () {
    test('hands the whole command over in order and reads its lines', () async {
      phone.printed = (id) => [
        '[vh-parts] 100 []',
        '[vh] downloading 50 100 NA 1 1 NA NA',
        '[vh] finished 100 100 NA 1 NA NA NA',
        '[vh-file] /storage/emulated/0/Download/Vidhoist/A [abc].mp4',
      ];
      final events = await backend.download(request).toList();

      final run = phone.named('execute').single;
      expect((run.arguments as Map)['id'], 't1');
      expect(
        argsOf(run),
        CommandBuilder.download(
          request.toSpec(),
          const EngineSetup(platform: HostPlatform.android),
        ),
      );
      expect(events.whereType<BackendProgress>().last.progress.fraction, 1);
      expect((events.last as BackendFinished).path, endsWith('A [abc].mp4'));
      expect(readies, 1, reason: 'the engine is made ready before a run');
    });

    test(
      'nothing goes into the phone\'s public folder but the media',
      () async {
        phone.printed = (_) => ['[vh-file] /x/A.mp4'];
        await backend.download(request).toList();
        final args = argsOf(phone.named('execute').single);
        expect(args, isNot(contains('--write-info-json')));
        expect(args, isNot(contains('--write-thumbnail')));
      },
    );

    test('another run\'s lines are not this run\'s', () async {
      phone.printed = (id) => [
        '[vh] downloading 90 100 NA 1 1 NA NA',
        '[vh-file] /x/A.mp4',
      ];
      // A line for a run that is not ours arrives first.
      phone.messenger.handlePlatformMessage(
        MethodChannelYtDlpBridge.lineChannel.name,
        const StandardMethodCodec().encodeSuccessEnvelope({
          'id': 'other',
          'line': '[vh-file] /x/Other.mp4',
        }),
        (_) {},
      );
      final events = await backend.download(request).toList();
      expect((events.last as BackendFinished).path, '/x/A.mp4');
    });

    test('a failed run is classified from what it printed on stderr', () async {
      phone.ending = (_) => {
        'exitCode': 1,
        'stderr': 'ERROR: [youtube] abc: Video unavailable',
      };
      final events = await backend.download(request).toList();
      expect(
        (events.single as BackendFailed).error.kind,
        YtDlpErrorKind.unavailable,
      );
    });

    test('a stopped run ends with neither a file nor a failure', () async {
      phone.ending = (_) => {'exitCode': 1, 'stderr': '', 'cancelled': true};
      final events = await backend.download(request).toList();
      expect(events.whereType<BackendFinished>(), isEmpty);
      expect(events.whereType<BackendFailed>(), isEmpty);
    });

    test('an engine that would not start is a failure, not a crash', () async {
      phone.messenger.setMockMethodCallHandler(
        MethodChannelYtDlpBridge.methods,
        (call) async => throw PlatformException(code: 'init_failed'),
      );
      final events = await backend.download(request).toList();
      expect(
        (events.single as BackendFailed).error.kind,
        YtDlpErrorKind.engineMissing,
      );
    });

    test('IPv4 is forced unless turned off', () async {
      phone.printed = (_) => ['[vh-file] /x/A.mp4'];
      await backend.download(request).toList();
      ipv4 = false;
      await backend.download(request).toList();
      final runs = phone.named('execute').toList();
      expect(argsOf(runs[0]), contains('-4'));
      expect(argsOf(runs[1]), isNot(contains('-4')));
    });

    test('the sign-ins go in as --cookies once there is a file, for the '
        'probe too', () async {
      phone.printed = (_) => ['[vh-file] /x/A.mp4'];
      await backend.download(request).toList();
      cookies = '/data/app/cookies.txt';
      await backend.download(request).toList();
      await backend.probe(request.url);
      final runs = phone.named('execute').map(argsOf).toList();
      expect(runs[0], isNot(contains('--cookies')));
      for (final run in runs.skip(1)) {
        final at = run.indexOf('--cookies');
        expect(at, isNonNegative);
        expect(run[at + 1], '/data/app/cookies.txt');
      }
    });
  });

  group('a probe', () {
    test(
      'keeps its JSON in the cache and the download starts from it',
      () async {
        final probe = await backend.probe(
          'https://www.youtube.com/watch?v=abc',
        );
        final run = phone.named('execute').single;
        final kept = (run.arguments as Map)['stdoutFile'] as String;
        expect(kept, startsWith(cache.path));
        expect(probe.infoJsonPath, kept);
        expect(probe.info.title, 'A clip');
        expect(
          argsOf(run),
          CommandBuilder.probe(
            'https://www.youtube.com/watch?v=abc',
            const EngineSetup(platform: HostPlatform.android),
          ),
        );

        phone.printed = (_) => ['[vh-file] /x/A.mp4'];
        await backend
            .download(request.copyWith(infoJsonPath: () => kept))
            .toList();
        final download = argsOf(phone.named('execute').last);
        expect(download, containsAllInOrder(['--load-info-json', kept]));
        expect(download, isNot(contains(request.url)));
        expect(
          File(kept).existsSync(),
          isFalse,
          reason: 'its links are signed for this device: gone once used',
        );
      },
    );

    test('a failed probe throws the classified error', () async {
      phone.ending = (_) => {
        'exitCode': 1,
        'stderr': 'ERROR: Unsupported URL: https://example.com/',
      };
      await expectLater(
        backend.probe('https://example.com/'),
        throwsA(
          isA<YtDlpError>().having(
            (e) => e.kind,
            'kind',
            YtDlpErrorKind.unsupportedUrl,
          ),
        ),
      );
    });

    test('an old probe is read again from the link: its media links have '
        'expired', () async {
      final probe = await backend.probe(request.url);
      File(
        probe.infoJsonPath!,
      ).setLastModifiedSync(DateTime.now().subtract(const Duration(hours: 7)));
      phone.printed = (_) => ['[vh-file] /x/A.mp4'];
      await backend
          .download(request.copyWith(infoJsonPath: () => probe.infoJsonPath))
          .toList();
      final download = argsOf(phone.named('execute').last);
      expect(download, isNot(contains('--load-info-json')));
      expect(download.last, request.url);
    });
  });

  group('cancel', () {
    test('stops the download of that task', () async {
      phone.hold = Completer<void>();
      final events = backend.download(request).toList();
      await pumpEventQueue();
      await backend.cancel('t1');
      expect((phone.named('cancel').single.arguments as Map)['id'], 't1');
      phone.hold!.complete();
      await events;
    });

    test('a task still reading its link stops its probe', () async {
      phone.hold = Completer<void>();
      final probe = backend.probe(request.url);
      while (phone.named('execute').isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      final probeId =
          (phone.named('execute').single.arguments as Map)['id'] as String;
      await backend.cancel('t1');
      expect((phone.named('cancel').single.arguments as Map)['id'], probeId);
      phone.hold!.complete();
      await probe;
    });

    test('a stop asked before the probe reaches the phone keeps it from '
        'starting', () async {
      final probe = backend.probe(request.url);
      await backend.cancel('t1');
      await expectLater(probe, throwsA(isA<CancelledException>()));
      expect(phone.named('execute'), isEmpty);
    });

    test('a stop asked while the engine is still being readied keeps the '
        'download from starting', () async {
      readyGate = Completer<void>();
      final events = backend.download(request).toList();
      while (readies == 0) {
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      await backend.cancel('t1');
      readyGate!.complete();
      expect(await events, isEmpty);
      expect(phone.named('execute'), isEmpty);
    });
  });

  test('versions and updates in the core\'s terms', () async {
    final version = await backend.version();
    expect(version.ytDlp.toString(), '2026.10.26');
    expect(version.jsRuntime, 'quickjs');
    final update = await backend.updateEngine();
    expect(update.updated, isTrue);
    expect(update.version.toString(), '2026.11.01');
    expect(
      (phone.named('update').single.arguments as Map)['channel'],
      'stable',
    );
  });
}
