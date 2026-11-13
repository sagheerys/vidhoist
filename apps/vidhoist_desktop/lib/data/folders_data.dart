import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../di.dart';
import '../identity.dart';

/// What this computer offers for folders: where they are by default, a
/// folder dialog, and Explorer. The Windows one is put in by main; the
/// default knows no folder and opens nothing, for tests.
abstract class DesktopFolders {
  const DesktopFolders();

  /// The user's Videos folder (moved by OneDrive or not).
  Future<String?> videos();

  /// The user's Downloads folder.
  Future<String?> downloads();

  /// Windows' folder dialog; null when it is closed without a choice.
  Future<String?> pick({String? initial});

  /// Windows' open dialog for one file of [extensions], read as text;
  /// null when it is closed or the file cannot be read.
  Future<String?> openText({required List<String> extensions});

  /// Windows' open dialog for several files of [extensions], each with its
  /// name and bytes; empty when it is closed or nothing could be read.
  Future<List<(String, List<int>)>> openFiles({
    required List<String> extensions,
  });

  /// Windows' save dialog, offering [name]; writes [text] where the user
  /// chose and returns that path, or null when it is closed.
  Future<String?> saveText({required String name, required String text});

  /// [saveText] for a file that is not text, a PDF say.
  Future<String?> saveBytes({required String name, required List<int> bytes});

  /// Opens Explorer on [path]'s folder with the file selected.
  Future<void> reveal(String path);

  /// Opens Explorer on the folder [path].
  Future<void> open(String path);

  /// Windows' "Open with" for the file at [path], so the user plays it in
  /// a player of their own (VLC, say); nothing where there is no Windows.
  Future<void> openWith(String path) async {}
}

class NoFolders extends DesktopFolders {
  const NoFolders();

  @override
  Future<String?> videos() async => null;

  @override
  Future<String?> downloads() async => null;

  @override
  Future<String?> pick({String? initial}) async => null;

  @override
  Future<String?> openText({required List<String> extensions}) async => null;

  @override
  Future<List<(String, List<int>)>> openFiles({
    required List<String> extensions,
  }) async => const [];

  @override
  Future<String?> saveText({
    required String name,
    required String text,
  }) async => null;

  @override
  Future<String?> saveBytes({
    required String name,
    required List<int> bytes,
  }) async => null;

  @override
  Future<void> reveal(String path) async {}

  @override
  Future<void> open(String path) async {}
}

final desktopFoldersProvider = Provider<DesktopFolders>(
  (ref) => const NoFolders(),
);

/// The download folder, saved on this computer only (a backup does not
/// carry it: another computer has other folders).
class FolderSettings {
  const FolderSettings({this.download});

  /// Chosen by the user; null is the default below Downloads.
  final String? download;
}

const _downloadKey = 'ember_download_folder';

final folderSettingsProvider =
    NotifierProvider<FolderSettingsNotifier, FolderSettings>(
      FolderSettingsNotifier.new,
    );

class FolderSettingsNotifier extends Notifier<FolderSettings> {
  @override
  FolderSettings build() {
    _load();
    return const FolderSettings();
  }

  Future<void> _load() async {
    final store = ref.read(keyValueStoreProvider);
    try {
      final download = await store.getString(_downloadKey);
      state = FolderSettings(
        download: (download?.isEmpty ?? true) ? null : download,
      );
    } on Object {
      // Unreadable settings are the defaults, never a failed start.
    }
  }

  Future<void> setDownload(String path) async {
    state = FolderSettings(download: path);
    await ref
        .read(prefsMutexProvider)
        .run(
          () => ref.read(keyValueStoreProvider).setString(_downloadKey, path),
        );
  }
}

/// The download folder in use: the chosen one, or
/// `Downloads\Vidhoist`.
final downloadFolderProvider = FutureProvider<String?>((ref) async {
  final chosen = ref.watch(folderSettingsProvider.select((s) => s.download));
  if (chosen != null) return chosen;
  final downloads = await ref.watch(desktopFoldersProvider).downloads();
  return downloads == null
      ? null
      : '$downloads\\${DesktopIdentity.displayName}';
});
