// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'vh_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class VhLocalizationsHi extends VhLocalizations {
  VhLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get about => 'परिचय';

  @override
  String get aboutApp => 'ऐप के बारे में';

  @override
  String get aboutDescriptionPhone =>
      'एक हल्का और तेज़ ऐप जो yt-dlp से कई साइटों के वीडियो और ऑडियो डाउनलोड करता है। इसमें अपना प्लेयर और प्लेलिस्ट हैं।';

  @override
  String get accountSignIn => 'साइन इन करें';

  @override
  String get accountSignOut => 'साइन आउट करें';

  @override
  String get accountSignedIn => 'साइन इन है';

  @override
  String get accountSignedOut => 'साइन इन नहीं है';

  @override
  String accountSignedOutOf(String site) {
    return '$site से साइन आउट हो गया';
  }

  @override
  String get accountsBanRisk =>
      'बेहतर है कि दूसरा अकाउंट इस्तेमाल करें: बहुत ज़्यादा डाउनलोड करने पर साइट कुछ समय के लिए अकाउंट पर रोक लगा सकती है।';

  @override
  String get accountsClearAll => 'सभी कुकीज़ मिटाएँ';

  @override
  String get accountsCleared => 'कुकीज़ मिटा दी गईं';

  @override
  String get accountsFileHint =>
      'ब्राउज़र से cookies.txt फ़ाइल (Netscape फ़ॉर्मैट) के रूप में एक्सपोर्ट की गई, किसी भी साइट के लिए, ऊपर न दी गई साइटों के लिए भी। यह यहाँ पहले से मौजूद साइन-इन में जुड़ जाती है, और इसी फ़ोन पर रहती है।';

  @override
  String get accountsFilePick => 'कुकीज़ फ़ाइल चुनें';

  @override
  String get accountsFileTitle => 'या कुकीज़ फ़ाइल इंपोर्ट करें';

  @override
  String get accountsFromFile => 'कुकीज़ फ़ाइल से';

  @override
  String get accountsHelp =>
      'साइन-इन कुछ समय बाद खत्म हो जाता है; जब कोई साइट फिर से मना करने लगे, तो एक बार और साइन इन करें। एक साइट से साइन आउट करने पर ऐप का ब्राउज़र बाकी साइटों से भी साइन आउट हो जाता है, पर उनके डाउनलोड पहले की तरह चलते रहते हैं। अगर कोई साइट यहाँ साइन इन नहीं करने देती, तो नीचे अपने कंप्यूटर के ब्राउज़र से कुकीज़ फ़ाइल इंपोर्ट करें।';

  @override
  String get accountsHint =>
      'उन साइटों के लिए जो लॉगिन के बिना डाउनलोड नहीं करने देतीं। आप ऐप के अंदर साइट के अपने पेज पर साइन इन करते हैं; उसका डेटा इसी फ़ोन पर रहता है, जहाँ yt-dlp हर डाउनलोड के लिए उसे पढ़ता है, और कहीं और नहीं जाता।';

  @override
  String get activeDownloads => 'चालू डाउनलोड';

  @override
  String activeDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count डाउनलोड चल रहे हैं',
      one: '1 डाउनलोड चल रहा है',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloadsSheet => 'चालू डाउनलोड';

  @override
  String get activeNow => 'अभी चालू';

  @override
  String get addLinkFab => 'लिंक जोड़ें';

  @override
  String get addTo => 'इसमें जोड़ें…';

  @override
  String get addToFavorites => 'पसंदीदा में जोड़ें';

  @override
  String get addToPlaylist => 'प्लेलिस्ट में जोड़ें';

  @override
  String get addUrl => 'URL जोड़ें';

  @override
  String addedNToServer(int count) {
    return '$count डाउनलोड में जोड़े गए';
  }

  @override
  String get addedToFavorites => 'पसंदीदा में जोड़ा गया';

  @override
  String addedToPlaylistCount(int count) {
    return '$count प्लेलिस्ट में जोड़े गए';
  }

  @override
  String get allDownloadsFinished => 'सभी डाउनलोड पूरे हुए।';

  @override
  String get allPlatforms => 'सभी साइटें';

  @override
  String get alreadyInPlaylist => 'पहले से जोड़ा हुआ';

  @override
  String get alreadySubscribed => 'यह चैनल पहले से फ़ॉलो किया हुआ है';

  @override
  String get appTitle => 'VidHoist';

  @override
  String get appearanceAndLanguage => 'रूप और भाषा';

  @override
  String audioChannels(int count) {
    return '$count ऑडियो चैनल';
  }

  @override
  String get audioFormat => 'ऑडियो फ़ॉर्मैट';

  @override
  String get audioFormatM4a => 'M4A: हर जगह चलता है';

  @override
  String get audioFormatMp3 => 'MP3: पुराने प्लेयर और कार के लिए';

  @override
  String get audioFormatOriginal => 'जैसा साइट भेजती है, बिना बदले';

  @override
  String get audioMono => 'मोनो';

  @override
  String get audioOnly => 'सिर्फ़ ऑडियो';

  @override
  String get audioStereo => 'स्टीरियो';

  @override
  String get autoBuilt => 'अपने-आप';

  @override
  String get autoCheckUpdates => 'अपने-आप जाँचें';

  @override
  String get autoCheckUpdatesHelp =>
      'बैकग्राउंड में दिन में लगभग दो बार नया वर्शन ढूँढता है।';

  @override
  String get autoRestoreSuccess => 'बैकअप से डेटा रीस्टोर हो गया।';

  @override
  String get autoRetry => 'नेटवर्क लौटने पर फिर कोशिश करें';

  @override
  String get autoRetryHelp =>
      'नेटवर्क टूटने से जो भी विफल हुआ, नेटवर्क लौटते ही अपने-आप फिर से कोशिश की जाती है। जिसे साइट ने मना किया, उसे दोबारा नहीं आज़माया जाता: बिना बदलाव दोहराने पर वह फिर विफल होगा।';

  @override
  String get backgroundChecks => 'ऐप बंद होने पर जाँचें';

  @override
  String get backgroundChecksHelp =>
      'लगभग हर छह घंटे, जब नेटवर्क हो और बैटरी कम न हो। यह केवल नई चीज़ें बताता है; वीडियो तब डाउनलोड होते हैं जब आप VidHoist खोलते हैं।';

  @override
  String get backgroundDownload => 'बैकग्राउंड में फ़ाइलें डाउनलोड हो रही हैं…';

  @override
  String backgroundLastRun(String when) {
    return 'ऐप बंद होने पर पिछली जाँच: $when';
  }

  @override
  String get backgroundNotRunYet =>
      'ऐप बंद होने पर अभी तक कोई जाँच नहीं हुई: समय Android चुनता है।';

  @override
  String get backgroundOfferBody =>
      'VidHoist लगभग हर छह घंटे आपके चैनल देखकर नई चीज़ें बता सकता है। ऐप खोलने तक कुछ भी डाउनलोड नहीं होता।';

  @override
  String get backgroundOfferNo => 'अभी नहीं';

  @override
  String get backgroundOfferTitle =>
      'VidHoist बंद होने पर नए वीडियो की सूचना चाहिए?';

  @override
  String get backgroundOfferYes => 'चालू करें';

  @override
  String get backupNote =>
      'इसमें लाइब्रेरी, प्लेलिस्ट, टैग, फ़ॉलो किए गए चैनल और सेटिंग्स शामिल हैं। साइन-इन और ट्रांसक्रिप्ट अलग रखे जाते हैं, और मीडिया फ़ाइलें शामिल नहीं होतीं।';

  @override
  String get backupSettings => 'सारे डेटा का बैकअप लें';

  @override
  String get backupSettingsSubtitle =>
      'तारीख वाली सात कॉपी जो अपने-आप नई होती रहती हैं। इनमें से कोई भी रीस्टोर करें, या शेयर करने के लिए एक्सपोर्ट करें';

  @override
  String backupSuccess(Object path) {
    return 'बैकअप यहाँ सेव हुआ: $path';
  }

  @override
  String backupsKept(int count) {
    return '$count बैकअप रखे गए';
  }

  @override
  String get batchDownloadSelected => 'चुने हुए डाउनलोड करें';

  @override
  String get batchLoading => 'प्लेलिस्ट पढ़ी जा रही है…';

  @override
  String get batchNothingSelected => 'कम से कम एक आइटम चुनें';

  @override
  String batchSelectedOf(int selected, int total) {
    return '$total में से $selected चुने गए';
  }

  @override
  String get batchThisVideoOnly => 'सिर्फ़ यह क्लिप डाउनलोड करें';

  @override
  String get batchTitle => 'एक साथ डाउनलोड';

  @override
  String get batteryAllow => 'अनुमति दें';

  @override
  String get batteryFree =>
      'बैटरी सेविंग डाउनलोड को नहीं रोकती, ऐप दिखाई न दे तब भी।';

  @override
  String get batteryRestricted =>
      'ऐप दिखाई न देने पर बैटरी सेविंग लंबा डाउनलोड रोक सकती है।';

  @override
  String get batteryStateFree => 'अनुमति है';

  @override
  String get batteryStateLimited => 'सीमित';

  @override
  String get batteryTitle => 'बैकग्राउंड में डाउनलोड';

  @override
  String bitrateKbps(String value) {
    return '$value kb/s';
  }

  @override
  String bitrateMbps(String value) {
    return '$value Mb/s';
  }

  @override
  String get builtWith => 'इनसे बना है';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get changeQuality => 'क्वालिटी बदलें';

  @override
  String get channelNameFolder => 'चैनल के नाम पर';

  @override
  String channelFollowers(String count) {
    return '$count सब्सक्राइबर';
  }

  @override
  String get channelCheckFailed =>
      'इस बार जाँच नहीं हुई। VidHoist अपने-आप फिर कोशिश करेगा।';

  @override
  String get channelUrl => 'किसी चैनल, प्लेलिस्ट या उसके किसी वीडियो का लिंक';

  @override
  String get channelUrlHint => 'https://www.youtube.com/@name';

  @override
  String chapterNumber(int number) {
    return 'चैप्टर $number';
  }

  @override
  String get chaptersFold => 'चैप्टर छिपाएँ';

  @override
  String chaptersFromTranscript(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ट्रांसक्रिप्ट से $count चैप्टर',
      one: 'ट्रांसक्रिप्ट से 1 चैप्टर',
    );
    return '$_temp0';
  }

  @override
  String get chaptersShowAll => 'सभी चैप्टर देखें';

  @override
  String get chaptersUnfold => 'चैप्टर दिखाएँ';

  @override
  String get checkEvery => 'कितनी बार जाँचें';

  @override
  String get checkForUpdates => 'अपडेट जाँचें';

  @override
  String get checkNow => 'अभी जाँचें';

  @override
  String get checkQueued =>
      'अभी जाँच हो रही है। जो भी नया होगा, लाइब्रेरी में दिखेगा।';

  @override
  String get chooseFolder => 'फ़ोल्डर चुनें';

  @override
  String get chooseOptions => 'विकल्प';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get clearLogs => 'लॉग साफ़ करें';

  @override
  String get clearLogsConfirm => 'सभी डायग्नोस्टिक लॉग मिटाएँ?';

  @override
  String get clipEndAfterStart => 'शुरुआत के बाद';

  @override
  String get clipFrom => 'से';

  @override
  String clipLength(Object length) {
    return 'वीडियो $length लंबा है';
  }

  @override
  String get clipLengthReading => 'वीडियो की लंबाई पढ़ी जा रही है…';

  @override
  String get clipLengthUnknown =>
      'साइट वीडियो की लंबाई नहीं बताती, इसलिए समय की जाँच नहीं होती';

  @override
  String get clipMinuteDown => 'एक मिनट पहले';

  @override
  String get clipMinuteUp => 'एक मिनट बाद';

  @override
  String get clipOnly => 'वीडियो का सिर्फ़ एक हिस्सा';

  @override
  String get clipOnlyHelp =>
      'एक समय से दूसरे समय तक, बाकी हिस्से के बिना। इसमें सबटाइटल नहीं आते।';

  @override
  String clipPastEnd(Object length) {
    return 'वीडियो $length पर खत्म होता है';
  }

  @override
  String get clipTimeHint => 'सिर्फ़ अंक: 130 यानी 1:30';

  @override
  String get clipTo => 'तक';

  @override
  String get clipboardFound => 'आपके क्लिपबोर्ड में एक लिंक तैयार है';

  @override
  String get clipboardLinkReady => 'लिंक पेस्ट करें';

  @override
  String get closePlayer => 'प्लेयर बंद करें';

  @override
  String get columnAdded => 'जोड़ा गया';

  @override
  String get columnChannel => 'चैनल';

  @override
  String get columnLength => 'लंबाई';

  @override
  String get compactView => 'कॉम्पैक्ट व्यू';

  @override
  String get compatiblePlayback => 'सबसे अच्छी प्लेबैक कम्पैटिबिलिटी';

  @override
  String get compatiblePlaybackHelp =>
      'H.264/AAC माँगता है, जिसे हर फ़ोन हार्डवेयर में डिकोड करता है। इसके बिना YouTube AV1 भेज सकता है, जो कई डिवाइस पर बिगड़ी हुई तस्वीर दिखाता है। इसे बंद करने पर सबसे ऊँचा रेज़ोल्यूशन मिलता है, पर कम्पैटिबिलिटी घटती है।';

  @override
  String get completed => 'पूरे हुए';

  @override
  String get continueAsAudio => 'ऑडियो के रूप में जारी रखें';

  @override
  String get continueAsAudioBody =>
      'इसे उसी सेकंड से ऑडियो के रूप में चलाते रहें?';

  @override
  String get continueAsAudioNo => 'नहीं, रोकें';

  @override
  String get continueAsAudioTitle => 'बैकग्राउंड में जारी रखें?';

  @override
  String get cookies => 'कुकीज़';

  @override
  String get cookiesNotNetscape =>
      'इनमें से किसी फ़ाइल में Netscape फ़ॉर्मैट की कुकीज़ नहीं हैं';

  @override
  String get cookiesSubtitle =>
      'उन साइटों के लिए जो लॉगिन के बिना डाउनलोड नहीं होने देतीं';

  @override
  String get copiedToClipboard => 'क्लिपबोर्ड पर कॉपी हुआ';

  @override
  String get copyright => '© 2026 Yasir Sagheer';

  @override
  String get couldNotLoadPlaylist =>
      'यह प्लेलिस्ट लोड नहीं हो सकी। URL और अपना कनेक्शन जाँचें।';

  @override
  String get create => 'बनाएँ';

  @override
  String get createPlaylist => 'प्लेलिस्ट बनाएँ';

  @override
  String get defaultQuality => 'डिफ़ॉल्ट वीडियो क्वालिटी';

  @override
  String get delete => 'मिटाएँ';

  @override
  String deleteMultipleConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count क्लिप मिटाएँ?\n\nइनकी फ़ाइलें आपके डिवाइस से हटा दी जाएँगी।',
      one: '1 क्लिप मिटाएँ?\n\nइसकी फ़ाइल आपके डिवाइस से हटा दी जाएगी।',
    );
    return '$_temp0';
  }

  @override
  String deletePlaylistConfirm(Object name) {
    return '\"$name\" मिटाएँ?';
  }

  @override
  String get deleteRefused =>
      'नहीं मिटा: इस फ़ाइल को मिटाने के लिए Android को आपकी अनुमति चाहिए, उस डायलॉग में जो वह दिखाता है।';

  @override
  String get deleteSelected => 'चुने हुए मिटाएँ';

  @override
  String get deleteTag => 'टैग मिटाएँ';

  @override
  String deleteTagConfirm(Object tag) {
    return 'टैग \"$tag\" को सभी आइटम से मिटाएँ? क्लिप खुद नहीं मिटेंगी।';
  }

  @override
  String get deleteVideo => 'क्लिप मिटाएँ';

  @override
  String deleteVideoConfirm(Object title) {
    return '\"$title\" मिटाएँ?\n\nइससे फ़ाइल आपके डिवाइस से हट जाएगी।';
  }

  @override
  String deletedCount(Object count) {
    return '$count मिटाए गए';
  }

  @override
  String deletedTitle(Object title) {
    return 'मिटाया गया: $title';
  }

  @override
  String get deselectAll => 'सभी का चुनाव हटाएँ';

  @override
  String desktopAddLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लिंक जोड़ें',
      one: '1 लिंक जोड़ें',
      zero: 'जोड़ने के लिए कुछ नहीं',
    );
    return '$_temp0';
  }

  @override
  String get desktopBack => 'वापस';

  @override
  String get desktopBackUpNow => 'अभी बैकअप लें';

  @override
  String get desktopBackupHint =>
      'यह कंप्यूटर अपने आखिरी सात बैकअप, कम से कम एक घंटे के अंतर पर, Downloads\\VidHoist\\Backups में रखता है, जहाँ वे ऐप अनइंस्टॉल होने के बाद भी बचे रहते हैं।';

  @override
  String get desktopBackupsNone => 'अभी कोई बैकअप नहीं';

  @override
  String get desktopBrowserButton => 'ब्राउज़र में “VidHoist पर भेजें” बटन';

  @override
  String get desktopBrowserButtonCopied =>
      'कोड कॉपी हुआ। एक नया बुकमार्क बनाएँ और इसे उसके पते (URL) में पेस्ट करें।';

  @override
  String get desktopBrowserButtonCopy => 'कोड कॉपी करें';

  @override
  String get desktopBrowserButtonFailed =>
      'पेज नहीं खुल सका; इसकी जगह कोड कॉपी करें।';

  @override
  String get desktopBrowserButtonHint =>
      'आपके बुकमार्क बार पर एक बटन: किसी भी वीडियो के पेज पर एक क्लिक से यहाँ उसके लिंक के साथ जोड़ने वाला डायलॉग खुलता है। जब तक आप जोड़ें नहीं दबाते, कुछ नहीं भेजा जाता।';

  @override
  String get desktopBrowserButtonName => 'VidHoist पर भेजें';

  @override
  String get desktopBrowserButtonOpen => 'सेटअप पेज खोलें';

  @override
  String get desktopBrowserPageCopyInstead =>
      'अगर खींचना काम न करे, तो एक नया बुकमार्क बनाएँ और इसे उसके पते में पेस्ट करें:';

  @override
  String get desktopBrowserPageDragHint =>
      'इसे बार पर खींचें; यहाँ क्लिक करने से कुछ नहीं होता।';

  @override
  String get desktopBrowserPageStep1 =>
      'अगर बुकमार्क बार छिपा है तो उसे दिखाएँ:';

  @override
  String get desktopBrowserPageStep2 =>
      'नीचे दिए बटन को माउस से बार पर खींचें।';

  @override
  String get desktopBrowserPageStep3 =>
      'किसी भी वीडियो के पेज पर इसे क्लिक करें: VidHoist लिंक के साथ अपना जोड़ने वाला डायलॉग खोलता है। पहली बार ब्राउज़र पूछेगा कि ऐप खोलना है या नहीं; अनुमति दें।';

  @override
  String get desktopBrowserPageTitle =>
      'अपने ब्राउज़र में “VidHoist पर भेजें” बटन जोड़ें';

  @override
  String get desktopChangeFolder => 'बदलें…';

  @override
  String get desktopChannel => 'चैनल';

  @override
  String get desktopChannelClips => 'आपकी लाइब्रेरी में';

  @override
  String get desktopChannels => 'चैनल';

  @override
  String get desktopChannelsInLibrary => 'आपकी लाइब्रेरी के चैनल';

  @override
  String get desktopChannelsLater => 'डाउनलोड इंजन चाहिए';

  @override
  String get desktopChannelsLaterBody =>
      'चैनल फ़ॉलो करने के लिए इस कंप्यूटर पर yt-dlp चाहिए। इसे सेटिंग्स › इंजन में सेट करें, फिर आपके चैनल यहाँ दिखेंगे।';

  @override
  String get desktopChapters => 'चैप्टर';

  @override
  String get desktopCheckAll => 'सभी जाँचें';

  @override
  String get desktopChooseClip => 'चुनें';

  @override
  String get desktopClearFilters => 'फ़िल्टर हटाएँ';

  @override
  String get desktopClearSelection => 'चुनाव हटाएँ';

  @override
  String get desktopCookiesBrowser => 'ब्राउज़र से';

  @override
  String get desktopCookiesBrowserHint =>
      'उस ब्राउज़र से पढ़ी जाती हैं जिसमें आप साइन इन हैं। अगर न पढ़ी जा सकें, तो वह ब्राउज़र बंद करके फिर कोशिश करें।';

  @override
  String get desktopCookiesChoose => 'फ़ाइल चुनें…';

  @override
  String get desktopCookiesFile => 'कुकीज़ फ़ाइल';

  @override
  String get desktopCookiesHelp =>
      'अपने ब्राउज़र में ऐसा एक्सटेंशन इस्तेमाल करें जो कुकीज़ को Netscape फ़ॉर्मैट में एक्सपोर्ट करे (हर साइट की एक फ़ाइल), और यहाँ सभी फ़ाइलें एक साथ चुनें। फिर yt-dlp हर डाउनलोड के लिए इनका इस्तेमाल करता है। कुकीज़ की मियाद खत्म होती है, इसलिए अगर डाउनलोड फिर से विफल होने लगें, तो आम तौर पर नया एक्सपोर्ट करने का समय है।';

  @override
  String get desktopCookiesKept => 'इस कंप्यूटर पर रखी कुकीज़';

  @override
  String desktopCookiesKeptFor(String sites) {
    return 'इनके लिए कुकीज़ रखी हैं: $sites';
  }

  @override
  String get desktopCookiesLocalHint =>
      'उन साइटों के लिए जिनमें साइन इन होना ज़रूरी है। yt-dlp इन्हें इसी कंप्यूटर पर पढ़ता है, और ये कहीं और नहीं जातीं।';

  @override
  String get desktopCookiesNone => 'कोई नहीं';

  @override
  String get desktopCookiesRemove => 'हटाएँ';

  @override
  String get desktopCopiedLinkAdd => 'जोड़ें…';

  @override
  String get desktopCopiedLinkTitle => 'यह लिंक डाउनलोड करें?';

  @override
  String get desktopCopyFile => 'फ़ाइल कॉपी करें';

  @override
  String get desktopCopyFileFailed => 'फ़ाइल कॉपी नहीं हो सकी';

  @override
  String get desktopCopyLink => 'लिंक कॉपी करें';

  @override
  String get desktopCopyOneClip => 'एक बार में एक ही क्लिप कॉपी होती है';

  @override
  String get desktopCopyQuote => 'समय और लिंक के साथ कॉपी करें';

  @override
  String get desktopDefaultQualityHint =>
      'हर बार जोड़ते समय यही पहले चुना रहता है; आप हर लिंक के लिए इसे बदल सकते हैं।';

  @override
  String desktopDeleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count क्लिप मिटाएँ? इस कंप्यूटर पर इनकी फ़ाइलें मिट जाएँगी।',
      one: '1 क्लिप मिटाएँ? इस कंप्यूटर पर इसकी फ़ाइल मिट जाएगी।',
    );
    return '$_temp0';
  }

  @override
  String get desktopDesktopSection => 'Windows';

  @override
  String get desktopDiscover => 'VidHoist को जानें';

  @override
  String get desktopDiscoverAddLink => 'लिंक पेस्ट करें या छोड़ें';

  @override
  String get desktopDiscoverAddLinkLine =>
      'जोड़ने के लिए कहीं भी Ctrl+V दबाएँ, या लिंक को विंडो पर छोड़ें।';

  @override
  String get desktopDiscoverAdding => 'जोड़ना और शेयर करना';

  @override
  String get desktopDiscoverBrowser => 'ब्राउज़र से';

  @override
  String get desktopDiscoverBrowserLine =>
      'आपके बुकमार्क बार का “VidHoist पर भेजें” बटन आपके मौजूदा पेज के साथ जोड़ने वाला डायलॉग खोलता है।';

  @override
  String get desktopDiscoverChapters => 'चैप्टर';

  @override
  String get desktopDiscoverChaptersLine =>
      'क्लिप के हिस्से, उसकी ट्रांसक्रिप्ट से, उसके पेज पर।';

  @override
  String get desktopDiscoverChoose => 'कई चुनें';

  @override
  String get desktopDiscoverChooseLine =>
      'गोल निशान, या Ctrl या Shift के साथ क्लिक; फिर उन्हें किसी लिस्ट में जोड़ें या एक साथ मिटाएँ।';

  @override
  String get desktopDiscoverDragOut => 'क्लिप बाहर खींचें';

  @override
  String get desktopDiscoverDragOutLine =>
      'इसे किसी फ़ोल्डर या दूसरे ऐप पर छोड़ें, और यह वहाँ फ़ाइल के रूप में पहुँच जाती है।';

  @override
  String get desktopDiscoverExport => 'ट्रांसक्रिप्ट एक्सपोर्ट करें';

  @override
  String get desktopDiscoverExportLine =>
      'टेक्स्ट के रूप में, या दूसरे प्लेयर के लिए SRT सबटाइटल के रूप में।';

  @override
  String get desktopDiscoverHint =>
      'ऐप जो कुछ कर सकता है, हर बात एक लाइन में, उसकी कीज़ के साथ।';

  @override
  String get desktopDiscoverLibrary => 'लाइब्रेरी';

  @override
  String get desktopDiscoverListening =>
      'सुनने के लिए: बड़े कवर के साथ एक शांत स्क्रीन, फ़ुल स्क्रीन में।';

  @override
  String get desktopDiscoverMini => 'छोटी विंडो';

  @override
  String get desktopDiscoverMiniLine =>
      'स्क्रीन के निचले कोने में, बाकी सभी विंडो के ऊपर एक छोटा कार्ड।';

  @override
  String get desktopDiscoverReading =>
      'ट्रांसक्रिप्ट एक लेख की तरह: किसी वाक्य पर क्लिक करें और वहीं से सुनें।';

  @override
  String get desktopDiscoverSaid => 'जो कहा गया';

  @override
  String get desktopDiscoverSearch => 'जो कहा गया उसमें खोजें';

  @override
  String get desktopDiscoverSearchLine =>
      'वे क्लिप ढूँढें जिनमें कोई शब्द बोला गया, सिर्फ़ टाइटल में नहीं।';

  @override
  String get desktopDiscoverShortcutsLine =>
      'विंडो जिन कीज़ पर काम करती है, सब एक शीट पर।';

  @override
  String get desktopDiscoverShow => 'दिखाएँ';

  @override
  String get desktopDiscoverStatsLine =>
      'लाइब्रेरी की गिनती: साइट, चैनल और महीने के हिसाब से।';

  @override
  String get desktopDiscoverSubtitles =>
      'तस्वीर पर ट्रांसक्रिप्ट, बोला जा रहा शब्द हाइलाइट।';

  @override
  String get desktopDiscoverTheater =>
      'बड़ी तस्वीर जो साइड पैनल की जगह ले लेती है।';

  @override
  String get desktopDiscoverTry => 'आज़माएँ';

  @override
  String get desktopDiscoverWatching => 'देखना और सुनना';

  @override
  String get desktopDownloadFolder => 'डाउनलोड फ़ोल्डर';

  @override
  String get desktopDownloadFolderHint =>
      'डाउनलोड यहाँ आम फ़ाइलों की तरह सेव होते हैं, जिन्हें किसी भी दूसरी फ़ाइल की तरह खोला, हटाया या बैकअप किया जा सकता है।';

  @override
  String get desktopDownloads => 'डाउनलोड';

  @override
  String get desktopDownloadsEmpty =>
      'कुछ भी डाउनलोड नहीं हो रहा। शुरू करने के लिए लिंक जोड़ें।';

  @override
  String get desktopDownloadsRunning => 'चल रहे हैं';

  @override
  String get desktopDragToReorder => 'क्रम बदलने के लिए खींचें';

  @override
  String get desktopDropLinks => 'जोड़ने के लिए छोड़ें';

  @override
  String get desktopEmptyLibraryMessage =>
      'लिंक जोड़ें, और डाउनलोड होते ही क्लिप यहाँ दिखेगी।';

  @override
  String get desktopEngine => 'इंजन';

  @override
  String get desktopEngineDenoHint =>
      'YouTube की जाँच का जवाब देता है, ताकि वह जो भी क्वालिटी दे, डाउनलोड हो सके';

  @override
  String get desktopEngineFetch => 'लाएँ';

  @override
  String get desktopEngineFetchCorrupt =>
      'जो फ़ाइल आई वह जारी की गई फ़ाइल नहीं थी, इसलिए उसका इस्तेमाल नहीं हुआ।';

  @override
  String get desktopEngineFetchFailed =>
      'लाया नहीं जा सका। कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get desktopEngineFetchInUse =>
      'एक डाउनलोड इसका इस्तेमाल कर रहा है। उसके खत्म होने पर फिर कोशिश करें।';

  @override
  String desktopEngineFetching(int percent) {
    return 'लाया जा रहा है · $percent%';
  }

  @override
  String get desktopEngineFfmpegHint =>
      'तस्वीर और आवाज़ को जोड़ता है, और ऑडियो बदलता है';

  @override
  String get desktopEngineIpv4 => 'सिर्फ़ IPv4 इस्तेमाल करें';

  @override
  String get desktopEngineIpv4Hint =>
      'जहाँ IPv6 खराब है, जैसे कई घरेलू नेटवर्क में, वहाँ बहुत तेज़। इसे तभी बंद करें जब आपके नेटवर्क में सिर्फ़ IPv6 हो।';

  @override
  String get desktopEngineMissing =>
      'इस कंप्यूटर पर yt-dlp नहीं है। VidHoist दोबारा इंस्टॉल करें, या इसे यहाँ से लाएँ।';

  @override
  String get desktopEngineOnFirstUse =>
      'पहली बार ज़रूरत वाले डाउनलोड पर लाया जाता है';

  @override
  String get desktopEngineUpToDate => 'yt-dlp अप टू डेट है';

  @override
  String get desktopEngineUpdate => 'yt-dlp अपडेट करें';

  @override
  String get desktopEngineUpdateFailed =>
      'अपडेट नहीं हो सका। बाद में फिर कोशिश करें।';

  @override
  String get desktopEngineUpdateHint =>
      'साइटें अक्सर बदलती हैं; पुराना yt-dlp कुछ ही महीनों में काम करना बंद कर देता है।';

  @override
  String desktopEngineUpdated(String version) {
    return 'yt-dlp अब $version है';
  }

  @override
  String get desktopEngineUpdating => 'अपडेट हो रहा है…';

  @override
  String desktopEngineVersion(String version) {
    return 'वर्शन $version';
  }

  @override
  String get desktopEngineYtDlpHint => 'लिंक पढ़ता है और उसे डाउनलोड करता है';

  @override
  String get desktopExport => 'एक्सपोर्ट करें';

  @override
  String get desktopExportForPhone => 'फ़ोन के लिए एक्सपोर्ट करें';

  @override
  String get desktopExportForPhoneHint =>
      'इस कंप्यूटर के टैग, लिस्ट और जहाँ रुके थे वहाँ के पॉइंट, और इसकी ट्रांसक्रिप्ट, दो फ़ाइलों के रूप में सेव करता है जिन्हें फ़ोन रीस्टोर करता है। फ़ोन पर रीस्टोर करने से उसके अपने टैग और लिस्ट बदल जाते हैं।';

  @override
  String get desktopExportMarkdown => 'टेक्स्ट (Markdown)';

  @override
  String get desktopExportPdf => 'डॉक्यूमेंट (PDF)';

  @override
  String get desktopExportPhone => 'फ़ोन के लिए (VidHoist इंपोर्ट)';

  @override
  String get desktopExportSrt => 'सबटाइटल (SRT)';

  @override
  String desktopExported(String name) {
    return '$name सेव हुआ';
  }

  @override
  String desktopFileReadyToPaste(String name, String size) {
    return 'पेस्ट के लिए तैयार: $name · $size';
  }

  @override
  String get desktopFirstLinkKeys => 'विंडो में कहीं भी यही करता है';

  @override
  String get desktopFirstLinkNote =>
      'YouTube या किसी दूसरी साइट से। डाउनलोड शुरू होते ही क्लिप यहाँ दिखेगी।';

  @override
  String get desktopFirstLinkPaste => 'पेस्ट';

  @override
  String get desktopFirstLinkTitle => 'अपना पहला लिंक पेस्ट करें';

  @override
  String get desktopFolderUnavailable => 'कोई फ़ोल्डर उपलब्ध नहीं';

  @override
  String get desktopFolders => 'फ़ोल्डर';

  @override
  String get desktopForward => 'आगे';

  @override
  String get desktopGlobalShortcut => 'किसी भी ऐप से चलाएँ और रोकें';

  @override
  String desktopGlobalShortcutHint(String keys) {
    return 'विंडो दूसरे ऐप के पीछे होने पर भी $keys चलाता और रोकता है।';
  }

  @override
  String desktopGlobalShortcutTaken(String keys) {
    return 'कोई दूसरा ऐप पहले से $keys इस्तेमाल करता है।';
  }

  @override
  String get desktopHidePanel => 'साइड पैनल छिपाएँ';

  @override
  String get desktopHintShortcuts =>
      'कीबोर्ड शॉर्टकट के लिए ? दबाएँ। Space चलाता और रोकता है; तीर वाली कीज़ आगे-पीछे करती हैं।';

  @override
  String get desktopHintShortcutsAction => 'शॉर्टकट';

  @override
  String get desktopHintTrayBody =>
      'यह घड़ी के पास वाले आइकन से चलता रहता है। बंद करने के लिए आइकन पर राइट-क्लिक करें।';

  @override
  String get desktopHintTrayTitle => 'VidHoist अभी भी चल रहा है';

  @override
  String get desktopHints => 'टिप्स दिखाएँ';

  @override
  String get desktopHintsAgain => 'फिर से दिखाएँ';

  @override
  String get desktopHintsHint =>
      'दो छोटे टिप्स, हर एक सिर्फ़ एक बार: पहली क्लिप पर शॉर्टकट, पहली बार बंद करने पर घड़ी के पास का आइकन।';

  @override
  String get desktopImportFromPhone => 'बैकअप या ट्रांसक्रिप्ट इंपोर्ट करें…';

  @override
  String get desktopImportHint =>
      'VidHoist की बैकअप या ट्रांसक्रिप्ट फ़ाइल, यहाँ चुनी हुई या विंडो पर छोड़ी हुई। फ़ोन की फ़ाइल यहाँ मौजूद डेटा में जुड़ जाती है; इस कंप्यूटर का बैकअप पूछने के बाद पूरा रीस्टोर होता है।';

  @override
  String desktopImportedBackup(int tagged, int lists, int positions) {
    return 'फ़ोन से जोड़ा गया। टैग: $tagged · लिस्ट: $lists · रुके हुए पॉइंट: $positions';
  }

  @override
  String get desktopImportedNothing =>
      'कुछ नया नहीं: इस कंप्यूटर में यह सब पहले से था।';

  @override
  String desktopImportedTranscripts(int count) {
    return 'जोड़ी गई ट्रांसक्रिप्ट: $count';
  }

  @override
  String desktopInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आपकी लाइब्रेरी में $count',
      one: 'आपकी लाइब्रेरी में 1',
    );
    return '$_temp0';
  }

  @override
  String get desktopKeepAwake => 'डाउनलोड के दौरान कंप्यूटर को जगाए रखें';

  @override
  String get desktopKeepAwakeHint =>
      'ताकि फ़ोन से भेजा गया लिंक, या लंबी प्लेलिस्ट, Windows के स्लीप में जाने पर रुकने की जगह पूरी हो जाए। स्क्रीन हमेशा की तरह बंद होती है।';

  @override
  String get desktopKeyAddLink => 'कॉपी किया लिंक जोड़ें';

  @override
  String get desktopKeyFavorite => 'पसंदीदा में जोड़ें या हटाएँ';

  @override
  String get desktopKeyFullScreen => 'फ़ुल स्क्रीन; ऑडियो के लिए, लिसनिंग रूम';

  @override
  String get desktopKeyMenu => 'क्लिप का मेन्यू';

  @override
  String get desktopKeyMini => 'बाकी विंडो के ऊपर छोटी विंडो, और वापस';

  @override
  String get desktopKeyPlayPause => 'चलाएँ या रोकें';

  @override
  String get desktopKeyRepeat => 'रिपीट बदलें';

  @override
  String get desktopKeySearch => 'टाइटल और जो कहा गया उसमें खोजें';

  @override
  String get desktopKeySeek => '10 सेकंड पीछे या आगे';

  @override
  String get desktopKeyShortcuts => 'यह लिस्ट';

  @override
  String get desktopKeyVolume =>
      'आवाज़ तेज़ या धीमी; Shorts में, पिछला या अगला';

  @override
  String get desktopKeyZoomIn => 'बड़ा इंटरफ़ेस';

  @override
  String get desktopKeyZoomOut => 'छोटा इंटरफ़ेस';

  @override
  String get desktopKeyZoomReset => 'इंटरफ़ेस सामान्य साइज़ में';

  @override
  String get desktopLanguageSystemHint => 'Windows की भाषा अपनाता है।';

  @override
  String desktopLastArrival(String when) {
    return 'आखिरी बार आया $when';
  }

  @override
  String get desktopLess => 'कम';

  @override
  String desktopLibraryDownloading(int count) {
    return '$count डाउनलोड हो रहे हैं';
  }

  @override
  String get desktopLibraryLoading => 'लाइब्रेरी लोड हो रही है…';

  @override
  String get desktopLinkCopied => 'लिंक कॉपी हुआ';

  @override
  String get desktopLinkDuplicate => 'ऊपर दोहराया गया';

  @override
  String get desktopLinkInLibrary => 'पहले से आपकी लाइब्रेरी में';

  @override
  String get desktopLinkPlaylist => 'एक प्लेलिस्ट: इसकी क्लिप चुनें';

  @override
  String get desktopLinkReady => 'तैयार';

  @override
  String get desktopLinkUnsupported => 'ऐसी साइट जिसे यह ऐप नहीं जानता';

  @override
  String desktopLinksDropped(int count, int limit) {
    return 'सिर्फ़ पहले $limit लिंक लिए गए; $count और छोड़ दिए गए।';
  }

  @override
  String desktopLinksFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लिंक',
      one: '1 लिंक',
    );
    return '$_temp0';
  }

  @override
  String get desktopListeningClose => 'लिसनिंग रूम बंद करें';

  @override
  String get desktopListeningRoom => 'लिसनिंग रूम';

  @override
  String get desktopLogsCopied => 'लॉग कॉपी हुआ, लिंक या पतों के बिना';

  @override
  String get desktopLogsCopy => 'कॉपी करें';

  @override
  String get desktopLogsSave => 'फ़ाइल में सेव करें';

  @override
  String get desktopMiniRestore => 'पूरी विंडो पर वापस';

  @override
  String get desktopMiniWindow => 'छोटी विंडो';

  @override
  String get desktopMore => 'और';

  @override
  String get desktopNarrowSidebar => 'साइडबार छोटा करें';

  @override
  String get desktopNoChannelNames =>
      'आपकी लाइब्रेरी की क्लिप में उनके चैनल का नाम नहीं है, इसलिए इस चैनल की क्लिप अलग नहीं की जा सकतीं। इसे इसके अपने फ़ोल्डर के साथ फ़ॉलो करें, और वहाँ जो भी आएगा, यहाँ दिखेगा।';

  @override
  String get desktopNoFavoritesMessage =>
      'किसी क्लिप को पसंदीदा बनाएँ और वह यहाँ आपका इंतज़ार करेगी।';

  @override
  String get desktopNoFavoritesTitle => 'अभी कोई पसंदीदा नहीं';

  @override
  String get desktopNoMatchMessage => 'ज़्यादा देखने के लिए कोई फ़िल्टर हटाएँ।';

  @override
  String get desktopNoMatchTitle => 'इन फ़िल्टर से कुछ मेल नहीं खाता';

  @override
  String get desktopNoTags =>
      'अभी कोई टैग नहीं। क्लिप के पेज से उसे टैग करें और टैग यहाँ दिखेगा।';

  @override
  String get desktopNoTranscriptMessage =>
      'क्लिप के साथ उसके सबटाइटल डाउनलोड होते ही यह यहाँ दिखेगी।';

  @override
  String get desktopNoTranscriptTitle => 'इस क्लिप की कोई ट्रांसक्रिप्ट नहीं';

  @override
  String get desktopNotABackup =>
      'यह फ़ाइल VidHoist की बैकअप या ट्रांसक्रिप्ट फ़ाइल नहीं है।';

  @override
  String desktopNotWatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नहीं देखीं',
      one: '1 नहीं देखी',
    );
    return '$_temp0';
  }

  @override
  String get desktopNothingPlaying => 'कुछ नहीं चल रहा';

  @override
  String get desktopNothingPlayingHint =>
      'कोई क्लिप चलाएँ, और उसकी ट्रांसक्रिप्ट, आगे क्या है और उसकी जानकारी यहाँ दिखेगी।';

  @override
  String get desktopNotifyArrivalsHint =>
      'जब आपके फ़ॉलो किए चैनलों की नई क्लिप डाउनलोड हों, तो Windows की सूचना।';

  @override
  String get desktopOfferCopiedLinks => 'मेरे कॉपी किए लिंक सुझाएँ';

  @override
  String get desktopOfferCopiedLinksHint =>
      'जब आप किसी दूसरे ऐप में वीडियो लिंक कॉपी करते हैं, तो एक सूचना उसे जोड़ने का सुझाव देती है। सिर्फ़ लिंक देखे जाते हैं, और कोई सेव नहीं होता।';

  @override
  String get desktopOpenBackup => 'बैकअप खोलें';

  @override
  String get desktopOpenChannels => 'चैनल खोलें';

  @override
  String get desktopOpenInExplorer => 'Explorer में खोलें';

  @override
  String get desktopOpenWith => 'दूसरे प्लेयर में खोलें…';

  @override
  String get desktopPaletteClose => 'बंद करने के लिए';

  @override
  String get desktopPaletteCommands => 'कमांड';

  @override
  String get desktopPaletteHint =>
      'टाइटल और जो कहा गया उसमें खोजें, या कमांड के लिए > लिखें';

  @override
  String desktopPaletteList(String name) {
    return 'लिस्ट: $name';
  }

  @override
  String get desktopPaletteMove => 'चलने के लिए';

  @override
  String get desktopPaletteOpen => 'खोलने के लिए';

  @override
  String get desktopPaletteRecent => 'हाल में चलाए गए';

  @override
  String get desktopPaletteSaid => 'क्लिप के अंदर कहा गया';

  @override
  String get desktopPaletteSave => 'यह खोज सेव करें';

  @override
  String get desktopPaletteSaved => 'सेव की गई खोजें';

  @override
  String desktopPaletteSettings(String section) {
    return 'सेटिंग्स: $section';
  }

  @override
  String get desktopPaletteTitles => 'टाइटल';

  @override
  String get desktopPinned => 'पिन किए गए';

  @override
  String get desktopPlayNext => 'इसके बाद चलाएँ';

  @override
  String get desktopPlaysNext => 'इसके बाद चलेगी';

  @override
  String get desktopQueueEnd => 'इसके बाद कुछ नहीं है';

  @override
  String desktopQuote(String text, String title, String time, String link) {
    return '“$text”\n— $title, $time\n$link';
  }

  @override
  String get desktopQuoteCopied => 'समय और लिंक के साथ कॉपी हुआ';

  @override
  String get desktopReadingBack => 'क्लिप पर वापस';

  @override
  String get desktopReadingCloseFind => 'खोज बंद करें';

  @override
  String get desktopReadingFind => 'टेक्स्ट में खोजें';

  @override
  String desktopReadingFound(int at, int count) {
    return '$count में से $at';
  }

  @override
  String get desktopReadingHint =>
      'किसी वाक्य पर क्लिक करके वहाँ से सुनें · Ctrl+F से शब्द खोजें · समय के साथ कॉपी करने के लिए चुनें';

  @override
  String get desktopReadingNextMatch => 'अगला मिलान';

  @override
  String get desktopReadingPreviousMatch => 'पिछला मिलान';

  @override
  String get desktopReadingRoom => 'रीडिंग रूम';

  @override
  String get desktopRecoverLibrary => 'फ़ोल्डर में पहले से मौजूद क्लिप';

  @override
  String get desktopRecoverLibraryAction => 'फ़ोल्डर में देखें';

  @override
  String get desktopRecoverLibraryHint =>
      'दोबारा इंस्टॉल करने के बाद: जो क्लिप डाउनलोड फ़ोल्डर में हैं पर लिस्ट में नहीं, उन्हें लाइब्रेरी में वापस लाता है। फ़ाइलों को छुआ नहीं जाता।';

  @override
  String desktopRecovered(int count) {
    return 'लाइब्रेरी में वापस लाई गईं: $count';
  }

  @override
  String get desktopRecoveredNothing =>
      'जोड़ने के लिए कुछ नहीं: फ़ोल्डर की हर क्लिप लाइब्रेरी में है।';

  @override
  String desktopRecoveredSome(int count, int left) {
    return 'लाइब्रेरी में वापस लाई गईं: $count। लिंक पता न होने से छोड़ी गईं: $left';
  }

  @override
  String get desktopRemoveFromList => 'लिस्ट से हटाएँ';

  @override
  String get desktopRestore => 'रीस्टोर करें';

  @override
  String get desktopRestoreBody =>
      'इस कंप्यूटर की लाइब्रेरी, फ़ॉलो किए चैनल, टैग, लिस्ट और सेटिंग्स वैसी हो जाएँगी जैसी बैकअप में हैं। डाउनलोड की गई फ़ाइलों को छुआ नहीं जाता।';

  @override
  String desktopRestoreOfferBody(String when) {
    return 'Downloads\\VidHoist\\Backups में इस कंप्यूटर का बैकअप है: इसकी लाइब्रेरी, फ़ॉलो किए चैनल, प्लेलिस्ट, टैग, सेटिंग्स और सेव की गई ट्रांसक्रिप्ट। सबसे नया $when बना था। दोनों ही हालत में आपकी डाउनलोड की गई फ़ाइलों को छुआ नहीं जाता।';
  }

  @override
  String get desktopRestoreOfferTitle => 'अपना बैकअप रीस्टोर करें?';

  @override
  String get desktopRestoreTitle => 'यह बैकअप रीस्टोर करें?';

  @override
  String get desktopRestored => 'बैकअप रीस्टोर हुआ';

  @override
  String get desktopRevealAfterDownload => 'पूरा होने पर Explorer में दिखाएँ';

  @override
  String get desktopRevealAfterDownloadHint =>
      'जब इस कंप्यूटर पर कोई फ़ाइल डाउनलोड हो जाती है, तो उसका फ़ोल्डर फ़ाइल चुनी हुई हालत में खुलता है।';

  @override
  String desktopSavedIn(String folder) {
    return '$folder में सेव हुआ';
  }

  @override
  String desktopSavedSearchDelete(String name) {
    return 'सेव की गई खोज “$name” मिटाएँ? लाइब्रेरी में कुछ नहीं बदलता।';
  }

  @override
  String get desktopSavedSearchName => 'खोज का नाम';

  @override
  String get desktopSearch => 'खोजें';

  @override
  String get desktopSearchHint => 'टाइटल और जो कहा गया उसमें खोजें…';

  @override
  String get desktopSearchSaved => 'साइडबार में सेव हुआ';

  @override
  String get desktopSeekBar => 'क्लिप में स्थिति';

  @override
  String desktopSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count चुने गए',
      one: '1 चुना गया',
    );
    return '$_temp0';
  }

  @override
  String get desktopSetupChooseFile => 'फ़ाइल चुनें…';

  @override
  String get desktopShortcutsApp => 'ऐप';

  @override
  String get desktopShortcutsClip => 'चुनी हुई क्लिप पर';

  @override
  String get desktopShortcutsPlayback => 'प्लेबैक';

  @override
  String get desktopShortcutsTitle => 'कीबोर्ड शॉर्टकट';

  @override
  String get desktopShortcutsWindow => 'विंडो';

  @override
  String get desktopShortsHint =>
      'अगले Shorts वीडियो के लिए ↑ ↓ या व्हील · पसंदीदा के लिए डबल-क्लिक';

  @override
  String get desktopShowInFolder => 'फ़ोल्डर में दिखाएँ';

  @override
  String get desktopShowPanel => 'साइड पैनल दिखाएँ';

  @override
  String get desktopStartFresh => 'नए सिरे से शुरू करें';

  @override
  String get desktopStartWithWindows => 'Windows के साथ शुरू करें';

  @override
  String get desktopStartWithWindowsHint =>
      'आपके साइन इन करने पर खुलता है: अगर ट्रे में चलता रहता है तो ट्रे में, नहीं तो मिनिमाइज़ होकर।';

  @override
  String get desktopStartWithWindowsRefused =>
      'Windows ने ऐप को अपने साथ शुरू नहीं होने दिया।';

  @override
  String get desktopStats => 'लाइब्रेरी के आँकड़े';

  @override
  String get desktopStatsByChannel => 'चैनल के हिसाब से';

  @override
  String get desktopStatsByMonth => 'जोड़ने के महीने के हिसाब से';

  @override
  String get desktopStatsBySite => 'साइट के हिसाब से';

  @override
  String get desktopStatsClips => 'क्लिप';

  @override
  String get desktopStatsHint =>
      'लाइब्रेरी में क्या है, और किस पर नज़र डालना ठीक रहेगा। यहाँ से कुछ नहीं मिटता।';

  @override
  String desktopStatsHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count घंटे',
      one: '1 घंटा',
      zero: 'एक घंटे से कम',
    );
    return '$_temp0';
  }

  @override
  String get desktopStatsLargest => 'सबसे बड़ी:';

  @override
  String get desktopStatsLength => 'कुल अवधि';

  @override
  String get desktopStatsLink => 'आँकड़े';

  @override
  String get desktopStatsNeverPlayed => 'यहाँ कभी नहीं चलाई गई';

  @override
  String get desktopStatsNewest => 'सबसे नई:';

  @override
  String get desktopStatsOtherChannels => 'दूसरे चैनल';

  @override
  String get desktopStatsRoom => 'ली गई जगह';

  @override
  String get desktopStatsUnnamed => 'चैनल का नाम नहीं';

  @override
  String get desktopStatsWithText => 'ट्रांसक्रिप्ट के साथ';

  @override
  String get desktopStatsWithoutText => 'ट्रांसक्रिप्ट के बिना';

  @override
  String get desktopStatsWorthALook => 'देखने लायक';

  @override
  String get desktopSubtitleOptions => 'सबटाइटल विकल्प';

  @override
  String get desktopTheater => 'थिएटर';

  @override
  String get desktopTranscriptFirst => 'पहले इसकी ट्रांसक्रिप्ट लाएँ';

  @override
  String get desktopTranscriptHint =>
      'प्लेबैक के साथ चलती है · किसी लाइन पर क्लिक करके वहाँ जाएँ';

  @override
  String get desktopTranscriptHintPage =>
      'इस क्लिप की ट्रांसक्रिप्ट · वहीं से चलाने के लिए किसी लाइन पर क्लिक करें';

  @override
  String get desktopTranscriptsDeleteBody =>
      'ये इस कंप्यूटर से और इसके बैकअप से हटा दी जाती हैं। सिर्फ़ आपकी एक्सपोर्ट की हुई फ़ाइल ही इन्हें वापस ला सकती है।';

  @override
  String get desktopTranscriptsHelp =>
      'आप जो भी YouTube क्लिप जोड़ते हैं, VidHoist उसमें कहे गए शब्द रखता है, ताकि खोज (Ctrl+K) सिर्फ़ टाइटल ही नहीं, आपकी क्लिप के अंदर कही गई बातें भी ढूँढे। ये इसी कंप्यूटर पर रहती हैं।';

  @override
  String get desktopTranscriptsMove => 'फ़ोन पर या फ़ोन से';

  @override
  String get desktopTranscriptsMoveHint =>
      'ट्रांसक्रिप्ट बैकअप के साथ जाती हैं: फ़ोन के लिए एक्सपोर्ट इन्हें ले जाता है, और वहाँ इंपोर्ट इन्हें ले आता है, जो यहाँ नहीं है उसे जोड़ते हुए।';

  @override
  String get desktopTrayOnClose => 'विंडो बंद होने पर ट्रे में चलाते रहें';

  @override
  String get desktopTrayOnCloseHint =>
      'विंडो बंद करने पर भी आवाज़ चलती रहती है; घड़ी के पास वाले आइकन से बंद करें।';

  @override
  String get desktopTrayOpen => 'VidHoist खोलें';

  @override
  String get desktopTrayQuit => 'बंद करें';

  @override
  String get desktopUiSize => 'इंटरफ़ेस का साइज़';

  @override
  String desktopUiSizeHint(String bigger, String smaller, String reset) {
    return '$bigger और $smaller इसे कहीं से भी बदलते हैं, और $reset इसे 100% पर लौटाता है।';
  }

  @override
  String get desktopUiSizeTooLarge => 'इस स्क्रीन के लिए बहुत बड़ा';

  @override
  String get desktopUpdateInstall => 'इंस्टॉल करें और रीस्टार्ट करें';

  @override
  String get desktopUpdateRestartHint =>
      'VidHoist बंद होगा, अपडेट इंस्टॉल करेगा और फिर खुलेगा। आपकी सेटिंग्स और लाइब्रेरी जैसी हैं वैसी रहेंगी।';

  @override
  String get desktopViewCompact => 'कॉम्पैक्ट';

  @override
  String get desktopViewTable => 'टेबल';

  @override
  String get desktopVolume => 'आवाज़';

  @override
  String desktopVolumeLevel(int percent) {
    return 'आवाज़ $percent%';
  }

  @override
  String get desktopWelcomeFetchNow => 'अभी लाएँ';

  @override
  String get desktopWelcomeHelpers =>
      'ffmpeg (तस्वीर और आवाज़ जोड़ता है) और Deno (YouTube के लिए ज़रूरी) पहले डाउनलोड पर अपने-आप आ जाते हैं, लगभग 160 MB। आप चाहें तो इन्हें अभी ला सकते हैं।';

  @override
  String get desktopWelcomeMessage =>
      'YouTube या किसी दूसरी साइट का लिंक पेस्ट करें, और VidHoist उसे yt-dlp से इस कंप्यूटर पर डाउनलोड करता है।';

  @override
  String get desktopWelcomeStart => 'शुरू करें';

  @override
  String get desktopWelcomeTitle => 'VidHoist में आपका स्वागत है';

  @override
  String get desktopWhatsNewAllFeatures => 'VidHoist जो कुछ कर सकता है';

  @override
  String get desktopWidenSidebar => 'साइडबार बड़ा करें';

  @override
  String get desktopWindowClose => 'बंद करें';

  @override
  String get desktopWindowMaximize => 'बड़ा करें';

  @override
  String get desktopWindowMinimize => 'छोटा करें';

  @override
  String get desktopWindowRestore => 'पहले जैसा करें';

  @override
  String get desktopZoomChange => 'बदलें';

  @override
  String desktopZoomLowered(String percent) {
    return 'इंटरफ़ेस अब $percent है ताकि इस स्क्रीन में फ़िट हो।';
  }

  @override
  String get details => 'जानकारी';

  @override
  String get developer => 'डेवलपर';

  @override
  String get developerName => 'Yasir Sagheer';

  @override
  String get diagnosticLogs => 'डायग्नोस्टिक लॉग';

  @override
  String get diagnosticLogsSubtitle =>
      'ऐप लॉग देखें, खोजें और शेयर करें (निजी जानकारी हटाकर)';

  @override
  String get disclaimer => 'अस्वीकरण';

  @override
  String get disclaimerText =>
      'यह ऐप yt-dlp से मीडिया डाउनलोड करता है। उपयोगकर्ता इस टूल का कैसे इस्तेमाल करते हैं, इसके लिए डेवलपर ज़िम्मेदार नहीं है। कृपया कॉपीराइट कानूनों और जिन साइटों से आप डाउनलोड करते हैं उनकी सेवा की शर्तों का सम्मान करें।';

  @override
  String get dismiss => 'हटाएँ';

  @override
  String get done => 'हो गया';

  @override
  String get download => 'डाउनलोड करें';

  @override
  String get downloadComplete => 'डाउनलोड पूरा हुआ';

  @override
  String get downloadCompleteTitle => 'पूरा हुआ';

  @override
  String get downloadDate => 'डाउनलोड की तारीख';

  @override
  String get downloadFailed => 'डाउनलोड विफल रहा';

  @override
  String get downloadFailedTitle => 'डाउनलोड विफल रहा';

  @override
  String get downloadNow => 'डाउनलोड करें';

  @override
  String get downloadStarted => 'डाउनलोड शुरू हुआ…';

  @override
  String downloadStartedQuality(Object quality) {
    return 'डाउनलोड शुरू हुआ · $quality';
  }

  @override
  String get downloading => 'डाउनलोड हो रहा है…';

  @override
  String get downloadingTitle => 'डाउनलोड हो रहा है';

  @override
  String get downloadsAdvanced => 'एडवांस्ड';

  @override
  String get editSubscription => 'बदलें';

  @override
  String get embedSubtitles => 'सबटाइटल वीडियो के अंदर भी';

  @override
  String get embedSubtitlesHelp =>
      'ताकि दूसरे प्लेयर भी इन्हें दिखाएँ। VidHoist का अपना प्लेयर इन्हें हर हाल में दिखाता है।';

  @override
  String get emptyFilteredMessage =>
      'अपनी पूरी लाइब्रेरी देखने के लिए ऊपर कोई फ़िल्टर हटाएँ।';

  @override
  String get emptyFilteredTitle => 'इन फ़िल्टर से कुछ मेल नहीं खाता';

  @override
  String get emptyPlaylist => 'खाली प्लेलिस्ट';

  @override
  String get emptyPlaylistMessage => 'लाइब्रेरी से क्लिप जोड़ें';

  @override
  String engineDownloadingProgress(Object percent) {
    return 'डाउनलोड हो रहा है · $percent%';
  }

  @override
  String get engineErrDiskFull => 'इस फ़ाइल के लिए स्टोरेज में जगह नहीं है';

  @override
  String engineErrFailed(Object reason) {
    return 'डाउनलोड विफल रहा: $reason';
  }

  @override
  String get engineErrFormat => 'इस वीडियो के लिए यह क्वालिटी उपलब्ध नहीं है';

  @override
  String get engineErrGeoBlocked => 'आपके देश में उपलब्ध नहीं';

  @override
  String get engineErrMissing =>
      'डाउनलोड इंजन मौजूद नहीं है या अधूरा है। सेटिंग्स में इंजन ठीक करें से इसे ठीक करें';

  @override
  String get engineErrRateLimited =>
      'साइट अनुरोधों को सीमित कर रही है। कुछ देर बाद फिर कोशिश करें';

  @override
  String get engineErrUnavailable =>
      'यह वीडियो उपलब्ध नहीं है, प्राइवेट है या हटा दिया गया है';

  @override
  String get engineErrUnsupported => 'यह लिंक समर्थित नहीं है';

  @override
  String get enginePaused => 'रुका हुआ';

  @override
  String get enginePostprocessing => 'फ़ाइल पूरी की जा रही है…';

  @override
  String get enginePreparing => 'लिंक पढ़ा जा रहा है…';

  @override
  String get engineRepair => 'इंजन ठीक करें';

  @override
  String get engineRepairBusy => 'डाउनलोड पूरे होने दें, फिर ठीक करें';

  @override
  String get engineRepairHint =>
      'जब डाउनलोड कई साइटों पर विफल होने लगें जो पहले नहीं होते थे, और अपडेट से भी फ़ायदा न हो: yt-dlp का सेव किया डेटा साफ़ करता है और एक साफ़, नई कॉपी वापस लगाता है। आपके डाउनलोड और सेटिंग्स जैसे हैं वैसे रहेंगे।';

  @override
  String get engineRepairPartly =>
      'आंशिक रूप से ठीक हुआ: बाकी के लिए कनेक्शन चाहिए। ऑनलाइन होने पर फिर कोशिश करें।';

  @override
  String engineRepaired(String version) {
    return 'ठीक हुआ: yt-dlp $version';
  }

  @override
  String get engineRepairing => 'ठीक किया जा रहा है…';

  @override
  String get engineResume => 'फिर से शुरू करें';

  @override
  String get enterFullscreen => 'फ़ुल स्क्रीन';

  @override
  String errClipPastEnd(Object length) {
    return 'यह हिस्सा वीडियो खत्म होने के बाद शुरू होता है ($length)';
  }

  @override
  String get errClipPastEndUnknown =>
      'यह हिस्सा वीडियो खत्म होने के बाद शुरू होता है';

  @override
  String get errNetwork => 'साइट से कोई कनेक्शन नहीं';

  @override
  String get errPlatformBlockedCookies =>
      'साइट को लॉगिन चाहिए। सेटिंग्स › कुकीज़ में कुकीज़ फ़ाइल चुनें';

  @override
  String errorGeneric(Object message) {
    return 'गड़बड़ी: $message';
  }

  @override
  String get every30Minutes => 'हर 30 मिनट';

  @override
  String everyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हर $count घंटे',
      one: 'हर घंटे',
    );
    return '$_temp0';
  }

  @override
  String get exitFullscreen => 'फ़ुल स्क्रीन से बाहर निकलें';

  @override
  String get exportShare => 'एक्सपोर्ट और शेयर करें';

  @override
  String get exportShareSubtitle =>
      'भेजने या कहीं और रखने के लिए तारीख वाली कॉपी';

  @override
  String get externalPlayerShort => 'दूसरा प्लेयर';

  @override
  String get failed => 'विफल';

  @override
  String get failedToLoadPlaylist => 'प्लेलिस्ट लोड नहीं हो सकी';

  @override
  String get fastStreams => 'तेज़ हिस्सों वाली स्ट्रीम';

  @override
  String fastStreamsHelp(int count) {
    return 'जो साइटें वीडियो को टुकड़ों में काटती हैं, जैसे X, उनसे एक साथ $count टुकड़े लाता है। कुछ साइटें एक साथ कई अनुरोधों को धीमा कर देती हैं।';
  }

  @override
  String get favorites => 'पसंदीदा';

  @override
  String get file => 'फ़ाइल';

  @override
  String get fileSize => 'फ़ाइल का साइज़';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterAudio => 'ऑडियो';

  @override
  String get filterVideo => 'वीडियो';

  @override
  String get filtersOn => 'फ़िल्टर चालू';

  @override
  String get folder => 'फ़ोल्डर';

  @override
  String get foldersHelp =>
      'डाउनलोड फ़ोल्डर के अंदर एक फ़ोल्डर बनता है, और क्लिप सीधे उसमें सेव होती है, जहाँ Explorer और कोई भी दूसरा ऐप उसे देख सकता है। इसे \"कोई फ़ोल्डर नहीं\" पर छोड़ें तो क्लिप डाउनलोड फ़ोल्डर में सबसे ऊपर जाती है।';

  @override
  String get follow => 'फ़ॉलो करें';

  @override
  String get followChannel => 'चैनल फ़ॉलो करें';

  @override
  String get format => 'फ़ॉर्मैट';

  @override
  String framesPerSecond(int count) {
    return '$count fps';
  }

  @override
  String get helpAboutField => 'इस फ़ील्ड के बारे में';

  @override
  String get inPlaylists => 'प्लेलिस्ट में';

  @override
  String get invalidUrl => 'सही लिंक डालें';

  @override
  String get itemOptions => 'आइटम के विकल्प';

  @override
  String get itemUnavailable => 'अब उपलब्ध नहीं';

  @override
  String get jumpToNewest => 'सबसे नए पर जाएँ';

  @override
  String get justNow => 'अभी-अभी';

  @override
  String knownVideos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count वीडियो पता हैं',
      one: '1 वीडियो पता है',
      zero: 'अभी कुछ पता नहीं',
    );
    return '$_temp0';
  }

  @override
  String get language => 'भाषा';

  @override
  String get languageSystem => 'सिस्टम';

  @override
  String get languageSystemHint => 'आपके फ़ोन की भाषा अपनाता है';

  @override
  String lastBackup(String when) {
    return 'आखिरी बैकअप $when';
  }

  @override
  String lastCheckedAt(String when) {
    return 'आखिरी जाँच $when';
  }

  @override
  String get latestAdditions => 'हाल ही में जोड़े गए';

  @override
  String get licensedUnder => 'GPL-3.0 के तहत लाइसेंस';

  @override
  String get licenses => 'ओपन-सोर्स लाइसेंस';

  @override
  String get listSeparator => ', ';

  @override
  String get listenInBackground => 'बैकग्राउंड में सुनें';

  @override
  String get lockTouch => 'टच लॉक करें';

  @override
  String get loginDone => 'हो गया';

  @override
  String loginKept(String site) {
    return '$site में साइन इन है; डाउनलोड इसका इस्तेमाल करेंगे';
  }

  @override
  String get loginNotYet =>
      'अभी कोई साइन-इन नहीं मिला। साइन इन पूरा करें, फिर हो गया पर टैप करें';

  @override
  String get logsEmpty => 'लॉग खाली है';

  @override
  String get logsSanitizedNote =>
      'शेयर करने से पहले लिंक, पते और क्रेडेंशियल हटा दिए जाते हैं';

  @override
  String get manageTags => 'टैग मैनेज करें';

  @override
  String get mediaAccessBlockedMessage =>
      'Android फिर से नहीं पूछेगा। सिस्टम सेटिंग्स में इस ऐप के लिए फ़ोटो और वीडियो चालू करें, फिर वापस आएँ।';

  @override
  String get mediaAccessGrant => 'अनुमति दें';

  @override
  String get mediaAccessMessage =>
      'आपके डाउनलोड फ़ोन के Download फ़ोल्डर में रखे जाते हैं, और ऐप उन्हें दिखा सके इससे पहले Android को आपकी अनुमति चाहिए।';

  @override
  String get mediaAccessOpenSettings => 'सेटिंग्स खोलें';

  @override
  String get mediaAccessTitle => 'अपने मीडिया तक पहुँच दें';

  @override
  String get mobileChannelsEmptyBody =>
      'किसी चैनल को फ़ॉलो करें और VidHoist खुला या बैकग्राउंड में होने पर हर नया वीडियो अपने-आप डाउनलोड होगा; ऐप बंद रहने के दौरान जो आया, वह ऐप खुलने पर डाउनलोड होगा। चैनल पर पहले से मौजूद वीडियो डाउनलोड नहीं होते।';

  @override
  String get mobileChannelsHint =>
      'आपके फ़ॉलो किए चैनलों के नए वीडियो, अपने-आप डाउनलोड';

  @override
  String get mobileEngineIpv4 => 'IPv4 से कनेक्ट करें';

  @override
  String get mobileEngineIpv4Help =>
      'जिन नेटवर्क का IPv6 रूट खराब है, वहाँ लंबी रुकावट से बचाता है। इसे तभी बंद करें जब आपके नेटवर्क में सिर्फ़ IPv6 हो।';

  @override
  String mobileEngineLastUpdate(String when) {
    return 'आखिरी अपडेट $when';
  }

  @override
  String get mobileEngineNotReady => 'तैयार हो रहा है…';

  @override
  String get mobileEngineUpToDate => 'yt-dlp अप टू डेट है';

  @override
  String get mobileEngineUpdate => 'yt-dlp अपडेट करें';

  @override
  String get mobileEngineUpdateFailed =>
      'yt-dlp अपडेट नहीं हो सका। कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get mobileEngineUpdateMissed => 'अपडेट विफल रहा';

  @override
  String get mobileEngineUpdated => 'अपडेट हुआ';

  @override
  String get mobileEngineUpdating => 'अपडेट हो रहा है…';

  @override
  String get mobileEngineVersionLabel => 'yt-dlp वर्शन';

  @override
  String get mobileEngineVersionUnknown =>
      'इसका वर्शन पहले अपडेट के बाद दिखेगा';

  @override
  String get mobileSettingsEngine => 'डाउनलोड इंजन';

  @override
  String get mobileSettingsGroupEngine => 'इंजन';

  @override
  String get mobileSignInNeeded =>
      'यह साइट चाहती है कि आप साइन इन करें। सेटिंग्स › अकाउंट से साइन इन करें, फिर दोबारा कोशिश करें';

  @override
  String get mobileSubtitleOptions => 'साइज़, बैकग्राउंड और ट्रांसक्रिप्ट';

  @override
  String get mobileSubtitleStyleHelp => 'प्लेयर में भी: CC बटन दबाकर रखें।';

  @override
  String get mobileSubtitles => 'सबटाइटल डाउनलोड करें';

  @override
  String get mobileSubtitlesHelp =>
      'नीचे दी गई भाषाओं में सबटाइटल, अगर वीडियो में हों, उसके साथ सेव होते हैं और प्लेयर में दिखते हैं।';

  @override
  String get mobileSubtitlesSizeLarger => 'बड़ा';

  @override
  String get mobileTranscript => 'ट्रांसक्रिप्ट';

  @override
  String get mobileTranscriptHint =>
      'वहाँ से चलाने के लिए किसी लाइन पर टैप करें।';

  @override
  String get mobileTranscriptOpen => 'ट्रांसक्रिप्ट पढ़ें';

  @override
  String get mobileWelcomeBody =>
      'आपकी इस्तेमाल की जाने वाली साइटों के वीडियो और ऑडियो, सीधे इस फ़ोन पर सेव। डाउनलोड इंजन तैयार हो रहा है; ऐसा सिर्फ़ एक बार होता है।';

  @override
  String get mobileWelcomeFailed =>
      'इंजन शुरू नहीं हो सका। फिर कोशिश करें; अगर बार-बार विफल हो, तो ऐप दोबारा इंस्टॉल करें।';

  @override
  String get mobileWelcomeStart => 'शुरू करें';

  @override
  String get mobileWelcomeTitle => 'VidHoist में आपका स्वागत है';

  @override
  String get mobileWelcomeUnpacking => 'डाउनलोड इंजन तैयार हो रहा है';

  @override
  String get mobileWelcomeUpdateFailed =>
      'अभी अपडेट नहीं हो सका। VidHoist आपके पहले डाउनलोड से पहले फिर कोशिश करेगा।';

  @override
  String get mobileWelcomeUpdating =>
      'yt-dlp को नए वर्शन पर अपडेट किया जा रहा है';

  @override
  String get modeAutoNext => 'ऑटो';

  @override
  String get modeRepeatAll => 'सभी रिपीट करें';

  @override
  String get modeRepeatOne => 'एक रिपीट करें';

  @override
  String get modeStopAtEnd => 'आखिर में रुकें';

  @override
  String get navLibrary => 'लाइब्रेरी';

  @override
  String get navMyDownloads => 'मेरे डाउनलोड';

  @override
  String get navPlaylists => 'प्लेलिस्ट';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get needsAttention => 'आपका ध्यान चाहिए';

  @override
  String get neverChecked => 'अभी जाँच नहीं हुई';

  @override
  String get newFolder => 'नया फ़ोल्डर…';

  @override
  String get newFolderHint => 'जैसे Ai/पाठ';

  @override
  String get newPlaylistAction => 'नई प्लेलिस्ट';

  @override
  String get newTagHint => 'नया टैग';

  @override
  String newVideosBody(String channels) {
    return '$channels। ये VidHoist खोलने पर डाउनलोड होंगे।';
  }

  @override
  String newVideosNotice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नए वीडियो',
      one: '$count नया वीडियो',
    );
    return '$_temp0';
  }

  @override
  String get next => 'अगला';

  @override
  String get noBackupsYet => 'अभी कोई बैकअप नहीं';

  @override
  String get noDownloads => 'कोई डाउनलोड नहीं';

  @override
  String get noDownloadsMessage =>
      'डाउनलोड की गई क्लिप यहाँ दिखेंगी।\nकोई लिंक शेयर करें या लिंक जोड़ें बटन इस्तेमाल करें।';

  @override
  String get noExternalPlayer => 'इस डिवाइस पर कोई बाहरी प्लेयर नहीं';

  @override
  String get noFolder => 'कोई फ़ोल्डर नहीं';

  @override
  String get noFolderHint => 'डाउनलोड में सबसे ऊपर';

  @override
  String get noLogsFound => 'कोई लॉग नहीं मिला';

  @override
  String get noPlayableSource => 'इस आइटम का कोई चलाने लायक सोर्स नहीं है';

  @override
  String get noPlaylistsMessage =>
      'अपनी क्लिप व्यवस्थित करने के लिए प्लेलिस्ट बनाएँ';

  @override
  String get noResults => 'कोई नतीजा नहीं';

  @override
  String get noResultsMessage => 'आपकी खोज से कोई आइटम मेल नहीं खाता।';

  @override
  String get noServerTitle => 'डाउनलोड इंजन तैयार नहीं है';

  @override
  String get noticeChannelNewVideos => 'नए वीडियो';

  @override
  String get noticeChannelUpdates => 'अपडेट';

  @override
  String get noVideosFound => 'आपकी लाइब्रेरी खाली है';

  @override
  String get noWarranty => 'जैसा है वैसा दिया गया है, बिना किसी वारंटी के।';

  @override
  String get notAffiliated =>
      'yt-dlp या किसी भी साइट से जुड़ा नहीं है, और उनके द्वारा समर्थित नहीं है।';

  @override
  String get nothingHereYet => 'अभी यहाँ कुछ नहीं';

  @override
  String get notificationClipGone => 'यह क्लिप अब फ़ोन पर नहीं है।';

  @override
  String get nowPlaying => 'अभी चल रहा है';

  @override
  String get nowPlayingCollapse => 'प्लेयर पैनल छोटा करें';

  @override
  String get nowPlayingExpand => 'प्लेयर पैनल दिखाएँ';

  @override
  String get ok => 'ठीक है';

  @override
  String get onlyNewVideos =>
      'सिर्फ़ अब से आने वाले वीडियो डाउनलोड होंगे। चैनल पर पहले से मौजूद वीडियो जैसे हैं वैसे छोड़ दिए जाते हैं।';

  @override
  String get openChannel => 'चैनल खोलें';

  @override
  String get openInExternalPlayer => 'दूसरे प्लेयर में खोलें';

  @override
  String get openOriginalLink => 'असली लिंक खोलें';

  @override
  String get ownFolder => 'अपने अलग फ़ोल्डर में सेव करें';

  @override
  String get ownFolderNote =>
      'डाउनलोड फ़ोल्डर के अंदर एक फ़ोल्डर, जिसे Explorer और दूसरे ऐप भी देख सकते हैं। सिर्फ़ अब से आने वाला वहाँ जाएगा; जो पहले से डाउनलोड है, वहीं रहेगा।';

  @override
  String get pasteUrlHint => 'लिंक यहाँ पेस्ट करें…';

  @override
  String get pause => 'रोकें';

  @override
  String get pauseSubscription => 'रोकें';

  @override
  String get pcAddressLabel => 'पता';

  @override
  String get pcBadAddress =>
      'पता वैसे ही लिखें जैसे कंप्यूटर दिखाता है, जैसे 192.168.1.24।';

  @override
  String get pcBadQr => 'यह VidHoist पेयरिंग का QR कोड नहीं है।';

  @override
  String get pcCertificate => 'कंप्यूटर का सर्टिफ़िकेट';

  @override
  String get pcCodeLabel => 'कोड';

  @override
  String get pcConnected => 'कनेक्ट है';

  @override
  String get pcCopied => 'सबटाइटल के साथ फ़ोन की लाइब्रेरी में कॉपी हुआ।';

  @override
  String get pcCopyFailed =>
      'कॉपी पूरी नहीं हुई: कंप्यूटर बंद हो सकता है या पहुँच से बाहर। कुछ भी नहीं रखा गया।';

  @override
  String get pcCopyStarting => 'कॉपी हो रहा है…';

  @override
  String get pcCopyStop => 'कॉपी करना रोकें';

  @override
  String get pcCopyToPhone => 'फ़ोन पर कॉपी करें';

  @override
  String pcCopying(int percent) {
    return 'कॉपी हो रहा है $percent%';
  }

  @override
  String get pcDelete => 'कंप्यूटर से मिटाएँ';

  @override
  String pcDeleteBody(String title) {
    return '\"$title\" कंप्यूटर के Recycle Bin में चली जाती है, जहाँ से इसे वापस लाया जा सकता है।';
  }

  @override
  String get pcDeleteFailed =>
      'कंप्यूटर इसे मिटा नहीं सका। हो सकता है यह वहाँ खुली हो।';

  @override
  String get pcDeleteMissing => 'यह क्लिप अब कंप्यूटर पर नहीं है।';

  @override
  String get pcDeleteNoBin =>
      'नहीं मिटाई गई: कंप्यूटर पर इसकी ड्राइव में Recycle Bin नहीं है।';

  @override
  String get pcDeleteNotAllowed =>
      'कंप्यूटर फ़ोन को मिटाने नहीं देता। इसे वहाँ सेटिंग्स › फ़ोन में चालू करें।';

  @override
  String pcDeleteTitle(String name) {
    return '$name से मिटाएँ?';
  }

  @override
  String pcDeleted(String title) {
    return 'कंप्यूटर के Recycle Bin में: $title';
  }

  @override
  String get pcDestPhone => 'यह फ़ोन';

  @override
  String pcDoneOnPc(String title) {
    return 'कंप्यूटर पर पूरा हुआ: $title';
  }

  @override
  String pcDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'कंप्यूटर के लिए $count डाउनलोड',
      one: 'कंप्यूटर के लिए 1 डाउनलोड',
    );
    return '$_temp0';
  }

  @override
  String get pcDownloadsSheet => 'कंप्यूटर पर डाउनलोड';

  @override
  String get pcEmptyLibrary => 'कंप्यूटर पर अभी कोई डाउनलोड नहीं।';

  @override
  String get pcErrBad =>
      'कंप्यूटर ने ऐसा जवाब दिया जो यह वर्शन नहीं समझता। दोनों ऐप अपडेट करें।';

  @override
  String get pcErrClosed =>
      'कंप्यूटर पर कोई कोड नहीं दिख रहा, या उसकी मियाद खत्म हो गई। वहाँ फ़ोन पेयर करें दबाएँ।';

  @override
  String get pcErrDenied =>
      'कंप्यूटर पर पेयरिंग मना कर दी गई, या समय पर जवाब नहीं मिला।';

  @override
  String get pcErrRefused => 'कंप्यूटर ने यह लिंक नहीं लिया।';

  @override
  String get pcErrUnauthorized =>
      'कंप्यूटर अब इस फ़ोन को नहीं पहचानता। फिर से पेयर करें।';

  @override
  String get pcErrUnreachable =>
      'कंप्यूटर ने जवाब नहीं दिया। क्या वह चालू है, इसी नेटवर्क पर या आपके Tailscale पर, और \"फ़ोन से पाएँ\" चालू है?';

  @override
  String get pcErrWrongCertificate =>
      'इस पते पर आपके कंप्यूटर के बजाय किसी और ने जवाब दिया। कुछ नहीं भेजा गया।';

  @override
  String get pcErrWrongCode => 'गलत कोड।';

  @override
  String get pcFindNone =>
      'कोई कंप्यूटर नहीं मिला। कंप्यूटर पर पहले सेटिंग्स › फ़ोन › फ़ोन पेयर करें खोलें, उसी Wi-Fi पर।';

  @override
  String get pcFindOnNetwork => 'नेटवर्क पर ढूँढें';

  @override
  String get pcFirewallAllow => 'अनुमति दें';

  @override
  String get pcFirewallBlocked =>
      'Windows Firewall VidHoist को रोक रहा है, इसलिए फ़ोन उस तक नहीं पहुँच सकता। घरेलू (प्राइवेट) नेटवर्क पर इसे अनुमति दें।';

  @override
  String get pcFirewallMissing =>
      'Windows ने अभी तक VidHoist को फ़ोन से पाने की अनुमति नहीं दी है। एक बार अनुमति दें, सिर्फ़ घरेलू (प्राइवेट) नेटवर्क पर।';

  @override
  String get pcFirewallPublic =>
      'Windows इस नेटवर्क को पब्लिक मानता है, और वहाँ से कुछ भी अंदर नहीं आने देता। अगर यह आपका घरेलू नेटवर्क है, तो इसे प्राइवेट करें: सेटिंग्स › नेटवर्क और इंटरनेट › Wi-Fi › इसकी प्रॉपर्टी।';

  @override
  String get pcFirewallRefused =>
      'कुछ नहीं बदला: Windows को एडमिनिस्ट्रेटर की अनुमति चाहिए।';

  @override
  String get pcFirewallTitle => 'Windows Firewall';

  @override
  String pcFound(String name) {
    return '$name मिला। वह जो कोड दिखा रहा है, उसे लिखें।';
  }

  @override
  String pcFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मिले',
      one: '1 मिला',
    );
    return '$_temp0';
  }

  @override
  String pcLastContact(String time) {
    return 'आखिरी संपर्क $time';
  }

  @override
  String get pcLibrary => 'कंप्यूटर की लाइब्रेरी';

  @override
  String get pcLinkAddress => 'इस नेटवर्क पर पता';

  @override
  String get pcLinkAddressTailscale => 'Tailscale से, घर के बाहर से';

  @override
  String get pcLinkAllow => 'अनुमति दें';

  @override
  String get pcLinkAllowDelete => 'फ़ोन को क्लिप मिटाने दें';

  @override
  String get pcLinkAllowDeleteHint =>
      'फ़ोन से मिटाई गई क्लिप इस कंप्यूटर के Recycle Bin में जाती है, जहाँ से आप उसे वापस ला सकते हैं। जिस ड्राइव में Recycle Bin नहीं है, वहाँ वह नहीं मिटती।';

  @override
  String get pcLinkCodeHint =>
      'फ़ोन पर: सेटिंग्स › कंप्यूटर › QR कोड स्कैन करें। या वहाँ यह पता और कोड लिखें। यह एक बार, दो मिनट के लिए काम करता है।';

  @override
  String pcLinkCodeLeft(int seconds) {
    return '$seconds सेकंड बाकी';
  }

  @override
  String get pcLinkCodeTitle => 'पेयरिंग कोड';

  @override
  String get pcLinkDeny => 'मना करें';

  @override
  String get pcLinkDevices => 'पेयर किए गए फ़ोन';

  @override
  String pcLinkFailed(String error) {
    return 'शुरू नहीं हो सका: $error';
  }

  @override
  String get pcLinkIntro =>
      'अपने फ़ोन के VidHoist से इस कंप्यूटर पर लिंक भेजें, और इसके डाउनलोड और लाइब्रेरी वहाँ देखें। आपके घरेलू नेटवर्क में काम करता है, और उसके बाहर से Tailscale के ज़रिए।';

  @override
  String pcLinkLastSeen(String time) {
    return 'आखिरी बार संपर्क $time';
  }

  @override
  String get pcLinkNoDevices => 'अभी कोई फ़ोन नहीं।';

  @override
  String get pcLinkOff => 'बंद';

  @override
  String pcLinkOtherAddresses(int count) {
    return 'दूसरे पते ($count)';
  }

  @override
  String get pcLinkOtherAddressesHint =>
      'दूसरे प्रोग्राम के जोड़े नेटवर्क अडैप्टर, जैसे VirtualBox या WSL। फ़ोन को इनकी शायद ही कभी ज़रूरत होती है।';

  @override
  String get pcLinkPairPhone => 'फ़ोन पेयर करें';

  @override
  String pcLinkPairedAt(String time) {
    return 'पेयर हुआ $time';
  }

  @override
  String pcLinkPhones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ोन',
      one: 'एक फ़ोन',
      zero: 'कोई फ़ोन नहीं',
    );
    return '$_temp0';
  }

  @override
  String get pcLinkQrHint => 'फ़ोन से स्कैन करें';

  @override
  String get pcLinkReceive => 'फ़ोन से पाएँ';

  @override
  String get pcLinkReceiveHint =>
      'जब यह बंद होता है, तो इस कंप्यूटर पर कोई पोर्ट खुला नहीं रहता। अगर Windows पूछे, तो सिर्फ़ प्राइवेट नेटवर्क की अनुमति दें।';

  @override
  String pcLinkRequest(String name) {
    return '$name पेयर करना चाहता है';
  }

  @override
  String get pcLinkRequestHint =>
      'तभी अनुमति दें जब फ़ोन वही चार अंक दिखा रहा हो।';

  @override
  String get pcLinkRevoke => 'अनपेयर करें';

  @override
  String get pcLinkSecurity =>
      'फ़ोन इस कंप्यूटर से सीधे बात करता है, आपके नेटवर्क पर या आपके Tailscale के ज़रिए। यह एक बार पेयर होता है, कोड और यहाँ आपकी मंज़ूरी से; उसके बाद हर अनुरोध के साथ अपनी कुंजी दिखाता है, ऐसे कनेक्शन पर जो सिर्फ़ इस कंप्यूटर के सर्टिफ़िकेट से एन्क्रिप्ट होता है। नेटवर्क पर किसी और को बंद दरवाज़ा मिलता है।';

  @override
  String get pcLinkStarting => 'शुरू हो रहा है…';

  @override
  String get pcLinkTitle => 'फ़ोन';

  @override
  String get pcListEmpty => 'इस लिस्ट की कोई भी क्लिप अब कंप्यूटर पर नहीं है।';

  @override
  String get pcListen => 'सुनें';

  @override
  String get pcLists => 'कंप्यूटर की लिस्ट';

  @override
  String get pcListsEmpty => 'कंप्यूटर की किसी लिस्ट में क्लिप नहीं हैं।';

  @override
  String get pcNow => 'अभी कंप्यूटर पर';

  @override
  String get pcOffline => 'उपलब्ध नहीं';

  @override
  String get pcOfflineMessage =>
      'कंप्यूटर बंद है या दूसरे नेटवर्क पर है। पिछली बार उसमें जो था, वह नीचे दिखाया गया है।';

  @override
  String get pcOfflineRoute =>
      'घर से बाहर हैं? सेटिंग्स › कंप्यूटर में Tailscale चुनें।';

  @override
  String get pcOnPhone => 'फ़ोन पर';

  @override
  String get pcOrType => 'या पता और कोड लिखें';

  @override
  String get pcOutboxRefused => 'कंप्यूटर ने यह लिंक नहीं लिया';

  @override
  String pcOutboxTitle(int count) {
    return 'भेजने के इंतज़ार में ($count)';
  }

  @override
  String get pcPairButton => 'पेयर करें';

  @override
  String pcPairCheck(String check) {
    return 'देखें कि कंप्यूटर $check दिखा रहा है, फिर वहाँ फ़ोन को अनुमति दें।';
  }

  @override
  String get pcPairIntro =>
      'अगर आपके Windows कंप्यूटर पर VidHoist चलता है, तो यह फ़ोन उसे लिंक भेज सकता है और उसके डाउनलोड और लाइब्रेरी दिखा सकता है। कंप्यूटर पर सेटिंग्स › फ़ोन चालू करें और फ़ोन पेयर करें दबाएँ, फिर वह जो QR कोड दिखाए उसे स्कैन करें।';

  @override
  String pcPaired(String name) {
    return '$name से पेयर हुआ';
  }

  @override
  String get pcPortLabel => 'पोर्ट';

  @override
  String pcQueued(String name) {
    return '$name के वापस आने पर इसे भेजा जाएगा।';
  }

  @override
  String pcQueuedMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$name के वापस आने पर $count क्लिप भेजी जाएँगी।',
      one: '$name के वापस आने पर 1 क्लिप भेजी जाएगी।',
    );
    return '$_temp0';
  }

  @override
  String get pcRouteHint =>
      'घर से बाहर होने पर Tailscale चुनें; यह फ़ोन और कंप्यूटर दोनों पर चालू होना चाहिए।';

  @override
  String get pcRouteHome => 'घरेलू नेटवर्क';

  @override
  String get pcRouteOther => 'दूसरा नेटवर्क';

  @override
  String get pcRouteTailscale => 'Tailscale';

  @override
  String get pcRouteTitle => 'इससे कनेक्ट करें';

  @override
  String get pcRouteWaiting =>
      'कंप्यूटर के जवाब देने पर उसके दूसरे रास्ते यहाँ दिखेंगे।';

  @override
  String get pcScanButton => 'QR कोड स्कैन करें';

  @override
  String get pcScanFailed => 'कैमरा नहीं खुल सका।';

  @override
  String get pcScanPrompt =>
      'कैमरे को कंप्यूटर की स्क्रीन पर दिख रहे QR कोड की ओर करें';

  @override
  String get pcSearchHint => 'कंप्यूटर की लाइब्रेरी में खोजें';

  @override
  String get pcSendToPc => 'कंप्यूटर पर भेजें';

  @override
  String pcSent(String name) {
    return '$name को भेजा गया';
  }

  @override
  String pcSentMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$name को $count क्लिप भेजी गईं',
      one: '$name को 1 क्लिप भेजी गई',
    );
    return '$_temp0';
  }

  @override
  String get pcSettingsHint => 'अपने कंप्यूटर पर लिंक भेजें';

  @override
  String get pcTab => 'कंप्यूटर';

  @override
  String pcVia(String route) {
    return '$route से';
  }

  @override
  String get pcWatch => 'देखें';

  @override
  String get pcWillSend => 'उपलब्ध नहीं: वापस आने पर भेजा जाएगा';

  @override
  String get pickAnotherFile => 'दूसरी फ़ाइल से…';

  @override
  String get pickAnotherFileSubtitle => 'दूसरे फ़ोन या पुराने वर्शन का बैकअप';

  @override
  String get pictureInPicture => 'पिक्चर-इन-पिक्चर';

  @override
  String get pictureInPictureHelp =>
      'क्लिप चलते समय ऐप से बाहर जाने पर वह स्क्रीन के एक कोने में दिखती रहती है';

  @override
  String get pinPlaylist => 'ऊपर पिन करें';

  @override
  String get platform => 'साइट';

  @override
  String platformCount(Object name, int count) {
    return '$name · $count';
  }

  @override
  String get platformOther => 'अन्य';

  @override
  String get play => 'चलाएँ';

  @override
  String get playAll => 'सभी चलाएँ';

  @override
  String get playModeLabel => 'मोड';

  @override
  String get playbackSpeed => 'प्लेबैक स्पीड';

  @override
  String get playerError => 'यह फ़ाइल नहीं चल सकी';

  @override
  String get playingFromDevice => 'आपके डिवाइस से चल रहा है';

  @override
  String get playlist => 'प्लेलिस्ट';

  @override
  String get playlistAddClips => 'क्लिप जोड़ें';

  @override
  String playlistAddClipsTo(String name) {
    return '“$name” में जोड़ें';
  }

  @override
  String playlistAddCount(int count) {
    return 'जोड़ें ($count)';
  }

  @override
  String get playlistCreated => 'प्लेलिस्ट बनाई गई';

  @override
  String get playlistDeleted => 'प्लेलिस्ट मिटाई गई';

  @override
  String get playlistDetails => 'प्लेलिस्ट की जानकारी';

  @override
  String get playlistEditHint =>
      'क्लिप को खिसकाने के लिए उसे देर तक दबाएँ। हटाने के लिए उसे एक तरफ़ स्वाइप करें।';

  @override
  String get playlistName => 'प्लेलिस्ट का नाम';

  @override
  String get playlistNameHint => 'मेरी प्लेलिस्ट';

  @override
  String playlistOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get playlists => 'प्लेलिस्ट';

  @override
  String get previous => 'पिछला';

  @override
  String get quality => 'क्वालिटी';

  @override
  String get quality1080 => '1080p तक';

  @override
  String get quality360 => '360p तक';

  @override
  String get quality480 => '480p तक';

  @override
  String get quality720 => '720p तक';

  @override
  String get qualityAudio => 'ऑडियो';

  @override
  String get qualityBest => 'सबसे अच्छी';

  @override
  String get qualityHelper =>
      'क्विक डाउनलोड, पूरी प्लेलिस्ट के डाउनलोड, और क्लिपबोर्ड बार के \"डाउनलोड करें\" में इसका इस्तेमाल होता है, और लिंक जोड़ने वाली शीट में यही पहले से चुना रहता है। इसलिए क्विक डाउनलोड चालू हो या न हो, यह मायने रखता है।';

  @override
  String get qualityReading => 'फ़ाइल पढ़ी जा रही है…';

  @override
  String get qualityUnavailable => 'उपलब्ध नहीं';

  @override
  String get qualityVideo => 'वीडियो';

  @override
  String queueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम',
      one: '1 आइटम',
      zero: 'कोई आइटम नहीं',
    );
    return '$_temp0';
  }

  @override
  String get queueLabel => 'कतार';

  @override
  String queuePosition(int position) {
    return 'कतार में नंबर $position';
  }

  @override
  String get queued => 'कतार में';

  @override
  String get queuedSection => 'इंतज़ार में';

  @override
  String get quickDownload => 'क्विक डाउनलोड';

  @override
  String get quickDownloadHelp =>
      'शेयर या पेस्ट किया गया लिंक बिना किसी शीट के, डिफ़ॉल्ट क्वालिटी में तुरंत डाउनलोड होने लगता है। जिस साइट पर वह क्वालिटी नहीं है, वह अपनी सबसे अच्छी देती है, और \"सिर्फ़ ऑडियो\" हर साइट पर काम करता है।';

  @override
  String get rateLimit => 'स्पीड लिमिट';

  @override
  String get rateLimitNone => 'कोई लिमिट नहीं';

  @override
  String rateLimitValue(int mb) {
    return '$mb MB/s';
  }

  @override
  String get reelsEndBack => 'लाइब्रेरी पर वापस';

  @override
  String get reelsEndContinue => 'लिस्ट का बाकी हिस्सा जारी रखें';

  @override
  String get reelsEndReplay => 'शुरू से फिर चलाएँ';

  @override
  String get reelsEndTitle => 'Shorts खत्म';

  @override
  String get reelsSwipeHint => 'अगले Shorts वीडियो के लिए ऊपर स्वाइप करें';

  @override
  String get refresh => 'रिफ़्रेश करें';

  @override
  String get remove => 'हटाएँ';

  @override
  String get removeFromFavorites => 'पसंदीदा से हटाएँ';

  @override
  String removeUnavailable(int count) {
    return '$count अनुपलब्ध हटाएँ';
  }

  @override
  String get removedFromFavorites => 'पसंदीदा से हटाया गया';

  @override
  String get removedFromPlaylist => 'प्लेलिस्ट से हटाया गया';

  @override
  String get rename => 'नाम बदलें';

  @override
  String get renameTag => 'टैग का नाम बदलें';

  @override
  String get reportBug => 'बग रिपोर्ट करें';

  @override
  String get restoreConfirm =>
      'बैकअप फ़ाइल से डेटा रीस्टोर करें? इससे मौजूदा प्लेलिस्ट, टैग और सेटिंग्स बदल जाएँगी।';

  @override
  String get restoreData => 'रीस्टोर करें';

  @override
  String get restoreFailed => 'रीस्टोर विफल रहा: बैकअप फ़ाइल सही नहीं है';

  @override
  String get restorePickBody =>
      'इस फ़ोन में VidHoist के डाउनलोड हैं पर कोई सेटिंग्स नहीं, जैसा दोबारा इंस्टॉल करने के बाद होता है। अगर आपने बैकअप रखा है, तो उसे चुनें: ऐप उन्हें Download/VidHoist/backups में लिखता है।';

  @override
  String get restorePickChoose => 'बैकअप चुनें';

  @override
  String get restorePickTitle => 'अपनी सेटिंग्स वापस लाएँ?';

  @override
  String get restoreSettings => 'सारा डेटा रीस्टोर करें';

  @override
  String get restoreSuccess => 'डेटा रीस्टोर हो गया';

  @override
  String get resumeSubscription => 'फिर से शुरू करें';

  @override
  String get retry => 'फिर कोशिश करें';

  @override
  String get saveSettings => 'सेटिंग्स सेव करें';

  @override
  String get searchLogs => 'लॉग में खोजें…';

  @override
  String get searchVideos => 'क्लिप खोजें…';

  @override
  String get seekBackward10 => '10 सेकंड पीछे';

  @override
  String get seekForward10 => '10 सेकंड आगे';

  @override
  String get selectAll => 'सभी चुनें';

  @override
  String selected(int count) {
    return '$count चुने गए';
  }

  @override
  String selectedCount(int count) {
    return '$count चुने गए';
  }

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get settingsAccounts => 'अकाउंट';

  @override
  String get settingsBackup => 'बैकअप';

  @override
  String get settingsDownloads => 'डाउनलोड';

  @override
  String get settingsGroupApp => 'ऐप';

  @override
  String get settingsGroupData => 'डेटा';

  @override
  String get settingsPlayback => 'प्लेबैक';

  @override
  String get settingsTranscripts => 'ट्रांसक्रिप्ट और सबटाइटल';

  @override
  String settingsValueChannels(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count चैनल',
      one: '1 चैनल',
      zero: 'अभी कोई चैनल नहीं',
    );
    return '$_temp0';
  }

  @override
  String get settingsValueCompatOff => 'सबसे अच्छी कम्पैटिबिलिटी: बंद';

  @override
  String get settingsValueCompatOn => 'सबसे अच्छी कम्पैटिबिलिटी: चालू';

  @override
  String get settingsValueNotSet => 'अभी सेट नहीं';

  @override
  String get settingsValueQuick => 'क्विक';

  @override
  String settingsValueSignedIn(String sites) {
    return 'साइन इन: $sites';
  }

  @override
  String get settingsValueWifiOnly => 'सिर्फ़ Wi‑Fi';

  @override
  String get share => 'शेयर करें';

  @override
  String get shareLogs => 'लॉग शेयर करें';

  @override
  String get shareOpening => 'शेयर मेन्यू खुल रहा है…';

  @override
  String get shareOpeningHint => 'बड़ी फ़ाइल सौंपने में कुछ सेकंड लगते हैं।';

  @override
  String get shareSelected => 'चुने हुए शेयर करें';

  @override
  String get sharedLinksAdd => 'इन्हें जोड़ें';

  @override
  String get sharedLinksBody => 'हर एक इस फ़ोन पर डाउनलोड होगा।';

  @override
  String sharedLinksCapped(int max) {
    return 'सिर्फ़ पहले $max लिंक जोड़े गए।';
  }

  @override
  String sharedLinksTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लिंक जोड़ें?',
      one: '1 लिंक जोड़ें?',
    );
    return '$_temp0';
  }

  @override
  String get shortsFilter => 'Shorts';

  @override
  String get shuffle => 'शफ़ल';

  @override
  String get signInRequired => 'साइन इन ज़रूरी है';

  @override
  String get size => 'साइज़';

  @override
  String get smartPlaylists => 'स्मार्ट प्लेलिस्ट';

  @override
  String get sortAndPlatform => 'क्रम और साइट';

  @override
  String get sortBy => 'क्रम';

  @override
  String get sortLargest => 'सबसे बड़ी';

  @override
  String get sortNameAZ => 'नाम A–Z';

  @override
  String get sortNameZA => 'नाम Z–A';

  @override
  String get sortNewest => 'सबसे नई';

  @override
  String get sortOldest => 'सबसे पुरानी';

  @override
  String get sortSmallest => 'सबसे छोटी';

  @override
  String get sortedByLastPlayed => 'आखिरी बार चलाने के हिसाब से';

  @override
  String get source => 'सोर्स';

  @override
  String get sourceCode => 'सोर्स कोड';

  @override
  String get starAskBody =>
      'मुफ़्त और ओपन सोर्स, बिना विज्ञापन और बिना खाते के। GitHub पर एक स्टार दूसरों को इसे ढूँढने में मदद करता है।';

  @override
  String get starAskIdeas => 'कोई सुझाव दें या समस्या बताएँ';

  @override
  String get starAskLater => 'शायद बाद में';

  @override
  String get starAskNever => 'फिर से न दिखाएँ';

  @override
  String get starAskStar => 'GitHub पर स्टार दें';

  @override
  String get starAskTitle => 'क्या VidHoist पसंद आया?';

  @override
  String get startDownload => 'डाउनलोड शुरू करें';

  @override
  String get status => 'स्थिति';

  @override
  String get storageCardMissing =>
      'कार्ड नहीं लगा है, इसलिए डाउनलोड फ़ोन में जाते हैं';

  @override
  String get storageLocation => 'यहाँ सेव करें';

  @override
  String get storageLocationHelp =>
      'पहले से डाउनलोड क्लिप जहाँ हैं वहीं रहती हैं और लाइब्रेरी में दिखती रहती हैं। मेमोरी कार्ड के लिए Android 11 या उसके बाद का वर्शन चाहिए।';

  @override
  String get storageNoCard => 'इस फ़ोन में कोई मेमोरी कार्ड नहीं';

  @override
  String get storagePhone => 'फ़ोन स्टोरेज';

  @override
  String get streamingOnline => 'नेटवर्क पर चल रहा है';

  @override
  String subscriptionAdded(String name) {
    return 'अब $name को फ़ॉलो कर रहे हैं';
  }

  @override
  String get subscriptionName => 'नाम';

  @override
  String get subscriptionPaused => 'रुका हुआ';

  @override
  String get subscriptionQuality => 'इस चैनल के लिए क्वालिटी';

  @override
  String get subscriptionQualityHelp =>
      'इस चैनल के नए वीडियो इसी क्वालिटी में डाउनलोड होते हैं। आप चैनल को बदलकर इसे बाद में बदल सकते हैं; पहले से डाउनलोड वीडियो अपनी क्वालिटी में रहते हैं।\n\n\"सबसे अच्छी\" का मतलब AV1 फ़ॉर्मैट में 4K हो सकता है, जो पुराने कंप्यूटर पर अटक-अटक कर चल सकता है: ऐसा हो तो 1080p चुनें।';

  @override
  String get subscriptionQualityNote =>
      'नए वीडियो पर लागू होता है; पहले से डाउनलोड वीडियो अपनी क्वालिटी में रहते हैं।';

  @override
  String get subscriptions => 'चैनल';

  @override
  String get subscriptionsEmpty => 'अभी कोई चैनल फ़ॉलो नहीं किया';

  @override
  String get subscriptionsEmptyBody =>
      'किसी चैनल को फ़ॉलो करें और VidHoist खुला या ट्रे में होने पर हर नया वीडियो अपने-आप आपकी लाइब्रेरी में डाउनलोड होगा। चैनल पर पहले से मौजूद वीडियो डाउनलोड नहीं होते।';

  @override
  String get subscriptionsSubtitle =>
      'आपके फ़ॉलो किए चैनलों के नए वीडियो, अपने-आप डाउनलोड';

  @override
  String get subtitleLangs => 'सबटाइटल की भाषाएँ';

  @override
  String get subtitleLangsHelp =>
      'वीडियो में हों तो लाए जाते हैं। कम से कम एक चुनी रहती है।';

  @override
  String get subtitles => 'सबटाइटल';

  @override
  String get subtitlesBackground => 'बैकग्राउंड';

  @override
  String get subtitlesBackgroundFaint => 'हल्का';

  @override
  String get subtitlesBackgroundHelp =>
      'शब्दों के पीछे क्या रहे। कुछ न हो तो हर अक्षर का किनारा गहरा रहता है ताकि चमकीली तस्वीर पर भी पढ़ा जा सके।';

  @override
  String get subtitlesBackgroundNone => 'कोई नहीं';

  @override
  String get subtitlesBackgroundSolid => 'गहरा';

  @override
  String get subtitlesHide => 'सबटाइटल छिपाएँ';

  @override
  String get subtitlesLanguage => 'सबटाइटल की भाषा';

  @override
  String get subtitlesShow => 'सबटाइटल दिखाएँ';

  @override
  String get subtitlesShowHelp =>
      'वीडियो के ऊपर, उन क्लिप के लिए जिनकी ट्रांसक्रिप्ट है। प्लेयर का CC बटन भी यही करता है।';

  @override
  String get subtitlesSize => 'टेक्स्ट का साइज़';

  @override
  String get subtitlesSizeLarge => 'बड़ा';

  @override
  String get subtitlesSizeMedium => 'मध्यम';

  @override
  String get subtitlesSizeSmall => 'छोटा';

  @override
  String tagLimitReached(int max) {
    return 'आप ज़्यादा से ज़्यादा $max टैग रख सकते हैं। नया जोड़ने के लिए टैग मैनेज करें में से एक हटाएँ।';
  }

  @override
  String get tags => 'टैग';

  @override
  String get tagsOpenFiltered => 'फ़िल्टर के साथ लाइब्रेरी खोलता है';

  @override
  String get theme => 'थीम';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get titleFilter => 'सिर्फ़ इन शब्दों वाले टाइटल डाउनलोड करें';

  @override
  String get titleFilterHelp =>
      'इस चैनल का नया वीडियो तभी डाउनलोड होता है जब उसके टाइटल में वह हो जो आप यहाँ लिखते हैं।\n\n• एक सादा शब्द काफ़ी है: Episode\n• कई शब्दों में से कोई भी: Episode|Part (| का मतलब है \"या\")\n• छोटे-बड़े अक्षर से फ़र्क नहीं पड़ता: episode भी Episode से मेल खाता है।\n\nजिस वीडियो को फ़िल्टर छोड़ देता है, वह हमेशा के लिए देखा हुआ माना जाता है: बाद में फ़िल्टर हटाने पर उसके बाद आने वाले वीडियो डाउनलोड होते हैं, छोड़े गए नहीं।';

  @override
  String get titleFilterHelper =>
      'कई शब्द: उन्हें | से अलग करें। सब कुछ के लिए खाली छोड़ें।';

  @override
  String get titleFilterHint => 'जैसे Episode';

  @override
  String get titleLabel => 'टाइटल';

  @override
  String totalDuration(Object duration) {
    return 'कुल: $duration';
  }

  @override
  String get transcript => 'ट्रांसक्रिप्ट';

  @override
  String transcriptSaidMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बार और कहा गया',
      one: 'एक बार और कहा गया',
    );
    return '$_temp0';
  }

  @override
  String transcriptsClips(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count क्लिप',
      one: '1 क्लिप',
      zero: 'अभी कोई क्लिप नहीं',
    );
    return '$_temp0';
  }

  @override
  String get transcriptsDeleteAll => 'सभी मिटाएँ';

  @override
  String get transcriptsDeleteTitle => 'सभी ट्रांसक्रिप्ट मिटाएँ?';

  @override
  String get transcriptsSaidInside => 'क्लिप के अंदर कहा गया';

  @override
  String get transcriptsSearchHelp =>
      'आपकी जोड़ी हर YouTube क्लिप के शब्द रखता है, ताकि आप खोज सकें कि क्या कहा गया।';

  @override
  String get tryAgain => 'फिर कोशिश करें';

  @override
  String get undo => 'पहले जैसा करें';

  @override
  String get unfollow => 'अनफ़ॉलो करें';

  @override
  String unfollowConfirm(String name) {
    return '$name को अनफ़ॉलो करें?';
  }

  @override
  String get unfollowConfirmBody =>
      'VidHoist भूल जाता है कि इस चैनल के कौन-से वीडियो वह देख चुका है। अगर आप बाद में इसे फिर फ़ॉलो करते हैं, तो तब तक इस पर जो भी है वह देखा हुआ माना जाएगा, और जो छूट गया वह नहीं भरा जाएगा। रोकने पर यह याद बनी रहती है।';

  @override
  String get unlockTouch => 'अनलॉक करें';

  @override
  String get unpinPlaylist => 'अनपिन करें';

  @override
  String get updateNoticeBody => 'इंस्टॉल करने के लिए VidHoist खोलें।';

  @override
  String get upNext => 'आगे';

  @override
  String upNextIn(String name) {
    return '«$name» में आगे';
  }

  @override
  String get updateAllowInstallBody =>
      'ऐप अपने अपडेट इंस्टॉल कर सके, इससे पहले Android को आपकी अनुमति चाहिए। सिस्टम सेटिंग्स में एक बार अनुमति दें, फिर इंस्टॉल करें पर दोबारा टैप करें।';

  @override
  String get updateAllowInstallTitle => 'अपडेट इंस्टॉल करने दें';

  @override
  String get updateAvailable => 'अपडेट उपलब्ध है';

  @override
  String get updateCheckFailed => 'अपडेट नहीं जाँचे जा सके';

  @override
  String get updateChecking => 'जाँच हो रही है…';

  @override
  String get updateDownloadFailed => 'अपडेट डाउनलोड नहीं हो सका';

  @override
  String updateDownloadedMb(String done, String total) {
    return '$total MB में से $done';
  }

  @override
  String get updateDownloading => 'अपडेट डाउनलोड हो रहा है…';

  @override
  String get updateFailedToStart => 'इंस्टॉलर नहीं खुल सका';

  @override
  String get updateInstall => 'इंस्टॉल करें';

  @override
  String get updateLater => 'बाद में';

  @override
  String get updateNever => 'अभी नहीं';

  @override
  String get updateNow => 'अपडेट डाउनलोड करें';

  @override
  String get updateOpenSystemSettings => 'सेटिंग्स खोलें';

  @override
  String get updateReady => 'इंस्टॉल के लिए तैयार';

  @override
  String updateSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get updateSkipVersion => 'यह वर्शन छोड़ें';

  @override
  String get updateUpToDate => 'आप नए वर्शन पर हैं';

  @override
  String updateVersionAvailable(String version) {
    return 'वर्शन $version उपलब्ध है';
  }

  @override
  String updateVersionTitle(String version) {
    return 'वर्शन $version';
  }

  @override
  String get updateWhatsNew => 'नया क्या है';

  @override
  String get updates => 'अपडेट';

  @override
  String get version => 'वर्शन';

  @override
  String get videoAdded => 'प्लेलिस्ट में जोड़ा गया';

  @override
  String get videoPlayer => 'वीडियो प्लेयर';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get viewAllInPlaylists => 'सभी देखें';

  @override
  String get viewCards => 'कार्ड';

  @override
  String get viewGrid => 'ग्रिड';

  @override
  String get viewList => 'लिस्ट';

  @override
  String get viewMode => 'व्यू';

  @override
  String get waitingForWifi => 'Wi-Fi का इंतज़ार';

  @override
  String get whatsNewGotIt => 'समझ गया';

  @override
  String get whatsNewReleasePage => 'रिलीज़ पेज';

  @override
  String get whatsNewThisVersion => 'इस वर्शन में नया क्या है';

  @override
  String whatsNewTitle(String version) {
    return '$version में नया क्या है';
  }

  @override
  String get whatsNewUnavailable =>
      'इस वर्शन में क्या बदला, यह रिलीज़ पेज पर है।';

  @override
  String get wifiOnly => 'सिर्फ़ Wi-Fi पर डाउनलोड करें';

  @override
  String get wifiOnlyHelp =>
      'मोबाइल डेटा पर कुछ डाउनलोड नहीं होता। डाउनलोड Wi-Fi का इंतज़ार करते हैं, और Wi-Fi कटने पर चल रहा डाउनलोड रुक जाता है और लौटने पर अपने-आप आगे बढ़ता है।';

  @override
  String get yourPlaylists => 'आपकी प्लेलिस्ट';

  @override
  String get yourTags => 'आपके टैग';

  @override
  String get ytdlpCredit => 'VidHoist जिस डाउनलोडर को चलाता है';
}
