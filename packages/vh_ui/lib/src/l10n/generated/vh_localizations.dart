import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'vh_localizations_ar.dart';
import 'vh_localizations_de.dart';
import 'vh_localizations_en.dart';
import 'vh_localizations_es.dart';
import 'vh_localizations_fa.dart';
import 'vh_localizations_fr.dart';
import 'vh_localizations_hi.dart';
import 'vh_localizations_id.dart';
import 'vh_localizations_pt.dart';
import 'vh_localizations_ru.dart';
import 'vh_localizations_tr.dart';
import 'vh_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of VhLocalizations
/// returned by `VhLocalizations.of(context)`.
///
/// Applications need to include `VhLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/vh_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: VhLocalizations.localizationsDelegates,
///   supportedLocales: VhLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the VhLocalizations.supportedLocales
/// property.
abstract class VhLocalizations {
  VhLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static VhLocalizations of(BuildContext context) {
    return Localizations.of<VhLocalizations>(context, VhLocalizations)!;
  }

  static const LocalizationsDelegate<VhLocalizations> delegate =
      _VhLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('ur'),
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get aboutApp;

  /// No description provided for @aboutDescriptionPhone.
  ///
  /// In en, this message translates to:
  /// **'A light, fast app that downloads video and audio from many sites with yt-dlp. It has its own player and playlists.'**
  String get aboutDescriptionPhone;

  /// No description provided for @accountSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get accountSignIn;

  /// No description provided for @accountSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get accountSignOut;

  /// No description provided for @accountSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get accountSignedIn;

  /// No description provided for @accountSignedOut.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get accountSignedOut;

  /// No description provided for @accountSignedOutOf.
  ///
  /// In en, this message translates to:
  /// **'Signed out of {site}'**
  String accountSignedOutOf(String site);

  /// No description provided for @accountsBanRisk.
  ///
  /// In en, this message translates to:
  /// **'Better use a secondary account: heavy downloading can get an account restricted by the site for a while.'**
  String get accountsBanRisk;

  /// No description provided for @accountsClearAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all cookies'**
  String get accountsClearAll;

  /// No description provided for @accountsCleared.
  ///
  /// In en, this message translates to:
  /// **'Cookies deleted'**
  String get accountsCleared;

  /// No description provided for @accountsFileHint.
  ///
  /// In en, this message translates to:
  /// **'Exported from a browser as a cookies.txt file (Netscape format), for any site, including those not listed above. It joins the sign-ins already here, and stays on this phone.'**
  String get accountsFileHint;

  /// No description provided for @accountsFilePick.
  ///
  /// In en, this message translates to:
  /// **'Choose a cookies file'**
  String get accountsFilePick;

  /// No description provided for @accountsFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Or import a cookies file'**
  String get accountsFileTitle;

  /// No description provided for @accountsFromFile.
  ///
  /// In en, this message translates to:
  /// **'From a cookies file'**
  String get accountsFromFile;

  /// No description provided for @accountsHelp.
  ///
  /// In en, this message translates to:
  /// **'A sign-in expires after a while; when a site starts refusing again, sign in once more. Signing out of one site also signs the in-app browser out of the others, whose downloads go on as they were. If a site will not let you sign in here, import a cookies file from your computer\'s browser below.'**
  String get accountsHelp;

  /// No description provided for @accountsHint.
  ///
  /// In en, this message translates to:
  /// **'For the sites that refuse a download without a login. You sign in on the site\'s own page inside the app; what it leaves stays on this phone, where yt-dlp reads it for every download, and goes nowhere else.'**
  String get accountsHint;

  /// No description provided for @activeDownloads.
  ///
  /// In en, this message translates to:
  /// **'Active downloads'**
  String get activeDownloads;

  /// No description provided for @activeDownloadsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 download in progress} other{{count} downloads in progress}}'**
  String activeDownloadsCount(int count);

  /// No description provided for @activeDownloadsSheet.
  ///
  /// In en, this message translates to:
  /// **'Active downloads'**
  String get activeDownloadsSheet;

  /// No description provided for @activeNow.
  ///
  /// In en, this message translates to:
  /// **'Active now'**
  String get activeNow;

  /// No description provided for @addLinkFab.
  ///
  /// In en, this message translates to:
  /// **'Add link'**
  String get addLinkFab;

  /// No description provided for @addTo.
  ///
  /// In en, this message translates to:
  /// **'Add to…'**
  String get addTo;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @addToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to playlist'**
  String get addToPlaylist;

  /// No description provided for @addUrl.
  ///
  /// In en, this message translates to:
  /// **'Add URL'**
  String get addUrl;

  /// No description provided for @addedNToServer.
  ///
  /// In en, this message translates to:
  /// **'Added {count} to the downloads'**
  String addedNToServer(int count);

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @addedToPlaylistCount.
  ///
  /// In en, this message translates to:
  /// **'{count} added to the playlist'**
  String addedToPlaylistCount(int count);

  /// No description provided for @allDownloadsFinished.
  ///
  /// In en, this message translates to:
  /// **'All downloads finished.'**
  String get allDownloadsFinished;

  /// No description provided for @allPlatforms.
  ///
  /// In en, this message translates to:
  /// **'All sites'**
  String get allPlatforms;

  /// No description provided for @alreadyInPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Already added'**
  String get alreadyInPlaylist;

  /// No description provided for @alreadySubscribed.
  ///
  /// In en, this message translates to:
  /// **'This channel is already followed'**
  String get alreadySubscribed;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'VidHoist'**
  String get appTitle;

  /// No description provided for @appearanceAndLanguage.
  ///
  /// In en, this message translates to:
  /// **'Appearance & language'**
  String get appearanceAndLanguage;

  /// No description provided for @audioChannels.
  ///
  /// In en, this message translates to:
  /// **'{count} channels'**
  String audioChannels(int count);

  /// No description provided for @audioFormat.
  ///
  /// In en, this message translates to:
  /// **'Audio format'**
  String get audioFormat;

  /// No description provided for @audioFormatM4a.
  ///
  /// In en, this message translates to:
  /// **'M4A: plays everywhere'**
  String get audioFormatM4a;

  /// No description provided for @audioFormatMp3.
  ///
  /// In en, this message translates to:
  /// **'MP3: for older players and cars'**
  String get audioFormatMp3;

  /// No description provided for @audioFormatOriginal.
  ///
  /// In en, this message translates to:
  /// **'As the site sends it, unconverted'**
  String get audioFormatOriginal;

  /// No description provided for @audioMono.
  ///
  /// In en, this message translates to:
  /// **'Mono'**
  String get audioMono;

  /// No description provided for @audioOnly.
  ///
  /// In en, this message translates to:
  /// **'Audio only'**
  String get audioOnly;

  /// No description provided for @audioStereo.
  ///
  /// In en, this message translates to:
  /// **'Stereo'**
  String get audioStereo;

  /// No description provided for @autoBuilt.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get autoBuilt;

  /// No description provided for @autoCheckUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check automatically'**
  String get autoCheckUpdates;

  /// No description provided for @autoCheckUpdatesHelp.
  ///
  /// In en, this message translates to:
  /// **'Looks for a new version in the background about twice a day.'**
  String get autoCheckUpdatesHelp;

  /// No description provided for @autoRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data restored from the backup.'**
  String get autoRestoreSuccess;

  /// No description provided for @autoRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry when the network returns'**
  String get autoRetry;

  /// No description provided for @autoRetryHelp.
  ///
  /// In en, this message translates to:
  /// **'Anything that failed because the network dropped is retried on its own when it returns. What a site refused is not retried: repeating it unchanged just fails again.'**
  String get autoRetryHelp;

  /// No description provided for @backgroundChecks.
  ///
  /// In en, this message translates to:
  /// **'Check while closed'**
  String get backgroundChecks;

  /// No description provided for @backgroundChecksHelp.
  ///
  /// In en, this message translates to:
  /// **'About every six hours, when there is a network and the battery is not low. It only tells you what is new; the clips download when you open VidHoist.'**
  String get backgroundChecksHelp;

  /// No description provided for @backgroundDownload.
  ///
  /// In en, this message translates to:
  /// **'Downloading files in the background…'**
  String get backgroundDownload;

  /// No description provided for @backgroundLastRun.
  ///
  /// In en, this message translates to:
  /// **'Last check while closed: {when}'**
  String backgroundLastRun(String when);

  /// No description provided for @backgroundNotRunYet.
  ///
  /// In en, this message translates to:
  /// **'No check while closed yet: Android chooses when.'**
  String get backgroundNotRunYet;

  /// No description provided for @backgroundOfferBody.
  ///
  /// In en, this message translates to:
  /// **'VidHoist can look at your channels about every six hours and tell you what is new. Nothing downloads until you open the app.'**
  String get backgroundOfferBody;

  /// No description provided for @backgroundOfferNo.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get backgroundOfferNo;

  /// No description provided for @backgroundOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'Hear about new videos while VidHoist is closed?'**
  String get backgroundOfferTitle;

  /// No description provided for @backgroundOfferYes.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get backgroundOfferYes;

  /// No description provided for @backupNote.
  ///
  /// In en, this message translates to:
  /// **'Includes the library, playlists, tags, followed channels and settings. Sign-ins and transcripts are kept apart, and the media files themselves are not included.'**
  String get backupNote;

  /// No description provided for @backupSettings.
  ///
  /// In en, this message translates to:
  /// **'Back up all data'**
  String get backupSettings;

  /// No description provided for @backupSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Seven dated copies that refresh themselves. Restore any of them, or export one to share'**
  String get backupSettingsSubtitle;

  /// No description provided for @backupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup saved to: {path}'**
  String backupSuccess(Object path);

  /// No description provided for @backupsKept.
  ///
  /// In en, this message translates to:
  /// **'{count} backups kept'**
  String backupsKept(int count);

  /// No description provided for @batchDownloadSelected.
  ///
  /// In en, this message translates to:
  /// **'Download selected'**
  String get batchDownloadSelected;

  /// No description provided for @batchLoading.
  ///
  /// In en, this message translates to:
  /// **'Reading the playlist…'**
  String get batchLoading;

  /// No description provided for @batchNothingSelected.
  ///
  /// In en, this message translates to:
  /// **'Select at least one item'**
  String get batchNothingSelected;

  /// No description provided for @batchSelectedOf.
  ///
  /// In en, this message translates to:
  /// **'{selected} of {total} selected'**
  String batchSelectedOf(int selected, int total);

  /// No description provided for @batchThisVideoOnly.
  ///
  /// In en, this message translates to:
  /// **'Download this clip only'**
  String get batchThisVideoOnly;

  /// No description provided for @batchTitle.
  ///
  /// In en, this message translates to:
  /// **'Batch download'**
  String get batchTitle;

  /// No description provided for @batteryAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get batteryAllow;

  /// No description provided for @batteryFree.
  ///
  /// In en, this message translates to:
  /// **'Battery saving leaves downloads alone, even with the app out of sight.'**
  String get batteryFree;

  /// No description provided for @batteryRestricted.
  ///
  /// In en, this message translates to:
  /// **'Battery saving can stop a long download while the app is out of sight.'**
  String get batteryRestricted;

  /// No description provided for @batteryStateFree.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get batteryStateFree;

  /// No description provided for @batteryStateLimited.
  ///
  /// In en, this message translates to:
  /// **'Restricted'**
  String get batteryStateLimited;

  /// No description provided for @batteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Downloads in the background'**
  String get batteryTitle;

  /// No description provided for @bitrateKbps.
  ///
  /// In en, this message translates to:
  /// **'{value} kb/s'**
  String bitrateKbps(String value);

  /// No description provided for @bitrateMbps.
  ///
  /// In en, this message translates to:
  /// **'{value} Mb/s'**
  String bitrateMbps(String value);

  /// No description provided for @builtWith.
  ///
  /// In en, this message translates to:
  /// **'Built with'**
  String get builtWith;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @changeQuality.
  ///
  /// In en, this message translates to:
  /// **'Change quality'**
  String get changeQuality;

  /// No description provided for @channelNameFolder.
  ///
  /// In en, this message translates to:
  /// **'Named after the channel'**
  String get channelNameFolder;

  /// No description provided for @channelFollowers.
  ///
  /// In en, this message translates to:
  /// **'{count} subscribers'**
  String channelFollowers(String count);

  /// No description provided for @channelCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Not checked this time. VidHoist tries again by itself.'**
  String get channelCheckFailed;

  /// No description provided for @channelUrl.
  ///
  /// In en, this message translates to:
  /// **'Link to a channel, a playlist or one of its videos'**
  String get channelUrl;

  /// No description provided for @channelUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://www.youtube.com/@name'**
  String get channelUrlHint;

  /// No description provided for @chapterNumber.
  ///
  /// In en, this message translates to:
  /// **'Chapter {number}'**
  String chapterNumber(int number);

  /// No description provided for @chaptersFold.
  ///
  /// In en, this message translates to:
  /// **'Hide chapters'**
  String get chaptersFold;

  /// No description provided for @chaptersFromTranscript.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 chapter from the transcript} other{{count} chapters from the transcript}}'**
  String chaptersFromTranscript(int count);

  /// No description provided for @chaptersShowAll.
  ///
  /// In en, this message translates to:
  /// **'View all chapters'**
  String get chaptersShowAll;

  /// No description provided for @chaptersUnfold.
  ///
  /// In en, this message translates to:
  /// **'Show chapters'**
  String get chaptersUnfold;

  /// No description provided for @checkEvery.
  ///
  /// In en, this message translates to:
  /// **'How often to look'**
  String get checkEvery;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get checkForUpdates;

  /// No description provided for @checkNow.
  ///
  /// In en, this message translates to:
  /// **'Check now'**
  String get checkNow;

  /// No description provided for @checkQueued.
  ///
  /// In en, this message translates to:
  /// **'Checking now. Anything new appears in the library.'**
  String get checkQueued;

  /// No description provided for @chooseFolder.
  ///
  /// In en, this message translates to:
  /// **'Choose a folder'**
  String get chooseFolder;

  /// No description provided for @chooseOptions.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get chooseOptions;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clearLogs.
  ///
  /// In en, this message translates to:
  /// **'Clear logs'**
  String get clearLogs;

  /// No description provided for @clearLogsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all diagnostic logs?'**
  String get clearLogsConfirm;

  /// No description provided for @clipEndAfterStart.
  ///
  /// In en, this message translates to:
  /// **'After the start'**
  String get clipEndAfterStart;

  /// No description provided for @clipFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get clipFrom;

  /// No description provided for @clipLength.
  ///
  /// In en, this message translates to:
  /// **'The video is {length} long'**
  String clipLength(Object length);

  /// No description provided for @clipLengthReading.
  ///
  /// In en, this message translates to:
  /// **'Reading the video\'s length…'**
  String get clipLengthReading;

  /// No description provided for @clipLengthUnknown.
  ///
  /// In en, this message translates to:
  /// **'The site does not say how long the video is, so the times are not checked'**
  String get clipLengthUnknown;

  /// No description provided for @clipMinuteDown.
  ///
  /// In en, this message translates to:
  /// **'A minute earlier'**
  String get clipMinuteDown;

  /// No description provided for @clipMinuteUp.
  ///
  /// In en, this message translates to:
  /// **'A minute later'**
  String get clipMinuteUp;

  /// No description provided for @clipOnly.
  ///
  /// In en, this message translates to:
  /// **'Only a part of the video'**
  String get clipOnly;

  /// No description provided for @clipOnlyHelp.
  ///
  /// In en, this message translates to:
  /// **'From one time to another, without the rest. It comes without subtitles.'**
  String get clipOnlyHelp;

  /// No description provided for @clipPastEnd.
  ///
  /// In en, this message translates to:
  /// **'The video ends at {length}'**
  String clipPastEnd(Object length);

  /// No description provided for @clipTimeHint.
  ///
  /// In en, this message translates to:
  /// **'Digits alone: 130 is 1:30'**
  String get clipTimeHint;

  /// No description provided for @clipTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get clipTo;

  /// No description provided for @clipboardFound.
  ///
  /// In en, this message translates to:
  /// **'A link is ready in your clipboard'**
  String get clipboardFound;

  /// No description provided for @clipboardLinkReady.
  ///
  /// In en, this message translates to:
  /// **'Paste link'**
  String get clipboardLinkReady;

  /// No description provided for @closePlayer.
  ///
  /// In en, this message translates to:
  /// **'Close player'**
  String get closePlayer;

  /// No description provided for @columnAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get columnAdded;

  /// No description provided for @columnLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get columnLength;

  /// No description provided for @compactView.
  ///
  /// In en, this message translates to:
  /// **'Compact view'**
  String get compactView;

