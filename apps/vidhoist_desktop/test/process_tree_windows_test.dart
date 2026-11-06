import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/platform/process_tree_windows.dart';

/// The real Windows tree, on real processes: a command shell that starts a
/// child of its own stands in for yt-dlp starting Deno. Killing only the
/// first process left the child running, and the download with it.
void main() {
  Future<List<int>> childrenOf(int pid) async {
    final out = await Process.run('powershell', [
      '-NoProfile',
      '-Command',
      '(Get-CimInstance Win32_Process -Filter "ParentProcessId=$pid")'
          '.ProcessId',
    ]);
    return [
      for (final line in '${out.stdout}'.split('\n'))
        ?int.tryParse(line.trim()),
    ];
  }

  test(
    'kill ends the process and the child it started',
    () async {
      final tree = WindowsProcessTree();
      final shell = await Process.start('cmd', [
        '/c',
        'ping -n 60 127.0.0.1 >nul',
      ]);
      tree.adopt(shell);
      List<int> children = [];
      for (var i = 0; i < 40 && children.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        children = await childrenOf(shell.pid);
      }
      expect(children, isNotEmpty, reason: 'ping should have started');
      await tree.kill(shell);
      await shell.exitCode.timeout(const Duration(seconds: 5));
      tree.release(shell);
      final alive = await Process.run('tasklist', [
        '/FI',
        'PID eq ${children.first}',
        '/NH',
      ]);
      expect('${alive.stdout}', isNot(contains('${children.first}')));
    },
    skip: !Platform.isWindows,
    timeout: const Timeout(Duration(seconds: 60)),
  );

  test('killing a process it never adopted still ends it', () async {
    final tree = WindowsProcessTree();
    final shell = await Process.start('cmd', ['/c', 'ping -n 60 127.0.0.1']);
    await tree.kill(shell);
    await shell.exitCode.timeout(const Duration(seconds: 10));
  }, skip: !Platform.isWindows);
}
