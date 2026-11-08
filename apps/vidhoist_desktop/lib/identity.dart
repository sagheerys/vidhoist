/// The names Windows shows for the app. **Fixed for good at the first
/// release**: the data folder is derived from them, so a later rename
/// would leave every user's settings, tags and playlists behind in the old
/// folder.
abstract final class DesktopIdentity {
  /// The window title, the media flyout and the tray.
  ///
  /// It is also the data folder: `%APPDATA%\Vidhoist\` for settings
  /// and `%LOCALAPPDATA%\Vidhoist\` for logs and caches. path_provider
  /// builds those from the ProductName in `windows/runner/Runner.rc`,
  /// prefixed by the CompanyName when there is one, which is why that
  /// field stays empty. A test holds the runner to this value.
  ///
  /// 1.0.0 wrote it `Vidhoist`; the capital H changes nothing on disk,
  /// since Windows reads folder names without regard to case.
  static const displayName = 'VidHoist';

  /// The diagnostic log's file name, inside the local data folder.
  static const logFile = 'vidhoist.log';
}
