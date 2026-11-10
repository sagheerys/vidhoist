import 'package:win32/win32.dart'
    show ES_CONTINUOUS, ES_SYSTEM_REQUIRED, SetThreadExecutionState;

import '../data/keep_awake_data.dart';

/// Tells Windows the computer is busy, as a media player does while it
/// plays: no sleep while it holds, the screen may still turn off. The
/// state belongs to the calling thread, the app's own for its whole life,
/// and Windows drops it if the app ends.
class WindowsSleepPort implements SleepPort {
  const WindowsSleepPort();

  @override
  void holdOffSleep(bool on) => SetThreadExecutionState(
    on ? ES_CONTINUOUS | ES_SYSTEM_REQUIRED : ES_CONTINUOUS,
  );
}
