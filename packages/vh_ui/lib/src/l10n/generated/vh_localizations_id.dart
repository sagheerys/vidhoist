// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'vh_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class VhLocalizationsId extends VhLocalizations {
  VhLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get about => 'Tentang';

  @override
  String get aboutApp => 'Tentang aplikasi';

  @override
  String get aboutDescriptionPhone =>
      'Aplikasi ringan dan cepat yang mengunduh video dan audio dari banyak situs dengan yt-dlp. Dilengkapi pemutar dan playlist sendiri.';

  @override
  String get accountSignIn => 'Masuk';

  @override
  String get accountSignOut => 'Keluar';

  @override
  String get accountSignedIn => 'Sudah masuk';

  @override
  String get accountSignedOut => 'Belum masuk';

  @override
  String accountSignedOutOf(String site) {
    return 'Keluar dari $site';
  }

  @override
  String get accountsBanRisk =>
      'Sebaiknya gunakan akun kedua: mengunduh terlalu banyak bisa membuat akun dibatasi oleh situs untuk sementara.';

  @override
  String get accountsClearAll => 'Hapus semua cookie';

  @override
  String get accountsCleared => 'Cookie dihapus';

  @override
  String get accountsFileHint =>
      'Diekspor dari browser sebagai file cookies.txt (format Netscape), untuk situs mana pun, termasuk yang tidak tercantum di atas. File ini ditambahkan ke data masuk yang sudah ada, dan tetap di ponsel ini.';

  @override
  String get accountsFilePick => 'Pilih file cookie';

  @override
  String get accountsFileTitle => 'Atau impor file cookie';

  @override
  String get accountsFromFile => 'Dari file cookie';

  @override
  String get accountsHelp =>
      'Status masuk akan kedaluwarsa setelah beberapa waktu; jika situs mulai menolak lagi, masuk sekali lagi. Keluar dari satu situs juga mengeluarkan browser dalam aplikasi dari situs lain, tetapi unduhannya tetap berjalan seperti biasa. Jika situs tidak mengizinkan Anda masuk di sini, impor file cookie dari browser komputer Anda di bawah.';

  @override
  String get accountsHint =>
      'Untuk situs yang menolak unduhan tanpa login. Anda masuk di halaman situs itu sendiri di dalam aplikasi; data yang ditinggalkannya tetap di ponsel ini, tempat yt-dlp membacanya untuk setiap unduhan, dan tidak dikirim ke mana pun.';

  @override
  String get activeDownloads => 'Unduhan aktif';

  @override
  String activeDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unduhan sedang berjalan',
      one: '1 unduhan sedang berjalan',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloadsSheet => 'Unduhan aktif';

  @override
  String get activeNow => 'Aktif sekarang';

  @override
  String get addLinkFab => 'Tambah tautan';

  @override
  String get addTo => 'Tambahkan ke…';

  @override
  String get addToFavorites => 'Tambahkan ke favorit';

  @override
  String get addToPlaylist => 'Tambahkan ke playlist';

  @override
  String get addUrl => 'Tambah URL';

  @override
  String addedNToServer(int count) {
    return '$count ditambahkan ke unduhan';
  }

  @override
  String get addedToFavorites => 'Ditambahkan ke favorit';

  @override
  String addedToPlaylistCount(int count) {
    return '$count ditambahkan ke playlist';
  }

  @override
  String get allDownloadsFinished => 'Semua unduhan selesai.';

  @override
  String get allPlatforms => 'Semua situs';

  @override
  String get alreadyInPlaylist => 'Sudah ditambahkan';

  @override
  String get alreadySubscribed => 'Saluran ini sudah diikuti';

  @override
  String get appTitle => 'VidHoist';

  @override
  String get appearanceAndLanguage => 'Tampilan & bahasa';

  @override
  String audioChannels(int count) {
    return '$count kanal audio';
  }

  @override
  String get audioFormat => 'Format audio';

  @override
  String get audioFormatM4a => 'M4A: bisa diputar di mana saja';

  @override
  String get audioFormatMp3 => 'MP3: untuk pemutar lama dan mobil';

  @override
  String get audioFormatOriginal =>
      'Seperti yang dikirim situs, tanpa konversi';

  @override
  String get audioMono => 'Mono';

  @override
  String get audioOnly => 'Hanya audio';

  @override
  String get audioStereo => 'Stereo';

  @override
  String get autoBuilt => 'Otomatis';

  @override
  String get autoCheckUpdates => 'Periksa otomatis';

  @override
  String get autoCheckUpdatesHelp =>
      'Mencari versi baru di latar belakang sekitar dua kali sehari.';

  @override
  String get autoRestoreSuccess => 'Data dipulihkan dari cadangan.';

  @override
  String get autoRetry => 'Coba lagi saat jaringan kembali';

  @override
  String get autoRetryHelp =>
      'Apa pun yang gagal karena jaringan terputus akan dicoba lagi secara otomatis saat jaringan kembali. Yang ditolak situs tidak dicoba lagi: mengulanginya tanpa perubahan hanya akan gagal lagi.';

  @override
  String get backgroundChecks => 'Periksa saat aplikasi tertutup';

  @override
  String get backgroundChecksHelp =>
      'Kira-kira setiap enam jam, saat ada jaringan dan baterai tidak lemah. Hanya memberi tahu yang baru; video diunduh saat Anda membuka VidHoist.';

  @override
  String get backgroundDownload => 'Mengunduh file di latar belakang…';

  @override
  String backgroundLastRun(String when) {
    return 'Pemeriksaan terakhir saat tertutup: $when';
  }

  @override
  String get backgroundNotRunYet =>
      'Belum ada pemeriksaan saat tertutup: Android yang memilih waktunya.';

  @override
  String get backgroundOfferBody =>
      'VidHoist dapat melihat saluran Anda kira-kira setiap enam jam dan memberi tahu yang baru. Tidak ada yang diunduh sampai Anda membuka aplikasi.';

  @override
  String get backgroundOfferNo => 'Nanti saja';

  @override
  String get backgroundOfferTitle =>
      'Ingin tahu video baru saat VidHoist tertutup?';

  @override
  String get backgroundOfferYes => 'Aktifkan';

  @override
  String get backupNote =>
      'Mencakup pustaka, playlist, tag, saluran yang diikuti, dan pengaturan. Data masuk dan transkrip disimpan terpisah, dan file medianya sendiri tidak disertakan.';

  @override
  String get backupSettings => 'Cadangkan semua data';

  @override
  String get backupSettingsSubtitle =>
      'Tujuh salinan bertanggal yang diperbarui sendiri. Pulihkan salah satunya, atau ekspor satu untuk dibagikan';

  @override
  String backupSuccess(Object path) {
    return 'Cadangan disimpan ke: $path';
  }

  @override
  String backupsKept(int count) {
    return '$count cadangan disimpan';
  }

  @override
  String get batchDownloadSelected => 'Unduh yang dipilih';

  @override
  String get batchLoading => 'Membaca playlist…';

  @override
  String get batchNothingSelected => 'Pilih setidaknya satu item';

  @override
  String batchSelectedOf(int selected, int total) {
    return '$selected dari $total dipilih';
  }

  @override
  String get batchThisVideoOnly => 'Unduh klip ini saja';

  @override
  String get batchTitle => 'Unduh sekaligus';

  @override
  String get batteryAllow => 'Izinkan';

  @override
  String get batteryFree =>
      'Penghemat baterai tidak mengganggu unduhan, meskipun aplikasi tidak terlihat.';

  @override
  String get batteryRestricted =>
      'Penghemat baterai bisa menghentikan unduhan panjang saat aplikasi tidak terlihat.';

  @override
  String get batteryStateFree => 'Diizinkan';

  @override
  String get batteryStateLimited => 'Dibatasi';

  @override
  String get batteryTitle => 'Unduhan di latar belakang';

  @override
  String bitrateKbps(String value) {
    return '$value kb/s';
  }

  @override
  String bitrateMbps(String value) {
    return '$value Mb/s';
  }

  @override
  String get builtWith => 'Dibuat dengan';

  @override
  String get cancel => 'Batal';

  @override
  String get changeQuality => 'Ubah kualitas';

  @override
  String get channelNameFolder => 'Dinamai sesuai saluran';

  @override
  String channelFollowers(String count) {
    return '$count pelanggan';
  }

  @override
  String get channelCheckFailed =>
      'Tidak diperiksa kali ini. VidHoist akan mencoba lagi sendiri.';

  @override
  String get channelUrl =>
      'Tautan ke saluran, playlist, atau salah satu videonya';

  @override
  String get channelUrlHint => 'https://www.youtube.com/@name';

  @override
  String chapterNumber(int number) {
    return 'Bab $number';
  }

  @override
  String get chaptersFold => 'Sembunyikan bab';

  @override
  String chaptersFromTranscript(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab dari transkrip',
      one: '1 bab dari transkrip',
    );
    return '$_temp0';
  }

  @override
  String get chaptersShowAll => 'Lihat semua bab';

  @override
  String get chaptersUnfold => 'Tampilkan bab';

  @override
  String get checkEvery => 'Seberapa sering memeriksa';

  @override
  String get checkForUpdates => 'Periksa pembaruan';

  @override
  String get checkNow => 'Periksa sekarang';

  @override
  String get checkQueued =>
      'Sedang memeriksa. Yang baru akan muncul di pustaka.';

  @override
  String get chooseFolder => 'Pilih folder';

  @override
  String get chooseOptions => 'Opsi';

  @override
  String get clear => 'Hapus';

  @override
  String get clearLogs => 'Hapus log';

  @override
  String get clearLogsConfirm => 'Hapus semua log diagnostik?';

  @override
  String get clipEndAfterStart => 'Setelah titik awal';

  @override
  String get clipFrom => 'Dari';

  @override
  String clipLength(Object length) {
    return 'Durasi video $length';
  }

  @override
  String get clipLengthReading => 'Membaca durasi video…';

  @override
  String get clipLengthUnknown =>
      'Situs tidak menyebutkan durasi video, jadi waktunya tidak diperiksa';

  @override
  String get clipMinuteDown => 'Satu menit lebih awal';

  @override
  String get clipMinuteUp => 'Satu menit lebih lambat';

  @override
  String get clipOnly => 'Hanya sebagian video';

  @override
  String get clipOnlyHelp =>
      'Dari satu waktu ke waktu lain, tanpa sisanya. Bagian ini tidak disertai subtitel.';

  @override
  String clipPastEnd(Object length) {
    return 'Video berakhir di $length';
  }

  @override
  String get clipTimeHint => 'Angka saja: 130 berarti 1:30';

  @override
  String get clipTo => 'Sampai';

  @override
  String get clipboardFound => 'Ada tautan siap di papan klip Anda';

  @override
  String get clipboardLinkReady => 'Tempel tautan';

  @override
  String get closePlayer => 'Tutup pemutar';

  @override
  String get columnAdded => 'Ditambahkan';

  @override
  String get columnLength => 'Durasi';

  @override
  String get compactView => 'Tampilan ringkas';

  @override
  String get compatiblePlayback => 'Kompatibilitas pemutaran terbaik';

  @override
  String get compatiblePlaybackHelp =>
      'Meminta H.264/AAC, yang didekode secara hardware oleh semua ponsel. Tanpa ini, YouTube mungkin mengirim AV1, yang di banyak perangkat tampil sebagai gambar rusak. Menonaktifkannya memungkinkan resolusi tertinggi dengan mengorbankan kompatibilitas.';

  @override
  String get completed => 'Selesai';

  @override
  String get continueAsAudio => 'Lanjutkan sebagai audio';

  @override
  String get continueAsAudioBody =>
      'Lanjutkan memutar ini sebagai audio dari detik yang sama?';

  @override
  String get continueAsAudioNo => 'Tidak, hentikan';

  @override
  String get continueAsAudioTitle => 'Lanjutkan di latar belakang?';

  @override
  String get cookies => 'Cookie';

  @override
  String get cookiesNotNetscape =>
      'Tidak ada file yang berisi cookie dalam format Netscape';

  @override
  String get cookiesSubtitle =>
      'Untuk situs yang tidak bisa diunduh tanpa login';

  @override
  String get copiedToClipboard => 'Disalin ke papan klip';

  @override
  String get copyright => '© 2026 Yasir Sagheer';

  @override
  String get couldNotLoadPlaylist =>
      'Tidak dapat memuat playlist ini. Periksa URL dan koneksi Anda.';

  @override
  String get create => 'Buat';

  @override
  String get createPlaylist => 'Buat playlist';

  @override
  String get defaultQuality => 'Kualitas video default';

  @override
  String get delete => 'Hapus';

  @override
  String deleteMultipleConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hapus $count klip?\n\nFile-filenya dihapus dari perangkat Anda.',
      one: 'Hapus 1 klip?\n\nFilenya dihapus dari perangkat Anda.',
    );
    return '$_temp0';
  }

  @override
  String deletePlaylistConfirm(Object name) {
    return 'Hapus \"$name\"?';
  }

  @override
  String get deleteRefused =>
      'Tidak dihapus: Android memerlukan izin Anda untuk menghapus file ini, di dialog yang ditampilkannya.';

  @override
  String get deleteSelected => 'Hapus yang dipilih';

  @override
  String get deleteTag => 'Hapus tag';

  @override
  String deleteTagConfirm(Object tag) {
    return 'Hapus tag \"$tag\" dari semua item? Klipnya sendiri tidak dihapus.';
  }

  @override
  String get deleteVideo => 'Hapus klip';

  @override
  String deleteVideoConfirm(Object title) {
    return 'Hapus \"$title\"?\n\nFile akan dihapus dari perangkat Anda.';
  }

  @override
  String deletedCount(Object count) {
    return '$count dihapus';
  }

  @override
  String deletedTitle(Object title) {
    return 'Dihapus: $title';
  }

  @override
  String get deselectAll => 'Batalkan semua pilihan';

  @override
  String desktopAddLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tambah $count tautan',
      one: 'Tambah 1 tautan',
      zero: 'Tidak ada yang ditambahkan',
    );
    return '$_temp0';
  }

  @override
  String get desktopBack => 'Kembali';

  @override
  String get desktopBackUpNow => 'Cadangkan sekarang';

  @override
  String get desktopBackupHint =>
      'Komputer ini menyimpan tujuh cadangan terakhirnya, berjarak minimal satu jam, di Downloads\\VidHoist\\Backups, sehingga tetap ada meskipun aplikasi dicopot.';

  @override
  String get desktopBackupsNone => 'Belum ada cadangan';

  @override
  String get desktopBrowserButton => 'Tombol “Ke VidHoist” di browser';

  @override
  String get desktopBrowserButtonCopied =>
      'Kode disalin. Buat bookmark baru dan tempelkan sebagai alamatnya (URL).';

  @override
  String get desktopBrowserButtonCopy => 'Salin kode';

  @override
  String get desktopBrowserButtonFailed =>
      'Halaman tidak dapat dibuka; salin kodenya saja.';

  @override
  String get desktopBrowserButtonHint =>
      'Tombol di bilah bookmark Anda: satu klik di halaman video mana pun membuka dialog tambah di sini dengan tautannya. Tidak ada yang dikirim sampai Anda menekan Tambah.';

  @override
  String get desktopBrowserButtonName => 'Ke VidHoist';

  @override
  String get desktopBrowserButtonOpen => 'Buka halaman penyiapan';

  @override
  String get desktopBrowserPageCopyInstead =>
      'Jika menyeret tidak berhasil, buat bookmark baru dan tempelkan ini sebagai alamatnya:';

  @override
  String get desktopBrowserPageDragHint =>
      'Seret ke bilah; mengklik di sini tidak melakukan apa-apa.';

  @override
  String get desktopBrowserPageStep1 =>
      'Tampilkan bilah bookmark jika tersembunyi:';

  @override
  String get desktopBrowserPageStep2 =>
      'Seret tombol di bawah ke bilah dengan mouse.';

  @override
  String get desktopBrowserPageStep3 =>
      'Di halaman video mana pun, klik tombol itu: VidHoist membuka dialog tambah dengan tautannya. Pertama kali, browser akan bertanya apakah aplikasi boleh dibuka; izinkan.';

  @override
  String get desktopBrowserPageTitle =>
      'Tambahkan tombol “Ke VidHoist” ke browser Anda';

  @override
  String get desktopChangeFolder => 'Ubah…';

  @override
  String get desktopChannel => 'Saluran';

  @override
  String get desktopChannelClips => 'Di pustaka Anda';

  @override
  String get desktopChannels => 'Saluran';

  @override
  String get desktopChannelsInLibrary => 'Saluran di pustaka Anda';

  @override
  String get desktopChannelsLater => 'Memerlukan mesin unduh';

  @override
  String get desktopChannelsLaterBody =>
      'Mengikuti saluran memerlukan yt-dlp di komputer ini. Siapkan di Pengaturan › Mesin, lalu saluran Anda akan muncul di sini.';

  @override
  String get desktopChapters => 'Bab';

  @override
  String get desktopCheckAll => 'Periksa semua';

  @override
  String get desktopChooseClip => 'Pilih';

  @override
  String get desktopClearFilters => 'Hapus filter';

  @override
  String get desktopClearSelection => 'Hapus pilihan';

  @override
  String get desktopCookiesBrowser => 'Dari browser';

  @override
  String get desktopCookiesBrowserHint =>
      'Dibaca dari browser tempat Anda masuk. Jika tidak dapat dibaca, tutup browser itu dan coba lagi.';

  @override
  String get desktopCookiesChoose => 'Pilih file…';

  @override
  String get desktopCookiesFile => 'File cookie';

  @override
  String get desktopCookiesHelp =>
      'Di browser Anda, gunakan ekstensi yang mengekspor cookie dalam format Netscape (satu file per situs), lalu pilih semua file itu sekaligus di sini. yt-dlp kemudian memakainya untuk setiap unduhan. Cookie bisa kedaluwarsa, jadi unduhan yang mulai gagal lagi biasanya berarti perlu diekspor ulang.';

  @override
  String get desktopCookiesKept => 'Cookie yang disimpan di komputer ini';

  @override
  String desktopCookiesKeptFor(String sites) {
    return 'Cookie disimpan untuk: $sites';
  }

  @override
  String get desktopCookiesLocalHint =>
      'Untuk situs yang mengharuskan Anda masuk. yt-dlp membacanya di komputer ini, dan cookie tidak dikirim ke mana pun.';

  @override
  String get desktopCookiesNone => 'Tidak ada';

  @override
  String get desktopCookiesRemove => 'Hapus';

  @override
  String get desktopCopiedLinkAdd => 'Tambah…';

  @override
  String get desktopCopiedLinkTitle => 'Unduh tautan ini?';

  @override
  String get desktopCopyFile => 'Salin file';

  @override
  String get desktopCopyFileFailed => 'File tidak dapat disalin';

  @override
  String get desktopCopyLink => 'Salin tautan';

  @override
  String get desktopCopyOneClip => 'Penyalinan hanya bisa satu klip sekaligus';

  @override
  String get desktopCopyQuote => 'Salin dengan waktu dan tautan';

  @override
  String get desktopDefaultQualityHint =>
      'Pilihan awal setiap kali menambah; Anda tetap bisa mengubahnya untuk tiap tautan.';

  @override
  String desktopDeleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hapus $count klip? File-filenya di komputer ini akan dihapus.',
      one: 'Hapus 1 klip? Filenya di komputer ini akan dihapus.',
    );
    return '$_temp0';
  }

  @override
  String get desktopDesktopSection => 'Windows';

  @override
  String get desktopDiscover => 'Jelajahi VidHoist';

  @override
  String get desktopDiscoverAddLink => 'Tempel atau jatuhkan tautan';

  @override
  String get desktopDiscoverAddLinkLine =>
      'Ctrl+V di mana saja, atau jatuhkan tautan ke jendela, untuk menambahkannya.';

  @override
  String get desktopDiscoverAdding => 'Menambah dan berbagi';

  @override
  String get desktopDiscoverBrowser => 'Dari browser';

  @override
  String get desktopDiscoverBrowserLine =>
      'Tombol “Ke VidHoist” di bilah bookmark Anda membuka dialog tambah dengan halaman yang sedang Anda buka.';

  @override
  String get desktopDiscoverChapters => 'Bab';

  @override
  String get desktopDiscoverChaptersLine =>
      'Bagian-bagian klip, dari transkripnya, di halamannya.';

  @override
  String get desktopDiscoverChoose => 'Pilih banyak';

  @override
  String get desktopDiscoverChooseLine =>
      'Tanda bulat, atau Ctrl atau Shift sambil klik; lalu tambahkan ke daftar atau hapus sekaligus.';

  @override
  String get desktopDiscoverDragOut => 'Seret klip keluar';

  @override
  String get desktopDiscoverDragOutLine =>
      'Jatuhkan ke folder atau aplikasi lain, dan klip tiba di sana sebagai file.';

  @override
  String get desktopDiscoverExport => 'Ekspor transkrip';

  @override
  String get desktopDiscoverExportLine =>
      'Sebagai teks, atau sebagai subtitel SRT untuk pemutar lain.';

  @override
  String get desktopDiscoverHint =>
      'Semua yang bisa dilakukan aplikasi, satu baris masing-masing, beserta tombolnya.';

  @override
  String get desktopDiscoverLibrary => 'Pustaka';

  @override
  String get desktopDiscoverListening =>
      'Untuk audio: ruang tenang dengan sampul besar, dalam layar penuh.';

  @override
  String get desktopDiscoverMini => 'Jendela kecil';

  @override
  String get desktopDiscoverMiniLine =>
      'Kartu kecil di atas semua jendela lain, di sudut bawah layar.';

  @override
  String get desktopDiscoverReading =>
      'Transkrip sebagai artikel: klik sebuah kalimat untuk mendengarnya dari situ.';

  @override
  String get desktopDiscoverSaid => 'Apa yang diucapkan';

  @override
  String get desktopDiscoverSearch => 'Cari apa yang diucapkan';

  @override
  String get desktopDiscoverSearchLine =>
      'Temukan klip tempat sebuah kata diucapkan, tidak hanya di judul.';

  @override
  String get desktopDiscoverShortcutsLine =>
      'Semua tombol yang dikenali jendela, dalam satu lembar.';

  @override
  String get desktopDiscoverShow => 'Tampilkan';

  @override
  String get desktopDiscoverStatsLine =>
      'Pustaka dalam angka: per situs, saluran, dan bulan.';

  @override
  String get desktopDiscoverSubtitles =>
      'Transkrip di atas gambar, kata yang diucapkan disorot.';

  @override
  String get desktopDiscoverTheater =>
      'Gambar lebih besar yang mengambil tempat panel samping.';

  @override
  String get desktopDiscoverTry => 'Coba';

  @override
  String get desktopDiscoverWatching => 'Menonton dan mendengarkan';

  @override
  String get desktopDownloadFolder => 'Folder unduhan';

  @override
  String get desktopDownloadFolderHint =>
      'Unduhan disimpan di sini sebagai file biasa, untuk dibuka, dipindahkan, atau dicadangkan seperti file lainnya.';

  @override
  String get desktopDownloads => 'Unduhan';

  @override
  String get desktopDownloadsEmpty =>
      'Tidak ada yang sedang diunduh. Tambahkan tautan untuk mulai.';

  @override
  String get desktopDownloadsRunning => 'Sedang berjalan';

  @override
  String get desktopDragToReorder => 'Seret untuk mengurutkan';

  @override
  String get desktopDropLinks => 'Jatuhkan untuk menambah';

  @override
  String get desktopEmptyLibraryLocal =>
      'Tambahkan tautan, dan klip akan muncul di sini setelah diunduh.';

  @override
  String get desktopEmptyLibraryMessage =>
      'Tambahkan tautan, dan klip akan muncul di sini setelah diunduh.';

  @override
  String get desktopEngine => 'Mesin';

  @override
  String get desktopEngineDenoHint =>
      'Menjawab pemeriksaan YouTube, sehingga setiap kualitas yang ditawarkan bisa diunduh';

  @override
  String get desktopEngineFetch => 'Ambil';

  @override
  String get desktopEngineFetchCorrupt =>
      'File yang diterima bukan versi yang dirilis, jadi tidak digunakan.';

  @override
  String get desktopEngineFetchFailed =>
      'Tidak dapat diambil. Periksa koneksi dan coba lagi.';

  @override
  String get desktopEngineFetchInUse =>
      'Sedang dipakai oleh unduhan. Coba lagi setelah selesai.';

  @override
  String desktopEngineFetching(int percent) {
    return 'Mengambil · $percent%';
  }

  @override
  String get desktopEngineFfmpegHint =>
      'Menggabungkan gambar dan suara, serta mengonversi audio';

  @override
  String get desktopEngineIpv4 => 'Gunakan IPv4 saja';

  @override
  String get desktopEngineIpv4Hint =>
      'Jauh lebih cepat jika IPv6 bermasalah, seperti di banyak jaringan rumah. Nonaktifkan hanya jika jaringan Anda hanya memiliki IPv6.';

  @override
  String get desktopEngineMissing =>
      'yt-dlp tidak ada di komputer ini. Instal ulang VidHoist, atau ambil di sini.';

  @override
  String get desktopEngineOnFirstUse =>
      'Diambil saat unduhan pertama yang memerlukannya';

  @override
  String get desktopEngineUpToDate => 'yt-dlp sudah versi terbaru';

  @override
  String get desktopEngineUpdate => 'Perbarui yt-dlp';

  @override
  String get desktopEngineUpdateFailed => 'Pembaruan gagal. Coba lagi nanti.';

  @override
  String get desktopEngineUpdateHint =>
      'Situs sering berubah; yt-dlp versi lama berhenti berfungsi dalam beberapa bulan.';

  @override
  String desktopEngineUpdated(String version) {
    return 'yt-dlp sekarang $version';
  }

  @override
  String get desktopEngineUpdating => 'Memperbarui…';

  @override
  String desktopEngineVersion(String version) {
    return 'Versi $version';
  }

  @override
  String get desktopEngineYtDlpHint => 'Membaca tautan dan mengunduhnya';

  @override
  String get desktopExport => 'Ekspor';

  @override
  String get desktopExportForPhone => 'Ekspor untuk ponsel';

  @override
  String get desktopExportForPhoneHint =>
      'Menyimpan tag, daftar, dan titik lanjutan komputer ini, beserta transkripnya, sebagai dua file yang dipulihkan oleh ponsel. Memulihkan di ponsel akan mengganti tag dan daftarnya sendiri.';

  @override
  String get desktopExportMarkdown => 'Teks (Markdown)';

  @override
  String get desktopExportPdf => 'Dokumen (PDF)';

  @override
  String get desktopExportPhone => 'Untuk ponsel (impor VidHoist)';

  @override
  String get desktopExportSrt => 'Subtitel (SRT)';

  @override
  String desktopExported(String name) {
    return '$name disimpan';
  }

  @override
  String desktopFileReadyToPaste(String name, String size) {
    return 'Siap ditempel: $name · $size';
  }

  @override
  String get desktopFolderUnavailable => 'Tidak ada folder yang tersedia';

  @override
  String get desktopFolders => 'Folder';

  @override
  String get desktopForward => 'Maju';

  @override
  String get desktopGlobalShortcut => 'Putar dan jeda dari aplikasi mana pun';

  @override
  String desktopGlobalShortcutHint(String keys) {
    return '$keys memutar dan menjeda saat jendela berada di belakang aplikasi lain.';
  }

  @override
  String desktopGlobalShortcutTaken(String keys) {
    return '$keys sudah dipakai aplikasi lain.';
  }

  @override
  String get desktopHidePanel => 'Sembunyikan panel samping';

  @override
  String get desktopHintShortcuts =>
      'Tekan ? untuk pintasan keyboard. Spasi memutar dan menjeda; tombol panah untuk maju-mundur.';

  @override
  String get desktopHintShortcutsAction => 'Pintasan';

  @override
  String get desktopHintTrayBody =>
      'Aplikasi tetap memutar dari ikonnya di dekat jam. Untuk keluar, klik kanan ikonnya.';

  @override
  String get desktopHintTrayTitle => 'VidHoist masih berjalan';

  @override
  String get desktopHints => 'Tampilkan tips';

  @override
  String get desktopHintsAgain => 'Tampilkan lagi';

  @override
  String get desktopHintsHint =>
      'Dua tips singkat, masing-masing ditampilkan sekali: pintasan saat klip pertama, ikon di dekat jam saat pertama kali ditutup.';

  @override
  String get desktopImportFromPhone => 'Impor cadangan atau transkrip…';

  @override
  String get desktopImportHint =>
      'File cadangan atau transkrip dari VidHoist, dipilih di sini atau dijatuhkan ke jendela. Milik ponsel ditambahkan ke yang sudah ada di sini; cadangan komputer ini dipulihkan seluruhnya, setelah konfirmasi.';

  @override
  String desktopImportedBackup(int tagged, int lists, int positions) {
    return 'Ditambahkan dari ponsel. Tag: $tagged · daftar: $lists · titik lanjutan: $positions';
  }

  @override
  String get desktopImportedNothing =>
      'Tidak ada yang baru: komputer ini sudah memiliki semuanya.';

  @override
  String desktopImportedTranscripts(int count) {
    return 'Transkrip ditambahkan: $count';
  }

  @override
  String desktopInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count di pustaka Anda',
      one: '1 di pustaka Anda',
    );
    return '$_temp0';
  }

  @override
  String get desktopKeepAwake => 'Jaga komputer tetap aktif saat mengunduh';

  @override
  String get desktopKeepAwakeHint =>
      'Agar tautan yang dikirim dari ponsel, atau playlist panjang, selesai alih-alih berhenti saat Windows tidur. Layar tetap mati seperti biasa.';

  @override
  String get desktopKeyAddLink => 'Tambahkan tautan yang Anda salin';

  @override
  String get desktopKeyFavorite => 'Tambahkan ke atau hapus dari favorit';

  @override
  String get desktopKeyFullScreen => 'Layar penuh; untuk audio, ruang dengar';

  @override
  String get desktopKeyMenu => 'Menu klip';

  @override
  String get desktopKeyMini =>
      'Jendela kecil di atas jendela lain, dan kembali';

  @override
  String get desktopKeyPlayPause => 'Putar atau jeda';

  @override
  String get desktopKeyRepeat => 'Ubah pengulangan';

  @override
  String get desktopKeySearch => 'Cari judul dan apa yang diucapkan';

  @override
  String get desktopKeySeek => 'Mundur atau maju 10 detik';

  @override
  String get desktopKeyShortcuts => 'Daftar ini';

  @override
  String get desktopKeyVolume =>
      'Lebih keras atau lebih pelan; di Shorts, sebelumnya atau berikutnya';

  @override
  String get desktopKeyZoomIn => 'Antarmuka lebih besar';

  @override
  String get desktopKeyZoomOut => 'Antarmuka lebih kecil';

  @override
  String get desktopKeyZoomReset => 'Antarmuka ukuran normal';

  @override
  String get desktopLanguageSystemHint => 'Mengikuti bahasa Windows.';

  @override
  String desktopLastArrival(String when) {
    return 'Terakhir masuk $when';
  }

  @override
  String get desktopLess => 'Lebih sedikit';

  @override
  String get desktopLibraryLoading => 'Memuat pustaka…';

  @override
  String get desktopLinkCopied => 'Tautan disalin';

  @override
  String get desktopLinkDuplicate => 'Sudah ada di atas';

  @override
  String get desktopLinkInLibrary => 'Sudah ada di pustaka Anda';

  @override
  String get desktopLinkPlaylist => 'Playlist: pilih klipnya';

  @override
  String get desktopLinkReady => 'Siap';

  @override
  String get desktopLinkUnsupported => 'Situs yang tidak dikenal aplikasi ini';

  @override
  String desktopLinksDropped(int count, int limit) {
    return 'Hanya $limit tautan pertama yang diambil; $count lainnya dilewati.';
  }

  @override
  String desktopLinksFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tautan',
      one: '1 tautan',
    );
    return '$_temp0';
  }

  @override
  String get desktopListeningClose => 'Tutup ruang dengar';

  @override
  String get desktopListeningRoom => 'Ruang dengar';

  @override
  String get desktopLogsCopied => 'Log disalin, tanpa tautan atau alamat';

  @override
  String get desktopLogsCopy => 'Salin';

  @override
  String get desktopLogsSave => 'Simpan ke file';

  @override
  String get desktopMiniRestore => 'Kembali ke jendela penuh';

  @override
  String get desktopMiniWindow => 'Jendela kecil';

  @override
  String get desktopMore => 'Lainnya';

  @override
  String get desktopNarrowSidebar => 'Ciutkan bilah samping';

  @override
  String get desktopNoChannelNames =>
      'Klip di pustaka Anda tidak menyebutkan salurannya, jadi klip saluran ini tidak bisa dipilah. Ikuti saluran dengan foldernya sendiri, dan apa pun yang masuk ke sana akan muncul di sini.';

  @override
  String get desktopNoFavoritesMessage =>
      'Tandai klip sebagai favorit dan klip itu akan menunggu Anda di sini.';

  @override
  String get desktopNoFavoritesTitle => 'Belum ada favorit';

  @override
  String get desktopNoMatchMessage =>
      'Hapus filter untuk melihat lebih banyak.';

  @override
  String get desktopNoMatchTitle => 'Tidak ada yang cocok dengan filter ini';

  @override
  String get desktopNoTags =>
      'Belum ada tag. Beri tag pada klip dari halamannya dan tag akan muncul di sini.';

  @override
  String get desktopNoTranscriptMessage =>
      'Transkrip muncul di sini setelah subtitel klip diunduh bersamanya.';

  @override
  String get desktopNoTranscriptTitle => 'Tidak ada transkrip untuk klip ini';

  @override
  String get desktopNotABackup =>
      'File ini bukan file cadangan atau transkrip VidHoist.';

  @override
  String desktopNotWatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count belum ditonton',
      one: '1 belum ditonton',
    );
    return '$_temp0';
  }

  @override
  String get desktopNothingPlaying => 'Tidak ada yang diputar';

  @override
  String get desktopNothingPlayingHint =>
      'Putar klip, dan transkripnya, apa yang berikutnya, serta detailnya akan muncul di sini.';

  @override
  String get desktopNotifyArrivalsHint =>
      'Notifikasi Windows saat klip baru dari saluran yang Anda ikuti selesai diunduh.';

  @override
  String get desktopOfferCopiedLinks => 'Tawarkan tautan yang saya salin';

  @override
  String get desktopOfferCopiedLinksHint =>
      'Saat Anda menyalin tautan video di aplikasi lain, notifikasi menawarkan untuk menambahkannya. Hanya tautan yang diperiksa, dan tidak ada yang disimpan.';

  @override
  String get desktopOpenBackup => 'Buka Cadangan';

  @override
  String get desktopOpenChannels => 'Buka saluran';

  @override
  String get desktopOpenInExplorer => 'Buka di Explorer';

  @override
  String get desktopOpenWith => 'Buka di pemutar lain…';

  @override
  String get desktopPaletteClose => 'untuk menutup';

  @override
  String get desktopPaletteCommands => 'Perintah';

  @override
  String get desktopPaletteHint =>
      'Cari judul dan apa yang diucapkan, atau ketik > untuk perintah';

  @override
  String desktopPaletteList(String name) {
    return 'Daftar: $name';
  }

  @override
  String get desktopPaletteMove => 'untuk berpindah';

  @override
  String get desktopPaletteOpen => 'untuk membuka';

  @override
  String get desktopPaletteSaid => 'Diucapkan di dalam klip';

  @override
  String get desktopPaletteSave => 'Simpan pencarian ini';

  @override
  String desktopPaletteSettings(String section) {
    return 'Pengaturan: $section';
  }

  @override
  String get desktopPaletteTitles => 'Judul';

  @override
  String get desktopPinned => 'Disematkan';

  @override
  String get desktopPlayNext => 'Putar berikutnya';

  @override
  String get desktopPlaysNext => 'Diputar berikutnya, setelah yang ini';

  @override
  String get desktopQueueEnd => 'Tidak ada lagi setelah yang ini';

  @override
  String desktopQuote(String text, String title, String time, String link) {
    return '“$text”\n— $title, $time\n$link';
  }

  @override
  String get desktopQuoteCopied => 'Disalin dengan waktu dan tautannya';

  @override
  String get desktopReadingBack => 'Kembali ke klip';

  @override
  String get desktopReadingCloseFind => 'Tutup pencarian';

  @override
  String get desktopReadingFind => 'Cari di teks';

  @override
  String desktopReadingFound(int at, int count) {
    return '$at dari $count';
  }

  @override
  String get desktopReadingHint =>
      'Klik kalimat untuk mendengarnya dari situ · Ctrl+F mencari kata · pilih untuk menyalin beserta waktunya';

  @override
  String get desktopReadingNextMatch => 'Hasil berikutnya';

  @override
  String get desktopReadingPreviousMatch => 'Hasil sebelumnya';

  @override
  String get desktopReadingRoom => 'Ruang baca';

  @override
  String get desktopRecoverLibrary => 'Klip yang sudah ada di folder';

  @override
  String get desktopRecoverLibraryAction => 'Cari di folder';

  @override
  String get desktopRecoverLibraryHint =>
      'Setelah instal ulang: mengembalikan ke pustaka klip yang ada di folder unduhan tetapi tidak lagi tercantum. File-filenya tidak diubah.';

  @override
  String desktopRecovered(int count) {
    return 'Dikembalikan ke pustaka: $count';
  }

  @override
  String get desktopRecoveredNothing =>
      'Tidak ada yang perlu ditambahkan: semua klip di folder sudah ada di pustaka.';

  @override
  String desktopRecoveredSome(int count, int left) {
    return 'Dikembalikan ke pustaka: $count. Dilewati karena tautannya tidak diketahui: $left';
  }

  @override
  String get desktopRemoveFromList => 'Hapus dari daftar';

  @override
  String get desktopRestore => 'Pulihkan';

  @override
  String get desktopRestoreBody =>
      'Pustaka, saluran yang diikuti, tag, daftar, dan pengaturan komputer ini akan diganti dengan isi cadangan. File yang sudah diunduh tidak diubah.';

  @override
  String desktopRestoreOfferBody(String when) {
    return 'Downloads\\VidHoist\\Backups berisi cadangan komputer ini: pustaka, saluran yang diikuti, playlist, tag, pengaturan, dan transkrip yang disimpan. Yang terbaru dibuat $when. File yang sudah Anda unduh tidak diubah apa pun pilihan Anda.';
  }

  @override
  String get desktopRestoreOfferTitle => 'Pulihkan cadangan Anda?';

  @override
  String get desktopRestoreTitle => 'Pulihkan cadangan ini?';

  @override
  String get desktopRestored => 'Cadangan dipulihkan';

  @override
  String get desktopRevealAfterDownload =>
      'Tampilkan di Explorer setelah selesai';

  @override
  String get desktopRevealAfterDownloadHint =>
      'Saat file yang diunduh ke komputer ini selesai, foldernya terbuka dengan file tersebut terpilih.';

  @override
  String desktopSavedIn(String folder) {
    return 'Disimpan di $folder';
  }

  @override
  String desktopSavedSearchDelete(String name) {
    return 'Hapus pencarian tersimpan “$name”? Tidak ada yang berubah di pustaka.';
  }

  @override
  String get desktopSavedSearchName => 'Nama pencarian';

  @override
  String get desktopSearch => 'Cari';

  @override
  String get desktopSearchHint => 'Cari judul dan apa yang diucapkan…';

  @override
  String get desktopSearchSaved => 'Disimpan di bilah samping';

  @override
  String get desktopSeekBar => 'Posisi dalam klip';

  @override
  String desktopSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dipilih',
      one: '1 dipilih',
    );
    return '$_temp0';
  }

  @override
  String get desktopSetupChooseFile => 'Pilih file…';

  @override
  String get desktopShortcutsApp => 'Aplikasi';

  @override
  String get desktopShortcutsClip => 'Pada klip yang dipilih';

  @override
  String get desktopShortcutsPlayback => 'Pemutaran';

  @override
  String get desktopShortcutsTitle => 'Pintasan keyboard';

  @override
  String get desktopShortcutsWindow => 'Jendela';

  @override
  String get desktopShortsHint =>
      '↑ ↓ atau roda mouse untuk Shorts berikutnya · klik dua kali untuk favorit';

  @override
  String get desktopShowInFolder => 'Tampilkan di folder';

  @override
  String get desktopShowPanel => 'Tampilkan panel samping';

  @override
  String get desktopStartFresh => 'Mulai dari awal';

  @override
  String get desktopStartWithWindows => 'Mulai bersama Windows';

  @override
  String get desktopStartWithWindowsHint =>
      'Terbuka saat Anda masuk: di tray jika tetap memutar di sana, jika tidak, dalam keadaan diminimalkan.';

  @override
  String get desktopStartWithWindowsRefused =>
      'Windows tidak mengizinkan aplikasi dimulai bersamanya.';

  @override
  String get desktopStats => 'Statistik pustaka';

  @override
  String get desktopStatsByChannel => 'Per saluran';

  @override
  String get desktopStatsByMonth => 'Per bulan ditambahkan';

  @override
  String get desktopStatsBySite => 'Per situs';

  @override
  String get desktopStatsClips => 'Klip';

  @override
  String get desktopStatsHint =>
      'Apa isi pustaka, dan apa yang mungkin perlu dilihat. Tidak ada yang dihapus dari sini.';

  @override
  String desktopStatsHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jam',
      one: '1 jam',
      zero: 'Kurang dari satu jam',
    );
    return '$_temp0';
  }

  @override
  String get desktopStatsLargest => 'Terbesar:';

  @override
  String get desktopStatsLength => 'Total durasi';

  @override
  String get desktopStatsLink => 'Statistik';

  @override
  String get desktopStatsNeverPlayed => 'Belum pernah diputar di sini';

  @override
  String get desktopStatsNewest => 'Terbaru:';

  @override
  String get desktopStatsOtherChannels => 'Saluran lain';

  @override
  String get desktopStatsRoom => 'Ruang terpakai';

  @override
  String get desktopStatsUnnamed => 'Tanpa nama saluran';

  @override
  String get desktopStatsWithText => 'Dengan transkrip';

  @override
  String get desktopStatsWithoutText => 'Tanpa transkrip';

  @override
  String get desktopStatsWorthALook => 'Layak dilihat';

  @override
  String get desktopSubtitleOptions => 'Opsi subtitel';

  @override
  String get desktopTheater => 'Teater';

  @override
  String get desktopTranscriptFirst => 'Ambil transkripnya dulu';

  @override
  String get desktopTranscriptHint =>
      'Mengikuti pemutaran · klik baris untuk melompat';

  @override
  String get desktopTranscriptsDeleteBody =>
      'Transkrip dihapus dari komputer ini dan dari cadangannya. Hanya file yang Anda ekspor yang bisa mengembalikannya.';

  @override
  String get desktopTranscriptsHelp =>
      'VidHoist menyimpan kata-kata yang diucapkan di setiap klip YouTube yang Anda tambahkan, sehingga pencarian (Ctrl+K) juga menemukan apa yang diucapkan di dalam klip Anda, tidak hanya judulnya. Semuanya tetap di komputer ini.';

  @override
  String get desktopTranscriptsMove => 'Ke atau dari ponsel';

  @override
  String get desktopTranscriptsMoveHint =>
      'Transkrip ikut bersama cadangan: Ekspor untuk ponsel membawanya, dan Impor di sana memasukkannya, menambahkan yang belum ada di sini.';

  @override
  String get desktopTrayOnClose => 'Tetap memutar di tray saat jendela ditutup';

  @override
  String get desktopTrayOnCloseHint =>
      'Menutup jendela tidak menghentikan suara; keluar dari ikon di dekat jam.';

  @override
  String get desktopTrayOpen => 'Buka VidHoist';

  @override
  String get desktopTrayQuit => 'Keluar';

  @override
  String get desktopUiSize => 'Ukuran antarmuka';

  @override
  String desktopUiSizeHint(String bigger, String smaller, String reset) {
    return '$bigger dan $smaller mengubahnya dari mana saja, dan $reset mengembalikannya ke 100%.';
  }

  @override
  String get desktopUiSizeTooLarge => 'Terlalu besar untuk layar ini';

  @override
  String get desktopUpdateInstall => 'Instal dan mulai ulang';

  @override
  String get desktopUpdateRestartHint =>
      'VidHoist ditutup, menginstal pembaruan, lalu terbuka lagi. Pengaturan dan pustaka Anda tetap seperti semula.';

  @override
  String get desktopViewCompact => 'Ringkas';

  @override
  String get desktopViewTable => 'Tabel';

  @override
  String get desktopVolume => 'Volume';

  @override
  String desktopVolumeLevel(int percent) {
    return 'Volume $percent%';
  }

  @override
  String get desktopWelcomeFetchNow => 'Ambil sekarang';

  @override
  String get desktopWelcomeHelpers =>
      'ffmpeg (menggabungkan gambar dan suara) dan Deno (diperlukan YouTube) diunduh otomatis saat unduhan pertama, sekitar 160 MB. Anda bisa mengambilnya sekarang saja.';

  @override
  String get desktopWelcomeMessage =>
      'Tempel tautan dari YouTube atau situs lain, dan VidHoist mengunduhnya ke komputer ini dengan yt-dlp.';

  @override
  String get desktopWelcomeStart => 'Mulai';

  @override
  String get desktopWelcomeTitle => 'Selamat datang di VidHoist';

  @override
  String get desktopWhatsNewAllFeatures => 'Semua yang bisa dilakukan VidHoist';

  @override
  String get desktopWidenSidebar => 'Perluas bilah samping';

  @override
  String get desktopWindowClose => 'Tutup';

  @override
  String get desktopWindowMaximize => 'Maksimalkan';

  @override
  String get desktopWindowMinimize => 'Minimalkan';

  @override
  String get desktopWindowRestore => 'Kembalikan ukuran';

  @override
  String get desktopZoomChange => 'Ubah';

  @override
  String desktopZoomLowered(String percent) {
    return 'Antarmuka sekarang $percent agar muat di layar ini.';
  }

  @override
  String get details => 'Detail';

  @override
  String get developer => 'Pengembang';

  @override
  String get developerName => 'Yasir Sagheer';

  @override
  String get diagnosticLogs => 'Log diagnostik';

  @override
  String get diagnosticLogsSubtitle =>
      'Lihat, cari, dan bagikan log aplikasi (disamarkan)';

  @override
  String get disclaimer => 'Penafian';

  @override
  String get disclaimerText =>
      'Aplikasi ini mengunduh media dengan yt-dlp. Pengembang tidak bertanggung jawab atas cara pengguna memakai alat ini. Harap hormati hukum hak cipta dan ketentuan layanan situs tempat Anda mengunduh.';

  @override
  String get dismiss => 'Tutup';

  @override
  String get done => 'Selesai';

  @override
  String get download => 'Unduh';

  @override
  String get downloadComplete => 'Unduhan selesai';

  @override
  String get downloadCompleteTitle => 'Selesai';

  @override
  String get downloadDate => 'Tanggal unduh';

  @override
  String get downloadFailed => 'Unduhan gagal';

  @override
  String get downloadFailedTitle => 'Unduhan gagal';

  @override
  String get downloadNow => 'Unduh';

  @override
  String get downloadStarted => 'Unduhan dimulai…';

  @override
  String downloadStartedQuality(Object quality) {
    return 'Unduhan dimulai · $quality';
  }

  @override
  String get downloading => 'Mengunduh…';

  @override
  String get downloadingTitle => 'Mengunduh';

  @override
  String get downloadsAdvanced => 'Lanjutan';

  @override
  String get editSubscription => 'Edit';

  @override
  String get embedSubtitles => 'Subtitel juga di dalam video';

  @override
  String get embedSubtitlesHelp =>
      'Agar pemutar lain juga menampilkannya. Pemutar VidHoist sendiri tetap menampilkannya.';

  @override
  String get emptyFilteredMessage =>
      'Hapus filter di atas untuk melihat seluruh pustaka Anda.';

  @override
  String get emptyFilteredTitle => 'Tidak ada yang cocok dengan filter ini';

  @override
  String get emptyPlaylist => 'Playlist kosong';

  @override
  String get emptyPlaylistMessage => 'Tambahkan klip dari pustaka';

  @override
  String engineDownloadingProgress(Object percent) {
    return 'Mengunduh · $percent%';
  }

  @override
  String get engineErrDiskFull =>
      'Ruang penyimpanan tidak cukup untuk file ini';

  @override
  String engineErrFailed(Object reason) {
    return 'Unduhan gagal: $reason';
  }

  @override
  String get engineErrFormat => 'Kualitas ini tidak tersedia untuk video ini';

  @override
  String get engineErrGeoBlocked => 'Tidak tersedia di negara Anda';

  @override
  String get engineErrMissing =>
      'Mesin unduh tidak ada atau tidak lengkap. Perbaiki di Pengaturan dengan Perbaiki mesin';

  @override
  String get engineErrRateLimited =>
      'Situs membatasi permintaan. Coba lagi nanti';

  @override
  String get engineErrUnavailable =>
      'Video ini tidak tersedia, privat, atau sudah dihapus';

  @override
  String get engineErrUnsupported => 'Tautan ini tidak didukung';

  @override
  String get enginePaused => 'Dijeda';

  @override
  String get enginePostprocessing => 'Menyelesaikan file…';

  @override
  String get enginePreparing => 'Membaca tautan…';

  @override
  String get engineRepair => 'Perbaiki mesin';

  @override
  String get engineRepairBusy => 'Tunggu unduhan selesai, lalu perbaiki';

  @override
  String get engineRepairHint =>
      'Saat unduhan gagal di berbagai situs padahal sebelumnya tidak, dan pembaruan tidak membantu: menghapus data yang disimpan yt-dlp dan memasang salinan baru yang bersih dan terkini. Unduhan dan pengaturan Anda tetap seperti semula.';

  @override
  String get engineRepairPartly =>
      'Diperbaiki sebagian: sisanya memerlukan koneksi. Coba lagi saat online.';

  @override
  String engineRepaired(String version) {
    return 'Diperbaiki: yt-dlp $version';
  }

  @override
  String get engineRepairing => 'Memperbaiki…';

  @override
  String get engineResume => 'Lanjutkan';

  @override
  String get enterFullscreen => 'Layar penuh';

  @override
  String errClipPastEnd(Object length) {
    return 'Bagian ini dimulai setelah video berakhir ($length)';
  }

  @override
  String get errClipPastEndUnknown =>
      'Bagian ini dimulai setelah video berakhir';

  @override
  String get errNetwork => 'Tidak ada koneksi ke situs';

  @override
  String get errPlatformBlockedCookies =>
      'Situs ini memerlukan login. Pilih file cookie di Pengaturan › Cookie';

  @override
  String errorGeneric(Object message) {
    return 'Kesalahan: $message';
  }

  @override
  String get every30Minutes => 'Setiap 30 menit';

  @override
  String everyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Setiap $count jam',
      one: 'Setiap jam',
    );
    return '$_temp0';
  }

  @override
  String get exitFullscreen => 'Keluar dari layar penuh';

  @override
  String get exportShare => 'Ekspor & bagikan';

  @override
  String get exportShareSubtitle =>
      'Salinan bertanggal untuk dikirim atau disimpan di tempat lain';

  @override
  String get externalPlayerShort => 'Pemutar lain';

  @override
  String get failed => 'Gagal';

  @override
  String get failedToLoadPlaylist => 'Gagal memuat playlist';

  @override
  String get fastStreams => 'Stream tersegmen lebih cepat';

  @override
  String fastStreamsHelp(int count) {
    return 'Mengambil $count potongan sekaligus dari situs yang memotong video menjadi beberapa bagian, seperti X. Beberapa situs memperlambat banyak permintaan sekaligus.';
  }

  @override
  String get favorites => 'Favorit';

  @override
  String get file => 'File';

  @override
  String get fileSize => 'Ukuran file';

  @override
  String get filterAll => 'Semua';

  @override
  String get filterAudio => 'Audio';

  @override
  String get filterVideo => 'Video';

  @override
  String get filtersOn => 'Filter aktif';

  @override
  String get folder => 'Folder';

  @override
  String get foldersHelp =>
      'Folder dibuat di dalam folder unduhan, dan klip langsung disimpan di sana, tempat Explorer dan aplikasi lain dapat melihatnya. Biarkan di \"Tanpa folder\" dan klip masuk ke tingkat teratas folder unduhan.';

  @override
  String get follow => 'Ikuti';

  @override
  String get followChannel => 'Ikuti saluran';

  @override
  String get format => 'Format';

  @override
  String framesPerSecond(int count) {
    return '$count fps';
  }

  @override
  String get helpAboutField => 'Tentang kolom ini';

  @override
  String get inPlaylists => 'Di playlist';

  @override
  String get invalidUrl => 'Masukkan tautan yang valid';

  @override
  String get itemOptions => 'Opsi item';

  @override
  String get itemUnavailable => 'Tidak tersedia lagi';

  @override
  String get jumpToNewest => 'Ke yang terbaru';

  @override
  String get justNow => 'baru saja';

  @override
  String knownVideos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count video diketahui',
      one: '1 video diketahui',
      zero: 'Belum ada yang diketahui',
    );
    return '$_temp0';
  }

  @override
  String get language => 'Bahasa';

  @override
  String get languageSystem => 'Sistem';

  @override
  String get languageSystemHint => 'Mengikuti bahasa ponsel Anda';

  @override
  String lastBackup(String when) {
    return 'Cadangan terakhir $when';
  }

  @override
  String lastCheckedAt(String when) {
    return 'Terakhir diperiksa $when';
  }

  @override
  String get latestAdditions => 'Tambahan terbaru';

  @override
  String get licensedUnder => 'Berlisensi GPL-3.0';

  @override
  String get licenses => 'Lisensi open source';

  @override
  String get listSeparator => ', ';

  @override
  String get listenInBackground => 'Dengarkan di latar belakang';

  @override
  String get lockTouch => 'Kunci sentuhan';

  @override
  String get loginDone => 'Selesai';

  @override
  String loginKept(String site) {
    return 'Masuk ke $site; unduhan akan memakainya';
  }

  @override
  String get loginNotYet =>
      'Belum ada data masuk. Selesaikan proses masuk, lalu ketuk Selesai';

  @override
  String get logsEmpty => 'Log kosong';

  @override
  String get logsSanitizedNote =>
      'Tautan, alamat, dan kredensial dihapus sebelum dibagikan';

  @override
  String get manageTags => 'Kelola tag';

  @override
  String get mediaAccessBlockedMessage =>
      'Android tidak akan bertanya lagi. Aktifkan akses foto dan video untuk aplikasi ini di pengaturan sistem, lalu kembali.';

  @override
  String get mediaAccessGrant => 'Izinkan';

  @override
  String get mediaAccessMessage =>
      'Unduhan Anda disimpan di folder Download ponsel, dan Android memerlukan izin Anda sebelum aplikasi dapat menampilkannya.';

  @override
  String get mediaAccessOpenSettings => 'Buka pengaturan';

  @override
  String get mediaAccessTitle => 'Izinkan akses ke media Anda';

  @override
  String get mobileChannelsEmptyBody =>
      'Ikuti saluran dan setiap video baru akan terunduh sendiri saat VidHoist terbuka atau di latar belakang; yang muncul saat aplikasi tertutup akan diunduh saat dibuka. Video yang sudah ada di saluran tidak diunduh.';

  @override
  String get mobileChannelsHint =>
      'Video baru dari saluran yang Anda ikuti, terunduh dengan sendirinya';

  @override
  String get mobileEngineIpv4 => 'Hubungkan lewat IPv4';

  @override
  String get mobileEngineIpv4Help =>
      'Menghindari macet lama di jaringan yang rute IPv6-nya bermasalah. Nonaktifkan hanya jika jaringan Anda hanya memiliki IPv6.';

  @override
  String mobileEngineLastUpdate(String when) {
    return 'Terakhir diperbarui $when';
  }

  @override
  String get mobileEngineNotReady => 'Sedang disiapkan…';

  @override
  String get mobileEngineUpToDate => 'yt-dlp sudah versi terbaru';

  @override
  String get mobileEngineUpdate => 'Perbarui yt-dlp';

  @override
  String get mobileEngineUpdateFailed =>
      'Tidak dapat memperbarui yt-dlp. Periksa koneksi dan coba lagi.';

  @override
  String get mobileEngineUpdateMissed => 'Pembaruan gagal';

  @override
  String get mobileEngineUpdated => 'Diperbarui';

  @override
  String get mobileEngineUpdating => 'Memperbarui…';

  @override
  String get mobileEngineVersionLabel => 'Versi yt-dlp';

  @override
  String get mobileEngineVersionUnknown =>
      'Versinya muncul setelah pembaruan pertama';

  @override
  String get mobileSettingsEngine => 'Mesin unduh';

  @override
  String get mobileSettingsGroupEngine => 'Mesin';

  @override
  String get mobileSignInNeeded =>
      'Situs ini meminta Anda masuk. Masuk dari Pengaturan › Akun, lalu coba lagi';

  @override
  String get mobileSubtitleOptions => 'Ukuran, latar, dan transkrip';

  @override
  String get mobileSubtitleStyleHelp => 'Juga di pemutar: tahan tombol CC.';

  @override
  String get mobileSubtitles => 'Unduh subtitel';

  @override
  String get mobileSubtitlesHelp =>
      'Subtitel dalam bahasa di bawah, jika video memilikinya, disimpan di sebelahnya dan ditampilkan di pemutar.';

  @override
  String get mobileSubtitlesSizeLarger => 'Lebih besar';

  @override
  String get mobileTranscript => 'Transkrip';

  @override
  String get mobileTranscriptHint => 'Ketuk baris untuk memutar dari situ.';

  @override
  String get mobileTranscriptOpen => 'Baca transkrip';

  @override
  String get mobileWelcomeBody =>
      'Video dan audio dari situs yang Anda gunakan, langsung disimpan ke ponsel ini. Mesin unduh sedang disiapkan; ini hanya terjadi sekali.';

  @override
  String get mobileWelcomeFailed =>
      'Mesin tidak dapat dimulai. Coba lagi; jika terus gagal, instal ulang aplikasi.';

  @override
  String get mobileWelcomeStart => 'Mulai';

  @override
  String get mobileWelcomeTitle => 'Selamat datang di VidHoist';

  @override
  String get mobileWelcomeUnpacking => 'Menyiapkan mesin unduh';

  @override
  String get mobileWelcomeUpdateFailed =>
      'Tidak dapat memperbarui sekarang. VidHoist akan mencoba lagi sebelum unduhan pertama Anda.';

  @override
  String get mobileWelcomeUpdating => 'Memperbarui yt-dlp ke versi terbaru';

  @override
  String get modeAutoNext => 'Otomatis';

  @override
  String get modeRepeatAll => 'Ulangi semua';

  @override
  String get modeRepeatOne => 'Ulangi satu';

  @override
  String get modeStopAtEnd => 'Berhenti di akhir';

  @override
  String get navLibrary => 'Pustaka';

  @override
  String get navMyDownloads => 'Unduhan saya';

  @override
  String get navPlaylists => 'Playlist';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get needsAttention => 'Perlu perhatian Anda';

  @override
  String get neverChecked => 'Belum diperiksa';

  @override
  String get newFolder => 'Folder baru…';

  @override
  String get newFolderHint => 'mis. Ai/Pelajaran';

  @override
  String get newPlaylistAction => 'Playlist baru';

  @override
  String get newTagHint => 'Tag baru';

  @override
  String newVideosBody(String channels) {
    return '$channels. Diunduh saat Anda membuka VidHoist.';
  }

  @override
  String newVideosNotice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count video baru',
    );
    return '$_temp0';
  }

  @override
  String get next => 'Berikutnya';

  @override
  String get noBackupsYet => 'Belum ada cadangan';

  @override
  String get noDownloads => 'Tidak ada unduhan';

  @override
  String get noDownloadsMessage =>
      'Klip yang diunduh akan muncul di sini.\nBagikan tautan atau gunakan tombol Tambah tautan.';

  @override
  String get noExternalPlayer => 'Tidak ada pemutar eksternal di perangkat ini';

  @override
  String get noFolder => 'Tanpa folder';

  @override
  String get noFolderHint => 'Di tingkat teratas unduhan';

  @override
  String get noLogsFound => 'Tidak ada log';

  @override
  String get noPlayableSource =>
      'Item ini tidak memiliki sumber yang bisa diputar';

  @override
  String get noPlaylistsMessage => 'Buat playlist untuk mengatur klip Anda';

  @override
  String get noResults => 'Tidak ada hasil';

  @override
  String get noResultsMessage =>
      'Tidak ada item yang cocok dengan pencarian Anda.';

  @override
  String get noServerTitle => 'Mesin unduh belum siap';

  @override
  String get noticeChannelNewVideos => 'Video baru';

  @override
  String get noticeChannelUpdates => 'Pembaruan';

  @override
  String get noVideosFound => 'Pustaka Anda kosong';

  @override
  String get noWarranty => 'Disediakan apa adanya, tanpa jaminan apa pun.';

  @override
  String get notAffiliated =>
      'Tidak berafiliasi dengan yt-dlp atau situs mana pun, dan tidak didukung oleh mereka.';

  @override
  String get nothingHereYet => 'Belum ada apa-apa di sini';

  @override
  String get notificationClipGone => 'Klip ini sudah tidak ada di ponsel.';

  @override
  String get nowPlaying => 'Sedang diputar';

  @override
  String get nowPlayingCollapse => 'Ciutkan panel pemutar';

  @override
  String get nowPlayingExpand => 'Tampilkan panel pemutar';

  @override
  String get ok => 'OK';

  @override
  String get onlyNewVideos =>
      'Hanya yang muncul mulai sekarang yang diunduh. Video yang sudah ada di saluran dibiarkan.';

  @override
  String get openChannel => 'Buka saluran';

  @override
  String get openInExternalPlayer => 'Buka di pemutar lain';

  @override
  String get openOriginalLink => 'Buka tautan asli';

  @override
  String get ownFolder => 'Simpan di folder sendiri';

  @override
  String get ownFolderNote =>
      'Folder di dalam folder unduhan, yang juga terlihat oleh Explorer dan aplikasi lain. Hanya yang masuk mulai sekarang yang disimpan di sana; yang sudah diunduh tetap di tempatnya.';

  @override
  String get pasteUrlHint => 'Tempel tautan di sini…';

  @override
  String get pause => 'Jeda';

  @override
  String get pauseSubscription => 'Jeda';

  @override
  String get pcAddressLabel => 'Alamat';

  @override
  String get pcBadAddress =>
      'Ketik alamat seperti yang ditampilkan komputer, misalnya 192.168.1.24.';

  @override
  String get pcBadQr => 'Ini bukan kode QR pemasangan VidHoist.';

  @override
  String get pcCertificate => 'Sertifikat komputer';

  @override
  String get pcCodeLabel => 'Kode';

  @override
  String get pcConnected => 'Terhubung';

  @override
  String get pcCopied => 'Disalin ke pustaka ponsel, beserta subtitelnya.';

  @override
  String get pcCopyFailed =>
      'Penyalinan tidak selesai: komputer mungkin mati atau tidak terjangkau. Tidak ada yang disimpan.';

  @override
  String get pcCopyStarting => 'Menyalin…';

  @override
  String get pcCopyStop => 'Hentikan penyalinan';

  @override
  String get pcCopyToPhone => 'Salin ke ponsel';

  @override
  String pcCopying(int percent) {
    return 'Menyalin $percent%';
  }

  @override
  String get pcDelete => 'Hapus dari komputer';

  @override
  String pcDeleteBody(String title) {
    return '\"$title\" dipindahkan ke Recycle Bin komputer, tempat file bisa dikembalikan.';
  }

  @override
  String get pcDeleteFailed =>
      'Komputer tidak dapat menghapusnya. Mungkin sedang dibuka di sana.';

  @override
  String get pcDeleteMissing => 'Klip ini sudah tidak ada di komputer.';

  @override
  String get pcDeleteNoBin =>
      'Tidak dihapus: drive-nya di komputer tidak memiliki Recycle Bin.';

  @override
  String get pcDeleteNotAllowed =>
      'Komputer tidak mengizinkan ponsel menghapus. Aktifkan di sana, di Pengaturan › Ponsel.';

  @override
  String pcDeleteTitle(String name) {
    return 'Hapus dari $name?';
  }

  @override
  String pcDeleted(String title) {
    return 'Di Recycle Bin komputer: $title';
  }

  @override
  String get pcDestPhone => 'Ponsel ini';

  @override
  String pcDoneOnPc(String title) {
    return 'Selesai di komputer: $title';
  }

  @override
  String pcDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unduhan untuk komputer',
      one: '1 unduhan untuk komputer',
    );
    return '$_temp0';
  }

  @override
  String get pcDownloadsSheet => 'Unduhan di komputer';

  @override
  String get pcEmptyLibrary => 'Belum ada unduhan di komputer.';

  @override
  String get pcErrBad =>
      'Komputer menjawab dengan cara yang tidak dipahami versi ini. Perbarui kedua aplikasi.';

  @override
  String get pcErrClosed =>
      'Tidak ada kode yang tampil di komputer, atau kodenya kedaluwarsa. Tekan Pasangkan ponsel di sana.';

  @override
  String get pcErrDenied =>
      'Pemasangan ditolak di komputer, atau tidak dijawab tepat waktu.';

  @override
  String get pcErrRefused => 'Komputer tidak mau menerima tautan ini.';

  @override
  String get pcErrUnauthorized =>
      'Komputer tidak lagi mengenali ponsel ini. Pasangkan lagi.';

  @override
  String get pcErrUnreachable =>
      'Komputer tidak menjawab. Apakah komputer menyala, di jaringan ini atau di Tailscale Anda, dengan \"Terima dari ponsel\" aktif?';

  @override
  String get pcErrWrongCertificate =>
      'Yang menjawab di alamat ini bukan komputer Anda. Tidak ada yang dikirim.';

  @override
  String get pcErrWrongCode => 'Kode salah.';

  @override
  String get pcFindNone =>
      'Tidak ada komputer yang ditemukan. Di komputer, buka Pengaturan › Ponsel › Pasangkan ponsel terlebih dahulu, di Wi-Fi yang sama.';

  @override
  String get pcFindOnNetwork => 'Cari di jaringan';

  @override
  String get pcFirewallAllow => 'Izinkan';

  @override
  String get pcFirewallBlocked =>
      'Windows Firewall memblokir VidHoist, sehingga ponsel tidak dapat menjangkaunya. Izinkan di jaringan rumah (pribadi).';

  @override
  String get pcFirewallMissing =>
      'Windows belum mengizinkan VidHoist menerima dari ponsel. Izinkan sekali, hanya di jaringan rumah (pribadi).';

  @override
  String get pcFirewallPublic =>
      'Windows menyebut jaringan ini Publik, dan tidak mengizinkan apa pun masuk. Jika ini jaringan rumah Anda, jadikan Pribadi: Pengaturan › Jaringan & internet › Wi-Fi › properti jaringannya.';

  @override
  String get pcFirewallRefused =>
      'Tidak ada yang berubah: Windows memerlukan izin administrator.';

  @override
  String get pcFirewallTitle => 'Windows Firewall';

  @override
  String pcFound(String name) {
    return '$name ditemukan. Ketik kode yang ditampilkannya.';
  }

  @override
  String pcFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ditemukan',
      one: '1 ditemukan',
    );
    return '$_temp0';
  }

  @override
  String pcLastContact(String time) {
    return 'Kontak terakhir $time';
  }

  @override
  String get pcLibrary => 'Pustaka di komputer';

  @override
  String get pcLinkAddress => 'Alamat di jaringan ini';

  @override
  String get pcLinkAddressTailscale => 'Lewat Tailscale, dari luar rumah';

  @override
  String get pcLinkAllow => 'Izinkan';

  @override
  String get pcLinkAllowDelete => 'Izinkan ponsel menghapus klip';

  @override
  String get pcLinkAllowDeleteHint =>
      'Klip yang dihapus dari ponsel masuk ke Recycle Bin komputer ini, tempat Anda bisa mengembalikannya. Di drive tanpa Recycle Bin, klip tidak dihapus.';

  @override
  String get pcLinkCodeHint =>
      'Di ponsel: Pengaturan › Komputer › Pindai kode QR. Atau ketik alamat dan kode ini di sana. Hanya berlaku sekali, selama dua menit.';

  @override
  String pcLinkCodeLeft(int seconds) {
    return 'Sisa $seconds dtk';
  }

  @override
  String get pcLinkCodeTitle => 'Kode pemasangan';

  @override
  String get pcLinkDeny => 'Tolak';

  @override
  String get pcLinkDevices => 'Ponsel yang dipasangkan';

  @override
  String pcLinkFailed(String error) {
    return 'Tidak dapat memulai: $error';
  }

  @override
  String get pcLinkIntro =>
      'Kirim tautan dari VidHoist di ponsel ke komputer ini, dan lihat unduhan serta pustakanya di sana. Berfungsi di jaringan rumah Anda, dan dari luar lewat Tailscale.';

  @override
  String pcLinkLastSeen(String time) {
    return 'Terakhir terhubung $time';
  }

  @override
  String get pcLinkNoDevices => 'Belum ada ponsel.';

  @override
  String get pcLinkOff => 'Nonaktif';

  @override
  String pcLinkOtherAddresses(int count) {
    return 'Alamat lain ($count)';
  }

  @override
  String get pcLinkOtherAddressesHint =>
      'Adaptor jaringan yang ditambahkan program lain, seperti VirtualBox atau WSL. Ponsel jarang memerlukannya.';

  @override
  String get pcLinkPairPhone => 'Pasangkan ponsel';

  @override
  String pcLinkPairedAt(String time) {
    return 'Dipasangkan $time';
  }

  @override
  String pcLinkPhones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ponsel',
      one: 'Satu ponsel',
      zero: 'Tidak ada ponsel',
    );
    return '$_temp0';
  }

  @override
  String get pcLinkQrHint => 'Pindai dari ponsel';

  @override
  String get pcLinkReceive => 'Terima dari ponsel';

  @override
  String get pcLinkReceiveHint =>
      'Selama nonaktif, tidak ada port yang terbuka di komputer ini. Jika Windows bertanya, izinkan jaringan pribadi saja.';

  @override
  String pcLinkRequest(String name) {
    return '$name meminta untuk dipasangkan';
  }

  @override
  String get pcLinkRequestHint =>
      'Izinkan hanya jika ponsel menampilkan empat angka yang sama.';

  @override
  String get pcLinkRevoke => 'Lepas pasangan';

  @override
  String get pcLinkSecurity =>
      'Ponsel berkomunikasi langsung dengan komputer ini, di jaringan Anda atau lewat Tailscale Anda. Pemasangan dilakukan sekali, dengan kode dan persetujuan Anda di sini; setelah itu ponsel menunjukkan kuncinya sendiri pada setiap permintaan, lewat koneksi yang dienkripsi hanya dengan sertifikat komputer ini. Orang lain di jaringan hanya menemukan pintu tertutup.';

  @override
  String get pcLinkStarting => 'Memulai…';

  @override
  String get pcLinkTitle => 'Ponsel';

  @override
  String get pcListEmpty => 'Tidak ada lagi klip dari daftar ini di komputer.';

  @override
  String get pcListen => 'Dengarkan';

  @override
  String get pcLists => 'Daftar di komputer';

  @override
  String get pcListsEmpty => 'Tidak ada daftar di komputer yang berisi klip.';

  @override
  String get pcNow => 'Di komputer sekarang';

  @override
  String get pcOffline => 'Tidak tersedia';

  @override
  String get pcOfflineMessage =>
      'Komputer mati atau di jaringan lain. Isinya terakhir kali ditampilkan di bawah.';

  @override
  String get pcOfflineRoute =>
      'Sedang di luar rumah? Pilih Tailscale di Pengaturan › Komputer.';

  @override
  String get pcOnPhone => 'Di ponsel';

  @override
  String get pcOrType => 'Atau ketik alamat dan kode';

  @override
  String get pcOutboxRefused => 'Komputer tidak mau menerima tautan ini';

  @override
  String pcOutboxTitle(int count) {
    return 'Menunggu dikirim ($count)';
  }

  @override
  String get pcPairButton => 'Pasangkan';

  @override
  String pcPairCheck(String check) {
    return 'Pastikan komputer menampilkan $check, lalu izinkan ponsel di sana.';
  }

  @override
  String get pcPairIntro =>
      'Jika VidHoist berjalan di komputer Windows Anda, ponsel ini dapat mengirim tautan ke sana dan menampilkan unduhan serta pustakanya. Di komputer, aktifkan Pengaturan › Ponsel dan tekan Pasangkan ponsel, lalu pindai kode QR yang ditampilkan.';

  @override
  String pcPaired(String name) {
    return 'Dipasangkan dengan $name';
  }

  @override
  String get pcPortLabel => 'Port';

  @override
  String pcQueued(String name) {
    return 'Akan dikirim ke $name saat tersedia lagi.';
  }

  @override
  String pcQueuedMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count klip akan dikirim ke $name saat tersedia lagi.',
      one: '1 klip akan dikirim ke $name saat tersedia lagi.',
    );
    return '$_temp0';
  }

  @override
  String get pcRouteHint =>
      'Pilih Tailscale saat Anda di luar rumah; Tailscale harus berjalan di ponsel dan komputer.';

  @override
  String get pcRouteHome => 'Jaringan rumah';

  @override
  String get pcRouteOther => 'Jaringan lain';

  @override
  String get pcRouteTailscale => 'Tailscale';

  @override
  String get pcRouteTitle => 'Hubungkan lewat';

  @override
  String get pcRouteWaiting =>
      'Rute lain komputer muncul di sini setelah komputer menjawab.';

  @override
  String get pcScanButton => 'Pindai kode QR';

  @override
  String get pcScanFailed => 'Kamera tidak dapat dibuka.';

  @override
  String get pcScanPrompt => 'Arahkan kamera ke kode QR di layar komputer';

  @override
  String get pcSearchHint => 'Cari di pustaka komputer';

  @override
  String get pcSendToPc => 'Kirim ke komputer';

  @override
  String pcSent(String name) {
    return 'Dikirim ke $name';
  }

  @override
  String pcSentMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count klip dikirim ke $name',
      one: '1 klip dikirim ke $name',
    );
    return '$_temp0';
  }

  @override
  String get pcSettingsHint => 'Kirim tautan ke komputer Anda';

  @override
  String get pcTab => 'Komputer';

  @override
  String pcVia(String route) {
    return 'Lewat $route';
  }

  @override
  String get pcWatch => 'Tonton';

  @override
  String get pcWillSend => 'Tidak tersedia: dikirim saat kembali';

  @override
  String get pickAnotherFile => 'Dari file lain…';

  @override
  String get pickAnotherFileSubtitle =>
      'Cadangan dari ponsel lain atau versi lama';

  @override
  String get pictureInPicture => 'Picture-in-picture';

  @override
  String get pictureInPictureHelp =>
      'Saat Anda keluar dari aplikasi ketika klip sedang diputar, klip tetap tampil di sudut layar';

  @override
  String get pinPlaylist => 'Sematkan di atas';

  @override
  String get platform => 'Situs';

  @override
  String platformCount(Object name, int count) {
    return '$name · $count';
  }

  @override
  String get platformOther => 'Lainnya';

  @override
  String get play => 'Putar';

  @override
  String get playAll => 'Putar semua';

  @override
  String get playModeLabel => 'Mode';

  @override
  String get playbackSpeed => 'Kecepatan putar';

  @override
  String get playerError => 'Tidak dapat memutar file ini';

  @override
  String get playingFromDevice => 'Diputar dari perangkat Anda';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistCreated => 'Playlist dibuat';

  @override
  String get playlistDeleted => 'Playlist dihapus';

  @override
  String get playlistDetails => 'Detail playlist';

  @override
  String get playlistEditHint =>
      'Tekan lama klip untuk memindahkannya. Geser ke samping untuk menghapusnya.';

  @override
  String get playlistName => 'Nama playlist';

  @override
  String get playlistNameHint => 'Playlist saya';

  @override
  String playlistOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get playlists => 'Playlist';

  @override
  String get previous => 'Sebelumnya';

  @override
  String get quality => 'Kualitas';

  @override
  String get quality1080 => 'Hingga 1080p';

  @override
  String get quality360 => 'Hingga 360p';

  @override
  String get quality480 => 'Hingga 480p';

  @override
  String get quality720 => 'Hingga 720p';

  @override
  String get qualityAudio => 'Audio';

  @override
  String get qualityBest => 'Terbaik';

  @override
  String get qualityHelper =>
      'Dipakai oleh unduh cepat, unduhan seluruh playlist, dan \"Unduh\" di bilah papan klip, serta menjadi pilihan awal di lembar tambah tautan. Jadi pengaturan ini berpengaruh, baik unduh cepat aktif maupun tidak.';

  @override
  String get qualityReading => 'Membaca file…';

  @override
  String get qualityUnavailable => 'Tidak tersedia';

  @override
  String get qualityVideo => 'Video';

  @override
  String queueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
      one: '1 item',
      zero: 'Tidak ada item',
    );
    return '$_temp0';
  }

  @override
  String get queueLabel => 'Antrean';

  @override
  String queuePosition(int position) {
    return 'Nomor $position dalam antrean';
  }

  @override
  String get queued => 'Dalam antrean';

  @override
  String get queuedSection => 'Menunggu';

  @override
  String get quickDownload => 'Unduh cepat';

  @override
  String get quickDownloadHelp =>
      'Tautan yang dibagikan atau ditempel langsung diunduh dengan kualitas default, tanpa lembar pilihan. Situs yang tidak punya kualitas itu memberikan yang terbaik, dan \"Hanya audio\" berfungsi di semua situs.';

  @override
  String get rateLimit => 'Batas kecepatan';

  @override
  String get rateLimitNone => 'Tanpa batas';

  @override
  String rateLimitValue(int mb) {
    return '$mb MB/s';
  }

  @override
  String get reelsEndBack => 'Kembali ke pustaka';

  @override
  String get reelsEndContinue => 'Lanjutkan sisa daftar';

  @override
  String get reelsEndReplay => 'Putar ulang dari awal';

  @override
  String get reelsEndTitle => 'Akhir dari Shorts';

  @override
  String get reelsSwipeHint => 'Geser ke atas untuk Shorts berikutnya';

  @override
  String get refresh => 'Muat ulang';

  @override
  String get remove => 'Hapus';

  @override
  String get removeFromFavorites => 'Hapus dari favorit';

  @override
  String removeUnavailable(int count) {
    return 'Hapus $count yang tidak tersedia';
  }

  @override
  String get removedFromFavorites => 'Dihapus dari favorit';

  @override
  String get removedFromPlaylist => 'Dihapus dari playlist';

  @override
  String get rename => 'Ganti nama';

  @override
  String get renameTag => 'Ganti nama tag';

  @override
  String get reportBug => 'Laporkan bug';

  @override
  String get restoreConfirm =>
      'Pulihkan data dari file cadangan? Ini akan menimpa playlist, tag, dan pengaturan saat ini.';

  @override
  String get restoreData => 'Pulihkan';

  @override
  String get restoreFailed => 'Pemulihan gagal: file cadangan tidak valid';

  @override
  String get restorePickBody =>
      'Ponsel ini memiliki unduhan VidHoist tetapi tanpa pengaturan, seperti setelah instal ulang. Jika Anda menyimpan cadangan, pilih cadangan itu: aplikasi menyimpannya di Download/VidHoist/backups.';

  @override
  String get restorePickChoose => 'Pilih cadangan';

  @override
  String get restorePickTitle => 'Kembalikan pengaturan Anda?';

  @override
  String get restoreSettings => 'Pulihkan semua data';

  @override
  String get restoreSuccess => 'Data berhasil dipulihkan';

  @override
  String get resumeSubscription => 'Lanjutkan';

  @override
  String get retry => 'Coba lagi';

  @override
  String get saveSettings => 'Simpan pengaturan';

  @override
  String get searchLogs => 'Cari log…';

  @override
  String get searchVideos => 'Cari klip…';

  @override
  String get seekBackward10 => 'Mundur 10 detik';

  @override
  String get seekForward10 => 'Maju 10 detik';

  @override
  String get selectAll => 'Pilih semua';

  @override
  String selected(int count) {
    return '$count dipilih';
  }

  @override
  String selectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get settings => 'Pengaturan';

  @override
  String get settingsAccounts => 'Akun';

  @override
  String get settingsBackup => 'Cadangan';

  @override
  String get settingsDownloads => 'Unduhan';

  @override
  String get settingsGroupApp => 'Aplikasi';

  @override
  String get settingsGroupData => 'Data';

  @override
  String get settingsPlayback => 'Pemutaran';

  @override
  String get settingsTranscripts => 'Transkrip & subtitel';

  @override
  String settingsValueChannels(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saluran',
      one: '1 saluran',
      zero: 'Belum ada saluran',
    );
    return '$_temp0';
  }

  @override
  String get settingsValueCompatOff => 'Kompatibilitas terbaik: nonaktif';

  @override
  String get settingsValueCompatOn => 'Kompatibilitas terbaik: aktif';

  @override
  String get settingsValueNotSet => 'Belum disiapkan';

  @override
  String get settingsValueQuick => 'cepat';

  @override
  String settingsValueSignedIn(String sites) {
    return 'Sudah masuk: $sites';
  }

  @override
  String get settingsValueWifiOnly => 'Hanya Wi‑Fi';

  @override
  String get share => 'Bagikan';

  @override
  String get shareLogs => 'Bagikan log';

  @override
  String get shareOpening => 'Membuka menu bagikan…';

  @override
  String get shareOpeningHint =>
      'File besar memerlukan beberapa detik untuk diserahkan.';

  @override
  String get shareSelected => 'Bagikan yang dipilih';

  @override
  String get sharedLinksAdd => 'Tambahkan';

  @override
  String get sharedLinksBody => 'Masing-masing diunduh ke ponsel ini.';

  @override
  String sharedLinksCapped(int max) {
    return 'Hanya $max tautan pertama yang ditambahkan.';
  }

  @override
  String sharedLinksTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tambahkan $count tautan?',
      one: 'Tambahkan 1 tautan?',
    );
    return '$_temp0';
  }

  @override
  String get shortsFilter => 'Shorts';

  @override
  String get shuffle => 'Acak';

  @override
  String get signInRequired => 'Perlu masuk';

  @override
  String get size => 'Ukuran';

  @override
  String get smartPlaylists => 'Playlist pintar';

  @override
  String get sortAndPlatform => 'Urutan dan situs';

  @override
  String get sortBy => 'Urutkan menurut';

  @override
  String get sortLargest => 'Terbesar';

  @override
  String get sortNameAZ => 'Nama A–Z';

  @override
  String get sortNameZA => 'Nama Z–A';

  @override
  String get sortNewest => 'Terbaru';

  @override
  String get sortOldest => 'Terlama';

  @override
  String get sortSmallest => 'Terkecil';

  @override
  String get sortedByLastPlayed => 'Menurut terakhir diputar';

  @override
  String get source => 'Sumber';

  @override
  String get sourceCode => 'Kode sumber';

  @override
  String get startDownload => 'Mulai unduh';

  @override
  String get status => 'Status';

  @override
  String get storageCardMissing =>
      'Kartu tidak terpasang, jadi unduhan disimpan ke ponsel';

  @override
  String get storageLocation => 'Simpan ke';

  @override
  String get storageLocationHelp =>
      'Klip yang sudah diunduh tetap di tempatnya dan tetap tampil di pustaka. Kartu memori memerlukan Android 11 atau yang lebih baru.';

  @override
  String get storageNoCard => 'Tidak ada kartu memori di ponsel ini';

  @override
  String get storagePhone => 'Penyimpanan ponsel';

  @override
  String get streamingOnline => 'Diputar lewat jaringan';

  @override
  String subscriptionAdded(String name) {
    return 'Sekarang mengikuti $name';
  }

  @override
  String get subscriptionName => 'Nama';

  @override
  String get subscriptionPaused => 'Dijeda';

  @override
  String get subscriptionQuality => 'Kualitas untuk saluran ini';

  @override
  String get subscriptionQualityHelp =>
      'Kualitas unduhan video baru dari saluran ini. Anda bisa mengubahnya nanti dengan mengedit saluran; video yang sudah diunduh tetap dengan kualitasnya.\n\n\"Terbaik\" bisa berarti 4K dalam format AV1, yang mungkin tersendat saat diputar di komputer lama: jika begitu, pilih 1080p.';

  @override
  String get subscriptionQualityNote =>
      'Berlaku untuk video baru; yang sudah diunduh tetap dengan kualitasnya.';

  @override
  String get subscriptions => 'Saluran';

  @override
  String get subscriptionsEmpty => 'Belum ada saluran yang diikuti';

  @override
  String get subscriptionsEmptyBody =>
      'Ikuti saluran dan setiap video baru akan terunduh sendiri ke pustaka Anda, saat VidHoist terbuka atau di tray. Video yang sudah ada di saluran tidak diunduh.';

  @override
  String get subscriptionsSubtitle =>
      'Video baru dari saluran yang Anda ikuti, terunduh dengan sendirinya';

  @override
  String get subtitleLangs => 'Bahasa subtitel';

  @override
  String get subtitleLangsHelp =>
      'Diambil jika video memilikinya. Minimal satu tetap terpilih.';

  @override
  String get subtitles => 'Subtitel';

  @override
  String get subtitlesBackground => 'Latar';

  @override
  String get subtitlesBackgroundFaint => 'Tipis';

  @override
  String get subtitlesBackgroundHelp =>
      'Apa yang ada di belakang teks. Tanpa latar, setiap huruf diberi tepi gelap agar tetap terbaca di atas gambar terang.';

  @override
  String get subtitlesBackgroundNone => 'Tidak ada';

  @override
  String get subtitlesBackgroundSolid => 'Gelap';

  @override
  String get subtitlesHide => 'Sembunyikan subtitel';

  @override
  String get subtitlesLanguage => 'Bahasa subtitel';

  @override
  String get subtitlesShow => 'Tampilkan subtitel';

  @override
  String get subtitlesShowHelp =>
      'Di atas video, untuk klip yang memiliki transkrip. Tombol CC di pemutar melakukan hal yang sama.';

  @override
  String get subtitlesSize => 'Ukuran teks';

  @override
  String get subtitlesSizeLarge => 'Besar';

  @override
  String get subtitlesSizeMedium => 'Sedang';

  @override
  String get subtitlesSizeSmall => 'Kecil';

  @override
  String tagLimitReached(int max) {
    return 'Anda bisa memiliki hingga $max tag. Hapus satu di Kelola tag untuk menambah yang lain.';
  }

  @override
  String get tags => 'Tag';

  @override
  String get tagsOpenFiltered => 'Membuka pustaka dengan filter';

  @override
  String get theme => 'Tema';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get titleFilter => 'Hanya unduh judul yang mengandung';

  @override
  String get titleFilterHelp =>
      'Video baru dari saluran ini hanya diunduh jika judulnya mengandung apa yang Anda tulis di sini.\n\n• Satu kata biasa sudah cukup: Episode\n• Salah satu dari beberapa kata: Episode|Bagian (tanda | berarti \"atau\")\n• Huruf besar tidak berpengaruh: episode juga cocok dengan Episode.\n\nVideo yang dilewati filter dianggap sudah dilihat untuk selamanya: menghapus filter nanti akan mengunduh yang datang setelahnya, bukan yang sudah dilewati.';

  @override
  String get titleFilterHelper =>
      'Beberapa kata: pisahkan dengan | . Biarkan kosong untuk semuanya.';

  @override
  String get titleFilterHint => 'mis. Episode';

  @override
  String get titleLabel => 'Judul';

  @override
  String totalDuration(Object duration) {
    return 'Total: $duration';
  }

  @override
  String get transcript => 'Transkrip';

  @override
  String transcriptSaidMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Diucapkan $count kali lagi',
      one: 'Diucapkan sekali lagi',
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
      zero: 'Belum ada klip',
    );
    return '$_temp0';
  }

  @override
  String get transcriptsDeleteAll => 'Hapus semua';

  @override
  String get transcriptsDeleteTitle => 'Hapus semua transkrip?';

  @override
  String get transcriptsSaidInside => 'Diucapkan di dalam klip';

  @override
  String get transcriptsSearchHelp =>
      'Menyimpan kata-kata dari setiap klip YouTube yang Anda tambahkan, sehingga Anda bisa mencari apa yang diucapkan.';

  @override
  String get tryAgain => 'Coba lagi';

  @override
  String get undo => 'Urungkan';

  @override
  String get unfollow => 'Berhenti ikuti';

  @override
  String unfollowConfirm(String name) {
    return 'Berhenti mengikuti $name?';
  }

  @override
  String get unfollowConfirmBody =>
      'VidHoist akan melupakan video mana saja yang sudah dilihatnya di saluran ini. Jika Anda mengikutinya lagi nanti, semua video yang ada saat itu dianggap sudah dilihat, dan yang terlewat tidak akan diunduh. Menjeda tetap menyimpan ingatan itu.';

  @override
  String get unlockTouch => 'Buka kunci';

  @override
  String get unpinPlaylist => 'Lepas sematan';

  @override
  String get updateNoticeBody => 'Buka VidHoist untuk memasangnya.';

  @override
  String get upNext => 'Berikutnya';

  @override
  String upNextIn(String name) {
    return 'Berikutnya di «$name»';
  }

  @override
  String get updateAllowInstallBody =>
      'Android memerlukan izin Anda sebelum aplikasi dapat menginstal pembaruannya sendiri. Berikan sekali di pengaturan sistem, lalu ketuk Instal lagi.';

  @override
  String get updateAllowInstallTitle => 'Izinkan instal pembaruan';

  @override
  String get updateAvailable => 'Pembaruan tersedia';

  @override
  String get updateCheckFailed => 'Tidak dapat memeriksa pembaruan';

  @override
  String get updateChecking => 'Memeriksa…';

  @override
  String get updateDownloadFailed => 'Tidak dapat mengunduh pembaruan';

  @override
  String updateDownloadedMb(String done, String total) {
    return '$done dari $total MB';
  }

  @override
  String get updateDownloading => 'Mengunduh pembaruan…';

  @override
  String get updateFailedToStart => 'Tidak dapat membuka penginstal';

  @override
  String get updateInstall => 'Instal';

  @override
  String get updateLater => 'Nanti';

  @override
  String get updateNever => 'Belum';

  @override
  String get updateNow => 'Unduh pembaruan';

  @override
  String get updateOpenSystemSettings => 'Buka pengaturan';

  @override
  String get updateReady => 'Siap diinstal';

  @override
  String updateSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get updateSkipVersion => 'Lewati versi ini';

  @override
  String get updateUpToDate => 'Anda menggunakan versi terbaru';

  @override
  String updateVersionAvailable(String version) {
    return 'Versi $version tersedia';
  }

  @override
  String updateVersionTitle(String version) {
    return 'Versi $version';
  }

  @override
  String get updateWhatsNew => 'Yang baru';

  @override
  String get updates => 'Pembaruan';

  @override
  String get version => 'Versi';

  @override
  String get videoAdded => 'Ditambahkan ke playlist';

  @override
  String get videoPlayer => 'Pemutar video';

  @override
  String get viewAll => 'Lihat semua';

  @override
  String get viewAllInPlaylists => 'Lihat semua';

  @override
  String get viewCards => 'Kartu';

  @override
  String get viewGrid => 'Kisi';

  @override
  String get viewList => 'Daftar';

  @override
  String get viewMode => 'Tampilan';

  @override
  String get waitingForWifi => 'Menunggu Wi-Fi';

  @override
  String get whatsNewGotIt => 'Mengerti';

  @override
  String get whatsNewReleasePage => 'Halaman rilis';

  @override
  String get whatsNewThisVersion => 'Yang baru di versi ini';

  @override
  String whatsNewTitle(String version) {
    return 'Yang baru di $version';
  }

  @override
  String get whatsNewUnavailable =>
      'Perubahan di versi ini ada di halaman rilis.';

  @override
  String get wifiOnly => 'Unduh hanya lewat Wi-Fi';

  @override
  String get wifiOnlyHelp =>
      'Tidak ada yang diunduh lewat data seluler. Unduhan menunggu Wi-Fi, dan unduhan yang sedang berjalan saat Wi-Fi terputus akan dijeda lalu berlanjut sendiri saat Wi-Fi kembali.';

  @override
  String get yourPlaylists => 'Playlist Anda';

  @override
  String get yourTags => 'Tag Anda';

  @override
  String get ytdlpCredit => 'Pengunduh yang dijalankan VidHoist';
}
