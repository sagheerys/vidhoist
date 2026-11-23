import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Thrown when clips stayed on the phone because Android would not let the
/// app delete them and the user did not allow it either.
class DeleteRefusedException implements Exception {
  const DeleteRefusedException({required this.deleted, required this.left});

  /// How many clips of the request were deleted all the same.
  final int deleted;

  /// How many are still on the phone.
  final int left;

  @override
  String toString() => 'DeleteRefusedException: $left left, $deleted deleted';
}

/// Removing a download from the phone's shared storage.
///
/// **A path is not always enough.** Android lets an app delete by path only
/// the shared files it records as that app's own, and it forgets the owner
/// when the app's data is cleared, when the app is uninstalled, and for
/// files a phone transfer brought back. From then on the delete fails with
/// "no such file" for a file that is there. Such files go through
/// [askSystem]: Android shows its own dialog and deletes them itself.
class MediaRemover {
  const MediaRemover([this.channel = _defaultChannel]);

  static const _defaultChannel = MethodChannel('vidhoist_mobile/media');
  final MethodChannel channel;

  /// Deletes [file] by its path. False when Android refused; a file already
  /// gone counts as deleted.
  Future<bool> delete(File file) async {
    try {
      if (await file.exists()) await file.delete();
      return true;
    } on FileSystemException {
      return false;
    }
  }

  /// Asks the user, in the system's dialog, to delete the files at [paths].
  /// True when they agreed; the caller still checks what is left, since the
  /// system may take fewer than were asked.
  Future<bool> askSystem(List<String> paths) async {
    if (paths.isEmpty) return false;
    try {
      return await channel.invokeMethod<bool>('requestDelete', {
            'paths': paths,
          }) ??
          false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}

final mediaRemoverProvider = Provider((ref) => const MediaRemover());
