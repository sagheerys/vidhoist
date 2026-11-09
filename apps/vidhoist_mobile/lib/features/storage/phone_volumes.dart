import 'package:flutter/foundation.dart' show immutable, listEquals;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../downloads_library/local_item.dart';

/// **A memory card or a drive beside the phone's own storage**, where
/// downloads may go instead (plan item R4, 2026-11-09).
///
/// A path, not a folder picked through Android's file picker: yt-dlp
/// writes by path, and so do the library scan, the player, sharing and
/// deleting. A picked folder is a `content://` permission with no path,
/// and would have meant downloading inside the app and copying out, plus
/// rewriting all of those. Android 11 lets an app write its own files in
/// a card's `Download` folder by path, which is all this needs; older
/// versions list no card (`StorageVolumes.kt`).
@immutable
class PhoneVolume {
  const PhoneVolume({
    required this.id,
    required this.path,
    required this.label,
  });

  /// Android's id for the card (`1A2B-3C4D`): the setting keeps this, not
  /// the path, so the same card is found again however it is mounted.
  final String id;

  /// Where it is mounted, such as `/storage/1A2B-3C4D`.
  final String path;

  /// The name Android shows for it ("SD card", "USB drive").
  final String label;

  /// The app's folder on it, named as on the phone's own storage.
  String get mediaDir => '$path/Download/$mediaFolderName';

  /// One entry of the channel's answer; null for anything malformed, so a
  /// strange volume is skipped rather than breaking the settings.
  static PhoneVolume? fromMap(Object? raw) {
    if (raw is! Map) return null;
    final id = raw['id'];
    final path = raw['path'];
    final label = raw['label'];
    if (id is! String || id.isEmpty || path is! String || path.isEmpty) {
      return null;
    }
    return PhoneVolume(
      id: id,
      path: path,
      label: label is String && label.isNotEmpty ? label : id,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PhoneVolume &&
      other.id == id &&
      other.path == path &&
      other.label == label;

  @override
  int get hashCode => Object.hash(id, path, label);
}

/// Where a new download goes: the chosen card while it is mounted, the
/// phone's own folder otherwise. A card taken out never fails a download;
/// it lands on the phone, and the setting says so.
String downloadDirFor(String? volumeId, List<PhoneVolume> volumes) {
  for (final volume in volumes) {
    if (volume.id == volumeId) return volume.mediaDir;
  }
  return phoneMediaDir;
}

/// Every folder the library shows, the phone's first: what was downloaded
/// to a card before the setting changed back still shows, as long as the
/// card is in.
List<String> libraryDirsFor(List<PhoneVolume> volumes) => [
  phoneMediaDir,
  for (final volume in volumes) volume.mediaDir,
];

/// The mounted cards and drives, phone storage left out.
abstract interface class VolumeSource {
  Future<List<PhoneVolume>> volumes();
}

/// [VolumeSource] over the `vidhoist_mobile/media` channel of
/// `MainActivity.kt`.
class ChannelVolumeSource implements VolumeSource {
  const ChannelVolumeSource();

  static const _channel = MethodChannel('vidhoist_mobile/media');

  @override
  Future<List<PhoneVolume>> volumes() async {
    try {
      final raw = await _channel.invokeListMethod<Object?>('volumes');
      return [
        for (final entry in raw ?? const <Object?>[])
          ?PhoneVolume.fromMap(entry),
      ];
    } on PlatformException {
      return const [];
    } on MissingPluginException {
      return const [];
    }
  }
}

/// The volumes read before runApp, so the first download and the first
/// library scan know the card without waiting; overridden in main.
final initialVolumesProvider = Provider<List<PhoneVolume>>((ref) => const []);

final volumeSourceProvider = Provider<VolumeSource>(
  (ref) => const ChannelVolumeSource(),
);

/// The mounted volumes as last read: at startup, and again whenever the
/// downloads settings or the library are refreshed, since a card can go
/// in or out while the app runs.
class VolumesNotifier extends Notifier<List<PhoneVolume>> {
  @override
  List<PhoneVolume> build() => ref.read(initialVolumesProvider);

  Future<void> refresh() async {
    final fresh = await ref.read(volumeSourceProvider).volumes();
    if (!listEquals(fresh, state)) state = fresh;
  }
}

final phoneVolumesProvider =
    NotifierProvider<VolumesNotifier, List<PhoneVolume>>(VolumesNotifier.new);

/// The folders the library scans, phone first.
final libraryDirsProvider = Provider<List<String>>(
  (ref) => libraryDirsFor(ref.watch(phoneVolumesProvider)),
);
