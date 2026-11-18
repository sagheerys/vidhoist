import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart'
    show LocalDownloadEngine, PlaylistDetector, UrlKit;

import '../../data/downloads_data.dart';

/// How long the video at a link is, read as soon as the add screen holds
/// it ([readsLength]), so the times cannot run past its end. The download
/// that follows starts from this same reading
/// ([LocalDownloadEngine.lengthOf]).
/// The same file is in both apps.
final clipLengthProvider = FutureProvider.autoDispose.family<Duration?, String>(
  (ref, url) async => ref.read(downloadEngineProvider)?.lengthOf(url),
);

/// How long the field must stay unchanged before its link is read.
const settleTime = Duration(milliseconds: 600);

/// How long Start waits on a length still being read.
const lengthWait = Duration(seconds: 20);

/// Whether the length of [link] is read as soon as the add screen holds
/// it, before a stretch is asked for, so the times are held to it from the
/// first one typed (asked 2026-11-18). The download starts from that same
/// probe, so a link downloaded whole costs nothing more. A playlist is not
/// one video; a short link waits to be followed, or for a stretch.
bool readsLength(String link, bool clipOn) =>
    link.startsWith('http') &&
    !PlaylistDetector.isPlaylist(link) &&
    (clipOn || !UrlKit.needsResolution(link));