  /// No description provided for @compatiblePlayback.
  ///
  /// In en, this message translates to:
  /// **'Best playback compatibility'**
  String get compatiblePlayback;

  /// No description provided for @compatiblePlaybackHelp.
  ///
  /// In en, this message translates to:
  /// **'Asks for H.264/AAC, which every phone decodes in hardware. Without it YouTube may deliver AV1, which many devices render as a garbled picture. Turning it off allows the highest resolution at the cost of compatibility.'**
  String get compatiblePlaybackHelp;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @continueAsAudio.
  ///
  /// In en, this message translates to:
  /// **'Continue as audio'**
  String get continueAsAudio;

  /// No description provided for @continueAsAudioBody.
  ///
  /// In en, this message translates to:
  /// **'Keep playing this as audio from the same second?'**
  String get continueAsAudioBody;

  /// No description provided for @continueAsAudioNo.
  ///
  /// In en, this message translates to:
  /// **'No, stop'**
  String get continueAsAudioNo;

  /// No description provided for @continueAsAudioTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue in the background?'**
  String get continueAsAudioTitle;

  /// No description provided for @cookies.
  ///
  /// In en, this message translates to:
  /// **'Cookies'**
  String get cookies;

  /// No description provided for @cookiesNotNetscape.
  ///
  /// In en, this message translates to:
  /// **'None of these files holds cookies in the Netscape format'**
  String get cookiesNotNetscape;

  /// No description provided for @cookiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For the sites that will not download without a login'**
  String get cookiesSubtitle;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Yasir Sagheer'**
  String get copyright;

  /// No description provided for @couldNotLoadPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this playlist. Check the URL and your connection.'**
  String get couldNotLoadPlaylist;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Create playlist'**
  String get createPlaylist;

