import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:vidhoist_desktop/platform/ytdlp_process.dart';

/// A process that prints what a test tells it to, line by line as yt-dlp
/// does on Windows, and ends when told.
class FakeProcess implements Process {
  FakeProcess({this.pid = 4242});

  @override
  final int pid;

  final _out = StreamController<List<int>>();
  final _err = StreamController<List<int>>();
  final _exit = Completer<int>();
  bool killed = false;

  void say(String line) => _out.add(utf8.encode('$line\r\n'));
  void sayBytes(List<int> bytes) => _out.add(bytes);
  void complain(String line) => _err.add(utf8.encode('$line\n'));

  Future<void> end(int code) async {
    if (_exit.isCompleted) return;
    await _out.close();
    await _err.close();
    _exit.complete(code);
  }

  @override
  Stream<List<int>> get stdout => _out.stream;

  @override
  Stream<List<int>> get stderr => _err.stream;

  @override
  Future<int> get exitCode => _exit.future;

  @override
  IOSink get stdin => throw UnsupportedError('yt-dlp reads nothing');

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    killed = true;
    unawaited(end(1));
    return true;
  }
}

/// One start of a process, as the backend asked for it.
typedef Started = ({
  String executable,
  List<String> arguments,
  Map<String, String>? environment,
  FakeProcess process,
});

/// Starts [FakeProcess]es and keeps what each was started with; [script]
/// drives each one once it is running.
class FakeStarter {
  FakeStarter([this.script]);

  final void Function(Started started)? script;
  final List<Started> started = [];

  /// Thrown instead of starting, as when the executable has gone.
  Object? refuse;

  Future<Process> call(
    String executable,
    List<String> arguments, {
    Map<String, String>? environment,
  }) async {
    if (refuse case final error?) throw error;
    final run = (
      executable: executable,
      arguments: arguments,
      environment: environment,
      process: FakeProcess(pid: 4242 + started.length),
    );
    started.add(run);
    if (script case final drive?) scheduleMicrotask(() => drive(run));
    return run.process;
  }
}

/// A process tree that remembers instead of reaching Windows.
class FakeTree implements ProcessTree {
  final List<int> adopted = [];
  final List<int> killed = [];
  final List<int> released = [];

  @override
  void adopt(Process process) => adopted.add(process.pid);

  @override
  Future<void> kill(Process process) async {
    killed.add(process.pid);
    process.kill();
  }

  @override
  void release(Process process) => released.add(process.pid);
}
