import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:vh_core/vh_core.dart';

import 'atomic_file.dart';

/// The name shared_preferences_windows gives its one file, in the folder
/// path_provider calls the application support directory
/// (`%APPDATA%\Vidhoist`): its default file name plus `.json`.
const prefsFileName = 'shared_preferences.json';

/// The last copy of [prefsFileName] that read back whole.
const prefsCopyName = 'shared_preferences.last-good.json';

/// What [PrefsGuard.check] found.
enum PrefsCheck {
  /// No file: a first start, or one removed on purpose.
  none,

  /// A whole file, now copied as the last good one.
  healthy,

  /// A broken file, put aside, and the last good copy put in its place.
  restored,

  /// A broken file, put aside, with no good copy to bring back: the app
  /// starts with no settings rather than not at all.
  lost,
}

/// Keeps every setting and index (one JSON file on Windows) from being
/// lost to a crash or a power cut. shared_preferences_windows rewrites
/// that file in place, so an interruption leaves it empty or cut short;
/// the plugin then reads nothing, or throws at every start and the app
/// never opens.
///
/// [check] runs **before SharedPreferences reads the file**: a whole file
/// is copied aside (atomically), a broken one is renamed aside, never
/// deleted, and the last good copy takes its place. A missing file is
/// left missing: the plugin never deletes it, so it went on purpose, and
/// the uninstaller's "delete the app's data" takes the copy with it.
class PrefsGuard {
  PrefsGuard({required this.folder, this.logger, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  /// The application support directory.
  final String folder;
  final VhLogger? logger;
  final DateTime Function() _clock;

  String get _sep => Platform.pathSeparator;
  File get file => File('$folder$_sep$prefsFileName');
  File get copy => File('$folder$_sep$prefsCopyName');

  /// [check], then [keepFresh], for the start of the app: a check that
  /// fails is logged and the app starts anyway, as it would without it.
  Future<void> guard() async {
    try {
      await check();
    } on FileSystemException catch (e) {
      await logger?.error('settings file check failed', cause: e, tag: _tag);
    }
    keepFresh();
  }

  Future<PrefsCheck> check() async {
    if (!await file.exists()) return PrefsCheck.none;
    final text = await _whole(file);
    if (text != null) {
      await _keep(text);
      return PrefsCheck.healthy;
    }
    final aside = await _putAside();
    final good = await copy.exists() ? await _whole(copy) : null;
    if (good == null) {
      await _note('settings file unreadable, kept as $aside; no good copy');
      return PrefsCheck.lost;
    }
    await writeAtomically(file.path, good);
    await _note(
      'settings file unreadable, kept as $aside; last good copy '
      'restored',
    );
    return PrefsCheck.restored;
  }

  /// Copies the file again, as [check] does when it is whole, every
  /// [every]: a computer left open for days would otherwise only have the
  /// copy made when it started. A read that meets a write in progress sees
  /// a broken file and keeps the copy it has.
  Timer keepFresh({Duration every = const Duration(hours: 1)}) =>
      Timer.periodic(every, (_) => unawaited(refresh()));

  Future<void> refresh() async {
    try {
      if (!await file.exists()) return;
      final text = await _whole(file);
      if (text != null) await _keep(text);
    } on FileSystemException {
      // Tried again at the next tick.
    }
  }

  /// The file's text when it is what the plugin can read back: UTF-8 and
  /// one JSON object. An empty file is broken too: the plugin always writes
  /// at least `{}`, so empty means a write cut off after the truncation.
  static Future<String?> _whole(File f) async {
    try {
      final text = utf8.decode(await f.readAsBytes());
      return json.decode(text) is Map ? text : null;
    } on FormatException {
      return null;
    } on FileSystemException {
      return null;
    }
  }

  Future<void> _keep(String text) async {
    if (await _whole(copy) == text) return;
    await writeAtomically(copy.path, text);
  }

  Future<String> _putAside() async {
    final stamp = BackupRotation.stampOf(_clock());
    final aside = 'shared_preferences.broken-$stamp.json';
    await file.rename('$folder$_sep$aside');
    return aside;
  }

  Future<void> _note(String message) async =>
      logger?.log(message, level: LogLevel.warn, tag: _tag);

  static const _tag = 'settings';
}