  /// No description provided for @defaultQuality.
  ///
  /// In en, this message translates to:
  /// **'Default video quality'**
  String get defaultQuality;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteMultipleConfirm.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 clip?\n\nIts file is removed from your device.} other{Delete {count} clips?\n\nTheir files are removed from your device.}}'**
  String deleteMultipleConfirm(int count);

  /// No description provided for @deletePlaylistConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deletePlaylistConfirm(Object name);

  /// No description provided for @deleteRefused.
  ///
  /// In en, this message translates to:
  /// **'Not deleted: Android needs your permission to delete this file, in the dialog it shows.'**
  String get deleteRefused;

  /// No description provided for @deleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get deleteSelected;

  /// No description provided for @deleteTag.
  ///
  /// In en, this message translates to:
  /// **'Delete tag'**
  String get deleteTag;

  /// No description provided for @deleteTagConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete the tag \"{tag}\" from all items? The clips themselves are not deleted.'**
  String deleteTagConfirm(Object tag);

  /// No description provided for @deleteVideo.
  ///
  /// In en, this message translates to:
  /// **'Delete clip'**
  String get deleteVideo;

  /// No description provided for @deleteVideoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"?\n\nThis will remove the file from your device.'**
  String deleteVideoConfirm(Object title);

  /// No description provided for @deletedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} deleted'**
  String deletedCount(Object count);

  /// No description provided for @deletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Deleted: {title}'**
  String deletedTitle(Object title);

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get deselectAll;

  /// No description provided for @desktopAddLinks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing to add} =1{Add 1 link} other{Add {count} links}}'**
  String desktopAddLinks(int count);

  /// No description provided for @desktopBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get desktopBack;

  /// No description provided for @desktopBackUpNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get desktopBackUpNow;

  /// No description provided for @desktopBackupHint.
  ///
  /// In en, this message translates to:
  /// **'This computer keeps its last seven backups, at least an hour apart, in Downloads\\VidHoist\\Backups, where they outlast an uninstall.'**
  String get desktopBackupHint;

  /// No description provided for @desktopBackupsNone.
  ///
  /// In en, this message translates to:
  /// **'No backup yet'**
  String get desktopBackupsNone;

  /// No description provided for @desktopBrowserButton.
  ///
  /// In en, this message translates to:
  /// **'“To VidHoist” button in the browser'**
  String get desktopBrowserButton;

  /// No description provided for @desktopBrowserButtonCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied. Make a new bookmark and paste it as its address (URL).'**
  String get desktopBrowserButtonCopied;

  /// No description provided for @desktopBrowserButtonCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy the code'**
  String get desktopBrowserButtonCopy;

  /// No description provided for @desktopBrowserButtonFailed.
  ///
  /// In en, this message translates to:
  /// **'The page could not be opened; copy the code instead.'**
  String get desktopBrowserButtonFailed;

  /// No description provided for @desktopBrowserButtonHint.
  ///
  /// In en, this message translates to:
  /// **'A button on your bookmarks bar: one click on any video\'s page opens the add dialog here with its link. Nothing is sent until you press Add.'**
  String get desktopBrowserButtonHint;

  /// No description provided for @desktopBrowserButtonName.
  ///
  /// In en, this message translates to:
  /// **'To VidHoist'**
  String get desktopBrowserButtonName;

  /// No description provided for @desktopBrowserButtonOpen.
  ///
  /// In en, this message translates to:
  /// **'Open the setup page'**
  String get desktopBrowserButtonOpen;

  /// No description provided for @desktopBrowserPageCopyInstead.
  ///
  /// In en, this message translates to:
  /// **'If dragging does not work, make a new bookmark and paste this as its address:'**
  String get desktopBrowserPageCopyInstead;

  /// No description provided for @desktopBrowserPageDragHint.
  ///
  /// In en, this message translates to:
  /// **'Drag it to the bar; a click here does nothing.'**
  String get desktopBrowserPageDragHint;

  /// No description provided for @desktopBrowserPageStep1.
  ///
  /// In en, this message translates to:
  /// **'Show the bookmarks bar if it is hidden:'**
  String get desktopBrowserPageStep1;

  /// No description provided for @desktopBrowserPageStep2.
  ///
  /// In en, this message translates to:
  /// **'Drag the button below onto the bar with the mouse.'**
  String get desktopBrowserPageStep2;

  /// No description provided for @desktopBrowserPageStep3.
  ///
  /// In en, this message translates to:
  /// **'On any video\'s page, click it: VidHoist opens its add dialog with the link. The first time, the browser asks whether to open the app; allow it.'**
  String get desktopBrowserPageStep3;

  /// No description provided for @desktopBrowserPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Add the “To VidHoist” button to your browser'**
  String get desktopBrowserPageTitle;

  /// No description provided for @desktopChangeFolder.
  ///
  /// In en, this message translates to:
  /// **'Change…'**
  String get desktopChangeFolder;

  /// No description provided for @desktopChannel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get desktopChannel;

  /// No description provided for @desktopChannelClips.
  ///
  /// In en, this message translates to:
  /// **'In your library'**
  String get desktopChannelClips;

  /// No description provided for @desktopChannels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get desktopChannels;

  /// No description provided for @desktopChannelsInLibrary.
  ///
  /// In en, this message translates to:
  /// **'Channels in your library'**
  String get desktopChannelsInLibrary;

  /// No description provided for @desktopChannelsLater.
  ///
  /// In en, this message translates to:
  /// **'Needs the download engine'**
  String get desktopChannelsLater;

  /// No description provided for @desktopChannelsLaterBody.
  ///
  /// In en, this message translates to:
  /// **'Following a channel needs yt-dlp on this computer. Set it up in Settings › Engine, and your channels show here.'**
  String get desktopChannelsLaterBody;

  /// No description provided for @desktopChapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get desktopChapters;

  /// No description provided for @desktopCheckAll.
  ///
  /// In en, this message translates to:
  /// **'Check all'**
  String get desktopCheckAll;

  /// No description provided for @desktopChooseClip.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get desktopChooseClip;

  /// No description provided for @desktopClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get desktopClearFilters;

  /// No description provided for @desktopClearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get desktopClearSelection;

  /// No description provided for @desktopCookiesBrowser.
  ///
  /// In en, this message translates to:
  /// **'From a browser'**
  String get desktopCookiesBrowser;

  /// No description provided for @desktopCookiesBrowserHint.
  ///
  /// In en, this message translates to:
  /// **'Read from the browser you are signed in with. If they cannot be read, close that browser and try again.'**
  String get desktopCookiesBrowserHint;

  /// No description provided for @desktopCookiesChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a file…'**
  String get desktopCookiesChoose;

  /// No description provided for @desktopCookiesFile.
  ///
  /// In en, this message translates to:
  /// **'Cookies file'**
  String get desktopCookiesFile;

  /// No description provided for @desktopCookiesHelp.
  ///
  /// In en, this message translates to:
  /// **'In your browser, use an extension that exports cookies in the Netscape format (one file per site), and choose the files here together. yt-dlp then uses them for every download. Cookies expire, so a download that starts failing again usually means a fresh export is due.'**
  String get desktopCookiesHelp;

  /// No description provided for @desktopCookiesKept.
  ///
  /// In en, this message translates to:
  /// **'Cookies kept on this computer'**
  String get desktopCookiesKept;

  /// No description provided for @desktopCookiesKeptFor.
  ///
  /// In en, this message translates to:
  /// **'Cookies kept for: {sites}'**
  String desktopCookiesKeptFor(String sites);

  /// No description provided for @desktopCookiesLocalHint.
  ///
  /// In en, this message translates to:
  /// **'For sites that need you signed in. yt-dlp reads them on this computer, and they go nowhere else.'**
  String get desktopCookiesLocalHint;

  /// No description provided for @desktopCookiesNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get desktopCookiesNone;

  /// No description provided for @desktopCookiesRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get desktopCookiesRemove;

  /// No description provided for @desktopCopiedLinkAdd.
  ///
  /// In en, this message translates to:
  /// **'Add…'**
  String get desktopCopiedLinkAdd;

  /// No description provided for @desktopCopiedLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Download this link?'**
  String get desktopCopiedLinkTitle;

  /// No description provided for @desktopCopyFile.
  ///
  /// In en, this message translates to:
  /// **'Copy file'**
  String get desktopCopyFile;

  /// No description provided for @desktopCopyFileFailed.
  ///
  /// In en, this message translates to:
  /// **'The file could not be copied'**
  String get desktopCopyFileFailed;

  /// No description provided for @desktopCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get desktopCopyLink;

  /// No description provided for @desktopCopyOneClip.
  ///
  /// In en, this message translates to:
  /// **'Copying takes one clip at a time'**
  String get desktopCopyOneClip;

  /// No description provided for @desktopCopyQuote.
  ///
  /// In en, this message translates to:
  /// **'Copy with time and link'**
  String get desktopCopyQuote;

  /// No description provided for @desktopDefaultQualityHint.
  ///
  /// In en, this message translates to:
  /// **'What each add starts with; you can still change it for each link.'**
  String get desktopDefaultQualityHint;

  /// No description provided for @desktopDeleteSelectedConfirm.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 clip? Its file on this computer is deleted.} other{Delete {count} clips? Their files on this computer are deleted.}}'**
  String desktopDeleteSelectedConfirm(int count);

  /// No description provided for @desktopDesktopSection.
  ///
  /// In en, this message translates to:
  /// **'Windows'**
  String get desktopDesktopSection;

  /// No description provided for @desktopDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover VidHoist'**
  String get desktopDiscover;

  /// No description provided for @desktopDiscoverAddLink.
  ///
  /// In en, this message translates to:
  /// **'Paste or drop a link'**
  String get desktopDiscoverAddLink;

  /// No description provided for @desktopDiscoverAddLinkLine.
  ///
  /// In en, this message translates to:
  /// **'Ctrl+V anywhere, or drop a link on the window, to add it.'**
  String get desktopDiscoverAddLinkLine;

  /// No description provided for @desktopDiscoverAdding.
  ///
  /// In en, this message translates to:
  /// **'Adding and sharing'**
  String get desktopDiscoverAdding;

  /// No description provided for @desktopDiscoverBrowser.
  ///
  /// In en, this message translates to:
  /// **'From the browser'**
  String get desktopDiscoverBrowser;

  /// No description provided for @desktopDiscoverBrowserLine.
  ///
  /// In en, this message translates to:
  /// **'The “To VidHoist” button on your bookmarks bar opens the add dialog with the page you are on.'**
  String get desktopDiscoverBrowserLine;

  /// No description provided for @desktopDiscoverChapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get desktopDiscoverChapters;

  /// No description provided for @desktopDiscoverChaptersLine.
  ///
  /// In en, this message translates to:
  /// **'A clip\'s parts, from its transcript, on its page.'**
  String get desktopDiscoverChaptersLine;

  /// No description provided for @desktopDiscoverChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose many'**
  String get desktopDiscoverChoose;

  /// No description provided for @desktopDiscoverChooseLine.
  ///
  /// In en, this message translates to:
  /// **'The round mark, or Ctrl or Shift with a click; then add them to a list or delete them together.'**
  String get desktopDiscoverChooseLine;

  /// No description provided for @desktopDiscoverDragOut.
  ///
  /// In en, this message translates to:
  /// **'Drag a clip out'**
  String get desktopDiscoverDragOut;

  /// No description provided for @desktopDiscoverDragOutLine.
  ///
  /// In en, this message translates to:
  /// **'Drop it on a folder or another app, and it arrives there as a file.'**
  String get desktopDiscoverDragOutLine;

  /// No description provided for @desktopDiscoverExport.
  ///
  /// In en, this message translates to:
  /// **'Export a transcript'**
  String get desktopDiscoverExport;

  /// No description provided for @desktopDiscoverExportLine.
  ///
  /// In en, this message translates to:
  /// **'As text, or as SRT subtitles for another player.'**
  String get desktopDiscoverExportLine;

  /// No description provided for @desktopDiscoverHint.
  ///
  /// In en, this message translates to:
  /// **'Everything the app can do, a line each, with its keys.'**
  String get desktopDiscoverHint;

  /// No description provided for @desktopDiscoverLibrary.
  ///
  /// In en, this message translates to:
  /// **'The library'**
  String get desktopDiscoverLibrary;

  /// No description provided for @desktopDiscoverListening.
  ///
  /// In en, this message translates to:
  /// **'For sound: a quiet room with the cover large, in full screen.'**
  String get desktopDiscoverListening;

  /// No description provided for @desktopDiscoverMini.
  ///
  /// In en, this message translates to:
  /// **'Small window'**
  String get desktopDiscoverMini;

  /// No description provided for @desktopDiscoverMiniLine.
  ///
  /// In en, this message translates to:
  /// **'A small card above every other window, in the bottom corner of the screen.'**
  String get desktopDiscoverMiniLine;

  /// No description provided for @desktopDiscoverReading.
  ///
  /// In en, this message translates to:
  /// **'The transcript as an article: click a sentence to hear it from there.'**
  String get desktopDiscoverReading;

  /// No description provided for @desktopDiscoverSaid.
  ///
  /// In en, this message translates to:
  /// **'What was said'**
  String get desktopDiscoverSaid;

  /// No description provided for @desktopDiscoverSearch.
  ///
  /// In en, this message translates to:
  /// **'Search what was said'**
  String get desktopDiscoverSearch;

  /// No description provided for @desktopDiscoverSearchLine.
  ///
  /// In en, this message translates to:
  /// **'Find the clips where a word was spoken, not only in titles.'**
  String get desktopDiscoverSearchLine;

  /// No description provided for @desktopDiscoverShortcutsLine.
  ///
  /// In en, this message translates to:
  /// **'Every key the window answers, on one sheet.'**
  String get desktopDiscoverShortcutsLine;

  /// No description provided for @desktopDiscoverShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get desktopDiscoverShow;

  /// No description provided for @desktopDiscoverStatsLine.
  ///
  /// In en, this message translates to:
  /// **'The library counted: by site, channel and month.'**
  String get desktopDiscoverStatsLine;

  /// No description provided for @desktopDiscoverSubtitles.
  ///
  /// In en, this message translates to:
  /// **'The transcript over the picture, the spoken word lit up.'**
  String get desktopDiscoverSubtitles;

  /// No description provided for @desktopDiscoverTheater.
  ///
  /// In en, this message translates to:
  /// **'A larger picture that takes the side panel\'s place.'**
  String get desktopDiscoverTheater;

  /// No description provided for @desktopDiscoverTry.
  ///
  /// In en, this message translates to:
  /// **'Try it'**
  String get desktopDiscoverTry;

  /// No description provided for @desktopDiscoverWatching.
  ///
  /// In en, this message translates to:
  /// **'Watching and listening'**
  String get desktopDiscoverWatching;

  /// No description provided for @desktopDownloadFolder.
  ///
  /// In en, this message translates to:
  /// **'Download folder'**
  String get desktopDownloadFolder;

  /// No description provided for @desktopDownloadFolderHint.
  ///
  /// In en, this message translates to:
  /// **'Downloads are saved here as ordinary files, to open, move or back up like any other.'**
  String get desktopDownloadFolderHint;

  /// No description provided for @desktopDownloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get desktopDownloads;

  /// No description provided for @desktopDownloadsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing is downloading. Add a link to start.'**
  String get desktopDownloadsEmpty;

  /// No description provided for @desktopDownloadsRunning.
  ///
  /// In en, this message translates to:
  /// **'Under way'**
  String get desktopDownloadsRunning;

  /// No description provided for @desktopDragToReorder.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get desktopDragToReorder;

  /// No description provided for @desktopDropLinks.
  ///
  /// In en, this message translates to:
  /// **'Drop to add'**
  String get desktopDropLinks;

  /// No description provided for @desktopEmptyLibraryLocal.
  ///
  /// In en, this message translates to:
  /// **'Add a link, and the clip appears here once it is downloaded.'**
  String get desktopEmptyLibraryLocal;

  /// No description provided for @desktopEmptyLibraryMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a link, and the clip appears here once it is downloaded.'**
  String get desktopEmptyLibraryMessage;

  /// No description provided for @desktopEngine.
  ///
  /// In en, this message translates to:
  /// **'Engine'**
  String get desktopEngine;

  /// No description provided for @desktopEngineDenoHint.
  ///
  /// In en, this message translates to:
  /// **'Answers YouTube\'s check, so every quality it offers can be downloaded'**
  String get desktopEngineDenoHint;

  /// No description provided for @desktopEngineFetch.
  ///
  /// In en, this message translates to:
  /// **'Fetch'**
  String get desktopEngineFetch;

  /// No description provided for @desktopEngineFetchCorrupt.
  ///
  /// In en, this message translates to:
  /// **'The file that arrived was not the published one, so it was not used.'**
  String get desktopEngineFetchCorrupt;

  /// No description provided for @desktopEngineFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not be fetched. Check the connection and try again.'**
  String get desktopEngineFetchFailed;

  /// No description provided for @desktopEngineFetchInUse.
  ///
  /// In en, this message translates to:
  /// **'In use by a download. Try again once it ends.'**
  String get desktopEngineFetchInUse;

  /// No description provided for @desktopEngineFetching.
  ///
  /// In en, this message translates to:
  /// **'Fetching · {percent}%'**
  String desktopEngineFetching(int percent);

  /// No description provided for @desktopEngineFfmpegHint.
  ///
  /// In en, this message translates to:
  /// **'Joins picture and sound, and converts audio'**
  String get desktopEngineFfmpegHint;

  /// No description provided for @desktopEngineIpv4.
  ///
  /// In en, this message translates to:
  /// **'Use IPv4 only'**
  String get desktopEngineIpv4;

  /// No description provided for @desktopEngineIpv4Hint.
  ///
  /// In en, this message translates to:
  /// **'Much faster where IPv6 is broken, as on many home networks. Turn it off only if your network has IPv6 alone.'**
  String get desktopEngineIpv4Hint;

  /// No description provided for @desktopEngineMissing.
  ///
  /// In en, this message translates to:
  /// **'yt-dlp is not on this computer. Reinstall VidHoist, or fetch it here.'**
  String get desktopEngineMissing;

  /// No description provided for @desktopEngineOnFirstUse.
  ///
  /// In en, this message translates to:
  /// **'Fetched at the first download that needs it'**
  String get desktopEngineOnFirstUse;

  /// No description provided for @desktopEngineUpToDate.
  ///
  /// In en, this message translates to:
  /// **'yt-dlp is up to date'**
  String get desktopEngineUpToDate;

  /// No description provided for @desktopEngineUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update yt-dlp'**
  String get desktopEngineUpdate;

  /// No description provided for @desktopEngineUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'The update did not go through. Try again later.'**
  String get desktopEngineUpdateFailed;

  /// No description provided for @desktopEngineUpdateHint.
  ///
  /// In en, this message translates to:
  /// **'Sites change often; an old yt-dlp stops working within months.'**
  String get desktopEngineUpdateHint;

  /// No description provided for @desktopEngineUpdated.
  ///
  /// In en, this message translates to:
  /// **'yt-dlp is now {version}'**
  String desktopEngineUpdated(String version);

  /// No description provided for @desktopEngineUpdating.
  ///
  /// In en, this message translates to:
  /// **'Updating…'**
  String get desktopEngineUpdating;

  /// No description provided for @desktopEngineVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String desktopEngineVersion(String version);

  /// No description provided for @desktopEngineYtDlpHint.
  ///
  /// In en, this message translates to:
  /// **'Reads the link and downloads it'**
  String get desktopEngineYtDlpHint;

  /// No description provided for @desktopExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get desktopExport;

  /// No description provided for @desktopExportForPhone.
  ///
  /// In en, this message translates to:
  /// **'Export for the phone'**
  String get desktopExportForPhone;

  /// No description provided for @desktopExportForPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Saves this computer\'s tags, lists and resume points, and its transcripts, as two files the phone restores. Restoring on the phone replaces its own tags and lists.'**
  String get desktopExportForPhoneHint;

  /// No description provided for @desktopExportMarkdown.
  ///
  /// In en, this message translates to:
  /// **'Text (Markdown)'**
  String get desktopExportMarkdown;

  /// No description provided for @desktopExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Document (PDF)'**
  String get desktopExportPdf;

  /// No description provided for @desktopExportPhone.
  ///
  /// In en, this message translates to:
  /// **'For the phone (VidHoist import)'**
  String get desktopExportPhone;

  /// No description provided for @desktopExportSrt.
  ///
  /// In en, this message translates to:
  /// **'Subtitles (SRT)'**
  String get desktopExportSrt;

  /// No description provided for @desktopExported.
  ///
  /// In en, this message translates to:
  /// **'Saved {name}'**
  String desktopExported(String name);

  /// No description provided for @desktopFileReadyToPaste.
  ///
  /// In en, this message translates to:
  /// **'Ready to paste: {name} · {size}'**
  String desktopFileReadyToPaste(String name, String size);

  /// No description provided for @desktopFolderUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No folder available'**
  String get desktopFolderUnavailable;

  /// No description provided for @desktopFolders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get desktopFolders;

  /// No description provided for @desktopForward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get desktopForward;

  /// No description provided for @desktopGlobalShortcut.
  ///
  /// In en, this message translates to:
  /// **'Play and pause from any app'**
  String get desktopGlobalShortcut;

  /// No description provided for @desktopGlobalShortcutHint.
  ///
  /// In en, this message translates to:
  /// **'{keys} plays and pauses while the window is behind other apps.'**
  String desktopGlobalShortcutHint(String keys);

  /// No description provided for @desktopGlobalShortcutTaken.
  ///
  /// In en, this message translates to:
  /// **'Another app already uses {keys}.'**
  String desktopGlobalShortcutTaken(String keys);

  /// No description provided for @desktopHidePanel.
  ///
  /// In en, this message translates to:
  /// **'Hide side panel'**
  String get desktopHidePanel;

  /// No description provided for @desktopHintShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Press ? for the keyboard shortcuts. Space plays and pauses; the arrow keys seek.'**
  String get desktopHintShortcuts;

  /// No description provided for @desktopHintShortcutsAction.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get desktopHintShortcutsAction;

  /// No description provided for @desktopHintTrayBody.
  ///
  /// In en, this message translates to:
  /// **'It keeps playing from its icon by the clock. To quit, right-click the icon.'**
  String get desktopHintTrayBody;

  /// No description provided for @desktopHintTrayTitle.
  ///
  /// In en, this message translates to:
  /// **'VidHoist is still running'**
  String get desktopHintTrayTitle;

  /// No description provided for @desktopHints.
  ///
  /// In en, this message translates to:
  /// **'Show tips'**
  String get desktopHints;

  /// No description provided for @desktopHintsAgain.
  ///
  /// In en, this message translates to:
  /// **'Show them again'**
  String get desktopHintsAgain;

  /// No description provided for @desktopHintsHint.
  ///
  /// In en, this message translates to:
  /// **'Two short tips, each shown once: the shortcuts at the first clip, the icon by the clock at the first close.'**
  String get desktopHintsHint;

  /// No description provided for @desktopImportFromPhone.
  ///
  /// In en, this message translates to:
  /// **'Import a backup or transcripts…'**
  String get desktopImportFromPhone;

  /// No description provided for @desktopImportHint.
  ///
  /// In en, this message translates to:
  /// **'A backup or transcripts file from VidHoist, chosen here or dropped on the window. A phone\'s is added to what is here; a backup of this computer is restored whole, after asking.'**
  String get desktopImportHint;

  /// No description provided for @desktopImportedBackup.
  ///
  /// In en, this message translates to:
  /// **'Added from the phone. Tags: {tagged} · lists: {lists} · resume points: {positions}'**
  String desktopImportedBackup(int tagged, int lists, int positions);

  /// No description provided for @desktopImportedNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing new: this computer already had all of it.'**
  String get desktopImportedNothing;

  /// No description provided for @desktopImportedTranscripts.
  ///
  /// In en, this message translates to:
  /// **'Transcripts added: {count}'**
  String desktopImportedTranscripts(int count);

  /// No description provided for @desktopInLibrary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 in your library} other{{count} in your library}}'**
  String desktopInLibrary(int count);

  /// No description provided for @desktopKeepAwake.
  ///
  /// In en, this message translates to:
  /// **'Keep the computer awake while downloading'**
  String get desktopKeepAwake;

  /// No description provided for @desktopKeepAwakeHint.
  ///
  /// In en, this message translates to:
  /// **'So a link sent from the phone, or a long playlist, finishes instead of stopping when Windows goes to sleep. The screen still turns off as usual.'**
  String get desktopKeepAwakeHint;

  /// No description provided for @desktopKeyAddLink.
  ///
  /// In en, this message translates to:
  /// **'Add the link you copied'**
  String get desktopKeyAddLink;

  /// No description provided for @desktopKeyFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites or remove'**
  String get desktopKeyFavorite;

  /// No description provided for @desktopKeyFullScreen.
  ///
  /// In en, this message translates to:
  /// **'Full screen; for sound, the listening room'**
  String get desktopKeyFullScreen;

  /// No description provided for @desktopKeyMenu.
  ///
  /// In en, this message translates to:
  /// **'The clip\'s menu'**
  String get desktopKeyMenu;

  /// No description provided for @desktopKeyMini.
  ///
  /// In en, this message translates to:
  /// **'Small window above the others, and back'**
  String get desktopKeyMini;

  /// No description provided for @desktopKeyPlayPause.
  ///
  /// In en, this message translates to:
  /// **'Play or pause'**
  String get desktopKeyPlayPause;

  /// No description provided for @desktopKeyRepeat.
  ///
  /// In en, this message translates to:
  /// **'Change repeat'**
  String get desktopKeyRepeat;

  /// No description provided for @desktopKeySearch.
  ///
  /// In en, this message translates to:
  /// **'Search titles and what was said'**
  String get desktopKeySearch;

  /// No description provided for @desktopKeySeek.
  ///
  /// In en, this message translates to:
  /// **'Back or forward 10 seconds'**
  String get desktopKeySeek;

  /// No description provided for @desktopKeyShortcuts.
  ///
  /// In en, this message translates to:
  /// **'This list'**
  String get desktopKeyShortcuts;

  /// No description provided for @desktopKeyVolume.
  ///
  /// In en, this message translates to:
  /// **'Louder or quieter; in shorts, the previous or next one'**
  String get desktopKeyVolume;

  /// No description provided for @desktopKeyZoomIn.
  ///
  /// In en, this message translates to:
  /// **'Larger interface'**
  String get desktopKeyZoomIn;

  /// No description provided for @desktopKeyZoomOut.
  ///
  /// In en, this message translates to:
  /// **'Smaller interface'**
  String get desktopKeyZoomOut;

  /// No description provided for @desktopKeyZoomReset.
  ///
  /// In en, this message translates to:
  /// **'Interface at its usual size'**
  String get desktopKeyZoomReset;

  /// No description provided for @desktopLanguageSystemHint.
  ///
  /// In en, this message translates to:
  /// **'Follows the language of Windows.'**
  String get desktopLanguageSystemHint;

  /// No description provided for @desktopLastArrival.
  ///
  /// In en, this message translates to:
  /// **'Last arrival {when}'**
  String desktopLastArrival(String when);

  /// No description provided for @desktopLess.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get desktopLess;

  /// No description provided for @desktopLibraryLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading the library…'**
  String get desktopLibraryLoading;

  /// No description provided for @desktopLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get desktopLinkCopied;

  /// No description provided for @desktopLinkDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Repeated above'**
  String get desktopLinkDuplicate;

  /// No description provided for @desktopLinkInLibrary.
  ///
  /// In en, this message translates to:
  /// **'Already in your library'**
  String get desktopLinkInLibrary;

  /// No description provided for @desktopLinkPlaylist.
  ///
  /// In en, this message translates to:
  /// **'A playlist: choose its clips'**
  String get desktopLinkPlaylist;

  /// No description provided for @desktopLinkReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get desktopLinkReady;

  /// No description provided for @desktopLinkUnsupported.
  ///
  /// In en, this message translates to:
  /// **'A site this app doesn\'t know'**
  String get desktopLinkUnsupported;

  /// No description provided for @desktopLinksDropped.
  ///
  /// In en, this message translates to:
  /// **'Only the first {limit} links are taken; {count} more were left out.'**
  String desktopLinksDropped(int count, int limit);

  /// No description provided for @desktopLinksFound.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 link} other{{count} links}}'**
  String desktopLinksFound(int count);

  /// No description provided for @desktopListeningClose.
  ///
  /// In en, this message translates to:
  /// **'Close the listening room'**
  String get desktopListeningClose;

  /// No description provided for @desktopListeningRoom.
  ///
  /// In en, this message translates to:
  /// **'Listening room'**
  String get desktopListeningRoom;

  /// No description provided for @desktopLogsCopied.
  ///
  /// In en, this message translates to:
  /// **'Log copied, without links or addresses'**
  String get desktopLogsCopied;

  /// No description provided for @desktopLogsCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get desktopLogsCopy;

  /// No description provided for @desktopLogsSave.
  ///
  /// In en, this message translates to:
  /// **'Save to a file'**
  String get desktopLogsSave;

  /// No description provided for @desktopMiniRestore.
  ///
  /// In en, this message translates to:
  /// **'Back to the full window'**
  String get desktopMiniRestore;

  /// No description provided for @desktopMiniWindow.
  ///
  /// In en, this message translates to:
  /// **'Small window'**
  String get desktopMiniWindow;

  /// No description provided for @desktopMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get desktopMore;

  /// No description provided for @desktopNarrowSidebar.
  ///
  /// In en, this message translates to:
  /// **'Collapse sidebar'**
  String get desktopNarrowSidebar;

  /// No description provided for @desktopNoChannelNames.
  ///
  /// In en, this message translates to:
  /// **'The clips in your library don\'t name their channel, so this channel\'s clips can\'t be picked out. Follow it with its own folder, and whatever arrives there shows here.'**
  String get desktopNoChannelNames;

  /// No description provided for @desktopNoFavoritesMessage.
  ///
  /// In en, this message translates to:
  /// **'Mark a clip as a favorite and it waits for you here.'**
  String get desktopNoFavoritesMessage;

  /// No description provided for @desktopNoFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get desktopNoFavoritesTitle;

  /// No description provided for @desktopNoMatchMessage.
  ///
  /// In en, this message translates to:
  /// **'Clear a filter to see more.'**
  String get desktopNoMatchMessage;

  /// No description provided for @desktopNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches these filters'**
  String get desktopNoMatchTitle;

  /// No description provided for @desktopNoTags.
  ///
  /// In en, this message translates to:
  /// **'No tags yet. Tag a clip from its page and it appears here.'**
  String get desktopNoTags;

  /// No description provided for @desktopNoTranscriptMessage.
  ///
  /// In en, this message translates to:
  /// **'It shows here once the clip\'s subtitles are downloaded with it.'**
  String get desktopNoTranscriptMessage;

  /// No description provided for @desktopNoTranscriptTitle.
  ///
  /// In en, this message translates to:
  /// **'No transcript for this clip'**
  String get desktopNoTranscriptTitle;

  /// No description provided for @desktopNotABackup.
  ///
  /// In en, this message translates to:
  /// **'This file is not a VidHoist backup or transcripts file.'**
  String get desktopNotABackup;

  /// No description provided for @desktopNotWatched.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 not watched} other{{count} not watched}}'**
  String desktopNotWatched(int count);

  /// No description provided for @desktopNothingPlaying.
  ///
  /// In en, this message translates to:
  /// **'Nothing playing'**
  String get desktopNothingPlaying;

  /// No description provided for @desktopNothingPlayingHint.
  ///
  /// In en, this message translates to:
  /// **'Play a clip and its transcript, what comes next and its details appear here.'**
  String get desktopNothingPlayingHint;

  /// No description provided for @desktopNotifyArrivalsHint.
  ///
  /// In en, this message translates to:
  /// **'A Windows notice when new clips from the channels you follow are downloaded.'**
  String get desktopNotifyArrivalsHint;

  /// No description provided for @desktopOfferCopiedLinks.
  ///
  /// In en, this message translates to:
  /// **'Offer links I copy'**
  String get desktopOfferCopiedLinks;

  /// No description provided for @desktopOfferCopiedLinksHint.
  ///
  /// In en, this message translates to:
  /// **'When you copy a video link in another app, a notification offers to add it. Only links are looked at, and none is saved.'**
  String get desktopOfferCopiedLinksHint;

  /// No description provided for @desktopOpenBackup.
  ///
  /// In en, this message translates to:
  /// **'Open Backup'**
  String get desktopOpenBackup;

  /// No description provided for @desktopOpenChannels.
  ///
  /// In en, this message translates to:
  /// **'Open channels'**
  String get desktopOpenChannels;

  /// No description provided for @desktopOpenInExplorer.
  ///
  /// In en, this message translates to:
  /// **'Open in Explorer'**
  String get desktopOpenInExplorer;

  /// No description provided for @desktopOpenWith.
  ///
  /// In en, this message translates to:
  /// **'Open in another player…'**
  String get desktopOpenWith;

  /// No description provided for @desktopPaletteClose.
  ///
  /// In en, this message translates to:
  /// **'to close'**
  String get desktopPaletteClose;

  /// No description provided for @desktopPaletteCommands.
  ///
  /// In en, this message translates to:
  /// **'Commands'**
  String get desktopPaletteCommands;

  /// No description provided for @desktopPaletteHint.
  ///
  /// In en, this message translates to:
  /// **'Search titles and what was said, or type > for commands'**
  String get desktopPaletteHint;

  /// No description provided for @desktopPaletteList.
  ///
  /// In en, this message translates to:
  /// **'List: {name}'**
  String desktopPaletteList(String name);

  /// No description provided for @desktopPaletteMove.
  ///
  /// In en, this message translates to:
  /// **'to move'**
  String get desktopPaletteMove;

  /// No description provided for @desktopPaletteOpen.
  ///
  /// In en, this message translates to:
  /// **'to open'**
  String get desktopPaletteOpen;

  /// No description provided for @desktopPaletteSaid.
  ///
  /// In en, this message translates to:
  /// **'Said inside clips'**
  String get desktopPaletteSaid;

  /// No description provided for @desktopPaletteSave.
  ///
  /// In en, this message translates to:
  /// **'Save this search'**
  String get desktopPaletteSave;

  /// No description provided for @desktopPaletteSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings: {section}'**
  String desktopPaletteSettings(String section);

  /// No description provided for @desktopPaletteTitles.
  ///
  /// In en, this message translates to:
  /// **'Titles'**
  String get desktopPaletteTitles;

  /// No description provided for @desktopPinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get desktopPinned;

  /// No description provided for @desktopPlayNext.
  ///
  /// In en, this message translates to:
  /// **'Play next'**
  String get desktopPlayNext;

  /// No description provided for @desktopPlaysNext.
  ///
  /// In en, this message translates to:
  /// **'Plays next, after this one'**
  String get desktopPlaysNext;

  /// No description provided for @desktopQueueEnd.
  ///
  /// In en, this message translates to:
  /// **'Nothing comes after this one'**
  String get desktopQueueEnd;

  /// No description provided for @desktopQuote.
  ///
  /// In en, this message translates to:
  /// **'“{text}”\n— {title}, {time}\n{link}'**
  String desktopQuote(String text, String title, String time, String link);

  /// No description provided for @desktopQuoteCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied with its time and link'**
  String get desktopQuoteCopied;

  /// No description provided for @desktopReadingBack.
  ///
  /// In en, this message translates to:
  /// **'Back to the clip'**
  String get desktopReadingBack;

  /// No description provided for @desktopReadingCloseFind.
  ///
  /// In en, this message translates to:
  /// **'Close the search'**
  String get desktopReadingCloseFind;

  /// No description provided for @desktopReadingFind.
  ///
  /// In en, this message translates to:
  /// **'Find in the text'**
  String get desktopReadingFind;

  /// No description provided for @desktopReadingFound.
  ///
  /// In en, this message translates to:
  /// **'{at} of {count}'**
  String desktopReadingFound(int at, int count);

  /// No description provided for @desktopReadingHint.
  ///
  /// In en, this message translates to:
  /// **'Click a sentence to hear it from there · Ctrl+F finds a word · select to copy with its time'**
  String get desktopReadingHint;

  /// No description provided for @desktopReadingNextMatch.
  ///
  /// In en, this message translates to:
  /// **'Next match'**
  String get desktopReadingNextMatch;

  /// No description provided for @desktopReadingPreviousMatch.
  ///
  /// In en, this message translates to:
  /// **'Previous match'**
  String get desktopReadingPreviousMatch;

  /// No description provided for @desktopReadingRoom.
  ///
  /// In en, this message translates to:
  /// **'Reading room'**
  String get desktopReadingRoom;

  /// No description provided for @desktopRecoverLibrary.
  ///
  /// In en, this message translates to:
  /// **'Clips already in the folder'**
  String get desktopRecoverLibrary;

  /// No description provided for @desktopRecoverLibraryAction.
  ///
  /// In en, this message translates to:
  /// **'Look in the folder'**
  String get desktopRecoverLibraryAction;

  /// No description provided for @desktopRecoverLibraryHint.
  ///
  /// In en, this message translates to:
  /// **'After a reinstall: puts back in the library the clips that are in the downloads folder but no longer listed. The files are not touched.'**
  String get desktopRecoverLibraryHint;

  /// No description provided for @desktopRecovered.
  ///
  /// In en, this message translates to:
  /// **'Put back in the library: {count}'**
  String desktopRecovered(int count);

  /// No description provided for @desktopRecoveredNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing to add: every clip in the folder is in the library.'**
  String get desktopRecoveredNothing;

  /// No description provided for @desktopRecoveredSome.
  ///
  /// In en, this message translates to:
  /// **'Put back in the library: {count}. Left out, their link unknown: {left}'**
  String desktopRecoveredSome(int count, int left);

  /// No description provided for @desktopRemoveFromList.
  ///
  /// In en, this message translates to:
  /// **'Remove from the list'**
  String get desktopRemoveFromList;

  /// No description provided for @desktopRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get desktopRestore;

  /// No description provided for @desktopRestoreBody.
  ///
  /// In en, this message translates to:
  /// **'This computer\'s library, followed channels, tags, lists and settings become what the backup holds. The downloaded files are not touched.'**
  String get desktopRestoreBody;

  /// No description provided for @desktopRestoreOfferBody.
  ///
  /// In en, this message translates to:
  /// **'Downloads\\VidHoist\\Backups holds a backup of this computer: its library, followed channels, playlists, tags, settings and saved transcripts. The newest was made {when}. Your downloaded files are not touched either way.'**
  String desktopRestoreOfferBody(String when);

  /// No description provided for @desktopRestoreOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore your backup?'**
  String get desktopRestoreOfferTitle;

  /// No description provided for @desktopRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get desktopRestoreTitle;

  /// No description provided for @desktopRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get desktopRestored;

  /// No description provided for @desktopRevealAfterDownload.
  ///
  /// In en, this message translates to:
  /// **'Show in Explorer when done'**
  String get desktopRevealAfterDownload;

  /// No description provided for @desktopRevealAfterDownloadHint.
  ///
  /// In en, this message translates to:
  /// **'When a file downloaded to this computer is done, its folder opens with the file chosen.'**
  String get desktopRevealAfterDownloadHint;

  /// No description provided for @desktopSavedIn.
  ///
  /// In en, this message translates to:
  /// **'Saved in {folder}'**
  String desktopSavedIn(String folder);

  /// No description provided for @desktopSavedSearchDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete the saved search “{name}”? Nothing in the library changes.'**
  String desktopSavedSearchDelete(String name);

  /// No description provided for @desktopSavedSearchName.
  ///
  /// In en, this message translates to:
  /// **'Search name'**
  String get desktopSavedSearchName;

  /// No description provided for @desktopSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get desktopSearch;

  /// No description provided for @desktopSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search titles and what was said…'**
  String get desktopSearchHint;

  /// No description provided for @desktopSearchSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved in the sidebar'**
  String get desktopSearchSaved;

  /// No description provided for @desktopSeekBar.
  ///
  /// In en, this message translates to:
  /// **'Position in the clip'**
  String get desktopSeekBar;

  /// No description provided for @desktopSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 selected} other{{count} selected}}'**
  String desktopSelectedCount(int count);

  /// No description provided for @desktopSetupChooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a file…'**
  String get desktopSetupChooseFile;

  /// No description provided for @desktopShortcutsApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get desktopShortcutsApp;

  /// No description provided for @desktopShortcutsClip.
  ///
  /// In en, this message translates to:
  /// **'On a chosen clip'**
  String get desktopShortcutsClip;

  /// No description provided for @desktopShortcutsPlayback.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get desktopShortcutsPlayback;

  /// No description provided for @desktopShortcutsTitle.
  ///
  /// In en, this message translates to:
  /// **'Keyboard shortcuts'**
  String get desktopShortcutsTitle;

  /// No description provided for @desktopShortcutsWindow.
  ///
  /// In en, this message translates to:
  /// **'Window'**
  String get desktopShortcutsWindow;

  /// No description provided for @desktopShortsHint.
  ///
  /// In en, this message translates to:
  /// **'↑ ↓ or the wheel for the next short · double-click to favorite'**
  String get desktopShortsHint;

  /// No description provided for @desktopShowInFolder.
  ///
  /// In en, this message translates to:
  /// **'Show in folder'**
  String get desktopShowInFolder;

  /// No description provided for @desktopShowPanel.
  ///
  /// In en, this message translates to:
  /// **'Show side panel'**
  String get desktopShowPanel;

  /// No description provided for @desktopStartFresh.
  ///
  /// In en, this message translates to:
  /// **'Start fresh'**
  String get desktopStartFresh;

  /// No description provided for @desktopStartWithWindows.
  ///
  /// In en, this message translates to:
  /// **'Start with Windows'**
  String get desktopStartWithWindows;

  /// No description provided for @desktopStartWithWindowsHint.
  ///
  /// In en, this message translates to:
  /// **'Opens when you sign in: in the tray when it keeps playing there, otherwise minimized.'**
  String get desktopStartWithWindowsHint;

  /// No description provided for @desktopStartWithWindowsRefused.
  ///
  /// In en, this message translates to:
  /// **'Windows did not let the app start with it.'**
  String get desktopStartWithWindowsRefused;

  /// No description provided for @desktopStats.
  ///
  /// In en, this message translates to:
  /// **'Library statistics'**
  String get desktopStats;

  /// No description provided for @desktopStatsByChannel.
  ///
  /// In en, this message translates to:
  /// **'By channel'**
  String get desktopStatsByChannel;

  /// No description provided for @desktopStatsByMonth.
  ///
  /// In en, this message translates to:
  /// **'By month added'**
  String get desktopStatsByMonth;

  /// No description provided for @desktopStatsBySite.
  ///
  /// In en, this message translates to:
  /// **'By site'**
  String get desktopStatsBySite;

  /// No description provided for @desktopStatsClips.
  ///
  /// In en, this message translates to:
  /// **'Clips'**
  String get desktopStatsClips;

  /// No description provided for @desktopStatsHint.
  ///
  /// In en, this message translates to:
  /// **'What the library holds, and what may deserve a look. Nothing is deleted from here.'**
  String get desktopStatsHint;

  /// No description provided for @desktopStatsHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Under an hour} =1{1 hour} other{{count} hours}}'**
  String desktopStatsHours(int count);

  /// No description provided for @desktopStatsLargest.
  ///
  /// In en, this message translates to:
  /// **'The largest:'**
  String get desktopStatsLargest;

  /// No description provided for @desktopStatsLength.
  ///
  /// In en, this message translates to:
  /// **'Running time'**
  String get desktopStatsLength;

  /// No description provided for @desktopStatsLink.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get desktopStatsLink;

  /// No description provided for @desktopStatsNeverPlayed.
  ///
  /// In en, this message translates to:
  /// **'Never played here'**
  String get desktopStatsNeverPlayed;

  /// No description provided for @desktopStatsNewest.
  ///
  /// In en, this message translates to:
  /// **'The newest:'**
  String get desktopStatsNewest;

  /// No description provided for @desktopStatsOtherChannels.
  ///
  /// In en, this message translates to:
  /// **'Other channels'**
  String get desktopStatsOtherChannels;

  /// No description provided for @desktopStatsRoom.
  ///
  /// In en, this message translates to:
  /// **'Room taken'**
  String get desktopStatsRoom;

  /// No description provided for @desktopStatsUnnamed.
  ///
  /// In en, this message translates to:
  /// **'No channel named'**
  String get desktopStatsUnnamed;

  /// No description provided for @desktopStatsWithText.
  ///
  /// In en, this message translates to:
  /// **'With a transcript'**
  String get desktopStatsWithText;

  /// No description provided for @desktopStatsWithoutText.
  ///
  /// In en, this message translates to:
  /// **'Without a transcript'**
  String get desktopStatsWithoutText;

  /// No description provided for @desktopStatsWorthALook.
  ///
  /// In en, this message translates to:
  /// **'Worth a look'**
  String get desktopStatsWorthALook;

  /// No description provided for @desktopSubtitleOptions.
  ///
  /// In en, this message translates to:
  /// **'Subtitle options'**
  String get desktopSubtitleOptions;

  /// No description provided for @desktopTheater.
  ///
  /// In en, this message translates to:
  /// **'Theater'**
  String get desktopTheater;

  /// No description provided for @desktopTranscriptFirst.
  ///
  /// In en, this message translates to:
  /// **'Fetch its transcript first'**
  String get desktopTranscriptFirst;

  /// No description provided for @desktopTranscriptHint.
  ///
  /// In en, this message translates to:
  /// **'Follows playback · click a line to jump'**
  String get desktopTranscriptHint;

  /// No description provided for @desktopTranscriptsDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'They are removed from this computer and from its backup. Only a file you exported can bring them back.'**
  String get desktopTranscriptsDeleteBody;

  /// No description provided for @desktopTranscriptsHelp.
  ///
  /// In en, this message translates to:
  /// **'VidHoist keeps the words said in each YouTube clip you add, so a search (Ctrl+K) also finds what was said inside your clips, not only their titles. They stay on this computer.'**
  String get desktopTranscriptsHelp;

  /// No description provided for @desktopTranscriptsMove.
  ///
  /// In en, this message translates to:
  /// **'To or from a phone'**
  String get desktopTranscriptsMove;

  /// No description provided for @desktopTranscriptsMoveHint.
  ///
  /// In en, this message translates to:
  /// **'Transcripts travel with the backup: Export for the phone takes them, and Import there brings them in, adding what is missing here.'**
  String get desktopTranscriptsMoveHint;

  /// No description provided for @desktopTrayOnClose.
  ///
  /// In en, this message translates to:
  /// **'Keep playing in the tray when the window closes'**
  String get desktopTrayOnClose;

  /// No description provided for @desktopTrayOnCloseHint.
  ///
  /// In en, this message translates to:
  /// **'Closing the window keeps the sound playing; quit from the icon by the clock.'**
  String get desktopTrayOnCloseHint;

  /// No description provided for @desktopTrayOpen.
  ///
  /// In en, this message translates to:
  /// **'Open VidHoist'**
  String get desktopTrayOpen;

  /// No description provided for @desktopTrayQuit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get desktopTrayQuit;

  /// No description provided for @desktopUiSize.
  ///
  /// In en, this message translates to:
  /// **'Interface size'**
  String get desktopUiSize;

  /// No description provided for @desktopUiSizeHint.
  ///
  /// In en, this message translates to:
  /// **'{bigger} and {smaller} change it from anywhere, and {reset} returns to 100%.'**
  String desktopUiSizeHint(String bigger, String smaller, String reset);

  /// No description provided for @desktopUiSizeTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Too large for this screen'**
  String get desktopUiSizeTooLarge;

  /// No description provided for @desktopUpdateInstall.
  ///
  /// In en, this message translates to:
  /// **'Install and restart'**
  String get desktopUpdateInstall;

  /// No description provided for @desktopUpdateRestartHint.
  ///
  /// In en, this message translates to:
  /// **'VidHoist closes, installs the update and opens again. Your settings and library stay as they are.'**
  String get desktopUpdateRestartHint;

  /// No description provided for @desktopViewCompact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get desktopViewCompact;

  /// No description provided for @desktopViewTable.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get desktopViewTable;

  /// No description provided for @desktopVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get desktopVolume;

  /// No description provided for @desktopVolumeLevel.
  ///
  /// In en, this message translates to:
  /// **'Volume {percent}%'**
  String desktopVolumeLevel(int percent);

  /// No description provided for @desktopWelcomeFetchNow.
  ///
  /// In en, this message translates to:
  /// **'Fetch them now'**
  String get desktopWelcomeFetchNow;

  /// No description provided for @desktopWelcomeHelpers.
  ///
  /// In en, this message translates to:
  /// **'ffmpeg (joins picture and sound) and Deno (needed by YouTube) come down by themselves at the first download, about 160 MB. You can fetch them now instead.'**
  String get desktopWelcomeHelpers;

  /// No description provided for @desktopWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Paste a link from YouTube or another site, and VidHoist downloads it to this computer with yt-dlp.'**
  String get desktopWelcomeMessage;

  /// No description provided for @desktopWelcomeStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get desktopWelcomeStart;

  /// No description provided for @desktopWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to VidHoist'**
  String get desktopWelcomeTitle;

  /// No description provided for @desktopWhatsNewAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'Everything VidHoist can do'**
  String get desktopWhatsNewAllFeatures;

  /// No description provided for @desktopWidenSidebar.
  ///
  /// In en, this message translates to:
  /// **'Expand sidebar'**
  String get desktopWidenSidebar;

  /// No description provided for @desktopWindowClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get desktopWindowClose;

  /// No description provided for @desktopWindowMaximize.
  ///
  /// In en, this message translates to:
  /// **'Maximize'**
  String get desktopWindowMaximize;

  /// No description provided for @desktopWindowMinimize.
  ///
  /// In en, this message translates to:
  /// **'Minimize'**
  String get desktopWindowMinimize;

  /// No description provided for @desktopWindowRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore down'**
  String get desktopWindowRestore;

  /// No description provided for @desktopZoomChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get desktopZoomChange;

  /// No description provided for @desktopZoomLowered.
  ///
  /// In en, this message translates to:
  /// **'The interface is now {percent} so it fits this screen.'**
  String desktopZoomLowered(String percent);

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @developerName.
  ///
  /// In en, this message translates to:
  /// **'Yasir Sagheer'**
  String get developerName;

  /// No description provided for @diagnosticLogs.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic logs'**
  String get diagnosticLogs;

  /// No description provided for @diagnosticLogsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View, search, and share app logs (redacted)'**
  String get diagnosticLogsSubtitle;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @disclaimerText.
  ///
  /// In en, this message translates to:
  /// **'This app downloads media with yt-dlp. The developer is not responsible for how users utilize this tool. Please respect copyright laws and the terms of service of the sites you download from.'**
  String get disclaimerText;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @downloadComplete.
  ///
  /// In en, this message translates to:
  /// **'Download complete'**
  String get downloadComplete;

  /// No description provided for @downloadCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get downloadCompleteTitle;

  /// No description provided for @downloadDate.
  ///
  /// In en, this message translates to:
  /// **'Download date'**
  String get downloadDate;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadFailed;

  /// No description provided for @downloadFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadFailedTitle;

  /// No description provided for @downloadNow.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get downloadNow;

  /// No description provided for @downloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Download started…'**
  String get downloadStarted;

  /// No description provided for @downloadStartedQuality.
  ///
  /// In en, this message translates to:
  /// **'Download started · {quality}'**
  String downloadStartedQuality(Object quality);

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading…'**
  String get downloading;

  /// No description provided for @downloadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get downloadingTitle;

  /// No description provided for @downloadsAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get downloadsAdvanced;

  /// No description provided for @editSubscription.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editSubscription;

  /// No description provided for @embedSubtitles.
  ///
  /// In en, this message translates to:
  /// **'Subtitles inside the video too'**
  String get embedSubtitles;

  /// No description provided for @embedSubtitlesHelp.
  ///
  /// In en, this message translates to:
  /// **'So other players show them. VidHoist\'s own player shows them either way.'**
  String get embedSubtitlesHelp;

  /// No description provided for @emptyFilteredMessage.
  ///
  /// In en, this message translates to:
  /// **'Clear a filter above to see your whole library.'**
  String get emptyFilteredMessage;

  /// No description provided for @emptyFilteredTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches these filters'**
  String get emptyFilteredTitle;

  /// No description provided for @emptyPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Empty playlist'**
  String get emptyPlaylist;

  /// No description provided for @emptyPlaylistMessage.
  ///
  /// In en, this message translates to:
  /// **'Add clips from the library'**
  String get emptyPlaylistMessage;

  /// No description provided for @engineDownloadingProgress.
  ///
  /// In en, this message translates to:
  /// **'Downloading · {percent}%'**
  String engineDownloadingProgress(Object percent);

  /// No description provided for @engineErrDiskFull.
  ///
  /// In en, this message translates to:
  /// **'Not enough storage space for this file'**
  String get engineErrDiskFull;

  /// No description provided for @engineErrFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed: {reason}'**
  String engineErrFailed(Object reason);

  /// No description provided for @engineErrFormat.
  ///
  /// In en, this message translates to:
  /// **'This quality is not available for this video'**
  String get engineErrFormat;

  /// No description provided for @engineErrGeoBlocked.
  ///
  /// In en, this message translates to:
  /// **'Not available in your country'**
  String get engineErrGeoBlocked;

  /// No description provided for @engineErrMissing.
  ///
  /// In en, this message translates to:
  /// **'The download engine is missing or incomplete. Repair it in Settings with Repair the engine'**
  String get engineErrMissing;

  /// No description provided for @engineErrRateLimited.
  ///
  /// In en, this message translates to:
  /// **'The site is limiting requests. Try again in a while'**
  String get engineErrRateLimited;

  /// No description provided for @engineErrUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This video is unavailable, private or removed'**
  String get engineErrUnavailable;

  /// No description provided for @engineErrUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This link is not supported'**
  String get engineErrUnsupported;

  /// No description provided for @enginePaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get enginePaused;

  /// No description provided for @enginePostprocessing.
  ///
  /// In en, this message translates to:
  /// **'Finishing the file…'**
  String get enginePostprocessing;

  /// No description provided for @enginePreparing.
  ///
  /// In en, this message translates to:
  /// **'Reading the link…'**
  String get enginePreparing;

  /// No description provided for @engineRepair.
  ///
  /// In en, this message translates to:
  /// **'Repair the engine'**
  String get engineRepair;

  /// No description provided for @engineRepairBusy.
  ///
  /// In en, this message translates to:
  /// **'Wait for the downloads to finish, then repair'**
  String get engineRepairBusy;

  /// No description provided for @engineRepairHint.
  ///
  /// In en, this message translates to:
  /// **'When downloads fail across sites as they did not before, and an update did not help: clears what yt-dlp saved and puts back a clean, current copy. Your downloads and settings stay as they are.'**
  String get engineRepairHint;

  /// No description provided for @engineRepairPartly.
  ///
  /// In en, this message translates to:
  /// **'Repaired in part: the rest needs a connection. Try again once online.'**
  String get engineRepairPartly;

  /// No description provided for @engineRepaired.
  ///
  /// In en, this message translates to:
  /// **'Repaired: yt-dlp {version}'**
  String engineRepaired(String version);

  /// No description provided for @engineRepairing.
  ///
  /// In en, this message translates to:
  /// **'Repairing…'**
  String get engineRepairing;

  /// No description provided for @engineResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get engineResume;

  /// No description provided for @enterFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get enterFullscreen;

  /// No description provided for @errClipPastEnd.
  ///
  /// In en, this message translates to:
  /// **'The part starts after the video ends ({length})'**
  String errClipPastEnd(Object length);

  /// No description provided for @errClipPastEndUnknown.
  ///
  /// In en, this message translates to:
  /// **'The part starts after the video ends'**
  String get errClipPastEndUnknown;

  /// No description provided for @errNetwork.
  ///
  /// In en, this message translates to:
  /// **'No connection to the site'**
  String get errNetwork;

  /// No description provided for @errPlatformBlockedCookies.
  ///
  /// In en, this message translates to:
  /// **'The site requires a login. Choose a cookies file in Settings › Cookies'**
  String get errPlatformBlockedCookies;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorGeneric(Object message);

  /// No description provided for @every30Minutes.
  ///
  /// In en, this message translates to:
  /// **'Every 30 minutes'**
  String get every30Minutes;

  /// No description provided for @everyHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Every hour} other{Every {count} hours}}'**
  String everyHours(int count);

  /// No description provided for @exitFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Exit fullscreen'**
  String get exitFullscreen;

  /// No description provided for @exportShare.
  ///
  /// In en, this message translates to:
  /// **'Export & share'**
  String get exportShare;

  /// No description provided for @exportShareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A dated copy to send or keep elsewhere'**
  String get exportShareSubtitle;

  /// No description provided for @externalPlayerShort.
  ///
  /// In en, this message translates to:
  /// **'Another player'**
  String get externalPlayerShort;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @failedToLoadPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Failed to load playlist'**
  String get failedToLoadPlaylist;

  /// No description provided for @fastStreams.
  ///
  /// In en, this message translates to:
  /// **'Faster segmented streams'**
  String get fastStreams;

  /// No description provided for @fastStreamsHelp.
  ///
  /// In en, this message translates to:
  /// **'Fetches {count} pieces at once from sites that cut a video into pieces, such as X. Some sites slow down many requests at once.'**
  String fastStreamsHelp(int count);

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @fileSize.
  ///
  /// In en, this message translates to:
  /// **'File size'**
  String get fileSize;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get filterAudio;

  /// No description provided for @filterVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get filterVideo;

  /// No description provided for @filtersOn.
  ///
  /// In en, this message translates to:
  /// **'Filters on'**
  String get filtersOn;

  /// No description provided for @folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folder;

  /// No description provided for @foldersHelp.
  ///
  /// In en, this message translates to:
  /// **'A folder is made inside the download folder, and the clip is saved straight into it, where Explorer and any other app see it. Leave it at \"No folder\" and the clip goes to the top of the download folder.'**
  String get foldersHelp;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @followChannel.
  ///
  /// In en, this message translates to:
  /// **'Follow a channel'**
  String get followChannel;

  /// No description provided for @format.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get format;

  /// No description provided for @framesPerSecond.
  ///
  /// In en, this message translates to:
  /// **'{count} fps'**
  String framesPerSecond(int count);

  /// No description provided for @helpAboutField.
  ///
  /// In en, this message translates to:
  /// **'About this field'**
  String get helpAboutField;

  /// No description provided for @inPlaylists.
  ///
  /// In en, this message translates to:
  /// **'In playlists'**
  String get inPlaylists;

  /// No description provided for @invalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid link'**
  String get invalidUrl;

  /// No description provided for @itemOptions.
  ///
  /// In en, this message translates to:
  /// **'Item options'**
  String get itemOptions;

  /// No description provided for @itemUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No longer available'**
  String get itemUnavailable;

  /// No description provided for @jumpToNewest.
  ///
  /// In en, this message translates to:
  /// **'Go to the newest'**
  String get jumpToNewest;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @knownVideos.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing known yet} =1{1 video known} other{{count} videos known}}'**
  String knownVideos(int count);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageSystemHint.
  ///
  /// In en, this message translates to:
  /// **'Follows your phone\'s language'**
  String get languageSystemHint;

  /// No description provided for @lastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last backup {when}'**
  String lastBackup(String when);

  /// No description provided for @lastCheckedAt.
  ///
  /// In en, this message translates to:
  /// **'Last checked {when}'**
  String lastCheckedAt(String when);

  /// No description provided for @latestAdditions.
  ///
  /// In en, this message translates to:
  /// **'Latest additions'**
  String get latestAdditions;

  /// No description provided for @licensedUnder.
  ///
  /// In en, this message translates to:
  /// **'Licensed under GPL-3.0'**
  String get licensedUnder;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get licenses;

  /// No description provided for @listSeparator.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get listSeparator;

  /// No description provided for @listenInBackground.
  ///
  /// In en, this message translates to:
  /// **'Listen in the background'**
  String get listenInBackground;

  /// No description provided for @lockTouch.
  ///
  /// In en, this message translates to:
  /// **'Lock touch'**
  String get lockTouch;

  /// No description provided for @loginDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get loginDone;

  /// No description provided for @loginKept.
  ///
  /// In en, this message translates to:
  /// **'Signed in to {site}; downloads will use it'**
  String loginKept(String site);

  /// No description provided for @loginNotYet.
  ///
  /// In en, this message translates to:
  /// **'No sign-in found yet. Finish signing in, then tap Done'**
  String get loginNotYet;

  /// No description provided for @logsEmpty.
  ///
  /// In en, this message translates to:
  /// **'The log is empty'**
  String get logsEmpty;

  /// No description provided for @logsSanitizedNote.
  ///
  /// In en, this message translates to:
  /// **'Links, addresses and credentials are stripped before sharing'**
  String get logsSanitizedNote;

  /// No description provided for @manageTags.
  ///
  /// In en, this message translates to:
  /// **'Manage tags'**
  String get manageTags;

  /// No description provided for @mediaAccessBlockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Android will not ask again. Turn on photos and videos for this app in the system settings, then come back.'**
  String get mediaAccessBlockedMessage;

  /// No description provided for @mediaAccessGrant.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get mediaAccessGrant;

  /// No description provided for @mediaAccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your downloads are kept in the phone\'s Download folder, and Android needs your permission before the app can list them.'**
  String get mediaAccessMessage;

  /// No description provided for @mediaAccessOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get mediaAccessOpenSettings;

  /// No description provided for @mediaAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow access to your media'**
  String get mediaAccessTitle;

  /// No description provided for @miniPlayerTab.
  ///
  /// In en, this message translates to:
  /// **'Player: {title}. Tap for the controls'**
  String miniPlayerTab(String title);

  /// No description provided for @mobileChannelsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Follow a channel and each new video downloads by itself while VidHoist is open or in the background; what came while it was closed downloads when it opens. What is already on the channel is not downloaded.'**
  String get mobileChannelsEmptyBody;

  /// No description provided for @mobileChannelsHint.
  ///
  /// In en, this message translates to:
  /// **'New videos from channels you follow, downloaded by themselves'**
  String get mobileChannelsHint;

  /// No description provided for @mobileEngineIpv4.
  ///
  /// In en, this message translates to:
  /// **'Connect over IPv4'**
  String get mobileEngineIpv4;

  /// No description provided for @mobileEngineIpv4Help.
  ///
  /// In en, this message translates to:
  /// **'Avoids a long stall on networks whose IPv6 route is broken. Turn it off only if your network has IPv6 alone.'**
  String get mobileEngineIpv4Help;

  /// No description provided for @mobileEngineLastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last updated {when}'**
  String mobileEngineLastUpdate(String when);

  /// No description provided for @mobileEngineNotReady.
  ///
  /// In en, this message translates to:
  /// **'Getting ready…'**
  String get mobileEngineNotReady;

  /// No description provided for @mobileEngineUpToDate.
  ///
  /// In en, this message translates to:
  /// **'yt-dlp is up to date'**
  String get mobileEngineUpToDate;

  /// No description provided for @mobileEngineUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update yt-dlp'**
  String get mobileEngineUpdate;

  /// No description provided for @mobileEngineUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update yt-dlp. Check the connection and try again.'**
  String get mobileEngineUpdateFailed;

  /// No description provided for @mobileEngineUpdateMissed.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get mobileEngineUpdateMissed;

  /// No description provided for @mobileEngineUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get mobileEngineUpdated;

  /// No description provided for @mobileEngineUpdating.
  ///
  /// In en, this message translates to:
  /// **'Updating…'**
  String get mobileEngineUpdating;

  /// No description provided for @mobileEngineVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'yt-dlp version'**
  String get mobileEngineVersionLabel;

  /// No description provided for @mobileEngineVersionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Its version shows after the first update'**
  String get mobileEngineVersionUnknown;

  /// No description provided for @mobileSettingsEngine.
  ///
  /// In en, this message translates to:
  /// **'Download engine'**
  String get mobileSettingsEngine;

  /// No description provided for @mobileSettingsGroupEngine.
  ///
  /// In en, this message translates to:
  /// **'Engine'**
  String get mobileSettingsGroupEngine;

  /// No description provided for @mobileSignInNeeded.
  ///
  /// In en, this message translates to:
  /// **'This site wants you signed in. Sign in from Settings › Accounts, then retry'**
  String get mobileSignInNeeded;

  /// No description provided for @mobileSubtitleOptions.
  ///
  /// In en, this message translates to:
  /// **'Size, background and the transcript'**
  String get mobileSubtitleOptions;

  /// No description provided for @mobileSubtitleStyleHelp.
  ///
  /// In en, this message translates to:
  /// **'Also in the player: hold the CC button.'**
  String get mobileSubtitleStyleHelp;

  /// No description provided for @mobileSubtitles.
  ///
  /// In en, this message translates to:
  /// **'Download subtitles'**
  String get mobileSubtitles;

  /// No description provided for @mobileSubtitlesHelp.
  ///
  /// In en, this message translates to:
  /// **'Subtitles in the languages below, when the video has them, saved beside it and shown in the player.'**
  String get mobileSubtitlesHelp;

  /// No description provided for @mobileSubtitlesSizeLarger.
  ///
  /// In en, this message translates to:
  /// **'Larger'**
  String get mobileSubtitlesSizeLarger;

  /// No description provided for @mobileTranscript.
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get mobileTranscript;

  /// No description provided for @mobileTranscriptHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a line to play from there.'**
  String get mobileTranscriptHint;

  /// No description provided for @mobileTranscriptOpen.
  ///
  /// In en, this message translates to:
  /// **'Read the transcript'**
  String get mobileTranscriptOpen;

  /// No description provided for @mobileWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Videos and audio from the sites you use, saved straight to this phone. The download engine is getting ready; this happens only once.'**
  String get mobileWelcomeBody;

  /// No description provided for @mobileWelcomeFailed.
  ///
  /// In en, this message translates to:
  /// **'The engine couldn\'t start. Try again; if it keeps failing, reinstall the app.'**
  String get mobileWelcomeFailed;

  /// No description provided for @mobileWelcomeStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get mobileWelcomeStart;

  /// No description provided for @mobileWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to VidHoist'**
  String get mobileWelcomeTitle;

  /// No description provided for @mobileWelcomeUnpacking.
  ///
  /// In en, this message translates to:
  /// **'Preparing the download engine'**
  String get mobileWelcomeUnpacking;

  /// No description provided for @mobileWelcomeUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update now. VidHoist tries again before your first download.'**
  String get mobileWelcomeUpdateFailed;

  /// No description provided for @mobileWelcomeUpdating.
  ///
  /// In en, this message translates to:
  /// **'Updating yt-dlp to its latest version'**
  String get mobileWelcomeUpdating;

  /// No description provided for @modeAutoNext.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get modeAutoNext;

  /// No description provided for @modeRepeatAll.
  ///
  /// In en, this message translates to:
  /// **'Repeat all'**
  String get modeRepeatAll;

  /// No description provided for @modeRepeatOne.
  ///
  /// In en, this message translates to:
  /// **'Repeat one'**
  String get modeRepeatOne;

  /// No description provided for @modeStopAtEnd.
  ///
  /// In en, this message translates to:
  /// **'Stop at end'**
  String get modeStopAtEnd;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navMyDownloads.
  ///
  /// In en, this message translates to:
  /// **'My downloads'**
  String get navMyDownloads;

  /// No description provided for @navPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get navPlaylists;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @needsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs your attention'**
  String get needsAttention;

  /// No description provided for @neverChecked.
  ///
  /// In en, this message translates to:
  /// **'Not checked yet'**
  String get neverChecked;

  /// No description provided for @newFolder.
  ///
  /// In en, this message translates to:
  /// **'New folder…'**
  String get newFolder;

  /// No description provided for @newFolderHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ai/Lessons'**
  String get newFolderHint;

  /// No description provided for @newPlaylistAction.
  ///
  /// In en, this message translates to:
  /// **'New playlist'**
  String get newPlaylistAction;

  /// No description provided for @newTagHint.
  ///
  /// In en, this message translates to:
  /// **'New tag'**
  String get newTagHint;

  /// No description provided for @newVideosBody.
  ///
  /// In en, this message translates to:
  /// **'{channels}. They download when you open VidHoist.'**
  String newVideosBody(String channels);

  /// No description provided for @newVideosNotice.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 new video} other{{count} new videos}}'**
  String newVideosNotice(int count);

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @noBackupsYet.
  ///
  /// In en, this message translates to:
  /// **'No backups yet'**
  String get noBackupsYet;

  /// No description provided for @noDownloads.
  ///
  /// In en, this message translates to:
  /// **'No downloads'**
  String get noDownloads;

  /// No description provided for @noDownloadsMessage.
  ///
  /// In en, this message translates to:
  /// **'Downloaded clips will appear here.\nShare a link or use the Add link button.'**
  String get noDownloadsMessage;

  /// No description provided for @noExternalPlayer.
  ///
  /// In en, this message translates to:
  /// **'No external player on this device'**
  String get noExternalPlayer;

  /// No description provided for @noFolder.
  ///
  /// In en, this message translates to:
  /// **'No folder'**
  String get noFolder;

  /// No description provided for @noFolderHint.
  ///
  /// In en, this message translates to:
  /// **'At the top of the downloads'**
  String get noFolderHint;

  /// No description provided for @noLogsFound.
  ///
  /// In en, this message translates to:
  /// **'No logs found'**
  String get noLogsFound;

  /// No description provided for @noPlayableSource.
  ///
  /// In en, this message translates to:
  /// **'This item has no playable source'**
  String get noPlayableSource;

  /// No description provided for @noPlaylistsMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a playlist to organize your clips'**
  String get noPlaylistsMessage;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @noResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'No items match your search.'**
  String get noResultsMessage;

  /// No description provided for @noServerTitle.
  ///
  /// In en, this message translates to:
  /// **'The download engine is not ready'**
  String get noServerTitle;

  /// No description provided for @noticeChannelNewVideos.
  ///
  /// In en, this message translates to:
  /// **'New videos'**
  String get noticeChannelNewVideos;

  /// No description provided for @noticeChannelUpdates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get noticeChannelUpdates;

  /// No description provided for @noVideosFound.
  ///
  /// In en, this message translates to:
  /// **'Your library is empty'**
  String get noVideosFound;

  /// No description provided for @noWarranty.
  ///
  /// In en, this message translates to:
  /// **'Provided as is, without any warranty.'**
  String get noWarranty;

  /// No description provided for @notAffiliated.
  ///
  /// In en, this message translates to:
  /// **'Not affiliated with yt-dlp or with any site, and not endorsed by them.'**
  String get notAffiliated;

  /// No description provided for @nothingHereYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get nothingHereYet;

  /// No description provided for @notificationClipGone.
  ///
  /// In en, this message translates to:
  /// **'This clip is no longer on the phone.'**
  String get notificationClipGone;

  /// No description provided for @nowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now playing'**
  String get nowPlaying;

  /// No description provided for @nowPlayingCollapse.
  ///
  /// In en, this message translates to:
  /// **'Fold the player panel'**
  String get nowPlayingCollapse;

  /// No description provided for @nowPlayingExpand.
  ///
  /// In en, this message translates to:
  /// **'Show the player panel'**
  String get nowPlayingExpand;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @onlyNewVideos.
  ///
  /// In en, this message translates to:
  /// **'Only what appears from now on is downloaded. The videos already on the channel are left where they are.'**
  String get onlyNewVideos;

  /// No description provided for @openChannel.
  ///
  /// In en, this message translates to:
  /// **'Open channel'**
  String get openChannel;

  /// No description provided for @openInExternalPlayer.
  ///
  /// In en, this message translates to:
  /// **'Open in another player'**
  String get openInExternalPlayer;

  /// No description provided for @openOriginalLink.
  ///
  /// In en, this message translates to:
  /// **'Open original link'**
  String get openOriginalLink;

  /// No description provided for @ownFolder.
  ///
  /// In en, this message translates to:
  /// **'Save in its own folder'**
  String get ownFolder;

  /// No description provided for @ownFolderNote.
  ///
  /// In en, this message translates to:
  /// **'A folder inside the download folder, which Explorer and other apps see too. Only what arrives from now on goes there; what is already downloaded stays where it is.'**
  String get ownFolderNote;

  /// No description provided for @pasteUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the link here…'**
  String get pasteUrlHint;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @pauseSubscription.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseSubscription;

  /// No description provided for @pcAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get pcAddressLabel;

  /// No description provided for @pcBadAddress.
  ///
  /// In en, this message translates to:
  /// **'Type the address as the computer shows it, for example 192.168.1.24.'**
  String get pcBadAddress;

  /// No description provided for @pcBadQr.
  ///
  /// In en, this message translates to:
  /// **'This is not a VidHoist pairing QR code.'**
  String get pcBadQr;

  /// No description provided for @pcCertificate.
  ///
  /// In en, this message translates to:
  /// **'Computer\'s certificate'**
  String get pcCertificate;

  /// No description provided for @pcCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get pcCodeLabel;

  /// No description provided for @pcConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get pcConnected;

  /// No description provided for @pcCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to the phone\'s library, with its subtitles.'**
  String get pcCopied;

  /// No description provided for @pcCopyFailed.
  ///
  /// In en, this message translates to:
  /// **'The copy did not finish: the computer may be off or out of reach. Nothing was kept.'**
  String get pcCopyFailed;

  /// No description provided for @pcCopyStarting.
  ///
  /// In en, this message translates to:
  /// **'Copying…'**
  String get pcCopyStarting;

  /// No description provided for @pcCopyStop.
  ///
  /// In en, this message translates to:
  /// **'Stop copying'**
  String get pcCopyStop;

  /// No description provided for @pcCopyToPhone.
  ///
  /// In en, this message translates to:
  /// **'Copy to the phone'**
  String get pcCopyToPhone;

  /// No description provided for @pcCopying.
  ///
  /// In en, this message translates to:
  /// **'Copying {percent}%'**
  String pcCopying(int percent);

  /// No description provided for @pcDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete from the computer'**
  String get pcDelete;

  /// No description provided for @pcDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" goes to the computer\'s Recycle Bin, where it can be got back.'**
  String pcDeleteBody(String title);

  /// No description provided for @pcDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'The computer could not delete it. It may be open there.'**
  String get pcDeleteFailed;

  /// No description provided for @pcDeleteMissing.
  ///
  /// In en, this message translates to:
  /// **'This clip is no longer on the computer.'**
  String get pcDeleteMissing;

  /// No description provided for @pcDeleteNoBin.
  ///
  /// In en, this message translates to:
  /// **'Not deleted: its drive on the computer has no Recycle Bin.'**
  String get pcDeleteNoBin;

  /// No description provided for @pcDeleteNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'The computer does not let the phone delete. Turn it on there in Settings › Phone.'**
  String get pcDeleteNotAllowed;

  /// No description provided for @pcDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete from {name}?'**
  String pcDeleteTitle(String name);

  /// No description provided for @pcDeleted.
  ///
  /// In en, this message translates to:
  /// **'In the computer\'s Recycle Bin: {title}'**
  String pcDeleted(String title);

  /// No description provided for @pcDestPhone.
  ///
  /// In en, this message translates to:
  /// **'This phone'**
  String get pcDestPhone;

  /// No description provided for @pcDoneOnPc.
  ///
  /// In en, this message translates to:
  /// **'Done on the computer: {title}'**
  String pcDoneOnPc(String title);

  /// No description provided for @pcDownloadsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 download for the computer} other{{count} downloads for the computer}}'**
  String pcDownloadsCount(int count);

  /// No description provided for @pcDownloadsSheet.
  ///
  /// In en, this message translates to:
  /// **'Downloads on the computer'**
  String get pcDownloadsSheet;

  /// No description provided for @pcEmptyLibrary.
  ///
  /// In en, this message translates to:
  /// **'No downloads on the computer yet.'**
  String get pcEmptyLibrary;

  /// No description provided for @pcErrBad.
  ///
  /// In en, this message translates to:
  /// **'The computer answered in a way this version does not understand. Update both apps.'**
  String get pcErrBad;

  /// No description provided for @pcErrClosed.
  ///
  /// In en, this message translates to:
  /// **'No code is showing on the computer, or it expired. Press Pair a phone there.'**
  String get pcErrClosed;

  /// No description provided for @pcErrDenied.
  ///
  /// In en, this message translates to:
  /// **'The pairing was refused on the computer, or not answered in time.'**
  String get pcErrDenied;

  /// No description provided for @pcErrRefused.
  ///
  /// In en, this message translates to:
  /// **'The computer would not take this link.'**
  String get pcErrRefused;

  /// No description provided for @pcErrUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'The computer no longer knows this phone. Pair again.'**
  String get pcErrUnauthorized;

  /// No description provided for @pcErrUnreachable.
  ///
  /// In en, this message translates to:
  /// **'The computer did not answer. Is it on, on this network or on your Tailscale, with \"Receive from the phone\" turned on?'**
  String get pcErrUnreachable;

  /// No description provided for @pcErrWrongCertificate.
  ///
  /// In en, this message translates to:
  /// **'Something other than your computer answered at this address. Nothing was sent.'**
  String get pcErrWrongCertificate;

  /// No description provided for @pcErrWrongCode.
  ///
  /// In en, this message translates to:
  /// **'Wrong code.'**
  String get pcErrWrongCode;

  /// No description provided for @pcFindNone.
  ///
  /// In en, this message translates to:
  /// **'No computer found. On the computer, open Settings › Phone › Pair a phone first, on the same Wi-Fi.'**
  String get pcFindNone;

  /// No description provided for @pcFindOnNetwork.
  ///
  /// In en, this message translates to:
  /// **'Find on the network'**
  String get pcFindOnNetwork;

  /// No description provided for @pcFirewallAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get pcFirewallAllow;

  /// No description provided for @pcFirewallBlocked.
  ///
  /// In en, this message translates to:
  /// **'Windows Firewall blocks VidHoist, so the phone cannot reach it. Allow it on home (private) networks.'**
  String get pcFirewallBlocked;

  /// No description provided for @pcFirewallMissing.
  ///
  /// In en, this message translates to:
  /// **'Windows has not let VidHoist receive from the phone yet. Allow it once, on home (private) networks only.'**
  String get pcFirewallMissing;

  /// No description provided for @pcFirewallPublic.
  ///
  /// In en, this message translates to:
  /// **'Windows calls this network Public, and lets nothing in there. If it is your home network, make it Private: Settings › Network & internet › Wi-Fi › its properties.'**
  String get pcFirewallPublic;

  /// No description provided for @pcFirewallRefused.
  ///
  /// In en, this message translates to:
  /// **'Nothing changed: Windows needs an administrator\'s permission.'**
  String get pcFirewallRefused;

  /// No description provided for @pcFirewallTitle.
  ///
  /// In en, this message translates to:
  /// **'Windows Firewall'**
  String get pcFirewallTitle;

  /// No description provided for @pcFound.
  ///
  /// In en, this message translates to:
  /// **'Found {name}. Type the code it shows.'**
  String pcFound(String name);

  /// No description provided for @pcFoundCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 found} other{{count} found}}'**
  String pcFoundCount(int count);

  /// No description provided for @pcLastContact.
  ///
  /// In en, this message translates to:
  /// **'Last contact {time}'**
  String pcLastContact(String time);

  /// No description provided for @pcLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library on the computer'**
  String get pcLibrary;

  /// No description provided for @pcLinkAddress.
  ///
  /// In en, this message translates to:
  /// **'Address on this network'**
  String get pcLinkAddress;

  /// No description provided for @pcLinkAddressTailscale.
  ///
  /// In en, this message translates to:
  /// **'Through Tailscale, from outside home'**
  String get pcLinkAddressTailscale;

  /// No description provided for @pcLinkAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get pcLinkAllow;

  /// No description provided for @pcLinkAllowDelete.
  ///
  /// In en, this message translates to:
  /// **'Let the phone delete clips'**
  String get pcLinkAllowDelete;

  /// No description provided for @pcLinkAllowDeleteHint.
  ///
  /// In en, this message translates to:
  /// **'A clip deleted from the phone goes to this computer\'s Recycle Bin, where you can get it back. On a drive with no Recycle Bin it is not deleted.'**
  String get pcLinkAllowDeleteHint;

  /// No description provided for @pcLinkCodeHint.
  ///
  /// In en, this message translates to:
  /// **'On the phone: Settings › Computer › Scan the QR code. Or type this address and code there. It works once, for two minutes.'**
  String get pcLinkCodeHint;

  /// No description provided for @pcLinkCodeLeft.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s left'**
  String pcLinkCodeLeft(int seconds);

  /// No description provided for @pcLinkCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Pairing code'**
  String get pcLinkCodeTitle;

  /// No description provided for @pcLinkDeny.
  ///
  /// In en, this message translates to:
  /// **'Refuse'**
  String get pcLinkDeny;

  /// No description provided for @pcLinkDevices.
  ///
  /// In en, this message translates to:
  /// **'Paired phones'**
  String get pcLinkDevices;

  /// No description provided for @pcLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not start: {error}'**
  String pcLinkFailed(String error);

  /// No description provided for @pcLinkIntro.
  ///
  /// In en, this message translates to:
  /// **'Send links from VidHoist on your phone to this computer, and see its downloads and library there. Works inside your home network, and from outside it through Tailscale.'**
  String get pcLinkIntro;

  /// No description provided for @pcLinkLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last heard from {time}'**
  String pcLinkLastSeen(String time);

  /// No description provided for @pcLinkNoDevices.
  ///
  /// In en, this message translates to:
  /// **'No phone yet.'**
  String get pcLinkNoDevices;

  /// No description provided for @pcLinkOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get pcLinkOff;

  /// No description provided for @pcLinkOtherAddresses.
  ///
  /// In en, this message translates to:
  /// **'Other addresses ({count})'**
  String pcLinkOtherAddresses(int count);

  /// No description provided for @pcLinkOtherAddressesHint.
  ///
  /// In en, this message translates to:
  /// **'Network adapters other programs add, such as VirtualBox or WSL. The phone rarely needs them.'**
  String get pcLinkOtherAddressesHint;

  /// No description provided for @pcLinkPairPhone.
  ///
  /// In en, this message translates to:
  /// **'Pair a phone'**
  String get pcLinkPairPhone;

  /// No description provided for @pcLinkPairedAt.
  ///
  /// In en, this message translates to:
  /// **'Paired {time}'**
  String pcLinkPairedAt(String time);

  /// No description provided for @pcLinkPhones.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No phone} =1{One phone} other{{count} phones}}'**
  String pcLinkPhones(int count);

  /// No description provided for @pcLinkQrHint.
  ///
  /// In en, this message translates to:
  /// **'Scan from the phone'**
  String get pcLinkQrHint;

  /// No description provided for @pcLinkReceive.
  ///
  /// In en, this message translates to:
  /// **'Receive from the phone'**
  String get pcLinkReceive;

  /// No description provided for @pcLinkReceiveHint.
  ///
  /// In en, this message translates to:
  /// **'While it is off, no port is open on this computer. If Windows asks, allow private networks only.'**
  String get pcLinkReceiveHint;

  /// No description provided for @pcLinkRequest.
  ///
  /// In en, this message translates to:
  /// **'{name} asks to pair'**
  String pcLinkRequest(String name);

  /// No description provided for @pcLinkRequestHint.
  ///
  /// In en, this message translates to:
  /// **'Allow only if the phone shows the same four digits.'**
  String get pcLinkRequestHint;

  /// No description provided for @pcLinkRevoke.
  ///
  /// In en, this message translates to:
  /// **'Unpair'**
  String get pcLinkRevoke;

  /// No description provided for @pcLinkSecurity.
  ///
  /// In en, this message translates to:
  /// **'The phone talks to this computer directly, on your network or over your Tailscale. It pairs once, with the code and your approval here; after that it presents its own key with every request, over a connection encrypted with this computer\'s certificate alone. Anyone else on the network finds a closed door.'**
  String get pcLinkSecurity;

  /// No description provided for @pcLinkStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting…'**
  String get pcLinkStarting;

  /// No description provided for @pcLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get pcLinkTitle;

  /// No description provided for @pcListEmpty.
  ///
  /// In en, this message translates to:
  /// **'None of this list\'s clips is on the computer any more.'**
  String get pcListEmpty;

  /// No description provided for @pcListen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get pcListen;

  /// No description provided for @pcLists.
  ///
  /// In en, this message translates to:
  /// **'Lists on the computer'**
  String get pcLists;

  /// No description provided for @pcListsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No list on the computer has clips in it.'**
  String get pcListsEmpty;

  /// No description provided for @pcNow.
  ///
  /// In en, this message translates to:
  /// **'On the computer now'**
  String get pcNow;

  /// No description provided for @pcOffline.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get pcOffline;

  /// No description provided for @pcOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'The computer is off or on another network. What it had last time is shown below.'**
  String get pcOfflineMessage;

  /// No description provided for @pcOfflineRoute.
  ///
  /// In en, this message translates to:
  /// **'Away from home? Choose Tailscale in Settings › Computer.'**
  String get pcOfflineRoute;

  /// No description provided for @pcOnPhone.
  ///
  /// In en, this message translates to:
  /// **'On the phone'**
  String get pcOnPhone;

  /// No description provided for @pcOrType.
  ///
  /// In en, this message translates to:
  /// **'Or type the address and code'**
  String get pcOrType;

  /// No description provided for @pcOutboxRefused.
  ///
  /// In en, this message translates to:
  /// **'The computer would not take this link'**
  String get pcOutboxRefused;

  /// No description provided for @pcOutboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting to send ({count})'**
  String pcOutboxTitle(int count);

  /// No description provided for @pcPairButton.
  ///
  /// In en, this message translates to:
  /// **'Pair'**
  String get pcPairButton;

  /// No description provided for @pcPairCheck.
  ///
  /// In en, this message translates to:
  /// **'Check that the computer shows {check}, then allow the phone there.'**
  String pcPairCheck(String check);

  /// No description provided for @pcPairIntro.
  ///
  /// In en, this message translates to:
  /// **'If VidHoist runs on your Windows computer, this phone can send it links and show its downloads and library. On the computer, turn on Settings › Phone and press Pair a phone, then scan the QR code it shows.'**
  String get pcPairIntro;

  /// No description provided for @pcPaired.
  ///
  /// In en, this message translates to:
  /// **'Paired with {name}'**
  String pcPaired(String name);

  /// No description provided for @pcPortLabel.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get pcPortLabel;

  /// No description provided for @pcQueued.
  ///
  /// In en, this message translates to:
  /// **'It goes to {name} when it is back.'**
  String pcQueued(String name);

  /// No description provided for @pcQueuedMany.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 clip goes to {name} when it is back.} other{{count} clips go to {name} when it is back.}}'**
  String pcQueuedMany(int count, String name);

  /// No description provided for @pcRouteHint.
  ///
  /// In en, this message translates to:
  /// **'Choose Tailscale when you are away from home; it must be running on both the phone and the computer.'**
  String get pcRouteHint;

  /// No description provided for @pcRouteHome.
  ///
  /// In en, this message translates to:
  /// **'Home network'**
  String get pcRouteHome;

  /// No description provided for @pcRouteOther.
  ///
  /// In en, this message translates to:
  /// **'Another network'**
  String get pcRouteOther;

  /// No description provided for @pcRouteTailscale.
  ///
  /// In en, this message translates to:
  /// **'Tailscale'**
  String get pcRouteTailscale;

  /// No description provided for @pcRouteTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect through'**
  String get pcRouteTitle;

  /// No description provided for @pcRouteWaiting.
  ///
  /// In en, this message translates to:
  /// **'The computer\'s other routes show here once it answers.'**
  String get pcRouteWaiting;

  /// No description provided for @pcScanButton.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code'**
  String get pcScanButton;

  /// No description provided for @pcScanFailed.
  ///
  /// In en, this message translates to:
  /// **'The camera could not be opened.'**
  String get pcScanFailed;

  /// No description provided for @pcScanPrompt.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the QR code on the computer\'s screen'**
  String get pcScanPrompt;

  /// No description provided for @pcSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search the computer\'s library'**
  String get pcSearchHint;

  /// No description provided for @pcSendToPc.
  ///
  /// In en, this message translates to:
  /// **'Send to the computer'**
  String get pcSendToPc;

  /// No description provided for @pcSent.
  ///
  /// In en, this message translates to:
  /// **'Sent to {name}'**
  String pcSent(String name);

  /// No description provided for @pcSentMany.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 clip sent to {name}} other{{count} clips sent to {name}}}'**
  String pcSentMany(int count, String name);

  /// No description provided for @pcSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Send links to your computer'**
  String get pcSettingsHint;

  /// No description provided for @pcTab.
  ///
  /// In en, this message translates to:
  /// **'Computer'**
  String get pcTab;

  /// No description provided for @pcVia.
  ///
  /// In en, this message translates to:
  /// **'Through {route}'**
  String pcVia(String route);

  /// No description provided for @pcWatch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get pcWatch;

  /// No description provided for @pcWillSend.
  ///
  /// In en, this message translates to:
  /// **'Away: sent when it is back'**
  String get pcWillSend;

  /// No description provided for @pickAnotherFile.
  ///
  /// In en, this message translates to:
  /// **'From another file…'**
  String get pickAnotherFile;

  /// No description provided for @pickAnotherFileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A backup from another phone or an older version'**
  String get pickAnotherFileSubtitle;

  /// No description provided for @pictureInPicture.
  ///
  /// In en, this message translates to:
  /// **'Picture in picture'**
  String get pictureInPicture;

  /// No description provided for @pictureInPictureHelp.
  ///
  /// In en, this message translates to:
  /// **'When you leave the app while a clip plays, it stays in a corner of the screen'**
  String get pictureInPictureHelp;

  /// No description provided for @pinPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Pin to top'**
  String get pinPlaylist;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Site'**
  String get platform;

  /// No description provided for @platformCount.
  ///
  /// In en, this message translates to:
  /// **'{name} · {count}'**
  String platformCount(Object name, int count);

  /// No description provided for @platformOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get platformOther;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @playAll.
  ///
  /// In en, this message translates to:
  /// **'Play all'**
  String get playAll;

  /// No description provided for @playModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get playModeLabel;

  /// No description provided for @playbackSpeed.
  ///
  /// In en, this message translates to:
  /// **'Playback speed'**
  String get playbackSpeed;

  /// No description provided for @playerError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t play this file'**
  String get playerError;

  /// No description provided for @playingFromDevice.
  ///
  /// In en, this message translates to:
  /// **'Playing from your device'**
  String get playingFromDevice;

  /// No description provided for @playlist.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get playlist;

  /// No description provided for @playlistAddClips.
  ///
  /// In en, this message translates to:
  /// **'Add clips'**
  String get playlistAddClips;

  /// No description provided for @playlistAddClipsTo.
  ///
  /// In en, this message translates to:
  /// **'Add to “{name}”'**
  String playlistAddClipsTo(String name);

  /// No description provided for @playlistAddCount.
  ///
  /// In en, this message translates to:
  /// **'Add ({count})'**
  String playlistAddCount(int count);

  /// No description provided for @playlistCreated.
  ///
  /// In en, this message translates to:
  /// **'Playlist created'**
  String get playlistCreated;

  /// No description provided for @playlistDeleted.
  ///
  /// In en, this message translates to:
  /// **'Playlist deleted'**
  String get playlistDeleted;

  /// No description provided for @playlistDetails.
  ///
  /// In en, this message translates to:
  /// **'Playlist details'**
  String get playlistDetails;

  /// No description provided for @playlistEditHint.
  ///
  /// In en, this message translates to:
  /// **'Long-press a clip to move it. Swipe it aside to remove it.'**
  String get playlistEditHint;

  /// No description provided for @playlistName.
  ///
  /// In en, this message translates to:
  /// **'Playlist name'**
  String get playlistName;

  /// No description provided for @playlistNameHint.
  ///
  /// In en, this message translates to:
  /// **'My playlist'**
  String get playlistNameHint;

  /// No description provided for @playlistOf.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total}'**
  String playlistOf(int current, int total);

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get quality;

  /// No description provided for @quality1080.
  ///
  /// In en, this message translates to:
  /// **'Up to 1080p'**
  String get quality1080;

  /// No description provided for @quality360.
  ///
  /// In en, this message translates to:
  /// **'Up to 360p'**
  String get quality360;

  /// No description provided for @quality480.
  ///
  /// In en, this message translates to:
  /// **'Up to 480p'**
  String get quality480;

  /// No description provided for @quality720.
  ///
  /// In en, this message translates to:
  /// **'Up to 720p'**
  String get quality720;

  /// No description provided for @qualityAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get qualityAudio;

  /// No description provided for @qualityBest.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get qualityBest;

  /// No description provided for @qualityHelper.
  ///
  /// In en, this message translates to:
  /// **'Used by quick download, by whole-playlist downloads, and by \"Download\" in the clipboard bar, and it is the preselected option in the add-link sheet. So it matters whether or not quick download is on.'**
  String get qualityHelper;

  /// No description provided for @qualityReading.
  ///
  /// In en, this message translates to:
  /// **'Reading the file…'**
  String get qualityReading;

  /// No description provided for @qualityUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get qualityUnavailable;

  /// No description provided for @qualityVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get qualityVideo;

  /// No description provided for @queueItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String queueItemsCount(int count);

  /// No description provided for @queueLabel.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queueLabel;

  /// No description provided for @queuePosition.
  ///
  /// In en, this message translates to:
  /// **'Number {position} in line'**
  String queuePosition(int position);

  /// No description provided for @queued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get queued;

  /// No description provided for @queuedSection.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get queuedSection;

  /// No description provided for @quickDownload.
  ///
  /// In en, this message translates to:
  /// **'Quick download'**
  String get quickDownload;

  /// No description provided for @quickDownloadHelp.
  ///
  /// In en, this message translates to:
  /// **'A shared or pasted link starts downloading at once at the default quality, with no sheet. A site that lacks that quality gives its best, and \"Audio only\" works on every site.'**
  String get quickDownloadHelp;

  /// No description provided for @rateLimit.
  ///
  /// In en, this message translates to:
  /// **'Speed limit'**
  String get rateLimit;

  /// No description provided for @rateLimitNone.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get rateLimitNone;

  /// No description provided for @rateLimitValue.
  ///
  /// In en, this message translates to:
  /// **'{mb} MB/s'**
  String rateLimitValue(int mb);

  /// No description provided for @reelsEndBack.
  ///
  /// In en, this message translates to:
  /// **'Back to library'**
  String get reelsEndBack;

  /// No description provided for @reelsEndContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue the rest of the list'**
  String get reelsEndContinue;

  /// No description provided for @reelsEndReplay.
  ///
  /// In en, this message translates to:
  /// **'Replay from the start'**
  String get reelsEndReplay;

  /// No description provided for @reelsEndTitle.
  ///
  /// In en, this message translates to:
  /// **'End of the shorts lane'**
  String get reelsEndTitle;

  /// No description provided for @reelsSwipeHint.
  ///
  /// In en, this message translates to:
  /// **'Swipe up for the next short'**
  String get reelsSwipeHint;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @removeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Remove {count} unavailable'**
  String removeUnavailable(int count);

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @removedFromPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Removed from the playlist'**
  String get removedFromPlaylist;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @renameTag.
  ///
  /// In en, this message translates to:
  /// **'Rename tag'**
  String get renameTag;

  /// No description provided for @reportBug.
  ///
  /// In en, this message translates to:
  /// **'Report a bug'**
  String get reportBug;

  /// No description provided for @restoreConfirm.
  ///
  /// In en, this message translates to:
  /// **'Restore data from the backup file? This overwrites current playlists, tags and settings.'**
  String get restoreConfirm;

  /// No description provided for @restoreData.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreData;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed: the backup file is not valid'**
  String get restoreFailed;

  /// No description provided for @restorePickBody.
  ///
  /// In en, this message translates to:
  /// **'This phone has VidHoist downloads but no settings, as after a reinstall. If you kept a backup, choose it: the app writes them to Download/VidHoist/backups.'**
  String get restorePickBody;

  /// No description provided for @restorePickChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a backup'**
  String get restorePickChoose;

  /// No description provided for @restorePickTitle.
  ///
  /// In en, this message translates to:
  /// **'Bring back your settings?'**
  String get restorePickTitle;

  /// No description provided for @restoreSettings.
  ///
  /// In en, this message translates to:
  /// **'Restore all data'**
  String get restoreSettings;

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data restored successfully'**
  String get restoreSuccess;

  /// No description provided for @resumeSubscription.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeSubscription;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save settings'**
  String get saveSettings;

  /// No description provided for @searchLogs.
  ///
  /// In en, this message translates to:
  /// **'Search logs…'**
  String get searchLogs;

  /// No description provided for @searchVideos.
  ///
  /// In en, this message translates to:
  /// **'Search clips…'**
  String get searchVideos;

  /// No description provided for @seekBackward10.
  ///
  /// In en, this message translates to:
  /// **'Back 10 seconds'**
  String get seekBackward10;

  /// No description provided for @seekForward10.
  ///
  /// In en, this message translates to:
  /// **'Forward 10 seconds'**
  String get seekForward10;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selected(int count);

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get settingsAccounts;

  /// No description provided for @settingsBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settingsBackup;

  /// No description provided for @settingsDownloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get settingsDownloads;

  /// No description provided for @settingsGroupApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get settingsGroupApp;

  /// No description provided for @settingsGroupData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsGroupData;

  /// No description provided for @settingsPlayback.
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get settingsPlayback;

  /// No description provided for @settingsTranscripts.
  ///
  /// In en, this message translates to:
  /// **'Transcripts & subtitles'**
  String get settingsTranscripts;

  /// No description provided for @settingsValueChannels.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No channels yet} =1{1 channel} other{{count} channels}}'**
  String settingsValueChannels(int count);

  /// No description provided for @settingsValueCompatOff.
  ///
  /// In en, this message translates to:
  /// **'Best compatibility: off'**
  String get settingsValueCompatOff;

  /// No description provided for @settingsValueCompatOn.
  ///
  /// In en, this message translates to:
  /// **'Best compatibility: on'**
  String get settingsValueCompatOn;

  /// No description provided for @settingsValueNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set up yet'**
  String get settingsValueNotSet;

  /// No description provided for @settingsValueQuick.
  ///
  /// In en, this message translates to:
  /// **'quick'**
  String get settingsValueQuick;

  /// No description provided for @settingsValueSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in: {sites}'**
  String settingsValueSignedIn(String sites);

  /// No description provided for @settingsValueWifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Wi‑Fi only'**
  String get settingsValueWifiOnly;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareLogs.
  ///
  /// In en, this message translates to:
  /// **'Share logs'**
  String get shareLogs;

  /// No description provided for @shareOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening the share menu…'**
  String get shareOpening;

  /// No description provided for @shareOpeningHint.
  ///
  /// In en, this message translates to:
  /// **'A large file takes a few seconds to hand over.'**
  String get shareOpeningHint;

  /// No description provided for @shareSelected.
  ///
  /// In en, this message translates to:
  /// **'Share selected'**
  String get shareSelected;

  /// No description provided for @sharedLinksAdd.
  ///
  /// In en, this message translates to:
  /// **'Add them'**
  String get sharedLinksAdd;

  /// No description provided for @sharedLinksBody.
  ///
  /// In en, this message translates to:
  /// **'Each one downloads to this phone.'**
  String get sharedLinksBody;

  /// No description provided for @sharedLinksCapped.
  ///
  /// In en, this message translates to:
  /// **'Only the first {max} links were added.'**
  String sharedLinksCapped(int max);

  /// No description provided for @sharedLinksTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Add 1 link?} other{Add {count} links?}}'**
  String sharedLinksTitle(int count);

  /// No description provided for @shortsFilter.
  ///
  /// In en, this message translates to:
  /// **'Shorts'**
  String get shortsFilter;

  /// No description provided for @shuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get shuffle;

  /// No description provided for @signInRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign-in required'**
  String get signInRequired;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @smartPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Smart playlists'**
  String get smartPlaylists;

  /// No description provided for @sortAndPlatform.
  ///
  /// In en, this message translates to:
  /// **'Sort and site'**
  String get sortAndPlatform;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortLargest.
  ///
  /// In en, this message translates to:
  /// **'Largest'**
  String get sortLargest;

  /// No description provided for @sortNameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name A–Z'**
  String get sortNameAZ;

  /// No description provided for @sortNameZA.
  ///
  /// In en, this message translates to:
  /// **'Name Z–A'**
  String get sortNameZA;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get sortOldest;

  /// No description provided for @sortSmallest.
  ///
  /// In en, this message translates to:
  /// **'Smallest'**
  String get sortSmallest;

  /// No description provided for @sortedByLastPlayed.
  ///
  /// In en, this message translates to:
  /// **'By last played'**
  String get sortedByLastPlayed;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @sourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get sourceCode;

  /// No description provided for @startDownload.
  ///
  /// In en, this message translates to:
  /// **'Start download'**
  String get startDownload;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @storageCardMissing.
  ///
  /// In en, this message translates to:
  /// **'The card is not in, so downloads go to the phone'**
  String get storageCardMissing;

  /// No description provided for @storageLocation.
  ///
  /// In en, this message translates to:
  /// **'Save to'**
  String get storageLocation;

  /// No description provided for @storageLocationHelp.
  ///
  /// In en, this message translates to:
  /// **'Clips already downloaded stay where they are and still show in the library. A memory card needs Android 11 or later.'**
  String get storageLocationHelp;

  /// No description provided for @storageNoCard.
  ///
  /// In en, this message translates to:
  /// **'No memory card in this phone'**
  String get storageNoCard;

  /// No description provided for @storagePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone storage'**
  String get storagePhone;

  /// No description provided for @streamingOnline.
  ///
  /// In en, this message translates to:
  /// **'Playing over the network'**
  String get streamingOnline;

  /// No description provided for @subscriptionAdded.
  ///
  /// In en, this message translates to:
  /// **'Now following {name}'**
  String subscriptionAdded(String name);

  /// No description provided for @subscriptionName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get subscriptionName;

  /// No description provided for @subscriptionPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get subscriptionPaused;

  /// No description provided for @subscriptionQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality for this channel'**
  String get subscriptionQuality;

  /// No description provided for @subscriptionQualityHelp.
  ///
  /// In en, this message translates to:
  /// **'The quality new videos from this channel download at. You can change it later by editing the channel; videos already downloaded keep theirs.\n\n\"Best\" can mean 4K in the AV1 format, which an older computer may play with stutters: choose 1080p if it does.'**
  String get subscriptionQualityHelp;

  /// No description provided for @subscriptionQualityNote.
  ///
  /// In en, this message translates to:
  /// **'Applies to new videos; those already downloaded keep theirs.'**
  String get subscriptionQualityNote;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get subscriptions;

  /// No description provided for @subscriptionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No channels followed yet'**
  String get subscriptionsEmpty;

  /// No description provided for @subscriptionsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Follow a channel and each new video downloads into your library by itself, while VidHoist is open or in the tray. What is already on the channel is not downloaded.'**
  String get subscriptionsEmptyBody;

  /// No description provided for @subscriptionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New videos from channels you follow, downloaded by themselves'**
  String get subscriptionsSubtitle;

  /// No description provided for @subtitleLangs.
  ///
  /// In en, this message translates to:
  /// **'Subtitle languages'**
  String get subtitleLangs;

  /// No description provided for @subtitleLangsHelp.
  ///
  /// In en, this message translates to:
  /// **'Fetched when the video has them. One at least stays chosen.'**
  String get subtitleLangsHelp;

  /// No description provided for @subtitles.
  ///
  /// In en, this message translates to:
  /// **'Subtitles'**
  String get subtitles;

  /// No description provided for @subtitlesBackground.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get subtitlesBackground;

  /// No description provided for @subtitlesBackgroundFaint.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get subtitlesBackgroundFaint;

  /// No description provided for @subtitlesBackgroundHelp.
  ///
  /// In en, this message translates to:
  /// **'What sits behind the words. With none, each letter keeps a dark edge so it still reads over a bright picture.'**
  String get subtitlesBackgroundHelp;

  /// No description provided for @subtitlesBackgroundNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get subtitlesBackgroundNone;

  /// No description provided for @subtitlesBackgroundSolid.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get subtitlesBackgroundSolid;

  /// No description provided for @subtitlesHide.
  ///
  /// In en, this message translates to:
  /// **'Hide subtitles'**
  String get subtitlesHide;

  /// No description provided for @subtitlesLanguage.
  ///
  /// In en, this message translates to:
  /// **'Subtitle language'**
  String get subtitlesLanguage;

  /// No description provided for @subtitlesShow.
  ///
  /// In en, this message translates to:
  /// **'Show subtitles'**
  String get subtitlesShow;

  /// No description provided for @subtitlesShowHelp.
  ///
  /// In en, this message translates to:
  /// **'Over the video, for clips that have a transcript. The CC button in the player does the same.'**
  String get subtitlesShowHelp;

  /// No description provided for @subtitlesSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get subtitlesSize;

  /// No description provided for @subtitlesSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get subtitlesSizeLarge;

  /// No description provided for @subtitlesSizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get subtitlesSizeMedium;

  /// No description provided for @subtitlesSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get subtitlesSizeSmall;

  /// No description provided for @tagLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You can have up to {max} tags. Remove one in Manage tags to add another.'**
  String tagLimitReached(int max);

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @tagsOpenFiltered.
  ///
  /// In en, this message translates to:
  /// **'Opens the library filtered'**
  String get tagsOpenFiltered;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @titleFilter.
  ///
  /// In en, this message translates to:
  /// **'Only download titles containing'**
  String get titleFilter;

  /// No description provided for @titleFilterHelp.
  ///
  /// In en, this message translates to:
  /// **'A new video from this channel is downloaded only if its title contains what you write here.\n\n• A plain word is enough: Episode\n• Any of several words: Episode|Part (the | means \"or\")\n• Capitals don\'t matter: episode matches Episode too.\n\nA video the filter skips counts as seen for good: removing the filter later downloads what comes after, not what was skipped.'**
  String get titleFilterHelp;

  /// No description provided for @titleFilterHelper.
  ///
  /// In en, this message translates to:
  /// **'Several words: separate them with | . Leave empty for everything.'**
  String get titleFilterHelper;

  /// No description provided for @titleFilterHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Episode'**
  String get titleFilterHint;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @totalDuration.
  ///
  /// In en, this message translates to:
  /// **'Total: {duration}'**
  String totalDuration(Object duration);

  /// No description provided for @transcript.
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get transcript;

  /// No description provided for @transcriptSaidMore.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Said once more} other{Said {count} more times}}'**
  String transcriptSaidMore(int count);

  /// No description provided for @transcriptsClips.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No clips yet} =1{1 clip} other{{count} clips}}'**
  String transcriptsClips(int count);

  /// No description provided for @transcriptsDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get transcriptsDeleteAll;

  /// No description provided for @transcriptsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete every transcript?'**
  String get transcriptsDeleteTitle;

  /// No description provided for @transcriptsSaidInside.
  ///
  /// In en, this message translates to:
  /// **'Said inside clips'**
  String get transcriptsSaidInside;

  /// No description provided for @transcriptsSearchHelp.
  ///
  /// In en, this message translates to:
  /// **'Keeps the words of every YouTube clip you add, so you can search what was said.'**
  String get transcriptsSearchHelp;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @unfollow.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollow;

  /// No description provided for @unfollowConfirm.
  ///
  /// In en, this message translates to:
  /// **'Unfollow {name}?'**
  String unfollowConfirm(String name);

  /// No description provided for @unfollowConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'VidHoist forgets which videos it has already seen on this channel. If you follow it again later, everything on it by then counts as seen, and what you missed is not filled in. Pausing keeps that memory.'**
  String get unfollowConfirmBody;

  /// No description provided for @unlockTouch.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlockTouch;

  /// No description provided for @unpinPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get unpinPlaylist;

  /// No description provided for @updateNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'Open VidHoist to install it.'**
  String get updateNoticeBody;

  /// No description provided for @upNext.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get upNext;

  /// No description provided for @upNextIn.
  ///
  /// In en, this message translates to:
  /// **'Up next in «{name}»'**
  String upNextIn(String name);

  /// No description provided for @updateAllowInstallBody.
  ///
  /// In en, this message translates to:
  /// **'Android needs your permission before the app can install its own updates. Grant it once in system settings, then tap Install again.'**
  String get updateAllowInstallBody;

  /// No description provided for @updateAllowInstallTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow installing updates'**
  String get updateAllowInstallTitle;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailable;

  /// No description provided for @updateCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t check for updates'**
  String get updateCheckFailed;

  /// No description provided for @updateChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get updateChecking;

  /// No description provided for @updateDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t download the update'**
  String get updateDownloadFailed;

  /// No description provided for @updateDownloadedMb.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} MB'**
  String updateDownloadedMb(String done, String total);

  /// No description provided for @updateDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading update…'**
  String get updateDownloading;

  /// No description provided for @updateFailedToStart.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the installer'**
  String get updateFailedToStart;

  /// No description provided for @updateInstall.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get updateInstall;

  /// No description provided for @updateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// No description provided for @updateNever.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get updateNever;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Download update'**
  String get updateNow;

  /// No description provided for @updateOpenSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get updateOpenSystemSettings;

  /// No description provided for @updateReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to install'**
  String get updateReady;

  /// No description provided for @updateSizeMb.
  ///
  /// In en, this message translates to:
  /// **'{size} MB'**
  String updateSizeMb(String size);

  /// No description provided for @updateSkipVersion.
  ///
  /// In en, this message translates to:
  /// **'Skip this version'**
  String get updateSkipVersion;

  /// No description provided for @updateUpToDate.
  ///
  /// In en, this message translates to:
  /// **'You\'re on the latest version'**
  String get updateUpToDate;

  /// No description provided for @updateVersionAvailable.
  ///
  /// In en, this message translates to:
  /// **'Version {version} is available'**
  String updateVersionAvailable(String version);

  /// No description provided for @updateVersionTitle.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String updateVersionTitle(String version);

  /// No description provided for @updateWhatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get updateWhatsNew;

  /// No description provided for @updates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updates;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @videoAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to playlist'**
  String get videoAdded;

  /// No description provided for @videoPlayer.
  ///
  /// In en, this message translates to:
  /// **'Video player'**
  String get videoPlayer;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @viewAllInPlaylists.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAllInPlaylists;

  /// No description provided for @viewCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get viewCards;

  /// No description provided for @viewGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get viewGrid;

  /// No description provided for @viewList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get viewList;

  /// No description provided for @viewMode.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewMode;

  /// No description provided for @waitingForWifi.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Wi-Fi'**
  String get waitingForWifi;

  /// No description provided for @whatsNewGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get whatsNewGotIt;

  /// No description provided for @whatsNewReleasePage.
  ///
  /// In en, this message translates to:
  /// **'Release page'**
  String get whatsNewReleasePage;

  /// No description provided for @whatsNewThisVersion.
  ///
  /// In en, this message translates to:
  /// **'What\'s new in this version'**
  String get whatsNewThisVersion;

  /// No description provided for @whatsNewTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s new in {version}'**
  String whatsNewTitle(String version);

  /// No description provided for @whatsNewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'What changed in this version is on the release page.'**
  String get whatsNewUnavailable;

  /// No description provided for @wifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Download over Wi-Fi only'**
  String get wifiOnly;

  /// No description provided for @wifiOnlyHelp.
  ///
  /// In en, this message translates to:
  /// **'Nothing downloads over mobile data. Downloads wait for Wi-Fi, and one under way when Wi-Fi drops is paused and goes on by itself when it returns.'**
  String get wifiOnlyHelp;

  /// No description provided for @yourPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Your playlists'**
  String get yourPlaylists;

  /// No description provided for @yourTags.
  ///
  /// In en, this message translates to:
  /// **'Your tags'**
  String get yourTags;

  /// No description provided for @ytdlpCredit.
  ///
  /// In en, this message translates to:
  /// **'The downloader VidHoist runs'**
  String get ytdlpCredit;
}

class _VhLocalizationsDelegate extends LocalizationsDelegate<VhLocalizations> {
  const _VhLocalizationsDelegate();

  @override
  Future<VhLocalizations> load(Locale locale) {
    return SynchronousFuture<VhLocalizations>(lookupVhLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fa',
    'fr',
    'hi',
    'id',
    'pt',
    'ru',
    'tr',
    'ur',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_VhLocalizationsDelegate old) => false;
}

VhLocalizations lookupVhLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return VhLocalizationsAr();
    case 'de':
      return VhLocalizationsDe();
    case 'en':
      return VhLocalizationsEn();
    case 'es':
      return VhLocalizationsEs();
    case 'fa':
      return VhLocalizationsFa();
    case 'fr':
      return VhLocalizationsFr();
    case 'hi':
      return VhLocalizationsHi();
    case 'id':
      return VhLocalizationsId();
    case 'pt':
      return VhLocalizationsPt();
    case 'ru':
      return VhLocalizationsRu();
    case 'tr':
      return VhLocalizationsTr();
    case 'ur':
      return VhLocalizationsUr();
  }

  throw FlutterError(
    'VhLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
