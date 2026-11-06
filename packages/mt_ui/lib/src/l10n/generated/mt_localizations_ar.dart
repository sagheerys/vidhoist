// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'mt_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class MTLocalizationsAr extends MTLocalizations {
  MTLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get about => 'عن التطبيق';

  @override
  String get aboutApp => 'عن التطبيق';

  @override
  String get aboutDescriptionLite =>
      'تطبيق خفيف وسريع لتحميل الفيديو والصوت من مختلف المنصات بـyt-dlp، إلى جهازك مباشرة بلا سيرفر بينهما، وفيه مشغل مدمج وقوائم تشغيل.';

  @override
  String get aboutDescriptionSuper =>
      'نسخة ويندوز: مكتبة محلية بوسوم وقوائم ونصوص وتحميل دفعي، كلها على هذا الكمبيوتر.';

  @override
  String get activeDownloads => 'التحميلات النشطة';

  @override
  String activeDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تحميلاً جارياً',
      few: '$count تحميلات جارية',
      two: 'تحميلان جاريان',
      one: 'تحميل واحد جارٍ',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloadsSheet => 'التحميلات الجارية';

  @override
  String get activeNow => 'نشط الآن';

  @override
  String get addLinkFab => 'إضافة رابط';

  @override
  String get addTo => 'أضف إلى…';

  @override
  String get addToFavorites => 'أضف للمفضلة';

  @override
  String get addToPlaylist => 'إضافة إلى قائمة';

  @override
  String get addUrl => 'إضافة رابط';

  @override
  String addedNToServer(int count) {
    return 'أُضيف $count إلى التنزيلات';
  }

  @override
  String get addedToFavorites => 'أُضيف إلى المفضلة';

  @override
  String addedToPlaylistCount(int count) {
    return 'أُضيف $count إلى القائمة';
  }

  @override
  String get allDownloadsFinished => 'اكتملت جميع التحميلات';

  @override
  String get allFolders => 'كل المجلدات';

  @override
  String get allPlatforms => 'كل المنصات';

  @override
  String get alreadyInPlaylist => 'موجود في القائمة';

  @override
  String get alreadySubscribed => 'أنت تتابع هذه القناة بالفعل';

  @override
  String get appTitle => 'Vidhoist';

  @override
  String get appearanceAndLanguage => 'المظهر واللغة';

  @override
  String audioChannels(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قناة',
      many: '$count قناة',
      few: '$count قنوات',
      two: 'قناتان',
      one: 'قناة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get audioMono => 'أحادي';

  @override
  String get audioOnly => 'صوت فقط';

  @override
  String get audioStereo => 'ستيريو';

  @override
  String get authentication => 'تسجيل الدخول (اختياري)';

  @override
  String get autoBuilt => 'تلقائية';

  @override
  String get autoCheckUpdates => 'التحقق تلقائياً';

  @override
  String get autoCheckUpdatesHelp =>
      'يبحث عن إصدار جديد في الخلفية مرتين يومياً تقريباً.';

  @override
  String get autoRestoreSuccess =>
      'استُعيدت البيانات من النسخة الاحتياطية بنجاح';

  @override
  String get autoRetry => 'إعادة المحاولة عند عودة الشبكة';

  @override
  String get autoRetryHelp =>
      'إذا فشل تحميل بسبب انقطاع الشبكة أعاده التطبيق تلقائياً حين تعود. أما ما رفضه الموقع فلا يُعاد، لأن تكراره دون تغيير سيفشل مجدداً.';

  @override
  String get availability => 'التوفّر';

  @override
  String get availabilityOffline => 'بلا اتصال (نسخة محلية)';

  @override
  String get backgroundDownload => 'جارٍ تحميل الملفات في الخلفية…';

  @override
  String get backupNote =>
      'تشمل النسخة القوائم والوسوم وفهرس المقاطع المتاحة دون اتصال وروابط الأغلفة والإعدادات، ولا تشمل أبداً اسم المستخدم وكلمة المرور، ولا ملفات الوسائط نفسها.';

  @override
  String get backupSettings => 'نسخ جميع البيانات احتياطياً';

  @override
  String get backupSettingsSubtitle =>
      'سبع نسخ مؤرَّخة تتجدد وحدها، استعِد أيّاً منها أو صدّر نسخة لمشاركتها';

  @override
  String backupSuccess(Object path) {
    return 'حُفظت النسخة في: $path';
  }

  @override
  String backupsKept(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نسخة محفوظة',
      many: '$count نسخة محفوظة',
      few: '$count نسخ محفوظة',
      two: 'نسختان محفوظتان',
      one: 'نسخة واحدة محفوظة',
    );
    return '$_temp0';
  }

  @override
  String get batchDownloadSelected => 'تحميل المحدد';

  @override
  String get batchLoading => 'جارٍ قراءة القائمة…';

  @override
  String get batchNothingSelected => 'اختر عنصراً واحداً على الأقل';

  @override
  String batchSelectedOf(int selected, int total) {
    return 'حُدِّد $selected من $total';
  }

  @override
  String get batchThisVideoOnly => 'تحميل هذا المقطع فقط';

  @override
  String get batchTitle => 'التحميل الدفعي';

  @override
  String bitrateKbps(String value) {
    return '$value كيلوبت/ث';
  }

  @override
  String bitrateMbps(String value) {
    return '$value ميغابت/ث';
  }

  @override
  String get builtWith => 'بُني باستخدام';

  @override
  String get cancel => 'إلغاء';

  @override
  String get changeQuality => 'تغيير الجودة';

  @override
  String get channelNameFolder => 'باسم القناة';

  @override
  String get channelUrl => 'رابط قناة أو قائمة';

  @override
  String get channelUrlHint => 'https://www.youtube.com/@name';

  @override
  String chapterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل',
      many: '$count فصلاً',
      few: '$count فصول',
      two: 'فصلان',
      one: 'فصل واحد',
    );
    return '$_temp0';
  }

  @override
  String chapterNumber(int number) {
    return 'الفصل $number';
  }

  @override
  String get chaptersFold => 'إخفاء الفصول';

  @override
  String chaptersFromTranscript(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل من نص المقطع',
      many: '$count فصلاً من نص المقطع',
      few: '$count فصول من نص المقطع',
      two: 'فصلان من نص المقطع',
      one: 'فصل واحد من نص المقطع',
    );
    return '$_temp0';
  }

  @override
  String get chaptersShowAll => 'عرض كل الفصول';

  @override
  String get chaptersUnfold => 'إظهار الفصول';

  @override
  String get checkEvery => 'معدّل الفحص';

  @override
  String get checkForUpdates => 'التحقق من التحديثات';

  @override
  String get checkNow => 'افحص الآن';

  @override
  String get checkQueued => 'بدأ الفحص، وسيظهر أي جديد في المكتبة.';

  @override
  String get chooseFolder => 'اختر المجلد';

  @override
  String get chooseOptions => 'خيارات';

  @override
  String get clear => 'مسح';

  @override
  String get clearLogs => 'مسح السجلّات';

  @override
  String get clearLogsConfirm => 'حذف كل سجلّات التشخيص؟';

  @override
  String get clipboardFound => 'رابط جاهز في الحافظة';

  @override
  String get clipboardLinkReady => 'لصق الرابط';

  @override
  String get closePlayer => 'إغلاق المشغل';

  @override
  String get columnAdded => 'تاريخ الإضافة';

  @override
  String get columnLength => 'المدة';

  @override
  String get compactView => 'عرض مختصر';

  @override
  String get compatiblePlayback => 'أفضل توافق للتشغيل';

  @override
  String get compatiblePlaybackHelp =>
      'يطلب صيغة H.264/AAC التي تشغّلها كل الهواتف بعتادها مباشرة. وإن أطفأته أتاح لك أعلى دقة، لكن يوتيوب قد يرسل حينها صيغة AV1 فتظهر الصورة مشوّشة على أجهزة كثيرة.';

  @override
  String get completed => 'مكتمل';

  @override
  String get continueAsAudio => 'متابعة بالصوت فقط';

  @override
  String get continueAsAudioBody =>
      'هل تريد متابعة تشغيله صوتاً فقط من اللحظة نفسها؟';

  @override
  String get continueAsAudioNo => 'لا، أوقف';

  @override
  String get continueAsAudioTitle => 'متابعة في الخلفية؟';

  @override
  String get cookies => 'الكوكيز';

  @override
  String get cookiesHelp =>
      'ثبّت في متصفحك إضافة تصدّر الكوكيز بصيغة Netscape، وصدّر ملفاً لكل منصة، ثم اختر الملفات هنا. سيستعملها السيرفر بعد ذلك في كل تحميل، ويقرر yt-dlp متى يحتاج إليها. وللكوكيز مدة صلاحية، فإذا عاد التحميل إلى الفشل فغالباً حان وقت تصديرها من جديد.';

  @override
  String get cookiesNotNetscape =>
      'لا يحوي أيٌّ من هذه الملفات كوكيز بصيغة Netscape';

  @override
  String get cookiesSubtitle => 'للمنصات التي ترفض التحميل بلا تسجيل دخول';

  @override
  String get cookiesWhat =>
      'بعض المنصات لا تسمح بتحميل المقطع إلا إذا بدا الطلب قادماً من متصفح سُجّل فيه الدخول، وملف الكوكيز المصدَّر من متصفحك يمنح السيرفر هذه الصفة.';

  @override
  String get copiedToClipboard => 'نُسِخ إلى الحافظة';

  @override
  String get copyright => '© 2026 ياسر صغير';

  @override
  String get couldNotLoadPlaylist =>
      'تعذّر فتح هذه القائمة. تحقّق من الرابط ومن اتصالك.';

  @override
  String get create => 'إنشاء';

  @override
  String get createPlaylist => 'إنشاء قائمة';

  @override
  String get creator => 'صانع المحتوى';

  @override
  String get defaultQuality => 'جودة الفيديو الافتراضية';

  @override
  String get delete => 'حذف';

  @override
  String deleteMultipleConfirm(int count) {
    return 'حذف $count فيديو؟\n\nستُزال الملفات من جهازك.';
  }

  @override
  String deletePlaylistConfirm(Object name) {
    return 'حذف «$name»؟';
  }

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get deleteTag => 'حذف الوسم';

  @override
  String deleteTagConfirm(Object tag) {
    return 'حذف الوسم «$tag» من كل العناصر؟ لن تُحذف الفيديوهات نفسها.';
  }

  @override
  String get deleteVideo => 'حذف الفيديو';

  @override
  String deleteVideoConfirm(Object title) {
    return 'حذف «$title»؟\n\nسيُزال الملف من جهازك.';
  }

  @override
  String deletedCount(Object count) {
    return 'حُذف $count';
  }

  @override
  String deletedTitle(Object title) {
    return 'تم الحذف: $title';
  }

  @override
  String get deselectAll => 'إلغاء التحديد';

  @override
  String desktopAddLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أضف $count رابط',
      many: 'أضف $count رابطاً',
      few: 'أضف $count روابط',
      two: 'أضف الرابطين',
      one: 'أضف رابطاً واحداً',
      zero: 'لا شيء لإضافته',
    );
    return '$_temp0';
  }

  @override
  String get desktopBack => 'رجوع';

  @override
  String get desktopBackUpNow => 'انسخ الآن';

  @override
  String get desktopBackupHint =>
      'يحتفظ هذا الكمبيوتر بآخر سبع نسخ احتياطية، بين كل نسخة والتي تليها ساعة على الأقل، في مجلده الخاص.';

  @override
  String get desktopBackupsNone => 'لا نسخة بعد';

  @override
  String get desktopBrowserButton => 'زر «إلى Vidhoist» في المتصفح';

  @override
  String get desktopBrowserButtonCopied =>
      'نُسخ الرمز. أنشئ إشارة مرجعية جديدة، والصقه في خانة عنوانها (URL).';

  @override
  String get desktopBrowserButtonCopy => 'انسخ الرمز';

  @override
  String get desktopBrowserButtonFailed =>
      'تعذّر فتح الصفحة؛ انسخ الرمز بدلاً منها.';

  @override
  String get desktopBrowserButtonHint =>
      'زرّ في شريط الإشارات المرجعية: نقرة عليه في صفحة أي مقطع تفتح نافذة الإضافة هنا بالرابط، ولا يُرسَل شيء قبل أن تضغط «إضافة».';

  @override
  String get desktopBrowserButtonName => 'إلى Vidhoist';

  @override
  String get desktopBrowserButtonOpen => 'افتح صفحة الإعداد';

  @override
  String get desktopBrowserPageCopyInstead =>
      'إن لم ينجح السحب، فأنشئ إشارة مرجعية جديدة والصق هذا في خانة عنوانها:';

  @override
  String get desktopBrowserPageDragHint =>
      'اسحبه إلى الشريط؛ النقر عليه هنا لا يفعل شيئاً.';

  @override
  String get desktopBrowserPageStep1 =>
      'أظهر شريط الإشارات المرجعية إن كان مخفياً:';

  @override
  String get desktopBrowserPageStep2 =>
      'اسحب الزر الذي تحت هذا السطر بالفأرة، وأفلته على الشريط.';

  @override
  String get desktopBrowserPageStep3 =>
      'في صفحة أي مقطع انقره، فيفتح Vidhoist نافذة الإضافة بالرابط. وفي المرة الأولى يسألك المتصفح هل يفتح التطبيق، فاسمح له.';

  @override
  String get desktopBrowserPageTitle => 'أضف زر «إلى Vidhoist» إلى متصفحك';

  @override
  String get desktopChangeFolder => 'تغيير…';

  @override
  String get desktopChannel => 'القناة';

  @override
  String get desktopChannelClips => 'في مكتبتك';

  @override
  String get desktopChannels => 'القنوات';

  @override
  String get desktopChannelsInLibrary => 'قنوات في مكتبتك';

  @override
  String get desktopChannelsLater => 'ليست في هذا الإصدار';

  @override
  String get desktopChannelsLaterBody =>
      'متابعة القنوات تحتاج مُجدولاً على هذا الكمبيوتر، ويأتي في إصدار لاحق. ما تنزّله من مقاطع يبقى في المكتبة.';

  @override
  String get desktopChapters => 'الفصول';

  @override
  String get desktopCheckAll => 'افحص الكل';

  @override
  String get desktopChooseClip => 'تحديد';

  @override
  String get desktopClearFilters => 'إلغاء التصفية';

  @override
  String get desktopClearSelection => 'إلغاء التحديد';

  @override
  String get desktopCookiesBrowser => 'من المتصفح';

  @override
  String get desktopCookiesBrowserHint =>
      'تُقرأ من المتصفح الذي سجّلت الدخول فيه. إن تعذّرت قراءتها فأغلق المتصفح وحاول مجدداً.';

  @override
  String get desktopCookiesChoose => 'اختر ملفاً…';

  @override
  String get desktopCookiesFile => 'ملف الكوكيز';

  @override
  String get desktopCookiesHelp =>
      'استعمل في متصفحك إضافةً تصدّر الكوكيز بصيغة Netscape (ملف لكل موقع)، واختر الملفات هنا معاً. يستعملها yt-dlp بعدها في كل تنزيل. تنتهي صلاحية الكوكيز، فإن عاد تنزيل يفشل فالأغلب أن الوقت حان لتصديرها من جديد.';

  @override
  String get desktopCookiesKept => 'الكوكيز محفوظة على هذا الحاسوب';

  @override
  String desktopCookiesKeptFor(String sites) {
    return 'حُفظت الكوكيز لـ: $sites';
  }

  @override
  String get desktopCookiesLocalHint =>
      'للمواقع التي تطلب تسجيل الدخول. يقرؤها yt-dlp على هذا الحاسوب ولا تذهب إلى أي مكان آخر.';

  @override
  String get desktopCookiesNone => 'بلا';

  @override
  String get desktopCookiesRemove => 'إزالة';

  @override
  String get desktopCopiedLinkAdd => 'إضافة…';

  @override
  String get desktopCopiedLinkTitle => 'أتنزّل هذا الرابط؟';

  @override
  String get desktopCopyFile => 'نسخ الملف';

  @override
  String get desktopCopyFileFailed => 'تعذّر نسخ الملف';

  @override
  String get desktopCopyLink => 'نسخ الرابط';

  @override
  String get desktopCopyOneClip => 'النسخ لمقطع واحد في كل مرة';

  @override
  String get desktopCopyQuote => 'انسخ مع الوقت والرابط';

  @override
  String get desktopDefaultQualityHint =>
      'ما تبدأ به كل إضافة، ويبقى تغييره ممكناً لكل رابط.';

  @override
  String desktopDeleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'حذف $count مقطع؟ تُحذف ملفاتها من هذا الكمبيوتر.',
      many: 'حذف $count مقطعاً؟ تُحذف ملفاتها من هذا الكمبيوتر.',
      few: 'حذف $count مقاطع؟ تُحذف ملفاتها من هذا الكمبيوتر.',
      two: 'حذف مقطعين؟ يُحذف ملفاهما من هذا الكمبيوتر.',
      one: 'حذف مقطع واحد؟ يُحذف ملفه من هذا الكمبيوتر.',
    );
    return '$_temp0';
  }

  @override
  String get desktopDesktopSection => 'سطح المكتب';

  @override
  String get desktopDiscover => 'اكتشف Vidhoist';

  @override
  String get desktopDiscoverAddLink => 'الصق رابطاً أو اسحبه';

  @override
  String get desktopDiscoverAddLinkLine =>
      'Ctrl+V في أي مكان، أو اسحب الرابط إلى النافذة لتضيفه.';

  @override
  String get desktopDiscoverAdding => 'الإضافة والمشاركة';

  @override
  String get desktopDiscoverBrowser => 'من المتصفح';

  @override
  String get desktopDiscoverBrowserLine =>
      'زر «إلى Vidhoist» في شريط الإشارات المرجعية يفتح نافذة الإضافة بالصفحة التي أنت فيها.';

  @override
  String get desktopDiscoverChapters => 'الفصول';

  @override
  String get desktopDiscoverChaptersLine => 'أقسام المقطع من نصه، في صفحته.';

  @override
  String get desktopDiscoverChoose => 'حدّد عدة مقاطع';

  @override
  String get desktopDiscoverChooseLine =>
      'بالدائرة عند المرور، أو Ctrl أو Shift مع النقر، ثم أضفها إلى قائمة أو احذفها معاً.';

  @override
  String get desktopDiscoverDragOut => 'اسحب مقطعاً إلى الخارج';

  @override
  String get desktopDiscoverDragOutLine => 'إلى مجلد أو برنامج آخر، ملفاً.';

  @override
  String get desktopDiscoverExport => 'صدّر النص';

  @override
  String get desktopDiscoverExportLine =>
      'نصاً، أو ترجمةً بصيغة SRT لمشغّل آخر.';

  @override
  String get desktopDiscoverHint =>
      'كل ما يستطيعه التطبيق، سطراً لكل ميزة، مع اختصاراتها.';

  @override
  String get desktopDiscoverLibrary => 'المكتبة';

  @override
  String get desktopDiscoverListening =>
      'للصوت: غرفة هادئة بغلاف كبير، بملء الشاشة.';

  @override
  String get desktopDiscoverMini => 'النافذة الصغيرة';

  @override
  String get desktopDiscoverMiniLine =>
      'بطاقة صغيرة فوق كل النوافذ، بجانب الساعة.';

  @override
  String get desktopDiscoverPhone => 'مع جوالك';

  @override
  String get desktopDiscoverPhoneLine =>
      'الوسوم والقوائم ومواضع الاستئناف، تُزامَن مع Vidhoist على جوالك عبر مجلد تختاره.';

  @override
  String get desktopDiscoverReading =>
      'النص مقالةً: انقر جملة لتسمعها من مكانها.';

  @override
  String get desktopDiscoverSaid => 'ما قيل في المقاطع';

  @override
  String get desktopDiscoverSearch => 'ابحث في ما قيل';

  @override
  String get desktopDiscoverSearchLine =>
      'اعثر على المقاطع التي قيلت فيها كلمة، لا في العناوين وحدها.';

  @override
  String get desktopDiscoverShortcutsLine =>
      'كل اختصارات النافذة في ورقة واحدة.';

  @override
  String get desktopDiscoverShow => 'اعرضها';

  @override
  String get desktopDiscoverStatsLine =>
      'المكتبة بالأرقام: حسب الموقع والقناة والشهر.';

  @override
  String get desktopDiscoverSubtitles =>
      'النص على الصورة، والكلمة المنطوقة تضيء.';

  @override
  String get desktopDiscoverTheater => 'صورة أكبر تأخذ مكان اللوحة الجانبية.';

  @override
  String get desktopDiscoverTry => 'جرّبها';

  @override
  String get desktopDiscoverWatching => 'المشاهدة والاستماع';

  @override
  String get desktopDownloadFolder => 'مجلد التنزيل';

  @override
  String get desktopDownloadFolderHint =>
      'ملفاتك الخاصة: تُحفظ هنا، ثم لا يتدخل فيها التطبيق.';

  @override
  String get desktopDownloads => 'التحميلات';

  @override
  String get desktopDownloadsEmpty =>
      'لا شيء قيد التحميل. أضف رابطاً، أو أتِح مقطعاً دون اتصال.';

  @override
  String get desktopDownloadsRunning => 'جارية';

  @override
  String get desktopDragToReorder => 'اسحب لتغيير الترتيب';

  @override
  String get desktopDropLinks => 'أفلِته لإضافته';

  @override
  String get desktopEmptyLibraryLocal =>
      'أضف رابطاً، فيظهر المقطع هنا حين يكتمل تنزيله.';

  @override
  String get desktopEmptyLibraryMessage =>
      'أضِف رابطاً فيظهر المقطع هنا بعد تنزيله.';

  @override
  String get desktopEngine => 'المحرّك';

  @override
  String get desktopEngineDenoHint => 'يحلّ فحص يوتيوب لتظهر كل صيغه';

  @override
  String get desktopEngineFetch => 'نزّل';

  @override
  String get desktopEngineFetchCorrupt =>
      'الملف الذي وصل لا يطابق المنشور، فلم يُستعمل.';

  @override
  String get desktopEngineFetchFailed =>
      'تعذّر التنزيل. تحقّق من الاتصال وحاول مجدداً.';

  @override
  String get desktopEngineFetchInUse =>
      'مستعمل في تنزيل جارٍ. حاول بعد انتهائه.';

  @override
  String desktopEngineFetching(int percent) {
    return 'جارٍ التنزيل · $percent٪';
  }

  @override
  String get desktopEngineFfmpegHint => 'يدمج الصورة والصوت ويحوّل الصوتيات';

  @override
  String get desktopEngineIpv4 => 'استعمل IPv4 فقط';

  @override
  String get desktopEngineIpv4Hint =>
      'أسرع بكثير حيث يتعطّل IPv6، كما في كثير من الشبكات المنزلية. أطفئه فقط إن كانت شبكتك بـIPv6 وحده.';

  @override
  String get desktopEngineMissing =>
      'yt-dlp غير موجود على هذا الحاسوب. أعد تثبيت Vidhoist، أو نزّله من هنا.';

  @override
  String get desktopEngineOnFirstUse => 'يُنزَّل مع أول تنزيل يحتاجه';

  @override
  String get desktopEngineUpToDate => 'yt-dlp محدَّث';

  @override
  String get desktopEngineUpdate => 'حدّث yt-dlp';

  @override
  String get desktopEngineUpdateFailed => 'لم يكتمل التحديث. حاول لاحقاً.';

  @override
  String get desktopEngineUpdateHint =>
      'تتغيّر المواقع كثيراً، وyt-dlp القديم يتوقف عن العمل خلال أشهر.';

  @override
  String desktopEngineUpdated(String version) {
    return 'صار yt-dlp بالإصدار $version';
  }

  @override
  String get desktopEngineUpdating => 'جارٍ التحديث…';

  @override
  String desktopEngineVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get desktopEngineYtDlpHint => 'يقرأ الرابط وينزّله';

  @override
  String get desktopExport => 'تصدير';

  @override
  String get desktopExportForPhone => 'تصدير للجوال';

  @override
  String get desktopExportForPhoneHint =>
      'يحفظ وسوم هذا الكمبيوتر وقوائمه ومواضع الاستئناف ونصوصه في ملفين يستعيدهما الجوال. والاستعادة في الجوال تستبدل وسومه وقوائمه.';

  @override
  String get desktopExportMarkdown => 'نص (Markdown)';

  @override
  String get desktopExportPdf => 'مستند (PDF)';

  @override
  String get desktopExportPhone => 'للجوال (ملف الاستيراد في Vidhoist)';

  @override
  String get desktopExportSrt => 'ترجمة (SRT)';

  @override
  String desktopExported(String name) {
    return 'حُفظ $name';
  }

  @override
  String desktopFileReadyToPaste(String name, String size) {
    return 'جاهز للصق: $name · $size';
  }

  @override
  String get desktopFolderUnavailable => 'لا مجلد متاح';

  @override
  String get desktopFolders => 'المجلدات';

  @override
  String get desktopForward => 'تقدّم';

  @override
  String get desktopGlobalShortcut => 'التشغيل والإيقاف من أي تطبيق';

  @override
  String desktopGlobalShortcutHint(String keys) {
    return '$keys يشغّل ويوقف والنافذة خلف البرامج الأخرى.';
  }

  @override
  String desktopGlobalShortcutTaken(String keys) {
    return 'برنامج آخر يستعمل $keys من قبل.';
  }

  @override
  String get desktopHidePanel => 'إخفاء اللوحة الجانبية';

  @override
  String get desktopHintShortcuts =>
      'اضغط ? لترى اختصارات لوحة المفاتيح. المسافة للتشغيل والإيقاف، والسهمان الأيمن والأيسر للتقديم والتأخير.';

  @override
  String get desktopHintShortcutsAction => 'الاختصارات';

  @override
  String get desktopHintTrayBody =>
      'يكمل التشغيل من أيقونته بجانب الساعة. للخروج، انقر الأيقونة بالزر الأيمن.';

  @override
  String get desktopHintTrayTitle => 'ما زال Vidhoist يعمل';

  @override
  String get desktopHints => 'إظهار التلميحات';

  @override
  String get desktopHintsAgain => 'أعد عرضها';

  @override
  String get desktopHintsHint =>
      'تلميحان قصيران، يظهر كل منهما مرة واحدة: الاختصارات مع أول مقطع، وأيقونة الساعة مع أول إغلاق.';

  @override
  String get desktopImportFromPhone => 'استيراد من الجوال…';

  @override
  String get desktopImportHint =>
      'نسخة احتياطية أو ملف نصوص من Vidhoist على جهاز آخر، أو من Vidhoist Super أو Lite، تختاره هنا أو تُفلته على النافذة. يُضاف إلى ما هنا ولا يستبدل شيئاً.';

  @override
  String desktopImportedBackup(int tagged, int lists, int positions) {
    return 'أُضيف من الجوال. وسوم: $tagged · قوائم: $lists · مواضع استئناف: $positions';
  }

  @override
  String get desktopImportedNothing => 'لا جديد: كل ما فيها موجود هنا.';

  @override
  String desktopImportedTranscripts(int count) {
    return 'نصوص أُضيفت: $count';
  }

  @override
  String desktopInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مقطع في مكتبتك',
      many: '$count مقطعاً في مكتبتك',
      few: '$count مقاطع في مكتبتك',
      two: 'مقطعان في مكتبتك',
      one: 'مقطع في مكتبتك',
      zero: 'لا شيء في مكتبتك',
    );
    return '$_temp0';
  }

  @override
  String get desktopKeyAddLink => 'إضافة الرابط المنسوخ';

  @override
  String get desktopKeyFavorite => 'إضافة إلى المفضلة أو إزالة منها';

  @override
  String get desktopKeyFullScreen => 'ملء الشاشة، وفي الصوت غرفة الاستماع';

  @override
  String get desktopKeyMenu => 'قائمة المقطع';

  @override
  String get desktopKeyMini => 'نافذة صغيرة فوق البرامج، والعودة منها';

  @override
  String get desktopKeyPlayPause => 'تشغيل أو إيقاف مؤقت';

  @override
  String get desktopKeyRepeat => 'تغيير التكرار';

  @override
  String get desktopKeySearch => 'البحث في العناوين وما قيل';

  @override
  String get desktopKeySeek => 'رجوع أو تقدّم 10 ثوانٍ';

  @override
  String get desktopKeyShortcuts => 'هذه القائمة';

  @override
  String get desktopKeyVolume =>
      'رفع الصوت أو خفضه، وفي المقاطع القصيرة: السابق أو التالي';

  @override
  String get desktopKeyZoomIn => 'تكبير الواجهة';

  @override
  String get desktopKeyZoomOut => 'تصغير الواجهة';

  @override
  String get desktopKeyZoomReset => 'الواجهة بحجمها المعتاد';

  @override
  String get desktopLanguageSystemHint => 'يتبع لغة Windows.';

  @override
  String desktopLastArrival(String when) {
    return 'آخر وصول $when';
  }

  @override
  String get desktopLaterFeatures => 'أظهر القنوات والمزامنة';

  @override
  String get desktopLaterFeaturesHint =>
      'لم تكتملا بعد على هذا المحرّك: القنوات تحتاج فحصاً دورياً من التطبيق، والمزامنة تنتظر تطبيق الجوال.';

  @override
  String get desktopLess => 'أقل';

  @override
  String get desktopLibraryLoading => 'تُحمَّل المكتبة…';

  @override
  String get desktopLinkCopied => 'نُسخ الرابط';

  @override
  String get desktopLinkDuplicate => 'مكرّر أعلاه';

  @override
  String get desktopLinkInLibrary => 'موجود في مكتبتك';

  @override
  String get desktopLinkPlaylist => 'قائمة تشغيل: اختر مقاطعها';

  @override
  String get desktopLinkReady => 'جاهز';

  @override
  String get desktopLinkUnsupported => 'موقع لا يعرفه التطبيق';

  @override
  String desktopLinksDropped(int count, int limit) {
    return 'تُؤخذ أول $limit رابط فقط، وتُرك الباقي: $count.';
  }

  @override
  String desktopLinksFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count رابط',
      many: '$count رابطاً',
      few: '$count روابط',
      two: 'رابطان',
      one: 'رابط واحد',
    );
    return '$_temp0';
  }

  @override
  String get desktopListeningClose => 'إغلاق غرفة الاستماع';

  @override
  String get desktopListeningRoom => 'غرفة الاستماع';

  @override
  String get desktopLogsCopied => 'نُسخ السجل بلا روابط ولا عناوين';

  @override
  String get desktopLogsCopy => 'نسخ';

  @override
  String get desktopLogsSave => 'حفظ في ملف';

  @override
  String get desktopMiniRestore => 'العودة إلى النافذة الكاملة';

  @override
  String get desktopMiniWindow => 'نافذة صغيرة';

  @override
  String get desktopMore => 'المزيد';

  @override
  String get desktopNarrowSidebar => 'تضييق الشريط الجانبي';

  @override
  String get desktopNoChannelNames =>
      'لا يحفظ سيرفرك اسم القناة مع كل مقطع، فلا يُعرف هنا ما نزل منها. لتظهر مقاطعها، تابِعها بمجلد خاص بها: كل ما ينزل في مجلدها يظهر هنا.';

  @override
  String get desktopNoFavoritesMessage => 'ضع قلباً على مقطع فيبقى لك هنا.';

  @override
  String get desktopNoFavoritesTitle => 'لا مفضلة بعد';

  @override
  String get desktopNoMatchMessage => 'ألغِ أحد الاختيارات لترى أكثر.';

  @override
  String get desktopNoMatchTitle => 'لا شيء يطابق هذه التصفية';

  @override
  String get desktopNoOfflineMessage =>
      'المقطع الذي يُنزَّل إلى هذا الكمبيوتر يعمل من هنا، ويظهر في هذه القائمة.';

  @override
  String get desktopNoOfflineTitle => 'لا شيء محفوظ على هذا الكمبيوتر بعد';

  @override
  String get desktopNoTags =>
      'لا وسوم بعد. أضف وسماً لأي مقطع من صفحته فيظهر هنا.';

  @override
  String get desktopNoTranscriptMessage =>
      'يظهر هنا حين تُنزَّل ترجمة المقطع معه.';

  @override
  String get desktopNoTranscriptTitle => 'لا نص لهذا المقطع';

  @override
  String get desktopNotABackup =>
      'هذا الملف ليس نسخة احتياطية ولا ملف نصوص من Vidhoist أو Vidhoist.';

  @override
  String desktopNotWatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لم تشاهدها',
      many: '$count لم تشاهدها',
      few: '$count لم تشاهدها',
      two: 'اثنان لم تشاهدهما',
      one: 'واحد لم تشاهده',
    );
    return '$_temp0';
  }

  @override
  String get desktopNothingPlaying => 'لا شيء قيد التشغيل';

  @override
  String get desktopNothingPlayingHint =>
      'شغّل مقطعاً فيظهر هنا نصه وما يليه وتفاصيله.';

  @override
  String get desktopNotifyArrivalsHint =>
      'إشعار من Windows حين تصل إلى السيرفر مقاطع جديدة من القنوات التي تتابعها.';

  @override
  String get desktopOfferCopiedLinks => 'اعرض عليّ الروابط التي أنسخها';

  @override
  String get desktopOfferCopiedLinksHint =>
      'حين تنسخ رابط مقطع في برنامج آخر، يعرض عليك إشعارٌ إضافته. لا يُنظر إلا في الروابط، ولا يُحفظ منها شيء.';

  @override
  String desktopOfflineCount(int count) {
    return 'دون اتصال: $count';
  }

  @override
  String get desktopOpenChannels => 'افتح القنوات';

  @override
  String get desktopOpenInExplorer => 'فتح في مستكشف الملفات';

  @override
  String get desktopPaletteClose => 'للإغلاق';

  @override
  String get desktopPaletteCommands => 'الأوامر';

  @override
  String get desktopPaletteHint =>
      'ابحث في العناوين وما قيل، أو اكتب > للأوامر';

  @override
  String desktopPaletteList(String name) {
    return 'قائمة: $name';
  }

  @override
  String get desktopPaletteMove => 'للتنقل';

  @override
  String get desktopPaletteOpen => 'للفتح';

  @override
  String get desktopPaletteSaid => 'قيل داخل المقاطع';

  @override
  String get desktopPaletteSave => 'احفظ هذا البحث';

  @override
  String desktopPaletteSettings(String section) {
    return 'الإعدادات: $section';
  }

  @override
  String get desktopPaletteTitles => 'العناوين';

  @override
  String get desktopPinned => 'مثبّتة';

  @override
  String get desktopPlayNext => 'تشغيل التالي';

  @override
  String get desktopPlaysNext => 'سيُشغَّل بعد الحالي';

  @override
  String get desktopQueueEnd => 'لا شيء بعد هذا المقطع';

  @override
  String desktopQuote(String text, String title, String time, String link) {
    return '«$text»\n— $title، $time\n$link';
  }

  @override
  String get desktopQuoteCopied => 'نُسخ مع وقته ورابطه';

  @override
  String get desktopReadingBack => 'العودة إلى المقطع';

  @override
  String get desktopReadingCloseFind => 'إغلاق البحث';

  @override
  String get desktopReadingFind => 'ابحث في النص';

  @override
  String desktopReadingFound(int at, int count) {
    return '$at من $count';
  }

  @override
  String get desktopReadingHint =>
      'انقر جملة لتسمعها منها · Ctrl+F للبحث عن كلمة · حدِّد لتنسخ مع الوقت';

  @override
  String get desktopReadingNextMatch => 'النتيجة التالية';

  @override
  String get desktopReadingPreviousMatch => 'النتيجة السابقة';

  @override
  String get desktopReadingRoom => 'غرفة القراءة';

  @override
  String get desktopRemoveFromList => 'أزله من القائمة';

  @override
  String get desktopRestore => 'استعادة';

  @override
  String get desktopRestoreBody =>
      'تصبح وسوم هذا الكمبيوتر وقوائمه وإعداداته كما في النسخة، ولا تُمسّ الملفات المنزّلة.';

  @override
  String get desktopRestoreTitle => 'استعادة هذه النسخة؟';

  @override
  String get desktopRestored => 'استُعيدت النسخة';

  @override
  String get desktopRevealAfterDownload => 'أظهره في المستكشف حين يكتمل';

  @override
  String get desktopRevealAfterDownloadHint =>
      'حين يكتمل تنزيل ملف إلى هذا الكمبيوتر، يُفتح مجلده والملف محدَّد فيه.';

  @override
  String desktopSavedIn(String folder) {
    return 'حُفظ في $folder';
  }

  @override
  String desktopSavedSearchDelete(String name) {
    return 'حذف البحث المحفوظ «$name»؟ لا يتغير شيء في المكتبة.';
  }

  @override
  String get desktopSavedSearchName => 'اسم البحث';

  @override
  String get desktopSearch => 'البحث';

  @override
  String get desktopSearchHint => 'ابحث في العناوين وما قيل…';

  @override
  String get desktopSearchSaved => 'حُفظ في الشريط الجانبي';

  @override
  String get desktopSeekBar => 'الموضع في المقطع';

  @override
  String desktopSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مقطع محدد',
      many: '$count مقطعاً محدداً',
      few: '$count مقاطع محددة',
      two: 'مقطعان محددان',
      one: 'مقطع محدد',
    );
    return '$_temp0';
  }

  @override
  String get desktopSetupChooseFile => 'اختر ملفاً…';

  @override
  String get desktopShortcutsApp => 'التطبيق';

  @override
  String get desktopShortcutsClip => 'على مقطع محدد';

  @override
  String get desktopShortcutsPlayback => 'التشغيل';

  @override
  String get desktopShortcutsTitle => 'اختصارات لوحة المفاتيح';

  @override
  String get desktopShortcutsWindow => 'النافذة';

  @override
  String get desktopShortsHint =>
      '↑ ↓ أو العجلة للقصير التالي · نقرتان للمفضلة';

  @override
  String get desktopShowInFolder => 'إظهار في المجلد';

  @override
  String get desktopShowPanel => 'إظهار اللوحة الجانبية';

  @override
  String get desktopStartWithWindows => 'التشغيل مع بدء Windows';

  @override
  String get desktopStartWithWindowsHint =>
      'يفتح عند تسجيل الدخول: في الدرج إن كان يستمر في التشغيل هناك، وإلا مصغَّراً.';

  @override
  String get desktopStartWithWindowsRefused =>
      'لم يسمح Windows للتطبيق بالبدء معه.';

  @override
  String get desktopStats => 'إحصاءات المكتبة';

  @override
  String get desktopStatsByChannel => 'حسب القناة';

  @override
  String get desktopStatsByMonth => 'حسب شهر الإضافة';

  @override
  String get desktopStatsBySite => 'حسب المنصة';

  @override
  String get desktopStatsClips => 'المقاطع';

  @override
  String get desktopStatsHint =>
      'ما تحويه المكتبة، وما قد يستحق نظرة. لا يُحذف شيء من هنا.';

  @override
  String desktopStatsHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ساعة',
      many: '$count ساعة',
      few: '$count ساعات',
      two: 'ساعتان',
      one: 'ساعة واحدة',
      zero: 'أقل من ساعة',
    );
    return '$_temp0';
  }

  @override
  String get desktopStatsLargest => 'أكبرها:';

  @override
  String get desktopStatsLength => 'المدة';

  @override
  String get desktopStatsLink => 'الإحصاءات';

  @override
  String get desktopStatsNeverPlayed => 'لم تُشغَّل هنا قط';

  @override
  String get desktopStatsNewest => 'أحدثها:';

  @override
  String get desktopStatsOtherChannels => 'قنوات أخرى';

  @override
  String get desktopStatsRoom => 'المساحة';

  @override
  String get desktopStatsUnnamed => 'بلا اسم قناة';

  @override
  String get desktopStatsWithText => 'لها نص';

  @override
  String get desktopStatsWithoutText => 'بلا نص';

  @override
  String get desktopStatsWorthALook => 'قد تستحق نظرة';

  @override
  String get desktopSubtitleOptions => 'خيارات الترجمة';

  @override
  String get desktopSync => 'المزامنة';

  @override
  String get desktopSyncCameBack =>
      'غاب هذا الكمبيوتر أكثر من 90 يوماً، فأُخذت بيانات أجهزتك الأخرى أولاً.';

  @override
  String get desktopSyncChoose => 'اختر مجلداً';

  @override
  String desktopSyncComputer(String name) {
    return 'الكمبيوتر $name';
  }

  @override
  String get desktopSyncFailed =>
      'تعذّرت قراءة مجلد المزامنة، فتأكد أن قرصه موجود.';

  @override
  String get desktopSyncFolder => 'مجلد المزامنة';

  @override
  String get desktopSyncForget => 'انسَ هذا الجهاز';

  @override
  String desktopSyncForgetBody(String device) {
    return 'لن يُقرأ $device بعد الآن، وتُنقل نصوصه إلى مجلد هذا الكمبيوتر أولاً فلا يضيع منها شيء. استعمله لجهاز ضاع أو بِيع.';
  }

  @override
  String desktopSyncFrom(String device, String ago) {
    return 'آخر ما وصل من $device: $ago';
  }

  @override
  String get desktopSyncGuide =>
      'داخل البيت: Syncthing على هذا الكمبيوتر وSyncthing‑Fork (من F-Droid) على الجوال يتشاركان مجلداً واحداً، واضبط Syncthing‑Fork على «Wi‑Fi فقط» توفيراً لبطارية الجوال. وعبر السحابة: مجلد برنامج السحابة على هذا الكمبيوتر (OneDrive أو Google Drive أو Dropbox)، وFolderSync على الجوال بالمجلد نفسه.';

  @override
  String get desktopSyncHint =>
      'تعكس الوسوم والمفضلة والقوائم ومواضع التوقف والبحوث المحفوظة والنصوص بين هذا الكمبيوتر وجوالك وأجهزتك الأخرى، عبر مجلد يزامنه برنامج تختاره (Syncthing داخل البيت، أو مجلد سحابي). ولا يُرسَل شيء من هنا إلى أي خدمة.';

  @override
  String desktopSyncLast(String ago) {
    return 'آخر مزامنة $ago';
  }

  @override
  String get desktopSyncNoOthers =>
      'لا جهاز آخر في هذا المجلد بعد. شغّل المزامنة في Vidhoist على الجوال بالمجلد نفسه.';

  @override
  String get desktopSyncNotBackup =>
      'المزامنة ليست نسخاً احتياطياً: تعكس الخطأ كما تعكس الصواب، ونسخك المؤرَّخة تبقى منفصلة عنها.';

  @override
  String get desktopSyncOff => 'متوقفة، ولا يخرج شيء من هذا الكمبيوتر.';

  @override
  String desktopSyncPhone(String name) {
    return 'الجوال $name';
  }

  @override
  String desktopSyncThisComputer(String name) {
    return 'هذا الكمبيوتر: $name';
  }

  @override
  String get desktopSyncTurnOff => 'إيقاف';

  @override
  String get desktopTheater => 'وضع المسرح';

  @override
  String get desktopTranscriptFirst => 'اجلب نصّه أولاً';

  @override
  String get desktopTranscriptHint => 'يتبع التشغيل · انقر سطراً ليُشغَّل منه';

  @override
  String get desktopTranscriptsDeleteBody =>
      'تُحذف من هذا الكمبيوتر، ولا يعيدها إلا ملف صدّرته أو جهاز آخر عبر المزامنة.';

  @override
  String get desktopTranscriptsExportHint => 'كلها في ملف واحد يستورده الجوال.';

  @override
  String get desktopTranscriptsHelp =>
      'يحفظ Vidhoist ما يُقال في كل مقطع يوتيوب تضيفه، فيجد البحث (Ctrl+K) ما قيل داخل مقاطعك لا عناوينها وحدها. وتبقى النصوص على هذا الكمبيوتر.';

  @override
  String get desktopTranscriptsImportHint =>
      'ملف نصوص من الجوال، يضيف ما ينقص هنا ولا يحذف شيئاً.';

  @override
  String get desktopTrayOnClose => 'يبقى التشغيل في الدرج عند إغلاق النافذة';

  @override
  String get desktopTrayOnCloseHint =>
      'إغلاق النافذة يُبقي الصوت شغالاً، والخروج من الأيقونة بجانب الساعة.';

  @override
  String get desktopTrayOpen => 'فتح Vidhoist';

  @override
  String get desktopTrayQuit => 'خروج';

  @override
  String get desktopUiSize => 'حجم الواجهة';

  @override
  String desktopUiSizeHint(String bigger, String smaller, String reset) {
    return 'يتغيّر من أي مكان بـ$bigger و$smaller، ويعود إلى 100% بـ$reset.';
  }

  @override
  String get desktopUiSizeTooLarge => 'لا تتسع له هذه الشاشة';

  @override
  String get desktopUpdateInstall => 'ثبّته وأعد التشغيل';

  @override
  String get desktopUpdateRestartHint =>
      'يُغلَق Vidhoist ويثبّت التحديث ثم يُفتح من جديد، وتبقى إعداداتك ومكتبتك كما هي.';

  @override
  String get desktopViewCompact => 'مختصر';

  @override
  String get desktopViewTable => 'جدول';

  @override
  String get desktopVolume => 'مستوى الصوت';

  @override
  String desktopVolumeLevel(int percent) {
    return 'الصوت $percent٪';
  }

  @override
  String get desktopWelcomeFetchNow => 'نزّلهما الآن';

  @override
  String get desktopWelcomeHelpers =>
      'ينزل ffmpeg (لدمج الصورة والصوت) وDeno (يحتاجه يوتيوب) تلقائياً مع أول تنزيل، نحو 160 ميغابايت. ويمكنك تنزيلهما الآن.';

  @override
  String get desktopWelcomeMessage =>
      'الصق رابطاً من يوتيوب أو أي موقع آخر، فينزّله Vidhoist إلى هذا الحاسوب بمحرّك yt-dlp، دون المرور بأي خادم.';

  @override
  String get desktopWelcomeStart => 'ابدأ';

  @override
  String get desktopWelcomeTitle => 'أهلاً بك في Vidhoist';

  @override
  String get desktopWhatsNewAllFeatures => 'وكل مزايا Vidhoist';

  @override
  String get desktopWidenSidebar => 'توسيع الشريط الجانبي';

  @override
  String get desktopWindowClose => 'إغلاق';

  @override
  String get desktopWindowMaximize => 'تكبير';

  @override
  String get desktopWindowMinimize => 'تصغير';

  @override
  String get desktopWindowRestore => 'استعادة الحجم';

  @override
  String get desktopZoomChange => 'غيّره';

  @override
  String desktopZoomLowered(String percent) {
    return 'صُغّرت الواجهة إلى $percent لتتسع لهذه الشاشة.';
  }

  @override
  String get details => 'التفاصيل';

  @override
  String get developer => 'المطور';

  @override
  String get developerName => 'ياسر صغير';

  @override
  String get diagnosticLogs => 'سجلّات التشخيص';

  @override
  String get diagnosticLogsSubtitle =>
      'عرض السجلّات والبحث فيها ومشاركتها، بعد إخفاء البيانات الحساسة';

  @override
  String get disclaimer => 'إخلاء مسؤولية';

  @override
  String get disclaimerText =>
      'يحمّل هذا التطبيق الوسائط بـyt-dlp، والمطوّر غير مسؤول عن طريقة استخدامه. يُرجى احترام حقوق النشر وشروط استخدام منصات المحتوى.';

  @override
  String get dismiss => 'تجاهل';

  @override
  String get done => 'تم';

  @override
  String get download => 'تنزيل';

  @override
  String get downloadComplete => 'اكتمل التحميل';

  @override
  String get downloadCompleteTitle => 'اكتمل';

  @override
  String get downloadDate => 'تاريخ التحميل';

  @override
  String get downloadFailed => 'فشل التحميل';

  @override
  String get downloadFailedTitle => 'فشل التنزيل';

  @override
  String get downloadNow => 'تحميل';

  @override
  String get downloadStarted => 'بدأ التحميل…';

  @override
  String downloadStartedQuality(Object quality) {
    return 'بدأ التحميل · $quality';
  }

  @override
  String get downloading => 'جارٍ التحميل…';

  @override
  String get downloadingTitle => 'جارٍ التنزيل';

  @override
  String get editSubscription => 'تعديل';

  @override
  String get emptyFilteredMessage => 'أزل مرشّحاً من الأعلى لترى مكتبتك كلها.';

  @override
  String get emptyFilteredTitle => 'لا شيء بهذه المرشّحات';

  @override
  String get emptyLibraryMessage => 'أضِف رابط فيديو، أو اسحب للتحديث.';

  @override
  String get emptyPlaylist => 'قائمة فارغة';

  @override
  String get emptyPlaylistMessage => 'أضِف فيديوهات من المكتبة';

  @override
  String engineDownloadingProgress(Object percent) {
    return 'جارٍ التنزيل · $percent٪';
  }

  @override
  String get engineErrDiskFull => 'لا توجد مساحة تخزين كافية لهذا الملف';

  @override
  String engineErrFailed(Object reason) {
    return 'فشل التنزيل: $reason';
  }

  @override
  String get engineErrFormat => 'هذه الجودة غير متاحة لهذا المقطع';

  @override
  String get engineErrGeoBlocked => 'غير متاح في بلدك';

  @override
  String get engineErrMissing =>
      'محرّك التنزيل مفقود أو ناقص. أعد تجهيزه من الإعدادات';

  @override
  String get engineErrRateLimited => 'الموقع يحدّ الطلبات الآن. حاول بعد قليل';

  @override
  String get engineErrUnavailable => 'هذا المقطع غير متاح أو خاص أو محذوف';

  @override
  String get engineErrUnsupported => 'هذا الرابط غير مدعوم';

  @override
  String get enginePaused => 'متوقف مؤقتاً';

  @override
  String get enginePostprocessing => 'جارٍ تجهيز الملف…';

  @override
  String get enginePreparing => 'جارٍ قراءة الرابط…';

  @override
  String get engineResume => 'استئناف';

  @override
  String get enterFullscreen => 'ملء الشاشة';

  @override
  String get errNetwork => 'تعذّر الاتصال بالموقع';

  @override
  String get errPlatformBlocked =>
      'المنصة تطلب تسجيل الدخول، ولا يُنزَّل هذا المقطع بدونه';

  @override
  String get errPlatformBlockedCookies =>
      'المنصة تطلب تسجيل الدخول. ارفع ملف كوكيز من الإعدادات ← الكوكيز';

  @override
  String errorGeneric(Object message) {
    return 'خطأ: $message';
  }

  @override
  String get every30Minutes => 'كل نصف ساعة';

  @override
  String everyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'كل $count ساعة',
      few: 'كل $count ساعات',
      two: 'كل ساعتين',
      one: 'كل ساعة',
    );
    return '$_temp0';
  }

  @override
  String get exitFullscreen => 'خروج من ملء الشاشة';

  @override
  String get exportShare => 'تصدير ومشاركة';

  @override
  String get exportShareSubtitle =>
      'نسخة مؤرَّخة لإرسالها أو حفظها في مكان آخر';

  @override
  String get externalPlayerShort => 'مشغل خارجي';

  @override
  String get failed => 'فشل';

  @override
  String get failedToLoadPlaylist => 'تعذّر فتح القائمة';

  @override
  String get favorites => 'المفضلة';

  @override
  String get file => 'الملف';

  @override
  String get fileName => 'اسم الملف';

  @override
  String get fileSize => 'حجم الملف';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterAudio => 'صوت';

  @override
  String get filterOffline => 'بلا اتصال';

  @override
  String get filterVideo => 'فيديو';

  @override
  String get filtersOn => 'مرشّحات مفعّلة';

  @override
  String get folder => 'المجلد';

  @override
  String get foldersHelp =>
      'يُنشأ المجلد داخل مجلد التنزيل، ويُحفظ المقطع فيه مباشرة، فتراه في المستكشف وفي أي برنامج آخر. اتركه «بلا مجلد» فيذهب المقطع إلى أعلى مجلد التنزيل.';

  @override
  String get follow => 'متابعة';

  @override
  String get followChannel => 'تابِع قناة';

  @override
  String get followingChannel => 'تتابعها';

  @override
  String get format => 'الصيغة';

  @override
  String framesPerSecond(int count) {
    return '$count إطار/ث';
  }

  @override
  String get helpAboutField => 'عن هذا الحقل';

  @override
  String get inPlaylists => 'في قوائم التشغيل';

  @override
  String get invalidUrl => 'أدخل رابطاً صالحاً';

  @override
  String get itemOptions => 'خيارات العنصر';

  @override
  String get itemUnavailable => 'لم يعد متوفراً';

  @override
  String get jumpToNewest => 'إلى الأحدث';

  @override
  String knownVideos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مقطع مرصود',
      many: '$count مقطعاً مرصوداً',
      few: '$count مقاطع مرصودة',
      two: 'مقطعان مرصودان',
      one: 'مقطع مرصود',
      zero: 'لم يُرصد أي مقطع بعد',
    );
    return '$_temp0';
  }

  @override
  String get language => 'اللغة';

  @override
  String get languageSystem => 'النظام';

  @override
  String get languageSystemHint => 'يتبع لغة هاتفك';

  @override
  String lastBackup(String when) {
    return 'آخر نسخة $when';
  }

  @override
  String lastCheckedAt(String when) {
    return 'آخر تحقق $when';
  }

  @override
  String get latestAdditions => 'أحدث الإضافات';

  @override
  String get licensedUnder => 'مرخَّص برخصة GPL-3.0';

  @override
  String get licenses => 'تراخيص البرمجيات مفتوحة المصدر';

  @override
  String get listSeparator => '، ';

  @override
  String get listenInBackground => 'الاستماع في الخلفية';

  @override
  String get lockTouch => 'قفل اللمس';

  @override
  String get logsEmpty => 'السجل فارغ';

  @override
  String get logsSanitizedNote =>
      'تُحذف الروابط والعناوين وبيانات الدخول قبل المشاركة';

  @override
  String get manageTags => 'إدارة الوسوم';

  @override
  String get mediaAccessBlockedMessage =>
      'لن يعرض أندرويد طلب الإذن مجدداً، ففعّل «الصور ومقاطع الفيديو» لهذا التطبيق من إعدادات النظام ثم عُد إليه.';

  @override
  String get mediaAccessGrant => 'السماح';

  @override
  String get mediaAccessMessage =>
      'تنزيلاتك محفوظة في مجلد Download في هاتفك، وأندرويد يطلب إذنك قبل أن يعرضها التطبيق.';

  @override
  String get mediaAccessOpenSettings => 'فتح الإعدادات';

  @override
  String get mediaAccessTitle => 'اسمح بالوصول إلى الوسائط';

  @override
  String get vidhoistCredit =>
      'أداة التنزيل ذاتية الاستضافة التي جاء Vidhoist من تطبيقاتها';

  @override
  String get mobileEngineIpv4 => 'الاتصال عبر IPv4';

  @override
  String get mobileEngineIpv4Help =>
      'يتجنّب توقّفاً طويلاً في الشبكات التي يتعطّل فيها مسار IPv6. لا توقفه إلا إن كانت شبكتك تعمل بـIPv6 وحده.';

  @override
  String mobileEngineLastUpdate(String when) {
    return 'آخر تحديث $when';
  }

  @override
  String get mobileEngineNotReady => 'قيد التجهيز…';

  @override
  String get mobileEngineUpToDate => 'yt-dlp بآخر إصدار';

  @override
  String get mobileEngineUpdate => 'تحديث yt-dlp';

  @override
  String get mobileEngineUpdateFailed =>
      'تعذّر تحديث yt-dlp. تحقّق من الاتصال وأعد المحاولة.';

  @override
  String get mobileEngineUpdating => 'جارٍ التحديث…';

  @override
  String get mobileEngineVersionUnknown => 'يظهر إصداره بعد أول تحديث';

  @override
  String get mobileSettingsEngine => 'محرّك التنزيل';

  @override
  String get mobileSettingsGroupEngine => 'المحرّك';

  @override
  String get mobileSubtitles => 'تنزيل الترجمات';

  @override
  String get mobileSubtitlesHelp =>
      'الترجمة العربية والإنجليزية إن وُجدت، تُحفظ بجانب المقطع وتظهر في المشغّل.';

  @override
  String get mobileWelcomeBody =>
      'الفيديو والصوت من المواقع التي تستعملها، يُحفظان في هذا الجوال مباشرة. محرّك التنزيل يتجهّز الآن، ولا يحدث هذا إلا مرة واحدة.';

  @override
  String get mobileWelcomeFailed =>
      'تعذّر تشغيل المحرّك. أعد المحاولة، وإن تكرّر الفشل فأعد تثبيت التطبيق.';

  @override
  String get mobileWelcomeStart => 'ابدأ';

  @override
  String get mobileWelcomeTitle => 'أهلاً بك في Vidhoist';

  @override
  String get mobileWelcomeUnpacking => 'تجهيز محرّك التنزيل';

  @override
  String get mobileWelcomeUpdateFailed =>
      'تعذّر التحديث الآن، وسيحاول Vidhoist مجدداً قبل أول تنزيل.';

  @override
  String get mobileWelcomeUpdating => 'تحديث yt-dlp إلى آخر إصدار';

  @override
  String get modeAutoNext => 'تلقائي';

  @override
  String get modeRepeatAll => 'تكرار الكل';

  @override
  String get modeRepeatOne => 'تكرار الحالي';

  @override
  String get modeStopAtEnd => 'التوقف في النهاية';

  @override
  String moreChips(int count) {
    return 'المزيد · $count';
  }

  @override
  String get navLibrary => 'المكتبة';

  @override
  String get navMyDownloads => 'تحميلاتي';

  @override
  String get navPlaylists => 'القوائم';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get needsAttention => 'تحتاج انتباهك';

  @override
  String get neverChecked => 'لم يُتحقَّق بعد';

  @override
  String get newFolder => 'مجلد جديد…';

  @override
  String get newFolderHint => 'مثال: Ai/دروس';

  @override
  String get newPlaylistAction => 'قائمة جديدة';

  @override
  String get newTagHint => 'وسم جديد';

  @override
  String get next => 'التالي';

  @override
  String get noBackupsYet => 'لا توجد نسخ بعد';

  @override
  String get noDownloads => 'لا توجد تحميلات';

  @override
  String get noDownloadsMessage =>
      'ستظهر هنا الفيديوهات التي تحمّلها.\nشارك رابط فيديو أو اضغط زر «إضافة رابط».';

  @override
  String get noExternalPlayer => 'لا يوجد مشغل خارجي على الجهاز';

  @override
  String get noFolder => 'بلا مجلد';

  @override
  String get noFolderHint => 'أعلى التنزيلات';

  @override
  String get noLogsFound => 'لا توجد سجلّات';

  @override
  String get noPlayableSource => 'لا مصدر لتشغيل هذا العنصر';

  @override
  String get noPlaylistsMessage => 'أنشئ قائمة لتنظيم فيديوهاتك';

  @override
  String get noResults => 'لا نتائج';

  @override
  String get noResultsMessage => 'لا توجد عناصر مطابقة لبحثك.';

  @override
  String get noServerTitle => 'محرك التنزيل غير جاهز';

  @override
  String get noTagsYet => 'لا وسوم بعد، أنشئ أول وسم من الأسفل.';

  @override
  String get noVideosFound => 'مكتبتك فارغة';

  @override
  String get noWarranty => 'يُقدَّم كما هو، بلا أي ضمان.';

  @override
  String get notAffiliated =>
      'لا صلة للتطبيق بمشروع yt-dlp ولا بأي منصة محتوى، ولا يحظى بتأييدها.';

  @override
  String get nothingHereYet => 'لا يوجد شيء بعد';

  @override
  String get nowPlaying => 'قيد التشغيل';

  @override
  String get nowPlayingCollapse => 'طيّ لوحة التشغيل';

  @override
  String get nowPlayingExpand => 'إظهار لوحة التشغيل';

  @override
  String get offlineSmartList => 'دون اتصال';

  @override
  String get ok => 'حسناً';

  @override
  String get onlyNewVideos =>
      'لا يُنزَّل إلا ما يُنشر من الآن فصاعداً، أما ما نُشر في القناة من قبل فلا يُنزَّل.';

  @override
  String get openChannel => 'فتح القناة';

  @override
  String get openInExternalPlayer => 'فتح في مشغل خارجي';

  @override
  String get openOriginalLink => 'فتح الرابط الأصلي';

  @override
  String get ownFolder => 'احفظ في مجلد خاص بها';

  @override
  String get ownFolderNote =>
      'مجلد داخل مجلد التنزيل، تراه في المستكشف وفي أي برنامج آخر. يذهب إليه ما ينزل من الآن فقط، وما نزل قبله يبقى مكانه.';

  @override
  String get password => 'كلمة المرور';

  @override
  String get pasteUrlHint => 'الصق الرابط هنا…';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get pauseSubscription => 'إيقاف مؤقت';

  @override
  String percentValue(Object percent) {
    return '$percent٪';
  }

  @override
  String get pickAnotherFile => 'من ملف آخر…';

  @override
  String get pickAnotherFileSubtitle => 'نسخة من هاتف آخر أو من إصدار سابق';

  @override
  String get pictureInPicture => 'صورة داخل صورة';

  @override
  String get pictureInPictureHelp =>
      'حين تخرج من التطبيق والفيديو يعمل، يبقى في زاوية الشاشة';

  @override
  String get pinPlaylist => 'تثبيت في الصدارة';

  @override
  String get platform => 'المنصّة';

  @override
  String platformCount(Object name, int count) {
    return '$name · $count';
  }

  @override
  String get platformOther => 'أخرى';

  @override
  String get play => 'تشغيل';

  @override
  String get playAll => 'تشغيل الكل';

  @override
  String get playModeLabel => 'الوضع';

  @override
  String get playbackSpeed => 'سرعة التشغيل';

  @override
  String get playerError => 'تعذّر تشغيل هذا الملف';

  @override
  String get playingFromDevice => 'يُشغَّل من جهازك';

  @override
  String get playlist => 'قائمة التشغيل';

  @override
  String get playlistCreated => 'أُنشئت القائمة';

  @override
  String get playlistDeleted => 'حُذفت القائمة';

  @override
  String get playlistDetails => 'تفاصيل القائمة';

  @override
  String get playlistEditHint =>
      'اضغط مطوّلاً لتغيير الترتيب، واسحب الصف جانباً لإزالته.';

  @override
  String get playlistName => 'اسم القائمة';

  @override
  String get playlistNameHint => 'قائمتي';

  @override
  String playlistOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get playlists => 'قوائم التشغيل';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get previous => 'السابق';

  @override
  String get quality => 'الجودة';

  @override
  String get quality1080 => 'حتى 1080p';

  @override
  String get quality360 => 'حتى 360p';

  @override
  String get quality480 => 'حتى 480p';

  @override
  String get quality720 => 'حتى 720p';

  @override
  String get qualityAudio => 'الصوت';

  @override
  String get qualityBest => 'الأفضل';

  @override
  String get qualityHelper =>
      'تُعتمد هذه الجودة في التحميل السريع، وفي تحميل القائمة كاملة، وفي «حمّل الآن» من شريط الحافظة، وتكون محددة مسبقاً في نافذة إضافة الرابط؛ لذا يسري أثرها سواء أكان التحميل السريع مفعّلاً أم لا.';

  @override
  String get qualityReading => 'جارٍ قراءة الملف…';

  @override
  String get qualityUnavailable => 'غير متاحة';

  @override
  String get qualityVideo => 'الفيديو';

  @override
  String queueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصراً',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: 'لا عناصر',
    );
    return '$_temp0';
  }

  @override
  String get queueLabel => 'قائمة الانتظار';

  @override
  String queuePosition(int position) {
    return 'رقم $position في الطابور';
  }

  @override
  String get queued => 'في الانتظار';

  @override
  String get queuedSection => 'بالانتظار';

  @override
  String get quickDownload => 'التحميل السريع';

  @override
  String get quickDownloadHelp =>
      'حين تشارك رابطاً أو تلصقه يبدأ تحميله فوراً بالجودة الافتراضية دون أي نافذة. الجودات الرقمية خاصة بيوتيوب، فما سواه يُحمَّل بأفضل جودة، أما «صوت فقط» فيسري على كل المنصات.';

  @override
  String get quoteExtendHint => 'المس سطراً آخر لتوسيع الاقتباس';

  @override
  String get quoteMomentLink => 'انسخ رابط هذه اللحظة';

  @override
  String get quotePlayFrom => 'شغّل من هنا';

  @override
  String get quoteTitle => 'اقتباس';

  @override
  String get readingAsMarkdownHint => 'عند كل فقرة وقتها برابط إلى لحظتها';

  @override
  String get readingAsPdfHint => 'للطباعة أو الحفظ';

  @override
  String get readingAsSrtHint => 'سطراً سطراً بأوقاته، لأي مشغّل';

  @override
  String get readingAsText => 'نص للقراءة';

  @override
  String get readingAsTextHint => 'فقرات بلا أوقات، يُلصق في أي تطبيق';

  @override
  String get readingHint => 'انقر جملة لتسمعها من هناك';

  @override
  String readingMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'نحو $count دقيقة قراءة',
      many: 'نحو $count دقيقة قراءة',
      few: 'نحو $count دقائق قراءة',
      two: 'نحو دقيقتين قراءة',
      one: 'نحو دقيقة قراءة',
    );
    return '$_temp0';
  }

  @override
  String get readingRead => 'اقرأ';

  @override
  String get readingShare => 'شارك النص';

  @override
  String get readingTextSize => 'مقاس الخط';

  @override
  String get reelsEndBack => 'عودة للمكتبة';

  @override
  String get reelsEndContinue => 'متابعة بقية القائمة';

  @override
  String get reelsEndReplay => 'إعادة من البداية';

  @override
  String get reelsEndTitle => 'وصلت إلى آخر القِصار';

  @override
  String get reelsSwipeHint => 'اسحب لأعلى للمقطع التالي';

  @override
  String get refresh => 'تحديث';

  @override
  String get remove => 'إزالة';

  @override
  String get removeFromFavorites => 'إزالة من المفضلة';

  @override
  String removeUnavailable(int count) {
    return 'إزالة غير المتوفر ($count)';
  }

  @override
  String get removedFromFavorites => 'أُزيل من المفضلة';

  @override
  String get removedFromPlaylist => 'أُزيل من القائمة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get renameTag => 'إعادة تسمية الوسم';

  @override
  String get reportBug => 'الإبلاغ عن مشكلة';

  @override
  String get restoreConfirm =>
      'هل تريد استعادة البيانات من النسخة الاحتياطية؟ ستحلّ محل قوائمك ووسومك وإعداداتك الحالية.';

  @override
  String get restoreData => 'استعادة';

  @override
  String get restoreFailed => 'فشلت الاستعادة: ملف النسخة الاحتياطية غير صالح';

  @override
  String get restoreSettings => 'استعادة جميع البيانات';

  @override
  String get restoreSuccess => 'استُعيدت البيانات بنجاح';

  @override
  String resultsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نتيجة',
      few: '$count نتائج',
      two: 'نتيجتان',
      one: 'نتيجة واحدة',
      zero: 'لا نتائج',
    );
    return '$_temp0';
  }

  @override
  String get resumeSubscription => 'استئناف';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get retryAll => 'أعد محاولة الكل';

  @override
  String get saveSettings => 'حفظ الإعدادات';

  @override
  String get searchLogs => 'بحث في السجلّات…';

  @override
  String get searchVideos => 'بحث في الفيديوهات…';

  @override
  String get seekBackward10 => 'إرجاع ١٠ ثوانٍ';

  @override
  String get seekForward10 => 'تقديم ١٠ ثوانٍ';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String selected(int count) {
    return 'المحدد: $count';
  }

  @override
  String selectedCount(int count) {
    return 'المحدد: $count';
  }

  @override
  String get serverUrl => 'رابط السيرفر (Vidhoist)';

  @override
  String get settings => 'الإعدادات';

  @override
  String get settingsBackup => 'النسخ الاحتياطي';

  @override
  String get settingsDownloads => 'التحميل';

  @override
  String get settingsGroupApp => 'التطبيق';

  @override
  String get settingsGroupData => 'البيانات';

  @override
  String get settingsPlayback => 'التشغيل';

  @override
  String get settingsSaved => 'حُفظت الإعدادات';

  @override
  String get settingsTranscripts => 'النصوص والترجمة';

  @override
  String settingsValueChannels(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قناة',
      many: '$count قناة',
      few: '$count قنوات',
      two: 'قناتان',
      one: 'قناة واحدة',
      zero: 'لا قنوات بعد',
    );
    return '$_temp0';
  }

  @override
  String get settingsValueCompatOff => 'أفضل توافق: معطّل';

  @override
  String get settingsValueCompatOn => 'أفضل توافق: مفعّل';

  @override
  String get settingsValueNotSet => 'لم يُضبط بعد';

  @override
  String get settingsValueOff => 'معطّل';

  @override
  String get settingsValueOn => 'مفعّل';

  @override
  String get settingsValueQuick => 'سريع';

  @override
  String get settingsValueSubtitlesShown => 'الترجمة ظاهرة';

  @override
  String get settingsValueWifiOnly => 'Wi‑Fi فقط';

  @override
  String get share => 'مشاركة';

  @override
  String get shareLogs => 'مشاركة السجلات';

  @override
  String get shareSelected => 'مشاركة المحدد';

  @override
  String get shortsFilter => 'قِصار';

  @override
  String showChannel(String channel) {
    return 'كل مقاطع $channel';
  }

  @override
  String get shuffle => 'تشغيل عشوائي';

  @override
  String get signInRequired => 'يلزم تسجيل الدخول';

  @override
  String get size => 'الحجم';

  @override
  String get smartPlaylists => 'قوائم ذكية';

  @override
  String get sortAndFilter => 'الترتيب والتصفية';

  @override
  String get sortAndPlatform => 'الترتيب والمنصة';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get sortLargest => 'الأكبر حجماً';

  @override
  String get sortNameAZ => 'الاسم أ–ي';

  @override
  String get sortNameZA => 'الاسم ي–أ';

  @override
  String get sortNewest => 'الأحدث';

  @override
  String get sortOldest => 'الأقدم';

  @override
  String get sortSmallest => 'الأصغر حجماً';

  @override
  String get sortedByLastPlayed => 'حسب آخر تشغيل';

  @override
  String get source => 'المصدر';

  @override
  String get sourceCode => 'الشيفرة المصدرية';

  @override
  String get startDownload => 'ابدأ التحميل';

  @override
  String get status => 'الحالة';

  @override
  String get streamingFromServer => 'يُبثّ من السيرفر';

  @override
  String subscriptionAdded(String name) {
    return 'تتابع الآن $name';
  }

  @override
  String get subscriptionName => 'الاسم';

  @override
  String get subscriptionPaused => 'موقوفة مؤقتاً';

  @override
  String get subscriptionQuality => 'جودة التنزيل لهذه القناة';

  @override
  String get subscriptionQualityHelp =>
      'يثبّت السيرفر الجودة التي تختارها عند المتابعة ولا يسمح بتغييرها. لتغييرها اضغط «افحص الآن» أولاً، ثم ألغِ المتابعة وتابع القناة من جديد.\n\nقد يعني «الأفضل» دقة 4K بترميز AV1، وهي تعمل بسلاسة على الجوالات الحديثة. فإن رأيت تقطيعاً فجوالك لا يفك ترميز AV1 عتادياً: اختر 1080p، أو فعّل «أفضل توافق للتشغيل» قبل المتابعة.';

  @override
  String get subscriptionQualityNote => 'لا تُغيَّر بعد المتابعة.';

  @override
  String get subscriptions => 'الاشتراكات';

  @override
  String get subscriptionsEmpty => 'لا قنوات متابَعة بعد';

  @override
  String get subscriptionsEmptyBody =>
      'تابِع قناة، وسينزّل السيرفر تلقائياً كل مقطع جديد تنشره ليصل إلى مكتبتك مباشرة. أما ما نُشر قبل المتابعة فلا يُنزَّل.';

  @override
  String get subscriptionsSubtitle => 'قنوات يتابعها السيرفر نيابةً عنك';

  @override
  String get subtitles => 'الترجمة على الفيديو';

  @override
  String get subtitlesBackground => 'الخلفية';

  @override
  String get subtitlesBackgroundFaint => 'خفيفة';

  @override
  String get subtitlesBackgroundHelp =>
      'اللون الذي يظهر خلف الكلمات. وإن اخترت «بلا خلفية» أحاط بكل حرف حدٌّ داكن ليبقى مقروءاً فوق الصور الفاتحة.';

  @override
  String get subtitlesBackgroundNone => 'بلا خلفية';

  @override
  String get subtitlesBackgroundSolid => 'داكنة';

  @override
  String get subtitlesHide => 'إخفاء الترجمة';

  @override
  String get subtitlesInShorts => 'الترجمة في الشورتس';

  @override
  String get subtitlesInShortsHelp =>
      'معطّلة افتراضياً، لأن كثيراً من الشورتس يُكتب كلامها على الصورة أصلاً.';

  @override
  String get subtitlesLanguage => 'لغة الترجمة';

  @override
  String get subtitlesShow => 'إظهار الترجمة';

  @override
  String get subtitlesShowHelp =>
      'تظهر فوق الفيديو في المقاطع التي لها نص، ويؤدي زر CC في المشغّل العمل نفسه.';

  @override
  String get subtitlesSize => 'حجم الخط';

  @override
  String get subtitlesSizeLarge => 'كبير';

  @override
  String get subtitlesSizeMedium => 'متوسط';

  @override
  String get subtitlesSizeSmall => 'صغير';

  @override
  String get syncDeviceQuiet =>
      'لم يصل منه شيء منذ أكثر من يومين. إن كان مستعملاً فالأرجح أن برنامج المزامنة متوقف أو نائم، عليه أو هنا، فالجوال يُنيم التطبيقات التي يظنها غير مستعملة.';

  @override
  String get syncPhoneCameBack =>
      'غاب هذا الجوال أكثر من 90 يوماً، فأُخذت بيانات أجهزتك الأخرى أولاً.';

  @override
  String get syncPhoneFailed =>
      'تعذّرت قراءة مجلد المزامنة. اختره من جديد إن نُقل أو سُحب إذنه.';

  @override
  String syncPhoneForgetBody(String device) {
    return 'لن يُقرأ $device بعد الآن، وتُنقل نصوصه إلى مجلد هذا الجوال أولاً فلا يضيع منها شيء. استعمله لجهاز ضاع أو بِيع.';
  }

  @override
  String get syncPhoneGuide =>
      'داخل البيت: Syncthing-Fork (من F-Droid) على هذا الجوال وSyncthing على الكمبيوتر يتشاركان مجلداً واحداً، واضبطه على «Wi‑Fi فقط» توفيراً للبطارية. وعبر السحابة: FolderSync مع المجلد السحابي الذي يستعمله الكمبيوتر.';

  @override
  String get syncPhoneHint =>
      'تعكس الوسوم والمفضلة والقوائم ومواضع التوقف والنصوص بين هذا الجوال وVidhoist على الكمبيوتر، عبر مجلد يزامنه برنامج تختاره. ولا يُرسَل شيء من هنا إلى أي خدمة.';

  @override
  String get syncPhoneNoOthers =>
      'لا جهاز آخر في هذا المجلد بعد. شغّل المزامنة في Vidhoist على الكمبيوتر بالمجلد نفسه.';

  @override
  String get syncPhoneOff => 'متوقفة، ولا يخرج شيء من هذا الجوال.';

  @override
  String syncPhoneThisDevice(String name) {
    return 'هذا الجوال: $name';
  }

  @override
  String get syncTitle => 'المزامنة مع الكمبيوتر';

  @override
  String get tagActionsHint => 'اضغط مطوّلاً على وسم لإعادة تسميته أو حذفه.';

  @override
  String get tagFilterHint =>
      'اضغط الوسم لإظهار مقاطعه، ومرة ثانية لإخفائها، وثالثة لإلغائه.';

  @override
  String tagLimitReached(int max) {
    return 'الحد الأقصى $max وسماً. احذف وسماً من «إدارة الوسوم» لتضيف غيره.';
  }

  @override
  String get tags => 'الوسوم';

  @override
  String get tagsOpenFiltered => 'تفتح المكتبة مصفّاةً بالوسم';

  @override
  String get theme => 'السمة';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeSystem => 'النظام';

  @override
  String get titleFilter => 'نزّل فقط المقاطع التي يحتوي عنوانها على';

  @override
  String get titleFilterHelp =>
      'لا ينزّل السيرفر مقطعاً جديداً من هذه القناة إلا إذا احتوى عنوانه على ما تكتبه هنا.\n\n• كلمة عادية تكفي: الحلقة\n• أيّ كلمة من عدة كلمات: الحلقة|الجزء (العلامة | تعني «أو»)\n• في الإنجليزية يُفرَّق بين الأحرف الكبيرة والصغيرة: episode لا تطابق Episode. اكتب ‎[Ee]pisode‎ أو اكتب الصيغتين.\n\nوالمقطع الذي يتخطاه الفلتر يُعدّ مُشاهَداً إلى الأبد، فإن أزلت الفلتر لاحقاً نُزِّل ما يُنشر بعد ذلك فقط، لا ما تخطّاه.';

  @override
  String get titleFilterHelper =>
      'لعدة كلمات افصل بينها بـ | ، واتركه فارغاً لتنزيل كل شيء.';

  @override
  String get titleFilterHint => 'مثال: الحلقة';

  @override
  String get titleLabel => 'العنوان';

  @override
  String totalDuration(Object duration) {
    return 'الإجمالي: $duration';
  }

  @override
  String get transcript => 'النص';

  @override
  String get transcriptFind => 'ابحث في النص';

  @override
  String get transcriptFull => 'النص الكامل';

  @override
  String transcriptMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count موضع',
      many: '$count موضعاً',
      few: '$count مواضع',
      two: 'موضعان',
      one: 'موضع واحد',
      zero: 'لا مواضع',
    );
    return '$_temp0';
  }

  @override
  String get transcriptNextMatch => 'الموضع التالي';

  @override
  String get transcriptPeekHint => 'اضغط للنص كاملاً';

  @override
  String get transcriptPreviousMatch => 'الموضع السابق';

  @override
  String transcriptSaidMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'قيلت $count مرة أخرى',
      many: 'قيلت $count مرة أخرى',
      few: 'قيلت $count مرات أخرى',
      two: 'قيلت مرتين أخريين',
      one: 'قيلت مرة أخرى',
    );
    return '$_temp0';
  }

  @override
  String get transcriptSwitchLanguage => 'بدّل لغة النص';

  @override
  String transcriptsClips(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مقطع',
      many: '$count مقطعاً',
      few: '$count مقاطع',
      two: 'مقطعان',
      one: 'مقطع واحد',
      zero: 'لا مقاطع بعد',
    );
    return '$_temp0';
  }

  @override
  String get transcriptsDeleteAll => 'حذف الكل';

  @override
  String get transcriptsDeleteBody =>
      'تُحذف من هذا الجوال، ولا يعيدها إلا ملف صدّرته.';

  @override
  String get transcriptsDeleteTitle => 'حذف كل النصوص؟';

  @override
  String transcriptsDisableBody(String size) {
    return 'النصوص المحفوظة ($size) تبقى في هذا الجوال ما لم تحذفها.';
  }

  @override
  String get transcriptsDisableTitle => 'إيقاف البحث داخل المقاطع؟';

  @override
  String get transcriptsEnable => 'تفعيل';

  @override
  String get transcriptsEnableBody =>
      'حين تضيف مقطع يوتيوب، يجلب التطبيق نصّه من سيرفرك قبل تنزيله، بلغة التطبيق وبالإنجليزية، وقد يستغرق ذلك حتى 40 ثانية، ثم يحفظه في هذا الجوال وحده. أما المقاطع الموجودة في مكتبتك فلا تُشمل إلا إن كان سيرفرك يحفظ ملف الترجمة بجانب كل منها (يشرح دليل الإعداد طريقة ذلك). ويمكنك إيقاف الميزة متى شئت.';

  @override
  String get transcriptsExport => 'تصدير';

  @override
  String transcriptsExported(Object path) {
    return 'حُفظت النصوص في: $path';
  }

  @override
  String get transcriptsHelp =>
      'يحفظ التطبيق ما يُقال في كل مقطع يوتيوب تضيفه، فيبحث بحث المكتبة في كلام مقاطعك لا في عناوينها وحدها.\n\nيُجلب الكلام من سيرفرك قبيل التنزيل ويُحفظ في هذا الجوال، ولا تشمله النسخة الاحتياطية الكاملة. لنقله إلى جوال آخر استعمل «تصدير» هنا و«استيراد» هناك، والاستيراد يضيف إلى الموجود ولا يحذف شيئاً.\n\nوإن ضبطت سيرفرك ليحفظ ملف الترجمة بجانب كل مقطع (سطر واحد في إعداداته يشرحه دليل الإعداد)، شُمل كل ما ينزّله من ذلك الحين، بما فيه مقاطع الاشتراكات والمواقع الأخرى، إذ يقرأ التطبيق تلك الملفات تلقائياً بلغة التطبيق وبالإنجليزية.';

  @override
  String get transcriptsImport => 'استيراد';

  @override
  String get transcriptsImportInvalid => 'هذا الملف لا يحوي نصوصاً.';

  @override
  String transcriptsImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'استُورد $count نص',
      many: 'استُورد $count نصاً',
      few: 'استُورد $count نصوص',
      two: 'استُورد نصّان',
      one: 'استُورد نص واحد',
    );
    return '$_temp0';
  }

  @override
  String get transcriptsKeep => 'إيقاف والاحتفاظ بالنصوص';

  @override
  String get transcriptsSaidInside => 'قيل داخل المقاطع';

  @override
  String get transcriptsSearch => 'البحث داخل المقاطع';

  @override
  String get transcriptsSearchHelp =>
      'يحفظ ما يُقال في كل مقطع يوتيوب تضيفه، لتبحث في كلامه لا في عنوانه وحده.';

  @override
  String get transcriptsStopAndDelete => 'إيقاف وحذف';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get undo => 'تراجع';

  @override
  String get unfollow => 'إلغاء المتابعة';

  @override
  String unfollowConfirm(String name) {
    return 'إلغاء متابعة $name؟';
  }

  @override
  String get unfollowConfirmBody =>
      'سينسى السيرفر المقاطع التي سبق أن رآها من هذه القناة. فإن تابعتها لاحقاً عُدَّ كل ما عليها حينها مُشاهَداً، ولن يُنزَّل ما فاتك. أما الإيقاف المؤقت فيحفظ هذا السجل.';

  @override
  String get unlockTouch => 'فك القفل';

  @override
  String get unpinPlaylist => 'إلغاء التثبيت';

  @override
  String get upNext => 'التالي';

  @override
  String upNextIn(String name) {
    return 'التالي في «$name»';
  }

  @override
  String get updateAllowInstallBody =>
      'يطلب أندرويد إذنك قبل أن يثبّت التطبيق تحديثاته بنفسه. امنحه مرة واحدة من إعدادات النظام، ثم عد واضغط «تثبيت».';

  @override
  String get updateAllowInstallTitle => 'السماح بتثبيت التحديثات';

  @override
  String get updateAvailable => 'يتوفّر تحديث';

  @override
  String get updateCheckFailed => 'تعذّر التحقق من التحديثات';

  @override
  String get updateChecking => 'جارٍ التحقق…';

  @override
  String get updateDownloadFailed => 'تعذّر تنزيل التحديث';

  @override
  String get updateDownloading => 'جارٍ تنزيل التحديث…';

  @override
  String get updateFailedToStart => 'تعذّر فتح شاشة التثبيت';

  @override
  String get updateInstall => 'تثبيت';

  @override
  String get updateLater => 'لاحقاً';

  @override
  String get updateNever => 'لم يحدث بعد';

  @override
  String get updateNow => 'تنزيل التحديث';

  @override
  String get updateOpenSystemSettings => 'فتح الإعدادات';

  @override
  String get updateReady => 'جاهز للتثبيت';

  @override
  String updateSizeMb(String size) {
    return '$size ميغابايت';
  }

  @override
  String get updateSkipVersion => 'تخطّي هذا الإصدار';

  @override
  String get updateUpToDate => 'لديك أحدث إصدار';

  @override
  String updateVersionAvailable(String version) {
    return 'الإصدار $version متاح';
  }

  @override
  String get updateWhatsNew => 'ما الجديد';

  @override
  String get updates => 'التحديثات';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get version => 'الإصدار';

  @override
  String get videoAdded => 'أُضيف إلى القائمة';

  @override
  String get videoPlayer => 'مشغّل الفيديو';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get viewAllInPlaylists => 'عرض الكل';

  @override
  String get viewCards => 'بطاقات';

  @override
  String get viewGrid => 'شبكة';

  @override
  String get viewList => 'قائمة';

  @override
  String get viewMode => 'العرض';

  @override
  String get waitingForWifi => 'بانتظار Wi‑Fi';

  @override
  String get whatsNewGotIt => 'حسناً';

  @override
  String get whatsNewReleasePage => 'صفحة الإصدار';

  @override
  String get whatsNewThisVersion => 'الجديد في هذا الإصدار';

  @override
  String whatsNewTitle(String version) {
    return 'الجديد في الإصدار $version';
  }

  @override
  String get whatsNewUnavailable =>
      'ما تغيّر في هذا الإصدار تجده في صفحة الإصدار.';

  @override
  String get wifiOnly => 'التحميل عبر Wi‑Fi فقط';

  @override
  String get wifiOnlyHelp =>
      'لا يُنزَّل شيء عبر بيانات الجوّال. تنتظر التنزيلات شبكة Wi‑Fi، وما كان جارياً حين تنقطع يتوقف مؤقتاً ثم يُستأنف وحده عند عودتها.';

  @override
  String get yourChannels => 'قنواتك';

  @override
  String get yourChannelsHint => 'تابعتها من الإعدادات أو من المشغّل';

  @override
  String get yourLibrary => 'مكتبتك';

  @override
  String get yourPlaylists => 'قوائمك';

  @override
  String get yourTags => 'وسومك';

  @override
  String get ytdlpCredit => 'أداة التنزيل التي يعتمد عليها Vidhoist';
}
