// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'vh_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class VhLocalizationsEn extends VhLocalizations {
  VhLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get aboutApp => 'About the app';

  @override
  String get aboutDescriptionPhone =>
      'A light, fast app that downloads video and audio from many platforms with yt-dlp, straight to your device, with no server in between. It has its own player and playlists.';

  @override
  String get accountSignIn => 'Sign in';

  @override
  String get accountSignOut => 'Sign out';

  @override
  String get accountSignedIn => 'Signed in';

  @override
  String get accountSignedOut => 'Not signed in';

  @override
  String accountSignedOutOf(String site) {
    return 'Signed out of $site';
  }

  @override
  String get accountsBanRisk =>
      'Better use a secondary account: heavy downloading can get an account restricted by the site for a while.';

  @override
  String get accountsClearAll => 'Delete all cookies';

  @override
  String get accountsCleared => 'Cookies deleted';

  @override
  String get accountsFileHint =>
      'Exported from a browser as a cookies.txt file (Netscape format), for any site, including those not listed above. It joins the sign-ins already here, and stays on this phone.';

  @override
  String get accountsFilePick => 'Choose a cookies file';

  @override
  String get accountsFileTitle => 'Or import a cookies file';

  @override
  String get accountsFromFile => 'From a cookies file';

  @override
  String get accountsHelp =>
      'A sign-in expires after a while; when a site starts refusing again, sign in once more. Signing out of one site also signs the in-app browser out of the others, whose downloads go on as they were.';

  @override
  String get accountsHint =>
      'For the sites that refuse a download without a login. You sign in on the site\'s own page inside the app; what it leaves stays on this phone, where yt-dlp reads it for every download, and goes nowhere else.';

  @override
  String get activeDownloads => 'Active downloads';

  @override
  String activeDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count downloads in progress',
      one: '1 download in progress',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloadsSheet => 'Active downloads';

  @override
  String get activeNow => 'Active now';

  @override
  String get addLinkFab => 'Add link';

  @override
  String get addTo => 'Add to…';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get addToPlaylist => 'Add to playlist';

  @override
  String get addUrl => 'Add URL';

  @override
  String addedNToServer(int count) {
    return 'Added $count to the downloads';
  }

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String addedToPlaylistCount(int count) {
    return '$count added to the playlist';
  }

  @override
  String get allDownloadsFinished => 'All downloads finished.';

  @override
  String get allFolders => 'All folders';

  @override
  String get allPlatforms => 'All platforms';

  @override
  String get alreadyInPlaylist => 'Already added';

  @override
  String get alreadySubscribed => 'This channel is already followed';

  @override
  String get appTitle => 'VidHoist';

  @override
  String get appearanceAndLanguage => 'Appearance & language';

  @override
  String audioChannels(int count) {
    return '$count channels';
  }

  @override
  String get audioFormat => 'Audio format';

  @override
  String get audioFormatM4a => 'M4A: plays everywhere';

  @override
  String get audioFormatMp3 => 'MP3: for older players and cars';

  @override
  String get audioFormatOriginal => 'As the site sends it, unconverted';

  @override
  String get audioMono => 'Mono';

  @override
  String get audioOnly => 'Audio only';

  @override
  String get audioStereo => 'Stereo';

  @override
  String get authentication => 'Authentication (optional)';

  @override
  String get autoBuilt => 'Automatic';

  @override
  String get autoCheckUpdates => 'Check automatically';

  @override
  String get autoCheckUpdatesHelp =>
      'Looks for a new version in the background about twice a day.';

  @override
  String get autoRestoreSuccess => 'Data restored from the backup.';

  @override
  String get autoRetry => 'Retry when the network returns';

  @override
  String get autoRetryHelp =>
      'Anything that failed because the network dropped is retried on its own when it returns. What a site refused is not retried: repeating it unchanged just fails again.';

  @override
  String get backgroundDownload => 'Downloading files in background...';

  @override
  String get backupNote =>
      'Includes playlists, tags, the offline index, artwork links and settings. Passwords and usernames are never backed up, and media files are not included.';

  @override
  String get backupSettings => 'Back up all data';

  @override
  String get backupSettingsSubtitle =>
      'Seven dated copies that refresh themselves. Restore any of them, or export one to share';

  @override
  String backupSuccess(Object path) {
    return 'Backup saved to: $path';
  }

  @override
  String backupsKept(int count) {
    return '$count backups kept';
  }

  @override
  String get batchDownloadSelected => 'Download selected';

  @override
  String get batchLoading => 'Reading the playlist…';

  @override
  String get batchNothingSelected => 'Select at least one item';

  @override
  String batchSelectedOf(int selected, int total) {
    return '$selected of $total selected';
  }

  @override
  String get batchThisVideoOnly => 'Download this video only';

  @override
  String get batchTitle => 'Batch download';

  @override
  String get batteryAllow => 'Allow';

  @override
  String get batteryFree =>
      'Battery saving leaves downloads alone, even with the app out of sight.';

  @override
  String get batteryRestricted =>
      'Battery saving can stop a long download while the app is out of sight.';

  @override
  String get batteryStateFree => 'Allowed';

  @override
  String get batteryStateLimited => 'Restricted';

  @override
  String get batteryTitle => 'Downloads in the background';

  @override
  String bitrateKbps(String value) {
    return '$value kb/s';
  }

  @override
  String bitrateMbps(String value) {
    return '$value Mb/s';
  }

  @override
  String get builtWith => 'Built with';

  @override
  String get cancel => 'Cancel';

  @override
  String get changeQuality => 'Change quality';

  @override
  String get channelNameFolder => 'Named after the channel';

  @override
  String channelFollowers(String count) {
    return '$count subscribers';
  }

  @override
  String get channelCheckFailed =>
      'Not checked this time. VidHoist tries again by itself.';

  @override
  String get channelUrl => 'Link to a channel, a playlist or one of its videos';

  @override
  String get channelUrlHint => 'https://www.youtube.com/@name';

  @override
  String chapterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters',
      one: '1 chapter',
    );
    return '$_temp0';
  }

  @override
  String chapterNumber(int number) {
    return 'Chapter $number';
  }

  @override
  String get chaptersFold => 'Hide chapters';

  @override
  String chaptersFromTranscript(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters from the transcript',
      one: '1 chapter from the transcript',
    );
    return '$_temp0';
  }

  @override
  String get chaptersShowAll => 'View all chapters';

  @override
  String get chaptersUnfold => 'Show chapters';

  @override
  String get checkEvery => 'How often to look';

  @override
  String get checkForUpdates => 'Check for updates';

  @override
  String get checkNow => 'Check now';

  @override
  String get checkQueued =>
      'Checking now. Anything new appears in the library.';

  @override
  String get chooseFolder => 'Choose a folder';

  @override
  String get chooseOptions => 'Options';

  @override
  String get clear => 'Clear';

  @override
  String get clearLogs => 'Clear logs';

  @override
  String get clearLogsConfirm => 'Delete all diagnostic logs?';

  @override
  String get clipEndAfterStart => 'After the start';

  @override
  String get clipFrom => 'From';

  @override
  String clipLength(Object length) {
    return 'The video is $length long';
  }

  @override
  String get clipLengthReading => 'Reading the video\'s length…';

  @override
  String get clipLengthUnknown =>
      'The site does not say how long the video is, so the times are not checked';

  @override
  String get clipMinuteDown => 'A minute earlier';

  @override
  String get clipMinuteUp => 'A minute later';

  @override
  String get clipOnly => 'Only a part of the video';

  @override
  String get clipOnlyHelp =>
      'From one time to another, without the rest. It comes without subtitles.';

  @override
  String clipPastEnd(Object length) {
    return 'The video ends at $length';
  }

  @override
  String get clipTimeHint => 'Digits alone: 130 is 1:30';

  @override
  String get clipTo => 'To';

  @override
  String get clipboardFound => 'A link is ready in your clipboard';

  @override
  String get clipboardLinkReady => 'Paste link';

  @override
  String get closePlayer => 'Close player';

  @override
  String get columnAdded => 'Added';

  @override
  String get columnLength => 'Length';

  @override
  String get compactView => 'Compact view';

  @override
  String get compatiblePlayback => 'Best playback compatibility';

  @override
  String get compatiblePlaybackHelp =>
      'Asks for H.264/AAC, which every phone decodes in hardware. Without it YouTube may deliver AV1, which many devices render as a garbled picture. Turning it off allows the highest resolution at the cost of compatibility.';

  @override
  String get completed => 'Completed';

  @override
  String get continueAsAudio => 'Continue as audio';

  @override
  String get continueAsAudioBody =>
      'Keep playing this as audio from the same second?';

  @override
  String get continueAsAudioNo => 'No, stop';

  @override
  String get continueAsAudioTitle => 'Continue in the background?';

  @override
  String get cookies => 'Cookies';

  @override
  String get cookiesHelp =>
      'In your browser, use an extension that exports cookies in the Netscape format (one file per platform) and pick the files here. The server then uses them for every download, and yt-dlp decides when it needs them. Cookies expire, so a download that starts failing again usually means a fresh export is due.';

  @override
  String get cookiesNotNetscape =>
      'None of these files holds cookies in the Netscape format';

  @override
  String get cookiesSubtitle =>
      'For the platforms that will not download without a login';

  @override
  String get cookiesWhat =>
      'Some platforms refuse to hand a video over unless the request looks like a signed-in browser. A cookies file exported from your browser gives the server that.';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get copyright => '© 2026 Yasir Sagheer';

  @override
  String get couldNotLoadPlaylist =>
      'Couldn\'t load this playlist. Check the URL and your connection.';

  @override
  String get create => 'Create';

  @override
  String get createPlaylist => 'Create playlist';

  @override
  String get creator => 'Creator';

  @override
  String get defaultQuality => 'Default video quality';

  @override
  String get delete => 'Delete';

  @override
  String deleteMultipleConfirm(int count) {
    return 'Delete $count video(s)?\n\nThis will remove the files from your device.';
  }

  @override
  String deletePlaylistConfirm(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get deleteSelected => 'Delete selected';

  @override
  String get deleteTag => 'Delete tag';

  @override
  String deleteTagConfirm(Object tag) {
    return 'Delete the tag \"$tag\" from all items? The videos themselves are not deleted.';
  }

  @override
  String get deleteVideo => 'Delete video';

  @override
  String deleteVideoConfirm(Object title) {
    return 'Delete \"$title\"?\n\nThis will remove the file from your device.';
  }

  @override
  String deletedCount(Object count) {
    return '$count deleted';
  }

  @override
  String deletedTitle(Object title) {
    return 'Deleted: $title';
  }

  @override
  String get deselectAll => 'Deselect all';

  @override
  String desktopAddLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count links',
      one: 'Add 1 link',
      zero: 'Nothing to add',
    );
    return '$_temp0';
  }

  @override
  String get desktopBack => 'Back';

  @override
  String get desktopBackUpNow => 'Back up now';

  @override
  String get desktopBackupHint =>
      'This computer keeps its last seven backups, at least an hour apart, in Downloads\\VidHoist\\Backups, where they outlast an uninstall.';

  @override
  String get desktopBackupsNone => 'No backup yet';

  @override
  String get desktopBrowserButton => '“To VidHoist” button in the browser';

  @override
  String get desktopBrowserButtonCopied =>
      'Code copied. Make a new bookmark and paste it as its address (URL).';

  @override
  String get desktopBrowserButtonCopy => 'Copy the code';

  @override
  String get desktopBrowserButtonFailed =>
      'The page could not be opened; copy the code instead.';

  @override
  String get desktopBrowserButtonHint =>
      'A button on your bookmarks bar: one click on any video\'s page opens the add dialog here with its link. Nothing is sent until you press Add.';

  @override
  String get desktopBrowserButtonName => 'To VidHoist';

  @override
  String get desktopBrowserButtonOpen => 'Open the setup page';

  @override
  String get desktopBrowserPageCopyInstead =>
      'If dragging does not work, make a new bookmark and paste this as its address:';

  @override
  String get desktopBrowserPageDragHint =>
      'Drag it to the bar; a click here does nothing.';

  @override
  String get desktopBrowserPageStep1 =>
      'Show the bookmarks bar if it is hidden:';

  @override
  String get desktopBrowserPageStep2 =>
      'Drag the button below onto the bar with the mouse.';

  @override
  String get desktopBrowserPageStep3 =>
      'On any video\'s page, click it: VidHoist opens its add dialog with the link. The first time, the browser asks whether to open the app; allow it.';

  @override
  String get desktopBrowserPageTitle =>
      'Add the “To VidHoist” button to your browser';

  @override
  String get desktopChangeFolder => 'Change…';

  @override
  String get desktopChannel => 'Channel';

  @override
  String get desktopChannelClips => 'In your library';

  @override
  String get desktopChannels => 'Channels';

  @override
  String get desktopChannelsInLibrary => 'Channels in your library';

  @override
  String get desktopChannelsLater => 'Not in this version';

  @override
  String get desktopChannelsLaterBody =>
      'Following a channel needs a scheduler on this computer, and that comes in a later version. The clips you download stay in the library.';

  @override
  String get desktopChapters => 'Chapters';

  @override
  String get desktopCheckAll => 'Check all';

  @override
  String get desktopChooseClip => 'Select';

  @override
  String get desktopClearFilters => 'Clear filters';

  @override
  String get desktopClearSelection => 'Clear selection';

  @override
  String get desktopCookiesBrowser => 'From a browser';

  @override
  String get desktopCookiesBrowserHint =>
      'Read from the browser you are signed in with. If they cannot be read, close that browser and try again.';

  @override
  String get desktopCookiesChoose => 'Choose a file…';

  @override
  String get desktopCookiesFile => 'Cookies file';

  @override
  String get desktopCookiesHelp =>
      'In your browser, use an extension that exports cookies in the Netscape format (one file per site), and choose the files here together. yt-dlp then uses them for every download. Cookies expire, so a download that starts failing again usually means a fresh export is due.';

  @override
  String get desktopCookiesKept => 'Cookies kept on this computer';

  @override
  String desktopCookiesKeptFor(String sites) {
    return 'Cookies kept for: $sites';
  }

  @override
  String get desktopCookiesLocalHint =>
      'For sites that need you signed in. yt-dlp reads them on this computer, and they go nowhere else.';

  @override
  String get desktopCookiesNone => 'None';

  @override
  String get desktopCookiesRemove => 'Remove';

  @override
  String get desktopCopiedLinkAdd => 'Add…';

  @override
  String get desktopCopiedLinkTitle => 'Download this link?';

  @override
  String get desktopCopyFile => 'Copy file';

  @override
  String get desktopCopyFileFailed => 'The file could not be copied';

  @override
  String get desktopCopyLink => 'Copy link';

  @override
  String get desktopCopyOneClip => 'Copying takes one clip at a time';

  @override
  String get desktopCopyQuote => 'Copy with time and link';

  @override
  String get desktopDefaultQualityHint =>
      'What each add starts with; you can still change it for each link.';

  @override
  String desktopDeleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $count clips? Their files on this computer are deleted.',
      one: 'Delete 1 clip? Its file on this computer is deleted.',
    );
    return '$_temp0';
  }

  @override
  String get desktopDesktopSection => 'Desktop';

  @override
  String get desktopDiscover => 'Discover VidHoist';

  @override
  String get desktopDiscoverAddLink => 'Paste or drop a link';

  @override
  String get desktopDiscoverAddLinkLine =>
      'Ctrl+V anywhere, or drop a link on the window, to add it.';

  @override
  String get desktopDiscoverAdding => 'Adding and sharing';

  @override
  String get desktopDiscoverBrowser => 'From the browser';

  @override
  String get desktopDiscoverBrowserLine =>
      'The “To VidHoist” button on your bookmarks bar opens the add dialog with the page you are on.';

  @override
  String get desktopDiscoverChapters => 'Chapters';

  @override
  String get desktopDiscoverChaptersLine =>
      'A clip\'s parts, from its transcript, on its page.';

  @override
  String get desktopDiscoverChoose => 'Choose many';

  @override
  String get desktopDiscoverChooseLine =>
      'The round mark, or Ctrl or Shift with a click; then add them to a list or delete them together.';

  @override
  String get desktopDiscoverDragOut => 'Drag a clip out';

  @override
  String get desktopDiscoverDragOutLine =>
      'Onto a folder or another app, as a file.';

  @override
  String get desktopDiscoverExport => 'Export a transcript';

  @override
  String get desktopDiscoverExportLine =>
      'As text, or as SRT subtitles for another player.';

  @override
  String get desktopDiscoverHint =>
      'Everything the app can do, a line each, with its keys.';

  @override
  String get desktopDiscoverLibrary => 'The library';

  @override
  String get desktopDiscoverListening =>
      'For sound: a quiet room with the cover large, in full screen.';

  @override
  String get desktopDiscoverMini => 'Small window';

  @override
  String get desktopDiscoverMiniLine =>
      'A small card above every other window, by the clock.';

  @override
  String get desktopDiscoverReading =>
      'The transcript as an article: click a sentence to hear it from there.';

  @override
  String get desktopDiscoverSaid => 'What was said';

  @override
  String get desktopDiscoverSearch => 'Search what was said';

  @override
  String get desktopDiscoverSearchLine =>
      'Find the clips where a word was spoken, not only in titles.';

  @override
  String get desktopDiscoverShortcutsLine =>
      'Every key the window answers, on one sheet.';

  @override
  String get desktopDiscoverShow => 'Show';

  @override
  String get desktopDiscoverStatsLine =>
      'The library counted: by site, channel and month.';

  @override
  String get desktopDiscoverSubtitles =>
      'The transcript over the picture, the spoken word lit up.';

  @override
  String get desktopDiscoverTheater =>
      'A larger picture that takes the side panel\'s place.';

  @override
  String get desktopDiscoverTry => 'Try it';

  @override
  String get desktopDiscoverWatching => 'Watching and listening';

  @override
  String get desktopDownloadFolder => 'Download folder';

  @override
  String get desktopDownloadFolderHint =>
      'Your own files: saved here, then the app leaves them alone.';

  @override
  String get desktopDownloads => 'Downloads';

  @override
  String get desktopDownloadsEmpty =>
      'Nothing is downloading. Add a link, or make a clip available offline.';

  @override
  String get desktopDownloadsRunning => 'Under way';

  @override
  String get desktopDragToReorder => 'Drag to reorder';

  @override
  String get desktopDropLinks => 'Drop to add';

  @override
  String get desktopEmptyLibraryLocal =>
      'Add a link, and the clip appears here once it is downloaded.';

  @override
  String get desktopEmptyLibraryMessage =>
      'Add a link, and the clip appears here once it is downloaded.';

  @override
  String get desktopEngine => 'Engine';

  @override
  String get desktopEngineDenoHint =>
      'Solves YouTube\'s check, for every format it offers';

  @override
  String get desktopEngineFetch => 'Fetch';

  @override
  String get desktopEngineFetchCorrupt =>
      'The file that arrived was not the published one, so it was not used.';

  @override
  String get desktopEngineFetchFailed =>
      'Could not be fetched. Check the connection and try again.';

  @override
  String get desktopEngineFetchInUse =>
      'In use by a download. Try again once it ends.';

  @override
  String desktopEngineFetching(int percent) {
    return 'Fetching · $percent%';
  }

  @override
  String get desktopEngineFfmpegHint =>
      'Joins picture and sound, and converts audio';

  @override
  String get desktopEngineIpv4 => 'Use IPv4 only';

  @override
  String get desktopEngineIpv4Hint =>
      'Much faster where IPv6 is broken, as on many home networks. Turn it off only if your network has IPv6 alone.';

  @override
  String get desktopEngineMissing =>
      'yt-dlp is not on this computer. Reinstall VidHoist, or fetch it here.';

  @override
  String get desktopEngineOnFirstUse =>
      'Fetched at the first download that needs it';

  @override
  String get desktopEngineUpToDate => 'yt-dlp is up to date';

  @override
  String get desktopEngineUpdate => 'Update yt-dlp';

  @override
  String get desktopEngineUpdateFailed =>
      'The update did not go through. Try again later.';

  @override
  String get desktopEngineUpdateHint =>
      'Sites change often; an old yt-dlp stops working within months.';

  @override
  String desktopEngineUpdated(String version) {
    return 'yt-dlp is now $version';
  }

  @override
  String get desktopEngineUpdating => 'Updating…';

  @override
  String desktopEngineVersion(String version) {
    return 'Version $version';
  }

  @override
  String get desktopEngineYtDlpHint => 'Reads the link and downloads it';

  @override
  String get desktopExport => 'Export';

  @override
  String get desktopExportForPhone => 'Export for the phone';

  @override
  String get desktopExportForPhoneHint =>
      'Saves this computer\'s tags, lists and resume points, and its transcripts, as two files the phone restores. Restoring on the phone replaces its own tags and lists.';

  @override
  String get desktopExportMarkdown => 'Text (Markdown)';

  @override
  String get desktopExportPdf => 'Document (PDF)';

  @override
  String get desktopExportPhone => 'For the phone (VidHoist import)';

  @override
  String get desktopExportSrt => 'Subtitles (SRT)';

  @override
  String desktopExported(String name) {
    return 'Saved $name';
  }

  @override
  String desktopFileReadyToPaste(String name, String size) {
    return 'Ready to paste: $name · $size';
  }

  @override
  String get desktopFolderUnavailable => 'No folder available';

  @override
  String get desktopFolders => 'Folders';

  @override
  String get desktopForward => 'Forward';

  @override
  String get desktopGlobalShortcut => 'Play and pause from any app';

  @override
  String desktopGlobalShortcutHint(String keys) {
    return '$keys plays and pauses while the window is behind other apps.';
  }

  @override
  String desktopGlobalShortcutTaken(String keys) {
    return 'Another app already uses $keys.';
  }

  @override
  String get desktopHidePanel => 'Hide side panel';

  @override
  String get desktopHintShortcuts =>
      'Press ? for the keyboard shortcuts. Space plays and pauses; the arrow keys seek.';

  @override
  String get desktopHintShortcutsAction => 'Shortcuts';

  @override
  String get desktopHintTrayBody =>
      'It keeps playing from its icon by the clock. To quit, right-click the icon.';

  @override
  String get desktopHintTrayTitle => 'VidHoist is still running';

  @override
  String get desktopHints => 'Show tips';

  @override
  String get desktopHintsAgain => 'Show them again';

  @override
  String get desktopHintsHint =>
      'Two short tips, each shown once: the shortcuts at the first clip, the icon by the clock at the first close.';

  @override
  String get desktopImportFromPhone => 'Import a backup or transcripts…';

  @override
  String get desktopImportHint =>
      'A backup or transcripts file from VidHoist, chosen here or dropped on the window. A phone\'s is added to what is here; a backup of this computer is restored whole, after asking.';

  @override
  String desktopImportedBackup(int tagged, int lists, int positions) {
    return 'Added from the phone. Tags: $tagged · lists: $lists · resume points: $positions';
  }

  @override
  String get desktopImportedNothing =>
      'Nothing new: this computer already had all of it.';

  @override
  String desktopImportedTranscripts(int count) {
    return 'Transcripts added: $count';
  }

  @override
  String desktopInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count in your library',
      one: '1 in your library',
    );
    return '$_temp0';
  }

  @override
  String get desktopKeepAwake => 'Keep the computer awake while downloading';

  @override
  String get desktopKeepAwakeHint =>
      'So a link sent from the phone, or a long playlist, finishes instead of stopping when Windows goes to sleep. The screen still turns off as usual.';

  @override
  String get desktopKeyAddLink => 'Add the link you copied';

  @override
  String get desktopKeyFavorite => 'Add to favorites or remove';

  @override
  String get desktopKeyFullScreen =>
      'Full screen; for sound, the listening room';

  @override
  String get desktopKeyMenu => 'The clip\'s menu';

  @override
  String get desktopKeyMini => 'Small window above the others, and back';

  @override
  String get desktopKeyPlayPause => 'Play or pause';

  @override
  String get desktopKeyRepeat => 'Change repeat';

  @override
  String get desktopKeySearch => 'Search titles and what was said';

  @override
  String get desktopKeySeek => 'Back or forward 10 seconds';

  @override
  String get desktopKeyShortcuts => 'This list';

  @override
  String get desktopKeyVolume =>
      'Louder or quieter; in shorts, the previous or next one';

  @override
  String get desktopKeyZoomIn => 'Larger interface';

  @override
  String get desktopKeyZoomOut => 'Smaller interface';

  @override
  String get desktopKeyZoomReset => 'Interface at its usual size';

  @override
  String get desktopLanguageSystemHint => 'Follows the language of Windows.';

  @override
  String desktopLastArrival(String when) {
    return 'Last arrival $when';
  }

  @override
  String get desktopLess => 'Less';

  @override
  String get desktopLibraryLoading => 'Loading the library…';

  @override
  String get desktopLinkCopied => 'Link copied';

  @override
  String get desktopLinkDuplicate => 'Repeated above';

  @override
  String get desktopLinkInLibrary => 'Already in your library';

  @override
  String get desktopLinkPlaylist => 'A playlist: choose its clips';

  @override
  String get desktopLinkReady => 'Ready';

  @override
  String get desktopLinkUnsupported => 'A site this app doesn\'t know';

  @override
  String desktopLinksDropped(int count, int limit) {
    return 'Only the first $limit links are taken; $count more were left out.';
  }

  @override
  String desktopLinksFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count links',
      one: '1 link',
    );
    return '$_temp0';
  }

  @override
  String get desktopListeningClose => 'Close the listening room';

  @override
  String get desktopListeningRoom => 'Listening room';

  @override
  String get desktopLogsCopied => 'Log copied, without links or addresses';

  @override
  String get desktopLogsCopy => 'Copy';

  @override
  String get desktopLogsSave => 'Save to a file';

  @override
  String get desktopMiniRestore => 'Back to the full window';

  @override
  String get desktopMiniWindow => 'Small window';

  @override
  String get desktopMore => 'More';

  @override
  String get desktopNarrowSidebar => 'Collapse sidebar';

  @override
  String get desktopNoChannelNames =>
      'The clips in your library don\'t name their channel, so this channel\'s clips can\'t be picked out. Follow it with its own folder, and whatever arrives there shows here.';

  @override
  String get desktopNoFavoritesMessage =>
      'Mark a clip as a favorite and it waits for you here.';

  @override
  String get desktopNoFavoritesTitle => 'No favorites yet';

  @override
  String get desktopNoMatchMessage => 'Clear a filter to see more.';

  @override
  String get desktopNoMatchTitle => 'Nothing matches these filters';

  @override
  String get desktopNoTags =>
      'No tags yet. Tag a clip from its page and it appears here.';

  @override
  String get desktopNoTranscriptMessage =>
      'It shows here once the clip\'s subtitles are downloaded with it.';

  @override
  String get desktopNoTranscriptTitle => 'No transcript for this clip';

  @override
  String get desktopNotABackup =>
      'This file is not a VidHoist backup or transcripts file.';

  @override
  String desktopNotWatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count not watched',
      one: '1 not watched',
    );
    return '$_temp0';
  }

  @override
  String get desktopNothingPlaying => 'Nothing playing';

  @override
  String get desktopNothingPlayingHint =>
      'Play a clip and its transcript, what comes next and its details appear here.';

  @override
  String get desktopNotifyArrivalsHint =>
      'A Windows notice when new clips from the channels you follow are downloaded.';

  @override
  String get desktopOfferCopiedLinks => 'Offer links I copy';

  @override
  String get desktopOfferCopiedLinksHint =>
      'When you copy a video link in another app, a notification offers to add it. Only links are looked at, and none is saved.';

  @override
  String get desktopOpenBackup => 'Open Backup';

  @override
  String get desktopOpenChannels => 'Open channels';

  @override
  String get desktopOpenInExplorer => 'Open in Explorer';

  @override
  String get desktopOpenWith => 'Open in another player…';

  @override
  String get desktopPaletteClose => 'to close';

  @override
  String get desktopPaletteCommands => 'Commands';

  @override
  String get desktopPaletteHint =>
      'Search titles and what was said, or type > for commands';

  @override
  String desktopPaletteList(String name) {
    return 'List: $name';
  }

  @override
  String get desktopPaletteMove => 'to move';

  @override
  String get desktopPaletteOpen => 'to open';

  @override
  String get desktopPaletteSaid => 'Said inside clips';

  @override
  String get desktopPaletteSave => 'Save this search';

  @override
  String desktopPaletteSettings(String section) {
    return 'Settings: $section';
  }

  @override
  String get desktopPaletteTitles => 'Titles';

  @override
  String get desktopPinned => 'Pinned';

  @override
  String get desktopPlayNext => 'Play next';

  @override
  String get desktopPlaysNext => 'Plays next, after this one';

  @override
  String get desktopQueueEnd => 'Nothing comes after this one';

  @override
  String desktopQuote(String text, String title, String time, String link) {
    return '“$text”\n— $title, $time\n$link';
  }

  @override
  String get desktopQuoteCopied => 'Copied with its time and link';

  @override
  String get desktopReadingBack => 'Back to the clip';

  @override
  String get desktopReadingCloseFind => 'Close the search';

  @override
  String get desktopReadingFind => 'Find in the text';

  @override
  String desktopReadingFound(int at, int count) {
    return '$at of $count';
  }

  @override
  String get desktopReadingHint =>
      'Click a sentence to hear it from there · Ctrl+F finds a word · select to copy with its time';

  @override
  String get desktopReadingNextMatch => 'Next match';

  @override
  String get desktopReadingPreviousMatch => 'Previous match';

  @override
  String get desktopReadingRoom => 'Reading room';

  @override
  String get desktopRecoverLibrary => 'Clips already in the folder';

  @override
  String get desktopRecoverLibraryAction => 'Look in the folder';

  @override
  String get desktopRecoverLibraryHint =>
      'After a reinstall: puts back in the library the clips that are in the downloads folder but no longer listed. The files are not touched.';

  @override
  String desktopRecovered(int count) {
    return 'Put back in the library: $count';
  }

  @override
  String get desktopRecoveredNothing =>
      'Nothing to add: every clip in the folder is in the library.';

  @override
  String desktopRecoveredSome(int count, int left) {
    return 'Put back in the library: $count. Left out, their link unknown: $left';
  }

  @override
  String get desktopRemoveFromList => 'Remove from the list';

  @override
  String get desktopRestore => 'Restore';

  @override
  String get desktopRestoreBody =>
      'This computer\'s library, followed channels, tags, lists and settings become what the backup holds. The downloaded files are not touched.';

  @override
  String desktopRestoreOfferBody(String when) {
    return 'Downloads\\VidHoist\\Backups holds a backup of this computer: its library, followed channels, playlists, tags, settings and saved transcripts. The newest was made $when. Your downloaded files are not touched either way.';
  }

  @override
  String get desktopRestoreOfferTitle => 'Restore your backup?';

  @override
  String get desktopRestoreTitle => 'Restore this backup?';

  @override
  String get desktopRestored => 'Backup restored';

  @override
  String get desktopRevealAfterDownload => 'Show in Explorer when done';

  @override
  String get desktopRevealAfterDownloadHint =>
      'When a file downloaded to this computer is done, its folder opens with the file chosen.';

  @override
  String desktopSavedIn(String folder) {
    return 'Saved in $folder';
  }

  @override
  String desktopSavedSearchDelete(String name) {
    return 'Delete the saved search “$name”? Nothing in the library changes.';
  }

  @override
  String get desktopSavedSearchName => 'Search name';

  @override
  String get desktopSearch => 'Search';

  @override
  String get desktopSearchHint => 'Search titles and what was said…';

  @override
  String get desktopSearchSaved => 'Saved in the sidebar';

  @override
  String get desktopSeekBar => 'Position in the clip';

  @override
  String desktopSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String get desktopSetupChooseFile => 'Choose a file…';

  @override
  String get desktopShortcutsApp => 'App';

  @override
  String get desktopShortcutsClip => 'On a chosen clip';

  @override
  String get desktopShortcutsPlayback => 'Playing';

  @override
  String get desktopShortcutsTitle => 'Keyboard shortcuts';

  @override
  String get desktopShortcutsWindow => 'Window';

  @override
  String get desktopShortsHint =>
      '↑ ↓ or the wheel for the next short · double-click to favorite';

  @override
  String get desktopShowInFolder => 'Show in folder';

  @override
  String get desktopShowPanel => 'Show side panel';

  @override
  String get desktopStartFresh => 'Start fresh';

  @override
  String get desktopStartWithWindows => 'Start with Windows';

  @override
  String get desktopStartWithWindowsHint =>
      'Opens when you sign in: in the tray when it keeps playing there, otherwise minimized.';

  @override
  String get desktopStartWithWindowsRefused =>
      'Windows did not let the app start with it.';

  @override
  String get desktopStats => 'Library statistics';

  @override
  String get desktopStatsByChannel => 'By channel';

  @override
  String get desktopStatsByMonth => 'By month added';

  @override
  String get desktopStatsBySite => 'By site';

  @override
  String get desktopStatsClips => 'Clips';

  @override
  String get desktopStatsHint =>
      'What the library holds, and what may deserve a look. Nothing is deleted from here.';

  @override
  String desktopStatsHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
      zero: 'Under an hour',
    );
    return '$_temp0';
  }

  @override
  String get desktopStatsLargest => 'The largest:';

  @override
  String get desktopStatsLength => 'Running time';

  @override
  String get desktopStatsLink => 'Statistics';

  @override
  String get desktopStatsNeverPlayed => 'Never played here';

  @override
  String get desktopStatsNewest => 'The newest:';

  @override
  String get desktopStatsOtherChannels => 'Other channels';

  @override
  String get desktopStatsRoom => 'Room taken';

  @override
  String get desktopStatsUnnamed => 'No channel named';

  @override
  String get desktopStatsWithText => 'With a transcript';

  @override
  String get desktopStatsWithoutText => 'Without a transcript';

  @override
  String get desktopStatsWorthALook => 'Worth a look';

  @override
  String get desktopSubtitleOptions => 'Subtitle options';

  @override
  String get desktopTheater => 'Theater';

  @override
  String get desktopTranscriptFirst => 'Fetch its transcript first';

  @override
  String get desktopTranscriptHint => 'Follows playback · click a line to jump';

  @override
  String get desktopTranscriptsDeleteBody =>
      'They are removed from this computer and from its backup. Only a file you exported can bring them back.';

  @override
  String get desktopTranscriptsHelp =>
      'VidHoist keeps the words said in each YouTube clip you add, so a search (Ctrl+K) also finds what was said inside your clips, not only their titles. They stay on this computer.';

  @override
  String get desktopTranscriptsMove => 'To or from a phone';

  @override
  String get desktopTranscriptsMoveHint =>
      'Transcripts travel with the backup: Export for the phone takes them, and Import there brings them in, adding what is missing here.';

  @override
  String get desktopTrayOnClose =>
      'Keep playing in the tray when the window closes';

  @override
  String get desktopTrayOnCloseHint =>
      'Closing the window keeps the sound playing; quit from the icon by the clock.';

  @override
  String get desktopTrayOpen => 'Open VidHoist';

  @override
  String get desktopTrayQuit => 'Quit';

  @override
  String get desktopUiSize => 'Interface size';

  @override
  String desktopUiSizeHint(String bigger, String smaller, String reset) {
    return '$bigger and $smaller change it from anywhere, and $reset returns to 100%.';
  }

  @override
  String get desktopUiSizeTooLarge => 'Too large for this screen';

  @override
  String get desktopUpdateInstall => 'Install and restart';

  @override
  String get desktopUpdateRestartHint =>
      'VidHoist closes, installs the update and opens again. Your settings and library stay as they are.';

  @override
  String get desktopViewCompact => 'Compact';

  @override
  String get desktopViewTable => 'Table';

  @override
  String get desktopVolume => 'Volume';

  @override
  String desktopVolumeLevel(int percent) {
    return 'Volume $percent%';
  }

  @override
  String get desktopWelcomeFetchNow => 'Fetch them now';

  @override
  String get desktopWelcomeHelpers =>
      'ffmpeg (joins picture and sound) and Deno (needed by YouTube) come down by themselves at the first download, about 160 MB. You can fetch them now instead.';

  @override
  String get desktopWelcomeMessage =>
      'Paste a link from YouTube or another site, and VidHoist downloads it to this computer with yt-dlp. Nothing goes through a server.';

  @override
  String get desktopWelcomeStart => 'Start';

  @override
  String get desktopWelcomeTitle => 'Welcome to VidHoist';

  @override
  String get desktopWhatsNewAllFeatures => 'Everything VidHoist can do';

  @override
  String get desktopWidenSidebar => 'Expand sidebar';

  @override
  String get desktopWindowClose => 'Close';

  @override
  String get desktopWindowMaximize => 'Maximize';

  @override
  String get desktopWindowMinimize => 'Minimize';

  @override
  String get desktopWindowRestore => 'Restore down';

  @override
  String get desktopZoomChange => 'Change';

  @override
  String desktopZoomLowered(String percent) {
    return 'The interface is now $percent so it fits this screen.';
  }

  @override
  String get details => 'Details';

  @override
  String get developer => 'Developer';

  @override
  String get developerName => 'Yasir Sagheer';

  @override
  String get diagnosticLogs => 'Diagnostic logs';

  @override
  String get diagnosticLogsSubtitle =>
      'View, search, and share app logs (redacted)';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get disclaimerText =>
      'This app downloads media with yt-dlp. The developer is not responsible for how users utilize this tool. Please respect copyright laws and terms of service of content platforms.';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get done => 'Done';

  @override
  String get download => 'Download';

  @override
  String get downloadComplete => 'Download complete';

  @override
  String get downloadCompleteTitle => 'Complete';

  @override
  String get downloadDate => 'Download date';

  @override
  String get downloadFailed => 'Download failed';

  @override
  String get downloadFailedTitle => 'Download failed';

  @override
  String get downloadNow => 'Download';

  @override
  String get downloadStarted => 'Download started…';

  @override
  String downloadStartedQuality(Object quality) {
    return 'Download started · $quality';
  }

  @override
  String get downloading => 'Downloading…';

  @override
  String get downloadingTitle => 'Downloading';

  @override
  String get downloadsAdvanced => 'Advanced';

  @override
  String get editSubscription => 'Edit';

  @override
  String get embedSubtitles => 'Subtitles inside the video too';

  @override
  String get embedSubtitlesHelp =>
      'So other players show them. VidHoist\'s own player shows them either way.';

  @override
  String get emptyFilteredMessage =>
      'Clear a filter above to see your whole library.';

  @override
  String get emptyFilteredTitle => 'Nothing matches these filters';

  @override
  String get emptyLibraryMessage => 'Add a video link, or pull to refresh.';

  @override
  String get emptyPlaylist => 'Empty playlist';

  @override
  String get emptyPlaylistMessage => 'Add videos from the library';

  @override
  String engineDownloadingProgress(Object percent) {
    return 'Downloading · $percent%';
  }

  @override
  String get engineErrDiskFull => 'Not enough storage space for this file';

  @override
  String engineErrFailed(Object reason) {
    return 'Download failed: $reason';
  }

  @override
  String get engineErrFormat => 'This quality is not available for this video';

  @override
  String get engineErrGeoBlocked => 'Not available in your country';

  @override
  String get engineErrMissing =>
      'The download engine is missing or incomplete. Set it up again from Settings';

  @override
  String get engineErrRateLimited =>
      'The site is limiting requests. Try again in a while';

  @override
  String get engineErrUnavailable =>
      'This video is unavailable, private or removed';

  @override
  String get engineErrUnsupported => 'This link is not supported';

  @override
  String get enginePaused => 'Paused';

  @override
  String get enginePostprocessing => 'Finishing the file…';

  @override
  String get enginePreparing => 'Reading the link…';

  @override
  String get engineRepair => 'Repair the engine';

  @override
  String get engineRepairBusy =>
      'Wait for the downloads to finish, then repair';

  @override
  String get engineRepairHint =>
      'When downloads fail across sites as they did not before, and an update did not help: clears what yt-dlp saved and puts back a clean, current copy. Your downloads and settings stay as they are.';

  @override
  String get engineRepairPartly =>
      'Repaired in part: the rest needs a connection. Try again once online.';

  @override
  String engineRepaired(String version) {
    return 'Repaired: yt-dlp $version';
  }

  @override
  String get engineRepairing => 'Repairing…';

  @override
  String get engineResume => 'Resume';

  @override
  String get enterFullscreen => 'Fullscreen';

  @override
  String errClipPastEnd(Object length) {
    return 'The part starts after the video ends ($length)';
  }

  @override
  String get errClipPastEndUnknown => 'The part starts after the video ends';

  @override
  String get errNetwork => 'No connection to the site';

  @override
  String get errPlatformBlocked =>
      'The platform requires a login, which this clip cannot be downloaded without';

  @override
  String get errPlatformBlockedCookies =>
      'The platform requires login. Send it a cookies file from Settings → Cookies';

  @override
  String errorGeneric(Object message) {
    return 'Error: $message';
  }

  @override
  String get every30Minutes => 'Every 30 minutes';

  @override
  String everyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count hours',
      one: 'Every hour',
    );
    return '$_temp0';
  }

  @override
  String get exitFullscreen => 'Exit fullscreen';

  @override
  String get exportShare => 'Export & share';

  @override
  String get exportShareSubtitle => 'A dated copy to send or keep elsewhere';

  @override
  String get externalPlayerShort => 'Another player';

  @override
  String get failed => 'Failed';

  @override
  String get failedToLoadPlaylist => 'Failed to load playlist';

  @override
  String get fastStreams => 'Faster segmented streams';

  @override
  String fastStreamsHelp(int count) {
    return 'Fetches $count pieces at once from sites that cut a video into pieces, such as X. Some sites slow down many requests at once.';
  }

  @override
  String get favorites => 'Favorites';

  @override
  String get file => 'File';

  @override
  String get fileName => 'File name';

  @override
  String get fileSize => 'File size';

  @override
  String get filterAll => 'All';

  @override
  String get filterAudio => 'Audio';

  @override
  String get filterVideo => 'Video';

  @override
  String get filtersOn => 'Filters on';

  @override
  String get folder => 'Folder';

  @override
  String get foldersHelp =>
      'A folder is made inside the download folder, and the clip is saved straight into it, where Explorer and any other app see it. Leave it at \"No folder\" and the clip goes to the top of the download folder.';

  @override
  String get follow => 'Follow';

  @override
  String get followChannel => 'Follow a channel';

  @override
  String get followingChannel => 'Following';

  @override
  String get format => 'Format';

  @override
  String framesPerSecond(int count) {
    return '$count fps';
  }

  @override
  String get helpAboutField => 'About this field';

  @override
  String get inPlaylists => 'In playlists';

  @override
  String get invalidUrl => 'Enter a valid link';

  @override
  String get itemOptions => 'Item options';

  @override
  String get itemUnavailable => 'No longer available';

  @override
  String get jumpToNewest => 'Go to the newest';

  @override
  String get justNow => 'just now';

  @override
  String knownVideos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count videos known',
      one: '1 video known',
      zero: 'Nothing known yet',
    );
    return '$_temp0';
  }

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageSystemHint => 'Follows your phone\'s language';

  @override
  String lastBackup(String when) {
    return 'Last backup $when';
  }

  @override
  String lastCheckedAt(String when) {
    return 'Last checked $when';
  }

  @override
  String get latestAdditions => 'Latest additions';

  @override
  String get licensedUnder => 'Licensed under GPL-3.0';

  @override
  String get licenses => 'Open-source licenses';

  @override
  String get listSeparator => ', ';

  @override
  String get listenInBackground => 'Listen in the background';

  @override
  String get lockTouch => 'Lock touch';

  @override
  String get loginDone => 'Done';

  @override
  String loginKept(String site) {
    return 'Signed in to $site; downloads will use it';
  }

  @override
  String get loginNotYet =>
      'No sign-in found yet. Finish signing in, then tap Done';

  @override
  String get logsEmpty => 'The log is empty';

  @override
  String get logsSanitizedNote =>
      'Links, addresses and credentials are stripped before sharing';

  @override
  String get manageTags => 'Manage tags';

  @override
  String get mediaAccessBlockedMessage =>
      'Android will not ask again. Turn on photos and videos for this app in the system settings, then come back.';

  @override
  String get mediaAccessGrant => 'Allow';

  @override
  String get mediaAccessMessage =>
      'Your downloads are kept in the phone\'s Download folder, and Android needs your permission before the app can list them.';

  @override
  String get mediaAccessOpenSettings => 'Open settings';

  @override
  String get mediaAccessTitle => 'Allow access to your media';

  @override
  String get mobileChannelsEmptyBody =>
      'Follow a channel and each new video downloads by itself while VidHoist is open or in the background; what came while it was closed downloads when it opens. What is already on the channel is not downloaded.';

  @override
  String get mobileChannelsHint =>
      'New videos from channels you follow, downloaded by themselves';

  @override
  String get mobileEngineIpv4 => 'Connect over IPv4';

  @override
  String get mobileEngineIpv4Help =>
      'Avoids a long stall on networks whose IPv6 route is broken. Turn it off only if your network has IPv6 alone.';

  @override
  String mobileEngineLastUpdate(String when) {
    return 'Last updated $when';
  }

  @override
  String get mobileEngineNotReady => 'Getting ready…';

  @override
  String get mobileEngineUpToDate => 'yt-dlp is up to date';

  @override
  String get mobileEngineUpdate => 'Update yt-dlp';

  @override
  String get mobileEngineUpdateFailed =>
      'Couldn\'t update yt-dlp. Check the connection and try again.';

  @override
  String get mobileEngineUpdateMissed => 'Update failed';

  @override
  String get mobileEngineUpdated => 'Updated';

  @override
  String get mobileEngineUpdating => 'Updating…';

  @override
  String get mobileEngineVersionLabel => 'yt-dlp version';

  @override
  String get mobileEngineVersionUnknown =>
      'Its version shows after the first update';

  @override
  String get mobileSettingsEngine => 'Download engine';

  @override
  String get mobileSettingsGroupEngine => 'Engine';

  @override
  String get mobileSignInNeeded =>
      'This site wants you signed in. Sign in from Settings › Accounts, then retry';

  @override
  String get mobileSubtitleOptions => 'Size, background and the transcript';

  @override
  String get mobileSubtitleStyleHelp =>
      'Also in the player: hold the CC button.';

  @override
  String get mobileSubtitles => 'Download subtitles';

  @override
  String get mobileSubtitlesHelp =>
      'Subtitles in the languages below, when the video has them, saved beside it and shown in the player.';

  @override
  String get mobileSubtitlesSizeLarger => 'Larger';

  @override
  String get mobileTranscript => 'Transcript';

  @override
  String get mobileTranscriptHint => 'Tap a line to play from there.';

  @override
  String get mobileTranscriptOpen => 'Read the transcript';

  @override
  String get mobileWelcomeBody =>
      'Videos and audio from the sites you use, saved straight to this phone. The download engine is getting ready; this happens only once.';

  @override
  String get mobileWelcomeFailed =>
      'The engine couldn\'t start. Try again; if it keeps failing, reinstall the app.';

  @override
  String get mobileWelcomeStart => 'Start';

  @override
  String get mobileWelcomeTitle => 'Welcome to VidHoist';

  @override
  String get mobileWelcomeUnpacking => 'Preparing the download engine';

  @override
  String get mobileWelcomeUpdateFailed =>
      'Couldn\'t update now. VidHoist tries again before your first download.';

  @override
  String get mobileWelcomeUpdating => 'Updating yt-dlp to its latest version';

  @override
  String get modeAutoNext => 'Auto';

  @override
  String get modeRepeatAll => 'Repeat all';

  @override
  String get modeRepeatOne => 'Repeat one';

  @override
  String get modeStopAtEnd => 'Stop at end';

  @override
  String moreChips(int count) {
    return 'More · $count';
  }

  @override
  String get navLibrary => 'Library';

  @override
  String get navMyDownloads => 'My downloads';

  @override
  String get navPlaylists => 'Playlists';

  @override
  String get navSettings => 'Settings';

  @override
  String get needsAttention => 'Needs your attention';

  @override
  String get neverChecked => 'Not checked yet';

  @override
  String get newFolder => 'New folder…';

  @override
  String get newFolderHint => 'e.g. Ai/Lessons';

  @override
  String get newPlaylistAction => 'New playlist';

  @override
  String get newTagHint => 'New tag';

  @override
  String get next => 'Next';

  @override
  String get noBackupsYet => 'No backups yet';

  @override
  String get noDownloads => 'No downloads';

  @override
  String get noDownloadsMessage =>
      'Downloaded videos will appear here.\nShare a video link or use the Add URL button.';

  @override
  String get noExternalPlayer => 'No external player on this device';

  @override
  String get noFolder => 'No folder';

  @override
  String get noFolderHint => 'At the top of the downloads';

  @override
  String get noLogsFound => 'No logs found';

  @override
  String get noPlayableSource => 'This item has no playable source';

  @override
  String get noPlaylistsMessage => 'Create a playlist to organize your videos';

  @override
  String get noResults => 'No results';

  @override
  String get noResultsMessage => 'No items match your search.';

  @override
  String get noServerTitle => 'The download engine is not ready';

  @override
  String get noTagsYet => 'No tags yet. Create one below.';

  @override
  String get noVideosFound => 'Your library is empty';

  @override
  String get noWarranty => 'Provided as is, without any warranty.';

  @override
  String get notAffiliated =>
      'Not affiliated with yt-dlp or with any content platform, and not endorsed by them.';

  @override
  String get nothingHereYet => 'Nothing here yet';

  @override
  String get nowPlaying => 'Now playing';

  @override
  String get nowPlayingCollapse => 'Fold the player panel';

  @override
  String get nowPlayingExpand => 'Show the player panel';

  @override
  String get ok => 'OK';

  @override
  String get onlyNewVideos =>
      'Only what appears from now on is downloaded. The videos already on the channel are left where they are.';

  @override
  String get openChannel => 'Open channel';

  @override
  String get openInExternalPlayer => 'Open in another player';

  @override
  String get openOriginalLink => 'Open original link';

  @override
  String get ownFolder => 'Save in its own folder';

  @override
  String get ownFolderNote =>
      'A folder inside the download folder, which Explorer and other apps see too. Only what arrives from now on goes there; what is already downloaded stays where it is.';

  @override
  String get password => 'Password';

  @override
  String get pasteUrlHint => 'Paste the link here…';

  @override
  String get pause => 'Pause';

  @override
  String get pauseSubscription => 'Pause';

  @override
  String get pcAddressLabel => 'Address';

  @override
  String get pcBadAddress =>
      'Type the address as the computer shows it, for example 192.168.1.24.';

  @override
  String get pcBadQr => 'This is not a VidHoist pairing code.';

  @override
  String get pcCertificate => 'Computer\'s certificate';

  @override
  String get pcCodeLabel => 'Code';

  @override
  String get pcConnected => 'Connected';

  @override
  String get pcCopied => 'Copied to the phone\'s library, with its subtitles.';

  @override
  String get pcCopyFailed =>
      'The copy did not finish: the computer may be off or out of reach. Nothing was kept.';

  @override
  String get pcCopyStarting => 'Copying…';

  @override
  String get pcCopyStop => 'Stop copying';

  @override
  String get pcCopyToPhone => 'Copy to the phone';

  @override
  String pcCopying(int percent) {
    return 'Copying $percent%';
  }

  @override
  String get pcDelete => 'Delete from the computer';

  @override
  String pcDeleteBody(String title) {
    return '\"$title\" goes to the computer\'s Recycle Bin, where it can be got back.';
  }

  @override
  String get pcDeleteFailed =>
      'The computer could not delete it. It may be open there.';

  @override
  String get pcDeleteMissing => 'This clip is no longer on the computer.';

  @override
  String get pcDeleteNoBin =>
      'Not deleted: its drive on the computer has no Recycle Bin.';

  @override
  String get pcDeleteNotAllowed =>
      'The computer does not let the phone delete. Turn it on there in Settings › Phone.';

  @override
  String pcDeleteTitle(String name) {
    return 'Delete from $name?';
  }

  @override
  String pcDeleted(String title) {
    return 'In the computer\'s Recycle Bin: $title';
  }

  @override
  String get pcDestPhone => 'This phone';

  @override
  String pcDoneOnPc(String title) {
    return 'Done on the computer: $title';
  }

  @override
  String pcDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count downloads for the computer',
      one: '1 download for the computer',
    );
    return '$_temp0';
  }

  @override
  String get pcDownloadsSheet => 'Downloads on the computer';

  @override
  String get pcEmptyLibrary => 'No downloads on the computer yet.';

  @override
  String get pcErrBad =>
      'The computer answered in a way this version does not understand. Update both apps.';

  @override
  String get pcErrClosed =>
      'No code is showing on the computer, or it expired. Press Pair a phone there.';

  @override
  String get pcErrDenied =>
      'The pairing was refused on the computer, or not answered in time.';

  @override
  String get pcErrRefused => 'The computer would not take this link.';

  @override
  String get pcErrUnauthorized =>
      'The computer no longer knows this phone. Pair again.';

  @override
  String get pcErrUnreachable =>
      'The computer did not answer. Is it on, on this network or on your Tailscale, with \"Receive from the phone\" turned on?';

  @override
  String get pcErrWrongCertificate =>
      'Something other than your computer answered at this address. Nothing was sent.';

  @override
  String get pcErrWrongCode => 'Wrong code.';

  @override
  String get pcFindNone =>
      'No computer found. On the computer, open Settings › Phone › Pair a phone first, on the same Wi-Fi.';

  @override
  String get pcFindOnNetwork => 'Find on the network';

  @override
  String get pcFirewallAllow => 'Allow';

  @override
  String get pcFirewallBlocked =>
      'Windows Firewall blocks VidHoist, so the phone cannot reach it. Allow it on home (private) networks.';

  @override
  String get pcFirewallMissing =>
      'Windows has not let VidHoist receive from the phone yet. Allow it once, on home (private) networks only.';

  @override
  String get pcFirewallPublic =>
      'Windows calls this network Public, and lets nothing in there. If it is your home network, make it Private: Settings › Network & internet › Wi-Fi › its properties.';

  @override
  String get pcFirewallRefused =>
      'Nothing changed: Windows needs an administrator\'s permission.';

  @override
  String get pcFirewallTitle => 'Windows Firewall';

  @override
  String pcFound(String name) {
    return 'Found $name. Type the code it shows.';
  }

  @override
  String pcLastContact(String time) {
    return 'Last contact $time';
  }

  @override
  String get pcLibrary => 'Library on the computer';

  @override
  String get pcLinkAddress => 'Address on this network';

  @override
  String get pcLinkAddressTailscale => 'Through Tailscale, from outside home';

  @override
  String get pcLinkAllow => 'Allow';

  @override
  String get pcLinkAllowDelete => 'Let the phone delete clips';

  @override
  String get pcLinkAllowDeleteHint =>
      'A clip deleted from the phone goes to this computer\'s Recycle Bin, where you can get it back. On a drive with no Recycle Bin it is not deleted.';

  @override
  String get pcLinkCodeHint =>
      'On the phone: Settings › Computer › Scan the code. Or type this address and code there. It works once, for two minutes.';

  @override
  String pcLinkCodeLeft(int seconds) {
    return '$seconds s left';
  }

  @override
  String get pcLinkCodeTitle => 'Pairing code';

  @override
  String get pcLinkDeny => 'Refuse';

  @override
  String get pcLinkDevices => 'Paired phones';

  @override
  String pcLinkFailed(String error) {
    return 'Could not start: $error';
  }

  @override
  String get pcLinkIntro =>
      'Send links from VidHoist on your phone to this computer, and see its downloads and library there. Works inside your home network, and from outside it through Tailscale.';

  @override
  String pcLinkLastSeen(String time) {
    return 'Last heard from $time';
  }

  @override
  String get pcLinkNoDevices => 'No phone yet.';

  @override
  String get pcLinkOff => 'Off';

  @override
  String pcLinkOtherAddresses(int count) {
    return 'Other addresses ($count)';
  }

  @override
  String get pcLinkOtherAddressesHint =>
      'Network adapters other programs add, such as VirtualBox or WSL. The phone rarely needs them.';

  @override
  String get pcLinkPairPhone => 'Pair a phone';

  @override
  String pcLinkPairedAt(String time) {
    return 'Paired $time';
  }

  @override
  String pcLinkPhones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count phones',
      one: 'One phone',
      zero: 'No phone',
    );
    return '$_temp0';
  }

  @override
  String get pcLinkQrHint => 'Scan from the phone';

  @override
  String get pcLinkReceive => 'Receive from the phone';

  @override
  String get pcLinkReceiveHint =>
      'While it is off, no port is open on this computer. If Windows asks, allow private networks only.';

  @override
  String pcLinkRequest(String name) {
    return '$name asks to pair';
  }

  @override
  String get pcLinkRequestHint =>
      'Allow only if the phone shows the same four digits.';

  @override
  String get pcLinkRevoke => 'Unpair';

  @override
  String get pcLinkSecurity =>
      'Nothing passes through any server of ours: the phone talks to this computer directly, on your network or over your Tailscale. It pairs once, with the code and your approval here; after that it presents its own key with every request, over a connection encrypted with this computer\'s certificate alone. Anyone else on the network finds a closed door.';

  @override
  String get pcLinkStarting => 'Starting…';

  @override
  String get pcLinkTitle => 'Phone';

  @override
  String get pcListEmpty =>
      'None of this list\'s clips is on the computer any more.';

  @override
  String get pcListen => 'Listen';

  @override
  String get pcLists => 'Lists on the computer';

  @override
  String get pcListsEmpty => 'No list on the computer has clips in it.';

  @override
  String get pcNow => 'On the computer now';

  @override
  String get pcOffline => 'Unavailable';

  @override
  String get pcOfflineMessage =>
      'The computer is off or on another network. What it had last time is shown below.';

  @override
  String get pcOfflineRoute =>
      'Away from home? Choose Tailscale in Settings › Computer.';

  @override
  String get pcOnPhone => 'On the phone';

  @override
  String get pcOrType => 'Or type the address and code';

  @override
  String get pcOutboxRefused => 'The computer would not take this link';

  @override
  String pcOutboxTitle(int count) {
    return 'Waiting to send ($count)';
  }

  @override
  String get pcPairButton => 'Pair';

  @override
  String pcPairCheck(String check) {
    return 'Check that the computer shows $check, then allow the phone there.';
  }

  @override
  String get pcPairIntro =>
      'If VidHoist runs on your Windows computer, this phone can send it links and show its downloads and library. On the computer, turn on Settings › Phone and press Pair a phone, then scan the code it shows.';

  @override
  String get pcPairStart => 'Pair with a computer';

  @override
  String pcPaired(String name) {
    return 'Paired with $name';
  }

  @override
  String get pcPortLabel => 'Port';

  @override
  String pcQueued(String name) {
    return 'It goes to $name when it is back.';
  }

  @override
  String pcQueuedMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clips go to $name when it is back.',
      one: '1 clip goes to $name when it is back.',
    );
    return '$_temp0';
  }

  @override
  String get pcRouteHint =>
      'Choose Tailscale when you are away from home; it must be running on both the phone and the computer.';

  @override
  String get pcRouteHome => 'Home network';

  @override
  String get pcRouteOther => 'Another network';

  @override
  String get pcRouteTailscale => 'Tailscale';

  @override
  String get pcRouteTitle => 'Connect through';

  @override
  String get pcRouteWaiting =>
      'The computer\'s other routes show here once it answers.';

  @override
  String get pcScanButton => 'Scan the code';

  @override
  String get pcScanFailed => 'The camera could not be opened.';

  @override
  String get pcScanPrompt =>
      'Point the camera at the code on the computer\'s screen';

  @override
  String get pcSendToPc => 'Send to the computer';

  @override
  String pcSent(String name) {
    return 'Sent to $name';
  }

  @override
  String pcSentMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clips sent to $name',
      one: '1 clip sent to $name',
    );
    return '$_temp0';
  }

  @override
  String get pcSettingsHint => 'Send links to your computer';

  @override
  String get pcTab => 'Computer';

  @override
  String pcVia(String route) {
    return 'Through $route';
  }

  @override
  String get pcWatch => 'Watch';

  @override
  String get pcWillSend => 'Away: sent when it is back';

  @override
  String percentValue(Object percent) {
    return '$percent%';
  }

  @override
  String get pickAnotherFile => 'From another file…';

  @override
  String get pickAnotherFileSubtitle =>
      'A backup from another phone or an older version';

  @override
  String get pictureInPicture => 'Picture in picture';

  @override
  String get pictureInPictureHelp =>
      'When you leave the app while a video plays, it stays in a corner of the screen';

  @override
  String get pinPlaylist => 'Pin to top';

  @override
  String get platform => 'Platform';

  @override
  String platformCount(Object name, int count) {
    return '$name · $count';
  }

  @override
  String get platformOther => 'Other';

  @override
  String get play => 'Play';

  @override
  String get playAll => 'Play all';

  @override
  String get playModeLabel => 'Mode';

  @override
  String get playbackSpeed => 'Playback speed';

  @override
  String get playerError => 'Couldn\'t play this file';

  @override
  String get playingFromDevice => 'Playing from your device';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistCreated => 'Playlist created';

  @override
  String get playlistDeleted => 'Playlist deleted';

  @override
  String get playlistDetails => 'Playlist details';

  @override
  String get playlistEditHint =>
      'Long-press a clip to move it. Swipe it aside to remove it.';

  @override
  String get playlistName => 'Playlist name';

  @override
  String get playlistNameHint => 'My playlist';

  @override
  String playlistOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get playlists => 'Playlists';

  @override
  String get preferences => 'Preferences';

  @override
  String get previous => 'Previous';

  @override
  String get quality => 'Quality';

  @override
  String get quality1080 => 'Up to 1080p';

  @override
  String get quality360 => 'Up to 360p';

  @override
  String get quality480 => 'Up to 480p';

  @override
  String get quality720 => 'Up to 720p';

  @override
  String get qualityAudio => 'Audio';

  @override
  String get qualityBest => 'Best';

  @override
  String get qualityHelper =>
      'Used by quick download, by whole-playlist downloads, and by \"Download now\" in the clipboard bar, and it is the preselected option in the add-link sheet. So it matters whether or not quick download is on.';

  @override
  String get qualityReading => 'Reading the file…';

  @override
  String get qualityUnavailable => 'Unavailable';

  @override
  String get qualityVideo => 'Video';

  @override
  String queueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get queueLabel => 'Queue';

  @override
  String queuePosition(int position) {
    return 'Number $position in line';
  }

  @override
  String get queued => 'Queued';

  @override
  String get queuedSection => 'Waiting';

  @override
  String get quickDownload => 'Quick download';

  @override
  String get quickDownloadHelp =>
      'A shared or pasted link starts downloading immediately at the default quality, with no sheet. Numeric qualities are YouTube-only: anything else downloads at best quality, and an \"audio only\" default applies everywhere.';

  @override
  String get quoteExtendHint => 'Touch another line to take it in';

  @override
  String get quoteMomentLink => 'Copy link to this moment';

  @override
  String get quotePlayFrom => 'Play from here';

  @override
  String get quoteTitle => 'Quote';

  @override
  String get rateLimit => 'Speed limit';

  @override
  String get rateLimitNone => 'No limit';

  @override
  String rateLimitValue(int mb) {
    return '$mb MB/s';
  }

  @override
  String get readingAsMarkdownHint =>
      'Each paragraph with its time, linked to its moment';

  @override
  String get readingAsPdfHint => 'To print or keep';

  @override
  String get readingAsSrtHint => 'Line by line with its times, for any player';

  @override
  String get readingAsText => 'Text to read';

  @override
  String get readingAsTextHint => 'Paragraphs without times, to paste anywhere';

  @override
  String get readingHint => 'Tap a sentence to hear it from there';

  @override
  String readingMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'About $count minutes to read',
      one: 'About a minute to read',
    );
    return '$_temp0';
  }

  @override
  String get readingRead => 'Read';

  @override
  String get readingShare => 'Share the text';

  @override
  String get readingTextSize => 'Text size';

  @override
  String get reelsEndBack => 'Back to library';

  @override
  String get reelsEndContinue => 'Continue the rest of the list';

  @override
  String get reelsEndReplay => 'Replay from the start';

  @override
  String get reelsEndTitle => 'End of the shorts lane';

  @override
  String get reelsSwipeHint => 'Swipe up for the next short';

  @override
  String get refresh => 'Refresh';

  @override
  String get remove => 'Remove';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String removeUnavailable(int count) {
    return 'Remove $count unavailable';
  }

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get removedFromPlaylist => 'Removed from the playlist';

  @override
  String get rename => 'Rename';

  @override
  String get renameTag => 'Rename tag';

  @override
  String get reportBug => 'Report a bug';

  @override
  String get restoreConfirm =>
      'Restore data from the backup file? This overwrites current playlists, tags and settings.';

  @override
  String get restoreData => 'Restore';

  @override
  String get restoreFailed => 'Restore failed: the backup file is not valid';

  @override
  String get restorePickBody =>
      'This phone has VidHoist downloads but no settings, as after a reinstall. If you kept a backup, choose it: the app writes them to Download/VidHoist/backups.';

  @override
  String get restorePickChoose => 'Choose a backup';

  @override
  String get restorePickTitle => 'Bring back your settings?';

  @override
  String get restoreSettings => 'Restore all data';

  @override
  String get restoreSuccess => 'Data restored successfully';

  @override
  String resultsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
    );
    return '$_temp0';
  }

  @override
  String get resumeSubscription => 'Resume';

  @override
  String get retry => 'Retry';

  @override
  String get retryAll => 'Retry all';

  @override
  String get saveSettings => 'Save settings';

  @override
  String get searchLogs => 'Search logs…';

  @override
  String get searchVideos => 'Search videos...';

  @override
  String get seekBackward10 => 'Back 10 seconds';

  @override
  String get seekForward10 => 'Forward 10 seconds';

  @override
  String get selectAll => 'Select all';

  @override
  String selected(int count) {
    return '$count selected';
  }

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get settings => 'Settings';

  @override
  String get settingsAccounts => 'Accounts';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get settingsDownloads => 'Downloads';

  @override
  String get settingsGroupApp => 'App';

  @override
  String get settingsGroupData => 'Data';

  @override
  String get settingsPlayback => 'Playback';

  @override
  String get settingsSaved => 'Settings saved successfully';

  @override
  String get settingsTranscripts => 'Transcripts & subtitles';

  @override
  String settingsValueChannels(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count channels',
      one: '1 channel',
      zero: 'No channels yet',
    );
    return '$_temp0';
  }

  @override
  String get settingsValueCompatOff => 'Best compatibility: off';

  @override
  String get settingsValueCompatOn => 'Best compatibility: on';

  @override
  String get settingsValueNotSet => 'Not set up yet';

  @override
  String get settingsValueOff => 'Off';

  @override
  String get settingsValueOn => 'On';

  @override
  String get settingsValueQuick => 'quick';

  @override
  String settingsValueSignedIn(String sites) {
    return 'Signed in: $sites';
  }

  @override
  String get settingsValueSubtitlesShown => 'subtitles shown';

  @override
  String get settingsValueWifiOnly => 'Wi‑Fi only';

  @override
  String get share => 'Share';

  @override
  String get shareLogs => 'Share logs';

  @override
  String get shareOpening => 'Opening the share menu…';

  @override
  String get shareOpeningHint =>
      'A large file takes a few seconds to hand over.';

  @override
  String get shareSelected => 'Share selected';

  @override
  String get sharedLinksAdd => 'Add them';

  @override
  String get sharedLinksBody => 'Each one downloads to this phone.';

  @override
  String sharedLinksCapped(int max) {
    return 'Only the first $max links were added.';
  }

  @override
  String sharedLinksTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count links?',
      one: 'Add 1 link?',
    );
    return '$_temp0';
  }

  @override
  String get shortsFilter => 'Shorts';

  @override
  String showChannel(String channel) {
    return 'Everything from $channel';
  }

  @override
  String get shuffle => 'Shuffle';

  @override
  String get signInRequired => 'Sign-in required';

  @override
  String get size => 'Size';

  @override
  String get smartPlaylists => 'Smart playlists';

  @override
  String get sortAndFilter => 'Sort and filter';

  @override
  String get sortAndPlatform => 'Sort and platform';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortLargest => 'Largest';

  @override
  String get sortNameAZ => 'Name A–Z';

  @override
  String get sortNameZA => 'Name Z–A';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortOldest => 'Oldest';

  @override
  String get sortSmallest => 'Smallest';

  @override
  String get sortedByLastPlayed => 'By last played';

  @override
  String get source => 'Source';

  @override
  String get sourceCode => 'Source code';

  @override
  String get startDownload => 'Start download';

  @override
  String get status => 'Status';

  @override
  String get storageCardMissing =>
      'The card is not in, so downloads go to the phone';

  @override
  String get storageLocation => 'Save to';

  @override
  String get storageLocationHelp =>
      'Clips already downloaded stay where they are and still show in the library. A memory card needs Android 11 or later.';

  @override
  String get storageNoCard => 'No memory card in this phone';

  @override
  String get storagePhone => 'Phone storage';

  @override
  String get streamingOnline => 'Streaming online';

  @override
  String subscriptionAdded(String name) {
    return 'Now following $name';
  }

  @override
  String get subscriptionName => 'Name';

  @override
  String get subscriptionPaused => 'Paused';

  @override
  String get subscriptionQuality => 'Quality for this channel';

  @override
  String get subscriptionQualityHelp =>
      'The quality is set when you follow and can\'t be changed afterwards. To change it: Check now, then unfollow and follow again.\n\n\"Best\" can mean 4K in the AV1 format, which an older computer may play with stutters: choose 1080p if it does.';

  @override
  String get subscriptionQualityNote => 'Can\'t be changed after following.';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get subscriptionsEmpty => 'No channels followed yet';

  @override
  String get subscriptionsEmptyBody =>
      'Follow a channel and each new video downloads into your library by itself, while VidHoist is open or in the tray. What is already on the channel is not downloaded.';

  @override
  String get subscriptionsSubtitle =>
      'New videos from channels you follow, downloaded by themselves';

  @override
  String get subtitleLangs => 'Subtitle languages';

  @override
  String get subtitleLangsHelp =>
      'Fetched when the video has them. One at least stays chosen.';

  @override
  String get subtitles => 'Subtitles';

  @override
  String get subtitlesBackground => 'Background';

  @override
  String get subtitlesBackgroundFaint => 'Light';

  @override
  String get subtitlesBackgroundHelp =>
      'What sits behind the words. With none, each letter keeps a dark edge so it still reads over a bright picture.';

  @override
  String get subtitlesBackgroundNone => 'None';

  @override
  String get subtitlesBackgroundSolid => 'Dark';

  @override
  String get subtitlesHide => 'Hide subtitles';

  @override
  String get subtitlesInShorts => 'Subtitles in shorts';

  @override
  String get subtitlesInShortsHelp =>
      'Off unless you turn it on: many shorts already carry their words in the picture.';

  @override
  String get subtitlesLanguage => 'Subtitle language';

  @override
  String get subtitlesShow => 'Show subtitles';

  @override
  String get subtitlesShowHelp =>
      'Over the video, for clips that have a transcript. The CC button in the player does the same.';

  @override
  String get subtitlesSize => 'Text size';

  @override
  String get subtitlesSizeLarge => 'Large';

  @override
  String get subtitlesSizeMedium => 'Medium';

  @override
  String get subtitlesSizeSmall => 'Small';

  @override
  String get tagActionsHint => 'Long-press a tag to rename or delete it.';

  @override
  String get tagFilterHint =>
      'Tap a tag to show its clips, again to hide them, and once more to let it go.';

  @override
  String tagLimitReached(int max) {
    return 'You can have up to $max tags. Remove one in Manage tags to add another.';
  }

  @override
  String get tags => 'Tags';

  @override
  String get tagsOpenFiltered => 'Opens the library filtered';

  @override
  String get theme => 'Theme';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System';

  @override
  String get titleFilter => 'Only download titles containing';

  @override
  String get titleFilterHelp =>
      'A new video from this channel is downloaded only if its title contains what you write here.\n\n• A plain word is enough: Episode\n• Any of several words: Episode|Part (the | means \"or\")\n• Capitals don\'t matter: episode matches Episode too.\n\nA video the filter skips counts as seen for good: removing the filter later downloads what comes after, not what was skipped.';

  @override
  String get titleFilterHelper =>
      'Several words: separate them with | . Leave empty for everything.';

  @override
  String get titleFilterHint => 'e.g. Episode';

  @override
  String get titleLabel => 'Title';

  @override
  String totalDuration(Object duration) {
    return 'Total: $duration';
  }

  @override
  String get transcript => 'Transcript';

  @override
  String get transcriptFind => 'Search the transcript';

  @override
  String get transcriptFull => 'Full transcript';

  @override
  String transcriptMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matches',
      one: '1 match',
      zero: 'No matches',
    );
    return '$_temp0';
  }

  @override
  String get transcriptNextMatch => 'Next match';

  @override
  String get transcriptPeekHint => 'Tap for the whole text';

  @override
  String get transcriptPreviousMatch => 'Previous match';

  @override
  String transcriptSaidMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Said $count more times',
      one: 'Said once more',
    );
    return '$_temp0';
  }

  @override
  String get transcriptSwitchLanguage => 'Switch the transcript language';

  @override
  String transcriptsClips(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clips',
      one: '1 clip',
      zero: 'No clips yet',
    );
    return '$_temp0';
  }

  @override
  String get transcriptsDeleteAll => 'Delete all';

  @override
  String get transcriptsDeleteBody =>
      'They are removed from this phone. Only a file you exported can bring them back.';

  @override
  String get transcriptsDeleteTitle => 'Delete every transcript?';

  @override
  String transcriptsDisableBody(String size) {
    return 'The saved transcripts ($size) stay on this phone unless you delete them.';
  }

  @override
  String get transcriptsDisableTitle => 'Stop searching inside clips?';

  @override
  String get transcriptsEnable => 'Turn on';

  @override
  String get transcriptsEnableBody =>
      'Before each YouTube clip you add is downloaded, the app fetches its words from your server, in the app\'s language and in English (up to 40 seconds), and keeps them on this phone only. Clips already in your library are included only if your server saved their subtitles beside them (the setup guide shows how). You can turn this off at any time.';

  @override
  String transcriptsExported(Object path) {
    return 'Transcripts saved to: $path';
  }

  @override
  String get transcriptsHelp =>
      'The app keeps the words said in each YouTube clip you add, so a library search also finds what was said inside your clips, not only their titles.\n\nThe words are fetched from your server just before the download and kept on this phone; the full backup does not include them. To move them to another phone, use Export here and Import there. An import adds to what is already here and deletes nothing.\n\nA server set to write subtitles beside each clip (one line in its configuration; the setup guide shows it) covers everything it downloads from then on, subscriptions and other sites included: the app reads those files on its own, in the app\'s language and in English.';

  @override
  String get transcriptsImportInvalid => 'This file holds no transcripts.';

  @override
  String transcriptsImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imported $count transcripts',
      one: 'Imported 1 transcript',
    );
    return '$_temp0';
  }

  @override
  String get transcriptsKeep => 'Stop and keep';

  @override
  String get transcriptsSaidInside => 'Said inside clips';

  @override
  String get transcriptsSearch => 'Search inside clips';

  @override
  String get transcriptsSearchHelp =>
      'Keeps the words of every YouTube clip you add, so you can search what was said.';

  @override
  String get transcriptsStopAndDelete => 'Stop and delete';

  @override
  String get tryAgain => 'Try again';

  @override
  String get undo => 'Undo';

  @override
  String get unfollow => 'Unfollow';

  @override
  String unfollowConfirm(String name) {
    return 'Unfollow $name?';
  }

  @override
  String get unfollowConfirmBody =>
      'VidHoist forgets which videos it has already seen on this channel. If you follow it again later, everything on it by then counts as seen, and what you missed is not filled in. Pausing keeps that memory.';

  @override
  String get unlockTouch => 'Unlock';

  @override
  String get unpinPlaylist => 'Unpin';

  @override
  String get upNext => 'Up next';

  @override
  String upNextIn(String name) {
    return 'Up next in «$name»';
  }

  @override
  String get updateAllowInstallBody =>
      'Android needs your permission before the app can install its own updates. Grant it once in system settings, then tap Install again.';

  @override
  String get updateAllowInstallTitle => 'Allow installing updates';

  @override
  String get updateAvailable => 'Update available';

  @override
  String get updateCheckFailed => 'Couldn\'t check for updates';

  @override
  String get updateChecking => 'Checking…';

  @override
  String get updateDownloadFailed => 'Couldn\'t download the update';

  @override
  String updateDownloadedMb(String done, String total) {
    return '$done of $total MB';
  }

  @override
  String get updateDownloading => 'Downloading update…';

  @override
  String get updateFailedToStart => 'Couldn\'t open the installer';

  @override
  String get updateInstall => 'Install';

  @override
  String get updateLater => 'Later';

  @override
  String get updateNever => 'Not yet';

  @override
  String get updateNow => 'Download update';

  @override
  String get updateOpenSystemSettings => 'Open settings';

  @override
  String get updateReady => 'Ready to install';

  @override
  String updateSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get updateSkipVersion => 'Skip this version';

  @override
  String get updateUpToDate => 'You\'re on the latest version';

  @override
  String updateVersionAvailable(String version) {
    return 'Version $version is available';
  }

  @override
  String updateVersionTitle(String version) {
    return 'Version $version';
  }

  @override
  String get updateWhatsNew => 'What\'s new';

  @override
  String get updates => 'Updates';

  @override
  String get username => 'Username';

  @override
  String get version => 'Version';

  @override
  String get videoAdded => 'Added to playlist';

  @override
  String get videoPlayer => 'Video player';

  @override
  String get viewAll => 'View all';

  @override
  String get viewAllInPlaylists => 'View all';

  @override
  String get viewCards => 'Cards';

  @override
  String get viewGrid => 'Grid';

  @override
  String get viewList => 'List';

  @override
  String get viewMode => 'View';

  @override
  String get waitingForWifi => 'Waiting for Wi-Fi';

  @override
  String get whatsNewGotIt => 'Got it';

  @override
  String get whatsNewReleasePage => 'Release page';

  @override
  String get whatsNewThisVersion => 'What\'s new in this version';

  @override
  String whatsNewTitle(String version) {
    return 'What\'s new in $version';
  }

  @override
  String get whatsNewUnavailable =>
      'What changed in this version is on the release page.';

  @override
  String get wifiOnly => 'Download over Wi-Fi only';

  @override
  String get wifiOnlyHelp =>
      'Nothing downloads over mobile data. Downloads wait for Wi-Fi, and one under way when Wi-Fi drops is paused and goes on by itself when it returns.';

  @override
  String get yourChannels => 'Your channels';

  @override
  String get yourChannelsHint => 'Followed in Settings or the player';

  @override
  String get yourLibrary => 'Your library';

  @override
  String get yourPlaylists => 'Your playlists';

  @override
  String get yourTags => 'Your tags';

  @override
  String get ytdlpCredit => 'The downloader VidHoist runs';
}
