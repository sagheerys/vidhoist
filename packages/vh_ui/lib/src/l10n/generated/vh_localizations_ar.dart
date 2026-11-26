// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'vh_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class VhLocalizationsAr extends VhLocalizations {
  VhLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get about => 'عن التطبيق';

  @override
  String get aboutApp => 'عن التطبيق';

  @override
  String get aboutDescriptionPhone =>
      'تطبيق خفيف وسريع لتنزيل الفيديو والصوت من مواقع كثيرة بـyt-dlp، وفيه مشغّل مدمج وقوائم تشغيل.';

  @override
  String get accountSignIn => 'تسجيل الدخول';

  @override
  String get accountSignOut => 'خروج';

  @override
  String get accountSignedIn => 'مسجّل الدخول';

  @override
  String get accountSignedOut => 'غير مسجّل';

  @override
  String accountSignedOutOf(String site) {
    return 'خرجت من $site';
  }

  @override
  String get accountsBanRisk =>
      'يُفضّل استخدام حساب ثانوي: التنزيل الكثيف قد يعرّض الحساب لتقييد مؤقت من الموقع.';

  @override
  String get accountsClearAll => 'حذف كل الكوكيز';

  @override
  String get accountsCleared => 'حُذفت الكوكيز';

  @override
  String get accountsFileHint =>
      'ملف cookies.txt مصدَّر من متصفح (بصيغة Netscape)، لأي موقع، حتى غير المذكور أعلاه. يُضاف إلى ما سجّلت دخوله هنا، ويبقى على هذا الجوال.';

  @override
  String get accountsFilePick => 'اختر ملف كوكيز';

  @override
  String get accountsFileTitle => 'أو استورد ملف كوكيز';

  @override
  String get accountsFromFile => 'من ملف كوكيز';

  @override
  String get accountsHelp =>
      'تنتهي صلاحية تسجيل الدخول بعد مدة؛ فإن عاد موقع يرفض، سجّل الدخول مرة أخرى. الخروج من موقع يُخرج متصفح التطبيق من المواقع الأخرى أيضاً، وتبقى تنزيلاتها تعمل كما كانت. وإن رفض موقع تسجيل الدخول هنا، فاستورد ملف كوكيز من متصفح كمبيوترك في الأسفل.';

  @override
  String get accountsHint =>
      'للمواقع التي ترفض التنزيل بلا تسجيل دخول. تسجّل الدخول في صفحة الموقع نفسها داخل التطبيق، وما يتركه يبقى على هذا الجوال حيث يقرؤه yt-dlp في كل تنزيل، ولا يذهب إلى أي مكان آخر.';

  @override
  String get activeDownloads => 'التنزيلات النشطة';

  @override
  String activeDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تنزيلاً جارياً',
      few: '$count تنزيلات جارية',
      two: 'تنزيلان جاريان',
      one: 'تنزيل واحد جارٍ',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloadsSheet => 'التنزيلات الجارية';

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
  String get allDownloadsFinished => 'اكتملت جميع التنزيلات';

  @override
  String get allPlatforms => 'كل المواقع';

  @override
  String get alreadyInPlaylist => 'موجود في القائمة';

  @override
  String get alreadySubscribed => 'أنت تتابع هذه القناة بالفعل';

  @override
  String get appTitle => 'VidHoist';

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
  String get audioFormat => 'صيغة الصوت';

  @override
  String get audioFormatM4a => 'M4A: يعمل في كل مكان';

  @override
  String get audioFormatMp3 => 'MP3: للمشغّلات القديمة والسيارات';

  @override
  String get audioFormatOriginal => 'كما يرسله الموقع، بلا تحويل';

  @override
  String get audioMono => 'أحادي';

  @override
  String get audioOnly => 'صوت فقط';

  @override
  String get audioStereo => 'ستيريو';

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
      'إذا فشل تنزيل بسبب انقطاع الشبكة أعاده التطبيق تلقائياً حين تعود. أما ما رفضه الموقع فلا يُعاد، لأن تكراره دون تغيير سيفشل مجدداً.';

  @override
  String get backgroundChecks => 'الفحص والتطبيق مغلق';

  @override
  String get backgroundChecksHelp =>
      'كل ست ساعات تقريباً، حين تتوفر الشبكة ولا تكون البطارية منخفضة. يخبرك بالجديد فقط، والمقاطع تُنزَّل حين تفتح VidHoist.';

  @override
  String get backgroundDownload => 'جارٍ تنزيل الملفات في الخلفية…';

  @override
  String backgroundLastRun(String when) {
    return 'آخر فحص والتطبيق مغلق: $when';
  }

  @override
  String get backgroundNotRunYet =>
      'لم يجرِ فحص والتطبيق مغلق بعد: أندرويد يختار وقته.';

  @override
  String get backgroundOfferBody =>
      'يستطيع VidHoist أن يفحص قنواتك كل ست ساعات تقريباً ويخبرك بالجديد. لا يُنزَّل شيء حتى تفتح التطبيق.';

  @override
  String get backgroundOfferNo => 'ليس الآن';

  @override
  String get backgroundOfferTitle =>
      'أتريد أن تعرف بالمقاطع الجديدة والتطبيق مغلق؟';

  @override
  String get backgroundOfferYes => 'تفعيل';

  @override
  String get backupNote =>
      'تشمل النسخة المكتبة والقوائم والوسوم والقنوات المتابَعة والإعدادات. أما تسجيلات الدخول والنصوص فتُحفظ منفصلة، ولا تشمل النسخة ملفات الوسائط نفسها.';

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
  String get batchDownloadSelected => 'تنزيل المحدد';

  @override
  String get batchLoading => 'جارٍ قراءة القائمة…';

  @override
  String get batchNothingSelected => 'اختر عنصراً واحداً على الأقل';

  @override
  String batchSelectedOf(int selected, int total) {
    return 'حُدِّد $selected من $total';
  }

  @override
  String get batchThisVideoOnly => 'تنزيل هذا المقطع فقط';

  @override
  String get batchTitle => 'التنزيل الدفعي';

  @override
  String get batteryAllow => 'سماح';

  @override
  String get batteryFree =>
      'توفير البطارية لا يوقف التنزيلات، حتى والتطبيق في الخلفية.';

  @override
  String get batteryRestricted =>
      'توفير البطارية قد يوقف التنزيل الطويل والتطبيق في الخلفية.';

  @override
  String get batteryStateFree => 'مسموح';

  @override
  String get batteryStateLimited => 'مقيّد';

  @override
  String get batteryTitle => 'التنزيل في الخلفية';

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
  String channelFollowers(String count) {
    return '$count مشترك';
  }

  @override
  String get channelCheckFailed =>
      'تعذّر فحصها هذه المرة، وسيحاول VidHoist مجدداً من تلقاء نفسه.';

  @override
  String get channelUrl => 'رابط قناة أو قائمة أو أحد مقاطعها';

  @override
  String get channelUrlHint => 'https://www.youtube.com/@name';

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
  String get clipEndAfterStart => 'بعد وقت البداية';

  @override
  String get clipFrom => 'من';

  @override
  String clipLength(Object length) {
    return 'طول المقطع $length';
  }

  @override
  String get clipLengthReading => 'يُقرأ طول المقطع…';

  @override
  String get clipLengthUnknown =>
      'الموقع لا يذكر طول المقطع، فلن تُقارَن الأوقات به';

  @override
  String get clipMinuteDown => 'دقيقة أبكر';

  @override
  String get clipMinuteUp => 'دقيقة لاحقاً';

  @override
  String get clipOnly => 'جزء من المقطع فقط';

  @override
  String get clipOnlyHelp =>
      'من وقت إلى آخر، بلا بقية المقطع. ويأتي بلا ترجمة.';

  @override
  String clipPastEnd(Object length) {
    return 'ينتهي المقطع عند $length';
  }

  @override
  String get clipTimeHint => 'بالأرقام وحدها: 130 تعني 1:30';

  @override
  String get clipTo => 'إلى';

  @override
  String get clipboardFound => 'رابط جاهز في الحافظة';

  @override
  String get clipboardLinkReady => 'لصق الرابط';

  @override
  String get closePlayer => 'إغلاق المشغل';

  @override
  String get columnAdded => 'تاريخ الإضافة';

  @override
  String get columnChannel => 'القناة';

  @override
  String get columnLength => 'المدة';

  @override
  String get compactView => 'عرض مختصر';

  @override
  String get compatiblePlayback => 'أفضل توافق للتشغيل';

  @override
  String get compatiblePlaybackHelp =>
      'يطلب صيغة H.264/AAC التي تشغّلها كل الجوالات بعتادها مباشرة. وإن أطفأته أتاح لك أعلى دقة، لكن يوتيوب قد يرسل حينها صيغة AV1 فتظهر الصورة مشوّشة على أجهزة كثيرة.';

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
  String get cookiesNotNetscape =>
      'لا يحوي أيٌّ من هذه الملفات كوكيز بصيغة Netscape';

  @override
  String get cookiesSubtitle => 'للمواقع التي ترفض التنزيل بلا تسجيل دخول';

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
  String get defaultQuality => 'جودة الفيديو الافتراضية';

  @override
  String get delete => 'حذف';

  @override
  String deleteMultipleConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'حذف $count مقطع؟\n\nستُزال ملفاتها من جهازك.',
      many: 'حذف $count مقطعاً؟\n\nستُزال ملفاتها من جهازك.',
      few: 'حذف $count مقاطع؟\n\nستُزال ملفاتها من جهازك.',
      two: 'حذف مقطعين؟\n\nسيُزال ملفاهما من جهازك.',
      one: 'حذف مقطع واحد؟\n\nسيُزال ملفه من جهازك.',
    );
    return '$_temp0';
  }

  @override
  String deletePlaylistConfirm(Object name) {
    return 'حذف «$name»؟';
  }

  @override
  String get deleteRefused =>
      'لم يُحذف: أندرويد يحتاج إذنك لحذف هذا الملف، في النافذة التي يعرضها.';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get deleteTag => 'حذف الوسم';

  @override
  String deleteTagConfirm(Object tag) {
    return 'حذف الوسم «$tag» من كل العناصر؟ لن تُحذف المقاطع نفسها.';
  }

  @override
  String get deleteVideo => 'حذف المقطع';

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
      'يحتفظ هذا الكمبيوتر بآخر سبع نسخ احتياطية، بين كل نسخة والتي تليها ساعة على الأقل، في Downloads\\VidHoist\\Backups، فتبقى إن حُذف التطبيق.';

  @override
  String get desktopBackupsNone => 'لا نسخة بعد';

  @override
  String get desktopBrowserButton => 'زر «إلى VidHoist» في المتصفح';

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
  String get desktopBrowserButtonName => 'إلى VidHoist';

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
      'في صفحة أي مقطع انقره، فيفتح VidHoist نافذة الإضافة بالرابط. وفي المرة الأولى يسألك المتصفح هل يفتح التطبيق، فاسمح له.';

  @override
  String get desktopBrowserPageTitle => 'أضف زر «إلى VidHoist» إلى متصفحك';

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
  String get desktopChannelsLater => 'تحتاج محرّك التنزيل';

  @override
  String get desktopChannelsLaterBody =>
      'متابعة القنوات تحتاج yt-dlp على هذا الكمبيوتر. جهّزه من الإعدادات › المحرّك، فتظهر قنواتك هنا.';

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
  String get desktopCloseAnyway => 'أغلق';

  @override
  String desktopCloseBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إن أغلقت VidHoist الآن تتوقف، ثم تكمل من حيث توقفت حين تفتحه مرة أخرى.',
      two: 'إن أغلقت VidHoist الآن يتوقفان، ثم يكملان من حيث توقفا حين تفتحه مرة أخرى.',
      one: 'إن أغلقت VidHoist الآن يتوقف، ثم يكمل من حيث توقف حين تفتحه مرة أخرى.',
    );
    return '$_temp0';
  }

  @override
  String get desktopCloseKeep => 'أكمل التنزيل';

  @override
  String desktopCloseMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ومعه $count تنزيل آخر',
      many: 'ومعه $count تنزيلاً آخر',
      few: 'ومعه $count تنزيلات أخرى',
      two: 'ومعه تنزيلان آخران',
      one: 'ومعه تنزيل آخر',
    );
    return '$_temp0';
  }

  @override
  String desktopCloseTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تنزيل لم ينتهِ',
      many: '$count تنزيلاً لم ينتهِ',
      few: '$count تنزيلات لم تنتهِ',
      two: 'تنزيلان لم ينتهيا',
      one: 'تنزيل لم ينتهِ',
    );
    return '$_temp0';
  }

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
  String get desktopCookiesKept => 'الكوكيز محفوظة على هذا الكمبيوتر';

  @override
  String desktopCookiesKeptFor(String sites) {
    return 'حُفظت الكوكيز لـ: $sites';
  }

  @override
  String get desktopCookiesLocalHint =>
      'للمواقع التي تطلب تسجيل الدخول. يقرؤها yt-dlp على هذا الكمبيوتر ولا تذهب إلى أي مكان آخر.';

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
  String get desktopDesktopSection => 'ويندوز';

  @override
  String get desktopDiscover => 'اكتشف VidHoist';

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
      'زر «إلى VidHoist» في شريط الإشارات المرجعية يفتح نافذة الإضافة بالصفحة التي أنت فيها.';

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
  String get desktopDiscoverDragOutLine =>
      'أفلته في مجلد أو برنامج آخر، فيصل إليه ملفاً.';

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
      'بطاقة صغيرة فوق كل النوافذ، في الزاوية السفلية من الشاشة.';

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
      'تُحفظ التنزيلات هنا ملفاتٍ عادية، تفتحها أو تنقلها أو تنسخها كأي ملف آخر.';

  @override
  String get desktopDownloads => 'التنزيلات';

  @override
  String get desktopDownloadsEmpty => 'لا شيء قيد التنزيل. أضف رابطاً ليبدأ.';

  @override
  String get desktopDownloadsRunning => 'جارية';

  @override
  String get desktopDragToReorder => 'اسحب لتغيير الترتيب';

  @override
  String get desktopDropLinks => 'أفلِته لإضافته';

  @override
  String get desktopEmptyLibraryMessage =>
      'أضِف رابطاً فيظهر المقطع هنا بعد تنزيله.';

  @override
  String get desktopEngine => 'المحرّك';

  @override
  String get desktopEngineDenoHint =>
      'يجتاز فحص يوتيوب، لتتاح كل الجودات التي يعرضها';

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
      'yt-dlp غير موجود على هذا الكمبيوتر. أعد تثبيت VidHoist، أو نزّله من هنا.';

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
  String get desktopExportPhone => 'للجوال (ملف الاستيراد في VidHoist)';

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
  String get desktopFirstLinkKeys => 'في أي مكان من النافذة يفعل الشيء نفسه';

  @override
  String get desktopFirstLinkNote =>
      'من يوتيوب أو أي موقع آخر. يظهر المقطع هنا لحظة بدء تنزيله.';

  @override
  String get desktopFirstLinkPaste => 'لصق';

  @override
  String get desktopFirstLinkTitle => 'الصق أول رابط';

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
  String get desktopHintTrayTitle => 'ما زال VidHoist يعمل';

  @override
  String get desktopHints => 'إظهار التلميحات';

  @override
  String get desktopHintsAgain => 'أعد عرضها';

  @override
  String get desktopHintsHint =>
      'تلميحان قصيران، يظهر كل منهما مرة واحدة: الاختصارات مع أول مقطع، وأيقونة الساعة مع أول إغلاق.';

  @override
  String get desktopImportFromPhone => 'استيراد نسخة احتياطية أو نصوص…';

  @override
  String get desktopImportHint =>
      'نسخة احتياطية أو ملف نصوص من VidHoist، تختاره هنا أو تُفلته على النافذة. نسخة الجوال تُضاف إلى ما هنا، ونسخة هذا الكمبيوتر تُستعاد كاملة بعد سؤالك.';

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
  String get desktopKeepAwake => 'أبقِ الكمبيوتر مستيقظاً أثناء التنزيل';

  @override
  String get desktopKeepAwakeHint =>
      'حتى يكتمل ما أرسلته من الجوال أو قائمة طويلة، بدل أن يتوقف حين ينام ويندوز. الشاشة تنطفئ كالعادة.';

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
  String get desktopLanguageSystemHint => 'يتبع لغة ويندوز.';

  @override
  String desktopLastArrival(String when) {
    return 'آخر وصول $when';
  }

  @override
  String get desktopLess => 'أقل';

  @override
  String desktopLibraryDownloading(int count) {
    return '$count قيد التنزيل';
  }

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
    return 'أُخذت الروابط الأولى فقط ($limit)، وتُرك الباقي ($count).';
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
      'مقاطع مكتبتك لا تحمل اسم قناتها، فلا يُعرف هنا ما نزل من هذه القناة. لتظهر مقاطعها، تابِعها بمجلد خاص بها: كل ما ينزل في مجلدها يظهر هنا.';

  @override
  String get desktopNoFavoritesMessage => 'ضع قلباً على مقطع فيبقى لك هنا.';

  @override
  String get desktopNoFavoritesTitle => 'لا مفضلة بعد';

  @override
  String get desktopNoMatchMessage => 'ألغِ إحدى التصفيات لترى أكثر.';

  @override
  String get desktopNoMatchTitle => 'لا شيء يطابق هذه التصفية';

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
      'هذا الملف ليس نسخة احتياطية ولا ملف نصوص من VidHoist.';

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
      'إشعار من ويندوز حين تُنزَّل مقاطع جديدة من القنوات التي تتابعها.';

  @override
  String get desktopOfferCopiedLinks => 'اعرض عليّ الروابط التي أنسخها';

  @override
  String get desktopOfferCopiedLinksHint =>
      'حين تنسخ رابط مقطع في برنامج آخر، يعرض عليك إشعارٌ إضافته. لا يُنظر إلا في الروابط، ولا يُحفظ منها شيء.';

  @override
  String get desktopOpenBackup => 'فتح النسخ الاحتياطي';

  @override
  String get desktopOpenChannels => 'افتح القنوات';

  @override
  String get desktopOpenInExplorer => 'فتح في مستكشف الملفات';

  @override
  String get desktopOpenWith => 'فتح بمشغّل آخر…';

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
  String get desktopPaletteRecent => 'آخر ما شُغِّل';

  @override
  String get desktopPaletteSaid => 'قيل داخل المقاطع';

  @override
  String get desktopPaletteSave => 'احفظ هذا البحث';

  @override
  String get desktopPaletteSaved => 'بحوث محفوظة';

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
  String get desktopRecoverLibrary => 'مقاطع موجودة في المجلد';

  @override
  String get desktopRecoverLibraryAction => 'ابحث في المجلد';

  @override
  String get desktopRecoverLibraryHint =>
      'بعد إعادة التثبيت: يعيد إلى المكتبة المقاطع الموجودة في مجلد التنزيلات وغابت عنها. لا تُمسّ الملفات.';

  @override
  String desktopRecovered(int count) {
    return 'أُعيد إلى المكتبة: $count';
  }

  @override
  String get desktopRecoveredNothing =>
      'لا شيء يُضاف: كل مقاطع المجلد في المكتبة.';

  @override
  String desktopRecoveredSome(int count, int left) {
    return 'أُعيد إلى المكتبة: $count. تُرك ما لا يُعرف رابطه: $left';
  }

  @override
  String get desktopRemoveFromList => 'أزله من القائمة';

  @override
  String get desktopRestore => 'استعادة';

  @override
  String get desktopRestoreBody =>
      'تصبح مكتبة هذا الكمبيوتر وقنواته المتابَعة ووسومه وقوائمه وإعداداته كما في النسخة، ولا تُمسّ الملفات المنزّلة.';

  @override
  String desktopRestoreOfferBody(String when) {
    return 'في Downloads\\VidHoist\\Backups نسخة احتياطية لهذا الكمبيوتر فيها مكتبته وقنواته المتابَعة وقوائمه ووسومه وإعداداته ونصوصه المحفوظة. أحدثها $when. ولا تُمسّ ملفاتك المنزّلة في الحالتين.';
  }

  @override
  String get desktopRestoreOfferTitle => 'استعادة نسختك الاحتياطية؟';

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
  String get desktopStartFresh => 'ابدأ من جديد';

  @override
  String get desktopStartWithWindows => 'التشغيل مع بدء ويندوز';

  @override
  String get desktopStartWithWindowsHint =>
      'يفتح عند تسجيل الدخول: في الدرج إن كان يستمر في التشغيل هناك، وإلا مصغَّراً.';

  @override
  String get desktopStartWithWindowsRefused =>
      'لم يسمح ويندوز للتطبيق بالبدء معه.';

  @override
  String get desktopStats => 'إحصاءات المكتبة';

  @override
  String get desktopStatsByChannel => 'حسب القناة';

  @override
  String get desktopStatsByMonth => 'حسب شهر الإضافة';

  @override
  String get desktopStatsBySite => 'حسب الموقع';

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
  String get desktopTheater => 'وضع المسرح';

  @override
  String get desktopTranscriptFirst => 'اجلب نصّه أولاً';

  @override
  String get desktopTranscriptHint => 'يتبع التشغيل · انقر سطراً ليُشغَّل منه';

  @override
  String get desktopTranscriptHintPage =>
      'نص هذا المقطع · انقر سطراً ليُشغَّل منه';

  @override
  String get desktopTranscriptsDeleteBody =>
      'تُحذف من هذا الكمبيوتر ومن نسخته الاحتياطية، ولا يعيدها إلا ملف صدّرته.';

  @override
  String get desktopTranscriptsHelp =>
      'يحفظ VidHoist ما يُقال في كل مقطع يوتيوب تضيفه، فيجد البحث (Ctrl+K) ما قيل داخل مقاطعك لا عناوينها وحدها. وتبقى النصوص على هذا الكمبيوتر.';

  @override
  String get desktopTranscriptsMove => 'من الجوال وإليه';

  @override
  String get desktopTranscriptsMoveHint =>
      'النصوص تنتقل مع النسخة الاحتياطية: «تصدير للجوال» يأخذها، و«استيراد» هناك يُدخلها ويضيف ما ينقص هنا.';

  @override
  String get desktopTrayOnClose => 'يبقى التشغيل في الدرج عند إغلاق النافذة';

  @override
  String get desktopTrayOnCloseHint =>
      'إغلاق النافذة يُبقي الصوت شغالاً، والخروج من الأيقونة بجانب الساعة.';

  @override
  String get desktopTrayOpen => 'فتح VidHoist';

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
      'يُغلَق VidHoist ويثبّت التحديث ثم يُفتح من جديد، وتبقى إعداداتك ومكتبتك كما هي.';

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
      'الصق رابطاً من يوتيوب أو أي موقع آخر، فينزّله VidHoist إلى هذا الكمبيوتر بمحرّك yt-dlp.';

  @override
  String get desktopWelcomeStart => 'ابدأ';

  @override
  String get desktopWelcomeTitle => 'أهلاً بك في VidHoist';

  @override
  String get desktopWhatsNewAllFeatures => 'وكل مزايا VidHoist';

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
      'ينزّل هذا التطبيق الوسائط بـyt-dlp، والمطوّر غير مسؤول عن طريقة استخدامه. يُرجى احترام حقوق النشر وشروط استخدام المواقع التي تنزّل منها.';

  @override
  String get dismiss => 'تجاهل';

  @override
  String get done => 'تم';

  @override
  String get download => 'تنزيل';

  @override
  String get downloadComplete => 'اكتمل التنزيل';

  @override
  String get downloadCompleteTitle => 'اكتمل';

  @override
  String get downloadDate => 'تاريخ التنزيل';

  @override
  String get downloadFailed => 'فشل التنزيل';

  @override
  String get downloadFailedTitle => 'فشل التنزيل';

  @override
  String get downloadNow => 'تنزيل';

  @override
  String get downloadStarted => 'بدأ التنزيل…';

  @override
  String downloadStartedQuality(Object quality) {
    return 'بدأ التنزيل · $quality';
  }

  @override
  String get downloading => 'جارٍ التنزيل…';

  @override
  String get downloadingTitle => 'جارٍ التنزيل';

  @override
  String get downloadsAdvanced => 'متقدّم';

  @override
  String get editSubscription => 'تعديل';

  @override
  String get embedSubtitles => 'الترجمة داخل ملف الفيديو أيضاً';

  @override
  String get embedSubtitlesHelp =>
      'لتظهر في المشغّلات الأخرى. مشغّل VidHoist يعرضها في الحالتين.';

  @override
  String get emptyFilteredMessage =>
      'ألغِ إحدى التصفيات في الأعلى لترى مكتبتك كلها.';

  @override
  String get emptyFilteredTitle => 'لا شيء يطابق هذه التصفية';

  @override
  String get emptyPlaylist => 'قائمة فارغة';

  @override
  String get emptyPlaylistMessage => 'أضِف مقاطع من المكتبة';

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
      'محرّك التنزيل مفقود أو ناقص. أصلحه من الإعدادات بزر «أصلح المحرّك»';

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
  String get engineRepair => 'أصلح المحرّك';

  @override
  String get engineRepairBusy => 'انتظر انتهاء التنزيلات ثم أصلح';

  @override
  String get engineRepairHint =>
      'حين تفشل التنزيلات في مواقع كثيرة على غير عادتها ولم ينفع التحديث: يمسح ما حفظه yt-dlp ويضع نسخة سليمة محدّثة منه. تنزيلاتك وإعداداتك تبقى كما هي.';

  @override
  String get engineRepairPartly =>
      'أُصلح جزئياً: الباقي يحتاج اتصالاً بالإنترنت. أعد المحاولة حين تتصل.';

  @override
  String engineRepaired(String version) {
    return 'أُصلح: yt-dlp $version';
  }

  @override
  String get engineRepairing => 'جارٍ الإصلاح…';

  @override
  String get engineResume => 'استئناف';

  @override
  String get enterFullscreen => 'ملء الشاشة';

  @override
  String errClipPastEnd(Object length) {
    return 'يبدأ الجزء بعد نهاية المقطع ($length)';
  }

  @override
  String get errClipPastEndUnknown => 'يبدأ الجزء بعد نهاية المقطع';

  @override
  String get errNetwork => 'تعذّر الاتصال بالموقع';

  @override
  String get errPlatformBlockedCookies =>
      'الموقع يطلب تسجيل الدخول. اختر ملف كوكيز من الإعدادات › الكوكيز';

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
  String get fastStreams => 'تسريع البث المقطّع';

  @override
  String fastStreamsHelp(int count) {
    return 'ينزّل $count أجزاء معاً من المواقع التي تقطّع المقطع أجزاءً، مثل X. بعض المواقع تُبطئ الطلبات الكثيرة في وقت واحد.';
  }

  @override
  String get favorites => 'المفضلة';

  @override
  String get file => 'الملف';

  @override
  String get fileSize => 'حجم الملف';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterAudio => 'صوت';

  @override
  String get filterVideo => 'فيديو';

  @override
  String get filtersOn => 'التصفية مفعّلة';

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
  String get justNow => 'الآن';

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
  String get languageSystemHint => 'يتبع لغة جوالك';

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
  String get loginDone => 'تم';

  @override
  String loginKept(String site) {
    return 'سُجّل الدخول إلى $site، وستستعمله التنزيلات';
  }

  @override
  String get loginNotYet =>
      'لم يظهر تسجيل دخول بعد. أكمل تسجيل الدخول ثم اضغط «تم»';

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
      'تنزيلاتك محفوظة في مجلد Download في جوالك، وأندرويد يطلب إذنك قبل أن يعرضها التطبيق.';

  @override
  String get mediaAccessOpenSettings => 'فتح الإعدادات';

  @override
  String get mediaAccessTitle => 'اسمح بالوصول إلى الوسائط';

  @override
  String get mobileChannelsEmptyBody =>
      'تابِع قناة، فيُنزَّل كل مقطع جديد تنشره تلقائياً ما دام VidHoist مفتوحاً أو في الخلفية، وما نُشر وهو مغلق يُنزَّل حين تفتحه. أما ما نُشر قبل المتابعة فلا يُنزَّل.';

  @override
  String get mobileChannelsHint =>
      'مقاطع القنوات التي تتابعها، تُنزَّل تلقائياً';

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
  String get mobileEngineUpdateMissed => 'تعذّر التحديث';

  @override
  String get mobileEngineUpdated => 'محدَّث';

  @override
  String get mobileEngineUpdating => 'جارٍ التحديث…';

  @override
  String get mobileEngineVersionLabel => 'نسخة yt-dlp';

  @override
  String get mobileEngineVersionUnknown => 'يظهر إصداره بعد أول تحديث';

  @override
  String get mobileSettingsEngine => 'محرّك التنزيل';

  @override
  String get mobileSettingsGroupEngine => 'المحرّك';

  @override
  String get mobileSignInNeeded =>
      'هذا الموقع يطلب تسجيل الدخول. سجّل الدخول من الإعدادات › الحسابات ثم أعد المحاولة';

  @override
  String get mobileSubtitleOptions => 'الحجم والخلفية والنص';

  @override
  String get mobileSubtitleStyleHelp => 'وفي المشغّل: اضغط زر CC مطوّلاً.';

  @override
  String get mobileSubtitles => 'تنزيل الترجمات';

  @override
  String get mobileSubtitlesHelp =>
      'الترجمة باللغات التالية إن وُجدت، تُحفظ بجانب المقطع وتظهر في المشغّل.';

  @override
  String get mobileSubtitlesSizeLarger => 'أكبر';

  @override
  String get mobileTranscript => 'النص';

  @override
  String get mobileTranscriptHint => 'اضغط سطراً ليبدأ التشغيل منه.';

  @override
  String get mobileTranscriptOpen => 'قراءة النص';

  @override
  String get mobileWelcomeBody =>
      'الفيديو والصوت من المواقع التي تستعملها، يُحفظان في هذا الجوال مباشرة. محرّك التنزيل يتجهّز الآن، ولا يحدث هذا إلا مرة واحدة.';

  @override
  String get mobileWelcomeFailed =>
      'تعذّر تشغيل المحرّك. أعد المحاولة، وإن تكرّر الفشل فأعد تثبيت التطبيق.';

  @override
  String get mobileWelcomeStart => 'ابدأ';

  @override
  String get mobileWelcomeTitle => 'أهلاً بك في VidHoist';

  @override
  String get mobileWelcomeUnpacking => 'تجهيز محرّك التنزيل';

  @override
  String get mobileWelcomeUpdateFailed =>
      'تعذّر التحديث الآن، وسيحاول VidHoist مجدداً قبل أول تنزيل.';

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
  String get navLibrary => 'المكتبة';

  @override
  String get navMyDownloads => 'تنزيلاتي';

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
  String newVideosBody(String channels) {
    return '$channels. تُنزَّل حين تفتح VidHoist.';
  }

  @override
  String newVideosNotice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مقطع جديد',
      many: '$count مقطعاً جديداً',
      few: '$count مقاطع جديدة',
      two: 'مقطعان جديدان',
      one: 'مقطع جديد',
    );
    return '$_temp0';
  }

  @override
  String get next => 'التالي';

  @override
  String get noBackupsYet => 'لا توجد نسخ بعد';

  @override
  String get noDownloads => 'لا توجد تنزيلات';

  @override
  String get noDownloadsMessage =>
      'ستظهر هنا المقاطع التي تنزّلها.\nشارك رابطاً أو اضغط زر «إضافة رابط».';

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
  String get noPlaylistsMessage => 'أنشئ قائمة لتنظيم مقاطعك';

  @override
  String get noResults => 'لا نتائج';

  @override
  String get noResultsMessage => 'لا توجد عناصر مطابقة لبحثك.';

  @override
  String get noServerTitle => 'محرك التنزيل غير جاهز';

  @override
  String get noticeChannelNewVideos => 'المقاطع الجديدة';

  @override
  String get noticeChannelUpdates => 'التحديثات';

  @override
  String get noVideosFound => 'مكتبتك فارغة';

  @override
  String get noWarranty => 'يُقدَّم كما هو، بلا أي ضمان.';

  @override
  String get notAffiliated =>
      'لا صلة للتطبيق بمشروع yt-dlp ولا بأي موقع، ولا يحظى بتأييدها.';

  @override
  String get nothingHereYet => 'لا يوجد شيء بعد';

  @override
  String get notificationClipGone => 'هذا المقطع لم يعد على الجوال.';

  @override
  String get nowPlaying => 'قيد التشغيل';

  @override
  String get nowPlayingCollapse => 'طيّ لوحة التشغيل';

  @override
  String get nowPlayingExpand => 'إظهار لوحة التشغيل';

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
  String get pasteUrlHint => 'الصق الرابط هنا…';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get pauseSubscription => 'إيقاف مؤقت';

  @override
  String get pcAddressLabel => 'العنوان';

  @override
  String get pcBadAddress =>
      'اكتب العنوان كما يعرضه الكمبيوتر، مثلاً 192.168.1.24.';

  @override
  String get pcBadQr => 'هذا ليس رمز QR للاقتران من VidHoist.';

  @override
  String get pcCertificate => 'شهادة الكمبيوتر';

  @override
  String get pcCodeLabel => 'الرمز';

  @override
  String get pcConnected => 'متصل';

  @override
  String get pcCopied => 'نُسخ إلى مكتبة الجوال مع ترجماته.';

  @override
  String get pcCopyFailed =>
      'لم يكتمل النسخ: ربما الكمبيوتر مطفأ أو بعيد عن الشبكة. لم يُحفظ شيء.';

  @override
  String get pcCopyStarting => 'يُنسخ…';

  @override
  String get pcCopyStop => 'أوقف النسخ';

  @override
  String get pcCopyToPhone => 'انسخ إلى الجوال';

  @override
  String pcCopying(int percent) {
    return 'يُنسخ $percent٪';
  }

  @override
  String get pcDelete => 'احذف من الكمبيوتر';

  @override
  String pcDeleteBody(String title) {
    return 'يذهب «$title» إلى سلة المحذوفات في الكمبيوتر، ويمكن استرجاعه منها.';
  }

  @override
  String get pcDeleteFailed =>
      'تعذّر الحذف على الكمبيوتر، وقد يكون المقطع مفتوحاً هناك.';

  @override
  String get pcDeleteMissing => 'لم يعد هذا المقطع على الكمبيوتر.';

  @override
  String get pcDeleteNoBin =>
      'لم يُحذف: القرص الذي عليه في الكمبيوتر بلا سلة محذوفات.';

  @override
  String get pcDeleteNotAllowed =>
      'الكمبيوتر لا يسمح للجوال بالحذف. فعّله هناك من الإعدادات › الجوال.';

  @override
  String pcDeleteTitle(String name) {
    return 'حذف من $name؟';
  }

  @override
  String pcDeleted(String title) {
    return 'في سلة محذوفات الكمبيوتر: $title';
  }

  @override
  String get pcDestPhone => 'هذا الجوال';

  @override
  String pcDoneOnPc(String title) {
    return 'انتهى على الكمبيوتر: $title';
  }

  @override
  String pcDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تنزيلاً للكمبيوتر',
      few: '$count تنزيلات للكمبيوتر',
      two: 'تنزيلان للكمبيوتر',
      one: 'تنزيل واحد للكمبيوتر',
    );
    return '$_temp0';
  }

  @override
  String get pcDownloadsSheet => 'تنزيلات الكمبيوتر';

  @override
  String get pcEmptyLibrary => 'لا تنزيلات على الكمبيوتر بعد.';

  @override
  String get pcErrBad =>
      'ردّ الكمبيوتر بما لا تفهمه هذه النسخة. حدّث التطبيقين.';

  @override
  String get pcErrClosed =>
      'لا رمز معروض على الكمبيوتر، أو انتهت مدته. اضغط «اربط جوالاً» هناك.';

  @override
  String get pcErrDenied =>
      'رُفض الاقتران على الكمبيوتر، أو لم يُجب عنه في الوقت.';

  @override
  String get pcErrRefused => 'رفض الكمبيوتر هذا الرابط.';

  @override
  String get pcErrUnauthorized =>
      'الكمبيوتر لم يعد يعرف هذا الجوال. اربط من جديد.';

  @override
  String get pcErrUnreachable =>
      'لم يردّ الكمبيوتر. هل هو شغّال، وعلى هذه الشبكة أو على Tailscale، و«استقبال من الجوال» مفعّل فيه؟';

  @override
  String get pcErrWrongCertificate =>
      'ردّ على هذا العنوان جهاز غير كمبيوترك. لم يُرسل شيء.';

  @override
  String get pcErrWrongCode => 'رمز خاطئ.';

  @override
  String get pcFindNone =>
      'لم يُعثر على كمبيوتر. افتح على الكمبيوتر الإعدادات › الجوال › «اربط جوالاً» أولاً، على شبكة Wi-Fi نفسها.';

  @override
  String get pcFindOnNetwork => 'ابحث في الشبكة';

  @override
  String get pcFirewallAllow => 'اسمح';

  @override
  String get pcFirewallBlocked =>
      'جدار حماية ويندوز يحجب VidHoist، فلا يصل إليه الجوال. اسمح له على شبكات البيت (الخاصة).';

  @override
  String get pcFirewallMissing =>
      'لم يسمح ويندوز بعدُ لـVidHoist بالاستقبال من الجوال. اسمح له مرة واحدة، على شبكات البيت (الخاصة) فقط.';

  @override
  String get pcFirewallPublic =>
      'يصنّف ويندوز هذه الشبكة «عامة» ولا يسمح فيها بأي اتصال وارد. إن كانت شبكة بيتك فاجعلها «خاصة»: الإعدادات › الشبكة والإنترنت › Wi-Fi › خصائصها.';

  @override
  String get pcFirewallRefused =>
      'لم يتغيّر شيء: يحتاج ويندوز إذن مسؤول الجهاز.';

  @override
  String get pcFirewallTitle => 'جدار حماية ويندوز';

  @override
  String pcFound(String name) {
    return 'وُجد $name. اكتب الرمز الظاهر عليه.';
  }

  @override
  String pcFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نتيجة',
      few: '$count نتائج',
      two: 'نتيجتان',
      one: 'نتيجة واحدة',
    );
    return '$_temp0';
  }

  @override
  String pcLastContact(String time) {
    return 'آخر تواصل $time';
  }

  @override
  String get pcLibrary => 'مكتبة الكمبيوتر';

  @override
  String get pcLinkAddress => 'العنوان على هذه الشبكة';

  @override
  String get pcLinkAddressTailscale => 'عبر Tailscale، من خارج البيت';

  @override
  String get pcLinkAllow => 'اسمح';

  @override
  String get pcLinkAllowDelete => 'اسمح للجوال بحذف المقاطع';

  @override
  String get pcLinkAllowDeleteHint =>
      'المقطع الذي يُحذف من الجوال يذهب إلى سلة المحذوفات في هذا الكمبيوتر، فيمكنك استرجاعه منها. وعلى قرص بلا سلة محذوفات لا يُحذف.';

  @override
  String get pcLinkCodeHint =>
      'على الجوال: الإعدادات › الكمبيوتر › امسح رمز QR. أو اكتب هناك العنوان والرمز. يعمل مرة واحدة ولمدة دقيقتين.';

  @override
  String pcLinkCodeLeft(int seconds) {
    return 'بقي $seconds ث';
  }

  @override
  String get pcLinkCodeTitle => 'رمز الاقتران';

  @override
  String get pcLinkDeny => 'ارفض';

  @override
  String get pcLinkDevices => 'الأجهزة المقترنة';

  @override
  String pcLinkFailed(String error) {
    return 'تعذّر التشغيل: $error';
  }

  @override
  String get pcLinkIntro =>
      'أرسل الروابط من VidHoist على جوالك إلى هذا الكمبيوتر، وشاهد تنزيلاته ومكتبته هناك. يعمل داخل شبكة البيت، ومن خارجها عبر Tailscale.';

  @override
  String pcLinkLastSeen(String time) {
    return 'آخر تواصل $time';
  }

  @override
  String get pcLinkNoDevices => 'لا جوال بعد.';

  @override
  String get pcLinkOff => 'مطفأ';

  @override
  String pcLinkOtherAddresses(int count) {
    return 'عناوين أخرى ($count)';
  }

  @override
  String get pcLinkOtherAddressesHint =>
      'بطاقات شبكة تضيفها برامج أخرى مثل VirtualBox أو WSL. لا يحتاجها الجوال غالباً.';

  @override
  String get pcLinkPairPhone => 'اربط جوالاً';

  @override
  String pcLinkPairedAt(String time) {
    return 'اقترن $time';
  }

  @override
  String pcLinkPhones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جهاز',
      few: '$count أجهزة',
      two: 'جوالان',
      one: 'جوال واحد',
      zero: 'لا جوال',
    );
    return '$_temp0';
  }

  @override
  String get pcLinkQrHint => 'امسحه من الجوال';

  @override
  String get pcLinkReceive => 'استقبال من الجوال';

  @override
  String get pcLinkReceiveHint =>
      'حين يكون مطفأً لا يُفتح أي منفذ على هذا الكمبيوتر. وإن سألك ويندوز فاسمح للشبكات الخاصة فقط.';

  @override
  String pcLinkRequest(String name) {
    return '$name يطلب الاقتران';
  }

  @override
  String get pcLinkRequestHint =>
      'اسمح فقط إن كان الجوال يعرض الأرقام الأربعة نفسها.';

  @override
  String get pcLinkRevoke => 'إلغاء الاقتران';

  @override
  String get pcLinkSecurity =>
      'الجوال يكلّم هذا الكمبيوتر مباشرة، داخل شبكتك أو عبر Tailscale الخاص بك. يقترن مرة واحدة بالرمز وبموافقتك هنا، وبعدها يقدّم مفتاحه الخاص مع كل طلب، عبر اتصال مشفّر بشهادة هذا الكمبيوتر وحدها. ومن سواه على الشبكة يجد باباً مغلقاً.';

  @override
  String get pcLinkStarting => 'يبدأ…';

  @override
  String get pcLinkTitle => 'الجوال';

  @override
  String get pcListEmpty => 'لم يعد أي مقطع من هذه القائمة على الكمبيوتر.';

  @override
  String get pcListen => 'استمع';

  @override
  String get pcLists => 'قوائم الكمبيوتر';

  @override
  String get pcListsEmpty => 'لا قائمة على الكمبيوتر فيها مقاطع.';

  @override
  String get pcNow => 'يُنزَّل على الكمبيوتر الآن';

  @override
  String get pcOffline => 'غير متاح';

  @override
  String get pcOfflineMessage =>
      'الكمبيوتر مطفأ أو على شبكة أخرى. ما كان فيه آخر مرة معروض أدناه.';

  @override
  String get pcOfflineRoute =>
      'خارج البيت؟ اختر Tailscale من الإعدادات › الكمبيوتر.';

  @override
  String get pcOnPhone => 'على الجوال';

  @override
  String get pcOrType => 'أو اكتب العنوان والرمز';

  @override
  String get pcOutboxRefused => 'لم يقبل الكمبيوتر هذا الرابط';

  @override
  String pcOutboxTitle(int count) {
    return 'بانتظار الإرسال ($count)';
  }

  @override
  String get pcPairButton => 'اربط';

  @override
  String pcPairCheck(String check) {
    return 'تأكد أن الكمبيوتر يعرض $check، ثم اسمح للجوال هناك.';
  }

  @override
  String get pcPairIntro =>
      'إن كان VidHoist يعمل على كمبيوترك بويندوز، يستطيع هذا الجوال أن يرسل إليه الروابط ويعرض تنزيلاته ومكتبته. على الكمبيوتر فعّل الإعدادات › الجوال واضغط «اربط جوالاً»، ثم امسح رمز QR الذي يظهر.';

  @override
  String pcPaired(String name) {
    return 'اقترن بـ$name';
  }

  @override
  String get pcPortLabel => 'المنفذ';

  @override
  String pcQueued(String name) {
    return 'سيُرسل إلى $name حين يعود.';
  }

  @override
  String pcQueuedMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'سيُرسل $count مقطعاً إلى $name حين يعود.',
      few: 'ستُرسل $count مقاطع إلى $name حين يعود.',
      two: 'سيُرسل مقطعان إلى $name حين يعود.',
      one: 'سيُرسل مقطع إلى $name حين يعود.',
    );
    return '$_temp0';
  }

  @override
  String get pcRouteHint =>
      'اختر Tailscale حين تكون خارج البيت، ويجب أن يعمل على الجوال والكمبيوتر معاً.';

  @override
  String get pcRouteHome => 'شبكة البيت';

  @override
  String get pcRouteOther => 'شبكة أخرى';

  @override
  String get pcRouteTailscale => 'Tailscale';

  @override
  String get pcRouteTitle => 'الاتصال عبر';

  @override
  String get pcRouteWaiting =>
      'تظهر طرق الاتصال الأخرى هنا بعد أول رد من الكمبيوتر.';

  @override
  String get pcScanButton => 'امسح رمز QR';

  @override
  String get pcScanFailed => 'تعذّر فتح الكاميرا.';

  @override
  String get pcScanPrompt => 'وجّه الكاميرا إلى رمز QR على شاشة الكمبيوتر';

  @override
  String get pcSearchHint => 'ابحث في مكتبة الكمبيوتر';

  @override
  String get pcSendToPc => 'أرسل إلى الكمبيوتر';

  @override
  String pcSent(String name) {
    return 'أُرسل إلى $name';
  }

  @override
  String pcSentMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أُرسل $count مقطعاً إلى $name',
      few: 'أُرسلت $count مقاطع إلى $name',
      two: 'أُرسل مقطعان إلى $name',
      one: 'أُرسل مقطع إلى $name',
    );
    return '$_temp0';
  }

  @override
  String get pcSettingsHint => 'أرسل الروابط إلى كمبيوترك';

  @override
  String get pcTab => 'الكمبيوتر';

  @override
  String pcVia(String route) {
    return 'عبر $route';
  }

  @override
  String get pcWatch => 'شاهد';

  @override
  String get pcWillSend => 'غائب: يُرسل حين يعود';

  @override
  String get pickAnotherFile => 'من ملف آخر…';

  @override
  String get pickAnotherFileSubtitle => 'نسخة من جوال آخر أو من إصدار سابق';

  @override
  String get pictureInPicture => 'صورة داخل صورة';

  @override
  String get pictureInPictureHelp =>
      'حين تخرج من التطبيق والمقطع يعمل، يبقى في زاوية الشاشة';

  @override
  String get pinPlaylist => 'تثبيت في الصدارة';

  @override
  String get platform => 'الموقع';

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
  String get playlistAddClips => 'أضف مقاطع';

  @override
  String playlistAddClipsTo(String name) {
    return 'إضافة إلى «$name»';
  }

  @override
  String playlistAddCount(int count) {
    return 'إضافة ($count)';
  }

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
      'تُعتمد هذه الجودة في التنزيل السريع، وفي تنزيل القائمة كاملة، وفي زر «تنزيل» من شريط الحافظة، وتكون محددة مسبقاً في نافذة إضافة الرابط؛ لذا يسري أثرها سواء أكان التنزيل السريع مفعّلاً أم لا.';

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
  String get quickDownload => 'التنزيل السريع';

  @override
  String get quickDownloadHelp =>
      'حين تشارك رابطاً أو تلصقه يبدأ تنزيله فوراً بالجودة الافتراضية دون أي نافذة. والموقع الذي لا يوفّر تلك الجودة يُنزَّل منه الأفضل، و«صوت فقط» يسري على كل المواقع.';

  @override
  String get rateLimit => 'حدّ السرعة';

  @override
  String get rateLimitNone => 'بلا حدّ';

  @override
  String rateLimitValue(int mb) {
    return '$mb ميغابايت/ث';
  }

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
  String get restorePickBody =>
      'في هذا الجوال تنزيلات VidHoist بلا إعدادات، كما يحدث بعد إعادة التثبيت. إن كانت لديك نسخة احتياطية فاخترها؛ يكتبها التطبيق في Download/VidHoist/backups.';

  @override
  String get restorePickChoose => 'اختر نسخة';

  @override
  String get restorePickTitle => 'استعادة إعداداتك؟';

  @override
  String get restoreSettings => 'استعادة جميع البيانات';

  @override
  String get restoreSuccess => 'استُعيدت البيانات بنجاح';

  @override
  String get resumeSubscription => 'استئناف';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get saveSettings => 'حفظ الإعدادات';

  @override
  String get searchLogs => 'بحث في السجلّات…';

  @override
  String get searchVideos => 'بحث في المقاطع…';

  @override
  String get seekBackward10 => 'إرجاع 10 ثوانٍ';

  @override
  String get seekForward10 => 'تقديم 10 ثوانٍ';

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
  String get settings => 'الإعدادات';

  @override
  String get settingsAccounts => 'الحسابات';

  @override
  String get settingsBackup => 'النسخ الاحتياطي';

  @override
  String get settingsDownloads => 'التنزيل';

  @override
  String get settingsGroupApp => 'التطبيق';

  @override
  String get settingsGroupData => 'البيانات';

  @override
  String get settingsPlayback => 'التشغيل';

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
  String get settingsValueQuick => 'سريع';

  @override
  String settingsValueSignedIn(String sites) {
    return 'مسجّل: $sites';
  }

  @override
  String get settingsValueWifiOnly => 'Wi‑Fi فقط';

  @override
  String get share => 'مشاركة';

  @override
  String get shareLogs => 'مشاركة السجلات';

  @override
  String get shareOpening => 'جارٍ فتح قائمة المشاركة…';

  @override
  String get shareOpeningHint => 'الملف الكبير يحتاج بضع ثوانٍ لتسليمه.';

  @override
  String get shareSelected => 'مشاركة المحدد';

  @override
  String get sharedLinksAdd => 'أضفها';

  @override
  String get sharedLinksBody => 'يُنزَّل كل رابط منها إلى هذا الجوال.';

  @override
  String sharedLinksCapped(int max) {
    return 'أُضيفت الروابط الأولى فقط ($max).';
  }

  @override
  String sharedLinksTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إضافة $count رابط؟',
      many: 'إضافة $count رابطاً؟',
      few: 'إضافة $count روابط؟',
      two: 'إضافة رابطين؟',
      one: 'إضافة رابط واحد؟',
    );
    return '$_temp0';
  }

  @override
  String get shortsFilter => 'قِصار';

  @override
  String get shuffle => 'تشغيل عشوائي';

  @override
  String get signInRequired => 'يلزم تسجيل الدخول';

  @override
  String get size => 'الحجم';

  @override
  String get smartPlaylists => 'قوائم ذكية';

  @override
  String get sortAndPlatform => 'الترتيب والموقع';

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
  String get starAskBody =>
      'مجاني ومفتوح المصدر، بلا إعلانات ولا حساب. نجمة على GitHub تساعد غيرك على أن يجده.';

  @override
  String get starAskIdeas => 'اقترح فكرة أو أبلغ عن مشكلة';

  @override
  String get starAskLater => 'ربما لاحقاً';

  @override
  String get starAskNever => 'لا تُظهره مجدداً';

  @override
  String get starAskStar => 'ضع نجمة على GitHub';

  @override
  String get starAskTitle => 'هل أعجبك VidHoist؟';

  @override
  String get startDownload => 'ابدأ التنزيل';

  @override
  String get status => 'الحالة';

  @override
  String get storageCardMissing =>
      'البطاقة غير موجودة، فالتنزيلات تذهب إلى ذاكرة الجوال';

  @override
  String get storageLocation => 'مكان الحفظ';

  @override
  String get storageLocationHelp =>
      'المقاطع المنزّلة تبقى حيث هي وتظهر في المكتبة. بطاقة الذاكرة تحتاج أندرويد 11 أو أحدث.';

  @override
  String get storageNoCard => 'لا توجد بطاقة ذاكرة في هذا الجوال';

  @override
  String get storagePhone => 'ذاكرة الجوال';

  @override
  String get streamingOnline => 'يُشغَّل عبر الشبكة';

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
      'الجودة التي تُنزَّل بها مقاطع هذه القناة الجديدة. يمكنك تغييرها لاحقاً من تعديل القناة، وما نُزّل من قبل يبقى بجودته.\n\nقد يعني «الأفضل» دقة 4K بترميز AV1، وقد يتقطّع تشغيلها على كمبيوتر قديم، فاختر حينها 1080p.';

  @override
  String get subscriptionQualityNote =>
      'تسري على المقاطع الجديدة، وما نُزّل يبقى بجودته.';

  @override
  String get subscriptions => 'القنوات';

  @override
  String get subscriptionsEmpty => 'لا قنوات متابَعة بعد';

  @override
  String get subscriptionsEmptyBody =>
      'تابِع قناة، فيُنزَّل كل مقطع جديد تنشره إلى مكتبتك تلقائياً ما دام VidHoist مفتوحاً أو في الدرج. أما ما نُشر قبل المتابعة فلا يُنزَّل.';

  @override
  String get subscriptionsSubtitle =>
      'مقاطع القنوات التي تتابعها، تُنزَّل تلقائياً';

  @override
  String get subtitleLangs => 'لغات الترجمة';

  @override
  String get subtitleLangsHelp =>
      'تُنزَّل حين يوفّرها المقطع. تبقى لغة واحدة مختارة على الأقل.';

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
  String tagLimitReached(int max) {
    return 'الحد الأقصى للوسوم $max. احذف وسماً من «إدارة الوسوم» لتضيف غيره.';
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
      'لا يُنزَّل مقطع جديد من هذه القناة إلا إذا احتوى عنوانه على ما تكتبه هنا.\n\n• كلمة عادية تكفي: الحلقة\n• أيّ كلمة من عدة كلمات: الحلقة|الجزء (العلامة | تعني «أو»)\n• لا فرق بين الأحرف الكبيرة والصغيرة: episode تطابق Episode أيضاً.\n\nوالمقطع الذي يتخطاه الفلتر يُعدّ مُشاهَداً إلى الأبد، فإن أزلت الفلتر لاحقاً نُزِّل ما يُنشر بعد ذلك فقط، لا ما تخطّاه.';

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
  String get transcriptsDeleteTitle => 'حذف كل النصوص؟';

  @override
  String get transcriptsSaidInside => 'قيل داخل المقاطع';

  @override
  String get transcriptsSearchHelp =>
      'يحفظ ما يُقال في كل مقطع يوتيوب تضيفه، لتبحث في كلامه لا في عنوانه وحده.';

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
      'سينسى VidHoist المقاطع التي سبق أن رآها من هذه القناة. فإن تابعتها لاحقاً عُدَّ كل ما عليها حينها مُشاهَداً، ولن يُنزَّل ما فاتك. أما الإيقاف المؤقت فيحفظ هذا السجل.';

  @override
  String get unlockTouch => 'فك القفل';

  @override
  String get unpinPlaylist => 'إلغاء التثبيت';

  @override
  String get updateNoticeBody => 'افتح VidHoist لتثبيته.';

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
  String updateDownloadedMb(String done, String total) {
    return '$done من $total ميغابايت';
  }

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
  String updateVersionTitle(String version) {
    return 'الإصدار $version';
  }

  @override
  String get updateWhatsNew => 'ما الجديد';

  @override
  String get updates => 'التحديثات';

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
  String get wifiOnly => 'التنزيل عبر Wi‑Fi فقط';

  @override
  String get wifiOnlyHelp =>
      'لا يُنزَّل شيء عبر بيانات الجوّال. تنتظر التنزيلات شبكة Wi‑Fi، وما كان جارياً حين تنقطع يتوقف مؤقتاً ثم يُستأنف وحده عند عودتها.';

  @override
  String get yourPlaylists => 'قوائمك';

  @override
  String get yourTags => 'وسومك';

  @override
  String get ytdlpCredit => 'أداة التنزيل التي يعتمد عليها VidHoist';
}
