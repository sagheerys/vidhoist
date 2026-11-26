// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'vh_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class VhLocalizationsUr extends VhLocalizations {
  VhLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get about => 'تعارف';

  @override
  String get aboutApp => 'ایپ کے بارے میں';

  @override
  String get aboutDescriptionPhone =>
      'ایک ہلکی اور تیز ایپ جو yt-dlp کے ذریعے بہت سی سائٹس سے ویڈیو اور آڈیو ڈاؤن لوڈ کرتی ہے۔ اس کا اپنا پلیئر اور پلے لسٹس ہیں۔';

  @override
  String get accountSignIn => 'سائن ان کریں';

  @override
  String get accountSignOut => 'سائن آؤٹ کریں';

  @override
  String get accountSignedIn => 'سائن ان ہے';

  @override
  String get accountSignedOut => 'سائن ان نہیں';

  @override
  String accountSignedOutOf(String site) {
    return '$site سے سائن آؤٹ ہو گیا';
  }

  @override
  String get accountsBanRisk =>
      'بہتر ہے کوئی ثانوی اکاؤنٹ استعمال کریں: زیادہ ڈاؤن لوڈنگ پر سائٹ کچھ عرصے کے لیے اکاؤنٹ پر پابندی لگا سکتی ہے۔';

  @override
  String get accountsClearAll => 'تمام کوکیز حذف کریں';

  @override
  String get accountsCleared => 'کوکیز حذف ہو گئیں';

  @override
  String get accountsFileHint =>
      'براؤزر سے cookies.txt فائل (Netscape فارمیٹ) کی صورت میں ایکسپورٹ کی گئی، کسی بھی سائٹ کے لیے، ان سائٹس سمیت جو اوپر درج نہیں۔ یہ یہاں پہلے سے موجود سائن اِنز میں شامل ہو جاتی ہے، اور اسی فون پر رہتی ہے۔';

  @override
  String get accountsFilePick => 'کوکیز فائل منتخب کریں';

  @override
  String get accountsFileTitle => 'یا کوکیز فائل امپورٹ کریں';

  @override
  String get accountsFromFile => 'کوکیز فائل سے';

  @override
  String get accountsHelp =>
      'سائن ان کچھ عرصے بعد ختم ہو جاتا ہے؛ جب کوئی سائٹ دوبارہ انکار کرنے لگے تو ایک بار پھر سائن ان کریں۔ ایک سائٹ سے سائن آؤٹ کرنے پر ایپ کا اندرونی براؤزر باقی سائٹس سے بھی سائن آؤٹ ہو جاتا ہے، جبکہ ان کے ڈاؤن لوڈ پہلے کی طرح جاری رہتے ہیں۔ اگر کوئی سائٹ یہاں سائن ان نہ ہونے دے تو نیچے سے اپنے کمپیوٹر کے براؤزر کی کوکیز فائل امپورٹ کریں۔';

  @override
  String get accountsHint =>
      'ان سائٹس کے لیے جو لاگ اِن کے بغیر ڈاؤن لوڈ سے انکار کرتی ہیں۔ آپ ایپ کے اندر سائٹ کے اپنے صفحے پر سائن ان کرتے ہیں؛ جو کچھ وہ چھوڑتی ہے وہ اسی فون پر رہتا ہے، جہاں yt-dlp ہر ڈاؤن لوڈ کے لیے اسے پڑھتا ہے، اور کہیں اور نہیں جاتا۔';

  @override
  String get activeDownloads => 'جاری ڈاؤن لوڈز';

  @override
  String activeDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ڈاؤن لوڈز جاری ہیں',
      one: '1 ڈاؤن لوڈ جاری ہے',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloadsSheet => 'جاری ڈاؤن لوڈز';

  @override
  String get activeNow => 'ابھی فعال';

  @override
  String get addLinkFab => 'لنک شامل کریں';

  @override
  String get addTo => 'اس میں شامل کریں…';

  @override
  String get addToFavorites => 'پسندیدہ میں شامل کریں';

  @override
  String get addToPlaylist => 'پلے لسٹ میں شامل کریں';

  @override
  String get addUrl => 'URL شامل کریں';

  @override
  String addedNToServer(int count) {
    return '$count ڈاؤن لوڈز میں شامل کیے گئے';
  }

  @override
  String get addedToFavorites => 'پسندیدہ میں شامل ہو گیا';

  @override
  String addedToPlaylistCount(int count) {
    return '$count پلے لسٹ میں شامل کیے گئے';
  }

  @override
  String get allDownloadsFinished => 'تمام ڈاؤن لوڈز مکمل ہو گئے۔';

  @override
  String get allPlatforms => 'تمام سائٹس';

  @override
  String get alreadyInPlaylist => 'پہلے سے شامل ہے';

  @override
  String get alreadySubscribed => 'یہ چینل پہلے سے فالو کیا جا رہا ہے';

  @override
  String get appTitle => 'VidHoist';

  @override
  String get appearanceAndLanguage => 'ظاہری شکل اور زبان';

  @override
  String audioChannels(int count) {
    return '$count چینلز';
  }

  @override
  String get audioFormat => 'آڈیو فارمیٹ';

  @override
  String get audioFormatM4a => 'M4A: ہر جگہ چلتا ہے';

  @override
  String get audioFormatMp3 => 'MP3: پرانے پلیئرز اور گاڑیوں کے لیے';

  @override
  String get audioFormatOriginal => 'جیسا سائٹ بھیجے، بغیر تبدیلی کے';

  @override
  String get audioMono => 'مونو';

  @override
  String get audioOnly => 'صرف آڈیو';

  @override
  String get audioStereo => 'اسٹیریو';

  @override
  String get autoBuilt => 'خودکار';

  @override
  String get autoCheckUpdates => 'خود بخود چیک کریں';

  @override
  String get autoCheckUpdatesHelp =>
      'دن میں تقریباً دو بار پس منظر میں نیا ورژن تلاش کرتا ہے۔';

  @override
  String get autoRestoreSuccess => 'ڈیٹا بیک اپ سے بحال ہو گیا۔';

  @override
  String get autoRetry => 'نیٹ ورک واپس آنے پر دوبارہ کوشش کریں';

  @override
  String get autoRetryHelp =>
      'جو کچھ نیٹ ورک منقطع ہونے کی وجہ سے ناکام ہوا، نیٹ ورک واپس آنے پر خود بخود دوبارہ آزمایا جاتا ہے۔ جسے سائٹ نے رد کیا اسے دوبارہ نہیں آزمایا جاتا: بغیر تبدیلی کے دہرانے سے وہ پھر ناکام ہو گا۔';

  @override
  String get backgroundChecks => 'ایپ بند ہونے پر جانچ';

  @override
  String get backgroundChecksHelp =>
      'تقریباً ہر چھ گھنٹے، جب نیٹ ورک ہو اور بیٹری کم نہ ہو۔ یہ صرف نئی چیزوں کی خبر دیتی ہے؛ ویڈیوز تب ڈاؤن لوڈ ہوتی ہیں جب آپ VidHoist کھولیں۔';

  @override
  String get backgroundDownload => 'فائلیں پس منظر میں ڈاؤن لوڈ ہو رہی ہیں…';

  @override
  String backgroundLastRun(String when) {
    return 'ایپ بند ہونے پر آخری جانچ: $when';
  }

  @override
  String get backgroundNotRunYet =>
      'ابھی تک ایپ بند ہونے پر کوئی جانچ نہیں ہوئی: وقت اینڈرائیڈ چنتا ہے۔';

  @override
  String get backgroundOfferBody =>
      'VidHoist تقریباً ہر چھ گھنٹے آپ کے چینلز دیکھ کر نئی چیزوں کی خبر دے سکتی ہے۔ ایپ کھولنے تک کچھ ڈاؤن لوڈ نہیں ہوتا۔';

  @override
  String get backgroundOfferNo => 'ابھی نہیں';

  @override
  String get backgroundOfferTitle =>
      'کیا VidHoist بند ہونے پر نئی ویڈیوز کی خبر چاہتے ہیں؟';

  @override
  String get backgroundOfferYes => 'آن کریں';

  @override
  String get backupNote =>
      'اس میں لائبریری، پلے لسٹس، ٹیگز، فالو کیے گئے چینلز اور ترتیبات شامل ہیں۔ سائن اِنز اور ٹرانسکرپٹس الگ رکھے جاتے ہیں، اور میڈیا فائلیں خود شامل نہیں ہوتیں۔';

  @override
  String get backupSettings => 'تمام ڈیٹا کا بیک اپ لیں';

  @override
  String get backupSettingsSubtitle =>
      'تاریخ والی سات کاپیاں جو خود تازہ ہوتی رہتی ہیں۔ ان میں سے کوئی بھی بحال کریں، یا شیئر کرنے کے لیے ایک ایکسپورٹ کریں';

  @override
  String backupSuccess(Object path) {
    return 'بیک اپ یہاں محفوظ ہوا: $path';
  }

  @override
  String backupsKept(int count) {
    return '$count بیک اپ محفوظ ہیں';
  }

  @override
  String get batchDownloadSelected => 'منتخب ڈاؤن لوڈ کریں';

  @override
  String get batchLoading => 'پلے لسٹ پڑھی جا رہی ہے…';

  @override
  String get batchNothingSelected => 'کم از کم ایک آئٹم منتخب کریں';

  @override
  String batchSelectedOf(int selected, int total) {
    return '$total میں سے $selected منتخب';
  }

  @override
  String get batchThisVideoOnly => 'صرف یہ کلپ ڈاؤن لوڈ کریں';

  @override
  String get batchTitle => 'اجتماعی ڈاؤن لوڈ';

  @override
  String get batteryAllow => 'اجازت دیں';

  @override
  String get batteryFree =>
      'بیٹری کی بچت ڈاؤن لوڈز کو نہیں چھیڑتی، چاہے ایپ نظر سے اوجھل ہو۔';

  @override
  String get batteryRestricted =>
      'ایپ نظر سے اوجھل ہو تو بیٹری کی بچت کسی لمبے ڈاؤن لوڈ کو روک سکتی ہے۔';

  @override
  String get batteryStateFree => 'اجازت ہے';

  @override
  String get batteryStateLimited => 'محدود';

  @override
  String get batteryTitle => 'پس منظر میں ڈاؤن لوڈز';

  @override
  String bitrateKbps(String value) {
    return '$value kb/s';
  }

  @override
  String bitrateMbps(String value) {
    return '$value Mb/s';
  }

  @override
  String get builtWith => 'ان سے بنی ہے';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get changeQuality => 'کوالٹی بدلیں';

  @override
  String get channelNameFolder => 'چینل کے نام پر';

  @override
  String channelFollowers(String count) {
    return '$count سبسکرائبرز';
  }

  @override
  String get channelCheckFailed =>
      'اس بار چیک نہیں ہو سکا۔ VidHoist خود دوبارہ کوشش کرے گا۔';

  @override
  String get channelUrl => 'کسی چینل، پلے لسٹ یا اس کی کسی ویڈیو کا لنک';

  @override
  String get channelUrlHint => 'https://www.youtube.com/@name';

  @override
  String chapterNumber(int number) {
    return 'باب $number';
  }

  @override
  String get chaptersFold => 'ابواب چھپائیں';

  @override
  String chaptersFromTranscript(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ٹرانسکرپٹ سے $count ابواب',
      one: 'ٹرانسکرپٹ سے 1 باب',
    );
    return '$_temp0';
  }

  @override
  String get chaptersShowAll => 'تمام ابواب دیکھیں';

  @override
  String get chaptersUnfold => 'ابواب دکھائیں';

  @override
  String get checkEvery => 'کتنی بار دیکھا جائے';

  @override
  String get checkForUpdates => 'اپ ڈیٹس چیک کریں';

  @override
  String get checkNow => 'ابھی چیک کریں';

  @override
  String get checkQueued =>
      'ابھی چیک ہو رہا ہے۔ جو کچھ نیا ہو گا وہ لائبریری میں نظر آئے گا۔';

  @override
  String get chooseFolder => 'فولڈر منتخب کریں';

  @override
  String get chooseOptions => 'اختیارات';

  @override
  String get clear => 'صاف کریں';

  @override
  String get clearLogs => 'لاگز صاف کریں';

  @override
  String get clearLogsConfirm => 'تمام تشخیصی لاگز حذف کریں؟';

  @override
  String get clipEndAfterStart => 'آغاز کے بعد';

  @override
  String get clipFrom => 'سے';

  @override
  String clipLength(Object length) {
    return 'ویڈیو کی لمبائی $length ہے';
  }

  @override
  String get clipLengthReading => 'ویڈیو کی لمبائی پڑھی جا رہی ہے…';

  @override
  String get clipLengthUnknown =>
      'سائٹ ویڈیو کی لمبائی نہیں بتاتی، اس لیے اوقات کی جانچ نہیں ہوتی';

  @override
  String get clipMinuteDown => 'ایک منٹ پہلے';

  @override
  String get clipMinuteUp => 'ایک منٹ بعد';

  @override
  String get clipOnly => 'ویڈیو کا صرف ایک حصہ';

  @override
  String get clipOnlyHelp =>
      'ایک وقت سے دوسرے وقت تک، باقی کے بغیر۔ یہ سب ٹائٹلز کے بغیر آتا ہے۔';

  @override
  String clipPastEnd(Object length) {
    return 'ویڈیو $length پر ختم ہوتی ہے';
  }

  @override
  String get clipTimeHint => 'صرف ہندسے: 130 کا مطلب 1:30 ہے';

  @override
  String get clipTo => 'تک';

  @override
  String get clipboardFound => 'آپ کے کلپ بورڈ میں ایک لنک تیار ہے';

  @override
  String get clipboardLinkReady => 'لنک پیسٹ کریں';

  @override
  String get closePlayer => 'پلیئر بند کریں';

  @override
  String get columnAdded => 'شامل کیا گیا';

  @override
  String get columnChannel => 'چینل';

  @override
  String get columnLength => 'لمبائی';

  @override
  String get compactView => 'مختصر منظر';

  @override
  String get compatiblePlayback => 'پلے بیک کی بہترین مطابقت';

  @override
  String get compatiblePlaybackHelp =>
      'H.264/AAC مانگتا ہے، جسے ہر فون ہارڈ ویئر میں ڈی کوڈ کرتا ہے۔ اس کے بغیر YouTube شاید AV1 بھیجے، جو بہت سے آلات پر بگڑی ہوئی تصویر دکھاتا ہے۔ اسے بند کرنے سے مطابقت کی قیمت پر سب سے اونچی ریزولوشن مل سکتی ہے۔';

  @override
  String get completed => 'مکمل';

  @override
  String get continueAsAudio => 'آڈیو کے طور پر جاری رکھیں';

  @override
  String get continueAsAudioBody =>
      'اسے اسی سیکنڈ سے آڈیو کے طور پر چلاتے رہیں؟';

  @override
  String get continueAsAudioNo => 'نہیں، روک دیں';

  @override
  String get continueAsAudioTitle => 'پس منظر میں جاری رکھیں؟';

  @override
  String get cookies => 'کوکیز';

  @override
  String get cookiesNotNetscape =>
      'ان میں سے کسی فائل میں Netscape فارمیٹ کی کوکیز نہیں ہیں';

  @override
  String get cookiesSubtitle =>
      'ان سائٹس کے لیے جو لاگ اِن کے بغیر ڈاؤن لوڈ نہیں ہونے دیتیں';

  @override
  String get copiedToClipboard => 'کلپ بورڈ پر کاپی ہو گیا';

  @override
  String get copyright => '© 2026 Yasir Sagheer';

  @override
  String get couldNotLoadPlaylist =>
      'یہ پلے لسٹ لوڈ نہیں ہو سکی۔ URL اور اپنا کنکشن چیک کریں۔';

  @override
  String get create => 'بنائیں';

  @override
  String get createPlaylist => 'پلے لسٹ بنائیں';

  @override
  String get defaultQuality => 'ویڈیو کی طے شدہ کوالٹی';

  @override
  String get delete => 'حذف کریں';

  @override
  String deleteMultipleConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count کلپس حذف کریں؟\n\nان کی فائلیں آپ کے آلے سے ہٹا دی جائیں گی۔',
      one: '1 کلپ حذف کریں؟\n\nاس کی فائل آپ کے آلے سے ہٹا دی جائے گی۔',
    );
    return '$_temp0';
  }

  @override
  String deletePlaylistConfirm(Object name) {
    return '«$name» حذف کریں؟';
  }

  @override
  String get deleteRefused =>
      'حذف نہیں ہوا: اینڈرائیڈ کو اس فائل کو حذف کرنے کے لیے آپ کی اجازت درکار ہے، اس ڈائیلاگ میں جو وہ دکھاتا ہے۔';

  @override
  String get deleteSelected => 'منتخب حذف کریں';

  @override
  String get deleteTag => 'ٹیگ حذف کریں';

  @override
  String deleteTagConfirm(Object tag) {
    return 'ٹیگ «$tag» تمام آئٹمز سے حذف کریں؟ کلپس خود حذف نہیں ہوں گے۔';
  }

  @override
  String get deleteVideo => 'کلپ حذف کریں';

  @override
  String deleteVideoConfirm(Object title) {
    return '«$title» حذف کریں؟\n\nاس سے فائل آپ کے آلے سے ہٹ جائے گی۔';
  }

  @override
  String deletedCount(Object count) {
    return '$count حذف ہو گئے';
  }

  @override
  String deletedTitle(Object title) {
    return 'حذف ہو گیا: $title';
  }

  @override
  String get deselectAll => 'سب کا انتخاب ختم کریں';

  @override
  String desktopAddLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لنکس شامل کریں',
      one: '1 لنک شامل کریں',
      zero: 'شامل کرنے کو کچھ نہیں',
    );
    return '$_temp0';
  }

  @override
  String get desktopBack => 'واپس';

  @override
  String get desktopBackUpNow => 'ابھی بیک اپ لیں';

  @override
  String get desktopBackupHint =>
      'یہ کمپیوٹر اپنے آخری سات بیک اپ، کم از کم ایک ایک گھنٹے کے فرق سے، Downloads\\VidHoist\\Backups میں رکھتا ہے، جہاں وہ ان انسٹال کے بعد بھی باقی رہتے ہیں۔';

  @override
  String get desktopBackupsNone => 'ابھی کوئی بیک اپ نہیں';

  @override
  String get desktopBrowserButton => 'براؤزر میں «VidHoist میں» بٹن';

  @override
  String get desktopBrowserButtonCopied =>
      'کوڈ کاپی ہو گیا۔ نیا بُک مارک بنائیں اور اسے اس کے پتے (URL) کے طور پر پیسٹ کریں۔';

  @override
  String get desktopBrowserButtonCopy => 'کوڈ کاپی کریں';

  @override
  String get desktopBrowserButtonFailed =>
      'صفحہ نہیں کھل سکا؛ اس کے بجائے کوڈ کاپی کریں۔';

  @override
  String get desktopBrowserButtonHint =>
      'آپ کی بُک مارکس بار پر ایک بٹن: کسی بھی ویڈیو کے صفحے پر ایک کلک یہاں اس کے لنک کے ساتھ شامل کرنے کا ڈائیلاگ کھول دیتا ہے۔ جب تک آپ «شامل کریں» نہ دبائیں، کچھ نہیں بھیجا جاتا۔';

  @override
  String get desktopBrowserButtonName => 'VidHoist میں';

  @override
  String get desktopBrowserButtonOpen => 'سیٹ اپ کا صفحہ کھولیں';

  @override
  String get desktopBrowserPageCopyInstead =>
      'اگر گھسیٹنا کام نہ کرے تو نیا بُک مارک بنائیں اور اسے اس کے پتے کے طور پر پیسٹ کریں:';

  @override
  String get desktopBrowserPageDragHint =>
      'اسے بار پر گھسیٹیں؛ یہاں کلک کرنے سے کچھ نہیں ہوتا۔';

  @override
  String get desktopBrowserPageStep1 =>
      'اگر بُک مارکس بار چھپی ہوئی ہے تو اسے دکھائیں:';

  @override
  String get desktopBrowserPageStep2 =>
      'نیچے والے بٹن کو ماؤس سے بار پر گھسیٹیں۔';

  @override
  String get desktopBrowserPageStep3 =>
      'کسی بھی ویڈیو کے صفحے پر اسے کلک کریں: VidHoist لنک کے ساتھ اپنا شامل کرنے کا ڈائیلاگ کھول دے گا۔ پہلی بار براؤزر پوچھے گا کہ ایپ کھولی جائے یا نہیں؛ اجازت دے دیں۔';

  @override
  String get desktopBrowserPageTitle =>
      'اپنے براؤزر میں «VidHoist میں» بٹن شامل کریں';

  @override
  String get desktopChangeFolder => 'بدلیں…';

  @override
  String get desktopChannel => 'چینل';

  @override
  String get desktopChannelClips => 'آپ کی لائبریری میں';

  @override
  String get desktopChannels => 'چینلز';

  @override
  String get desktopChannelsInLibrary => 'آپ کی لائبریری کے چینلز';

  @override
  String get desktopChannelsLater => 'ڈاؤن لوڈ انجن درکار ہے';

  @override
  String get desktopChannelsLaterBody =>
      'کسی چینل کو فالو کرنے کے لیے اس کمپیوٹر پر yt-dlp درکار ہے۔ اسے ترتیبات › انجن میں سیٹ اپ کریں، اور آپ کے چینلز یہاں نظر آئیں گے۔';

  @override
  String get desktopChapters => 'ابواب';

  @override
  String get desktopCheckAll => 'سب چیک کریں';

  @override
  String get desktopChooseClip => 'منتخب کریں';

  @override
  String get desktopClearFilters => 'فلٹرز صاف کریں';

  @override
  String get desktopClearSelection => 'انتخاب صاف کریں';

  @override
  String get desktopCloseAnyway => 'بند کریں';

  @override
  String desktopCloseBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'اگر آپ ابھی VidHoist بند کریں تو یہ رک جائیں گے اور دوبارہ کھولنے پر وہیں سے جاری ہوں گے۔',
      one: 'اگر آپ ابھی VidHoist بند کریں تو یہ رک جائے گا اور دوبارہ کھولنے پر وہیں سے جاری ہوگا۔',
    );
    return '$_temp0';
  }

  @override
  String get desktopCloseKeep => 'ڈاؤن لوڈ جاری رکھیں';

  @override
  String desktopCloseMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'اور $count مزید',
      one: 'اور 1 مزید',
    );
    return '$_temp0';
  }

  @override
  String desktopCloseTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ڈاؤن لوڈز مکمل نہیں ہوئے',
      one: 'ایک ڈاؤن لوڈ مکمل نہیں ہوا',
    );
    return '$_temp0';
  }

  @override
  String get desktopCookiesBrowser => 'براؤزر سے';

  @override
  String get desktopCookiesBrowserHint =>
      'اس براؤزر سے پڑھی جاتی ہیں جس میں آپ سائن ان ہیں۔ اگر یہ پڑھی نہ جا سکیں تو وہ براؤزر بند کر کے دوبارہ کوشش کریں۔';

  @override
  String get desktopCookiesChoose => 'فائل منتخب کریں…';

  @override
  String get desktopCookiesFile => 'کوکیز فائل';

  @override
  String get desktopCookiesHelp =>
      'اپنے براؤزر میں ایسی ایکسٹینشن استعمال کریں جو کوکیز کو Netscape فارمیٹ میں ایکسپورٹ کرے (ہر سائٹ کی ایک فائل)، اور یہاں تمام فائلیں ایک ساتھ منتخب کریں۔ پھر yt-dlp انہیں ہر ڈاؤن لوڈ کے لیے استعمال کرتا ہے۔ کوکیز کی میعاد ختم ہو جاتی ہے، اس لیے اگر کوئی ڈاؤن لوڈ پھر ناکام ہونے لگے تو عموماً نئی ایکسپورٹ کا وقت آ گیا ہوتا ہے۔';

  @override
  String get desktopCookiesKept => 'اس کمپیوٹر پر محفوظ کوکیز';

  @override
  String desktopCookiesKeptFor(String sites) {
    return 'ان کے لیے محفوظ کوکیز: $sites';
  }

  @override
  String get desktopCookiesLocalHint =>
      'ان سائٹس کے لیے جہاں سائن ان ہونا ضروری ہے۔ yt-dlp انہیں اسی کمپیوٹر پر پڑھتا ہے، اور یہ کہیں اور نہیں جاتیں۔';

  @override
  String get desktopCookiesNone => 'کوئی نہیں';

  @override
  String get desktopCookiesRemove => 'ہٹائیں';

  @override
  String get desktopCopiedLinkAdd => 'شامل کریں…';

  @override
  String get desktopCopiedLinkTitle => 'یہ لنک ڈاؤن لوڈ کریں؟';

  @override
  String get desktopCopyFile => 'فائل کاپی کریں';

  @override
  String get desktopCopyFileFailed => 'فائل کاپی نہیں ہو سکی';

  @override
  String get desktopCopyLink => 'لنک کاپی کریں';

  @override
  String get desktopCopyOneClip => 'کاپی ایک وقت میں ایک ہی کلپ کی ہوتی ہے';

  @override
  String get desktopCopyQuote => 'وقت اور لنک کے ساتھ کاپی کریں';

  @override
  String get desktopDefaultQualityHint =>
      'ہر اضافہ اسی سے شروع ہوتا ہے؛ آپ پھر بھی ہر لنک کے لیے اسے بدل سکتے ہیں۔';

  @override
  String desktopDeleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count کلپس حذف کریں؟ اس کمپیوٹر پر ان کی فائلیں حذف ہو جائیں گی۔',
      one: '1 کلپ حذف کریں؟ اس کمپیوٹر پر اس کی فائل حذف ہو جائے گی۔',
    );
    return '$_temp0';
  }

  @override
  String get desktopDesktopSection => 'Windows';

  @override
  String get desktopDiscover => 'VidHoist کو دریافت کریں';

  @override
  String get desktopDiscoverAddLink => 'لنک پیسٹ کریں یا چھوڑیں';

  @override
  String get desktopDiscoverAddLinkLine =>
      'شامل کرنے کے لیے کہیں بھی Ctrl+V دبائیں، یا لنک کو ونڈو پر چھوڑ دیں۔';

  @override
  String get desktopDiscoverAdding => 'شامل کرنا اور شیئر کرنا';

  @override
  String get desktopDiscoverBrowser => 'براؤزر سے';

  @override
  String get desktopDiscoverBrowserLine =>
      'آپ کی بُک مارکس بار پر «VidHoist میں» بٹن موجودہ صفحے کے ساتھ شامل کرنے کا ڈائیلاگ کھول دیتا ہے۔';

  @override
  String get desktopDiscoverChapters => 'ابواب';

  @override
  String get desktopDiscoverChaptersLine =>
      'کلپ کے حصے، اس کے ٹرانسکرپٹ سے، اس کے صفحے پر۔';

  @override
  String get desktopDiscoverChoose => 'کئی منتخب کریں';

  @override
  String get desktopDiscoverChooseLine =>
      'گول نشان، یا کلک کے ساتھ Ctrl یا Shift؛ پھر انہیں کسی فہرست میں شامل کریں یا ایک ساتھ حذف کریں۔';

  @override
  String get desktopDiscoverDragOut => 'کلپ باہر گھسیٹیں';

  @override
  String get desktopDiscoverDragOutLine =>
      'اسے کسی فولڈر یا دوسری ایپ پر چھوڑیں، اور وہ وہاں فائل کی صورت میں پہنچ جائے گا۔';

  @override
  String get desktopDiscoverExport => 'ٹرانسکرپٹ ایکسپورٹ کریں';

  @override
  String get desktopDiscoverExportLine =>
      'متن کے طور پر، یا کسی دوسرے پلیئر کے لیے SRT سب ٹائٹلز کے طور پر۔';

  @override
  String get desktopDiscoverHint =>
      'ایپ جو کچھ کر سکتی ہے، ہر چیز ایک سطر میں، اس کی کیز کے ساتھ۔';

  @override
  String get desktopDiscoverLibrary => 'لائبریری';

  @override
  String get desktopDiscoverListening =>
      'آواز کے لیے: ایک پُرسکون کمرہ جس میں کور بڑا ہو، پوری اسکرین پر۔';

  @override
  String get desktopDiscoverMini => 'چھوٹی ونڈو';

  @override
  String get desktopDiscoverMiniLine =>
      'ہر دوسری ونڈو کے اوپر ایک چھوٹا کارڈ، اسکرین کے نچلے کونے میں۔';

  @override
  String get desktopDiscoverReading =>
      'ٹرانسکرپٹ ایک مضمون کی طرح: کسی جملے پر کلک کریں اور وہیں سے سنیں۔';

  @override
  String get desktopDiscoverSaid => 'جو کہا گیا';

  @override
  String get desktopDiscoverSearch => 'جو کہا گیا اس میں تلاش کریں';

  @override
  String get desktopDiscoverSearchLine =>
      'وہ کلپس ڈھونڈیں جن میں کوئی لفظ بولا گیا، صرف عنوانات میں نہیں۔';

  @override
  String get desktopDiscoverShortcutsLine =>
      'ہر کی جس کا ونڈو جواب دیتی ہے، ایک ہی شیٹ پر۔';

  @override
  String get desktopDiscoverShow => 'دکھائیں';

  @override
  String get desktopDiscoverStatsLine =>
      'لائبریری کا شمار: سائٹ، چینل اور مہینے کے لحاظ سے۔';

  @override
  String get desktopDiscoverSubtitles =>
      'تصویر پر ٹرانسکرپٹ، بولا جانے والا لفظ نمایاں۔';

  @override
  String get desktopDiscoverTheater =>
      'بڑی تصویر جو سائیڈ پینل کی جگہ لے لیتی ہے۔';

  @override
  String get desktopDiscoverTry => 'آزمائیں';

  @override
  String get desktopDiscoverWatching => 'دیکھنا اور سننا';

  @override
  String get desktopDownloadFolder => 'ڈاؤن لوڈ فولڈر';

  @override
  String get desktopDownloadFolderHint =>
      'ڈاؤن لوڈز یہاں عام فائلوں کی طرح محفوظ ہوتے ہیں، جنہیں کسی بھی دوسری فائل کی طرح کھولا، منتقل کیا یا بیک اپ کیا جا سکتا ہے۔';

  @override
  String get desktopDownloads => 'ڈاؤن لوڈز';

  @override
  String get desktopDownloadsEmpty =>
      'کچھ ڈاؤن لوڈ نہیں ہو رہا۔ شروع کرنے کے لیے لنک شامل کریں۔';

  @override
  String get desktopDownloadsRunning => 'جاری';

  @override
  String get desktopDragToReorder => 'ترتیب بدلنے کے لیے گھسیٹیں';

  @override
  String get desktopDropLinks => 'شامل کرنے کے لیے چھوڑیں';

  @override
  String get desktopEmptyLibraryMessage =>
      'لنک شامل کریں، اور ڈاؤن لوڈ ہوتے ہی کلپ یہاں نظر آئے گا۔';

  @override
  String get desktopEngine => 'انجن';

  @override
  String get desktopEngineDenoHint =>
      'YouTube کی جانچ کا جواب دیتا ہے، تاکہ اس کی پیش کردہ ہر کوالٹی ڈاؤن لوڈ ہو سکے';

  @override
  String get desktopEngineFetch => 'حاصل کریں';

  @override
  String get desktopEngineFetchCorrupt =>
      'جو فائل پہنچی وہ شائع شدہ فائل نہیں تھی، اس لیے استعمال نہیں کی گئی۔';

  @override
  String get desktopEngineFetchFailed =>
      'حاصل نہیں ہو سکا۔ کنکشن چیک کر کے دوبارہ کوشش کریں۔';

  @override
  String get desktopEngineFetchInUse =>
      'ایک ڈاؤن لوڈ اسے استعمال کر رہا ہے۔ اس کے ختم ہونے پر دوبارہ کوشش کریں۔';

  @override
  String desktopEngineFetching(int percent) {
    return 'حاصل کیا جا رہا ہے · $percent%';
  }

  @override
  String get desktopEngineFfmpegHint =>
      'تصویر اور آواز کو جوڑتا ہے، اور آڈیو کو تبدیل کرتا ہے';

  @override
  String get desktopEngineIpv4 => 'صرف IPv4 استعمال کریں';

  @override
  String get desktopEngineIpv4Hint =>
      'جہاں IPv6 خراب ہو، جیسا کہ بہت سے گھریلو نیٹ ورکس پر، وہاں کہیں زیادہ تیز۔ اسے صرف تب بند کریں جب آپ کے نیٹ ورک پر صرف IPv6 ہو۔';

  @override
  String get desktopEngineMissing =>
      'yt-dlp اس کمپیوٹر پر نہیں ہے۔ VidHoist دوبارہ انسٹال کریں، یا اسے یہاں سے حاصل کریں۔';

  @override
  String get desktopEngineOnFirstUse =>
      'پہلے ایسے ڈاؤن لوڈ پر حاصل کیا جاتا ہے جسے اس کی ضرورت ہو';

  @override
  String get desktopEngineUpToDate => 'yt-dlp تازہ ترین ہے';

  @override
  String get desktopEngineUpdate => 'yt-dlp اپ ڈیٹ کریں';

  @override
  String get desktopEngineUpdateFailed =>
      'اپ ڈیٹ مکمل نہیں ہو سکی۔ بعد میں دوبارہ کوشش کریں۔';

  @override
  String get desktopEngineUpdateHint =>
      'سائٹس اکثر بدلتی رہتی ہیں؛ پرانا yt-dlp چند مہینوں میں کام کرنا چھوڑ دیتا ہے۔';

  @override
  String desktopEngineUpdated(String version) {
    return 'yt-dlp اب $version ہے';
  }

  @override
  String get desktopEngineUpdating => 'اپ ڈیٹ ہو رہا ہے…';

  @override
  String desktopEngineVersion(String version) {
    return 'ورژن $version';
  }

  @override
  String get desktopEngineYtDlpHint => 'لنک کو پڑھتا ہے اور ڈاؤن لوڈ کرتا ہے';

  @override
  String get desktopExport => 'ایکسپورٹ کریں';

  @override
  String get desktopExportForPhone => 'فون کے لیے ایکسپورٹ کریں';

  @override
  String get desktopExportForPhoneHint =>
      'اس کمپیوٹر کے ٹیگز، فہرستیں اور دوبارہ شروع کرنے کے مقامات، اور اس کے ٹرانسکرپٹس، دو فائلوں کی صورت میں محفوظ کرتا ہے جنہیں فون بحال کرتا ہے۔ فون پر بحال کرنے سے اس کے اپنے ٹیگز اور فہرستیں بدل جاتی ہیں۔';

  @override
  String get desktopExportMarkdown => 'متن (Markdown)';

  @override
  String get desktopExportPdf => 'دستاویز (PDF)';

  @override
  String get desktopExportPhone => 'فون کے لیے (VidHoist امپورٹ)';

  @override
  String get desktopExportSrt => 'سب ٹائٹلز (SRT)';

  @override
  String desktopExported(String name) {
    return '$name محفوظ ہو گئی';
  }

  @override
  String desktopFileReadyToPaste(String name, String size) {
    return 'پیسٹ کے لیے تیار: $name · $size';
  }

  @override
  String get desktopFirstLinkKeys => 'ونڈو میں کہیں بھی یہی کام کرتا ہے';

  @override
  String get desktopFirstLinkNote =>
      'یوٹیوب یا کسی بھی دوسری سائٹ سے۔ ڈاؤن لوڈ شروع ہوتے ہی کلپ یہاں نظر آئے گا۔';

  @override
  String get desktopFirstLinkPaste => 'پیسٹ';

  @override
  String get desktopFirstLinkTitle => 'اپنا پہلا لنک پیسٹ کریں';

  @override
  String get desktopFolderUnavailable => 'کوئی فولڈر دستیاب نہیں';

  @override
  String get desktopFolders => 'فولڈرز';

  @override
  String get desktopForward => 'آگے';

  @override
  String get desktopGlobalShortcut => 'کسی بھی ایپ سے چلائیں اور روکیں';

  @override
  String desktopGlobalShortcutHint(String keys) {
    return 'جب ونڈو دوسری ایپس کے پیچھے ہو تو $keys چلاتا اور روکتا ہے۔';
  }

  @override
  String desktopGlobalShortcutTaken(String keys) {
    return 'کوئی دوسری ایپ پہلے سے $keys استعمال کر رہی ہے۔';
  }

  @override
  String get desktopHidePanel => 'سائیڈ پینل چھپائیں';

  @override
  String get desktopHintShortcuts =>
      'کی بورڈ شارٹ کٹس کے لیے ? دبائیں۔ Space چلاتا اور روکتا ہے؛ تیر والی کیز آگے پیچھے کرتی ہیں۔';

  @override
  String get desktopHintShortcutsAction => 'شارٹ کٹس';

  @override
  String get desktopHintTrayBody =>
      'یہ گھڑی کے پاس اپنے آئیکن سے چلتی رہتی ہے۔ بند کرنے کے لیے آئیکن پر رائٹ کلک کریں۔';

  @override
  String get desktopHintTrayTitle => 'VidHoist ابھی چل رہی ہے';

  @override
  String get desktopHints => 'مشورے دکھائیں';

  @override
  String get desktopHintsAgain => 'انہیں دوبارہ دکھائیں';

  @override
  String get desktopHintsHint =>
      'دو مختصر مشورے، ہر ایک صرف ایک بار: پہلے کلپ پر شارٹ کٹس، اور پہلی بار بند کرنے پر گھڑی کے پاس والا آئیکن۔';

  @override
  String get desktopImportFromPhone => 'بیک اپ یا ٹرانسکرپٹس امپورٹ کریں…';

  @override
  String get desktopImportHint =>
      'VidHoist کی بیک اپ یا ٹرانسکرپٹس فائل، جو یہاں منتخب کی جائے یا ونڈو پر چھوڑی جائے۔ فون کی فائل یہاں موجود چیزوں میں شامل کی جاتی ہے؛ اس کمپیوٹر کا بیک اپ پوچھنے کے بعد پورا بحال کیا جاتا ہے۔';

  @override
  String desktopImportedBackup(int tagged, int lists, int positions) {
    return 'فون سے شامل کیا گیا۔ ٹیگز: $tagged · فہرستیں: $lists · دوبارہ شروع کرنے کے مقامات: $positions';
  }

  @override
  String get desktopImportedNothing =>
      'کچھ نیا نہیں: اس کمپیوٹر پر یہ سب پہلے سے موجود تھا۔';

  @override
  String desktopImportedTranscripts(int count) {
    return 'شامل کیے گئے ٹرانسکرپٹس: $count';
  }

  @override
  String desktopInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'آپ کی لائبریری میں $count',
      one: 'آپ کی لائبریری میں 1',
    );
    return '$_temp0';
  }

  @override
  String get desktopKeepAwake => 'ڈاؤن لوڈ کے دوران کمپیوٹر کو جاگتا رکھیں';

  @override
  String get desktopKeepAwakeHint =>
      'تاکہ فون سے بھیجا گیا لنک، یا لمبی پلے لسٹ، Windows کے سلیپ میں جانے پر رکنے کے بجائے مکمل ہو جائے۔ اسکرین پھر بھی معمول کے مطابق بند ہوتی ہے۔';

  @override
  String get desktopKeyAddLink => 'کاپی کیا ہوا لنک شامل کریں';

  @override
  String get desktopKeyFavorite => 'پسندیدہ میں شامل کریں یا ہٹائیں';

  @override
  String get desktopKeyFullScreen => 'پوری اسکرین؛ آواز کے لیے، سننے کا کمرہ';

  @override
  String get desktopKeyMenu => 'کلپ کا مینو';

  @override
  String get desktopKeyMini => 'دوسری ونڈوز کے اوپر چھوٹی ونڈو، اور واپس';

  @override
  String get desktopKeyPlayPause => 'چلائیں یا روکیں';

  @override
  String get desktopKeyRepeat => 'دہرانا بدلیں';

  @override
  String get desktopKeySearch => 'عنوانات اور جو کہا گیا اس میں تلاش کریں';

  @override
  String get desktopKeySeek => '10 سیکنڈ پیچھے یا آگے';

  @override
  String get desktopKeyShortcuts => 'یہ فہرست';

  @override
  String get desktopKeyVolume =>
      'آواز اونچی یا دھیمی؛ شارٹس میں، پچھلی یا اگلی';

  @override
  String get desktopKeyZoomIn => 'بڑا انٹرفیس';

  @override
  String get desktopKeyZoomOut => 'چھوٹا انٹرفیس';

  @override
  String get desktopKeyZoomReset => 'انٹرفیس معمول کے سائز پر';

  @override
  String get desktopLanguageSystemHint => 'Windows کی زبان کی پیروی کرتی ہے۔';

  @override
  String desktopLastArrival(String when) {
    return 'آخری آمد $when';
  }

  @override
  String get desktopLess => 'کم';

  @override
  String desktopLibraryDownloading(int count) {
    return '$count ڈاؤن لوڈ ہو رہے ہیں';
  }

  @override
  String get desktopLibraryLoading => 'لائبریری لوڈ ہو رہی ہے…';

  @override
  String get desktopLinkCopied => 'لنک کاپی ہو گیا';

  @override
  String get desktopLinkDuplicate => 'اوپر دہرایا گیا';

  @override
  String get desktopLinkInLibrary => 'پہلے سے آپ کی لائبریری میں ہے';

  @override
  String get desktopLinkPlaylist => 'ایک پلے لسٹ: اس کے کلپس منتخب کریں';

  @override
  String get desktopLinkReady => 'تیار';

  @override
  String get desktopLinkUnsupported => 'ایسی سائٹ جسے یہ ایپ نہیں جانتی';

  @override
  String desktopLinksDropped(int count, int limit) {
    return 'صرف پہلے $limit لنکس لیے گئے ہیں؛ مزید $count چھوڑ دیے گئے۔';
  }

  @override
  String desktopLinksFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لنکس',
      one: '1 لنک',
    );
    return '$_temp0';
  }

  @override
  String get desktopListeningClose => 'سننے کا کمرہ بند کریں';

  @override
  String get desktopListeningRoom => 'سننے کا کمرہ';

  @override
  String get desktopLogsCopied => 'لاگ کاپی ہو گیا، لنکس یا پتوں کے بغیر';

  @override
  String get desktopLogsCopy => 'کاپی کریں';

  @override
  String get desktopLogsSave => 'فائل میں محفوظ کریں';

  @override
  String get desktopMiniRestore => 'پوری ونڈو پر واپس';

  @override
  String get desktopMiniWindow => 'چھوٹی ونڈو';

  @override
  String get desktopMore => 'مزید';

  @override
  String get desktopNarrowSidebar => 'سائیڈبار سمیٹیں';

  @override
  String get desktopNoChannelNames =>
      'آپ کی لائبریری کے کلپس اپنے چینل کا نام نہیں بتاتے، اس لیے اس چینل کے کلپس الگ نہیں کیے جا سکتے۔ اسے اس کے اپنے فولڈر کے ساتھ فالو کریں، اور وہاں جو کچھ آئے گا وہ یہاں نظر آئے گا۔';

  @override
  String get desktopNoFavoritesMessage =>
      'کسی کلپ کو پسندیدہ کے طور پر نشان زد کریں اور وہ یہاں آپ کا منتظر رہے گا۔';

  @override
  String get desktopNoFavoritesTitle => 'ابھی کوئی پسندیدہ نہیں';

  @override
  String get desktopNoMatchMessage => 'مزید دیکھنے کے لیے کوئی فلٹر صاف کریں۔';

  @override
  String get desktopNoMatchTitle => 'ان فلٹرز سے کچھ نہیں ملتا';

  @override
  String get desktopNoTags =>
      'ابھی کوئی ٹیگ نہیں۔ کسی کلپ کو اس کے صفحے سے ٹیگ کریں اور وہ یہاں نظر آئے گا۔';

  @override
  String get desktopNoTranscriptMessage =>
      'کلپ کے ساتھ اس کے سب ٹائٹلز ڈاؤن لوڈ ہوتے ہی یہ یہاں نظر آئے گا۔';

  @override
  String get desktopNoTranscriptTitle => 'اس کلپ کا کوئی ٹرانسکرپٹ نہیں';

  @override
  String get desktopNotABackup =>
      'یہ فائل VidHoist کی بیک اپ یا ٹرانسکرپٹس فائل نہیں ہے۔';

  @override
  String desktopNotWatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نہیں دیکھے گئے',
      one: '1 نہیں دیکھا گیا',
    );
    return '$_temp0';
  }

  @override
  String get desktopNothingPlaying => 'کچھ نہیں چل رہا';

  @override
  String get desktopNothingPlayingHint =>
      'کوئی کلپ چلائیں اور اس کا ٹرانسکرپٹ، اس کے بعد آنے والا اور اس کی تفصیلات یہاں نظر آئیں گی۔';

  @override
  String get desktopNotifyArrivalsHint =>
      'جب آپ کے فالو کیے گئے چینلز کے نئے کلپس ڈاؤن لوڈ ہوں تو Windows کی اطلاع۔';

  @override
  String get desktopOfferCopiedLinks => 'میرے کاپی کیے گئے لنکس پیش کریں';

  @override
  String get desktopOfferCopiedLinksHint =>
      'جب آپ کسی دوسری ایپ میں ویڈیو کا لنک کاپی کرتے ہیں تو ایک اطلاع اسے شامل کرنے کی پیشکش کرتی ہے۔ صرف لنکس دیکھے جاتے ہیں، اور کوئی محفوظ نہیں کیا جاتا۔';

  @override
  String get desktopOpenBackup => 'بیک اپ کھولیں';

  @override
  String get desktopOpenChannels => 'چینلز کھولیں';

  @override
  String get desktopOpenInExplorer => 'Explorer میں کھولیں';

  @override
  String get desktopOpenWith => 'کسی دوسرے پلیئر میں کھولیں…';

  @override
  String get desktopPaletteClose => 'بند کرنے کے لیے';

  @override
  String get desktopPaletteCommands => 'کمانڈز';

  @override
  String get desktopPaletteHint =>
      'عنوانات اور جو کہا گیا اس میں تلاش کریں، یا کمانڈز کے لیے > لکھیں';

  @override
  String desktopPaletteList(String name) {
    return 'فہرست: $name';
  }

  @override
  String get desktopPaletteMove => 'حرکت کے لیے';

  @override
  String get desktopPaletteOpen => 'کھولنے کے لیے';

  @override
  String get desktopPaletteRecent => 'حال ہی میں چلائے گئے';

  @override
  String get desktopPaletteSaid => 'کلپس کے اندر کہا گیا';

  @override
  String get desktopPaletteSave => 'یہ تلاش محفوظ کریں';

  @override
  String get desktopPaletteSaved => 'محفوظ تلاشیں';

  @override
  String desktopPaletteSettings(String section) {
    return 'ترتیبات: $section';
  }

  @override
  String get desktopPaletteTitles => 'عنوانات';

  @override
  String get desktopPinned => 'پن کیے گئے';

  @override
  String get desktopPlayNext => 'اگلا چلائیں';

  @override
  String get desktopPlaysNext => 'اس کے بعد اگلا چلے گا';

  @override
  String get desktopQueueEnd => 'اس کے بعد کچھ نہیں';

  @override
  String desktopQuote(String text, String title, String time, String link) {
    return '«$text»\n— $title، $time\n$link';
  }

  @override
  String get desktopQuoteCopied => 'اپنے وقت اور لنک کے ساتھ کاپی ہو گیا';

  @override
  String get desktopReadingBack => 'کلپ پر واپس';

  @override
  String get desktopReadingCloseFind => 'تلاش بند کریں';

  @override
  String get desktopReadingFind => 'متن میں تلاش کریں';

  @override
  String desktopReadingFound(int at, int count) {
    return '$count میں سے $at';
  }

  @override
  String get desktopReadingHint =>
      'کسی جملے پر کلک کریں اور وہیں سے سنیں · Ctrl+F سے لفظ تلاش کریں · وقت کے ساتھ کاپی کرنے کے لیے منتخب کریں';

  @override
  String get desktopReadingNextMatch => 'اگلا نتیجہ';

  @override
  String get desktopReadingPreviousMatch => 'پچھلا نتیجہ';

  @override
  String get desktopReadingRoom => 'پڑھنے کا کمرہ';

  @override
  String get desktopRecoverLibrary => 'فولڈر میں پہلے سے موجود کلپس';

  @override
  String get desktopRecoverLibraryAction => 'فولڈر میں دیکھیں';

  @override
  String get desktopRecoverLibraryHint =>
      'دوبارہ انسٹال کرنے کے بعد: وہ کلپس لائبریری میں واپس لاتا ہے جو ڈاؤن لوڈ فولڈر میں ہیں لیکن اب فہرست میں نہیں۔ فائلوں کو نہیں چھیڑا جاتا۔';

  @override
  String desktopRecovered(int count) {
    return 'لائبریری میں واپس لائے گئے: $count';
  }

  @override
  String get desktopRecoveredNothing =>
      'شامل کرنے کو کچھ نہیں: فولڈر کا ہر کلپ لائبریری میں ہے۔';

  @override
  String desktopRecoveredSome(int count, int left) {
    return 'لائبریری میں واپس لائے گئے: $count۔ چھوڑ دیے گئے، ان کا لنک نامعلوم: $left';
  }

  @override
  String get desktopRemoveFromList => 'فہرست سے ہٹائیں';

  @override
  String get desktopRestore => 'بحال کریں';

  @override
  String get desktopRestoreBody =>
      'اس کمپیوٹر کی لائبریری، فالو کیے گئے چینلز، ٹیگز، فہرستیں اور ترتیبات وہی ہو جائیں گی جو بیک اپ میں ہیں۔ ڈاؤن لوڈ کی گئی فائلوں کو نہیں چھیڑا جاتا۔';

  @override
  String desktopRestoreOfferBody(String when) {
    return 'Downloads\\VidHoist\\Backups میں اس کمپیوٹر کا ایک بیک اپ ہے: اس کی لائبریری، فالو کیے گئے چینلز، پلے لسٹس، ٹیگز، ترتیبات اور محفوظ ٹرانسکرپٹس۔ سب سے نیا $when بنایا گیا تھا۔ دونوں صورتوں میں آپ کی ڈاؤن لوڈ کی گئی فائلوں کو نہیں چھیڑا جاتا۔';
  }

  @override
  String get desktopRestoreOfferTitle => 'اپنا بیک اپ بحال کریں؟';

  @override
  String get desktopRestoreTitle => 'یہ بیک اپ بحال کریں؟';

  @override
  String get desktopRestored => 'بیک اپ بحال ہو گیا';

  @override
  String get desktopRevealAfterDownload => 'مکمل ہونے پر Explorer میں دکھائیں';

  @override
  String get desktopRevealAfterDownloadHint =>
      'جب اس کمپیوٹر پر کوئی فائل ڈاؤن لوڈ ہو جائے تو اس کا فولڈر فائل منتخب حالت میں کھل جاتا ہے۔';

  @override
  String desktopSavedIn(String folder) {
    return '$folder میں محفوظ';
  }

  @override
  String desktopSavedSearchDelete(String name) {
    return 'محفوظ تلاش «$name» حذف کریں؟ لائبریری میں کچھ نہیں بدلے گا۔';
  }

  @override
  String get desktopSavedSearchName => 'تلاش کا نام';

  @override
  String get desktopSearch => 'تلاش';

  @override
  String get desktopSearchHint => 'عنوانات اور جو کہا گیا اس میں تلاش کریں…';

  @override
  String get desktopSearchSaved => 'سائیڈبار میں محفوظ';

  @override
  String get desktopSeekBar => 'کلپ میں مقام';

  @override
  String desktopSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منتخب',
      one: '1 منتخب',
    );
    return '$_temp0';
  }

  @override
  String get desktopSetupChooseFile => 'فائل منتخب کریں…';

  @override
  String get desktopShortcutsApp => 'ایپ';

  @override
  String get desktopShortcutsClip => 'منتخب کلپ پر';

  @override
  String get desktopShortcutsPlayback => 'چلانا';

  @override
  String get desktopShortcutsTitle => 'کی بورڈ شارٹ کٹس';

  @override
  String get desktopShortcutsWindow => 'ونڈو';

  @override
  String get desktopShortsHint =>
      'اگلے شارٹ کے لیے ↑ ↓ یا وہیل · پسندیدہ کے لیے ڈبل کلک';

  @override
  String get desktopShowInFolder => 'فولڈر میں دکھائیں';

  @override
  String get desktopShowPanel => 'سائیڈ پینل دکھائیں';

  @override
  String get desktopStartFresh => 'نئے سرے سے شروع کریں';

  @override
  String get desktopStartWithWindows => 'Windows کے ساتھ شروع کریں';

  @override
  String get desktopStartWithWindowsHint =>
      'آپ کے سائن ان کرنے پر کھلتی ہے: اگر وہاں چلتی رہتی ہے تو ٹرے میں، ورنہ چھوٹی حالت میں۔';

  @override
  String get desktopStartWithWindowsRefused =>
      'Windows نے ایپ کو اپنے ساتھ شروع ہونے نہیں دیا۔';

  @override
  String get desktopStats => 'لائبریری کے اعداد و شمار';

  @override
  String get desktopStatsByChannel => 'چینل کے لحاظ سے';

  @override
  String get desktopStatsByMonth => 'شامل کرنے کے مہینے کے لحاظ سے';

  @override
  String get desktopStatsBySite => 'سائٹ کے لحاظ سے';

  @override
  String get desktopStatsClips => 'کلپس';

  @override
  String get desktopStatsHint =>
      'لائبریری میں کیا ہے، اور کس چیز پر نظر ڈالنا مناسب ہو سکتا ہے۔ یہاں سے کچھ حذف نہیں ہوتا۔';

  @override
  String desktopStatsHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count گھنٹے',
      one: '1 گھنٹہ',
      zero: 'ایک گھنٹے سے کم',
    );
    return '$_temp0';
  }

  @override
  String get desktopStatsLargest => 'سب سے بڑے:';

  @override
  String get desktopStatsLength => 'کل دورانیہ';

  @override
  String get desktopStatsLink => 'اعداد و شمار';

  @override
  String get desktopStatsNeverPlayed => 'یہاں کبھی نہیں چلائے گئے';

  @override
  String get desktopStatsNewest => 'سب سے نئے:';

  @override
  String get desktopStatsOtherChannels => 'دوسرے چینلز';

  @override
  String get desktopStatsRoom => 'گھیری گئی جگہ';

  @override
  String get desktopStatsUnnamed => 'کسی چینل کا نام نہیں';

  @override
  String get desktopStatsWithText => 'ٹرانسکرپٹ کے ساتھ';

  @override
  String get desktopStatsWithoutText => 'ٹرانسکرپٹ کے بغیر';

  @override
  String get desktopStatsWorthALook => 'دیکھنے کے لائق';

  @override
  String get desktopSubtitleOptions => 'سب ٹائٹل کے اختیارات';

  @override
  String get desktopTheater => 'تھیٹر';

  @override
  String get desktopTranscriptFirst => 'پہلے اس کا ٹرانسکرپٹ حاصل کریں';

  @override
  String get desktopTranscriptHint =>
      'پلے بیک کے ساتھ چلتا ہے · جانے کے لیے کسی سطر پر کلک کریں';

  @override
  String get desktopTranscriptHintPage =>
      'اس کلپ کا ٹرانسکرپٹ · وہیں سے چلانے کے لیے کسی سطر پر کلک کریں';

  @override
  String get desktopTranscriptsDeleteBody =>
      'یہ اس کمپیوٹر اور اس کے بیک اپ سے ہٹا دیے جاتے ہیں۔ صرف آپ کی ایکسپورٹ کی ہوئی فائل ہی انہیں واپس لا سکتی ہے۔';

  @override
  String get desktopTranscriptsHelp =>
      'VidHoist آپ کے شامل کیے گئے ہر YouTube کلپ میں کہے گئے الفاظ محفوظ رکھتی ہے، تاکہ تلاش (Ctrl+K) صرف عنوانات ہی نہیں بلکہ آپ کے کلپس کے اندر کہی گئی باتیں بھی ڈھونڈ لے۔ یہ اسی کمپیوٹر پر رہتے ہیں۔';

  @override
  String get desktopTranscriptsMove => 'فون سے یا فون پر';

  @override
  String get desktopTranscriptsMoveHint =>
      'ٹرانسکرپٹس بیک اپ کے ساتھ جاتے ہیں: «فون کے لیے ایکسپورٹ کریں» انہیں لے جاتا ہے، اور وہاں «امپورٹ» انہیں لے آتا ہے، اور جو یہاں موجود نہیں وہ شامل کر دیتا ہے۔';

  @override
  String get desktopTrayOnClose => 'ونڈو بند ہونے پر ٹرے میں چلتی رہے';

  @override
  String get desktopTrayOnCloseHint =>
      'ونڈو بند کرنے سے آواز چلتی رہتی ہے؛ گھڑی کے پاس والے آئیکن سے بند کریں۔';

  @override
  String get desktopTrayOpen => 'VidHoist کھولیں';

  @override
  String get desktopTrayQuit => 'بند کریں';

  @override
  String get desktopUiSize => 'انٹرفیس کا سائز';

  @override
  String desktopUiSizeHint(String bigger, String smaller, String reset) {
    return '$bigger اور $smaller اسے کہیں سے بھی بدلتے ہیں، اور $reset اسے 100% پر واپس لاتا ہے۔';
  }

  @override
  String get desktopUiSizeTooLarge => 'اس اسکرین کے لیے بہت بڑا';

  @override
  String get desktopUpdateInstall => 'انسٹال کر کے دوبارہ شروع کریں';

  @override
  String get desktopUpdateRestartHint =>
      'VidHoist بند ہو کر اپ ڈیٹ انسٹال کرتی ہے اور دوبارہ کھل جاتی ہے۔ آپ کی ترتیبات اور لائبریری جوں کی توں رہتی ہیں۔';

  @override
  String get desktopViewCompact => 'مختصر';

  @override
  String get desktopViewTable => 'جدول';

  @override
  String get desktopVolume => 'آواز';

  @override
  String desktopVolumeLevel(int percent) {
    return 'آواز $percent%';
  }

  @override
  String get desktopWelcomeFetchNow => 'انہیں ابھی حاصل کریں';

  @override
  String get desktopWelcomeHelpers =>
      'ffmpeg (تصویر اور آواز جوڑتا ہے) اور Deno (YouTube کو درکار) پہلے ڈاؤن لوڈ پر خود بخود آ جاتے ہیں، تقریباً 160 MB۔ آپ چاہیں تو انہیں ابھی حاصل کر سکتے ہیں۔';

  @override
  String get desktopWelcomeMessage =>
      'YouTube یا کسی دوسری سائٹ کا لنک پیسٹ کریں، اور VidHoist اسے yt-dlp کے ذریعے اس کمپیوٹر پر ڈاؤن لوڈ کر دے گی۔';

  @override
  String get desktopWelcomeStart => 'شروع کریں';

  @override
  String get desktopWelcomeTitle => 'VidHoist میں خوش آمدید';

  @override
  String get desktopWhatsNewAllFeatures => 'VidHoist جو کچھ کر سکتی ہے';

  @override
  String get desktopWidenSidebar => 'سائیڈبار پھیلائیں';

  @override
  String get desktopWindowClose => 'بند کریں';

  @override
  String get desktopWindowMaximize => 'بڑا کریں';

  @override
  String get desktopWindowMinimize => 'چھوٹا کریں';

  @override
  String get desktopWindowRestore => 'پہلے سائز پر لائیں';

  @override
  String get desktopZoomChange => 'بدلیں';

  @override
  String desktopZoomLowered(String percent) {
    return 'انٹرفیس اب $percent ہے تاکہ اس اسکرین پر پورا آ جائے۔';
  }

  @override
  String get details => 'تفصیلات';

  @override
  String get developer => 'ڈیولپر';

  @override
  String get developerName => 'Yasir Sagheer';

  @override
  String get diagnosticLogs => 'تشخیصی لاگز';

  @override
  String get diagnosticLogsSubtitle =>
      'ایپ لاگز دیکھیں، تلاش کریں اور شیئر کریں (حساس معلومات کے بغیر)';

  @override
  String get disclaimer => 'دستبرداری';

  @override
  String get disclaimerText =>
      'یہ ایپ yt-dlp کے ذریعے میڈیا ڈاؤن لوڈ کرتی ہے۔ صارفین اس ٹول کو کیسے استعمال کرتے ہیں، اس کی ذمہ داری ڈیولپر پر نہیں۔ براہ کرم کاپی رائٹ قوانین اور جن سائٹس سے آپ ڈاؤن لوڈ کرتے ہیں ان کی سروس کی شرائط کا احترام کریں۔';

  @override
  String get dismiss => 'برخاست کریں';

  @override
  String get done => 'ہو گیا';

  @override
  String get download => 'ڈاؤن لوڈ';

  @override
  String get downloadComplete => 'ڈاؤن لوڈ مکمل';

  @override
  String get downloadCompleteTitle => 'مکمل';

  @override
  String get downloadDate => 'ڈاؤن لوڈ کی تاریخ';

  @override
  String get downloadFailed => 'ڈاؤن لوڈ ناکام';

  @override
  String get downloadFailedTitle => 'ڈاؤن لوڈ ناکام';

  @override
  String get downloadNow => 'ڈاؤن لوڈ کریں';

  @override
  String get downloadStarted => 'ڈاؤن لوڈ شروع ہو گیا…';

  @override
  String downloadStartedQuality(Object quality) {
    return 'ڈاؤن لوڈ شروع ہو گیا · $quality';
  }

  @override
  String get downloading => 'ڈاؤن لوڈ ہو رہا ہے…';

  @override
  String get downloadingTitle => 'ڈاؤن لوڈ ہو رہا ہے';

  @override
  String get downloadsAdvanced => 'اعلیٰ ترتیبات';

  @override
  String get editSubscription => 'ترمیم کریں';

  @override
  String get embedSubtitles => 'سب ٹائٹلز ویڈیو کے اندر بھی';

  @override
  String get embedSubtitlesHelp =>
      'تاکہ دوسرے پلیئرز بھی انہیں دکھائیں۔ VidHoist کا اپنا پلیئر انہیں ہر صورت دکھاتا ہے۔';

  @override
  String get emptyFilteredMessage =>
      'اپنی پوری لائبریری دیکھنے کے لیے اوپر سے کوئی فلٹر صاف کریں۔';

  @override
  String get emptyFilteredTitle => 'ان فلٹرز سے کچھ نہیں ملتا';

  @override
  String get emptyPlaylist => 'خالی پلے لسٹ';

  @override
  String get emptyPlaylistMessage => 'لائبریری سے کلپس شامل کریں';

  @override
  String engineDownloadingProgress(Object percent) {
    return 'ڈاؤن لوڈ ہو رہا ہے · $percent%';
  }

  @override
  String get engineErrDiskFull => 'اس فائل کے لیے اسٹوریج میں کافی جگہ نہیں';

  @override
  String engineErrFailed(Object reason) {
    return 'ڈاؤن لوڈ ناکام: $reason';
  }

  @override
  String get engineErrFormat => 'اس ویڈیو کے لیے یہ کوالٹی دستیاب نہیں';

  @override
  String get engineErrGeoBlocked => 'آپ کے ملک میں دستیاب نہیں';

  @override
  String get engineErrMissing =>
      'ڈاؤن لوڈ انجن موجود نہیں یا نامکمل ہے۔ اسے ترتیبات میں «انجن کی مرمت کریں» سے ٹھیک کریں';

  @override
  String get engineErrRateLimited =>
      'سائٹ درخواستیں محدود کر رہی ہے۔ کچھ دیر بعد دوبارہ کوشش کریں';

  @override
  String get engineErrUnavailable =>
      'یہ ویڈیو دستیاب نہیں، نجی ہے یا ہٹا دی گئی ہے';

  @override
  String get engineErrUnsupported => 'یہ لنک سپورٹ نہیں ہوتا';

  @override
  String get enginePaused => 'موقوف';

  @override
  String get enginePostprocessing => 'فائل مکمل کی جا رہی ہے…';

  @override
  String get enginePreparing => 'لنک پڑھا جا رہا ہے…';

  @override
  String get engineRepair => 'انجن کی مرمت کریں';

  @override
  String get engineRepairBusy =>
      'ڈاؤن لوڈز مکمل ہونے کا انتظار کریں، پھر مرمت کریں';

  @override
  String get engineRepairHint =>
      'جب ڈاؤن لوڈز مختلف سائٹس پر ناکام ہونے لگیں جیسے پہلے نہیں ہوتے تھے، اور اپ ڈیٹ سے فائدہ نہ ہو: yt-dlp کا محفوظ کیا ہوا مواد صاف کر کے ایک صاف، تازہ ترین کاپی واپس رکھ دیتا ہے۔ آپ کے ڈاؤن لوڈز اور ترتیبات جوں کی توں رہتی ہیں۔';

  @override
  String get engineRepairPartly =>
      'جزوی مرمت ہو گئی: باقی کے لیے کنکشن درکار ہے۔ آن لائن ہونے پر دوبارہ کوشش کریں۔';

  @override
  String engineRepaired(String version) {
    return 'مرمت ہو گئی: yt-dlp $version';
  }

  @override
  String get engineRepairing => 'مرمت ہو رہی ہے…';

  @override
  String get engineResume => 'دوبارہ شروع کریں';

  @override
  String get enterFullscreen => 'پوری اسکرین';

  @override
  String errClipPastEnd(Object length) {
    return 'یہ حصہ ویڈیو ختم ہونے کے بعد شروع ہوتا ہے ($length)';
  }

  @override
  String get errClipPastEndUnknown =>
      'یہ حصہ ویڈیو ختم ہونے کے بعد شروع ہوتا ہے';

  @override
  String get errNetwork => 'سائٹ سے کوئی کنکشن نہیں';

  @override
  String get errPlatformBlockedCookies =>
      'سائٹ لاگ اِن مانگتی ہے۔ ترتیبات › کوکیز میں کوکیز فائل منتخب کریں';

  @override
  String errorGeneric(Object message) {
    return 'خرابی: $message';
  }

  @override
  String get every30Minutes => 'ہر 30 منٹ بعد';

  @override
  String everyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ہر $count گھنٹے بعد',
      one: 'ہر گھنٹے',
    );
    return '$_temp0';
  }

  @override
  String get exitFullscreen => 'پوری اسکرین سے باہر نکلیں';

  @override
  String get exportShare => 'ایکسپورٹ اور شیئر کریں';

  @override
  String get exportShareSubtitle =>
      'تاریخ والی ایک کاپی، بھیجنے یا کہیں اور رکھنے کے لیے';

  @override
  String get externalPlayerShort => 'دوسرا پلیئر';

  @override
  String get failed => 'ناکام';

  @override
  String get failedToLoadPlaylist => 'پلے لسٹ لوڈ نہیں ہو سکی';

  @override
  String get fastStreams => 'تیز تر حصوں والی اسٹریمز';

  @override
  String fastStreamsHelp(int count) {
    return 'ان سائٹس سے جو ویڈیو کو ٹکڑوں میں کاٹتی ہیں، جیسے X، ایک ساتھ $count ٹکڑے حاصل کرتا ہے۔ کچھ سائٹس ایک ساتھ بہت سی درخواستوں کو سست کر دیتی ہیں۔';
  }

  @override
  String get favorites => 'پسندیدہ';

  @override
  String get file => 'فائل';

  @override
  String get fileSize => 'فائل کا سائز';

  @override
  String get filterAll => 'سب';

  @override
  String get filterAudio => 'آڈیو';

  @override
  String get filterVideo => 'ویڈیو';

  @override
  String get filtersOn => 'فلٹرز فعال';

  @override
  String get folder => 'فولڈر';

  @override
  String get foldersHelp =>
      'ڈاؤن لوڈ فولڈر کے اندر ایک فولڈر بنایا جاتا ہے، اور کلپ سیدھا اسی میں محفوظ ہوتا ہے، جہاں Explorer اور کوئی بھی دوسری ایپ اسے دیکھ سکتی ہے۔ اسے «کوئی فولڈر نہیں» پر چھوڑ دیں تو کلپ ڈاؤن لوڈ فولڈر کی اوپری سطح پر جائے گا۔';

  @override
  String get follow => 'فالو کریں';

  @override
  String get followChannel => 'کسی چینل کو فالو کریں';

  @override
  String get format => 'فارمیٹ';

  @override
  String framesPerSecond(int count) {
    return '$count fps';
  }

  @override
  String get helpAboutField => 'اس خانے کے بارے میں';

  @override
  String get inPlaylists => 'پلے لسٹس میں';

  @override
  String get invalidUrl => 'درست لنک درج کریں';

  @override
  String get itemOptions => 'آئٹم کے اختیارات';

  @override
  String get itemUnavailable => 'اب دستیاب نہیں';

  @override
  String get jumpToNewest => 'سب سے نئے پر جائیں';

  @override
  String get justNow => 'ابھی ابھی';

  @override
  String knownVideos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ویڈیوز معلوم',
      one: '1 ویڈیو معلوم',
      zero: 'ابھی کچھ معلوم نہیں',
    );
    return '$_temp0';
  }

  @override
  String get language => 'زبان';

  @override
  String get languageSystem => 'سسٹم';

  @override
  String get languageSystemHint => 'آپ کے فون کی زبان کی پیروی کرتی ہے';

  @override
  String lastBackup(String when) {
    return 'آخری بیک اپ $when';
  }

  @override
  String lastCheckedAt(String when) {
    return 'آخری بار چیک کیا گیا $when';
  }

  @override
  String get latestAdditions => 'تازہ ترین اضافے';

  @override
  String get licensedUnder => 'GPL-3.0 کے تحت لائسنس یافتہ';

  @override
  String get licenses => 'اوپن سورس لائسنس';

  @override
  String get listSeparator => '، ';

  @override
  String get listenInBackground => 'پس منظر میں سنیں';

  @override
  String get lockTouch => 'ٹچ لاک کریں';

  @override
  String get loginDone => 'ہو گیا';

  @override
  String loginKept(String site) {
    return '$site میں سائن ان ہو گیا؛ ڈاؤن لوڈز اسے استعمال کریں گے';
  }

  @override
  String get loginNotYet =>
      'ابھی کوئی سائن ان نہیں ملا۔ سائن ان مکمل کریں، پھر «ہو گیا» پر ٹیپ کریں';

  @override
  String get logsEmpty => 'لاگ خالی ہے';

  @override
  String get logsSanitizedNote =>
      'شیئر کرنے سے پہلے لنکس، پتے اور اسناد ہٹا دی جاتی ہیں';

  @override
  String get manageTags => 'ٹیگز کا انتظام کریں';

  @override
  String get mediaAccessBlockedMessage =>
      'Android دوبارہ نہیں پوچھے گا۔ سسٹم کی ترتیبات میں اس ایپ کے لیے تصاویر اور ویڈیوز کی اجازت آن کریں، پھر واپس آئیں۔';

  @override
  String get mediaAccessGrant => 'اجازت دیں';

  @override
  String get mediaAccessMessage =>
      'آپ کے ڈاؤن لوڈز فون کے Download فولڈر میں رکھے جاتے ہیں، اور ایپ کو ان کی فہرست دکھانے سے پہلے Android کو آپ کی اجازت درکار ہے۔';

  @override
  String get mediaAccessOpenSettings => 'ترتیبات کھولیں';

  @override
  String get mediaAccessTitle => 'اپنے میڈیا تک رسائی کی اجازت دیں';

  @override
  String get mobileChannelsEmptyBody =>
      'کسی چینل کو فالو کریں اور ہر نئی ویڈیو خود بخود ڈاؤن لوڈ ہو جائے گی جب تک VidHoist کھلی ہو یا پس منظر میں ہو؛ جو کچھ اس کے بند ہونے کے دوران آیا وہ کھلنے پر ڈاؤن لوڈ ہو گا۔ چینل پر پہلے سے موجود چیزیں ڈاؤن لوڈ نہیں ہوتیں۔';

  @override
  String get mobileChannelsHint =>
      'آپ کے فالو کیے گئے چینلز کی نئی ویڈیوز، خود بخود ڈاؤن لوڈ ہوتی ہیں';

  @override
  String get mobileEngineIpv4 => 'IPv4 کے ذریعے جڑیں';

  @override
  String get mobileEngineIpv4Help =>
      'ان نیٹ ورکس پر لمبی رکاوٹ سے بچاتا ہے جن کا IPv6 راستہ خراب ہو۔ اسے صرف تب بند کریں جب آپ کے نیٹ ورک پر صرف IPv6 ہو۔';

  @override
  String mobileEngineLastUpdate(String when) {
    return 'آخری اپ ڈیٹ $when';
  }

  @override
  String get mobileEngineNotReady => 'تیاری ہو رہی ہے…';

  @override
  String get mobileEngineUpToDate => 'yt-dlp تازہ ترین ہے';

  @override
  String get mobileEngineUpdate => 'yt-dlp اپ ڈیٹ کریں';

  @override
  String get mobileEngineUpdateFailed =>
      'yt-dlp اپ ڈیٹ نہیں ہو سکا۔ کنکشن چیک کر کے دوبارہ کوشش کریں۔';

  @override
  String get mobileEngineUpdateMissed => 'اپ ڈیٹ ناکام';

  @override
  String get mobileEngineUpdated => 'اپ ڈیٹ ہو گیا';

  @override
  String get mobileEngineUpdating => 'اپ ڈیٹ ہو رہا ہے…';

  @override
  String get mobileEngineVersionLabel => 'yt-dlp ورژن';

  @override
  String get mobileEngineVersionUnknown =>
      'اس کا ورژن پہلی اپ ڈیٹ کے بعد نظر آئے گا';

  @override
  String get mobileSettingsEngine => 'ڈاؤن لوڈ انجن';

  @override
  String get mobileSettingsGroupEngine => 'انجن';

  @override
  String get mobileSignInNeeded =>
      'یہ سائٹ چاہتی ہے کہ آپ سائن ان ہوں۔ ترتیبات › اکاؤنٹس سے سائن ان کریں، پھر دوبارہ کوشش کریں';

  @override
  String get mobileSubtitleOptions => 'سائز، پس منظر اور ٹرانسکرپٹ';

  @override
  String get mobileSubtitleStyleHelp => 'پلیئر میں بھی: CC بٹن دبائے رکھیں۔';

  @override
  String get mobileSubtitles => 'سب ٹائٹلز ڈاؤن لوڈ کریں';

  @override
  String get mobileSubtitlesHelp =>
      'نیچے دی گئی زبانوں میں سب ٹائٹلز، اگر ویڈیو میں موجود ہوں، اس کے ساتھ محفوظ ہوتے ہیں اور پلیئر میں دکھائے جاتے ہیں۔';

  @override
  String get mobileSubtitlesSizeLarger => 'بڑا';

  @override
  String get mobileTranscript => 'ٹرانسکرپٹ';

  @override
  String get mobileTranscriptHint =>
      'وہیں سے چلانے کے لیے کسی سطر پر ٹیپ کریں۔';

  @override
  String get mobileTranscriptOpen => 'ٹرانسکرپٹ پڑھیں';

  @override
  String get mobileWelcomeBody =>
      'آپ کی استعمال کردہ سائٹس سے ویڈیوز اور آڈیو، سیدھے اس فون پر محفوظ۔ ڈاؤن لوڈ انجن تیار ہو رہا ہے؛ یہ صرف ایک بار ہوتا ہے۔';

  @override
  String get mobileWelcomeFailed =>
      'انجن شروع نہیں ہو سکا۔ دوبارہ کوشش کریں؛ اگر بار بار ناکام ہو تو ایپ دوبارہ انسٹال کریں۔';

  @override
  String get mobileWelcomeStart => 'شروع کریں';

  @override
  String get mobileWelcomeTitle => 'VidHoist میں خوش آمدید';

  @override
  String get mobileWelcomeUnpacking => 'ڈاؤن لوڈ انجن تیار کیا جا رہا ہے';

  @override
  String get mobileWelcomeUpdateFailed =>
      'ابھی اپ ڈیٹ نہیں ہو سکا۔ VidHoist آپ کے پہلے ڈاؤن لوڈ سے پہلے دوبارہ کوشش کرے گی۔';

  @override
  String get mobileWelcomeUpdating =>
      'yt-dlp کو تازہ ترین ورژن پر اپ ڈیٹ کیا جا رہا ہے';

  @override
  String get modeAutoNext => 'خودکار';

  @override
  String get modeRepeatAll => 'سب دہرائیں';

  @override
  String get modeRepeatOne => 'ایک دہرائیں';

  @override
  String get modeStopAtEnd => 'آخر میں رکیں';

  @override
  String get navLibrary => 'لائبریری';

  @override
  String get navMyDownloads => 'میرے ڈاؤن لوڈز';

  @override
  String get navPlaylists => 'پلے لسٹس';

  @override
  String get navSettings => 'ترتیبات';

  @override
  String get needsAttention => 'آپ کی توجہ درکار ہے';

  @override
  String get neverChecked => 'ابھی چیک نہیں کیا گیا';

  @override
  String get newFolder => 'نیا فولڈر…';

  @override
  String get newFolderHint => 'مثلاً Ai/Lessons';

  @override
  String get newPlaylistAction => 'نئی پلے لسٹ';

  @override
  String get newTagHint => 'نیا ٹیگ';

  @override
  String newVideosBody(String channels) {
    return '$channels۔ یہ VidHoist کھولنے پر ڈاؤن لوڈ ہوں گی۔';
  }

  @override
  String newVideosNotice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نئی ویڈیوز',
      one: '$count نئی ویڈیو',
    );
    return '$_temp0';
  }

  @override
  String get next => 'اگلا';

  @override
  String get noBackupsYet => 'ابھی کوئی بیک اپ نہیں';

  @override
  String get noDownloads => 'کوئی ڈاؤن لوڈ نہیں';

  @override
  String get noDownloadsMessage =>
      'ڈاؤن لوڈ کیے گئے کلپس یہاں نظر آئیں گے۔\nکوئی لنک شیئر کریں یا «لنک شامل کریں» بٹن استعمال کریں۔';

  @override
  String get noExternalPlayer => 'اس آلے پر کوئی بیرونی پلیئر نہیں';

  @override
  String get noFolder => 'کوئی فولڈر نہیں';

  @override
  String get noFolderHint => 'ڈاؤن لوڈز کی اوپری سطح پر';

  @override
  String get noLogsFound => 'کوئی لاگ نہیں ملا';

  @override
  String get noPlayableSource => 'اس آئٹم کا کوئی قابلِ پلے ذریعہ نہیں';

  @override
  String get noPlaylistsMessage => 'اپنے کلپس منظم کرنے کے لیے پلے لسٹ بنائیں';

  @override
  String get noResults => 'کوئی نتیجہ نہیں';

  @override
  String get noResultsMessage => 'کوئی آئٹم آپ کی تلاش سے میل نہیں کھاتا۔';

  @override
  String get noServerTitle => 'ڈاؤن لوڈ انجن تیار نہیں';

  @override
  String get noticeChannelNewVideos => 'نئی ویڈیوز';

  @override
  String get noticeChannelUpdates => 'اپ ڈیٹس';

  @override
  String get noVideosFound => 'آپ کی لائبریری خالی ہے';

  @override
  String get noWarranty => 'جیسی ہے ویسی فراہم کی گئی ہے، بغیر کسی وارنٹی کے۔';

  @override
  String get notAffiliated =>
      'yt-dlp یا کسی سائٹ سے وابستہ نہیں، اور نہ ہی ان کی طرف سے توثیق شدہ۔';

  @override
  String get nothingHereYet => 'ابھی یہاں کچھ نہیں';

  @override
  String get notificationClipGone => 'یہ کلپ اب فون پر نہیں ہے۔';

  @override
  String get nowPlaying => 'اب چل رہا ہے';

  @override
  String get nowPlayingCollapse => 'پلیئر پینل سمیٹیں';

  @override
  String get nowPlayingExpand => 'پلیئر پینل دکھائیں';

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String get onlyNewVideos =>
      'صرف وہی ڈاؤن لوڈ ہو گا جو اب سے آئے گا۔ چینل پر پہلے سے موجود ویڈیوز کو نہیں چھیڑا جاتا۔';

  @override
  String get openChannel => 'چینل کھولیں';

  @override
  String get openInExternalPlayer => 'کسی دوسرے پلیئر میں کھولیں';

  @override
  String get openOriginalLink => 'اصل لنک کھولیں';

  @override
  String get ownFolder => 'اس کے اپنے فولڈر میں محفوظ کریں';

  @override
  String get ownFolderNote =>
      'ڈاؤن لوڈ فولڈر کے اندر ایک فولڈر، جسے Explorer اور دوسری ایپس بھی دیکھ سکتی ہیں۔ صرف وہی وہاں جائے گا جو اب سے آئے گا؛ جو پہلے سے ڈاؤن لوڈ ہو چکا ہے وہ اپنی جگہ رہے گا۔';

  @override
  String get pasteUrlHint => 'لنک یہاں پیسٹ کریں…';

  @override
  String get pause => 'روکیں';

  @override
  String get pauseSubscription => 'موقوف کریں';

  @override
  String get pcAddressLabel => 'پتہ';

  @override
  String get pcBadAddress =>
      'پتہ ویسے ہی لکھیں جیسا کمپیوٹر دکھاتا ہے، مثلاً 192.168.1.24۔';

  @override
  String get pcBadQr => 'یہ VidHoist کا جوڑنے والا QR کوڈ نہیں ہے۔';

  @override
  String get pcCertificate => 'کمپیوٹر کا سرٹیفکیٹ';

  @override
  String get pcCodeLabel => 'کوڈ';

  @override
  String get pcConnected => 'جڑا ہوا';

  @override
  String get pcCopied =>
      'فون کی لائبریری میں کاپی ہو گیا، اس کے سب ٹائٹلز کے ساتھ۔';

  @override
  String get pcCopyFailed =>
      'کاپی مکمل نہیں ہوئی: شاید کمپیوٹر بند ہے یا پہنچ سے باہر۔ کچھ محفوظ نہیں رکھا گیا۔';

  @override
  String get pcCopyStarting => 'کاپی ہو رہا ہے…';

  @override
  String get pcCopyStop => 'کاپی روکیں';

  @override
  String get pcCopyToPhone => 'فون پر کاپی کریں';

  @override
  String pcCopying(int percent) {
    return 'کاپی ہو رہا ہے $percent%';
  }

  @override
  String get pcDelete => 'کمپیوٹر سے حذف کریں';

  @override
  String pcDeleteBody(String title) {
    return '«$title» کمپیوٹر کی Recycle Bin میں چلا جائے گا، جہاں سے اسے واپس لایا جا سکتا ہے۔';
  }

  @override
  String get pcDeleteFailed =>
      'کمپیوٹر اسے حذف نہیں کر سکا۔ شاید یہ وہاں کھلا ہوا ہے۔';

  @override
  String get pcDeleteMissing => 'یہ کلپ اب کمپیوٹر پر نہیں ہے۔';

  @override
  String get pcDeleteNoBin =>
      'حذف نہیں ہوا: کمپیوٹر پر اس کی ڈرائیو میں Recycle Bin نہیں ہے۔';

  @override
  String get pcDeleteNotAllowed =>
      'کمپیوٹر فون کو حذف کرنے کی اجازت نہیں دیتا۔ اسے وہاں ترتیبات › فون میں آن کریں۔';

  @override
  String pcDeleteTitle(String name) {
    return '$name سے حذف کریں؟';
  }

  @override
  String pcDeleted(String title) {
    return 'کمپیوٹر کی Recycle Bin میں: $title';
  }

  @override
  String get pcDestPhone => 'یہ فون';

  @override
  String pcDoneOnPc(String title) {
    return 'کمپیوٹر پر مکمل: $title';
  }

  @override
  String pcDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'کمپیوٹر کے لیے $count ڈاؤن لوڈز',
      one: 'کمپیوٹر کے لیے 1 ڈاؤن لوڈ',
    );
    return '$_temp0';
  }

  @override
  String get pcDownloadsSheet => 'کمپیوٹر پر ڈاؤن لوڈز';

  @override
  String get pcEmptyLibrary => 'ابھی کمپیوٹر پر کوئی ڈاؤن لوڈ نہیں۔';

  @override
  String get pcErrBad =>
      'کمپیوٹر نے ایسا جواب دیا جو یہ ورژن نہیں سمجھتا۔ دونوں ایپس اپ ڈیٹ کریں۔';

  @override
  String get pcErrClosed =>
      'کمپیوٹر پر کوئی کوڈ نظر نہیں آ رہا، یا اس کی میعاد ختم ہو گئی۔ وہاں «فون جوڑیں» دبائیں۔';

  @override
  String get pcErrDenied =>
      'کمپیوٹر پر جوڑنے سے انکار کر دیا گیا، یا وقت پر جواب نہیں دیا گیا۔';

  @override
  String get pcErrRefused => 'کمپیوٹر نے یہ لنک قبول نہیں کیا۔';

  @override
  String get pcErrUnauthorized =>
      'کمپیوٹر اب اس فون کو نہیں پہچانتا۔ دوبارہ جوڑیں۔';

  @override
  String get pcErrUnreachable =>
      'کمپیوٹر نے جواب نہیں دیا۔ کیا وہ آن ہے، اسی نیٹ ورک پر یا آپ کے Tailscale پر، اور «فون سے وصول کریں» آن ہے؟';

  @override
  String get pcErrWrongCertificate =>
      'اس پتے پر آپ کے کمپیوٹر کے علاوہ کسی اور نے جواب دیا۔ کچھ نہیں بھیجا گیا۔';

  @override
  String get pcErrWrongCode => 'غلط کوڈ۔';

  @override
  String get pcFindNone =>
      'کوئی کمپیوٹر نہیں ملا۔ پہلے کمپیوٹر پر ترتیبات › فون › فون جوڑیں کھولیں، اسی Wi-Fi پر۔';

  @override
  String get pcFindOnNetwork => 'نیٹ ورک پر تلاش کریں';

  @override
  String get pcFirewallAllow => 'اجازت دیں';

  @override
  String get pcFirewallBlocked =>
      'Windows Firewall نے VidHoist کو روک رکھا ہے، اس لیے فون اس تک نہیں پہنچ سکتا۔ اسے گھریلو (نجی) نیٹ ورکس پر اجازت دیں۔';

  @override
  String get pcFirewallMissing =>
      'Windows نے ابھی تک VidHoist کو فون سے وصول کرنے کی اجازت نہیں دی۔ ایک بار اجازت دیں، صرف گھریلو (نجی) نیٹ ورکس پر۔';

  @override
  String get pcFirewallPublic =>
      'Windows اس نیٹ ورک کو Public کہتا ہے، اور وہاں کچھ اندر نہیں آنے دیتا۔ اگر یہ آپ کا گھریلو نیٹ ورک ہے تو اسے Private بنائیں: ترتیبات › نیٹ ورک اور انٹرنیٹ › Wi-Fi › اس کی خصوصیات۔';

  @override
  String get pcFirewallRefused =>
      'کچھ نہیں بدلا: Windows کو ایڈمنسٹریٹر کی اجازت درکار ہے۔';

  @override
  String get pcFirewallTitle => 'Windows Firewall';

  @override
  String pcFound(String name) {
    return '$name مل گیا۔ وہ جو کوڈ دکھاتا ہے وہ لکھیں۔';
  }

  @override
  String pcFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ملے',
      one: '1 ملا',
    );
    return '$_temp0';
  }

  @override
  String pcLastContact(String time) {
    return 'آخری رابطہ $time';
  }

  @override
  String get pcLibrary => 'کمپیوٹر پر لائبریری';

  @override
  String get pcLinkAddress => 'اس نیٹ ورک پر پتہ';

  @override
  String get pcLinkAddressTailscale => 'Tailscale کے ذریعے، گھر سے باہر سے';

  @override
  String get pcLinkAllow => 'اجازت دیں';

  @override
  String get pcLinkAllowDelete => 'فون کو کلپس حذف کرنے دیں';

  @override
  String get pcLinkAllowDeleteHint =>
      'فون سے حذف کیا گیا کلپ اس کمپیوٹر کی Recycle Bin میں جاتا ہے، جہاں سے آپ اسے واپس لا سکتے ہیں۔ جس ڈرائیو میں Recycle Bin نہ ہو وہاں یہ حذف نہیں ہوتا۔';

  @override
  String get pcLinkCodeHint =>
      'فون پر: ترتیبات › کمپیوٹر › QR کوڈ اسکین کریں۔ یا وہاں یہ پتہ اور کوڈ لکھیں۔ یہ ایک بار، دو منٹ کے لیے کام کرتا ہے۔';

  @override
  String pcLinkCodeLeft(int seconds) {
    return '$seconds سیکنڈ باقی';
  }

  @override
  String get pcLinkCodeTitle => 'جوڑنے کا کوڈ';

  @override
  String get pcLinkDeny => 'انکار کریں';

  @override
  String get pcLinkDevices => 'جوڑے گئے فون';

  @override
  String pcLinkFailed(String error) {
    return 'شروع نہیں ہو سکا: $error';
  }

  @override
  String get pcLinkIntro =>
      'اپنے فون پر VidHoist سے اس کمپیوٹر کو لنکس بھیجیں، اور وہیں اس کے ڈاؤن لوڈز اور لائبریری دیکھیں۔ آپ کے گھریلو نیٹ ورک کے اندر کام کرتا ہے، اور باہر سے Tailscale کے ذریعے۔';

  @override
  String pcLinkLastSeen(String time) {
    return 'آخری رابطہ $time';
  }

  @override
  String get pcLinkNoDevices => 'ابھی کوئی فون نہیں۔';

  @override
  String get pcLinkOff => 'بند';

  @override
  String pcLinkOtherAddresses(int count) {
    return 'دوسرے پتے ($count)';
  }

  @override
  String get pcLinkOtherAddressesHint =>
      'نیٹ ورک اڈاپٹرز جو دوسرے پروگرام شامل کرتے ہیں، جیسے VirtualBox یا WSL۔ فون کو ان کی شاذ ہی ضرورت پڑتی ہے۔';

  @override
  String get pcLinkPairPhone => 'فون جوڑیں';

  @override
  String pcLinkPairedAt(String time) {
    return 'جوڑا گیا $time';
  }

  @override
  String pcLinkPhones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فون',
      one: 'ایک فون',
      zero: 'کوئی فون نہیں',
    );
    return '$_temp0';
  }

  @override
  String get pcLinkQrHint => 'فون سے اسکین کریں';

  @override
  String get pcLinkReceive => 'فون سے وصول کریں';

  @override
  String get pcLinkReceiveHint =>
      'جب یہ بند ہو تو اس کمپیوٹر پر کوئی پورٹ کھلا نہیں ہوتا۔ اگر Windows پوچھے تو صرف نجی نیٹ ورکس کی اجازت دیں۔';

  @override
  String pcLinkRequest(String name) {
    return '$name جوڑنے کی درخواست کر رہا ہے';
  }

  @override
  String get pcLinkRequestHint =>
      'صرف تب اجازت دیں جب فون وہی چار ہندسے دکھائے۔';

  @override
  String get pcLinkRevoke => 'جوڑ ختم کریں';

  @override
  String get pcLinkSecurity =>
      'فون اس کمپیوٹر سے براہ راست بات کرتا ہے، آپ کے نیٹ ورک پر یا آپ کے Tailscale کے ذریعے۔ یہ ایک بار جوڑا جاتا ہے، کوڈ اور یہاں آپ کی منظوری کے ساتھ؛ اس کے بعد ہر درخواست کے ساتھ اپنی کلید پیش کرتا ہے، ایسے کنکشن پر جو صرف اس کمپیوٹر کے سرٹیفکیٹ سے خفیہ کیا گیا ہو۔ نیٹ ورک پر کسی اور کو بند دروازہ ملتا ہے۔';

  @override
  String get pcLinkStarting => 'شروع ہو رہا ہے…';

  @override
  String get pcLinkTitle => 'فون';

  @override
  String get pcListEmpty => 'اس فہرست کا کوئی کلپ اب کمپیوٹر پر نہیں ہے۔';

  @override
  String get pcListen => 'سنیں';

  @override
  String get pcLists => 'کمپیوٹر پر فہرستیں';

  @override
  String get pcListsEmpty => 'کمپیوٹر کی کسی فہرست میں کلپس نہیں ہیں۔';

  @override
  String get pcNow => 'ابھی کمپیوٹر پر';

  @override
  String get pcOffline => 'دستیاب نہیں';

  @override
  String get pcOfflineMessage =>
      'کمپیوٹر بند ہے یا کسی دوسرے نیٹ ورک پر ہے۔ پچھلی بار جو کچھ اس پر تھا وہ نیچے دکھایا گیا ہے۔';

  @override
  String get pcOfflineRoute =>
      'گھر سے باہر ہیں؟ ترتیبات › کمپیوٹر میں Tailscale منتخب کریں۔';

  @override
  String get pcOnPhone => 'فون پر';

  @override
  String get pcOrType => 'یا پتہ اور کوڈ لکھیں';

  @override
  String get pcOutboxRefused => 'کمپیوٹر نے یہ لنک قبول نہیں کیا';

  @override
  String pcOutboxTitle(int count) {
    return 'بھیجنے کے منتظر ($count)';
  }

  @override
  String get pcPairButton => 'جوڑیں';

  @override
  String pcPairCheck(String check) {
    return 'دیکھ لیں کہ کمپیوٹر $check دکھا رہا ہے، پھر وہاں فون کو اجازت دیں۔';
  }

  @override
  String get pcPairIntro =>
      'اگر VidHoist آپ کے Windows کمپیوٹر پر چلتی ہے تو یہ فون اسے لنکس بھیج سکتا ہے اور اس کے ڈاؤن لوڈز اور لائبریری دکھا سکتا ہے۔ کمپیوٹر پر ترتیبات › فون آن کریں اور «فون جوڑیں» دبائیں، پھر وہ جو QR کوڈ دکھائے اسے اسکین کریں۔';

  @override
  String pcPaired(String name) {
    return '$name سے جڑ گیا';
  }

  @override
  String get pcPortLabel => 'پورٹ';

  @override
  String pcQueued(String name) {
    return 'یہ $name کے واپس آنے پر اس کو جائے گا۔';
  }

  @override
  String pcQueuedMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کلپس $name کے واپس آنے پر اس کو جائیں گے۔',
      one: '1 کلپ $name کے واپس آنے پر اس کو جائے گا۔',
    );
    return '$_temp0';
  }

  @override
  String get pcRouteHint =>
      'جب آپ گھر سے باہر ہوں تو Tailscale منتخب کریں؛ یہ فون اور کمپیوٹر دونوں پر چل رہا ہونا چاہیے۔';

  @override
  String get pcRouteHome => 'گھریلو نیٹ ورک';

  @override
  String get pcRouteOther => 'دوسرا نیٹ ورک';

  @override
  String get pcRouteTailscale => 'Tailscale';

  @override
  String get pcRouteTitle => 'اس کے ذریعے جڑیں';

  @override
  String get pcRouteWaiting =>
      'کمپیوٹر کے جواب دیتے ہی اس کے دوسرے راستے یہاں نظر آئیں گے۔';

  @override
  String get pcScanButton => 'QR کوڈ اسکین کریں';

  @override
  String get pcScanFailed => 'کیمرا نہیں کھل سکا۔';

  @override
  String get pcScanPrompt =>
      'کیمرے کو کمپیوٹر کی اسکرین پر موجود QR کوڈ کی طرف کریں';

  @override
  String get pcSearchHint => 'کمپیوٹر کی لائبریری میں تلاش کریں';

  @override
  String get pcSendToPc => 'کمپیوٹر کو بھیجیں';

  @override
  String pcSent(String name) {
    return '$name کو بھیج دیا گیا';
  }

  @override
  String pcSentMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کلپس $name کو بھیجے گئے',
      one: '1 کلپ $name کو بھیجا گیا',
    );
    return '$_temp0';
  }

  @override
  String get pcSettingsHint => 'اپنے کمپیوٹر کو لنکس بھیجیں';

  @override
  String get pcTab => 'کمپیوٹر';

  @override
  String pcVia(String route) {
    return '$route کے ذریعے';
  }

  @override
  String get pcWatch => 'دیکھیں';

  @override
  String get pcWillSend => 'دور ہے: واپس آنے پر بھیجا جائے گا';

  @override
  String get pickAnotherFile => 'کسی دوسری فائل سے…';

  @override
  String get pickAnotherFileSubtitle => 'کسی دوسرے فون یا پرانے ورژن کا بیک اپ';

  @override
  String get pictureInPicture => 'تصویر میں تصویر';

  @override
  String get pictureInPictureHelp =>
      'کلپ چلتے ہوئے ایپ سے باہر جائیں تو وہ اسکرین کے ایک کونے میں رہتا ہے';

  @override
  String get pinPlaylist => 'اوپر پن کریں';

  @override
  String get platform => 'سائٹ';

  @override
  String platformCount(Object name, int count) {
    return '$name · $count';
  }

  @override
  String get platformOther => 'دیگر';

  @override
  String get play => 'چلائیں';

  @override
  String get playAll => 'سب چلائیں';

  @override
  String get playModeLabel => 'موڈ';

  @override
  String get playbackSpeed => 'پلے بیک کی رفتار';

  @override
  String get playerError => 'یہ فائل نہیں چل سکی';

  @override
  String get playingFromDevice => 'آپ کے آلے سے چل رہا ہے';

  @override
  String get playlist => 'پلے لسٹ';

  @override
  String get playlistAddClips => 'کلپ شامل کریں';

  @override
  String playlistAddClipsTo(String name) {
    return '“$name” میں شامل کریں';
  }

  @override
  String playlistAddCount(int count) {
    return 'شامل کریں ($count)';
  }

  @override
  String get playlistCreated => 'پلے لسٹ بن گئی';

  @override
  String get playlistDeleted => 'پلے لسٹ حذف ہو گئی';

  @override
  String get playlistDetails => 'پلے لسٹ کی تفصیلات';

  @override
  String get playlistEditHint =>
      'کلپ کو منتقل کرنے کے لیے دیر تک دبائیں۔ ہٹانے کے لیے اسے ایک طرف سوائپ کریں۔';

  @override
  String get playlistName => 'پلے لسٹ کا نام';

  @override
  String get playlistNameHint => 'میری پلے لسٹ';

  @override
  String playlistOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get playlists => 'پلے لسٹس';

  @override
  String get previous => 'پچھلا';

  @override
  String get quality => 'کوالٹی';

  @override
  String get quality1080 => '1080p تک';

  @override
  String get quality360 => '360p تک';

  @override
  String get quality480 => '480p تک';

  @override
  String get quality720 => '720p تک';

  @override
  String get qualityAudio => 'آڈیو';

  @override
  String get qualityBest => 'بہترین';

  @override
  String get qualityHelper =>
      'فوری ڈاؤن لوڈ، پوری پلے لسٹ کے ڈاؤن لوڈز، اور کلپ بورڈ بار میں «ڈاؤن لوڈ» کے لیے استعمال ہوتی ہے، اور لنک شامل کرنے والی شیٹ میں پہلے سے منتخب اختیار یہی ہوتا ہے۔ اس لیے یہ اہم ہے چاہے فوری ڈاؤن لوڈ آن ہو یا نہیں۔';

  @override
  String get qualityReading => 'فائل پڑھی جا رہی ہے…';

  @override
  String get qualityUnavailable => 'دستیاب نہیں';

  @override
  String get qualityVideo => 'ویڈیو';

  @override
  String queueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آئٹمز',
      one: '1 آئٹم',
      zero: 'کوئی آئٹم نہیں',
    );
    return '$_temp0';
  }

  @override
  String get queueLabel => 'قطار';

  @override
  String queuePosition(int position) {
    return 'قطار میں نمبر $position';
  }

  @override
  String get queued => 'قطار میں';

  @override
  String get queuedSection => 'منتظر';

  @override
  String get quickDownload => 'فوری ڈاؤن لوڈ';

  @override
  String get quickDownloadHelp =>
      'شیئر یا پیسٹ کیا گیا لنک بغیر کسی شیٹ کے فوراً طے شدہ کوالٹی میں ڈاؤن لوڈ ہونا شروع ہو جاتا ہے۔ جس سائٹ پر وہ کوالٹی نہ ہو وہ اپنی بہترین دیتی ہے، اور «صرف آڈیو» ہر سائٹ پر کام کرتا ہے۔';

  @override
  String get rateLimit => 'رفتار کی حد';

  @override
  String get rateLimitNone => 'کوئی حد نہیں';

  @override
  String rateLimitValue(int mb) {
    return '$mb MB/s';
  }

  @override
  String get reelsEndBack => 'لائبریری پر واپس';

  @override
  String get reelsEndContinue => 'فہرست کا باقی حصہ جاری رکھیں';

  @override
  String get reelsEndReplay => 'شروع سے دوبارہ چلائیں';

  @override
  String get reelsEndTitle => 'شارٹس کی قطار ختم';

  @override
  String get reelsSwipeHint => 'اگلے شارٹ کے لیے اوپر سوائپ کریں';

  @override
  String get refresh => 'تازہ کریں';

  @override
  String get remove => 'ہٹائیں';

  @override
  String get removeFromFavorites => 'پسندیدہ سے ہٹائیں';

  @override
  String removeUnavailable(int count) {
    return '$count غیر دستیاب ہٹائیں';
  }

  @override
  String get removedFromFavorites => 'پسندیدہ سے ہٹا دیا گیا';

  @override
  String get removedFromPlaylist => 'پلے لسٹ سے ہٹا دیا گیا';

  @override
  String get rename => 'نام بدلیں';

  @override
  String get renameTag => 'ٹیگ کا نام بدلیں';

  @override
  String get reportBug => 'خرابی کی اطلاع دیں';

  @override
  String get restoreConfirm =>
      'بیک اپ فائل سے ڈیٹا بحال کریں؟ اس سے موجودہ پلے لسٹس، ٹیگز اور ترتیبات بدل جائیں گی۔';

  @override
  String get restoreData => 'بحال کریں';

  @override
  String get restoreFailed => 'بحالی ناکام: بیک اپ فائل درست نہیں';

  @override
  String get restorePickBody =>
      'اس فون پر VidHoist کے ڈاؤن لوڈز ہیں لیکن ترتیبات نہیں، جیسا کہ دوبارہ انسٹال کرنے کے بعد ہوتا ہے۔ اگر آپ نے بیک اپ رکھا ہے تو اسے منتخب کریں: ایپ انہیں Download/VidHoist/backups میں لکھتی ہے۔';

  @override
  String get restorePickChoose => 'بیک اپ منتخب کریں';

  @override
  String get restorePickTitle => 'اپنی ترتیبات واپس لائیں؟';

  @override
  String get restoreSettings => 'تمام ڈیٹا بحال کریں';

  @override
  String get restoreSuccess => 'ڈیٹا کامیابی سے بحال ہو گیا';

  @override
  String get resumeSubscription => 'دوبارہ شروع کریں';

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String get saveSettings => 'ترتیبات محفوظ کریں';

  @override
  String get searchLogs => 'لاگز میں تلاش کریں…';

  @override
  String get searchVideos => 'کلپس میں تلاش کریں…';

  @override
  String get seekBackward10 => '10 سیکنڈ پیچھے';

  @override
  String get seekForward10 => '10 سیکنڈ آگے';

  @override
  String get selectAll => 'سب منتخب کریں';

  @override
  String selected(int count) {
    return '$count منتخب';
  }

  @override
  String selectedCount(int count) {
    return '$count منتخب';
  }

  @override
  String get settings => 'ترتیبات';

  @override
  String get settingsAccounts => 'اکاؤنٹس';

  @override
  String get settingsBackup => 'بیک اپ';

  @override
  String get settingsDownloads => 'ڈاؤن لوڈز';

  @override
  String get settingsGroupApp => 'ایپ';

  @override
  String get settingsGroupData => 'ڈیٹا';

  @override
  String get settingsPlayback => 'پلے بیک';

  @override
  String get settingsTranscripts => 'ٹرانسکرپٹس اور سب ٹائٹلز';

  @override
  String settingsValueChannels(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count چینلز',
      one: '1 چینل',
      zero: 'ابھی کوئی چینل نہیں',
    );
    return '$_temp0';
  }

  @override
  String get settingsValueCompatOff => 'بہترین مطابقت: بند';

  @override
  String get settingsValueCompatOn => 'بہترین مطابقت: آن';

  @override
  String get settingsValueNotSet => 'ابھی سیٹ اپ نہیں';

  @override
  String get settingsValueQuick => 'فوری';

  @override
  String settingsValueSignedIn(String sites) {
    return 'سائن ان: $sites';
  }

  @override
  String get settingsValueWifiOnly => 'صرف Wi‑Fi';

  @override
  String get share => 'شیئر کریں';

  @override
  String get shareLogs => 'لاگز شیئر کریں';

  @override
  String get shareOpening => 'شیئر مینو کھل رہا ہے…';

  @override
  String get shareOpeningHint =>
      'بڑی فائل کو منتقل ہونے میں چند سیکنڈ لگتے ہیں۔';

  @override
  String get shareSelected => 'منتخب شیئر کریں';

  @override
  String get sharedLinksAdd => 'انہیں شامل کریں';

  @override
  String get sharedLinksBody => 'ہر ایک اس فون پر ڈاؤن لوڈ ہو گا۔';

  @override
  String sharedLinksCapped(int max) {
    return 'صرف پہلے $max لنکس شامل کیے گئے۔';
  }

  @override
  String sharedLinksTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لنکس شامل کریں؟',
      one: '1 لنک شامل کریں؟',
    );
    return '$_temp0';
  }

  @override
  String get shortsFilter => 'شارٹس';

  @override
  String get shuffle => 'بے ترتیب';

  @override
  String get signInRequired => 'سائن ان ضروری ہے';

  @override
  String get size => 'سائز';

  @override
  String get smartPlaylists => 'اسمارٹ پلے لسٹس';

  @override
  String get sortAndPlatform => 'ترتیب اور سائٹ';

  @override
  String get sortBy => 'ترتیب بلحاظ';

  @override
  String get sortLargest => 'سب سے بڑا';

  @override
  String get sortNameAZ => 'نام A–Z';

  @override
  String get sortNameZA => 'نام Z–A';

  @override
  String get sortNewest => 'سب سے نیا';

  @override
  String get sortOldest => 'سب سے پرانا';

  @override
  String get sortSmallest => 'سب سے چھوٹا';

  @override
  String get sortedByLastPlayed => 'آخری بار چلائے گئے کے لحاظ سے';

  @override
  String get source => 'ذریعہ';

  @override
  String get sourceCode => 'سورس کوڈ';

  @override
  String get starAskBody =>
      'مفت اور اوپن سورس، نہ اشتہار نہ اکاؤنٹ۔ GitHub پر ایک ستارہ دوسروں کو اسے ڈھونڈنے میں مدد دیتا ہے۔';

  @override
  String get starAskIdeas => 'کوئی خیال تجویز کریں یا مسئلہ بتائیں';

  @override
  String get starAskLater => 'شاید بعد میں';

  @override
  String get starAskNever => 'دوبارہ نہ دکھائیں';

  @override
  String get starAskStar => 'GitHub پر ستارہ دیں';

  @override
  String get starAskTitle => 'کیا VidHoist پسند آیا؟';

  @override
  String get startDownload => 'ڈاؤن لوڈ شروع کریں';

  @override
  String get status => 'حالت';

  @override
  String get storageCardMissing =>
      'کارڈ موجود نہیں، اس لیے ڈاؤن لوڈز فون میں جائیں گے';

  @override
  String get storageLocation => 'یہاں محفوظ کریں';

  @override
  String get storageLocationHelp =>
      'پہلے سے ڈاؤن لوڈ شدہ کلپس اپنی جگہ رہتے ہیں اور لائبریری میں نظر آتے رہتے ہیں۔ میموری کارڈ کے لیے Android 11 یا اس سے نیا درکار ہے۔';

  @override
  String get storageNoCard => 'اس فون میں کوئی میموری کارڈ نہیں';

  @override
  String get storagePhone => 'فون کی اسٹوریج';

  @override
  String get streamingOnline => 'نیٹ ورک پر چل رہا ہے';

  @override
  String subscriptionAdded(String name) {
    return 'اب $name کو فالو کر رہے ہیں';
  }

  @override
  String get subscriptionName => 'نام';

  @override
  String get subscriptionPaused => 'موقوف';

  @override
  String get subscriptionQuality => 'اس چینل کے لیے کوالٹی';

  @override
  String get subscriptionQualityHelp =>
      'وہ کوالٹی جس میں اس چینل کی نئی ویڈیوز ڈاؤن لوڈ ہوتی ہیں۔ آپ بعد میں چینل میں ترمیم کر کے اسے بدل سکتے ہیں؛ پہلے سے ڈاؤن لوڈ شدہ ویڈیوز اپنی کوالٹی برقرار رکھتی ہیں۔\n\n«بہترین» کا مطلب AV1 فارمیٹ میں 4K ہو سکتا ہے، جو پرانا کمپیوٹر اٹک اٹک کر چلا سکتا ہے: ایسا ہو تو 1080p منتخب کریں۔';

  @override
  String get subscriptionQualityNote =>
      'نئی ویڈیوز پر لاگو ہوتی ہے؛ پہلے سے ڈاؤن لوڈ شدہ اپنی کوالٹی برقرار رکھتی ہیں۔';

  @override
  String get subscriptions => 'چینلز';

  @override
  String get subscriptionsEmpty => 'ابھی کوئی چینل فالو نہیں کیا گیا';

  @override
  String get subscriptionsEmptyBody =>
      'کسی چینل کو فالو کریں اور ہر نئی ویڈیو خود بخود آپ کی لائبریری میں ڈاؤن لوڈ ہو جائے گی، جب تک VidHoist کھلی ہو یا ٹرے میں ہو۔ چینل پر پہلے سے موجود چیزیں ڈاؤن لوڈ نہیں ہوتیں۔';

  @override
  String get subscriptionsSubtitle =>
      'آپ کے فالو کیے گئے چینلز کی نئی ویڈیوز، خود بخود ڈاؤن لوڈ ہوتی ہیں';

  @override
  String get subtitleLangs => 'سب ٹائٹل کی زبانیں';

  @override
  String get subtitleLangsHelp =>
      'جب ویڈیو میں موجود ہوں تو حاصل کیے جاتے ہیں۔ کم از کم ایک منتخب رہتی ہے۔';

  @override
  String get subtitles => 'سب ٹائٹلز';

  @override
  String get subtitlesBackground => 'پس منظر';

  @override
  String get subtitlesBackgroundFaint => 'ہلکا';

  @override
  String get subtitlesBackgroundHelp =>
      'الفاظ کے پیچھے کیا ہو۔ کچھ نہ ہو تو ہر حرف کا کنارہ گہرا رہتا ہے تاکہ روشن تصویر پر بھی پڑھا جا سکے۔';

  @override
  String get subtitlesBackgroundNone => 'کوئی نہیں';

  @override
  String get subtitlesBackgroundSolid => 'گہرا';

  @override
  String get subtitlesHide => 'سب ٹائٹلز چھپائیں';

  @override
  String get subtitlesLanguage => 'سب ٹائٹل کی زبان';

  @override
  String get subtitlesShow => 'سب ٹائٹلز دکھائیں';

  @override
  String get subtitlesShowHelp =>
      'ویڈیو کے اوپر، ان کلپس کے لیے جن کا ٹرانسکرپٹ ہو۔ پلیئر میں CC بٹن بھی یہی کرتا ہے۔';

  @override
  String get subtitlesSize => 'متن کا سائز';

  @override
  String get subtitlesSizeLarge => 'بڑا';

  @override
  String get subtitlesSizeMedium => 'درمیانہ';

  @override
  String get subtitlesSizeSmall => 'چھوٹا';

  @override
  String tagLimitReached(int max) {
    return 'آپ زیادہ سے زیادہ $max ٹیگز رکھ سکتے ہیں۔ نیا شامل کرنے کے لیے «ٹیگز کا انتظام کریں» میں سے ایک ہٹائیں۔';
  }

  @override
  String get tags => 'ٹیگز';

  @override
  String get tagsOpenFiltered => 'لائبریری فلٹر کے ساتھ کھولتا ہے';

  @override
  String get theme => 'تھیم';

  @override
  String get themeDark => 'گہرا';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeSystem => 'سسٹم';

  @override
  String get titleFilter => 'صرف وہ عنوانات ڈاؤن لوڈ کریں جن میں ہو';

  @override
  String get titleFilterHelp =>
      'اس چینل کی نئی ویڈیو صرف تب ڈاؤن لوڈ ہوتی ہے جب اس کے عنوان میں وہ ہو جو آپ یہاں لکھیں۔\n\n• ایک سادہ لفظ کافی ہے: Episode\n• کئی الفاظ میں سے کوئی ایک: Episode|Part (| کا مطلب ہے «یا»)\n• بڑے چھوٹے حروف سے فرق نہیں پڑتا: episode بھی Episode سے میل کھاتا ہے۔\n\nجس ویڈیو کو فلٹر چھوڑ دے وہ ہمیشہ کے لیے دیکھی ہوئی شمار ہوتی ہے: بعد میں فلٹر ہٹانے سے اس کے بعد آنے والی ویڈیوز ڈاؤن لوڈ ہوتی ہیں، چھوڑی گئی نہیں۔';

  @override
  String get titleFilterHelper =>
      'کئی الفاظ: انہیں | سے الگ کریں۔ سب کچھ کے لیے خالی چھوڑ دیں۔';

  @override
  String get titleFilterHint => 'مثلاً Episode';

  @override
  String get titleLabel => 'عنوان';

  @override
  String totalDuration(Object duration) {
    return 'کل: $duration';
  }

  @override
  String get transcript => 'ٹرانسکرپٹ';

  @override
  String transcriptSaidMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بار اور کہا گیا',
      one: 'ایک بار اور کہا گیا',
    );
    return '$_temp0';
  }

  @override
  String transcriptsClips(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کلپس',
      one: '1 کلپ',
      zero: 'ابھی کوئی کلپ نہیں',
    );
    return '$_temp0';
  }

  @override
  String get transcriptsDeleteAll => 'سب حذف کریں';

  @override
  String get transcriptsDeleteTitle => 'تمام ٹرانسکرپٹس حذف کریں؟';

  @override
  String get transcriptsSaidInside => 'کلپس کے اندر کہا گیا';

  @override
  String get transcriptsSearchHelp =>
      'آپ کے شامل کیے گئے ہر YouTube کلپ کے الفاظ محفوظ رکھتا ہے، تاکہ آپ جو کہا گیا اس میں تلاش کر سکیں۔';

  @override
  String get tryAgain => 'دوبارہ کوشش کریں';

  @override
  String get undo => 'واپس کریں';

  @override
  String get unfollow => 'ان فالو کریں';

  @override
  String unfollowConfirm(String name) {
    return '$name کو ان فالو کریں؟';
  }

  @override
  String get unfollowConfirmBody =>
      'VidHoist بھول جاتی ہے کہ اس چینل کی کون سی ویڈیوز وہ پہلے دیکھ چکی ہے۔ اگر آپ بعد میں اسے دوبارہ فالو کریں تو اس وقت تک اس پر موجود سب کچھ دیکھا ہوا شمار ہو گا، اور جو آپ سے رہ گیا وہ پورا نہیں کیا جائے گا۔ موقوف کرنے سے یہ یادداشت برقرار رہتی ہے۔';

  @override
  String get unlockTouch => 'ان لاک کریں';

  @override
  String get unpinPlaylist => 'پن ہٹائیں';

  @override
  String get updateNoticeBody => 'انسٹال کرنے کے لیے VidHoist کھولیں۔';

  @override
  String get upNext => 'اگلا';

  @override
  String upNextIn(String name) {
    return '«$name» میں اگلا';
  }

  @override
  String get updateAllowInstallBody =>
      'ایپ کو اپنی اپ ڈیٹس انسٹال کرنے سے پہلے Android کو آپ کی اجازت درکار ہے۔ سسٹم کی ترتیبات میں ایک بار اجازت دیں، پھر دوبارہ «انسٹال کریں» پر ٹیپ کریں۔';

  @override
  String get updateAllowInstallTitle => 'اپ ڈیٹس انسٹال کرنے کی اجازت دیں';

  @override
  String get updateAvailable => 'اپ ڈیٹ دستیاب ہے';

  @override
  String get updateCheckFailed => 'اپ ڈیٹس چیک نہیں ہو سکیں';

  @override
  String get updateChecking => 'چیک ہو رہا ہے…';

  @override
  String get updateDownloadFailed => 'اپ ڈیٹ ڈاؤن لوڈ نہیں ہو سکی';

  @override
  String updateDownloadedMb(String done, String total) {
    return '$total MB میں سے $done';
  }

  @override
  String get updateDownloading => 'اپ ڈیٹ ڈاؤن لوڈ ہو رہی ہے…';

  @override
  String get updateFailedToStart => 'انسٹالر نہیں کھل سکا';

  @override
  String get updateInstall => 'انسٹال کریں';

  @override
  String get updateLater => 'بعد میں';

  @override
  String get updateNever => 'ابھی نہیں';

  @override
  String get updateNow => 'اپ ڈیٹ ڈاؤن لوڈ کریں';

  @override
  String get updateOpenSystemSettings => 'ترتیبات کھولیں';

  @override
  String get updateReady => 'انسٹال کے لیے تیار';

  @override
  String updateSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get updateSkipVersion => 'یہ ورژن چھوڑ دیں';

  @override
  String get updateUpToDate => 'آپ کے پاس تازہ ترین ورژن ہے';

  @override
  String updateVersionAvailable(String version) {
    return 'ورژن $version دستیاب ہے';
  }

  @override
  String updateVersionTitle(String version) {
    return 'ورژن $version';
  }

  @override
  String get updateWhatsNew => 'نیا کیا ہے';

  @override
  String get updates => 'اپ ڈیٹس';

  @override
  String get version => 'ورژن';

  @override
  String get videoAdded => 'پلے لسٹ میں شامل ہو گیا';

  @override
  String get videoPlayer => 'ویڈیو پلیئر';

  @override
  String get viewAll => 'سب دیکھیں';

  @override
  String get viewAllInPlaylists => 'سب دیکھیں';

  @override
  String get viewCards => 'کارڈز';

  @override
  String get viewGrid => 'گرڈ';

  @override
  String get viewList => 'فہرست';

  @override
  String get viewMode => 'منظر';

  @override
  String get waitingForWifi => 'Wi-Fi کا انتظار';

  @override
  String get whatsNewGotIt => 'سمجھ گیا';

  @override
  String get whatsNewReleasePage => 'ریلیز کا صفحہ';

  @override
  String get whatsNewThisVersion => 'اس ورژن میں نیا کیا ہے';

  @override
  String whatsNewTitle(String version) {
    return '$version میں نیا کیا ہے';
  }

  @override
  String get whatsNewUnavailable =>
      'اس ورژن میں کیا بدلا، یہ ریلیز کے صفحے پر ہے۔';

  @override
  String get wifiOnly => 'صرف Wi-Fi پر ڈاؤن لوڈ کریں';

  @override
  String get wifiOnlyHelp =>
      'موبائل ڈیٹا پر کچھ ڈاؤن لوڈ نہیں ہوتا۔ ڈاؤن لوڈز Wi-Fi کا انتظار کرتے ہیں، اور جو Wi-Fi منقطع ہونے پر جاری ہو وہ موقوف ہو جاتا ہے اور واپس آنے پر خود بخود جاری ہو جاتا ہے۔';

  @override
  String get yourPlaylists => 'آپ کی پلے لسٹس';

  @override
  String get yourTags => 'آپ کے ٹیگز';

  @override
  String get ytdlpCredit => 'وہ ڈاؤن لوڈر جسے VidHoist چلاتی ہے';
}
