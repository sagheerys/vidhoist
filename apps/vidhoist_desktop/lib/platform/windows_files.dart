import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/clip_delete.dart';
import '../data/covers/covers_data.dart';
import '../data/file_copy.dart';
import '../data/shapes/shapes_data.dart';
import 'file_clipboard_windows.dart';
import 'frame_grab.dart';
import 'recycle_bin_windows.dart';
import 'shape_probe.dart';

/// What Windows gives the library's files: a frame for a cover, a clip's
/// length and size read from its header, the clipboard that holds a file,
/// and the Recycle Bin a deleted clip goes to. Each is null, empty or a
/// plain delete in tests.
List<Override> windowsFileOverrides() => [
  frameGrabProvider.overrideWithValue(grabFrame),
  shapeProbeProvider.overrideWithValue(probeShape),
  filesToClipboardProvider.overrideWithValue(putFilesOnClipboard),
  recycleFileProvider.overrideWithValue(recycleWithWindows),
];
