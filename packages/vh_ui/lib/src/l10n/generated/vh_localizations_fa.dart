// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'vh_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class VhLocalizationsFa extends VhLocalizations {
  VhLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get about => 'درباره';

  @override
  String get aboutApp => 'درباره‌ی برنامه';

  @override
  String get aboutDescriptionPhone =>
      'برنامه‌ای سبک و سریع که با yt-dlp ویدیو و صدا را از سایت‌های بسیاری دانلود می‌کند. پخش‌کننده و پلی‌لیست‌های خودش را دارد.';

  @override
  String get accountSignIn => 'ورود';

  @override
  String get accountSignOut => 'خروج';

  @override
  String get accountSignedIn => 'وارد شده‌اید';

  @override
  String get accountSignedOut => 'وارد نشده‌اید';

  @override
  String accountSignedOutOf(String site) {
    return 'از $site خارج شدید';
  }

  @override
  String get accountsBanRisk =>
      'بهتر است از یک حساب دوم استفاده کنید: دانلود زیاد ممکن است باعث شود سایت حسابتان را مدتی محدود کند.';

  @override
  String get accountsClearAll => 'حذف همه‌ی کوکی‌ها';

  @override
  String get accountsCleared => 'کوکی‌ها حذف شدند';

  @override
  String get accountsFileHint =>
      'فایل cookies.txt (قالب Netscape) که از مرورگر صادر شده است، برای هر سایتی، حتی سایت‌هایی که در بالا نیامده‌اند. به ورودهای موجود اضافه می‌شود و روی همین گوشی می‌ماند.';

  @override
  String get accountsFilePick => 'انتخاب فایل کوکی';

  @override
  String get accountsFileTitle => 'یا یک فایل کوکی وارد کنید';

  @override
  String get accountsFromFile => 'از فایل کوکی';

  @override
  String get accountsHelp =>
      'هر ورود پس از مدتی منقضی می‌شود؛ هر وقت سایتی دوباره دانلود را رد کرد، دوباره وارد شوید. خروج از یک سایت، مرورگر داخل برنامه را از سایت‌های دیگر هم خارج می‌کند، اما دانلودهای آن‌ها مثل قبل ادامه می‌یابد. اگر سایتی اجازه نمی‌دهد اینجا وارد شوید، در پایین یک فایل کوکی از مرورگر رایانه‌تان وارد کنید.';

  @override
  String get accountsHint =>
      'برای سایت‌هایی که بدون ورود اجازه‌ی دانلود نمی‌دهند. در صفحه‌ی خود سایت و داخل برنامه وارد می‌شوید؛ آنچه سایت به جا می‌گذارد روی همین گوشی می‌ماند، yt-dlp برای هر دانلود از آن استفاده می‌کند و به هیچ جای دیگری نمی‌رود.';

  @override
  String get activeDownloads => 'دانلودهای فعال';

  @override
  String activeDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دانلود در حال انجام',
      one: '1 دانلود در حال انجام',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloadsSheet => 'دانلودهای فعال';

  @override
  String get activeNow => 'اکنون فعال';

  @override
  String get addLinkFab => 'افزودن لینک';

  @override
  String get addTo => 'افزودن به…';

  @override
  String get addToFavorites => 'افزودن به علاقه‌مندی‌ها';

  @override
  String get addToPlaylist => 'افزودن به پلی‌لیست';

  @override
  String get addUrl => 'افزودن نشانی';

  @override
  String addedNToServer(int count) {
    return '$count مورد به دانلودها اضافه شد';
  }

  @override
  String get addedToFavorites => 'به علاقه‌مندی‌ها اضافه شد';

  @override
  String addedToPlaylistCount(int count) {
    return '$count مورد به پلی‌لیست اضافه شد';
  }

  @override
  String get allDownloadsFinished => 'همه‌ی دانلودها تمام شد.';

  @override
  String get allPlatforms => 'همه‌ی سایت‌ها';

  @override
  String get alreadyInPlaylist => 'قبلاً اضافه شده';

  @override
  String get alreadySubscribed => 'این کانال از قبل دنبال می‌شود';

  @override
  String get appTitle => 'VidHoist';

  @override
  String get appearanceAndLanguage => 'ظاهر و زبان';

  @override
  String audioChannels(int count) {
    return '$count کانال صوتی';
  }

  @override
  String get audioFormat => 'قالب صدا';

  @override
  String get audioFormatM4a => 'M4A: همه‌جا پخش می‌شود';

  @override
  String get audioFormatMp3 => 'MP3: برای پخش‌کننده‌های قدیمی و خودرو';

  @override
  String get audioFormatOriginal => 'همان‌طور که سایت می‌فرستد، بدون تبدیل';

  @override
  String get audioMono => 'مونو';

  @override
  String get audioOnly => 'فقط صدا';

  @override
  String get audioStereo => 'استریو';

  @override
  String get autoBuilt => 'خودکار';

  @override
  String get autoCheckUpdates => 'بررسی خودکار';

  @override
  String get autoCheckUpdatesHelp =>
      'حدود دو بار در روز در پس‌زمینه دنبال نسخه‌ی جدید می‌گردد.';

  @override
  String get autoRestoreSuccess => 'داده‌ها از نسخه‌ی پشتیبان بازیابی شد.';

  @override
  String get autoRetry => 'تلاش دوباره با برگشتن شبکه';

  @override
  String get autoRetryHelp =>
      'هر چیزی که به خاطر قطع شبکه ناموفق شد، با برگشتن شبکه خودبه‌خود دوباره امتحان می‌شود. آنچه سایت رد کرده دوباره امتحان نمی‌شود: تکرار بی‌تغییر آن فقط دوباره ناموفق می‌شود.';

  @override
  String get backgroundChecks => 'بررسی وقتی برنامه بسته است';

  @override
  String get backgroundChecksHelp =>
      'تقریباً هر شش ساعت، وقتی شبکه هست و باتری کم نیست. فقط موارد تازه را خبر می‌دهد؛ ویدیوها وقتی VidHoist را باز کنید دانلود می‌شوند.';

  @override
  String get backgroundDownload => 'در حال دانلود فایل‌ها در پس‌زمینه…';

  @override
  String backgroundLastRun(String when) {
    return 'آخرین بررسی در حالت بسته: $when';
  }

  @override
  String get backgroundNotRunYet =>
      'هنوز بررسی‌ای در حالت بسته انجام نشده: زمانش را اندروید انتخاب می‌کند.';

  @override
  String get backgroundOfferBody =>
      'VidHoist می‌تواند تقریباً هر شش ساعت کانال‌هایتان را ببیند و موارد تازه را خبر دهد. تا برنامه را باز نکنید چیزی دانلود نمی‌شود.';

  @override
  String get backgroundOfferNo => 'اکنون نه';

  @override
  String get backgroundOfferTitle =>
      'می‌خواهید وقتی VidHoist بسته است از ویدیوهای تازه باخبر شوید؟';

  @override
  String get backgroundOfferYes => 'روشن کردن';

  @override
  String get backupNote =>
      'شامل کتابخانه، پلی‌لیست‌ها، برچسب‌ها، کانال‌های دنبال‌شده و تنظیمات است. ورودها و رونوشت‌ها جدا نگه داشته می‌شوند و خود فایل‌های رسانه شامل نمی‌شوند.';

  @override
  String get backupSettings => 'پشتیبان‌گیری از همه‌ی داده‌ها';

  @override
  String get backupSettingsSubtitle =>
      'هفت نسخه‌ی تاریخ‌دار که خودشان تازه می‌شوند. هر کدام را بازیابی کنید، یا یکی را برای اشتراک‌گذاری صادر کنید';

  @override
  String backupSuccess(Object path) {
    return 'نسخه‌ی پشتیبان ذخیره شد در: $path';
  }

  @override
  String backupsKept(int count) {
    return '$count نسخه‌ی پشتیبان نگه داشته می‌شود';
  }

  @override
  String get batchDownloadSelected => 'دانلود موارد انتخاب‌شده';

  @override
  String get batchLoading => 'در حال خواندن پلی‌لیست…';

  @override
  String get batchNothingSelected => 'دست‌کم یک مورد را انتخاب کنید';

  @override
  String batchSelectedOf(int selected, int total) {
    return '$selected از $total انتخاب شده';
  }

  @override
  String get batchThisVideoOnly => 'فقط همین کلیپ دانلود شود';

  @override
  String get batchTitle => 'دانلود گروهی';

  @override
  String get batteryAllow => 'اجازه دادن';

  @override
  String get batteryFree =>
      'صرفه‌جویی باتری کاری به دانلودها ندارد، حتی وقتی برنامه در دید نیست.';

  @override
  String get batteryRestricted =>
      'صرفه‌جویی باتری ممکن است وقتی برنامه در دید نیست، دانلود طولانی را متوقف کند.';

  @override
  String get batteryStateFree => 'مجاز';

  @override
  String get batteryStateLimited => 'محدود';

  @override
  String get batteryTitle => 'دانلود در پس‌زمینه';

  @override
  String bitrateKbps(String value) {
    return '$value kb/s';
  }

  @override
  String bitrateMbps(String value) {
    return '$value Mb/s';
  }

  @override
  String get builtWith => 'ساخته‌شده با';

  @override
  String get cancel => 'لغو';

  @override
  String get changeQuality => 'تغییر کیفیت';

  @override
  String get channelNameFolder => 'به نام کانال';

  @override
  String channelFollowers(String count) {
    return '$count مشترک';
  }

  @override
  String get channelCheckFailed =>
      'این بار بررسی نشد. VidHoist خودش دوباره تلاش می‌کند.';

  @override
  String get channelUrl => 'لینک یک کانال، یک پلی‌لیست یا یکی از ویدیوهای آن';

  @override
  String get channelUrlHint => 'https://www.youtube.com/@name';

  @override
  String chapterNumber(int number) {
    return 'فصل $number';
  }

  @override
  String get chaptersFold => 'پنهان کردن فصل‌ها';

  @override
  String chaptersFromTranscript(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل از رونوشت',
      one: '1 فصل از رونوشت',
    );
    return '$_temp0';
  }

  @override
  String get chaptersShowAll => 'دیدن همه‌ی فصل‌ها';

  @override
  String get chaptersUnfold => 'نمایش فصل‌ها';

  @override
  String get checkEvery => 'هر چند وقت یک بار بررسی شود';

  @override
  String get checkForUpdates => 'بررسی به‌روزرسانی‌ها';

  @override
  String get checkNow => 'بررسی فوری';

  @override
  String get checkQueued =>
      'در حال بررسی است. هر چیز تازه‌ای در کتابخانه نمایش داده می‌شود.';

  @override
  String get chooseFolder => 'انتخاب پوشه';

  @override
  String get chooseOptions => 'گزینه‌ها';

  @override
  String get clear => 'پاک کردن';

  @override
  String get clearLogs => 'پاک کردن گزارش‌ها';

  @override
  String get clearLogsConfirm => 'همه‌ی گزارش‌های عیب‌یابی حذف شوند؟';

  @override
  String get clipEndAfterStart => 'بعد از شروع';

  @override
  String get clipFrom => 'از';

  @override
  String clipLength(Object length) {
    return 'طول ویدیو $length است';
  }

  @override
  String get clipLengthReading => 'در حال خواندن طول ویدیو…';

  @override
  String get clipLengthUnknown =>
      'سایت طول ویدیو را اعلام نمی‌کند، پس زمان‌ها بررسی نمی‌شوند';

  @override
  String get clipMinuteDown => 'یک دقیقه زودتر';

  @override
  String get clipMinuteUp => 'یک دقیقه دیرتر';

  @override
  String get clipOnly => 'فقط بخشی از ویدیو';

  @override
  String get clipOnlyHelp =>
      'از یک زمان تا زمانی دیگر، بدون بقیه. بدون زیرنویس می‌آید.';

  @override
  String clipPastEnd(Object length) {
    return 'ویدیو در $length تمام می‌شود';
  }

  @override
  String get clipTimeHint => 'فقط رقم: 130 یعنی 1:30';

  @override
  String get clipTo => 'تا';

  @override
  String get clipboardFound => 'یک لینک در کلیپ‌بورد آماده است';

  @override
  String get clipboardLinkReady => 'چسباندن لینک';

  @override
  String get closePlayer => 'بستن پخش‌کننده';

  @override
  String get columnAdded => 'افزوده‌شده';

  @override
  String get columnChannel => 'کانال';

  @override
  String get columnLength => 'مدت';

  @override
  String get compactView => 'نمای فشرده';

  @override
  String get compatiblePlayback => 'بهترین سازگاری پخش';

  @override
  String get compatiblePlaybackHelp =>
      'H.264/AAC را درخواست می‌کند که همه‌ی گوشی‌ها به‌صورت سخت‌افزاری رمزگشایی می‌کنند. بدون آن، YouTube ممکن است AV1 بفرستد که بسیاری از دستگاه‌ها آن را با تصویری به‌هم‌ریخته نشان می‌دهند. با خاموش کردن آن، بالاترین وضوح به بهای سازگاری ممکن می‌شود.';

  @override
  String get completed => 'تکمیل‌شده';

  @override
  String get continueAsAudio => 'ادامه به‌صورت صدا';

  @override
  String get continueAsAudioBody =>
      'پخش این مورد از همان ثانیه به‌صورت صدا ادامه یابد؟';

  @override
  String get continueAsAudioNo => 'نه، توقف';

  @override
  String get continueAsAudioTitle => 'در پس‌زمینه ادامه یابد؟';

  @override
  String get cookies => 'کوکی‌ها';

  @override
  String get cookiesNotNetscape =>
      'هیچ‌یک از این فایل‌ها کوکی با قالب Netscape ندارد';

  @override
  String get cookiesSubtitle =>
      'برای سایت‌هایی که بدون ورود اجازه‌ی دانلود نمی‌دهند';

  @override
  String get copiedToClipboard => 'در کلیپ‌بورد کپی شد';

  @override
  String get copyright => '© 2026 Yasir Sagheer';

  @override
  String get couldNotLoadPlaylist =>
      'این پلی‌لیست بارگیری نشد. نشانی و اتصال خود را بررسی کنید.';

  @override
  String get create => 'ایجاد';

  @override
  String get createPlaylist => 'ایجاد پلی‌لیست';

  @override
  String get defaultQuality => 'کیفیت پیش‌فرض ویدیو';

  @override
  String get delete => 'حذف';

  @override
  String deleteMultipleConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count کلیپ حذف شوند؟\n\nفایل‌های آن‌ها از دستگاه شما پاک می‌شوند.',
      one: '1 کلیپ حذف شود؟\n\nفایل آن از دستگاه شما پاک می‌شود.',
    );
    return '$_temp0';
  }

  @override
  String deletePlaylistConfirm(Object name) {
    return '«$name» حذف شود؟';
  }

  @override
  String get deleteRefused =>
      'حذف نشد: اندروید برای حذف این فایل به اجازه‌ی شما نیاز دارد، در پنجره‌ای که نشان می‌دهد.';

  @override
  String get deleteSelected => 'حذف موارد انتخاب‌شده';

  @override
  String get deleteTag => 'حذف برچسب';

  @override
  String deleteTagConfirm(Object tag) {
    return 'برچسب «$tag» از همه‌ی موارد حذف شود؟ خود کلیپ‌ها حذف نمی‌شوند.';
  }

  @override
  String get deleteVideo => 'حذف کلیپ';

  @override
  String deleteVideoConfirm(Object title) {
    return '«$title» حذف شود؟\n\nفایل آن از دستگاه شما پاک می‌شود.';
  }

  @override
  String deletedCount(Object count) {
    return '$count مورد حذف شد';
  }

  @override
  String deletedTitle(Object title) {
    return 'حذف شد: $title';
  }

  @override
  String get deselectAll => 'لغو انتخاب همه';

  @override
  String desktopAddLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'افزودن $count لینک',
      one: 'افزودن 1 لینک',
      zero: 'چیزی برای افزودن نیست',
    );
    return '$_temp0';
  }

  @override
  String get desktopBack => 'بازگشت';

  @override
  String get desktopBackUpNow => 'پشتیبان‌گیری فوری';

  @override
  String get desktopBackupHint =>
      'این رایانه هفت نسخه‌ی پشتیبان آخر خود را، با فاصله‌ی دست‌کم یک ساعت، در Downloads\\VidHoist\\Backups نگه می‌دارد؛ آنجا حتی پس از حذف برنامه باقی می‌مانند.';

  @override
  String get desktopBackupsNone => 'هنوز نسخه‌ی پشتیبانی نیست';

  @override
  String get desktopBrowserButton => 'دکمه‌ی «به VidHoist» در مرورگر';

  @override
  String get desktopBrowserButtonCopied =>
      'کد کپی شد. یک نشانک تازه بسازید و کد را به‌عنوان نشانی (URL) آن بچسبانید.';

  @override
  String get desktopBrowserButtonCopy => 'کپی کد';

  @override
  String get desktopBrowserButtonFailed =>
      'صفحه باز نشد؛ به‌جای آن کد را کپی کنید.';

  @override
  String get desktopBrowserButtonHint =>
      'دکمه‌ای در نوار نشانک‌ها: یک کلیک در صفحه‌ی هر ویدیو، پنجره‌ی افزودن را اینجا با لینک آن باز می‌کند. تا «افزودن» را نزنید، چیزی فرستاده نمی‌شود.';

  @override
  String get desktopBrowserButtonName => 'به VidHoist';

  @override
  String get desktopBrowserButtonOpen => 'باز کردن صفحه‌ی راه‌اندازی';

  @override
  String get desktopBrowserPageCopyInstead =>
      'اگر کشیدن کار نکرد، یک نشانک تازه بسازید و این را به‌عنوان نشانی آن بچسبانید:';

  @override
  String get desktopBrowserPageDragHint =>
      'آن را به نوار بکشید؛ کلیک در اینجا کاری نمی‌کند.';

  @override
  String get desktopBrowserPageStep1 =>
      'اگر نوار نشانک‌ها پنهان است، آن را نمایش دهید:';

  @override
  String get desktopBrowserPageStep2 => 'دکمه‌ی زیر را با ماوس روی نوار بکشید.';

  @override
  String get desktopBrowserPageStep3 =>
      'در صفحه‌ی هر ویدیو، روی آن کلیک کنید: VidHoist پنجره‌ی افزودن را با لینک باز می‌کند. بار اول، مرورگر می‌پرسد که برنامه باز شود یا نه؛ اجازه دهید.';

  @override
  String get desktopBrowserPageTitle =>
      'دکمه‌ی «به VidHoist» را به مرورگرتان اضافه کنید';

  @override
  String get desktopChangeFolder => 'تغییر…';

  @override
  String get desktopChannel => 'کانال';

  @override
  String get desktopChannelClips => 'در کتابخانه‌ی شما';

  @override
  String get desktopChannels => 'کانال‌ها';

  @override
  String get desktopChannelsInLibrary => 'کانال‌های کتابخانه‌ی شما';

  @override
  String get desktopChannelsLater => 'به موتور دانلود نیاز دارد';

  @override
  String get desktopChannelsLaterBody =>
      'دنبال کردن کانال به yt-dlp روی این رایانه نیاز دارد. آن را در تنظیمات › موتور راه‌اندازی کنید تا کانال‌هایتان اینجا نمایش داده شوند.';

  @override
  String get desktopChapters => 'فصل‌ها';

  @override
  String get desktopCheckAll => 'بررسی همه';

  @override
  String get desktopChooseClip => 'انتخاب';

  @override
  String get desktopClearFilters => 'پاک کردن فیلترها';

  @override
  String get desktopClearSelection => 'لغو انتخاب';

  @override
  String get desktopCloseAnyway => 'بستن';

  @override
  String desktopCloseBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'اگر اکنون VidHoist را ببندید، متوقف می‌شوند و وقتی دوباره بازش کنید از همان‌جا ادامه می‌دهند.',
      one: 'اگر اکنون VidHoist را ببندید، متوقف می‌شود و وقتی دوباره بازش کنید از همان‌جا ادامه می‌دهد.',
    );
    return '$_temp0';
  }

  @override
  String get desktopCloseKeep => 'ادامهٔ دانلود';

  @override
  String desktopCloseMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'و $count مورد دیگر',
      one: 'و ۱ مورد دیگر',
    );
    return '$_temp0';
  }

  @override
  String desktopCloseTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دانلود تمام نشده',
      one: 'یک دانلود تمام نشده',
    );
    return '$_temp0';
  }

  @override
  String get desktopCookiesBrowser => 'از مرورگر';

  @override
  String get desktopCookiesBrowserHint =>
      'از مرورگری خوانده می‌شود که با آن وارد شده‌اید. اگر خوانده نشد، آن مرورگر را ببندید و دوباره امتحان کنید.';

  @override
  String get desktopCookiesChoose => 'انتخاب فایل…';

  @override
  String get desktopCookiesFile => 'فایل کوکی';

  @override
  String get desktopCookiesHelp =>
      'در مرورگرتان از افزونه‌ای استفاده کنید که کوکی‌ها را با قالب Netscape صادر می‌کند (یک فایل برای هر سایت)، و فایل‌ها را با هم اینجا انتخاب کنید. سپس yt-dlp برای هر دانلود از آن‌ها استفاده می‌کند. کوکی‌ها منقضی می‌شوند، پس اگر دانلودی دوباره ناموفق شد، معمولاً وقت صدور دوباره رسیده است.';

  @override
  String get desktopCookiesKept => 'کوکی‌های نگه‌داشته‌شده روی این رایانه';

  @override
  String desktopCookiesKeptFor(String sites) {
    return 'کوکی‌های نگه‌داشته‌شده برای: $sites';
  }

  @override
  String get desktopCookiesLocalHint =>
      'برای سایت‌هایی که باید در آن‌ها وارد شده باشید. yt-dlp آن‌ها را روی این رایانه می‌خواند و به هیچ جای دیگری نمی‌روند.';

  @override
  String get desktopCookiesNone => 'هیچ';

  @override
  String get desktopCookiesRemove => 'حذف';

  @override
  String get desktopCopiedLinkAdd => 'افزودن…';

  @override
  String get desktopCopiedLinkTitle => 'این لینک دانلود شود؟';

  @override
  String get desktopCopyFile => 'کپی فایل';

  @override
  String get desktopCopyFileFailed => 'فایل کپی نشد';

  @override
  String get desktopCopyLink => 'کپی لینک';

  @override
  String get desktopCopyOneClip => 'هر بار فقط یک کلیپ کپی می‌شود';

  @override
  String get desktopCopyQuote => 'کپی با زمان و لینک';

  @override
  String get desktopDefaultQualityHint =>
      'هر افزودن با این شروع می‌شود؛ باز هم می‌توانید آن را برای هر لینک تغییر دهید.';

  @override
  String desktopDeleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کلیپ حذف شوند؟ فایل‌های آن‌ها روی این رایانه پاک می‌شوند.',
      one: '1 کلیپ حذف شود؟ فایل آن روی این رایانه پاک می‌شود.',
    );
    return '$_temp0';
  }

  @override
  String get desktopDesktopSection => 'Windows';

  @override
  String get desktopDiscover => 'آشنایی با VidHoist';

  @override
  String get desktopDiscoverAddLink => 'چسباندن یا رها کردن لینک';

  @override
  String get desktopDiscoverAddLinkLine =>
      'برای افزودن یک لینک، هر جا Ctrl+V بزنید یا آن را روی پنجره رها کنید.';

  @override
  String get desktopDiscoverAdding => 'افزودن و اشتراک‌گذاری';

  @override
  String get desktopDiscoverBrowser => 'از مرورگر';

  @override
  String get desktopDiscoverBrowserLine =>
      'دکمه‌ی «به VidHoist» در نوار نشانک‌ها، پنجره‌ی افزودن را با صفحه‌ای که در آن هستید باز می‌کند.';

  @override
  String get desktopDiscoverChapters => 'فصل‌ها';

  @override
  String get desktopDiscoverChaptersLine =>
      'بخش‌های یک کلیپ، برگرفته از رونوشتش، در صفحه‌ی خود کلیپ.';

  @override
  String get desktopDiscoverChoose => 'انتخاب چندتایی';

  @override
  String get desktopDiscoverChooseLine =>
      'نشان گرد، یا Ctrl یا Shift همراه با کلیک؛ سپس آن‌ها را به یک فهرست اضافه کنید یا با هم حذف کنید.';

  @override
  String get desktopDiscoverDragOut => 'بیرون کشیدن کلیپ';

  @override
  String get desktopDiscoverDragOutLine =>
      'آن را روی یک پوشه یا برنامه‌ای دیگر رها کنید تا به‌صورت فایل به آنجا برسد.';

  @override
  String get desktopDiscoverExport => 'صدور رونوشت';

  @override
  String get desktopDiscoverExportLine =>
      'به‌صورت متن، یا به‌صورت زیرنویس SRT برای پخش‌کننده‌ای دیگر.';

  @override
  String get desktopDiscoverHint =>
      'هر کاری که برنامه می‌تواند بکند، هر کدام در یک خط، با کلیدهایش.';

  @override
  String get desktopDiscoverLibrary => 'کتابخانه';

  @override
  String get desktopDiscoverListening =>
      'برای صدا: اتاقی آرام با جلد بزرگ، در حالت تمام‌صفحه.';

  @override
  String get desktopDiscoverMini => 'پنجره‌ی کوچک';

  @override
  String get desktopDiscoverMiniLine =>
      'کارتی کوچک بالای همه‌ی پنجره‌های دیگر، در گوشه‌ی پایین صفحه.';

  @override
  String get desktopDiscoverReading =>
      'رونوشت به‌صورت مقاله: روی یک جمله کلیک کنید تا از همان‌جا بشنوید.';

  @override
  String get desktopDiscoverSaid => 'آنچه گفته شد';

  @override
  String get desktopDiscoverSearch => 'جستجو در آنچه گفته شد';

  @override
  String get desktopDiscoverSearchLine =>
      'کلیپ‌هایی را پیدا کنید که واژه‌ای در آن‌ها گفته شده است، نه فقط در عنوان‌ها.';

  @override
  String get desktopDiscoverShortcutsLine =>
      'همه‌ی کلیدهایی که پنجره به آن‌ها پاسخ می‌دهد، در یک برگه.';

  @override
  String get desktopDiscoverShow => 'نمایش';

  @override
  String get desktopDiscoverStatsLine =>
      'آمار کتابخانه: بر اساس سایت، کانال و ماه.';

  @override
  String get desktopDiscoverSubtitles =>
      'رونوشت روی تصویر، با واژه‌ی گفته‌شده که روشن می‌شود.';

  @override
  String get desktopDiscoverTheater =>
      'تصویری بزرگ‌تر که جای پنل کناری را می‌گیرد.';

  @override
  String get desktopDiscoverTry => 'امتحان کنید';

  @override
  String get desktopDiscoverWatching => 'تماشا و شنیدن';

  @override
  String get desktopDownloadFolder => 'پوشه‌ی دانلود';

  @override
  String get desktopDownloadFolderHint =>
      'دانلودها به‌صورت فایل‌های معمولی اینجا ذخیره می‌شوند تا مثل هر فایل دیگری بازشان کنید، جابه‌جایشان کنید یا از آن‌ها پشتیبان بگیرید.';

  @override
  String get desktopDownloads => 'دانلودها';

  @override
  String get desktopDownloadsEmpty =>
      'چیزی در حال دانلود نیست. برای شروع یک لینک اضافه کنید.';

  @override
  String get desktopDownloadsRunning => 'در جریان';

  @override
  String get desktopDragToReorder => 'برای تغییر ترتیب بکشید';

  @override
  String get desktopDropLinks => 'برای افزودن رها کنید';

  @override
  String get desktopEmptyLibraryMessage =>
      'یک لینک اضافه کنید؛ کلیپ پس از دانلود اینجا نمایش داده می‌شود.';

  @override
  String get desktopEngine => 'موتور';

  @override
  String get desktopEngineDenoHint =>
      'به بررسی YouTube پاسخ می‌دهد تا هر کیفیتی که ارائه می‌کند قابل دانلود باشد';

  @override
  String get desktopEngineFetch => 'دریافت';

  @override
  String get desktopEngineFetchCorrupt =>
      'فایلی که رسید همان فایل منتشرشده نبود، پس استفاده نشد.';

  @override
  String get desktopEngineFetchFailed =>
      'دریافت نشد. اتصال را بررسی کنید و دوباره امتحان کنید.';

  @override
  String get desktopEngineFetchInUse =>
      'یک دانلود در حال استفاده از آن است. پس از پایان آن دوباره امتحان کنید.';

  @override
  String desktopEngineFetching(int percent) {
    return 'در حال دریافت · $percent%';
  }

  @override
  String get desktopEngineFfmpegHint =>
      'تصویر و صدا را به هم وصل می‌کند و صدا را تبدیل می‌کند';

  @override
  String get desktopEngineIpv4 => 'فقط IPv4';

  @override
  String get desktopEngineIpv4Hint =>
      'جایی که IPv6 خراب است، مثل بسیاری از شبکه‌های خانگی، بسیار سریع‌تر است. فقط اگر شبکه‌تان تنها IPv6 دارد، آن را خاموش کنید.';

  @override
  String get desktopEngineMissing =>
      'yt-dlp روی این رایانه نیست. VidHoist را دوباره نصب کنید، یا آن را از اینجا دریافت کنید.';

  @override
  String get desktopEngineOnFirstUse =>
      'در اولین دانلودی که به آن نیاز دارد دریافت می‌شود';

  @override
  String get desktopEngineUpToDate => 'yt-dlp به‌روز است';

  @override
  String get desktopEngineUpdate => 'به‌روزرسانی yt-dlp';

  @override
  String get desktopEngineUpdateFailed =>
      'به‌روزرسانی انجام نشد. بعداً دوباره امتحان کنید.';

  @override
  String get desktopEngineUpdateHint =>
      'سایت‌ها زیاد تغییر می‌کنند؛ yt-dlp قدیمی در عرض چند ماه از کار می‌افتد.';

  @override
  String desktopEngineUpdated(String version) {
    return 'yt-dlp اکنون $version است';
  }

  @override
  String get desktopEngineUpdating => 'در حال به‌روزرسانی…';

  @override
  String desktopEngineVersion(String version) {
    return 'نسخه‌ی $version';
  }

  @override
  String get desktopEngineYtDlpHint => 'لینک را می‌خواند و دانلودش می‌کند';

  @override
  String get desktopExport => 'صدور';

  @override
  String get desktopExportForPhone => 'صدور برای گوشی';

  @override
  String get desktopExportForPhoneHint =>
      'برچسب‌ها، فهرست‌ها و نقطه‌های ادامه‌ی این رایانه، و رونوشت‌هایش را به‌صورت دو فایل ذخیره می‌کند که گوشی بازیابی‌شان می‌کند. بازیابی در گوشی، برچسب‌ها و فهرست‌های خود گوشی را جایگزین می‌کند.';

  @override
  String get desktopExportMarkdown => 'متن (Markdown)';

  @override
  String get desktopExportPdf => 'سند (PDF)';

  @override
  String get desktopExportPhone => 'برای گوشی (وارد کردن در VidHoist)';

  @override
  String get desktopExportSrt => 'زیرنویس (SRT)';

  @override
  String desktopExported(String name) {
    return '$name ذخیره شد';
  }

  @override
  String desktopFileReadyToPaste(String name, String size) {
    return 'آماده‌ی چسباندن: $name · $size';
  }

  @override
  String get desktopFirstLinkKeys => 'در هر جای پنجره همین کار را می‌کند';

  @override
  String get desktopFirstLinkNote =>
      'از یوتیوب یا هر سایت دیگری. کلیپ به محض شروع دانلود اینجا نمایش داده می‌شود.';

  @override
  String get desktopFirstLinkPaste => 'جای‌گذاری';

  @override
  String get desktopFirstLinkTitle => 'اولین لینک خود را جای‌گذاری کنید';

  @override
  String get desktopFolderUnavailable => 'هیچ پوشه‌ای در دسترس نیست';

  @override
  String get desktopFolders => 'پوشه‌ها';

  @override
  String get desktopForward => 'جلو';

  @override
  String get desktopGlobalShortcut => 'پخش و مکث از هر برنامه‌ای';

  @override
  String desktopGlobalShortcutHint(String keys) {
    return '$keys حتی وقتی پنجره پشت برنامه‌های دیگر است، پخش و مکث می‌کند.';
  }

  @override
  String desktopGlobalShortcutTaken(String keys) {
    return 'برنامه‌ی دیگری از قبل از $keys استفاده می‌کند.';
  }

  @override
  String get desktopHidePanel => 'پنهان کردن پنل کناری';

  @override
  String get desktopHintShortcuts =>
      'برای میان‌برهای صفحه‌کلید، ? را بزنید. Space پخش و مکث می‌کند؛ کلیدهای جهت‌نما جلو و عقب می‌برند.';

  @override
  String get desktopHintShortcutsAction => 'میان‌برها';

  @override
  String get desktopHintTrayBody =>
      'از نماد کنار ساعت به پخش ادامه می‌دهد. برای خروج، روی نماد کلیک راست کنید.';

  @override
  String get desktopHintTrayTitle => 'VidHoist هنوز در حال اجراست';

  @override
  String get desktopHints => 'نمایش نکته‌ها';

  @override
  String get desktopHintsAgain => 'نمایش دوباره';

  @override
  String get desktopHintsHint =>
      'دو نکته‌ی کوتاه، هر کدام یک بار: میان‌برها در اولین کلیپ، و نماد کنار ساعت در اولین بستن.';

  @override
  String get desktopImportFromPhone => 'وارد کردن نسخه‌ی پشتیبان یا رونوشت‌ها…';

  @override
  String get desktopImportHint =>
      'فایل پشتیبان یا رونوشت‌های VidHoist، که اینجا انتخاب یا روی پنجره رها می‌شود. فایل گوشی به آنچه اینجاست اضافه می‌شود؛ پشتیبانِ همین رایانه پس از پرسش، به‌طور کامل بازیابی می‌شود.';

  @override
  String desktopImportedBackup(int tagged, int lists, int positions) {
    return 'از گوشی اضافه شد. برچسب‌ها: $tagged · فهرست‌ها: $lists · نقطه‌های ادامه: $positions';
  }

  @override
  String get desktopImportedNothing =>
      'چیز تازه‌ای نبود: این رایانه همه‌ی آن را از قبل داشت.';

  @override
  String desktopImportedTranscripts(int count) {
    return 'رونوشت‌های اضافه‌شده: $count';
  }

  @override
  String desktopInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد در کتابخانه‌ی شما',
      one: '1 مورد در کتابخانه‌ی شما',
    );
    return '$_temp0';
  }

  @override
  String get desktopKeepAwake => 'بیدار نگه داشتن رایانه هنگام دانلود';

  @override
  String get desktopKeepAwakeHint =>
      'تا لینکی که از گوشی فرستاده شده یا یک پلی‌لیست طولانی، به‌جای توقف هنگام رفتن Windows به حالت خواب، تمام شود. صفحه‌نمایش مثل همیشه خاموش می‌شود.';

  @override
  String get desktopKeyAddLink => 'افزودن لینکی که کپی کرده‌اید';

  @override
  String get desktopKeyFavorite => 'افزودن به علاقه‌مندی‌ها یا برداشتن';

  @override
  String get desktopKeyFullScreen => 'تمام‌صفحه؛ برای صدا، اتاق شنیدن';

  @override
  String get desktopKeyMenu => 'منوی کلیپ';

  @override
  String get desktopKeyMini => 'پنجره‌ی کوچک بالای بقیه، و برگشت';

  @override
  String get desktopKeyPlayPause => 'پخش یا مکث';

  @override
  String get desktopKeyRepeat => 'تغییر تکرار';

  @override
  String get desktopKeySearch => 'جستجو در عنوان‌ها و آنچه گفته شد';

  @override
  String get desktopKeySeek => '10 ثانیه عقب یا جلو';

  @override
  String get desktopKeyShortcuts => 'همین فهرست';

  @override
  String get desktopKeyVolume =>
      'بلندتر یا آرام‌تر؛ در ویدیوهای کوتاه، قبلی یا بعدی';

  @override
  String get desktopKeyZoomIn => 'رابط بزرگ‌تر';

  @override
  String get desktopKeyZoomOut => 'رابط کوچک‌تر';

  @override
  String get desktopKeyZoomReset => 'رابط در اندازه‌ی معمول';

  @override
  String get desktopLanguageSystemHint => 'از زبان Windows پیروی می‌کند.';

  @override
  String desktopLastArrival(String when) {
    return 'آخرین رسیدن: $when';
  }

  @override
  String get desktopLess => 'کمتر';

  @override
  String desktopLibraryDownloading(int count) {
    return '$count در حال دانلود';
  }

  @override
  String get desktopLibraryLoading => 'در حال بارگیری کتابخانه…';

  @override
  String get desktopLinkCopied => 'لینک کپی شد';

  @override
  String get desktopLinkDuplicate => 'در بالا تکرار شده';

  @override
  String get desktopLinkInLibrary => 'از قبل در کتابخانه‌ی شماست';

  @override
  String get desktopLinkPlaylist => 'یک پلی‌لیست: کلیپ‌هایش را انتخاب کنید';

  @override
  String get desktopLinkReady => 'آماده';

  @override
  String get desktopLinkUnsupported => 'سایتی که این برنامه نمی‌شناسد';

  @override
  String desktopLinksDropped(int count, int limit) {
    return 'فقط $limit لینک اول گرفته می‌شود؛ $count لینک دیگر کنار گذاشته شد.';
  }

  @override
  String desktopLinksFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لینک',
      one: '1 لینک',
    );
    return '$_temp0';
  }

  @override
  String get desktopListeningClose => 'بستن اتاق شنیدن';

  @override
  String get desktopListeningRoom => 'اتاق شنیدن';

  @override
  String get desktopLogsCopied => 'گزارش کپی شد، بدون لینک‌ها و نشانی‌ها';

  @override
  String get desktopLogsCopy => 'کپی';

  @override
  String get desktopLogsSave => 'ذخیره در فایل';

  @override
  String get desktopMiniRestore => 'بازگشت به پنجره‌ی کامل';

  @override
  String get desktopMiniWindow => 'پنجره‌ی کوچک';

  @override
  String get desktopMore => 'بیشتر';

  @override
  String get desktopNarrowSidebar => 'جمع کردن نوار کناری';

  @override
  String get desktopNoChannelNames =>
      'کلیپ‌های کتابخانه‌ی شما نام کانالشان را ندارند، پس کلیپ‌های این کانال قابل جدا کردن نیستند. آن را با پوشه‌ی خودش دنبال کنید تا هر چه آنجا برسد، اینجا نمایش داده شود.';

  @override
  String get desktopNoFavoritesMessage =>
      'کلیپی را علاقه‌مندی علامت بزنید تا اینجا منتظرتان بماند.';

  @override
  String get desktopNoFavoritesTitle => 'هنوز علاقه‌مندی‌ای نیست';

  @override
  String get desktopNoMatchMessage =>
      'برای دیدن موارد بیشتر، یک فیلتر را پاک کنید.';

  @override
  String get desktopNoMatchTitle => 'هیچ چیز با این فیلترها جور نیست';

  @override
  String get desktopNoTags =>
      'هنوز برچسبی نیست. از صفحه‌ی یک کلیپ به آن برچسب بزنید تا اینجا نمایش داده شود.';

  @override
  String get desktopNoTranscriptMessage =>
      'وقتی زیرنویس‌های کلیپ همراه آن دانلود شود، اینجا نمایش داده می‌شود.';

  @override
  String get desktopNoTranscriptTitle => 'این کلیپ رونوشت ندارد';

  @override
  String get desktopNotABackup =>
      'این فایل، پشتیبان یا فایل رونوشت VidHoist نیست.';

  @override
  String desktopNotWatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد تماشانشده',
      one: '1 مورد تماشانشده',
    );
    return '$_temp0';
  }

  @override
  String get desktopNothingPlaying => 'چیزی پخش نمی‌شود';

  @override
  String get desktopNothingPlayingHint =>
      'کلیپی را پخش کنید تا رونوشت آن، مورد بعدی و جزئیاتش اینجا نمایش داده شود.';

  @override
  String get desktopNotifyArrivalsHint =>
      'اعلان Windows وقتی کلیپ‌های تازه از کانال‌هایی که دنبال می‌کنید دانلود می‌شوند.';

  @override
  String get desktopOfferCopiedLinks => 'پیشنهاد لینک‌هایی که کپی می‌کنم';

  @override
  String get desktopOfferCopiedLinksHint =>
      'وقتی در برنامه‌ی دیگری لینک ویدیویی را کپی می‌کنید، اعلانی افزودن آن را پیشنهاد می‌دهد. فقط به لینک‌ها نگاه می‌شود و هیچ‌کدام ذخیره نمی‌شود.';

  @override
  String get desktopOpenBackup => 'باز کردن پشتیبان';

  @override
  String get desktopOpenChannels => 'باز کردن کانال‌ها';

  @override
  String get desktopOpenInExplorer => 'باز کردن در Explorer';

  @override
  String get desktopOpenWith => 'باز کردن در پخش‌کننده‌ای دیگر…';

  @override
  String get desktopPaletteClose => 'برای بستن';

  @override
  String get desktopPaletteCommands => 'فرمان‌ها';

  @override
  String get desktopPaletteHint =>
      'در عنوان‌ها و آنچه گفته شد جستجو کنید، یا برای فرمان‌ها > را تایپ کنید';

  @override
  String desktopPaletteList(String name) {
    return 'فهرست: $name';
  }

  @override
  String get desktopPaletteMove => 'برای جابه‌جایی';

  @override
  String get desktopPaletteOpen => 'برای باز کردن';

  @override
  String get desktopPaletteRecent => 'اخیراً پخش‌شده';

  @override
  String get desktopPaletteSaid => 'گفته‌شده درون کلیپ‌ها';

  @override
  String get desktopPaletteSave => 'ذخیره‌ی این جستجو';

  @override
  String get desktopPaletteSaved => 'جستجوهای ذخیره‌شده';

  @override
  String desktopPaletteSettings(String section) {
    return 'تنظیمات: $section';
  }

  @override
  String get desktopPaletteTitles => 'عنوان‌ها';

  @override
  String get desktopPinned => 'سنجاق‌شده';

  @override
  String get desktopPlayNext => 'پخش بعدی';

  @override
  String get desktopPlaysNext => 'بعد از این یکی پخش می‌شود';

  @override
  String get desktopQueueEnd => 'بعد از این یکی چیزی نیست';

  @override
  String desktopQuote(String text, String title, String time, String link) {
    return '«$text»\n— $title، $time\n$link';
  }

  @override
  String get desktopQuoteCopied => 'با زمان و لینکش کپی شد';

  @override
  String get desktopReadingBack => 'بازگشت به کلیپ';

  @override
  String get desktopReadingCloseFind => 'بستن جستجو';

  @override
  String get desktopReadingFind => 'یافتن در متن';

  @override
  String desktopReadingFound(int at, int count) {
    return '$at از $count';
  }

  @override
  String get desktopReadingHint =>
      'روی یک جمله کلیک کنید تا از همان‌جا بشنوید · Ctrl+F واژه را پیدا می‌کند · برای کپی با زمان، انتخاب کنید';

  @override
  String get desktopReadingNextMatch => 'مورد بعدی';

  @override
  String get desktopReadingPreviousMatch => 'مورد قبلی';

  @override
  String get desktopReadingRoom => 'اتاق مطالعه';

  @override
  String get desktopRecoverLibrary => 'کلیپ‌هایی که از قبل در پوشه هستند';

  @override
  String get desktopRecoverLibraryAction => 'جستجو در پوشه';

  @override
  String get desktopRecoverLibraryHint =>
      'پس از نصب دوباره: کلیپ‌هایی را که در پوشه‌ی دانلود هستند ولی دیگر در فهرست نیستند، به کتابخانه برمی‌گرداند. به فایل‌ها دست زده نمی‌شود.';

  @override
  String desktopRecovered(int count) {
    return 'به کتابخانه برگشت: $count';
  }

  @override
  String get desktopRecoveredNothing =>
      'چیزی برای افزودن نیست: همه‌ی کلیپ‌های پوشه در کتابخانه هستند.';

  @override
  String desktopRecoveredSome(int count, int left) {
    return 'به کتابخانه برگشت: $count. کنار گذاشته شد، چون لینکشان معلوم نیست: $left';
  }

  @override
  String get desktopRemoveFromList => 'برداشتن از فهرست';

  @override
  String get desktopRestore => 'بازیابی';

  @override
  String get desktopRestoreBody =>
      'کتابخانه، کانال‌های دنبال‌شده، برچسب‌ها، فهرست‌ها و تنظیمات این رایانه همانی می‌شود که در پشتیبان است. به فایل‌های دانلودشده دست زده نمی‌شود.';

  @override
  String desktopRestoreOfferBody(String when) {
    return 'در Downloads\\VidHoist\\Backups یک پشتیبان از این رایانه هست: کتابخانه، کانال‌های دنبال‌شده، پلی‌لیست‌ها، برچسب‌ها، تنظیمات و رونوشت‌های ذخیره‌شده‌اش. تازه‌ترین آن $when ساخته شده است. در هر حال به فایل‌های دانلودشده‌ی شما دست زده نمی‌شود.';
  }

  @override
  String get desktopRestoreOfferTitle => 'پشتیبان خود را بازیابی می‌کنید؟';

  @override
  String get desktopRestoreTitle => 'این پشتیبان بازیابی شود؟';

  @override
  String get desktopRestored => 'پشتیبان بازیابی شد';

  @override
  String get desktopRevealAfterDownload => 'نمایش در Explorer پس از پایان';

  @override
  String get desktopRevealAfterDownloadHint =>
      'وقتی دانلود فایلی روی این رایانه تمام شد، پوشه‌اش با همان فایل انتخاب‌شده باز می‌شود.';

  @override
  String desktopSavedIn(String folder) {
    return 'ذخیره شد در $folder';
  }

  @override
  String desktopSavedSearchDelete(String name) {
    return 'جستجوی ذخیره‌شده‌ی «$name» حذف شود؟ چیزی در کتابخانه تغییر نمی‌کند.';
  }

  @override
  String get desktopSavedSearchName => 'نام جستجو';

  @override
  String get desktopSearch => 'جستجو';

  @override
  String get desktopSearchHint => 'جستجو در عنوان‌ها و آنچه گفته شد…';

  @override
  String get desktopSearchSaved => 'در نوار کناری ذخیره شد';

  @override
  String get desktopSeekBar => 'موقعیت در کلیپ';

  @override
  String desktopSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد انتخاب شد',
      one: '1 مورد انتخاب شد',
    );
    return '$_temp0';
  }

  @override
  String get desktopSetupChooseFile => 'انتخاب فایل…';

  @override
  String get desktopShortcutsApp => 'برنامه';

  @override
  String get desktopShortcutsClip => 'روی کلیپ انتخاب‌شده';

  @override
  String get desktopShortcutsPlayback => 'هنگام پخش';

  @override
  String get desktopShortcutsTitle => 'میان‌برهای صفحه‌کلید';

  @override
  String get desktopShortcutsWindow => 'پنجره';

  @override
  String get desktopShortsHint =>
      '↑ ↓ یا چرخ ماوس برای ویدیوی کوتاه بعدی · دوبار کلیک برای علاقه‌مندی';

  @override
  String get desktopShowInFolder => 'نمایش در پوشه';

  @override
  String get desktopShowPanel => 'نمایش پنل کناری';

  @override
  String get desktopStartFresh => 'شروع از نو';

  @override
  String get desktopStartWithWindows => 'اجرا همراه با Windows';

  @override
  String get desktopStartWithWindowsHint =>
      'هنگام ورود به سیستم باز می‌شود: اگر پخش را در سینی ادامه می‌دهد در سینی، وگرنه کوچک‌شده.';

  @override
  String get desktopStartWithWindowsRefused =>
      'Windows اجازه نداد برنامه همراه با آن اجرا شود.';

  @override
  String get desktopStats => 'آمار کتابخانه';

  @override
  String get desktopStatsByChannel => 'بر اساس کانال';

  @override
  String get desktopStatsByMonth => 'بر اساس ماه افزودن';

  @override
  String get desktopStatsBySite => 'بر اساس سایت';

  @override
  String get desktopStatsClips => 'کلیپ‌ها';

  @override
  String get desktopStatsHint =>
      'آنچه کتابخانه در خود دارد، و آنچه شاید ارزش نگاهی داشته باشد. از اینجا چیزی حذف نمی‌شود.';

  @override
  String desktopStatsHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ساعت',
      one: '1 ساعت',
      zero: 'کمتر از یک ساعت',
    );
    return '$_temp0';
  }

  @override
  String get desktopStatsLargest => 'بزرگ‌ترین‌ها:';

  @override
  String get desktopStatsLength => 'مدت کل';

  @override
  String get desktopStatsLink => 'آمار';

  @override
  String get desktopStatsNeverPlayed => 'هرگز اینجا پخش نشده';

  @override
  String get desktopStatsNewest => 'تازه‌ترین‌ها:';

  @override
  String get desktopStatsOtherChannels => 'کانال‌های دیگر';

  @override
  String get desktopStatsRoom => 'فضای اشغال‌شده';

  @override
  String get desktopStatsUnnamed => 'بدون نام کانال';

  @override
  String get desktopStatsWithText => 'با رونوشت';

  @override
  String get desktopStatsWithoutText => 'بدون رونوشت';

  @override
  String get desktopStatsWorthALook => 'ارزش نگاه کردن';

  @override
  String get desktopSubtitleOptions => 'گزینه‌های زیرنویس';

  @override
  String get desktopTheater => 'حالت سینما';

  @override
  String get desktopTranscriptFirst => 'اول رونوشتش را دریافت کنید';

  @override
  String get desktopTranscriptHint =>
      'همراه با پخش پیش می‌رود · برای پرش روی یک خط کلیک کنید';

  @override
  String get desktopTranscriptHintPage =>
      'رونوشت این کلیپ · برای پخش از هر خط روی آن کلیک کنید';

  @override
  String get desktopTranscriptsDeleteBody =>
      'از این رایانه و از پشتیبان آن پاک می‌شوند. فقط فایلی که صادر کرده‌اید می‌تواند آن‌ها را برگرداند.';

  @override
  String get desktopTranscriptsHelp =>
      'VidHoist واژه‌های گفته‌شده در هر کلیپ YouTube را که اضافه می‌کنید نگه می‌دارد، تا جستجو (Ctrl+K) آنچه را درون کلیپ‌هایتان گفته شده هم پیدا کند، نه فقط عنوان‌ها را. روی همین رایانه می‌مانند.';

  @override
  String get desktopTranscriptsMove => 'به گوشی یا از گوشی';

  @override
  String get desktopTranscriptsMoveHint =>
      'رونوشت‌ها همراه پشتیبان جابه‌جا می‌شوند: «صدور برای گوشی» آن‌ها را می‌برد و «وارد کردن» در آنجا آن‌ها را می‌آورد و آنچه را اینجا کم است اضافه می‌کند.';

  @override
  String get desktopTrayOnClose => 'ادامه‌ی پخش در سینی هنگام بستن پنجره';

  @override
  String get desktopTrayOnCloseHint =>
      'با بستن پنجره، صدا به پخش ادامه می‌دهد؛ از نماد کنار ساعت خارج شوید.';

  @override
  String get desktopTrayOpen => 'باز کردن VidHoist';

  @override
  String get desktopTrayQuit => 'خروج';

  @override
  String get desktopUiSize => 'اندازه‌ی رابط';

  @override
  String desktopUiSizeHint(String bigger, String smaller, String reset) {
    return '$bigger و $smaller از هر جایی آن را تغییر می‌دهند، و $reset آن را به 100% برمی‌گرداند.';
  }

  @override
  String get desktopUiSizeTooLarge => 'برای این صفحه‌نمایش بیش از حد بزرگ است';

  @override
  String get desktopUpdateInstall => 'نصب و راه‌اندازی دوباره';

  @override
  String get desktopUpdateRestartHint =>
      'VidHoist بسته می‌شود، به‌روزرسانی را نصب می‌کند و دوباره باز می‌شود. تنظیمات و کتابخانه‌ی شما همان‌طور که هست می‌ماند.';

  @override
  String get desktopViewCompact => 'فشرده';

  @override
  String get desktopViewTable => 'جدول';

  @override
  String get desktopVolume => 'صدا';

  @override
  String desktopVolumeLevel(int percent) {
    return 'صدا $percent%';
  }

  @override
  String get desktopWelcomeFetchNow => 'همین حالا دریافت شوند';

  @override
  String get desktopWelcomeHelpers =>
      'ffmpeg (تصویر و صدا را به هم وصل می‌کند) و Deno (که YouTube به آن نیاز دارد) در اولین دانلود خودشان دریافت می‌شوند، حدود 160 MB. می‌توانید به‌جای آن همین حالا دریافتشان کنید.';

  @override
  String get desktopWelcomeMessage =>
      'لینکی از YouTube یا سایتی دیگر بچسبانید تا VidHoist آن را با yt-dlp روی این رایانه دانلود کند.';

  @override
  String get desktopWelcomeStart => 'شروع';

  @override
  String get desktopWelcomeTitle => 'به VidHoist خوش آمدید';

  @override
  String get desktopWhatsNewAllFeatures =>
      'همه‌ی کارهایی که VidHoist می‌تواند بکند';

  @override
  String get desktopWidenSidebar => 'باز کردن نوار کناری';

  @override
  String get desktopWindowClose => 'بستن';

  @override
  String get desktopWindowMaximize => 'بزرگ کردن';

  @override
  String get desktopWindowMinimize => 'کوچک کردن';

  @override
  String get desktopWindowRestore => 'بازگرداندن اندازه';

  @override
  String get desktopZoomChange => 'تغییر';

  @override
  String desktopZoomLowered(String percent) {
    return 'رابط اکنون $percent است تا در این صفحه‌نمایش جا شود.';
  }

  @override
  String get details => 'جزئیات';

  @override
  String get developer => 'توسعه‌دهنده';

  @override
  String get developerName => 'Yasir Sagheer';

  @override
  String get diagnosticLogs => 'گزارش‌های عیب‌یابی';

  @override
  String get diagnosticLogsSubtitle =>
      'دیدن، جستجو و اشتراک‌گذاری گزارش‌های برنامه (پاک‌سازی‌شده)';

  @override
  String get disclaimer => 'سلب مسئولیت';

  @override
  String get disclaimerText =>
      'این برنامه رسانه را با yt-dlp دانلود می‌کند. توسعه‌دهنده مسئول نحوه‌ی استفاده‌ی کاربران از این ابزار نیست. لطفاً قوانین حق نشر و شرایط خدمات سایت‌هایی را که از آن‌ها دانلود می‌کنید رعایت کنید.';

  @override
  String get dismiss => 'بستن';

  @override
  String get done => 'انجام شد';

  @override
  String get download => 'دانلود';

  @override
  String get downloadComplete => 'دانلود کامل شد';

  @override
  String get downloadCompleteTitle => 'کامل شد';

  @override
  String get downloadDate => 'تاریخ دانلود';

  @override
  String get downloadFailed => 'دانلود ناموفق بود';

  @override
  String get downloadFailedTitle => 'دانلود ناموفق بود';

  @override
  String get downloadNow => 'دانلود';

  @override
  String get downloadStarted => 'دانلود شروع شد…';

  @override
  String downloadStartedQuality(Object quality) {
    return 'دانلود شروع شد · $quality';
  }

  @override
  String get downloading => 'در حال دانلود…';

  @override
  String get downloadingTitle => 'در حال دانلود';

  @override
  String get downloadsAdvanced => 'پیشرفته';

  @override
  String get editSubscription => 'ویرایش';

  @override
  String get embedSubtitles => 'زیرنویس درون ویدیو هم باشد';

  @override
  String get embedSubtitlesHelp =>
      'تا پخش‌کننده‌های دیگر هم آن را نشان دهند. پخش‌کننده‌ی خود VidHoist در هر حال آن را نشان می‌دهد.';

  @override
  String get emptyFilteredMessage =>
      'برای دیدن کل کتابخانه‌تان، یکی از فیلترهای بالا را پاک کنید.';

  @override
  String get emptyFilteredTitle => 'هیچ چیز با این فیلترها جور نیست';

  @override
  String get emptyPlaylist => 'پلی‌لیست خالی';

  @override
  String get emptyPlaylistMessage => 'از کتابخانه کلیپ اضافه کنید';

  @override
  String engineDownloadingProgress(Object percent) {
    return 'در حال دانلود · $percent%';
  }

  @override
  String get engineErrDiskFull => 'فضای ذخیره‌سازی برای این فایل کافی نیست';

  @override
  String engineErrFailed(Object reason) {
    return 'دانلود ناموفق بود: $reason';
  }

  @override
  String get engineErrFormat => 'این کیفیت برای این ویدیو در دسترس نیست';

  @override
  String get engineErrGeoBlocked => 'در کشور شما در دسترس نیست';

  @override
  String get engineErrMissing =>
      'موتور دانلود وجود ندارد یا ناقص است. آن را در تنظیمات با «تعمیر موتور» درست کنید';

  @override
  String get engineErrRateLimited =>
      'سایت درخواست‌ها را محدود می‌کند. کمی بعد دوباره امتحان کنید';

  @override
  String get engineErrUnavailable =>
      'این ویدیو در دسترس نیست، خصوصی است یا حذف شده است';

  @override
  String get engineErrUnsupported => 'این لینک پشتیبانی نمی‌شود';

  @override
  String get enginePaused => 'مکث‌شده';

  @override
  String get enginePostprocessing => 'در حال تکمیل فایل…';

  @override
  String get enginePreparing => 'در حال خواندن لینک…';

  @override
  String get engineRepair => 'تعمیر موتور';

  @override
  String get engineRepairBusy =>
      'صبر کنید تا دانلودها تمام شوند، سپس تعمیر کنید';

  @override
  String get engineRepairHint =>
      'وقتی دانلودها برخلاف قبل در سایت‌های مختلف ناموفق می‌شوند و به‌روزرسانی هم کمکی نکرد: آنچه yt-dlp ذخیره کرده پاک می‌شود و نسخه‌ای تمیز و به‌روز جایگزین می‌شود. دانلودها و تنظیمات شما همان‌طور که هست می‌ماند.';

  @override
  String get engineRepairPartly =>
      'بخشی تعمیر شد: بقیه به اتصال نیاز دارد. وقتی آنلاین شدید دوباره امتحان کنید.';

  @override
  String engineRepaired(String version) {
    return 'تعمیر شد: yt-dlp $version';
  }

  @override
  String get engineRepairing => 'در حال تعمیر…';

  @override
  String get engineResume => 'ادامه';

  @override
  String get enterFullscreen => 'تمام‌صفحه';

  @override
  String errClipPastEnd(Object length) {
    return 'این بخش بعد از پایان ویدیو ($length) شروع می‌شود';
  }

  @override
  String get errClipPastEndUnknown => 'این بخش بعد از پایان ویدیو شروع می‌شود';

  @override
  String get errNetwork => 'اتصالی به سایت نیست';

  @override
  String get errPlatformBlockedCookies =>
      'این سایت ورود می‌خواهد. در تنظیمات › کوکی‌ها یک فایل کوکی انتخاب کنید';

  @override
  String errorGeneric(Object message) {
    return 'خطا: $message';
  }

  @override
  String get every30Minutes => 'هر 30 دقیقه';

  @override
  String everyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هر $count ساعت',
      one: 'هر ساعت',
    );
    return '$_temp0';
  }

  @override
  String get exitFullscreen => 'خروج از تمام‌صفحه';

  @override
  String get exportShare => 'صدور و اشتراک‌گذاری';

  @override
  String get exportShareSubtitle =>
      'نسخه‌ای تاریخ‌دار برای فرستادن یا نگه‌داشتن در جای دیگر';

  @override
  String get externalPlayerShort => 'پخش‌کننده‌ی دیگر';

  @override
  String get failed => 'ناموفق';

  @override
  String get failedToLoadPlaylist => 'پلی‌لیست بارگیری نشد';

  @override
  String get fastStreams => 'جریان‌های تکه‌تکه‌ی سریع‌تر';

  @override
  String fastStreamsHelp(int count) {
    return 'از سایت‌هایی که ویدیو را تکه‌تکه می‌کنند، مثل X، هم‌زمان $count تکه دریافت می‌کند. بعضی سایت‌ها درخواست‌های هم‌زمان زیاد را کند می‌کنند.';
  }

  @override
  String get favorites => 'علاقه‌مندی‌ها';

  @override
  String get file => 'فایل';

  @override
  String get fileSize => 'اندازه‌ی فایل';

  @override
  String get filterAll => 'همه';

  @override
  String get filterAudio => 'صدا';

  @override
  String get filterVideo => 'ویدیو';

  @override
  String get filtersOn => 'فیلترها فعال است';

  @override
  String get folder => 'پوشه';

  @override
  String get foldersHelp =>
      'پوشه‌ای درون پوشه‌ی دانلود ساخته می‌شود و کلیپ مستقیم در آن ذخیره می‌شود، جایی که Explorer و هر برنامه‌ی دیگری آن را می‌بیند. اگر روی «بدون پوشه» بماند، کلیپ در بالای پوشه‌ی دانلود قرار می‌گیرد.';

  @override
  String get follow => 'دنبال کردن';

  @override
  String get followChannel => 'دنبال کردن یک کانال';

  @override
  String get format => 'قالب';

  @override
  String framesPerSecond(int count) {
    return '$count fps';
  }

  @override
  String get helpAboutField => 'درباره‌ی این بخش';

  @override
  String get inPlaylists => 'در پلی‌لیست‌ها';

  @override
  String get invalidUrl => 'یک لینک معتبر وارد کنید';

  @override
  String get itemOptions => 'گزینه‌های مورد';

  @override
  String get itemUnavailable => 'دیگر در دسترس نیست';

  @override
  String get jumpToNewest => 'رفتن به تازه‌ترین';

  @override
  String get justNow => 'همین حالا';

  @override
  String knownVideos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ویدیوی شناخته‌شده',
      one: '1 ویدیوی شناخته‌شده',
      zero: 'هنوز چیزی شناخته نشده',
    );
    return '$_temp0';
  }

  @override
  String get language => 'زبان';

  @override
  String get languageSystem => 'سیستم';

  @override
  String get languageSystemHint => 'از زبان گوشی شما پیروی می‌کند';

  @override
  String lastBackup(String when) {
    return 'آخرین پشتیبان: $when';
  }

  @override
  String lastCheckedAt(String when) {
    return 'آخرین بررسی: $when';
  }

  @override
  String get latestAdditions => 'تازه‌ترین افزوده‌ها';

  @override
  String get licensedUnder => 'منتشرشده با مجوز GPL-3.0';

  @override
  String get licenses => 'مجوزهای متن‌باز';

  @override
  String get listSeparator => '، ';

  @override
  String get listenInBackground => 'شنیدن در پس‌زمینه';

  @override
  String get lockTouch => 'قفل لمس';

  @override
  String get loginDone => 'تمام';

  @override
  String loginKept(String site) {
    return 'به $site وارد شدید؛ دانلودها از آن استفاده می‌کنند';
  }

  @override
  String get loginNotYet =>
      'هنوز ورودی پیدا نشد. ورود را کامل کنید، سپس روی «تمام» بزنید';

  @override
  String get logsEmpty => 'گزارش خالی است';

  @override
  String get logsSanitizedNote =>
      'لینک‌ها، نشانی‌ها و اطلاعات ورود پیش از اشتراک‌گذاری حذف می‌شوند';

  @override
  String get manageTags => 'مدیریت برچسب‌ها';

  @override
  String get mediaAccessBlockedMessage =>
      'Android دیگر نمی‌پرسد. در تنظیمات سیستم، دسترسی به عکس‌ها و ویدیوها را برای این برنامه روشن کنید، سپس برگردید.';

  @override
  String get mediaAccessGrant => 'اجازه دادن';

  @override
  String get mediaAccessMessage =>
      'دانلودهای شما در پوشه‌ی Download گوشی نگه داشته می‌شوند و Android پیش از آنکه برنامه بتواند آن‌ها را فهرست کند، به اجازه‌ی شما نیاز دارد.';

  @override
  String get mediaAccessOpenSettings => 'باز کردن تنظیمات';

  @override
  String get mediaAccessTitle => 'اجازه‌ی دسترسی به رسانه‌هایتان';

  @override
  String get mobileChannelsEmptyBody =>
      'کانالی را دنبال کنید تا هر ویدیوی تازه، وقتی VidHoist باز است یا در پس‌زمینه، خودش دانلود شود؛ آنچه وقتی برنامه بسته بود آمده، با باز شدن آن دانلود می‌شود. آنچه از قبل در کانال هست دانلود نمی‌شود.';

  @override
  String get mobileChannelsHint =>
      'ویدیوهای تازه از کانال‌هایی که دنبال می‌کنید، خودشان دانلود می‌شوند';

  @override
  String get mobileEngineIpv4 => 'اتصال از طریق IPv4';

  @override
  String get mobileEngineIpv4Help =>
      'در شبکه‌هایی که مسیر IPv6 آن‌ها خراب است، از گیر کردن طولانی جلوگیری می‌کند. فقط اگر شبکه‌تان تنها IPv6 دارد، آن را خاموش کنید.';

  @override
  String mobileEngineLastUpdate(String when) {
    return 'آخرین به‌روزرسانی: $when';
  }

  @override
  String get mobileEngineNotReady => 'در حال آماده شدن…';

  @override
  String get mobileEngineUpToDate => 'yt-dlp به‌روز است';

  @override
  String get mobileEngineUpdate => 'به‌روزرسانی yt-dlp';

  @override
  String get mobileEngineUpdateFailed =>
      'yt-dlp به‌روز نشد. اتصال را بررسی کنید و دوباره امتحان کنید.';

  @override
  String get mobileEngineUpdateMissed => 'به‌روزرسانی ناموفق بود';

  @override
  String get mobileEngineUpdated => 'به‌روز شد';

  @override
  String get mobileEngineUpdating => 'در حال به‌روزرسانی…';

  @override
  String get mobileEngineVersionLabel => 'نسخه‌ی yt-dlp';

  @override
  String get mobileEngineVersionUnknown =>
      'نسخه‌ی آن پس از اولین به‌روزرسانی نمایش داده می‌شود';

  @override
  String get mobileSettingsEngine => 'موتور دانلود';

  @override
  String get mobileSettingsGroupEngine => 'موتور';

  @override
  String get mobileSignInNeeded =>
      'این سایت می‌خواهد وارد شده باشید. از تنظیمات › حساب‌ها وارد شوید، سپس دوباره امتحان کنید';

  @override
  String get mobileSubtitleOptions => 'اندازه، پس‌زمینه و رونوشت';

  @override
  String get mobileSubtitleStyleHelp =>
      'در پخش‌کننده هم: دکمه‌ی CC را نگه دارید.';

  @override
  String get mobileSubtitles => 'دانلود زیرنویس';

  @override
  String get mobileSubtitlesHelp =>
      'زیرنویس به زبان‌های زیر، اگر ویدیو داشته باشد، کنار آن ذخیره و در پخش‌کننده نمایش داده می‌شود.';

  @override
  String get mobileSubtitlesSizeLarger => 'بزرگ‌تر';

  @override
  String get mobileTranscript => 'رونوشت';

  @override
  String get mobileTranscriptHint => 'برای پخش از یک خط، روی آن بزنید.';

  @override
  String get mobileTranscriptOpen => 'خواندن رونوشت';

  @override
  String get mobileWelcomeBody =>
      'ویدیو و صدا از سایت‌هایی که استفاده می‌کنید، مستقیم روی همین گوشی ذخیره می‌شود. موتور دانلود در حال آماده شدن است؛ این فقط یک بار انجام می‌شود.';

  @override
  String get mobileWelcomeFailed =>
      'موتور راه‌اندازی نشد. دوباره امتحان کنید؛ اگر باز هم ناموفق بود، برنامه را دوباره نصب کنید.';

  @override
  String get mobileWelcomeStart => 'شروع';

  @override
  String get mobileWelcomeTitle => 'به VidHoist خوش آمدید';

  @override
  String get mobileWelcomeUnpacking => 'در حال آماده‌سازی موتور دانلود';

  @override
  String get mobileWelcomeUpdateFailed =>
      'الان به‌روز نشد. VidHoist پیش از اولین دانلود شما دوباره تلاش می‌کند.';

  @override
  String get mobileWelcomeUpdating =>
      'در حال به‌روزرسانی yt-dlp به تازه‌ترین نسخه';

  @override
  String get modeAutoNext => 'خودکار';

  @override
  String get modeRepeatAll => 'تکرار همه';

  @override
  String get modeRepeatOne => 'تکرار یکی';

  @override
  String get modeStopAtEnd => 'توقف در پایان';

  @override
  String get navLibrary => 'کتابخانه';

  @override
  String get navMyDownloads => 'دانلودهای من';

  @override
  String get navPlaylists => 'پلی‌لیست‌ها';

  @override
  String get navSettings => 'تنظیمات';

  @override
  String get needsAttention => 'به توجه شما نیاز دارد';

  @override
  String get neverChecked => 'هنوز بررسی نشده';

  @override
  String get newFolder => 'پوشه‌ی جدید…';

  @override
  String get newFolderHint => 'مثلاً Ai/Lessons';

  @override
  String get newPlaylistAction => 'پلی‌لیست جدید';

  @override
  String get newTagHint => 'برچسب جدید';

  @override
  String newVideosBody(String channels) {
    return '$channels. وقتی VidHoist را باز کنید دانلود می‌شوند.';
  }

  @override
  String newVideosNotice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ویدیوی تازه',
      one: '$count ویدیوی تازه',
    );
    return '$_temp0';
  }

  @override
  String get next => 'بعدی';

  @override
  String get noBackupsYet => 'هنوز پشتیبانی نیست';

  @override
  String get noDownloads => 'دانلودی نیست';

  @override
  String get noDownloadsMessage =>
      'کلیپ‌های دانلودشده اینجا نمایش داده می‌شوند.\nیک لینک را به اشتراک بگذارید یا از دکمه‌ی «افزودن لینک» استفاده کنید.';

  @override
  String get noExternalPlayer => 'هیچ پخش‌کننده‌ی دیگری روی این دستگاه نیست';

  @override
  String get noFolder => 'بدون پوشه';

  @override
  String get noFolderHint => 'در بالای پوشه‌ی دانلودها';

  @override
  String get noLogsFound => 'گزارشی پیدا نشد';

  @override
  String get noPlayableSource => 'این مورد منبع قابل پخشی ندارد';

  @override
  String get noPlaylistsMessage =>
      'برای مرتب کردن کلیپ‌هایتان یک پلی‌لیست بسازید';

  @override
  String get noResults => 'نتیجه‌ای نیست';

  @override
  String get noResultsMessage => 'هیچ موردی با جستجوی شما جور نیست.';

  @override
  String get noServerTitle => 'موتور دانلود آماده نیست';

  @override
  String get noticeChannelNewVideos => 'ویدیوهای تازه';

  @override
  String get noticeChannelUpdates => 'به‌روزرسانی‌ها';

  @override
  String get noVideosFound => 'کتابخانه‌ی شما خالی است';

  @override
  String get noWarranty => 'همان‌طور که هست، بدون هیچ ضمانتی ارائه می‌شود.';

  @override
  String get notAffiliated =>
      'وابسته به yt-dlp یا هیچ سایتی نیست و مورد تأیید آن‌ها نیست.';

  @override
  String get nothingHereYet => 'هنوز اینجا چیزی نیست';

  @override
  String get notificationClipGone => 'این کلیپ دیگر روی گوشی نیست.';

  @override
  String get nowPlaying => 'در حال پخش';

  @override
  String get nowPlayingCollapse => 'جمع کردن پنل پخش‌کننده';

  @override
  String get nowPlayingExpand => 'نمایش پنل پخش‌کننده';

  @override
  String get ok => 'باشه';

  @override
  String get onlyNewVideos =>
      'فقط آنچه از این پس منتشر شود دانلود می‌شود. ویدیوهایی که از قبل در کانال هستند، همان‌جا می‌مانند.';

  @override
  String get openChannel => 'باز کردن کانال';

  @override
  String get openInExternalPlayer => 'باز کردن در پخش‌کننده‌ای دیگر';

  @override
  String get openOriginalLink => 'باز کردن لینک اصلی';

  @override
  String get ownFolder => 'ذخیره در پوشه‌ی خودش';

  @override
  String get ownFolderNote =>
      'پوشه‌ای درون پوشه‌ی دانلود، که Explorer و برنامه‌های دیگر هم آن را می‌بینند. فقط آنچه از این پس برسد به آنجا می‌رود؛ آنچه قبلاً دانلود شده سر جایش می‌ماند.';

  @override
  String get pasteUrlHint => 'لینک را اینجا بچسبانید…';

  @override
  String get pause => 'مکث';

  @override
  String get pauseSubscription => 'مکث';

  @override
  String get pcAddressLabel => 'نشانی';

  @override
  String get pcBadAddress =>
      'نشانی را همان‌طور که رایانه نشان می‌دهد تایپ کنید، مثلاً 192.168.1.24.';

  @override
  String get pcBadQr => 'این کد QR جفت‌سازی VidHoist نیست.';

  @override
  String get pcCertificate => 'گواهی رایانه';

  @override
  String get pcCodeLabel => 'کد';

  @override
  String get pcConnected => 'متصل';

  @override
  String get pcCopied => 'همراه با زیرنویس‌هایش در کتابخانه‌ی گوشی کپی شد.';

  @override
  String get pcCopyFailed =>
      'کپی تمام نشد: شاید رایانه خاموش یا دور از دسترس باشد. چیزی نگه داشته نشد.';

  @override
  String get pcCopyStarting => 'در حال کپی…';

  @override
  String get pcCopyStop => 'توقف کپی';

  @override
  String get pcCopyToPhone => 'کپی در گوشی';

  @override
  String pcCopying(int percent) {
    return 'در حال کپی $percent%';
  }

  @override
  String get pcDelete => 'حذف از رایانه';

  @override
  String pcDeleteBody(String title) {
    return '«$title» به سطل بازیافت رایانه می‌رود و از آنجا قابل برگرداندن است.';
  }

  @override
  String get pcDeleteFailed =>
      'رایانه نتوانست آن را حذف کند. شاید آنجا باز باشد.';

  @override
  String get pcDeleteMissing => 'این کلیپ دیگر روی رایانه نیست.';

  @override
  String get pcDeleteNoBin => 'حذف نشد: درایو آن روی رایانه سطل بازیافت ندارد.';

  @override
  String get pcDeleteNotAllowed =>
      'رایانه به گوشی اجازه‌ی حذف نمی‌دهد. آن را در رایانه از تنظیمات › گوشی روشن کنید.';

  @override
  String pcDeleteTitle(String name) {
    return 'از $name حذف شود؟';
  }

  @override
  String pcDeleted(String title) {
    return 'در سطل بازیافت رایانه: $title';
  }

  @override
  String get pcDestPhone => 'این گوشی';

  @override
  String pcDoneOnPc(String title) {
    return 'روی رایانه انجام شد: $title';
  }

  @override
  String pcDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دانلود برای رایانه',
      one: '1 دانلود برای رایانه',
    );
    return '$_temp0';
  }

  @override
  String get pcDownloadsSheet => 'دانلودهای روی رایانه';

  @override
  String get pcEmptyLibrary => 'هنوز دانلودی روی رایانه نیست.';

  @override
  String get pcErrBad =>
      'رایانه پاسخی داد که این نسخه آن را نمی‌فهمد. هر دو برنامه را به‌روز کنید.';

  @override
  String get pcErrClosed =>
      'هیچ کدی روی رایانه نمایش داده نمی‌شود، یا منقضی شده است. آنجا «جفت کردن گوشی» را بزنید.';

  @override
  String get pcErrDenied =>
      'جفت‌سازی روی رایانه رد شد، یا به‌موقع پاسخ داده نشد.';

  @override
  String get pcErrRefused => 'رایانه این لینک را نپذیرفت.';

  @override
  String get pcErrUnauthorized =>
      'رایانه دیگر این گوشی را نمی‌شناسد. دوباره جفت کنید.';

  @override
  String get pcErrUnreachable =>
      'رایانه پاسخ نداد. آیا روشن است، در همین شبکه یا در Tailscale شماست، و «دریافت از گوشی» در آن روشن است؟';

  @override
  String get pcErrWrongCertificate =>
      'چیزی غیر از رایانه‌ی شما در این نشانی پاسخ داد. چیزی فرستاده نشد.';

  @override
  String get pcErrWrongCode => 'کد اشتباه است.';

  @override
  String get pcFindNone =>
      'رایانه‌ای پیدا نشد. اول روی رایانه، تنظیمات › گوشی › جفت کردن گوشی را باز کنید، در همان Wi-Fi.';

  @override
  String get pcFindOnNetwork => 'یافتن در شبکه';

  @override
  String get pcFirewallAllow => 'اجازه دادن';

  @override
  String get pcFirewallBlocked =>
      'فایروال Windows جلوی VidHoist را گرفته، پس گوشی به آن دسترسی ندارد. در شبکه‌های خانگی (خصوصی) به آن اجازه دهید.';

  @override
  String get pcFirewallMissing =>
      'Windows هنوز اجازه نداده VidHoist از گوشی دریافت کند. یک بار، فقط در شبکه‌های خانگی (خصوصی)، اجازه دهید.';

  @override
  String get pcFirewallPublic =>
      'Windows این شبکه را عمومی می‌داند و در آن هیچ چیز را راه نمی‌دهد. اگر شبکه‌ی خانگی شماست، آن را خصوصی کنید: تنظیمات › شبکه و اینترنت › Wi-Fi › ویژگی‌های آن.';

  @override
  String get pcFirewallRefused =>
      'چیزی تغییر نکرد: Windows به اجازه‌ی مدیر سیستم نیاز دارد.';

  @override
  String get pcFirewallTitle => 'فایروال Windows';

  @override
  String pcFound(String name) {
    return '$name پیدا شد. کدی را که نشان می‌دهد تایپ کنید.';
  }

  @override
  String pcFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد پیدا شد',
      one: '1 مورد پیدا شد',
    );
    return '$_temp0';
  }

  @override
  String pcLastContact(String time) {
    return 'آخرین ارتباط: $time';
  }

  @override
  String get pcLibrary => 'کتابخانه‌ی روی رایانه';

  @override
  String get pcLinkAddress => 'نشانی در این شبکه';

  @override
  String get pcLinkAddressTailscale => 'از طریق Tailscale، بیرون از خانه';

  @override
  String get pcLinkAllow => 'اجازه دادن';

  @override
  String get pcLinkAllowDelete => 'اجازه‌ی حذف کلیپ به گوشی';

  @override
  String get pcLinkAllowDeleteHint =>
      'کلیپی که از گوشی حذف شود به سطل بازیافت این رایانه می‌رود و می‌توانید آن را برگردانید. در درایوی که سطل بازیافت ندارد، حذف نمی‌شود.';

  @override
  String get pcLinkCodeHint =>
      'در گوشی: تنظیمات › رایانه › اسکن کد QR. یا این نشانی و کد را آنجا تایپ کنید. یک بار و به مدت دو دقیقه کار می‌کند.';

  @override
  String pcLinkCodeLeft(int seconds) {
    return '$seconds ثانیه مانده';
  }

  @override
  String get pcLinkCodeTitle => 'کد جفت‌سازی';

  @override
  String get pcLinkDeny => 'رد کردن';

  @override
  String get pcLinkDevices => 'گوشی‌های جفت‌شده';

  @override
  String pcLinkFailed(String error) {
    return 'شروع نشد: $error';
  }

  @override
  String get pcLinkIntro =>
      'از VidHoist روی گوشی‌تان به این رایانه لینک بفرستید، و دانلودها و کتابخانه‌ی آن را در گوشی ببینید. در شبکه‌ی خانگی‌تان کار می‌کند، و بیرون از آن از طریق Tailscale.';

  @override
  String pcLinkLastSeen(String time) {
    return 'آخرین خبر: $time';
  }

  @override
  String get pcLinkNoDevices => 'هنوز گوشی‌ای نیست.';

  @override
  String get pcLinkOff => 'خاموش';

  @override
  String pcLinkOtherAddresses(int count) {
    return 'نشانی‌های دیگر ($count)';
  }

  @override
  String get pcLinkOtherAddressesHint =>
      'کارت‌های شبکه‌ای که برنامه‌های دیگر اضافه می‌کنند، مثل VirtualBox یا WSL. گوشی به‌ندرت به آن‌ها نیاز دارد.';

  @override
  String get pcLinkPairPhone => 'جفت کردن گوشی';

  @override
  String pcLinkPairedAt(String time) {
    return 'جفت‌شده: $time';
  }

  @override
  String pcLinkPhones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count گوشی',
      one: 'یک گوشی',
      zero: 'بدون گوشی',
    );
    return '$_temp0';
  }

  @override
  String get pcLinkQrHint => 'از گوشی اسکن کنید';

  @override
  String get pcLinkReceive => 'دریافت از گوشی';

  @override
  String get pcLinkReceiveHint =>
      'تا وقتی خاموش است، هیچ درگاهی روی این رایانه باز نیست. اگر Windows پرسید، فقط به شبکه‌های خصوصی اجازه دهید.';

  @override
  String pcLinkRequest(String name) {
    return '$name درخواست جفت شدن دارد';
  }

  @override
  String get pcLinkRequestHint =>
      'فقط اگر گوشی همین چهار رقم را نشان می‌دهد اجازه دهید.';

  @override
  String get pcLinkRevoke => 'لغو جفت‌سازی';

  @override
  String get pcLinkSecurity =>
      'گوشی مستقیم با این رایانه صحبت می‌کند، در شبکه‌ی شما یا از طریق Tailscale شما. یک بار جفت می‌شود، با کد و تأیید شما در اینجا؛ پس از آن با هر درخواست کلید خودش را ارائه می‌دهد، روی اتصالی که فقط با گواهی همین رایانه رمزگذاری شده است. هر کس دیگری در شبکه با در بسته روبه‌رو می‌شود.';

  @override
  String get pcLinkStarting => 'در حال شروع…';

  @override
  String get pcLinkTitle => 'گوشی';

  @override
  String get pcListEmpty =>
      'هیچ‌یک از کلیپ‌های این فهرست دیگر روی رایانه نیست.';

  @override
  String get pcListen => 'شنیدن';

  @override
  String get pcLists => 'فهرست‌های روی رایانه';

  @override
  String get pcListsEmpty => 'هیچ فهرستی روی رایانه کلیپ ندارد.';

  @override
  String get pcNow => 'اکنون روی رایانه';

  @override
  String get pcOffline => 'در دسترس نیست';

  @override
  String get pcOfflineMessage =>
      'رایانه خاموش است یا در شبکه‌ی دیگری است. آنچه دفعه‌ی پیش داشت در پایین نمایش داده می‌شود.';

  @override
  String get pcOfflineRoute =>
      'بیرون از خانه هستید؟ در تنظیمات › رایانه، Tailscale را انتخاب کنید.';

  @override
  String get pcOnPhone => 'روی گوشی';

  @override
  String get pcOrType => 'یا نشانی و کد را تایپ کنید';

  @override
  String get pcOutboxRefused => 'رایانه این لینک را نپذیرفت';

  @override
  String pcOutboxTitle(int count) {
    return 'در انتظار فرستادن ($count)';
  }

  @override
  String get pcPairButton => 'جفت کردن';

  @override
  String pcPairCheck(String check) {
    return 'بررسی کنید که رایانه $check را نشان دهد، سپس آنجا به گوشی اجازه دهید.';
  }

  @override
  String get pcPairIntro =>
      'اگر VidHoist روی رایانه‌ی Windows شما اجرا می‌شود، این گوشی می‌تواند برایش لینک بفرستد و دانلودها و کتابخانه‌اش را نشان دهد. روی رایانه، تنظیمات › گوشی را روشن کنید و «جفت کردن گوشی» را بزنید، سپس کد QR نمایش‌داده‌شده را اسکن کنید.';

  @override
  String pcPaired(String name) {
    return 'با $name جفت شد';
  }

  @override
  String get pcPortLabel => 'درگاه';

  @override
  String pcQueued(String name) {
    return 'وقتی $name برگردد به آن فرستاده می‌شود.';
  }

  @override
  String pcQueuedMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کلیپ وقتی $name برگردد به آن فرستاده می‌شوند.',
      one: '1 کلیپ وقتی $name برگردد به آن فرستاده می‌شود.',
    );
    return '$_temp0';
  }

  @override
  String get pcRouteHint =>
      'وقتی بیرون از خانه هستید Tailscale را انتخاب کنید؛ باید هم روی گوشی و هم روی رایانه اجرا شود.';

  @override
  String get pcRouteHome => 'شبکه‌ی خانگی';

  @override
  String get pcRouteOther => 'شبکه‌ی دیگر';

  @override
  String get pcRouteTailscale => 'Tailscale';

  @override
  String get pcRouteTitle => 'اتصال از طریق';

  @override
  String get pcRouteWaiting =>
      'مسیرهای دیگر رایانه پس از پاسخ دادن آن اینجا نمایش داده می‌شوند.';

  @override
  String get pcScanButton => 'اسکن کد QR';

  @override
  String get pcScanFailed => 'دوربین باز نشد.';

  @override
  String get pcScanPrompt => 'دوربین را به سمت کد QR روی صفحه‌ی رایانه بگیرید';

  @override
  String get pcSearchHint => 'جستجو در کتابخانه‌ی رایانه';

  @override
  String get pcSendToPc => 'فرستادن به رایانه';

  @override
  String pcSent(String name) {
    return 'به $name فرستاده شد';
  }

  @override
  String pcSentMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کلیپ به $name فرستاده شد',
      one: '1 کلیپ به $name فرستاده شد',
    );
    return '$_temp0';
  }

  @override
  String get pcSettingsHint => 'فرستادن لینک به رایانه‌تان';

  @override
  String get pcTab => 'رایانه';

  @override
  String pcVia(String route) {
    return 'از طریق $route';
  }

  @override
  String get pcWatch => 'تماشا';

  @override
  String get pcWillSend => 'دور از دسترس: وقتی برگردد فرستاده می‌شود';

  @override
  String get pickAnotherFile => 'از فایلی دیگر…';

  @override
  String get pickAnotherFileSubtitle =>
      'پشتیبانی از گوشی دیگر یا نسخه‌ای قدیمی‌تر';

  @override
  String get pictureInPicture => 'تصویر در تصویر';

  @override
  String get pictureInPictureHelp =>
      'وقتی هنگام پخش کلیپ از برنامه بیرون می‌روید، کلیپ در گوشه‌ای از صفحه می‌ماند';

  @override
  String get pinPlaylist => 'سنجاق به بالا';

  @override
  String get platform => 'سایت';

  @override
  String platformCount(Object name, int count) {
    return '$name · $count';
  }

  @override
  String get platformOther => 'دیگر';

  @override
  String get play => 'پخش';

  @override
  String get playAll => 'پخش همه';

  @override
  String get playModeLabel => 'حالت';

  @override
  String get playbackSpeed => 'سرعت پخش';

  @override
  String get playerError => 'این فایل پخش نشد';

  @override
  String get playingFromDevice => 'پخش از دستگاه شما';

  @override
  String get playlist => 'پلی‌لیست';

  @override
  String get playlistAddClips => 'افزودن کلیپ';

  @override
  String playlistAddClipsTo(String name) {
    return 'افزودن به «$name»';
  }

  @override
  String playlistAddCount(int count) {
    return 'افزودن ($count)';
  }

  @override
  String get playlistCreated => 'پلی‌لیست ساخته شد';

  @override
  String get playlistDeleted => 'پلی‌لیست حذف شد';

  @override
  String get playlistDetails => 'جزئیات پلی‌لیست';

  @override
  String get playlistEditHint =>
      'برای جابه‌جا کردن یک کلیپ، آن را لمس کنید و نگه دارید. برای برداشتن، آن را به کنار بکشید.';

  @override
  String get playlistName => 'نام پلی‌لیست';

  @override
  String get playlistNameHint => 'پلی‌لیست من';

  @override
  String playlistOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get playlists => 'پلی‌لیست‌ها';

  @override
  String get previous => 'قبلی';

  @override
  String get quality => 'کیفیت';

  @override
  String get quality1080 => 'تا 1080p';

  @override
  String get quality360 => 'تا 360p';

  @override
  String get quality480 => 'تا 480p';

  @override
  String get quality720 => 'تا 720p';

  @override
  String get qualityAudio => 'صدا';

  @override
  String get qualityBest => 'بهترین';

  @override
  String get qualityHelper =>
      'در دانلود سریع، دانلود کل پلی‌لیست و دکمه‌ی «دانلود» در نوار کلیپ‌بورد به کار می‌رود، و گزینه‌ی از پیش انتخاب‌شده در برگه‌ی افزودن لینک است. پس چه دانلود سریع روشن باشد چه نه، اهمیت دارد.';

  @override
  String get qualityReading => 'در حال خواندن فایل…';

  @override
  String get qualityUnavailable => 'در دسترس نیست';

  @override
  String get qualityVideo => 'ویدیو';

  @override
  String queueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد',
      one: '1 مورد',
      zero: 'بدون مورد',
    );
    return '$_temp0';
  }

  @override
  String get queueLabel => 'صف';

  @override
  String queuePosition(int position) {
    return 'شماره‌ی $position در صف';
  }

  @override
  String get queued => 'در صف';

  @override
  String get queuedSection => 'در انتظار';

  @override
  String get quickDownload => 'دانلود سریع';

  @override
  String get quickDownloadHelp =>
      'لینکی که به اشتراک گذاشته یا چسبانده شود، بی‌درنگ و بدون برگه با کیفیت پیش‌فرض دانلود می‌شود. سایتی که آن کیفیت را ندارد بهترین کیفیت خود را می‌دهد، و «فقط صدا» در همه‌ی سایت‌ها کار می‌کند.';

  @override
  String get rateLimit => 'محدودیت سرعت';

  @override
  String get rateLimitNone => 'بدون محدودیت';

  @override
  String rateLimitValue(int mb) {
    return '$mb MB/s';
  }

  @override
  String get reelsEndBack => 'بازگشت به کتابخانه';

  @override
  String get reelsEndContinue => 'ادامه‌ی بقیه‌ی فهرست';

  @override
  String get reelsEndReplay => 'پخش دوباره از ابتدا';

  @override
  String get reelsEndTitle => 'پایان ویدیوهای کوتاه';

  @override
  String get reelsSwipeHint => 'برای ویدیوی کوتاه بعدی، به بالا بکشید';

  @override
  String get refresh => 'تازه‌سازی';

  @override
  String get remove => 'برداشتن';

  @override
  String get removeFromFavorites => 'برداشتن از علاقه‌مندی‌ها';

  @override
  String removeUnavailable(int count) {
    return 'برداشتن $count مورد ناموجود';
  }

  @override
  String get removedFromFavorites => 'از علاقه‌مندی‌ها برداشته شد';

  @override
  String get removedFromPlaylist => 'از پلی‌لیست برداشته شد';

  @override
  String get rename => 'تغییر نام';

  @override
  String get renameTag => 'تغییر نام برچسب';

  @override
  String get reportBug => 'گزارش اشکال';

  @override
  String get restoreConfirm =>
      'داده‌ها از فایل پشتیبان بازیابی شوند؟ این کار پلی‌لیست‌ها، برچسب‌ها و تنظیمات فعلی را بازنویسی می‌کند.';

  @override
  String get restoreData => 'بازیابی';

  @override
  String get restoreFailed => 'بازیابی ناموفق بود: فایل پشتیبان معتبر نیست';

  @override
  String get restorePickBody =>
      'این گوشی دانلودهای VidHoist را دارد اما تنظیماتی ندارد، مثل پس از نصب دوباره. اگر پشتیبانی نگه داشته‌اید، آن را انتخاب کنید: برنامه پشتیبان‌ها را در Download/VidHoist/backups می‌نویسد.';

  @override
  String get restorePickChoose => 'انتخاب پشتیبان';

  @override
  String get restorePickTitle => 'تنظیماتتان را برمی‌گردانید؟';

  @override
  String get restoreSettings => 'بازیابی همه‌ی داده‌ها';

  @override
  String get restoreSuccess => 'داده‌ها با موفقیت بازیابی شد';

  @override
  String get resumeSubscription => 'ادامه';

  @override
  String get retry => 'تلاش دوباره';

  @override
  String get saveSettings => 'ذخیره‌ی تنظیمات';

  @override
  String get searchLogs => 'جستجو در گزارش‌ها…';

  @override
  String get searchVideos => 'جستجوی کلیپ‌ها…';

  @override
  String get seekBackward10 => '10 ثانیه عقب';

  @override
  String get seekForward10 => '10 ثانیه جلو';

  @override
  String get selectAll => 'انتخاب همه';

  @override
  String selected(int count) {
    return '$count مورد انتخاب شد';
  }

  @override
  String selectedCount(int count) {
    return '$count مورد انتخاب شد';
  }

  @override
  String get settings => 'تنظیمات';

  @override
  String get settingsAccounts => 'حساب‌ها';

  @override
  String get settingsBackup => 'پشتیبان';

  @override
  String get settingsDownloads => 'دانلودها';

  @override
  String get settingsGroupApp => 'برنامه';

  @override
  String get settingsGroupData => 'داده‌ها';

  @override
  String get settingsPlayback => 'پخش';

  @override
  String get settingsTranscripts => 'رونوشت‌ها و زیرنویس‌ها';

  @override
  String settingsValueChannels(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کانال',
      one: '1 کانال',
      zero: 'هنوز کانالی نیست',
    );
    return '$_temp0';
  }

  @override
  String get settingsValueCompatOff => 'بهترین سازگاری: خاموش';

  @override
  String get settingsValueCompatOn => 'بهترین سازگاری: روشن';

  @override
  String get settingsValueNotSet => 'هنوز تنظیم نشده';

  @override
  String get settingsValueQuick => 'سریع';

  @override
  String settingsValueSignedIn(String sites) {
    return 'وارد شده: $sites';
  }

  @override
  String get settingsValueWifiOnly => 'فقط Wi-Fi';

  @override
  String get share => 'اشتراک‌گذاری';

  @override
  String get shareLogs => 'اشتراک‌گذاری گزارش‌ها';

  @override
  String get shareOpening => 'در حال باز کردن منوی اشتراک‌گذاری…';

  @override
  String get shareOpeningHint => 'تحویل یک فایل بزرگ چند ثانیه طول می‌کشد.';

  @override
  String get shareSelected => 'اشتراک‌گذاری موارد انتخاب‌شده';

  @override
  String get sharedLinksAdd => 'افزودن همه';

  @override
  String get sharedLinksBody => 'هر کدام روی این گوشی دانلود می‌شود.';

  @override
  String sharedLinksCapped(int max) {
    return 'فقط $max لینک اول اضافه شد.';
  }

  @override
  String sharedLinksTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لینک اضافه شوند؟',
      one: '1 لینک اضافه شود؟',
    );
    return '$_temp0';
  }

  @override
  String get shortsFilter => 'ویدیوهای کوتاه';

  @override
  String get shuffle => 'پخش تصادفی';

  @override
  String get signInRequired => 'ورود لازم است';

  @override
  String get size => 'اندازه';

  @override
  String get smartPlaylists => 'پلی‌لیست‌های هوشمند';

  @override
  String get sortAndPlatform => 'مرتب‌سازی و سایت';

  @override
  String get sortBy => 'مرتب‌سازی بر اساس';

  @override
  String get sortLargest => 'بزرگ‌ترین';

  @override
  String get sortNameAZ => 'نام A–Z';

  @override
  String get sortNameZA => 'نام Z–A';

  @override
  String get sortNewest => 'تازه‌ترین';

  @override
  String get sortOldest => 'قدیمی‌ترین';

  @override
  String get sortSmallest => 'کوچک‌ترین';

  @override
  String get sortedByLastPlayed => 'بر اساس آخرین پخش';

  @override
  String get source => 'منبع';

  @override
  String get sourceCode => 'کد منبع';

  @override
  String get starAskBody =>
      'رایگان و متن‌باز، بدون تبلیغ و بدون حساب. یک ستاره در GitHub به دیگران کمک می‌کند آن را پیدا کنند.';

  @override
  String get starAskIdeas => 'پیشنهاد یک ایده یا گزارش یک مشکل';

  @override
  String get starAskLater => 'شاید بعداً';

  @override
  String get starAskNever => 'دیگر نشان نده';

  @override
  String get starAskStar => 'در GitHub ستاره بدهید';

  @override
  String get starAskTitle => 'از VidHoist راضی هستید؟';

  @override
  String get startDownload => 'شروع دانلود';

  @override
  String get status => 'وضعیت';

  @override
  String get storageCardMissing =>
      'کارت حافظه وصل نیست، پس دانلودها در گوشی ذخیره می‌شوند';

  @override
  String get storageLocation => 'ذخیره در';

  @override
  String get storageLocationHelp =>
      'کلیپ‌هایی که قبلاً دانلود شده‌اند سر جایشان می‌مانند و همچنان در کتابخانه نمایش داده می‌شوند. کارت حافظه به Android 11 یا جدیدتر نیاز دارد.';

  @override
  String get storageNoCard => 'این گوشی کارت حافظه ندارد';

  @override
  String get storagePhone => 'حافظه‌ی گوشی';

  @override
  String get streamingOnline => 'پخش از طریق شبکه';

  @override
  String subscriptionAdded(String name) {
    return 'اکنون $name را دنبال می‌کنید';
  }

  @override
  String get subscriptionName => 'نام';

  @override
  String get subscriptionPaused => 'مکث‌شده';

  @override
  String get subscriptionQuality => 'کیفیت برای این کانال';

  @override
  String get subscriptionQualityHelp =>
      'کیفیتی که ویدیوهای تازه‌ی این کانال با آن دانلود می‌شوند. بعداً می‌توانید با ویرایش کانال آن را تغییر دهید؛ ویدیوهای دانلودشده کیفیت خود را نگه می‌دارند.\n\n«بهترین» ممکن است به معنای 4K با قالب AV1 باشد که رایانه‌ی قدیمی ممکن است آن را با لرزش پخش کند: اگر چنین بود، 1080p را انتخاب کنید.';

  @override
  String get subscriptionQualityNote =>
      'برای ویدیوهای تازه اعمال می‌شود؛ ویدیوهای دانلودشده کیفیت خود را نگه می‌دارند.';

  @override
  String get subscriptions => 'کانال‌ها';

  @override
  String get subscriptionsEmpty => 'هنوز کانالی را دنبال نمی‌کنید';

  @override
  String get subscriptionsEmptyBody =>
      'کانالی را دنبال کنید تا هر ویدیوی تازه، وقتی VidHoist باز است یا در سینی است، خودش در کتابخانه‌تان دانلود شود. آنچه از قبل در کانال هست دانلود نمی‌شود.';

  @override
  String get subscriptionsSubtitle =>
      'ویدیوهای تازه از کانال‌هایی که دنبال می‌کنید، خودشان دانلود می‌شوند';

  @override
  String get subtitleLangs => 'زبان‌های زیرنویس';

  @override
  String get subtitleLangsHelp =>
      'اگر ویدیو داشته باشد دریافت می‌شوند. دست‌کم یکی انتخاب‌شده می‌ماند.';

  @override
  String get subtitles => 'زیرنویس‌ها';

  @override
  String get subtitlesBackground => 'پس‌زمینه';

  @override
  String get subtitlesBackgroundFaint => 'کم‌رنگ';

  @override
  String get subtitlesBackgroundHelp =>
      'آنچه پشت واژه‌ها قرار می‌گیرد. بدون پس‌زمینه، هر حرف لبه‌ای تیره دارد تا روی تصویر روشن هم خوانا بماند.';

  @override
  String get subtitlesBackgroundNone => 'هیچ';

  @override
  String get subtitlesBackgroundSolid => 'تیره';

  @override
  String get subtitlesHide => 'پنهان کردن زیرنویس';

  @override
  String get subtitlesLanguage => 'زبان زیرنویس';

  @override
  String get subtitlesShow => 'نمایش زیرنویس';

  @override
  String get subtitlesShowHelp =>
      'روی ویدیو، برای کلیپ‌هایی که رونوشت دارند. دکمه‌ی CC در پخش‌کننده هم همین کار را می‌کند.';

  @override
  String get subtitlesSize => 'اندازه‌ی متن';

  @override
  String get subtitlesSizeLarge => 'بزرگ';

  @override
  String get subtitlesSizeMedium => 'متوسط';

  @override
  String get subtitlesSizeSmall => 'کوچک';

  @override
  String tagLimitReached(int max) {
    return 'حداکثر $max برچسب می‌توانید داشته باشید. برای افزودن برچسب دیگر، یکی را در «مدیریت برچسب‌ها» بردارید.';
  }

  @override
  String get tags => 'برچسب‌ها';

  @override
  String get tagsOpenFiltered => 'کتابخانه را فیلترشده باز می‌کند';

  @override
  String get theme => 'پوسته';

  @override
  String get themeDark => 'تیره';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeSystem => 'سیستم';

  @override
  String get titleFilter => 'فقط عنوان‌هایی دانلود شوند که شامل این باشند';

  @override
  String get titleFilterHelp =>
      'ویدیوی تازه‌ی این کانال فقط وقتی دانلود می‌شود که عنوانش شامل چیزی باشد که اینجا می‌نویسید.\n\n• یک واژه‌ی ساده کافی است: Episode\n• هر یک از چند واژه: Episode|Part (علامت | یعنی «یا»)\n• حروف بزرگ و کوچک مهم نیست: episode با Episode هم جور است.\n\nویدیویی که فیلتر از آن می‌گذرد برای همیشه دیده‌شده به حساب می‌آید: برداشتن فیلتر در آینده، آنچه را بعد از آن می‌آید دانلود می‌کند، نه آنچه را که رد شده است.';

  @override
  String get titleFilterHelper =>
      'چند واژه: آن‌ها را با | جدا کنید. برای همه چیز خالی بگذارید.';

  @override
  String get titleFilterHint => 'مثلاً Episode';

  @override
  String get titleLabel => 'عنوان';

  @override
  String totalDuration(Object duration) {
    return 'مجموع: $duration';
  }

  @override
  String get transcript => 'رونوشت';

  @override
  String transcriptSaidMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بار دیگر گفته شده',
      one: 'یک بار دیگر گفته شده',
    );
    return '$_temp0';
  }

  @override
  String transcriptsClips(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کلیپ',
      one: '1 کلیپ',
      zero: 'هنوز کلیپی نیست',
    );
    return '$_temp0';
  }

  @override
  String get transcriptsDeleteAll => 'حذف همه';

  @override
  String get transcriptsDeleteTitle => 'همه‌ی رونوشت‌ها حذف شوند؟';

  @override
  String get transcriptsSaidInside => 'گفته‌شده درون کلیپ‌ها';

  @override
  String get transcriptsSearchHelp =>
      'واژه‌های هر کلیپ YouTube را که اضافه می‌کنید نگه می‌دارد، تا بتوانید در آنچه گفته شده جستجو کنید.';

  @override
  String get tryAgain => 'دوباره امتحان کنید';

  @override
  String get undo => 'واگرد';

  @override
  String get unfollow => 'لغو دنبال کردن';

  @override
  String unfollowConfirm(String name) {
    return 'دنبال کردن $name لغو شود؟';
  }

  @override
  String get unfollowConfirmBody =>
      'VidHoist فراموش می‌کند کدام ویدیوهای این کانال را قبلاً دیده است. اگر بعداً دوباره آن را دنبال کنید، هر چه تا آن زمان در کانال باشد دیده‌شده به حساب می‌آید و آنچه از دست داده‌اید جبران نمی‌شود. مکث، این حافظه را نگه می‌دارد.';

  @override
  String get unlockTouch => 'باز کردن قفل';

  @override
  String get unpinPlaylist => 'برداشتن سنجاق';

  @override
  String get updateNoticeBody => 'برای نصب، VidHoist را باز کنید.';

  @override
  String get upNext => 'بعدی';

  @override
  String upNextIn(String name) {
    return 'بعدی در «$name»';
  }

  @override
  String get updateAllowInstallBody =>
      'Android پیش از آنکه برنامه بتواند به‌روزرسانی‌های خودش را نصب کند، به اجازه‌ی شما نیاز دارد. یک بار در تنظیمات سیستم اجازه دهید، سپس دوباره روی «نصب» بزنید.';

  @override
  String get updateAllowInstallTitle => 'اجازه‌ی نصب به‌روزرسانی‌ها';

  @override
  String get updateAvailable => 'به‌روزرسانی موجود است';

  @override
  String get updateCheckFailed => 'بررسی به‌روزرسانی‌ها انجام نشد';

  @override
  String get updateChecking => 'در حال بررسی…';

  @override
  String get updateDownloadFailed => 'به‌روزرسانی دانلود نشد';

  @override
  String updateDownloadedMb(String done, String total) {
    return '$done از $total MB';
  }

  @override
  String get updateDownloading => 'در حال دانلود به‌روزرسانی…';

  @override
  String get updateFailedToStart => 'نصب‌کننده باز نشد';

  @override
  String get updateInstall => 'نصب';

  @override
  String get updateLater => 'بعداً';

  @override
  String get updateNever => 'هنوز نه';

  @override
  String get updateNow => 'دانلود به‌روزرسانی';

  @override
  String get updateOpenSystemSettings => 'باز کردن تنظیمات';

  @override
  String get updateReady => 'آماده‌ی نصب';

  @override
  String updateSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get updateSkipVersion => 'رد کردن این نسخه';

  @override
  String get updateUpToDate => 'تازه‌ترین نسخه را دارید';

  @override
  String updateVersionAvailable(String version) {
    return 'نسخه‌ی $version موجود است';
  }

  @override
  String updateVersionTitle(String version) {
    return 'نسخه‌ی $version';
  }

  @override
  String get updateWhatsNew => 'تازه‌ها';

  @override
  String get updates => 'به‌روزرسانی‌ها';

  @override
  String get version => 'نسخه';

  @override
  String get videoAdded => 'به پلی‌لیست اضافه شد';

  @override
  String get videoPlayer => 'پخش‌کننده‌ی ویدیو';

  @override
  String get viewAll => 'دیدن همه';

  @override
  String get viewAllInPlaylists => 'دیدن همه';

  @override
  String get viewCards => 'کارت‌ها';

  @override
  String get viewGrid => 'شبکه‌ای';

  @override
  String get viewList => 'فهرستی';

  @override
  String get viewMode => 'نما';

  @override
  String get waitingForWifi => 'در انتظار Wi-Fi';

  @override
  String get whatsNewGotIt => 'متوجه شدم';

  @override
  String get whatsNewReleasePage => 'صفحه‌ی انتشار';

  @override
  String get whatsNewThisVersion => 'تازه‌های این نسخه';

  @override
  String whatsNewTitle(String version) {
    return 'تازه‌های $version';
  }

  @override
  String get whatsNewUnavailable =>
      'تغییرات این نسخه در صفحه‌ی انتشار آمده است.';

  @override
  String get wifiOnly => 'دانلود فقط با Wi-Fi';

  @override
  String get wifiOnlyHelp =>
      'هیچ چیز با داده‌ی همراه دانلود نمی‌شود. دانلودها منتظر Wi-Fi می‌مانند، و دانلودی که هنگام قطع Wi-Fi در جریان است مکث می‌کند و با برگشتن Wi-Fi خودش ادامه می‌یابد.';

  @override
  String get yourPlaylists => 'پلی‌لیست‌های شما';

  @override
  String get yourTags => 'برچسب‌های شما';

  @override
  String get ytdlpCredit => 'دانلودکننده‌ای که VidHoist اجرا می‌کند';
}
