import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart'
    show
        AssignProcessToJobObject,
        CloseHandle,
        CreateJobObject,
        OpenProcess,
        SetInformationJobObject,
        TerminateJobObject;

import 'ytdlp_process.dart';

/// A Windows job object per process: everything the process starts joins
/// its job, and ending the job ends them all.
///
/// The job is made to kill on close, so if the app itself crashes, Windows
/// closes the handle and stops yt-dlp, Deno and ffmpeg with it rather than
/// leaving a download running with no window (`docs/ENGINE.md`,
/// finding 5). Where a job cannot be made, `taskkill /T` stops the tree.
class WindowsProcessTree implements ProcessTree {
  final _jobs = <int, int>{};

  static const _processTerminate = 0x0001;
  static const _processSetQuota = 0x0100;
  static const _extendedLimitInformation = 9;
  static const _killOnJobClose = 0x00002000;

  // JOBOBJECT_EXTENDED_LIMIT_INFORMATION on 64-bit Windows: the flags sit
  // after the two time limits, and the whole is 144 bytes.
  static const _limitSize = 144;
  static const _flagsOffset = 16;

  @override
  void adopt(Process process) {
    final job = CreateJobObject(nullptr, nullptr);
    if (job == 0) return;
    final limits = calloc<Uint8>(_limitSize);
    try {
      (limits + _flagsOffset).cast<Uint32>().value = _killOnJobClose;
      final handle = OpenProcess(
        _processTerminate | _processSetQuota,
        0,
        process.pid,
      );
      final joined =
          SetInformationJobObject(
                job,
                _extendedLimitInformation,
                limits,
                _limitSize,
              ) !=
              0 &&
          handle != 0 &&
          AssignProcessToJobObject(job, handle) != 0;
      if (handle != 0) CloseHandle(handle);
      if (joined) {
        _jobs[process.pid] = job;
      } else {
        CloseHandle(job);
      }
    } finally {
      calloc.free(limits);
    }
  }

  @override
  Future<void> kill(Process process) async {
    final job = _jobs.remove(process.pid);
    if (job != null) {
      TerminateJobObject(job, 1);
      CloseHandle(job);
      return;
    }
    try {
      await Process.run('taskkill', ['/PID', '${process.pid}', '/T', '/F']);
    } on ProcessException {
      // taskkill is part of Windows; if it is missing, the parent at least.
    }
    process.kill();
  }

  @override
  void release(Process process) {
    // Closing the job also ends any child the process left behind.
    if (_jobs.remove(process.pid) case final job?) CloseHandle(job);
  }
}
