// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'vh_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class VhLocalizationsTr extends VhLocalizations {
  VhLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get about => 'Hakkında';

  @override
  String get aboutApp => 'Uygulama hakkında';

  @override
  String get aboutDescriptionPhone =>
      'Birçok siteden yt-dlp ile video ve ses indiren hafif ve hızlı bir uygulama. Kendi oynatıcısı ve oynatma listeleri vardır.';

  @override
  String get accountSignIn => 'Oturum aç';

  @override
  String get accountSignOut => 'Oturumu kapat';

  @override
  String get accountSignedIn => 'Oturum açık';

  @override
  String get accountSignedOut => 'Oturum açılmadı';

  @override
  String accountSignedOutOf(String site) {
    return '$site oturumu kapatıldı';
  }

  @override
  String get accountsBanRisk =>
      'İkincil bir hesap kullanmak daha iyi olur: yoğun indirme, hesabın site tarafından bir süre kısıtlanmasına yol açabilir.';

  @override
  String get accountsClearAll => 'Tüm çerezleri sil';

  @override
  String get accountsCleared => 'Çerezler silindi';

  @override
  String get accountsFileHint =>
      'Bir tarayıcıdan cookies.txt dosyası olarak (Netscape biçiminde) dışa aktarılır; yukarıda listelenmeyenler dahil her site için geçerlidir. Buradaki oturumlara eklenir ve bu telefonda kalır.';

  @override
  String get accountsFilePick => 'Çerez dosyası seç';

  @override
  String get accountsFileTitle => 'Ya da bir çerez dosyası içe aktarın';

  @override
  String get accountsFromFile => 'Çerez dosyasından';

  @override
  String get accountsHelp =>
      'Oturumların süresi bir süre sonra dolar; bir site yeniden reddetmeye başlarsa bir kez daha oturum açın. Bir sitede oturumu kapatmak, uygulama içi tarayıcıda diğer sitelerin oturumlarını da kapatır; onların indirmeleri eskisi gibi sürer. Bir site burada oturum açmanıza izin vermezse, aşağıdan bilgisayarınızın tarayıcısından bir çerez dosyası içe aktarın.';

  @override
  String get accountsHint =>
      'Oturum açmadan indirmeye izin vermeyen siteler için. Uygulamanın içinde sitenin kendi sayfasında oturum açarsınız; bıraktığı bilgiler bu telefonda kalır, yt-dlp her indirmede bunları okur ve başka hiçbir yere gönderilmez.';

  @override
  String get activeDownloads => 'Etkin indirmeler';

  @override
  String activeDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count indirme sürüyor',
      one: '1 indirme sürüyor',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloadsSheet => 'Etkin indirmeler';

  @override
  String get activeNow => 'Şu an etkin';

  @override
  String get addLinkFab => 'Bağlantı ekle';

  @override
  String get addTo => 'Şuraya ekle…';

  @override
  String get addToFavorites => 'Favorilere ekle';

  @override
  String get addToPlaylist => 'Oynatma listesine ekle';

  @override
  String get addUrl => 'URL ekle';

  @override
  String addedNToServer(int count) {
    return 'İndirmelere eklendi: $count';
  }

  @override
  String get addedToFavorites => 'Favorilere eklendi';

  @override
  String addedToPlaylistCount(int count) {
    return 'Oynatma listesine eklendi: $count';
  }

  @override
  String get allDownloadsFinished => 'Tüm indirmeler bitti.';

  @override
  String get allPlatforms => 'Tüm siteler';

  @override
  String get alreadyInPlaylist => 'Zaten eklendi';

  @override
  String get alreadySubscribed => 'Bu kanal zaten takip ediliyor';

  @override
  String get appTitle => 'VidHoist';

  @override
  String get appearanceAndLanguage => 'Görünüm ve dil';

  @override
  String audioChannels(int count) {
    return '$count kanal';
  }

  @override
  String get audioFormat => 'Ses biçimi';

  @override
  String get audioFormatM4a => 'M4A: her yerde çalar';

  @override
  String get audioFormatMp3 => 'MP3: eski oynatıcılar ve arabalar için';

  @override
  String get audioFormatOriginal => 'Sitenin gönderdiği gibi, dönüştürülmeden';

  @override
  String get audioMono => 'Mono';

  @override
  String get audioOnly => 'Yalnızca ses';

  @override
  String get audioStereo => 'Stereo';

  @override
  String get autoBuilt => 'Otomatik';

  @override
  String get autoCheckUpdates => 'Otomatik denetle';

  @override
  String get autoCheckUpdatesHelp =>
      'Arka planda günde yaklaşık iki kez yeni sürüm arar.';

  @override
  String get autoRestoreSuccess => 'Veriler yedekten geri yüklendi.';

  @override
  String get autoRetry => 'Ağ geri gelince yeniden dene';

  @override
  String get autoRetryHelp =>
      'Ağ kesildiği için başarısız olan her şey, ağ geri geldiğinde kendiliğinden yeniden denenir. Bir sitenin reddettiği şeyler yeniden denenmez: aynısını tekrarlamak yine başarısız olur.';

  @override
  String get backgroundChecks => 'Uygulama kapalıyken denetle';

  @override
  String get backgroundChecksHelp =>
      'Yaklaşık altı saatte bir, ağ varken ve pil zayıf değilken. Yalnızca yenilerini bildirir; videolar VidHoist\'i açtığınızda indirilir.';

  @override
  String get backgroundDownload => 'Dosyalar arka planda indiriliyor…';

  @override
  String backgroundLastRun(String when) {
    return 'Uygulama kapalıyken son denetim: $when';
  }

  @override
  String get backgroundNotRunYet =>
      'Uygulama kapalıyken henüz denetim yapılmadı: zamanı Android seçer.';

  @override
  String get backgroundOfferBody =>
      'VidHoist kanallarınıza yaklaşık altı saatte bir bakıp yenilerini size bildirebilir. Uygulamayı açana kadar hiçbir şey indirilmez.';

  @override
  String get backgroundOfferNo => 'Şimdi değil';

  @override
  String get backgroundOfferTitle =>
      'VidHoist kapalıyken yeni videolardan haberdar olmak ister misiniz?';

  @override
  String get backgroundOfferYes => 'Aç';

  @override
  String get backupNote =>
      'Kitaplık, oynatma listeleri, etiketler, takip edilen kanallar ve ayarlar dahildir. Oturumlar ve transkriptler ayrı tutulur; medya dosyalarının kendisi dahil değildir.';

  @override
  String get backupSettings => 'Tüm verileri yedekle';

  @override
  String get backupSettingsSubtitle =>
      'Kendini yenileyen yedi tarihli kopya. Herhangi birini geri yükleyin ya da paylaşmak için dışa aktarın';

  @override
  String backupSuccess(Object path) {
    return 'Yedek kaydedildi: $path';
  }

  @override
  String backupsKept(int count) {
    return 'Saklanan yedek: $count';
  }

  @override
  String get batchDownloadSelected => 'Seçilenleri indir';

  @override
  String get batchLoading => 'Oynatma listesi okunuyor…';

  @override
  String get batchNothingSelected => 'En az bir öğe seçin';

  @override
  String batchSelectedOf(int selected, int total) {
    return '$selected / $total seçildi';
  }

  @override
  String get batchThisVideoOnly => 'Yalnızca bu klibi indir';

  @override
  String get batchTitle => 'Toplu indirme';

  @override
  String get batteryAllow => 'İzin ver';

  @override
  String get batteryFree =>
      'Pil tasarrufu, uygulama görünmezken bile indirmelere dokunmaz.';

  @override
  String get batteryRestricted =>
      'Pil tasarrufu, uygulama görünmezken uzun bir indirmeyi durdurabilir.';

  @override
  String get batteryStateFree => 'İzin verildi';

  @override
  String get batteryStateLimited => 'Kısıtlı';

  @override
  String get batteryTitle => 'Arka planda indirme';

  @override
  String bitrateKbps(String value) {
    return '$value kb/sn';
  }

  @override
  String bitrateMbps(String value) {
    return '$value Mb/sn';
  }

  @override
  String get builtWith => 'Şunlarla geliştirildi';

  @override
  String get cancel => 'İptal';

  @override
  String get changeQuality => 'Kaliteyi değiştir';

  @override
  String get channelNameFolder => 'Kanalın adıyla';

  @override
  String channelFollowers(String count) {
    return '$count abone';
  }

  @override
  String get channelCheckFailed =>
      'Bu sefer denetlenemedi. VidHoist kendiliğinden yeniden dener.';

  @override
  String get channelUrl =>
      'Bir kanalın, oynatma listesinin ya da videolarından birinin bağlantısı';

  @override
  String get channelUrlHint => 'https://www.youtube.com/@name';

  @override
  String chapterNumber(int number) {
    return 'Bölüm $number';
  }

  @override
  String get chaptersFold => 'Bölümleri gizle';

  @override
  String chaptersFromTranscript(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Transkriptten $count bölüm',
      one: 'Transkriptten 1 bölüm',
    );
    return '$_temp0';
  }

  @override
  String get chaptersShowAll => 'Tüm bölümleri gör';

  @override
  String get chaptersUnfold => 'Bölümleri göster';

  @override
  String get checkEvery => 'Ne sıklıkla bakılsın';

  @override
  String get checkForUpdates => 'Güncellemeleri denetle';

  @override
  String get checkNow => 'Şimdi denetle';

  @override
  String get checkQueued =>
      'Şimdi denetleniyor. Yeni ne varsa kitaplıkta görünür.';

  @override
  String get chooseFolder => 'Klasör seç';

  @override
  String get chooseOptions => 'Seçenekler';

  @override
  String get clear => 'Temizle';

  @override
  String get clearLogs => 'Günlükleri temizle';

  @override
  String get clearLogsConfirm => 'Tüm tanılama günlükleri silinsin mi?';

  @override
  String get clipEndAfterStart => 'Başlangıçtan sonra olmalı';

  @override
  String get clipFrom => 'Başlangıç';

  @override
  String clipLength(Object length) {
    return 'Video süresi: $length';
  }

  @override
  String get clipLengthReading => 'Videonun süresi okunuyor…';

  @override
  String get clipLengthUnknown =>
      'Site videonun süresini bildirmiyor, bu yüzden zamanlar denetlenmiyor';

  @override
  String get clipMinuteDown => 'Bir dakika önce';

  @override
  String get clipMinuteUp => 'Bir dakika sonra';

  @override
  String get clipOnly => 'Videonun yalnızca bir kısmı';

  @override
  String get clipOnlyHelp =>
      'Bir andan diğerine kadar, gerisi olmadan. Altyazısız gelir.';

  @override
  String clipPastEnd(Object length) {
    return 'Videonun sonu: $length';
  }

  @override
  String get clipTimeHint => 'Yalnızca rakam: 130, 1:30 demektir';

  @override
  String get clipTo => 'Bitiş';

  @override
  String get clipboardFound => 'Panonuzda bir bağlantı hazır';

  @override
  String get clipboardLinkReady => 'Bağlantıyı yapıştır';

  @override
  String get closePlayer => 'Oynatıcıyı kapat';

  @override
  String get columnAdded => 'Eklenme';

  @override
  String get columnLength => 'Süre';

  @override
  String get compactView => 'Kompakt görünüm';

  @override
  String get compatiblePlayback => 'En iyi oynatma uyumluluğu';

  @override
  String get compatiblePlaybackHelp =>
      'Her telefonun donanımla çözdüğü H.264/AAC\'yi ister. Bu olmadan YouTube AV1 gönderebilir; birçok cihaz bunu bozuk görüntüyle oynatır. Kapatmak, uyumluluk pahasına en yüksek çözünürlüğe izin verir.';

  @override
  String get completed => 'Tamamlandı';

  @override
  String get continueAsAudio => 'Ses olarak sürdür';

  @override
  String get continueAsAudioBody =>
      'Aynı saniyeden ses olarak çalmaya devam edilsin mi?';

  @override
  String get continueAsAudioNo => 'Hayır, durdur';

  @override
  String get continueAsAudioTitle => 'Arka planda sürdürülsün mü?';

  @override
  String get cookies => 'Çerezler';

  @override
  String get cookiesNotNetscape =>
      'Bu dosyaların hiçbirinde Netscape biçiminde çerez yok';

  @override
  String get cookiesSubtitle =>
      'Oturum açmadan indirmeye izin vermeyen siteler için';

  @override
  String get copiedToClipboard => 'Panoya kopyalandı';

  @override
  String get copyright => '© 2026 Yasir Sagheer';

  @override
  String get couldNotLoadPlaylist =>
      'Bu oynatma listesi yüklenemedi. URL\'yi ve bağlantınızı kontrol edin.';

  @override
  String get create => 'Oluştur';

  @override
  String get createPlaylist => 'Oynatma listesi oluştur';

  @override
  String get defaultQuality => 'Varsayılan video kalitesi';

  @override
  String get delete => 'Sil';

  @override
  String deleteMultipleConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count klip silinsin mi?\n\nDosyaları cihazınızdan kaldırılır.',
      one: '1 klip silinsin mi?\n\nDosyası cihazınızdan kaldırılır.',
    );
    return '$_temp0';
  }

  @override
  String deletePlaylistConfirm(Object name) {
    return '\"$name\" silinsin mi?';
  }

  @override
  String get deleteRefused =>
      'Silinmedi: Android bu dosyayı silmek için, gösterdiği pencerede izninizi istiyor.';

  @override
  String get deleteSelected => 'Seçilenleri sil';

  @override
  String get deleteTag => 'Etiketi sil';

  @override
  String deleteTagConfirm(Object tag) {
    return '\"$tag\" etiketi tüm öğelerden silinsin mi? Kliplerin kendisi silinmez.';
  }

  @override
  String get deleteVideo => 'Klibi sil';

  @override
  String deleteVideoConfirm(Object title) {
    return '\"$title\" silinsin mi?\n\nDosya cihazınızdan kaldırılacak.';
  }

  @override
  String deletedCount(Object count) {
    return 'Silindi: $count';
  }

  @override
  String deletedTitle(Object title) {
    return 'Silindi: $title';
  }

  @override
  String get deselectAll => 'Seçimi kaldır';

  @override
  String desktopAddLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bağlantı ekle',
      one: '1 bağlantı ekle',
      zero: 'Eklenecek bir şey yok',
    );
    return '$_temp0';
  }

  @override
  String get desktopBack => 'Geri';

  @override
  String get desktopBackUpNow => 'Şimdi yedekle';

  @override
  String get desktopBackupHint =>
      'Bu bilgisayar son yedi yedeğini, aralarında en az bir saat olacak şekilde Downloads\\VidHoist\\Backups içinde saklar; orada uygulama kaldırılsa bile kalırlar.';

  @override
  String get desktopBackupsNone => 'Henüz yedek yok';

  @override
  String get desktopBrowserButton => 'Tarayıcıda “VidHoist\'e gönder” düğmesi';

  @override
  String get desktopBrowserButtonCopied =>
      'Kod kopyalandı. Yeni bir yer imi oluşturun ve kodu adresine (URL) yapıştırın.';

  @override
  String get desktopBrowserButtonCopy => 'Kodu kopyala';

  @override
  String get desktopBrowserButtonFailed =>
      'Sayfa açılamadı; bunun yerine kodu kopyalayın.';

  @override
  String get desktopBrowserButtonHint =>
      'Yer imleri çubuğunuzda bir düğme: herhangi bir video sayfasında tek tıklama, buradaki ekleme penceresini o bağlantıyla açar. Ekle\'ye basana kadar hiçbir şey gönderilmez.';

  @override
  String get desktopBrowserButtonName => 'VidHoist\'e gönder';

  @override
  String get desktopBrowserButtonOpen => 'Kurulum sayfasını aç';

  @override
  String get desktopBrowserPageCopyInstead =>
      'Sürükleme işe yaramazsa yeni bir yer imi oluşturun ve adresine bunu yapıştırın:';

  @override
  String get desktopBrowserPageDragHint =>
      'Çubuğa sürükleyin; buraya tıklamak bir şey yapmaz.';

  @override
  String get desktopBrowserPageStep1 =>
      'Gizliyse yer imleri çubuğunu gösterin:';

  @override
  String get desktopBrowserPageStep2 =>
      'Aşağıdaki düğmeyi fareyle çubuğa sürükleyin.';

  @override
  String get desktopBrowserPageStep3 =>
      'Herhangi bir video sayfasında ona tıklayın: VidHoist, ekleme penceresini bağlantıyla açar. İlk seferde tarayıcı uygulamanın açılıp açılmayacağını sorar; izin verin.';

  @override
  String get desktopBrowserPageTitle =>
      '“VidHoist\'e gönder” düğmesini tarayıcınıza ekleyin';

  @override
  String get desktopChangeFolder => 'Değiştir…';

  @override
  String get desktopChannel => 'Kanal';

  @override
  String get desktopChannelClips => 'Kitaplığınızda';

  @override
  String get desktopChannels => 'Kanallar';

  @override
  String get desktopChannelsInLibrary => 'Kitaplığınızdaki kanallar';

  @override
  String get desktopChannelsLater => 'İndirme motoru gerekli';

  @override
  String get desktopChannelsLaterBody =>
      'Kanal takip etmek için bu bilgisayarda yt-dlp gerekir. Ayarlar › Motor bölümünden kurun, kanallarınız burada görünsün.';

  @override
  String get desktopChapters => 'Bölümler';

  @override
  String get desktopCheckAll => 'Tümünü denetle';

  @override
  String get desktopChooseClip => 'Seç';

  @override
  String get desktopClearFilters => 'Filtreleri temizle';

  @override
  String get desktopClearSelection => 'Seçimi temizle';

  @override
  String get desktopCookiesBrowser => 'Bir tarayıcıdan';

  @override
  String get desktopCookiesBrowserHint =>
      'Oturum açtığınız tarayıcıdan okunur. Okunamazsa o tarayıcıyı kapatıp yeniden deneyin.';

  @override
  String get desktopCookiesChoose => 'Dosya seç…';

  @override
  String get desktopCookiesFile => 'Çerez dosyası';

  @override
  String get desktopCookiesHelp =>
      'Tarayıcınızda çerezleri Netscape biçiminde dışa aktaran bir eklenti kullanın (site başına bir dosya) ve dosyaları burada birlikte seçin. yt-dlp bunları her indirmede kullanır. Çerezlerin süresi dolar; yeniden başarısız olmaya başlayan bir indirme genellikle yeni bir dışa aktarma zamanının geldiğini gösterir.';

  @override
  String get desktopCookiesKept => 'Bu bilgisayarda saklanan çerezler';

  @override
  String desktopCookiesKeptFor(String sites) {
    return 'Çerezi saklanan siteler: $sites';
  }

  @override
  String get desktopCookiesLocalHint =>
      'Oturum açmanızı gerektiren siteler için. yt-dlp bunları bu bilgisayarda okur ve başka hiçbir yere gönderilmezler.';

  @override
  String get desktopCookiesNone => 'Yok';

  @override
  String get desktopCookiesRemove => 'Kaldır';

  @override
  String get desktopCopiedLinkAdd => 'Ekle…';

  @override
  String get desktopCopiedLinkTitle => 'Bu bağlantı indirilsin mi?';

  @override
  String get desktopCopyFile => 'Dosyayı kopyala';

  @override
  String get desktopCopyFileFailed => 'Dosya kopyalanamadı';

  @override
  String get desktopCopyLink => 'Bağlantıyı kopyala';

  @override
  String get desktopCopyOneClip =>
      'Bir seferde yalnızca bir klip kopyalanabilir';

  @override
  String get desktopCopyQuote => 'Zaman ve bağlantıyla kopyala';

  @override
  String get desktopDefaultQualityHint =>
      'Her eklemenin başlangıç değeri; yine de her bağlantı için değiştirebilirsiniz.';

  @override
  String desktopDeleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count klip silinsin mi? Bu bilgisayardaki dosyaları silinir.',
      one: '1 klip silinsin mi? Bu bilgisayardaki dosyası silinir.',
    );
    return '$_temp0';
  }

  @override
  String get desktopDesktopSection => 'Windows';

  @override
  String get desktopDiscover => 'VidHoist\'i keşfedin';

  @override
  String get desktopDiscoverAddLink => 'Bağlantı yapıştırın ya da bırakın';

  @override
  String get desktopDiscoverAddLinkLine =>
      'Eklemek için herhangi bir yerde Ctrl+V\'ye basın ya da bağlantıyı pencereye bırakın.';

  @override
  String get desktopDiscoverAdding => 'Ekleme ve paylaşma';

  @override
  String get desktopDiscoverBrowser => 'Tarayıcıdan';

  @override
  String get desktopDiscoverBrowserLine =>
      'Yer imleri çubuğunuzdaki “VidHoist\'e gönder” düğmesi, bulunduğunuz sayfayla ekleme penceresini açar.';

  @override
  String get desktopDiscoverChapters => 'Bölümler';

  @override
  String get desktopDiscoverChaptersLine =>
      'Bir klibin transkriptinden çıkarılan kısımları, kendi sayfasında.';

  @override
  String get desktopDiscoverChoose => 'Çoklu seçim';

  @override
  String get desktopDiscoverChooseLine =>
      'Yuvarlak işaret ya da Ctrl veya Shift ile tıklama; sonra hepsini bir listeye ekleyin ya da birlikte silin.';

  @override
  String get desktopDiscoverDragOut => 'Klibi dışarı sürükleyin';

  @override
  String get desktopDiscoverDragOutLine =>
      'Bir klasöre ya da başka bir uygulamaya bırakın, oraya dosya olarak ulaşır.';

  @override
  String get desktopDiscoverExport => 'Transkripti dışa aktarın';

  @override
  String get desktopDiscoverExportLine =>
      'Metin olarak ya da başka bir oynatıcı için SRT altyazısı olarak.';

  @override
  String get desktopDiscoverHint =>
      'Uygulamanın yapabildiği her şey, her biri bir satırda, tuşlarıyla birlikte.';

  @override
  String get desktopDiscoverLibrary => 'Kitaplık';

  @override
  String get desktopDiscoverListening =>
      'Ses için: tam ekranda, kapağı büyük, sakin bir oda.';

  @override
  String get desktopDiscoverMini => 'Küçük pencere';

  @override
  String get desktopDiscoverMiniLine =>
      'Ekranın alt köşesinde, tüm pencerelerin üstünde duran küçük bir kart.';

  @override
  String get desktopDiscoverReading =>
      'Makale gibi transkript: oradan dinlemek için bir cümleye tıklayın.';

  @override
  String get desktopDiscoverSaid => 'Söylenenler';

  @override
  String get desktopDiscoverSearch => 'Söylenenlerde arayın';

  @override
  String get desktopDiscoverSearchLine =>
      'Bir kelimenin söylendiği klipleri bulun; yalnızca başlıklarda değil.';

  @override
  String get desktopDiscoverShortcutsLine =>
      'Pencerenin yanıt verdiği tüm tuşlar, tek bir sayfada.';

  @override
  String get desktopDiscoverShow => 'Göster';

  @override
  String get desktopDiscoverStatsLine =>
      'Kitaplığın dökümü: siteye, kanala ve aya göre.';

  @override
  String get desktopDiscoverSubtitles =>
      'Görüntünün üzerinde transkript, söylenen kelime vurgulu.';

  @override
  String get desktopDiscoverTheater =>
      'Yan panelin yerini alan daha büyük bir görüntü.';

  @override
  String get desktopDiscoverTry => 'Deneyin';

  @override
  String get desktopDiscoverWatching => 'İzleme ve dinleme';

  @override
  String get desktopDownloadFolder => 'İndirme klasörü';

  @override
  String get desktopDownloadFolderHint =>
      'İndirilenler buraya sıradan dosyalar olarak kaydedilir; diğer dosyalar gibi açabilir, taşıyabilir ya da yedekleyebilirsiniz.';

  @override
  String get desktopDownloads => 'İndirmeler';

  @override
  String get desktopDownloadsEmpty =>
      'Şu anda indirme yok. Başlamak için bir bağlantı ekleyin.';

  @override
  String get desktopDownloadsRunning => 'Sürüyor';

  @override
  String get desktopDragToReorder => 'Sıralamak için sürükleyin';

  @override
  String get desktopDropLinks => 'Eklemek için bırakın';

  @override
  String get desktopEmptyLibraryLocal =>
      'Bir bağlantı ekleyin; klip indirildiğinde burada görünür.';

  @override
  String get desktopEmptyLibraryMessage =>
      'Bir bağlantı ekleyin; klip indirildiğinde burada görünür.';

  @override
  String get desktopEngine => 'Motor';

  @override
  String get desktopEngineDenoHint =>
      'YouTube\'un denetimini yanıtlar, böylece sunduğu her kalite indirilebilir';

  @override
  String get desktopEngineFetch => 'Getir';

  @override
  String get desktopEngineFetchCorrupt =>
      'Gelen dosya yayımlanan dosya değildi, bu yüzden kullanılmadı.';

  @override
  String get desktopEngineFetchFailed =>
      'Getirilemedi. Bağlantıyı kontrol edip yeniden deneyin.';

  @override
  String get desktopEngineFetchInUse =>
      'Bir indirme tarafından kullanılıyor. Bittiğinde yeniden deneyin.';

  @override
  String desktopEngineFetching(int percent) {
    return 'Getiriliyor · %$percent';
  }

  @override
  String get desktopEngineFfmpegHint =>
      'Görüntü ile sesi birleştirir ve sesi dönüştürür';

  @override
  String get desktopEngineIpv4 => 'Yalnızca IPv4 kullan';

  @override
  String get desktopEngineIpv4Hint =>
      'Birçok ev ağında olduğu gibi IPv6\'nın bozuk olduğu yerlerde çok daha hızlıdır. Yalnızca ağınızda sadece IPv6 varsa kapatın.';

  @override
  String get desktopEngineMissing =>
      'yt-dlp bu bilgisayarda yok. VidHoist\'i yeniden kurun ya da buradan getirin.';

  @override
  String get desktopEngineOnFirstUse => 'Gerektiren ilk indirmede getirilir';

  @override
  String get desktopEngineUpToDate => 'yt-dlp güncel';

  @override
  String get desktopEngineUpdate => 'yt-dlp\'yi güncelle';

  @override
  String get desktopEngineUpdateFailed =>
      'Güncelleme tamamlanamadı. Daha sonra yeniden deneyin.';

  @override
  String get desktopEngineUpdateHint =>
      'Siteler sık değişir; eski bir yt-dlp birkaç ay içinde çalışmaz olur.';

  @override
  String desktopEngineUpdated(String version) {
    return 'yt-dlp güncellendi: $version';
  }

  @override
  String get desktopEngineUpdating => 'Güncelleniyor…';

  @override
  String desktopEngineVersion(String version) {
    return 'Sürüm $version';
  }

  @override
  String get desktopEngineYtDlpHint => 'Bağlantıyı okur ve indirir';

  @override
  String get desktopExport => 'Dışa aktar';

  @override
  String get desktopExportForPhone => 'Telefon için dışa aktar';

  @override
  String get desktopExportForPhoneHint =>
      'Bu bilgisayarın etiketlerini, listelerini, kaldığı yerleri ve transkriptlerini, telefonun geri yüklediği iki dosya olarak kaydeder. Telefonda geri yükleme, telefonun kendi etiketlerinin ve listelerinin yerini alır.';

  @override
  String get desktopExportMarkdown => 'Metin (Markdown)';

  @override
  String get desktopExportPdf => 'Belge (PDF)';

  @override
  String get desktopExportPhone => 'Telefon için (VidHoist içe aktarma)';

  @override
  String get desktopExportSrt => 'Altyazı (SRT)';

  @override
  String desktopExported(String name) {
    return 'Kaydedildi: $name';
  }

  @override
  String desktopFileReadyToPaste(String name, String size) {
    return 'Yapıştırmaya hazır: $name · $size';
  }

  @override
  String get desktopFolderUnavailable => 'Kullanılabilir klasör yok';

  @override
  String get desktopFolders => 'Klasörler';

  @override
  String get desktopForward => 'İleri';

  @override
  String get desktopGlobalShortcut => 'Her uygulamadan oynat ve duraklat';

  @override
  String desktopGlobalShortcutHint(String keys) {
    return 'Pencere başka uygulamaların arkasındayken $keys oynatır ve duraklatır.';
  }

  @override
  String desktopGlobalShortcutTaken(String keys) {
    return '$keys zaten başka bir uygulama tarafından kullanılıyor.';
  }

  @override
  String get desktopHidePanel => 'Yan paneli gizle';

  @override
  String get desktopHintShortcuts =>
      'Klavye kısayolları için ? tuşuna basın. Boşluk oynatır ve duraklatır; ok tuşları ileri geri sarar.';

  @override
  String get desktopHintShortcutsAction => 'Kısayollar';

  @override
  String get desktopHintTrayBody =>
      'Saatin yanındaki simgesinden çalmayı sürdürür. Çıkmak için simgeye sağ tıklayın.';

  @override
  String get desktopHintTrayTitle => 'VidHoist hâlâ çalışıyor';

  @override
  String get desktopHints => 'İpuçlarını göster';

  @override
  String get desktopHintsAgain => 'Yeniden göster';

  @override
  String get desktopHintsHint =>
      'Her biri bir kez gösterilen iki kısa ipucu: ilk klipte kısayollar, ilk kapatışta saatin yanındaki simge.';

  @override
  String get desktopImportFromPhone => 'Yedek ya da transkript içe aktar…';

  @override
  String get desktopImportHint =>
      'VidHoist\'ten bir yedek ya da transkript dosyası; burada seçin ya da pencereye bırakın. Telefondan gelen dosya buradakilere eklenir; bu bilgisayarın yedeği ise sorulduktan sonra tümüyle geri yüklenir.';

  @override
  String desktopImportedBackup(int tagged, int lists, int positions) {
    return 'Telefondan eklendi. Etiketler: $tagged · listeler: $lists · kalınan yerler: $positions';
  }

  @override
  String get desktopImportedNothing =>
      'Yeni bir şey yok: bu bilgisayarda hepsi zaten vardı.';

  @override
  String desktopImportedTranscripts(int count) {
    return 'Eklenen transkriptler: $count';
  }

  @override
  String desktopInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kitaplığınızda $count klip',
      one: 'Kitaplığınızda 1 klip',
    );
    return '$_temp0';
  }

  @override
  String get desktopKeepAwake => 'İndirirken bilgisayarı uyanık tut';

  @override
  String get desktopKeepAwakeHint =>
      'Böylece telefondan gönderilen bir bağlantı ya da uzun bir oynatma listesi, Windows uyku moduna geçtiğinde durmak yerine tamamlanır. Ekran yine her zamanki gibi kapanır.';

  @override
  String get desktopKeyAddLink => 'Kopyaladığınız bağlantıyı ekle';

  @override
  String get desktopKeyFavorite => 'Favorilere ekle ya da çıkar';

  @override
  String get desktopKeyFullScreen => 'Tam ekran; ses için dinleme odası';

  @override
  String get desktopKeyMenu => 'Klibin menüsü';

  @override
  String get desktopKeyMini =>
      'Diğerlerinin üstünde küçük pencere ve geri dönüş';

  @override
  String get desktopKeyPlayPause => 'Oynat ya da duraklat';

  @override
  String get desktopKeyRepeat => 'Tekrarı değiştir';

  @override
  String get desktopKeySearch => 'Başlıklarda ve söylenenlerde ara';

  @override
  String get desktopKeySeek => '10 saniye geri ya da ileri';

  @override
  String get desktopKeyShortcuts => 'Bu liste';

  @override
  String get desktopKeyVolume =>
      'Sesi aç ya da kıs; Shorts\'ta önceki ya da sonraki';

  @override
  String get desktopKeyZoomIn => 'Arayüzü büyüt';

  @override
  String get desktopKeyZoomOut => 'Arayüzü küçült';

  @override
  String get desktopKeyZoomReset => 'Arayüzü normal boyuta getir';

  @override
  String get desktopLanguageSystemHint => 'Windows\'un dilini kullanır.';

  @override
  String desktopLastArrival(String when) {
    return 'Son gelen: $when';
  }

  @override
  String get desktopLess => 'Daha az';

  @override
  String get desktopLibraryLoading => 'Kitaplık yükleniyor…';

  @override
  String get desktopLinkCopied => 'Bağlantı kopyalandı';

  @override
  String get desktopLinkDuplicate => 'Yukarıda tekrarlanıyor';

  @override
  String get desktopLinkInLibrary => 'Zaten kitaplığınızda';

  @override
  String get desktopLinkPlaylist => 'Bir oynatma listesi: kliplerini seçin';

  @override
  String get desktopLinkReady => 'Hazır';

  @override
  String get desktopLinkUnsupported => 'Bu uygulamanın tanımadığı bir site';

  @override
  String desktopLinksDropped(int count, int limit) {
    return 'Yalnızca ilk $limit bağlantı alındı; $count bağlantı dışarıda kaldı.';
  }

  @override
  String desktopLinksFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bağlantı',
      one: '1 bağlantı',
    );
    return '$_temp0';
  }

  @override
  String get desktopListeningClose => 'Dinleme odasını kapat';

  @override
  String get desktopListeningRoom => 'Dinleme odası';

  @override
  String get desktopLogsCopied =>
      'Günlük, bağlantılar ve adresler olmadan kopyalandı';

  @override
  String get desktopLogsCopy => 'Kopyala';

  @override
  String get desktopLogsSave => 'Dosyaya kaydet';

  @override
  String get desktopMiniRestore => 'Tam pencereye dön';

  @override
  String get desktopMiniWindow => 'Küçük pencere';

  @override
  String get desktopMore => 'Daha fazla';

  @override
  String get desktopNarrowSidebar => 'Kenar çubuğunu daralt';

  @override
  String get desktopNoChannelNames =>
      'Kitaplığınızdaki klipler kanallarını belirtmiyor, bu yüzden bu kanalın klipleri ayırt edilemiyor. Kanalı kendi klasörüyle takip edin; oraya gelen her şey burada görünür.';

  @override
  String get desktopNoFavoritesMessage =>
      'Bir klibi favori olarak işaretleyin, sizi burada bekler.';

  @override
  String get desktopNoFavoritesTitle => 'Henüz favori yok';

  @override
  String get desktopNoMatchMessage =>
      'Daha fazlasını görmek için bir filtreyi temizleyin.';

  @override
  String get desktopNoMatchTitle => 'Bu filtrelere uyan bir şey yok';

  @override
  String get desktopNoTags =>
      'Henüz etiket yok. Bir klibi kendi sayfasından etiketleyin, burada görünür.';

  @override
  String get desktopNoTranscriptMessage =>
      'Klibin altyazıları onunla birlikte indirildiğinde burada görünür.';

  @override
  String get desktopNoTranscriptTitle => 'Bu klibin transkripti yok';

  @override
  String get desktopNotABackup =>
      'Bu dosya bir VidHoist yedeği ya da transkript dosyası değil.';

  @override
  String desktopNotWatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count izlenmemiş',
      one: '1 izlenmemiş',
    );
    return '$_temp0';
  }

  @override
  String get desktopNothingPlaying => 'Çalan bir şey yok';

  @override
  String get desktopNothingPlayingHint =>
      'Bir klip oynatın; transkripti, sırada ne olduğu ve ayrıntıları burada görünür.';

  @override
  String get desktopNotifyArrivalsHint =>
      'Takip ettiğiniz kanallardan yeni klipler indirildiğinde bir Windows bildirimi.';

  @override
  String get desktopOfferCopiedLinks => 'Kopyaladığım bağlantıları öner';

  @override
  String get desktopOfferCopiedLinksHint =>
      'Başka bir uygulamada bir video bağlantısı kopyaladığınızda, bir bildirim onu eklemeyi önerir. Yalnızca bağlantılara bakılır ve hiçbiri kaydedilmez.';

  @override
  String get desktopOpenBackup => 'Yedeği aç';

  @override
  String get desktopOpenChannels => 'Kanalları aç';

  @override
  String get desktopOpenInExplorer => 'Dosya Gezgini\'nde aç';

  @override
  String get desktopOpenWith => 'Başka bir oynatıcıda aç…';

  @override
  String get desktopPaletteClose => 'kapat';

  @override
  String get desktopPaletteCommands => 'Komutlar';

  @override
  String get desktopPaletteHint =>
      'Başlıklarda ve söylenenlerde arayın ya da komutlar için > yazın';

  @override
  String desktopPaletteList(String name) {
    return 'Liste: $name';
  }

  @override
  String get desktopPaletteMove => 'gezin';

  @override
  String get desktopPaletteOpen => 'aç';

  @override
  String get desktopPaletteSaid => 'Kliplerde söylenenler';

  @override
  String get desktopPaletteSave => 'Bu aramayı kaydet';

  @override
  String desktopPaletteSettings(String section) {
    return 'Ayarlar: $section';
  }

  @override
  String get desktopPaletteTitles => 'Başlıklar';

  @override
  String get desktopPinned => 'Sabitlenenler';

  @override
  String get desktopPlayNext => 'Sıradaki olarak oynat';

  @override
  String get desktopPlaysNext => 'Bundan sonra çalacak';

  @override
  String get desktopQueueEnd => 'Bundan sonra bir şey yok';

  @override
  String desktopQuote(String text, String title, String time, String link) {
    return '“$text”\n— $title, $time\n$link';
  }

  @override
  String get desktopQuoteCopied => 'Zamanı ve bağlantısıyla kopyalandı';

  @override
  String get desktopReadingBack => 'Klibe dön';

  @override
  String get desktopReadingCloseFind => 'Aramayı kapat';

  @override
  String get desktopReadingFind => 'Metinde bul';

  @override
  String desktopReadingFound(int at, int count) {
    return '$at / $count';
  }

  @override
  String get desktopReadingHint =>
      'Oradan dinlemek için bir cümleye tıklayın · Ctrl+F kelime bulur · zamanıyla kopyalamak için seçin';

  @override
  String get desktopReadingNextMatch => 'Sonraki eşleşme';

  @override
  String get desktopReadingPreviousMatch => 'Önceki eşleşme';

  @override
  String get desktopReadingRoom => 'Okuma odası';

  @override
  String get desktopRecoverLibrary => 'Klasörde zaten olan klipler';

  @override
  String get desktopRecoverLibraryAction => 'Klasöre bak';

  @override
  String get desktopRecoverLibraryHint =>
      'Yeniden kurulumdan sonra: indirme klasöründe olup artık listede görünmeyen klipleri kitaplığa geri koyar. Dosyalara dokunulmaz.';

  @override
  String desktopRecovered(int count) {
    return 'Kitaplığa geri kondu: $count';
  }

  @override
  String get desktopRecoveredNothing =>
      'Eklenecek bir şey yok: klasördeki her klip kitaplıkta.';

  @override
  String desktopRecoveredSome(int count, int left) {
    return 'Kitaplığa geri kondu: $count. Bağlantısı bilinmediği için dışarıda kalan: $left';
  }

  @override
  String get desktopRemoveFromList => 'Listeden kaldır';

  @override
  String get desktopRestore => 'Geri yükle';

  @override
  String get desktopRestoreBody =>
      'Bu bilgisayarın kitaplığı, takip edilen kanalları, etiketleri, listeleri ve ayarları yedektekiyle değiştirilir. İndirilen dosyalara dokunulmaz.';

  @override
  String desktopRestoreOfferBody(String when) {
    return 'Downloads\\VidHoist\\Backups klasöründe bu bilgisayarın bir yedeği var: kitaplığı, takip edilen kanalları, oynatma listeleri, etiketleri, ayarları ve kayıtlı transkriptleri. En yenisi şu zaman alındı: $when. Hangisini seçerseniz seçin, indirdiğiniz dosyalara dokunulmaz.';
  }

  @override
  String get desktopRestoreOfferTitle => 'Yedeğiniz geri yüklensin mi?';

  @override
  String get desktopRestoreTitle => 'Bu yedek geri yüklensin mi?';

  @override
  String get desktopRestored => 'Yedek geri yüklendi';

  @override
  String get desktopRevealAfterDownload => 'Bitince Dosya Gezgini\'nde göster';

  @override
  String get desktopRevealAfterDownloadHint =>
      'Bu bilgisayara indirilen bir dosya bittiğinde, klasörü dosya seçili olarak açılır.';

  @override
  String desktopSavedIn(String folder) {
    return 'Kaydedildiği yer: $folder';
  }

  @override
  String desktopSavedSearchDelete(String name) {
    return 'Kayıtlı arama “$name” silinsin mi? Kitaplıkta hiçbir şey değişmez.';
  }

  @override
  String get desktopSavedSearchName => 'Arama adı';

  @override
  String get desktopSearch => 'Ara';

  @override
  String get desktopSearchHint => 'Başlıklarda ve söylenenlerde ara…';

  @override
  String get desktopSearchSaved => 'Kenar çubuğuna kaydedildi';

  @override
  String get desktopSeekBar => 'Klipteki konum';

  @override
  String desktopSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seçili',
      one: '1 seçili',
    );
    return '$_temp0';
  }

  @override
  String get desktopSetupChooseFile => 'Dosya seç…';

  @override
  String get desktopShortcutsApp => 'Uygulama';

  @override
  String get desktopShortcutsClip => 'Seçili klipte';

  @override
  String get desktopShortcutsPlayback => 'Oynatma';

  @override
  String get desktopShortcutsTitle => 'Klavye kısayolları';

  @override
  String get desktopShortcutsWindow => 'Pencere';

  @override
  String get desktopShortsHint =>
      'Sonraki Shorts videosu için ↑ ↓ ya da tekerlek · favorilere eklemek için çift tıklayın';

  @override
  String get desktopShowInFolder => 'Klasörde göster';

  @override
  String get desktopShowPanel => 'Yan paneli göster';

  @override
  String get desktopStartFresh => 'Sıfırdan başla';

  @override
  String get desktopStartWithWindows => 'Windows ile başlat';

  @override
  String get desktopStartWithWindowsHint =>
      'Oturum açtığınızda açılır: orada çalmayı sürdürüyorsa sistem tepsisinde, değilse simge durumunda.';

  @override
  String get desktopStartWithWindowsRefused =>
      'Windows, uygulamanın kendisiyle başlamasına izin vermedi.';

  @override
  String get desktopStats => 'Kitaplık istatistikleri';

  @override
  String get desktopStatsByChannel => 'Kanala göre';

  @override
  String get desktopStatsByMonth => 'Eklendiği aya göre';

  @override
  String get desktopStatsBySite => 'Siteye göre';

  @override
  String get desktopStatsClips => 'Klipler';

  @override
  String get desktopStatsHint =>
      'Kitaplıkta neler var ve neler bir göz atmayı hak ediyor. Buradan hiçbir şey silinmez.';

  @override
  String desktopStatsHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saat',
      one: '1 saat',
      zero: 'Bir saatten az',
    );
    return '$_temp0';
  }

  @override
  String get desktopStatsLargest => 'En büyükler:';

  @override
  String get desktopStatsLength => 'Toplam süre';

  @override
  String get desktopStatsLink => 'İstatistikler';

  @override
  String get desktopStatsNeverPlayed => 'Burada hiç oynatılmamış';

  @override
  String get desktopStatsNewest => 'En yeniler:';

  @override
  String get desktopStatsOtherChannels => 'Diğer kanallar';

  @override
  String get desktopStatsRoom => 'Kaplanan alan';

  @override
  String get desktopStatsUnnamed => 'Kanal belirtilmemiş';

  @override
  String get desktopStatsWithText => 'Transkripti olan';

  @override
  String get desktopStatsWithoutText => 'Transkripti olmayan';

  @override
  String get desktopStatsWorthALook => 'Göz atmaya değer';

  @override
  String get desktopSubtitleOptions => 'Altyazı seçenekleri';

  @override
  String get desktopTheater => 'Sinema';

  @override
  String get desktopTranscriptFirst => 'Önce transkriptini getirin';

  @override
  String get desktopTranscriptHint =>
      'Oynatmayı izler · atlamak için bir satıra tıklayın';

  @override
  String get desktopTranscriptsDeleteBody =>
      'Bu bilgisayardan ve yedeğinden kaldırılırlar. Onları yalnızca dışa aktardığınız bir dosya geri getirebilir.';

  @override
  String get desktopTranscriptsHelp =>
      'VidHoist, eklediğiniz her YouTube klibinde söylenen kelimeleri saklar; böylece arama (Ctrl+K) yalnızca başlıkları değil, kliplerinizin içinde söylenenleri de bulur. Bu bilgisayarda kalırlar.';

  @override
  String get desktopTranscriptsMove => 'Telefona ya da telefondan';

  @override
  String get desktopTranscriptsMoveHint =>
      'Transkriptler yedekle birlikte taşınır: Telefon için dışa aktar onları alır, telefondaki İçe aktar ise buraya getirir ve burada eksik olanları ekler.';

  @override
  String get desktopTrayOnClose =>
      'Pencere kapanınca sistem tepsisinde çalmayı sürdür';

  @override
  String get desktopTrayOnCloseHint =>
      'Pencereyi kapatmak sesi durdurmaz; saatin yanındaki simgeden çıkın.';

  @override
  String get desktopTrayOpen => 'VidHoist\'i aç';

  @override
  String get desktopTrayQuit => 'Çık';

  @override
  String get desktopUiSize => 'Arayüz boyutu';

  @override
  String desktopUiSizeHint(String bigger, String smaller, String reset) {
    return '$bigger ve $smaller her yerden boyutu değiştirir, $reset ise %100\'e döndürür.';
  }

  @override
  String get desktopUiSizeTooLarge => 'Bu ekran için fazla büyük';

  @override
  String get desktopUpdateInstall => 'Yükle ve yeniden başlat';

  @override
  String get desktopUpdateRestartHint =>
      'VidHoist kapanır, güncellemeyi yükler ve yeniden açılır. Ayarlarınız ve kitaplığınız olduğu gibi kalır.';

  @override
  String get desktopViewCompact => 'Kompakt';

  @override
  String get desktopViewTable => 'Tablo';

  @override
  String get desktopVolume => 'Ses düzeyi';

  @override
  String desktopVolumeLevel(int percent) {
    return 'Ses düzeyi %$percent';
  }

  @override
  String get desktopWelcomeFetchNow => 'Şimdi getir';

  @override
  String get desktopWelcomeHelpers =>
      'ffmpeg (görüntü ile sesi birleştirir) ve Deno (YouTube için gerekli) ilk indirmede kendiliğinden iner, yaklaşık 160 MB. İsterseniz şimdi getirebilirsiniz.';

  @override
  String get desktopWelcomeMessage =>
      'YouTube\'dan ya da başka bir siteden bir bağlantı yapıştırın; VidHoist onu yt-dlp ile bu bilgisayara indirir.';

  @override
  String get desktopWelcomeStart => 'Başla';

  @override
  String get desktopWelcomeTitle => 'VidHoist\'e hoş geldiniz';

  @override
  String get desktopWhatsNewAllFeatures => 'VidHoist\'in yapabildiği her şey';

  @override
  String get desktopWidenSidebar => 'Kenar çubuğunu genişlet';

  @override
  String get desktopWindowClose => 'Kapat';

  @override
  String get desktopWindowMaximize => 'Ekranı kapla';

  @override
  String get desktopWindowMinimize => 'Simge durumuna küçült';

  @override
  String get desktopWindowRestore => 'Önceki boyuta getir';

  @override
  String get desktopZoomChange => 'Değiştir';

  @override
  String desktopZoomLowered(String percent) {
    return 'Arayüz bu ekrana sığması için şimdi $percent boyutunda.';
  }

  @override
  String get details => 'Ayrıntılar';

  @override
  String get developer => 'Geliştirici';

  @override
  String get developerName => 'Yasir Sagheer';

  @override
  String get diagnosticLogs => 'Tanılama günlükleri';

  @override
  String get diagnosticLogsSubtitle =>
      'Uygulama günlüklerini görüntüleyin, arayın ve paylaşın (hassas bilgiler gizlenir)';

  @override
  String get disclaimer => 'Sorumluluk reddi';

  @override
  String get disclaimerText =>
      'Bu uygulama medyayı yt-dlp ile indirir. Geliştirici, kullanıcıların bu aracı nasıl kullandığından sorumlu değildir. Lütfen telif hakkı yasalarına ve indirdiğiniz sitelerin hizmet şartlarına uyun.';

  @override
  String get dismiss => 'Kapat';

  @override
  String get done => 'Bitti';

  @override
  String get download => 'İndir';

  @override
  String get downloadComplete => 'İndirme tamamlandı';

  @override
  String get downloadCompleteTitle => 'Tamamlandı';

  @override
  String get downloadDate => 'İndirme tarihi';

  @override
  String get downloadFailed => 'İndirme başarısız';

  @override
  String get downloadFailedTitle => 'İndirme başarısız';

  @override
  String get downloadNow => 'İndir';

  @override
  String get downloadStarted => 'İndirme başladı…';

  @override
  String downloadStartedQuality(Object quality) {
    return 'İndirme başladı · $quality';
  }

  @override
  String get downloading => 'İndiriliyor…';

  @override
  String get downloadingTitle => 'İndiriliyor';

  @override
  String get downloadsAdvanced => 'Gelişmiş';

  @override
  String get editSubscription => 'Düzenle';

  @override
  String get embedSubtitles => 'Altyazılar videonun içine de';

  @override
  String get embedSubtitlesHelp =>
      'Böylece başka oynatıcılar da gösterir. VidHoist\'in kendi oynatıcısı her durumda gösterir.';

  @override
  String get emptyFilteredMessage =>
      'Tüm kitaplığınızı görmek için yukarıdaki bir filtreyi temizleyin.';

  @override
  String get emptyFilteredTitle => 'Bu filtrelere uyan bir şey yok';

  @override
  String get emptyPlaylist => 'Boş oynatma listesi';

  @override
  String get emptyPlaylistMessage => 'Kitaplıktan klip ekleyin';

  @override
  String engineDownloadingProgress(Object percent) {
    return 'İndiriliyor · %$percent';
  }

  @override
  String get engineErrDiskFull => 'Bu dosya için yeterli depolama alanı yok';

  @override
  String engineErrFailed(Object reason) {
    return 'İndirme başarısız: $reason';
  }

  @override
  String get engineErrFormat => 'Bu kalite bu video için yok';

  @override
  String get engineErrGeoBlocked => 'Ülkenizde kullanılamıyor';

  @override
  String get engineErrMissing =>
      'İndirme motoru eksik ya da tamamlanmamış. Ayarlar\'da Motoru onar ile düzeltin';

  @override
  String get engineErrRateLimited =>
      'Site istekleri sınırlıyor. Bir süre sonra yeniden deneyin';

  @override
  String get engineErrUnavailable =>
      'Bu video kullanılamıyor, gizli ya da kaldırılmış';

  @override
  String get engineErrUnsupported => 'Bu bağlantı desteklenmiyor';

  @override
  String get enginePaused => 'Duraklatıldı';

  @override
  String get enginePostprocessing => 'Dosya tamamlanıyor…';

  @override
  String get enginePreparing => 'Bağlantı okunuyor…';

  @override
  String get engineRepair => 'Motoru onar';

  @override
  String get engineRepairBusy =>
      'İndirmelerin bitmesini bekleyin, sonra onarın';

  @override
  String get engineRepairHint =>
      'İndirmeler daha önce olmadığı gibi sitelerin genelinde başarısız oluyorsa ve güncelleme işe yaramadıysa: yt-dlp\'nin kaydettiklerini temizler ve temiz, güncel bir kopyasını geri koyar. İndirmeleriniz ve ayarlarınız olduğu gibi kalır.';

  @override
  String get engineRepairPartly =>
      'Kısmen onarıldı: geri kalanı için bağlantı gerekiyor. Çevrimiçi olunca yeniden deneyin.';

  @override
  String engineRepaired(String version) {
    return 'Onarıldı: yt-dlp $version';
  }

  @override
  String get engineRepairing => 'Onarılıyor…';

  @override
  String get engineResume => 'Sürdür';

  @override
  String get enterFullscreen => 'Tam ekran';

  @override
  String errClipPastEnd(Object length) {
    return 'Kısım, video bittikten sonra başlıyor ($length)';
  }

  @override
  String get errClipPastEndUnknown => 'Kısım, video bittikten sonra başlıyor';

  @override
  String get errNetwork => 'Siteye bağlantı yok';

  @override
  String get errPlatformBlockedCookies =>
      'Site oturum açmayı gerektiriyor. Ayarlar › Çerezler bölümünden bir çerez dosyası seçin';

  @override
  String errorGeneric(Object message) {
    return 'Hata: $message';
  }

  @override
  String get every30Minutes => '30 dakikada bir';

  @override
  String everyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saatte bir',
      one: 'Saatte bir',
    );
    return '$_temp0';
  }

  @override
  String get exitFullscreen => 'Tam ekrandan çık';

  @override
  String get exportShare => 'Dışa aktar ve paylaş';

  @override
  String get exportShareSubtitle =>
      'Göndermek ya da başka yerde saklamak için tarihli bir kopya';

  @override
  String get externalPlayerShort => 'Başka oynatıcı';

  @override
  String get failed => 'Başarısız';

  @override
  String get failedToLoadPlaylist => 'Oynatma listesi yüklenemedi';

  @override
  String get fastStreams => 'Daha hızlı parçalı akışlar';

  @override
  String fastStreamsHelp(int count) {
    return 'Videoyu parçalara bölen sitelerden (X gibi) aynı anda $count parça getirir. Bazı siteler aynı anda gelen çok sayıda isteği yavaşlatır.';
  }

  @override
  String get favorites => 'Favoriler';

  @override
  String get file => 'Dosya';

  @override
  String get fileSize => 'Dosya boyutu';

  @override
  String get filterAll => 'Tümü';

  @override
  String get filterAudio => 'Ses';

  @override
  String get filterVideo => 'Video';

  @override
  String get filtersOn => 'Filtreler açık';

  @override
  String get folder => 'Klasör';

  @override
  String get foldersHelp =>
      'İndirme klasörünün içinde bir klasör oluşturulur ve klip doğrudan oraya kaydedilir; Dosya Gezgini ve diğer uygulamalar da onu görür. \"Klasör yok\" olarak bırakırsanız klip indirme klasörünün en üstüne gider.';

  @override
  String get follow => 'Takip et';

  @override
  String get followChannel => 'Kanal takip et';

  @override
  String get format => 'Biçim';

  @override
  String framesPerSecond(int count) {
    return '$count fps';
  }

  @override
  String get helpAboutField => 'Bu alan hakkında';

  @override
  String get inPlaylists => 'Oynatma listelerinde';

  @override
  String get invalidUrl => 'Geçerli bir bağlantı girin';

  @override
  String get itemOptions => 'Öğe seçenekleri';

  @override
  String get itemUnavailable => 'Artık kullanılamıyor';

  @override
  String get jumpToNewest => 'En yeniye git';

  @override
  String get justNow => 'az önce';

  @override
  String knownVideos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count video biliniyor',
      one: '1 video biliniyor',
      zero: 'Henüz bilinen bir şey yok',
    );
    return '$_temp0';
  }

  @override
  String get language => 'Dil';

  @override
  String get languageSystem => 'Sistem';

  @override
  String get languageSystemHint => 'Telefonunuzun dilini kullanır';

  @override
  String lastBackup(String when) {
    return 'Son yedek: $when';
  }

  @override
  String lastCheckedAt(String when) {
    return 'Son denetim: $when';
  }

  @override
  String get latestAdditions => 'Son eklenenler';

  @override
  String get licensedUnder => 'GPL-3.0 lisansı altındadır';

  @override
  String get licenses => 'Açık kaynak lisansları';

  @override
  String get listSeparator => ', ';

  @override
  String get listenInBackground => 'Arka planda dinle';

  @override
  String get lockTouch => 'Dokunmayı kilitle';

  @override
  String get loginDone => 'Bitti';

  @override
  String loginKept(String site) {
    return '$site oturumu açıldı; indirmeler bunu kullanacak';
  }

  @override
  String get loginNotYet =>
      'Henüz oturum bulunamadı. Oturum açmayı tamamlayın, sonra Bitti\'ye dokunun';

  @override
  String get logsEmpty => 'Günlük boş';

  @override
  String get logsSanitizedNote =>
      'Bağlantılar, adresler ve kimlik bilgileri paylaşmadan önce çıkarılır';

  @override
  String get manageTags => 'Etiketleri yönet';

  @override
  String get mediaAccessBlockedMessage =>
      'Android bir daha sormayacak. Sistem ayarlarından bu uygulama için fotoğraf ve video iznini açın, sonra geri dönün.';

  @override
  String get mediaAccessGrant => 'İzin ver';

  @override
  String get mediaAccessMessage =>
      'İndirdikleriniz telefonun Download klasöründe saklanır ve uygulamanın bunları listeleyebilmesi için Android\'in izninize ihtiyacı var.';

  @override
  String get mediaAccessOpenSettings => 'Ayarları aç';

  @override
  String get mediaAccessTitle => 'Medyanıza erişim izni verin';

  @override
  String get mobileChannelsEmptyBody =>
      'Bir kanalı takip edin; VidHoist açıkken ya da arka plandayken her yeni video kendiliğinden iner, kapalıyken gelenler ise uygulama açılınca iner. Kanalda zaten olanlar indirilmez.';

  @override
  String get mobileChannelsHint =>
      'Takip ettiğiniz kanallardan yeni videolar, kendiliğinden indirilir';

  @override
  String get mobileEngineIpv4 => 'IPv4 üzerinden bağlan';

  @override
  String get mobileEngineIpv4Help =>
      'IPv6 yolu bozuk olan ağlarda uzun takılmaları önler. Yalnızca ağınızda sadece IPv6 varsa kapatın.';

  @override
  String mobileEngineLastUpdate(String when) {
    return 'Son güncelleme: $when';
  }

  @override
  String get mobileEngineNotReady => 'Hazırlanıyor…';

  @override
  String get mobileEngineUpToDate => 'yt-dlp güncel';

  @override
  String get mobileEngineUpdate => 'yt-dlp\'yi güncelle';

  @override
  String get mobileEngineUpdateFailed =>
      'yt-dlp güncellenemedi. Bağlantıyı kontrol edip yeniden deneyin.';

  @override
  String get mobileEngineUpdateMissed => 'Güncelleme başarısız';

  @override
  String get mobileEngineUpdated => 'Güncellendi';

  @override
  String get mobileEngineUpdating => 'Güncelleniyor…';

  @override
  String get mobileEngineVersionLabel => 'yt-dlp sürümü';

  @override
  String get mobileEngineVersionUnknown =>
      'Sürümü ilk güncellemeden sonra görünür';

  @override
  String get mobileSettingsEngine => 'İndirme motoru';

  @override
  String get mobileSettingsGroupEngine => 'Motor';

  @override
  String get mobileSignInNeeded =>
      'Bu site oturum açmanızı istiyor. Ayarlar › Hesaplar bölümünden oturum açın, sonra yeniden deneyin';

  @override
  String get mobileSubtitleOptions => 'Boyut, arka plan ve transkript';

  @override
  String get mobileSubtitleStyleHelp =>
      'Oynatıcıda da var: CC düğmesini basılı tutun.';

  @override
  String get mobileSubtitles => 'Altyazıları indir';

  @override
  String get mobileSubtitlesHelp =>
      'Video sunuyorsa aşağıdaki dillerde altyazılar; videonun yanına kaydedilir ve oynatıcıda gösterilir.';

  @override
  String get mobileSubtitlesSizeLarger => 'Daha büyük';

  @override
  String get mobileTranscript => 'Transkript';

  @override
  String get mobileTranscriptHint => 'Oradan oynatmak için bir satıra dokunun.';

  @override
  String get mobileTranscriptOpen => 'Transkripti oku';

  @override
  String get mobileWelcomeBody =>
      'Kullandığınız sitelerden videolar ve sesler, doğrudan bu telefona kaydedilir. İndirme motoru hazırlanıyor; bu yalnızca bir kez olur.';

  @override
  String get mobileWelcomeFailed =>
      'Motor başlatılamadı. Yeniden deneyin; başarısız olmaya devam ederse uygulamayı yeniden yükleyin.';

  @override
  String get mobileWelcomeStart => 'Başla';

  @override
  String get mobileWelcomeTitle => 'VidHoist\'e hoş geldiniz';

  @override
  String get mobileWelcomeUnpacking => 'İndirme motoru hazırlanıyor';

  @override
  String get mobileWelcomeUpdateFailed =>
      'Şimdi güncellenemedi. VidHoist ilk indirmenizden önce yeniden dener.';

  @override
  String get mobileWelcomeUpdating => 'yt-dlp en son sürümüne güncelleniyor';

  @override
  String get modeAutoNext => 'Otomatik';

  @override
  String get modeRepeatAll => 'Tümünü tekrarla';

  @override
  String get modeRepeatOne => 'Birini tekrarla';

  @override
  String get modeStopAtEnd => 'Sonda dur';

  @override
  String get navLibrary => 'Kitaplık';

  @override
  String get navMyDownloads => 'İndirdiklerim';

  @override
  String get navPlaylists => 'Oynatma listeleri';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get needsAttention => 'İlgilenmeniz gerekiyor';

  @override
  String get neverChecked => 'Henüz denetlenmedi';

  @override
  String get newFolder => 'Yeni klasör…';

  @override
  String get newFolderHint => 'ör. Ai/Dersler';

  @override
  String get newPlaylistAction => 'Yeni oynatma listesi';

  @override
  String get newTagHint => 'Yeni etiket';

  @override
  String newVideosBody(String channels) {
    return '$channels. VidHoist\'i açtığınızda indirilir.';
  }

  @override
  String newVideosNotice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yeni video',
      one: '$count yeni video',
    );
    return '$_temp0';
  }

  @override
  String get next => 'Sonraki';

  @override
  String get noBackupsYet => 'Henüz yedek yok';

  @override
  String get noDownloads => 'İndirme yok';

  @override
  String get noDownloadsMessage =>
      'İndirilen klipler burada görünür.\nBir bağlantı paylaşın ya da Bağlantı ekle düğmesini kullanın.';

  @override
  String get noExternalPlayer => 'Bu cihazda harici oynatıcı yok';

  @override
  String get noFolder => 'Klasör yok';

  @override
  String get noFolderHint => 'İndirmelerin en üstünde';

  @override
  String get noLogsFound => 'Günlük bulunamadı';

  @override
  String get noPlayableSource => 'Bu öğenin oynatılabilir bir kaynağı yok';

  @override
  String get noPlaylistsMessage =>
      'Kliplerinizi düzenlemek için bir oynatma listesi oluşturun';

  @override
  String get noResults => 'Sonuç yok';

  @override
  String get noResultsMessage => 'Aramanızla eşleşen öğe yok.';

  @override
  String get noServerTitle => 'İndirme motoru hazır değil';

  @override
  String get noticeChannelNewVideos => 'Yeni videolar';

  @override
  String get noticeChannelUpdates => 'Güncellemeler';

  @override
  String get noVideosFound => 'Kitaplığınız boş';

  @override
  String get noWarranty => 'Hiçbir garanti olmaksızın olduğu gibi sunulur.';

  @override
  String get notAffiliated =>
      'yt-dlp ya da herhangi bir siteyle bağlantılı değildir ve onlar tarafından onaylanmamıştır.';

  @override
  String get nothingHereYet => 'Burada henüz bir şey yok';

  @override
  String get nowPlaying => 'Şimdi çalıyor';

  @override
  String get nowPlayingCollapse => 'Oynatıcı panelini daralt';

  @override
  String get nowPlayingExpand => 'Oynatıcı panelini göster';

  @override
  String get ok => 'Tamam';

  @override
  String get onlyNewVideos =>
      'Yalnızca bundan sonra çıkanlar indirilir. Kanalda zaten olan videolara dokunulmaz.';

  @override
  String get openChannel => 'Kanalı aç';

  @override
  String get openInExternalPlayer => 'Başka bir oynatıcıda aç';

  @override
  String get openOriginalLink => 'Orijinal bağlantıyı aç';

  @override
  String get ownFolder => 'Kendi klasörüne kaydet';

  @override
  String get ownFolderNote =>
      'İndirme klasörünün içinde, Dosya Gezgini ve diğer uygulamaların da gördüğü bir klasör. Yalnızca bundan sonra gelenler oraya gider; zaten indirilmiş olanlar yerinde kalır.';

  @override
  String get pasteUrlHint => 'Bağlantıyı buraya yapıştırın…';

  @override
  String get pause => 'Duraklat';

  @override
  String get pauseSubscription => 'Duraklat';

  @override
  String get pcAddressLabel => 'Adres';

  @override
  String get pcBadAddress =>
      'Adresi bilgisayarın gösterdiği gibi yazın, örneğin 192.168.1.24.';

  @override
  String get pcBadQr => 'Bu bir VidHoist eşleme QR kodu değil.';

  @override
  String get pcCertificate => 'Bilgisayarın sertifikası';

  @override
  String get pcCodeLabel => 'Kod';

  @override
  String get pcConnected => 'Bağlandı';

  @override
  String get pcCopied =>
      'Altyazılarıyla birlikte telefonun kitaplığına kopyalandı.';

  @override
  String get pcCopyFailed =>
      'Kopyalama tamamlanmadı: bilgisayar kapalı ya da erişilemez olabilir. Hiçbir şey saklanmadı.';

  @override
  String get pcCopyStarting => 'Kopyalanıyor…';

  @override
  String get pcCopyStop => 'Kopyalamayı durdur';

  @override
  String get pcCopyToPhone => 'Telefona kopyala';

  @override
  String pcCopying(int percent) {
    return 'Kopyalanıyor %$percent';
  }

  @override
  String get pcDelete => 'Bilgisayardan sil';

  @override
  String pcDeleteBody(String title) {
    return '\"$title\" bilgisayarın Geri Dönüşüm Kutusu\'na gider; oradan geri alınabilir.';
  }

  @override
  String get pcDeleteFailed => 'Bilgisayar onu silemedi. Orada açık olabilir.';

  @override
  String get pcDeleteMissing => 'Bu klip artık bilgisayarda değil.';

  @override
  String get pcDeleteNoBin =>
      'Silinmedi: bilgisayardaki sürücüsünde Geri Dönüşüm Kutusu yok.';

  @override
  String get pcDeleteNotAllowed =>
      'Bilgisayar, telefonun silmesine izin vermiyor. Orada Ayarlar › Telefon bölümünden açın.';

  @override
  String pcDeleteTitle(String name) {
    return '$name cihazından silinsin mi?';
  }

  @override
  String pcDeleted(String title) {
    return 'Bilgisayarın Geri Dönüşüm Kutusu\'nda: $title';
  }

  @override
  String get pcDestPhone => 'Bu telefon';

  @override
  String pcDoneOnPc(String title) {
    return 'Bilgisayarda tamamlandı: $title';
  }

  @override
  String pcDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bilgisayar için $count indirme',
      one: 'Bilgisayar için 1 indirme',
    );
    return '$_temp0';
  }

  @override
  String get pcDownloadsSheet => 'Bilgisayardaki indirmeler';

  @override
  String get pcEmptyLibrary => 'Bilgisayarda henüz indirme yok.';

  @override
  String get pcErrBad =>
      'Bilgisayar bu sürümün anlamadığı bir yanıt verdi. İki uygulamayı da güncelleyin.';

  @override
  String get pcErrClosed =>
      'Bilgisayarda kod görünmüyor ya da süresi doldu. Orada Telefon eşle\'ye basın.';

  @override
  String get pcErrDenied =>
      'Eşleme bilgisayarda reddedildi ya da zamanında yanıtlanmadı.';

  @override
  String get pcErrRefused => 'Bilgisayar bu bağlantıyı kabul etmedi.';

  @override
  String get pcErrUnauthorized =>
      'Bilgisayar artık bu telefonu tanımıyor. Yeniden eşleyin.';

  @override
  String get pcErrUnreachable =>
      'Bilgisayar yanıt vermedi. Açık mı, bu ağda ya da Tailscale\'inizde mi ve \"Telefondan al\" açık mı?';

  @override
  String get pcErrWrongCertificate =>
      'Bu adreste bilgisayarınızdan başka bir şey yanıt verdi. Hiçbir şey gönderilmedi.';

  @override
  String get pcErrWrongCode => 'Kod yanlış.';

  @override
  String get pcFindNone =>
      'Bilgisayar bulunamadı. Önce bilgisayarda, aynı Wi-Fi ağında Ayarlar › Telefon › Telefon eşle\'yi açın.';

  @override
  String get pcFindOnNetwork => 'Ağda bul';

  @override
  String get pcFirewallAllow => 'İzin ver';

  @override
  String get pcFirewallBlocked =>
      'Windows Güvenlik Duvarı VidHoist\'i engelliyor, bu yüzden telefon ona ulaşamıyor. Ev (özel) ağlarında izin verin.';

  @override
  String get pcFirewallMissing =>
      'Windows henüz VidHoist\'in telefondan veri almasına izin vermedi. Bir kez, yalnızca ev (özel) ağlarında izin verin.';

  @override
  String get pcFirewallPublic =>
      'Windows bu ağı Ortak olarak görüyor ve orada içeri hiçbir şey almıyor. Ev ağınızsa Özel yapın: Ayarlar › Ağ ve internet › Wi-Fi › ağın özellikleri.';

  @override
  String get pcFirewallRefused =>
      'Hiçbir şey değişmedi: Windows\'un yönetici izni gerekiyor.';

  @override
  String get pcFirewallTitle => 'Windows Güvenlik Duvarı';

  @override
  String pcFound(String name) {
    return 'Bulundu: $name. Gösterdiği kodu yazın.';
  }

  @override
  String pcFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bulundu',
      one: '1 bulundu',
    );
    return '$_temp0';
  }

  @override
  String pcLastContact(String time) {
    return 'Son iletişim: $time';
  }

  @override
  String get pcLibrary => 'Bilgisayardaki kitaplık';

  @override
  String get pcLinkAddress => 'Bu ağdaki adres';

  @override
  String get pcLinkAddressTailscale => 'Tailscale üzerinden, ev dışından';

  @override
  String get pcLinkAllow => 'İzin ver';

  @override
  String get pcLinkAllowDelete => 'Telefonun klip silmesine izin ver';

  @override
  String get pcLinkAllowDeleteHint =>
      'Telefondan silinen bir klip bu bilgisayarın Geri Dönüşüm Kutusu\'na gider; oradan geri alabilirsiniz. Geri Dönüşüm Kutusu olmayan bir sürücüde silinmez.';

  @override
  String get pcLinkCodeHint =>
      'Telefonda: Ayarlar › Bilgisayar › QR kodunu tara. Ya da bu adresi ve kodu orada yazın. Bir kez, iki dakika boyunca geçerlidir.';

  @override
  String pcLinkCodeLeft(int seconds) {
    return '$seconds sn kaldı';
  }

  @override
  String get pcLinkCodeTitle => 'Eşleme kodu';

  @override
  String get pcLinkDeny => 'Reddet';

  @override
  String get pcLinkDevices => 'Eşlenen telefonlar';

  @override
  String pcLinkFailed(String error) {
    return 'Başlatılamadı: $error';
  }

  @override
  String get pcLinkIntro =>
      'Telefonunuzdaki VidHoist\'ten bu bilgisayara bağlantı gönderin, bu bilgisayarın indirmelerini ve kitaplığını telefonda görün. Ev ağınızın içinde, dışarıdan ise Tailscale üzerinden çalışır.';

  @override
  String pcLinkLastSeen(String time) {
    return 'Son haber: $time';
  }

  @override
  String get pcLinkNoDevices => 'Henüz telefon yok.';

  @override
  String get pcLinkOff => 'Kapalı';

  @override
  String pcLinkOtherAddresses(int count) {
    return 'Diğer adresler ($count)';
  }

  @override
  String get pcLinkOtherAddressesHint =>
      'VirtualBox ya da WSL gibi başka programların eklediği ağ bağdaştırıcıları. Telefonun bunlara nadiren ihtiyacı olur.';

  @override
  String get pcLinkPairPhone => 'Telefon eşle';

  @override
  String pcLinkPairedAt(String time) {
    return 'Eşlenme: $time';
  }

  @override
  String pcLinkPhones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count telefon',
      one: 'Bir telefon',
      zero: 'Telefon yok',
    );
    return '$_temp0';
  }

  @override
  String get pcLinkQrHint => 'Telefondan tarayın';

  @override
  String get pcLinkReceive => 'Telefondan al';

  @override
  String get pcLinkReceiveHint =>
      'Kapalıyken bu bilgisayarda hiçbir bağlantı noktası açık değildir. Windows sorarsa yalnızca özel ağlara izin verin.';

  @override
  String pcLinkRequest(String name) {
    return 'Eşleme isteği: $name';
  }

  @override
  String get pcLinkRequestHint =>
      'Yalnızca telefon aynı dört rakamı gösteriyorsa izin verin.';

  @override
  String get pcLinkRevoke => 'Eşlemeyi kaldır';

  @override
  String get pcLinkSecurity =>
      'Telefon bu bilgisayarla ağınızda ya da Tailscale\'iniz üzerinden doğrudan konuşur. Bir kez, kod ve buradaki onayınızla eşlenir; sonrasında her istekte kendi anahtarını sunar ve bağlantı yalnızca bu bilgisayarın sertifikasıyla şifrelenir. Ağdaki başka herkes kapalı bir kapıyla karşılaşır.';

  @override
  String get pcLinkStarting => 'Başlatılıyor…';

  @override
  String get pcLinkTitle => 'Telefon';

  @override
  String get pcListEmpty =>
      'Bu listenin kliplerinden hiçbiri artık bilgisayarda değil.';

  @override
  String get pcListen => 'Dinle';

  @override
  String get pcLists => 'Bilgisayardaki listeler';

  @override
  String get pcListsEmpty => 'Bilgisayarda klip içeren liste yok.';

  @override
  String get pcNow => 'Şu an bilgisayarda';

  @override
  String get pcOffline => 'Kullanılamıyor';

  @override
  String get pcOfflineMessage =>
      'Bilgisayar kapalı ya da başka bir ağda. Son seferde olanlar aşağıda gösteriliyor.';

  @override
  String get pcOfflineRoute =>
      'Evden uzakta mısınız? Ayarlar › Bilgisayar bölümünden Tailscale\'i seçin.';

  @override
  String get pcOnPhone => 'Telefonda';

  @override
  String get pcOrType => 'Ya da adresi ve kodu yazın';

  @override
  String get pcOutboxRefused => 'Bilgisayar bu bağlantıyı kabul etmedi';

  @override
  String pcOutboxTitle(int count) {
    return 'Gönderilmeyi bekliyor ($count)';
  }

  @override
  String get pcPairButton => 'Eşle';

  @override
  String pcPairCheck(String check) {
    return 'Bilgisayarda $check göründüğünü kontrol edin, sonra orada telefona izin verin.';
  }

  @override
  String get pcPairIntro =>
      'VidHoist Windows bilgisayarınızda çalışıyorsa bu telefon ona bağlantı gönderebilir, indirmelerini ve kitaplığını gösterebilir. Bilgisayarda Ayarlar › Telefon\'u açıp Telefon eşle\'ye basın, sonra gösterdiği QR kodunu tarayın.';

  @override
  String pcPaired(String name) {
    return 'Eşlendi: $name';
  }

  @override
  String get pcPortLabel => 'Bağlantı noktası';

  @override
  String pcQueued(String name) {
    return 'Tekrar erişilebilir olduğunda $name cihazına gider.';
  }

  @override
  String pcQueuedMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count klip, tekrar erişilebilir olduğunda $name cihazına gider.',
      one: '1 klip, tekrar erişilebilir olduğunda $name cihazına gider.',
    );
    return '$_temp0';
  }

  @override
  String get pcRouteHint =>
      'Evden uzaktayken Tailscale\'i seçin; hem telefonda hem bilgisayarda çalışıyor olmalı.';

  @override
  String get pcRouteHome => 'Ev ağı';

  @override
  String get pcRouteOther => 'Başka bir ağ';

  @override
  String get pcRouteTailscale => 'Tailscale';

  @override
  String get pcRouteTitle => 'Bağlantı yolu';

  @override
  String get pcRouteWaiting =>
      'Bilgisayarın diğer yolları, yanıt verdiğinde burada görünür.';

  @override
  String get pcScanButton => 'QR kodunu tara';

  @override
  String get pcScanFailed => 'Kamera açılamadı.';

  @override
  String get pcScanPrompt =>
      'Kamerayı bilgisayar ekranındaki QR koduna doğrultun';

  @override
  String get pcSearchHint => 'Bilgisayarın kitaplığında ara';

  @override
  String get pcSendToPc => 'Bilgisayara gönder';

  @override
  String pcSent(String name) {
    return 'Gönderildi: $name';
  }

  @override
  String pcSentMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count klip gönderildi: $name',
      one: '1 klip gönderildi: $name',
    );
    return '$_temp0';
  }

  @override
  String get pcSettingsHint => 'Bilgisayarınıza bağlantı gönderin';

  @override
  String get pcTab => 'Bilgisayar';

  @override
  String pcVia(String route) {
    return 'Bağlantı yolu: $route';
  }

  @override
  String get pcWatch => 'İzle';

  @override
  String get pcWillSend => 'Erişilemiyor: geri gelince gönderilecek';

  @override
  String get pickAnotherFile => 'Başka bir dosyadan…';

  @override
  String get pickAnotherFileSubtitle =>
      'Başka bir telefondan ya da eski bir sürümden yedek';

  @override
  String get pictureInPicture => 'Resim içinde resim';

  @override
  String get pictureInPictureHelp =>
      'Bir klip oynarken uygulamadan çıktığınızda ekranın bir köşesinde kalır';

  @override
  String get pinPlaylist => 'En üste sabitle';

  @override
  String get platform => 'Site';

  @override
  String platformCount(Object name, int count) {
    return '$name · $count';
  }

  @override
  String get platformOther => 'Diğer';

  @override
  String get play => 'Oynat';

  @override
  String get playAll => 'Tümünü oynat';

  @override
  String get playModeLabel => 'Mod';

  @override
  String get playbackSpeed => 'Oynatma hızı';

  @override
  String get playerError => 'Bu dosya oynatılamadı';

  @override
  String get playingFromDevice => 'Cihazınızdan oynatılıyor';

  @override
  String get playlist => 'Oynatma listesi';

  @override
  String get playlistCreated => 'Oynatma listesi oluşturuldu';

  @override
  String get playlistDeleted => 'Oynatma listesi silindi';

  @override
  String get playlistDetails => 'Oynatma listesi ayrıntıları';

  @override
  String get playlistEditHint =>
      'Taşımak için bir klibe uzun basın. Kaldırmak için yana kaydırın.';

  @override
  String get playlistName => 'Oynatma listesi adı';

  @override
  String get playlistNameHint => 'Oynatma listem';

  @override
  String playlistOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get playlists => 'Oynatma listeleri';

  @override
  String get previous => 'Önceki';

  @override
  String get quality => 'Kalite';

  @override
  String get quality1080 => 'En fazla 1080p';

  @override
  String get quality360 => 'En fazla 360p';

  @override
  String get quality480 => 'En fazla 480p';

  @override
  String get quality720 => 'En fazla 720p';

  @override
  String get qualityAudio => 'Ses';

  @override
  String get qualityBest => 'En iyi';

  @override
  String get qualityHelper =>
      'Hızlı indirme, tüm oynatma listesi indirmeleri ve pano çubuğundaki \"İndir\" bunu kullanır; bağlantı ekleme sayfasında da önceden seçili seçenektir. Yani hızlı indirme açık olsun ya da olmasın önemlidir.';

  @override
  String get qualityReading => 'Dosya okunuyor…';

  @override
  String get qualityUnavailable => 'Kullanılamıyor';

  @override
  String get qualityVideo => 'Video';

  @override
  String queueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe',
      one: '1 öğe',
      zero: 'Öğe yok',
    );
    return '$_temp0';
  }

  @override
  String get queueLabel => 'Sıra';

  @override
  String queuePosition(int position) {
    return 'Sıra numarası: $position';
  }

  @override
  String get queued => 'Sırada';

  @override
  String get queuedSection => 'Bekleyenler';

  @override
  String get quickDownload => 'Hızlı indirme';

  @override
  String get quickDownloadHelp =>
      'Paylaşılan ya da yapıştırılan bir bağlantı, sayfa açılmadan hemen varsayılan kalitede inmeye başlar. O kaliteyi sunmayan bir site en iyisini verir; \"Yalnızca ses\" her sitede çalışır.';

  @override
  String get rateLimit => 'Hız sınırı';

  @override
  String get rateLimitNone => 'Sınır yok';

  @override
  String rateLimitValue(int mb) {
    return '$mb MB/sn';
  }

  @override
  String get reelsEndBack => 'Kitaplığa dön';

  @override
  String get reelsEndContinue => 'Listenin geri kalanıyla devam et';

  @override
  String get reelsEndReplay => 'Baştan oynat';

  @override
  String get reelsEndTitle => 'Shorts akışının sonu';

  @override
  String get reelsSwipeHint => 'Sonraki Shorts videosu için yukarı kaydırın';

  @override
  String get refresh => 'Yenile';

  @override
  String get remove => 'Kaldır';

  @override
  String get removeFromFavorites => 'Favorilerden çıkar';

  @override
  String removeUnavailable(int count) {
    return 'Kullanılamayanları kaldır ($count)';
  }

  @override
  String get removedFromFavorites => 'Favorilerden çıkarıldı';

  @override
  String get removedFromPlaylist => 'Oynatma listesinden kaldırıldı';

  @override
  String get rename => 'Yeniden adlandır';

  @override
  String get renameTag => 'Etiketi yeniden adlandır';

  @override
  String get reportBug => 'Hata bildir';

  @override
  String get restoreConfirm =>
      'Veriler yedek dosyasından geri yüklensin mi? Bu, mevcut oynatma listelerinin, etiketlerin ve ayarların üzerine yazar.';

  @override
  String get restoreData => 'Geri yükle';

  @override
  String get restoreFailed =>
      'Geri yükleme başarısız: yedek dosyası geçerli değil';

  @override
  String get restorePickBody =>
      'Bu telefonda VidHoist indirmeleri var ama ayar yok; yeniden kurulumdan sonraki gibi. Bir yedek sakladıysanız onu seçin: uygulama yedekleri Download/VidHoist/backups klasörüne yazar.';

  @override
  String get restorePickChoose => 'Yedek seç';

  @override
  String get restorePickTitle => 'Ayarlarınız geri getirilsin mi?';

  @override
  String get restoreSettings => 'Tüm verileri geri yükle';

  @override
  String get restoreSuccess => 'Veriler başarıyla geri yüklendi';

  @override
  String get resumeSubscription => 'Sürdür';

  @override
  String get retry => 'Yeniden dene';

  @override
  String get saveSettings => 'Ayarları kaydet';

  @override
  String get searchLogs => 'Günlüklerde ara…';

  @override
  String get searchVideos => 'Kliplerde ara…';

  @override
  String get seekBackward10 => '10 saniye geri';

  @override
  String get seekForward10 => '10 saniye ileri';

  @override
  String get selectAll => 'Tümünü seç';

  @override
  String selected(int count) {
    return '$count seçili';
  }

  @override
  String selectedCount(int count) {
    return '$count seçili';
  }

  @override
  String get settings => 'Ayarlar';

  @override
  String get settingsAccounts => 'Hesaplar';

  @override
  String get settingsBackup => 'Yedekleme';

  @override
  String get settingsDownloads => 'İndirmeler';

  @override
  String get settingsGroupApp => 'Uygulama';

  @override
  String get settingsGroupData => 'Veriler';

  @override
  String get settingsPlayback => 'Oynatma';

  @override
  String get settingsTranscripts => 'Transkriptler ve altyazılar';

  @override
  String settingsValueChannels(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kanal',
      one: '1 kanal',
      zero: 'Henüz kanal yok',
    );
    return '$_temp0';
  }

  @override
  String get settingsValueCompatOff => 'En iyi uyumluluk: kapalı';

  @override
  String get settingsValueCompatOn => 'En iyi uyumluluk: açık';

  @override
  String get settingsValueNotSet => 'Henüz ayarlanmadı';

  @override
  String get settingsValueQuick => 'hızlı';

  @override
  String settingsValueSignedIn(String sites) {
    return 'Oturum açık: $sites';
  }

  @override
  String get settingsValueWifiOnly => 'Yalnızca Wi‑Fi';

  @override
  String get share => 'Paylaş';

  @override
  String get shareLogs => 'Günlükleri paylaş';

  @override
  String get shareOpening => 'Paylaşım menüsü açılıyor…';

  @override
  String get shareOpeningHint =>
      'Büyük bir dosyanın aktarılması birkaç saniye sürer.';

  @override
  String get shareSelected => 'Seçilenleri paylaş';

  @override
  String get sharedLinksAdd => 'Ekle';

  @override
  String get sharedLinksBody => 'Her biri bu telefona indirilir.';

  @override
  String sharedLinksCapped(int max) {
    return 'Yalnızca ilk $max bağlantı eklendi.';
  }

  @override
  String sharedLinksTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bağlantı eklensin mi?',
      one: '1 bağlantı eklensin mi?',
    );
    return '$_temp0';
  }

  @override
  String get shortsFilter => 'Shorts';

  @override
  String get shuffle => 'Karıştır';

  @override
  String get signInRequired => 'Oturum açmak gerekli';

  @override
  String get size => 'Boyut';

  @override
  String get smartPlaylists => 'Akıllı oynatma listeleri';

  @override
  String get sortAndPlatform => 'Sıralama ve site';

  @override
  String get sortBy => 'Sırala';

  @override
  String get sortLargest => 'En büyük';

  @override
  String get sortNameAZ => 'Ad A–Z';

  @override
  String get sortNameZA => 'Ad Z–A';

  @override
  String get sortNewest => 'En yeni';

  @override
  String get sortOldest => 'En eski';

  @override
  String get sortSmallest => 'En küçük';

  @override
  String get sortedByLastPlayed => 'Son oynatılana göre';

  @override
  String get source => 'Kaynak';

  @override
  String get sourceCode => 'Kaynak kodu';

  @override
  String get startDownload => 'İndirmeyi başlat';

  @override
  String get status => 'Durum';

  @override
  String get storageCardMissing =>
      'Kart takılı değil, bu yüzden indirmeler telefona gidiyor';

  @override
  String get storageLocation => 'Kayıt yeri';

  @override
  String get storageLocationHelp =>
      'Zaten indirilmiş klipler yerinde kalır ve kitaplıkta görünmeye devam eder. Hafıza kartı için Android 11 veya üstü gerekir.';

  @override
  String get storageNoCard => 'Bu telefonda hafıza kartı yok';

  @override
  String get storagePhone => 'Telefon belleği';

  @override
  String get streamingOnline => 'Ağ üzerinden oynatılıyor';

  @override
  String subscriptionAdded(String name) {
    return 'Artık takip ediliyor: $name';
  }

  @override
  String get subscriptionName => 'Ad';

  @override
  String get subscriptionPaused => 'Duraklatıldı';

  @override
  String get subscriptionQuality => 'Bu kanal için kalite';

  @override
  String get subscriptionQualityHelp =>
      'Bu kanaldaki yeni videoların indirileceği kalite. Daha sonra kanalı düzenleyerek değiştirebilirsiniz; zaten indirilmiş videolar kendi kalitesini korur.\n\n\"En iyi\", AV1 biçiminde 4K anlamına gelebilir; eski bir bilgisayar bunu takılarak oynatabilir: öyleyse 1080p\'yi seçin.';

  @override
  String get subscriptionQualityNote =>
      'Yeni videolar için geçerlidir; zaten indirilmiş olanlar kendi kalitesini korur.';

  @override
  String get subscriptions => 'Kanallar';

  @override
  String get subscriptionsEmpty => 'Henüz takip edilen kanal yok';

  @override
  String get subscriptionsEmptyBody =>
      'Bir kanalı takip edin; VidHoist açıkken ya da sistem tepsisindeyken her yeni video kendiliğinden kitaplığınıza iner. Kanalda zaten olanlar indirilmez.';

  @override
  String get subscriptionsSubtitle =>
      'Takip ettiğiniz kanallardan yeni videolar, kendiliğinden indirilir';

  @override
  String get subtitleLangs => 'Altyazı dilleri';

  @override
  String get subtitleLangsHelp =>
      'Videoda varsa getirilir. En az biri seçili kalır.';

  @override
  String get subtitles => 'Altyazılar';

  @override
  String get subtitlesBackground => 'Arka plan';

  @override
  String get subtitlesBackgroundFaint => 'Hafif';

  @override
  String get subtitlesBackgroundHelp =>
      'Kelimelerin arkasında duran şey. Hiçbiri seçilmezse her harfin koyu bir kenarı olur, böylece parlak bir görüntü üzerinde de okunur.';

  @override
  String get subtitlesBackgroundNone => 'Yok';

  @override
  String get subtitlesBackgroundSolid => 'Koyu';

  @override
  String get subtitlesHide => 'Altyazıları gizle';

  @override
  String get subtitlesLanguage => 'Altyazı dili';

  @override
  String get subtitlesShow => 'Altyazıları göster';

  @override
  String get subtitlesShowHelp =>
      'Transkripti olan kliplerde videonun üzerinde. Oynatıcıdaki CC düğmesi de aynı işi yapar.';

  @override
  String get subtitlesSize => 'Metin boyutu';

  @override
  String get subtitlesSizeLarge => 'Büyük';

  @override
  String get subtitlesSizeMedium => 'Orta';

  @override
  String get subtitlesSizeSmall => 'Küçük';

  @override
  String tagLimitReached(int max) {
    return 'En fazla $max etiketiniz olabilir. Yenisini eklemek için Etiketleri yönet bölümünden birini kaldırın.';
  }

  @override
  String get tags => 'Etiketler';

  @override
  String get tagsOpenFiltered => 'Kitaplığı filtreli açar';

  @override
  String get theme => 'Tema';

  @override
  String get themeDark => 'Koyu';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get titleFilter => 'Yalnızca başlığında şu geçenleri indir';

  @override
  String get titleFilterHelp =>
      'Bu kanaldaki yeni bir video, yalnızca başlığı buraya yazdığınızı içeriyorsa indirilir.\n\n• Düz bir kelime yeterli: Bölüm\n• Birkaç kelimeden herhangi biri: Bölüm|Kısım (| işareti \"veya\" demektir)\n• Büyük-küçük harf fark etmez: bölüm, Bölüm ile de eşleşir.\n\nFiltrenin atladığı bir video kalıcı olarak görülmüş sayılır: filtreyi sonradan kaldırmak, atlananları değil, bundan sonra gelenleri indirir.';

  @override
  String get titleFilterHelper =>
      'Birkaç kelime: aralarına | koyun. Her şey için boş bırakın.';

  @override
  String get titleFilterHint => 'ör. Bölüm';

  @override
  String get titleLabel => 'Başlık';

  @override
  String totalDuration(Object duration) {
    return 'Toplam: $duration';
  }

  @override
  String get transcript => 'Transkript';

  @override
  String transcriptSaidMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kez daha söylendi',
      one: 'Bir kez daha söylendi',
    );
    return '$_temp0';
  }

  @override
  String transcriptsClips(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count klip',
      one: '1 klip',
      zero: 'Henüz klip yok',
    );
    return '$_temp0';
  }

  @override
  String get transcriptsDeleteAll => 'Tümünü sil';

  @override
  String get transcriptsDeleteTitle => 'Tüm transkriptler silinsin mi?';

  @override
  String get transcriptsSaidInside => 'Kliplerde söylenenler';

  @override
  String get transcriptsSearchHelp =>
      'Eklediğiniz her YouTube klibinin kelimelerini saklar, böylece söylenenlerde arama yapabilirsiniz.';

  @override
  String get tryAgain => 'Yeniden dene';

  @override
  String get undo => 'Geri al';

  @override
  String get unfollow => 'Takibi bırak';

  @override
  String unfollowConfirm(String name) {
    return '$name takipten çıkarılsın mı?';
  }

  @override
  String get unfollowConfirmBody =>
      'VidHoist bu kanalda daha önce gördüğü videoları unutur. Daha sonra yeniden takip ederseniz, o ana kadar kanalda olan her şey görülmüş sayılır ve kaçırdıklarınız tamamlanmaz. Duraklatmak bu hafızayı korur.';

  @override
  String get unlockTouch => 'Kilidi aç';

  @override
  String get unpinPlaylist => 'Sabitlemeyi kaldır';

  @override
  String get updateNoticeBody => 'Yüklemek için VidHoist\'i açın.';

  @override
  String get upNext => 'Sıradaki';

  @override
  String upNextIn(String name) {
    return '«$name» içinde sıradaki';
  }

  @override
  String get updateAllowInstallBody =>
      'Uygulamanın kendi güncellemelerini yükleyebilmesi için Android\'in izninize ihtiyacı var. Sistem ayarlarından bir kez izin verin, sonra yeniden Yükle\'ye dokunun.';

  @override
  String get updateAllowInstallTitle => 'Güncelleme yüklemeye izin verin';

  @override
  String get updateAvailable => 'Güncelleme var';

  @override
  String get updateCheckFailed => 'Güncellemeler denetlenemedi';

  @override
  String get updateChecking => 'Denetleniyor…';

  @override
  String get updateDownloadFailed => 'Güncelleme indirilemedi';

  @override
  String updateDownloadedMb(String done, String total) {
    return '$done / $total MB';
  }

  @override
  String get updateDownloading => 'Güncelleme indiriliyor…';

  @override
  String get updateFailedToStart => 'Yükleyici açılamadı';

  @override
  String get updateInstall => 'Yükle';

  @override
  String get updateLater => 'Sonra';

  @override
  String get updateNever => 'Henüz değil';

  @override
  String get updateNow => 'Güncellemeyi indir';

  @override
  String get updateOpenSystemSettings => 'Ayarları aç';

  @override
  String get updateReady => 'Yüklemeye hazır';

  @override
  String updateSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get updateSkipVersion => 'Bu sürümü atla';

  @override
  String get updateUpToDate => 'En son sürümü kullanıyorsunuz';

  @override
  String updateVersionAvailable(String version) {
    return 'Sürüm $version kullanılabilir';
  }

  @override
  String updateVersionTitle(String version) {
    return 'Sürüm $version';
  }

  @override
  String get updateWhatsNew => 'Yenilikler';

  @override
  String get updates => 'Güncellemeler';

  @override
  String get version => 'Sürüm';

  @override
  String get videoAdded => 'Oynatma listesine eklendi';

  @override
  String get videoPlayer => 'Video oynatıcı';

  @override
  String get viewAll => 'Tümünü gör';

  @override
  String get viewAllInPlaylists => 'Tümünü gör';

  @override
  String get viewCards => 'Kartlar';

  @override
  String get viewGrid => 'Izgara';

  @override
  String get viewList => 'Liste';

  @override
  String get viewMode => 'Görünüm';

  @override
  String get waitingForWifi => 'Wi-Fi bekleniyor';

  @override
  String get whatsNewGotIt => 'Anladım';

  @override
  String get whatsNewReleasePage => 'Sürüm sayfası';

  @override
  String get whatsNewThisVersion => 'Bu sürümdeki yenilikler';

  @override
  String whatsNewTitle(String version) {
    return '$version sürümündeki yenilikler';
  }

  @override
  String get whatsNewUnavailable =>
      'Bu sürümde nelerin değiştiği sürüm sayfasında.';

  @override
  String get wifiOnly => 'Yalnızca Wi-Fi ile indir';

  @override
  String get wifiOnlyHelp =>
      'Mobil veriyle hiçbir şey indirilmez. İndirmeler Wi-Fi\'yi bekler; Wi-Fi kesildiğinde süren bir indirme duraklatılır ve Wi-Fi geri gelince kendiliğinden devam eder.';

  @override
  String get yourPlaylists => 'Oynatma listeleriniz';

  @override
  String get yourTags => 'Etiketleriniz';

  @override
  String get ytdlpCredit => 'VidHoist\'in kullandığı indirici';
}
