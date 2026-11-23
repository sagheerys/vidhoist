// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'vh_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class VhLocalizationsRu extends VhLocalizations {
  VhLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get about => 'О приложении';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get aboutDescriptionPhone =>
      'Лёгкое и быстрое приложение для скачивания видео и аудио с множества сайтов через yt-dlp. Со своим плеером и плейлистами.';

  @override
  String get accountSignIn => 'Войти';

  @override
  String get accountSignOut => 'Выйти';

  @override
  String get accountSignedIn => 'Вход выполнен';

  @override
  String get accountSignedOut => 'Вход не выполнен';

  @override
  String accountSignedOutOf(String site) {
    return 'Вы вышли из аккаунта: $site';
  }

  @override
  String get accountsBanRisk =>
      'Лучше использовать дополнительный аккаунт: при активном скачивании сайт может на время ограничить аккаунт.';

  @override
  String get accountsClearAll => 'Удалить все cookies';

  @override
  String get accountsCleared => 'Cookies удалены';

  @override
  String get accountsFileHint =>
      'Файл cookies.txt (формат Netscape), экспортированный из браузера, для любого сайта, в том числе не из списка выше. Он добавляется к уже выполненным входам и остаётся на этом телефоне.';

  @override
  String get accountsFilePick => 'Выбрать файл cookies';

  @override
  String get accountsFileTitle => 'Или импортируйте файл cookies';

  @override
  String get accountsFromFile => 'Из файла cookies';

  @override
  String get accountsHelp =>
      'Вход со временем истекает: когда сайт снова начнёт отказывать, войдите ещё раз. Выход из одного сайта выполняет во встроенном браузере выход и из остальных, но их загрузки продолжаются как прежде. Если сайт не даёт войти здесь, импортируйте ниже файл cookies из браузера на компьютере.';

  @override
  String get accountsHint =>
      'Для сайтов, которые не дают скачивать без входа. Вы входите на странице самого сайта внутри приложения; то, что он сохраняет, остаётся на этом телефоне, где yt-dlp читает это при каждой загрузке, и больше никуда не передаётся.';

  @override
  String get activeDownloads => 'Активные загрузки';

  @override
  String activeDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count загрузки выполняется',
      many: '$count загрузок выполняется',
      few: '$count загрузки выполняются',
      one: '$count загрузка выполняется',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloadsSheet => 'Активные загрузки';

  @override
  String get activeNow => 'Активно сейчас';

  @override
  String get addLinkFab => 'Добавить ссылку';

  @override
  String get addTo => 'Добавить в…';

  @override
  String get addToFavorites => 'Добавить в избранное';

  @override
  String get addToPlaylist => 'Добавить в плейлист';

  @override
  String get addUrl => 'Добавить URL';

  @override
  String addedNToServer(int count) {
    return 'Добавлено в загрузки: $count';
  }

  @override
  String get addedToFavorites => 'Добавлено в избранное';

  @override
  String addedToPlaylistCount(int count) {
    return 'Добавлено в плейлист: $count';
  }

  @override
  String get allDownloadsFinished => 'Все загрузки завершены.';

  @override
  String get allPlatforms => 'Все сайты';

  @override
  String get alreadyInPlaylist => 'Уже добавлено';

  @override
  String get alreadySubscribed => 'Вы уже подписаны на этот канал';

  @override
  String get appTitle => 'VidHoist';

  @override
  String get appearanceAndLanguage => 'Внешний вид и язык';

  @override
  String audioChannels(int count) {
    return 'Аудиоканалы: $count';
  }

  @override
  String get audioFormat => 'Формат аудио';

  @override
  String get audioFormatM4a => 'M4A: воспроизводится везде';

  @override
  String get audioFormatMp3 => 'MP3: для старых плееров и автомобилей';

  @override
  String get audioFormatOriginal => 'Как отдаёт сайт, без конвертации';

  @override
  String get audioMono => 'Моно';

  @override
  String get audioOnly => 'Только аудио';

  @override
  String get audioStereo => 'Стерео';

  @override
  String get autoBuilt => 'Автоматически';

  @override
  String get autoCheckUpdates => 'Проверять автоматически';

  @override
  String get autoCheckUpdatesHelp =>
      'Ищет новую версию в фоне примерно два раза в день.';

  @override
  String get autoRestoreSuccess => 'Данные восстановлены из резервной копии.';

  @override
  String get autoRetry => 'Повторять, когда появится сеть';

  @override
  String get autoRetryHelp =>
      'Всё, что не скачалось из-за пропажи сети, повторяется само, когда она вернётся. То, от чего отказался сайт, не повторяется: повтор без изменений снова закончится ошибкой.';

  @override
  String get backgroundChecks => 'Проверять, когда приложение закрыто';

  @override
  String get backgroundChecksHelp =>
      'Примерно раз в шесть часов, когда есть сеть и заряд не низкий. Только сообщает о новом; видео скачиваются, когда вы открываете VidHoist.';

  @override
  String get backgroundDownload => 'Скачивание файлов в фоне…';

  @override
  String backgroundLastRun(String when) {
    return 'Последняя проверка при закрытом приложении: $when';
  }

  @override
  String get backgroundNotRunYet =>
      'Проверок при закрытом приложении ещё не было: время выбирает Android.';

  @override
  String get backgroundOfferBody =>
      'VidHoist может примерно раз в шесть часов заглядывать в ваши каналы и сообщать о новом. Ничего не скачивается, пока вы не откроете приложение.';

  @override
  String get backgroundOfferNo => 'Не сейчас';

  @override
  String get backgroundOfferTitle =>
      'Сообщать о новых видео, когда VidHoist закрыт?';

  @override
  String get backgroundOfferYes => 'Включить';

  @override
  String get backupNote =>
      'Включает медиатеку, плейлисты, метки, подписки на каналы и настройки. Входы и расшифровки хранятся отдельно, а сами медиафайлы не включаются.';

  @override
  String get backupSettings => 'Резервная копия всех данных';

  @override
  String get backupSettingsSubtitle =>
      'Семь датированных копий, которые обновляются сами. Восстановите любую или экспортируйте, чтобы поделиться';

  @override
  String backupSuccess(Object path) {
    return 'Резервная копия сохранена: $path';
  }

  @override
  String backupsKept(int count) {
    return 'Хранится резервных копий: $count';
  }

  @override
  String get batchDownloadSelected => 'Скачать выбранное';

  @override
  String get batchLoading => 'Чтение плейлиста…';

  @override
  String get batchNothingSelected => 'Выберите хотя бы один элемент';

  @override
  String batchSelectedOf(int selected, int total) {
    return 'Выбрано $selected из $total';
  }

  @override
  String get batchThisVideoOnly => 'Скачать только этот клип';

  @override
  String get batchTitle => 'Пакетная загрузка';

  @override
  String get batteryAllow => 'Разрешить';

  @override
  String get batteryFree =>
      'Экономия заряда не трогает загрузки, даже когда приложение скрыто.';

  @override
  String get batteryRestricted =>
      'Экономия заряда может остановить долгую загрузку, пока приложение скрыто.';

  @override
  String get batteryStateFree => 'Разрешено';

  @override
  String get batteryStateLimited => 'Ограничено';

  @override
  String get batteryTitle => 'Загрузки в фоне';

  @override
  String bitrateKbps(String value) {
    return '$value кбит/с';
  }

  @override
  String bitrateMbps(String value) {
    return '$value Мбит/с';
  }

  @override
  String get builtWith => 'Создано с помощью';

  @override
  String get cancel => 'Отмена';

  @override
  String get changeQuality => 'Изменить качество';

  @override
  String get channelNameFolder => 'По названию канала';

  @override
  String channelFollowers(String count) {
    return 'Подписчиков: $count';
  }

  @override
  String get channelCheckFailed =>
      'В этот раз проверить не удалось. VidHoist попробует снова сам.';

  @override
  String get channelUrl => 'Ссылка на канал, плейлист или одно из его видео';

  @override
  String get channelUrlHint => 'https://www.youtube.com/@name';

  @override
  String chapterNumber(int number) {
    return 'Глава $number';
  }

  @override
  String get chaptersFold => 'Скрыть главы';

  @override
  String chaptersFromTranscript(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count главы из расшифровки',
      many: '$count глав из расшифровки',
      few: '$count главы из расшифровки',
      one: '$count глава из расшифровки',
    );
    return '$_temp0';
  }

  @override
  String get chaptersShowAll => 'Все главы';

  @override
  String get chaptersUnfold => 'Показать главы';

  @override
  String get checkEvery => 'Как часто проверять';

  @override
  String get checkForUpdates => 'Проверить обновления';

  @override
  String get checkNow => 'Проверить сейчас';

  @override
  String get checkQueued => 'Проверяем. Всё новое появится в медиатеке.';

  @override
  String get chooseFolder => 'Выбрать папку';

  @override
  String get chooseOptions => 'Параметры';

  @override
  String get clear => 'Очистить';

  @override
  String get clearLogs => 'Очистить журналы';

  @override
  String get clearLogsConfirm => 'Удалить все диагностические журналы?';

  @override
  String get clipEndAfterStart => 'После начала';

  @override
  String get clipFrom => 'С';

  @override
  String clipLength(Object length) {
    return 'Длина видео: $length';
  }

  @override
  String get clipLengthReading => 'Определяем длину видео…';

  @override
  String get clipLengthUnknown =>
      'Сайт не сообщает длину видео, поэтому время не проверяется';

  @override
  String get clipMinuteDown => 'На минуту раньше';

  @override
  String get clipMinuteUp => 'На минуту позже';

  @override
  String get clipOnly => 'Только часть видео';

  @override
  String get clipOnlyHelp =>
      'От одного момента до другого, без остального. Без субтитров.';

  @override
  String clipPastEnd(Object length) {
    return 'Видео заканчивается на $length';
  }

  @override
  String get clipTimeHint => 'Можно только цифры: 130 — это 1:30';

  @override
  String get clipTo => 'До';

  @override
  String get clipboardFound => 'В буфере обмена есть ссылка';

  @override
  String get clipboardLinkReady => 'Вставить ссылку';

  @override
  String get closePlayer => 'Закрыть плеер';

  @override
  String get columnAdded => 'Добавлено';

  @override
  String get columnLength => 'Длина';

  @override
  String get compactView => 'Компактный вид';

  @override
  String get compatiblePlayback => 'Лучшая совместимость воспроизведения';

  @override
  String get compatiblePlaybackHelp =>
      'Запрашивает H.264/AAC, который любой телефон декодирует аппаратно. Без этого YouTube может отдать AV1, который многие устройства показывают с искажённой картинкой. Если выключить, станет доступно максимальное разрешение ценой совместимости.';

  @override
  String get completed => 'Завершено';

  @override
  String get continueAsAudio => 'Продолжить как аудио';

  @override
  String get continueAsAudioBody =>
      'Продолжить воспроизведение как аудио с той же секунды?';

  @override
  String get continueAsAudioNo => 'Нет, остановить';

  @override
  String get continueAsAudioTitle => 'Продолжить в фоне?';

  @override
  String get cookies => 'Cookies';

  @override
  String get cookiesNotNetscape =>
      'Ни в одном из этих файлов нет cookies в формате Netscape';

  @override
  String get cookiesSubtitle =>
      'Для сайтов, которые не дают скачивать без входа';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get copyright => '© 2026 Yasir Sagheer';

  @override
  String get couldNotLoadPlaylist =>
      'Не удалось загрузить плейлист. Проверьте URL и подключение.';

  @override
  String get create => 'Создать';

  @override
  String get createPlaylist => 'Создать плейлист';

  @override
  String get defaultQuality => 'Качество видео по умолчанию';

  @override
  String get delete => 'Удалить';

  @override
  String deleteMultipleConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалить $count клипа?\n\nИх файлы будут удалены с устройства.',
      many: 'Удалить $count клипов?\n\nИх файлы будут удалены с устройства.',
      few: 'Удалить $count клипа?\n\nИх файлы будут удалены с устройства.',
      one: 'Удалить $count клип?\n\nИх файлы будут удалены с устройства.',
    );
    return '$_temp0';
  }

  @override
  String deletePlaylistConfirm(Object name) {
    return 'Удалить «$name»?';
  }

  @override
  String get deleteRefused =>
      'Не удалено: Android нужно ваше разрешение на удаление этого файла — в окне, которое он показывает.';

  @override
  String get deleteSelected => 'Удалить выбранное';

  @override
  String get deleteTag => 'Удалить метку';

  @override
  String deleteTagConfirm(Object tag) {
    return 'Удалить метку «$tag» со всех элементов? Сами клипы не удаляются.';
  }

  @override
  String get deleteVideo => 'Удалить клип';

  @override
  String deleteVideoConfirm(Object title) {
    return 'Удалить «$title»?\n\nФайл будет удалён с устройства.';
  }

  @override
  String deletedCount(Object count) {
    return 'Удалено: $count';
  }

  @override
  String deletedTitle(Object title) {
    return 'Удалено: $title';
  }

  @override
  String get deselectAll => 'Снять выделение';

  @override
  String desktopAddLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Добавить $count ссылки',
      many: 'Добавить $count ссылок',
      few: 'Добавить $count ссылки',
      one: 'Добавить $count ссылку',
      zero: 'Нечего добавить',
    );
    return '$_temp0';
  }

  @override
  String get desktopBack => 'Назад';

  @override
  String get desktopBackUpNow => 'Создать копию сейчас';

  @override
  String get desktopBackupHint =>
      'Этот компьютер хранит семь последних резервных копий, сделанных минимум с часовым интервалом, в Downloads\\VidHoist\\Backups, где они переживут удаление приложения.';

  @override
  String get desktopBackupsNone => 'Резервных копий пока нет';

  @override
  String get desktopBrowserButton => 'Кнопка «В VidHoist» в браузере';

  @override
  String get desktopBrowserButtonCopied =>
      'Код скопирован. Создайте новую закладку и вставьте его как адрес (URL).';

  @override
  String get desktopBrowserButtonCopy => 'Скопировать код';

  @override
  String get desktopBrowserButtonFailed =>
      'Не удалось открыть страницу; скопируйте код.';

  @override
  String get desktopBrowserButtonHint =>
      'Кнопка на панели закладок: один щелчок на странице любого видео открывает здесь окно добавления с его ссылкой. Ничего не отправляется, пока вы не нажмёте «Добавить».';

  @override
  String get desktopBrowserButtonName => 'В VidHoist';

  @override
  String get desktopBrowserButtonOpen => 'Открыть страницу настройки';

  @override
  String get desktopBrowserPageCopyInstead =>
      'Если перетаскивание не работает, создайте новую закладку и вставьте это как её адрес:';

  @override
  String get desktopBrowserPageDragHint =>
      'Перетащите её на панель; щелчок здесь ничего не делает.';

  @override
  String get desktopBrowserPageStep1 =>
      'Покажите панель закладок, если она скрыта:';

  @override
  String get desktopBrowserPageStep2 =>
      'Перетащите кнопку ниже на панель мышью.';

  @override
  String get desktopBrowserPageStep3 =>
      'На странице любого видео нажмите на неё: VidHoist откроет окно добавления со ссылкой. В первый раз браузер спросит, открыть ли приложение; разрешите.';

  @override
  String get desktopBrowserPageTitle =>
      'Добавьте кнопку «В VidHoist» в браузер';

  @override
  String get desktopChangeFolder => 'Изменить…';

  @override
  String get desktopChannel => 'Канал';

  @override
  String get desktopChannelClips => 'В вашей медиатеке';

  @override
  String get desktopChannels => 'Каналы';

  @override
  String get desktopChannelsInLibrary => 'Каналы в вашей медиатеке';

  @override
  String get desktopChannelsLater => 'Нужен движок загрузки';

  @override
  String get desktopChannelsLaterBody =>
      'Для подписки на канал нужен yt-dlp на этом компьютере. Настройте его в «Настройки › Движок», и ваши каналы появятся здесь.';

  @override
  String get desktopChapters => 'Главы';

  @override
  String get desktopCheckAll => 'Проверить все';

  @override
  String get desktopChooseClip => 'Выбрать';

  @override
  String get desktopClearFilters => 'Сбросить фильтры';

  @override
  String get desktopClearSelection => 'Снять выделение';

  @override
  String get desktopCookiesBrowser => 'Из браузера';

  @override
  String get desktopCookiesBrowserHint =>
      'Читаются из браузера, в котором выполнен вход. Если прочитать не удаётся, закройте этот браузер и попробуйте снова.';

  @override
  String get desktopCookiesChoose => 'Выбрать файл…';

  @override
  String get desktopCookiesFile => 'Файл cookies';

  @override
  String get desktopCookiesHelp =>
      'В браузере используйте расширение, которое экспортирует cookies в формате Netscape (один файл на сайт), и выберите здесь все файлы сразу. Затем yt-dlp использует их при каждой загрузке. Cookies истекают, поэтому если загрузка снова начинает сбоить, обычно пора экспортировать их заново.';

  @override
  String get desktopCookiesKept => 'Cookies на этом компьютере';

  @override
  String desktopCookiesKeptFor(String sites) {
    return 'Cookies сохранены для: $sites';
  }

  @override
  String get desktopCookiesLocalHint =>
      'Для сайтов, где нужен вход. yt-dlp читает их на этом компьютере, и больше они никуда не передаются.';

  @override
  String get desktopCookiesNone => 'Нет';

  @override
  String get desktopCookiesRemove => 'Удалить';

  @override
  String get desktopCopiedLinkAdd => 'Добавить…';

  @override
  String get desktopCopiedLinkTitle => 'Скачать эту ссылку?';

  @override
  String get desktopCopyFile => 'Копировать файл';

  @override
  String get desktopCopyFileFailed => 'Не удалось скопировать файл';

  @override
  String get desktopCopyLink => 'Копировать ссылку';

  @override
  String get desktopCopyOneClip => 'Копировать можно только по одному клипу';

  @override
  String get desktopCopyQuote => 'Копировать со временем и ссылкой';

  @override
  String get desktopDefaultQualityHint =>
      'С этого начинается каждое добавление; для каждой ссылки его всё равно можно изменить.';

  @override
  String desktopDeleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалить $count клипа? Их файлы на этом компьютере будут удалены.',
      many: 'Удалить $count клипов? Их файлы на этом компьютере будут удалены.',
      few: 'Удалить $count клипа? Их файлы на этом компьютере будут удалены.',
      one: 'Удалить $count клип? Их файлы на этом компьютере будут удалены.',
    );
    return '$_temp0';
  }

  @override
  String get desktopDesktopSection => 'Windows';

  @override
  String get desktopDiscover => 'Возможности VidHoist';

  @override
  String get desktopDiscoverAddLink => 'Вставьте или перетащите ссылку';

  @override
  String get desktopDiscoverAddLinkLine =>
      'Нажмите Ctrl+V в любом месте или перетащите ссылку на окно, чтобы добавить её.';

  @override
  String get desktopDiscoverAdding => 'Добавление и обмен';

  @override
  String get desktopDiscoverBrowser => 'Из браузера';

  @override
  String get desktopDiscoverBrowserLine =>
      'Кнопка «В VidHoist» на панели закладок открывает окно добавления с текущей страницей.';

  @override
  String get desktopDiscoverChapters => 'Главы';

  @override
  String get desktopDiscoverChaptersLine =>
      'Части клипа из его расшифровки, на его странице.';

  @override
  String get desktopDiscoverChoose => 'Выбор нескольких';

  @override
  String get desktopDiscoverChooseLine =>
      'Круглая отметка или щелчок с Ctrl или Shift; затем добавьте их в список или удалите вместе.';

  @override
  String get desktopDiscoverDragOut => 'Перетащите клип наружу';

  @override
  String get desktopDiscoverDragOutLine =>
      'Бросьте его в папку или другое приложение, и он окажется там файлом.';

  @override
  String get desktopDiscoverExport => 'Экспорт расшифровки';

  @override
  String get desktopDiscoverExportLine =>
      'Как текст или как субтитры SRT для другого плеера.';

  @override
  String get desktopDiscoverHint =>
      'Всё, что умеет приложение, по строке на каждое, с клавишами.';

  @override
  String get desktopDiscoverLibrary => 'Медиатека';

  @override
  String get desktopDiscoverListening =>
      'Для звука: тихая комната с большой обложкой на весь экран.';

  @override
  String get desktopDiscoverMini => 'Маленькое окно';

  @override
  String get desktopDiscoverMiniLine =>
      'Небольшая карточка поверх всех окон в нижнем углу экрана.';

  @override
  String get desktopDiscoverReading =>
      'Расшифровка как статья: щёлкните предложение, чтобы слушать с него.';

  @override
  String get desktopDiscoverSaid => 'Что было сказано';

  @override
  String get desktopDiscoverSearch => 'Поиск по сказанному';

  @override
  String get desktopDiscoverSearchLine =>
      'Находите клипы, где прозвучало слово, а не только по названиям.';

  @override
  String get desktopDiscoverShortcutsLine =>
      'Все клавиши, на которые отвечает окно, на одном листе.';

  @override
  String get desktopDiscoverShow => 'Показать';

  @override
  String get desktopDiscoverStatsLine =>
      'Медиатека в цифрах: по сайтам, каналам и месяцам.';

  @override
  String get desktopDiscoverSubtitles =>
      'Расшифровка поверх картинки, с подсветкой звучащего слова.';

  @override
  String get desktopDiscoverTheater =>
      'Картинка крупнее, на месте боковой панели.';

  @override
  String get desktopDiscoverTry => 'Попробовать';

  @override
  String get desktopDiscoverWatching => 'Просмотр и прослушивание';

  @override
  String get desktopDownloadFolder => 'Папка загрузок';

  @override
  String get desktopDownloadFolderHint =>
      'Загрузки сохраняются здесь как обычные файлы: открывайте, перемещайте и копируйте их, как любые другие.';

  @override
  String get desktopDownloads => 'Загрузки';

  @override
  String get desktopDownloadsEmpty =>
      'Ничего не скачивается. Добавьте ссылку, чтобы начать.';

  @override
  String get desktopDownloadsRunning => 'Выполняются';

  @override
  String get desktopDragToReorder => 'Перетащите, чтобы изменить порядок';

  @override
  String get desktopDropLinks => 'Отпустите, чтобы добавить';

  @override
  String get desktopEmptyLibraryLocal =>
      'Добавьте ссылку, и клип появится здесь, когда скачается.';

  @override
  String get desktopEmptyLibraryMessage =>
      'Добавьте ссылку, и клип появится здесь, когда скачается.';

  @override
  String get desktopEngine => 'Движок';

  @override
  String get desktopEngineDenoHint =>
      'Проходит проверку YouTube, чтобы можно было скачать любое доступное качество';

  @override
  String get desktopEngineFetch => 'Загрузить';

  @override
  String get desktopEngineFetchCorrupt =>
      'Полученный файл не совпал с опубликованным, поэтому он не использован.';

  @override
  String get desktopEngineFetchFailed =>
      'Не удалось загрузить. Проверьте подключение и попробуйте снова.';

  @override
  String get desktopEngineFetchInUse =>
      'Используется загрузкой. Попробуйте снова, когда она закончится.';

  @override
  String desktopEngineFetching(int percent) {
    return 'Загрузка · $percent%';
  }

  @override
  String get desktopEngineFfmpegHint =>
      'Объединяет картинку и звук, конвертирует аудио';

  @override
  String get desktopEngineIpv4 => 'Только IPv4';

  @override
  String get desktopEngineIpv4Hint =>
      'Намного быстрее там, где IPv6 не работает, как во многих домашних сетях. Выключайте, только если в вашей сети есть лишь IPv6.';

  @override
  String get desktopEngineMissing =>
      'На этом компьютере нет yt-dlp. Переустановите VidHoist или загрузите его здесь.';

  @override
  String get desktopEngineOnFirstUse =>
      'Будет загружен при первом скачивании, где он нужен';

  @override
  String get desktopEngineUpToDate => 'Установлена последняя версия yt-dlp';

  @override
  String get desktopEngineUpdate => 'Обновить yt-dlp';

  @override
  String get desktopEngineUpdateFailed =>
      'Обновить не удалось. Попробуйте позже.';

  @override
  String get desktopEngineUpdateHint =>
      'Сайты часто меняются; старый yt-dlp перестаёт работать за несколько месяцев.';

  @override
  String desktopEngineUpdated(String version) {
    return 'yt-dlp обновлён до $version';
  }

  @override
  String get desktopEngineUpdating => 'Обновление…';

  @override
  String desktopEngineVersion(String version) {
    return 'Версия $version';
  }

  @override
  String get desktopEngineYtDlpHint => 'Читает ссылку и скачивает её';

  @override
  String get desktopExport => 'Экспорт';

  @override
  String get desktopExportForPhone => 'Экспорт для телефона';

  @override
  String get desktopExportForPhoneHint =>
      'Сохраняет метки, списки и позиции воспроизведения этого компьютера, а также его расшифровки в два файла, которые восстанавливает телефон. Восстановление на телефоне заменяет его собственные метки и списки.';

  @override
  String get desktopExportMarkdown => 'Текст (Markdown)';

  @override
  String get desktopExportPdf => 'Документ (PDF)';

  @override
  String get desktopExportPhone => 'Для телефона (импорт в VidHoist)';

  @override
  String get desktopExportSrt => 'Субтитры (SRT)';

  @override
  String desktopExported(String name) {
    return 'Сохранено: $name';
  }

  @override
  String desktopFileReadyToPaste(String name, String size) {
    return 'Готово к вставке: $name · $size';
  }

  @override
  String get desktopFolderUnavailable => 'Нет доступной папки';

  @override
  String get desktopFolders => 'Папки';

  @override
  String get desktopForward => 'Вперёд';

  @override
  String get desktopGlobalShortcut => 'Пуск и пауза из любого приложения';

  @override
  String desktopGlobalShortcutHint(String keys) {
    return '$keys запускает и ставит на паузу, даже когда окно за другими приложениями.';
  }

  @override
  String desktopGlobalShortcutTaken(String keys) {
    return '$keys уже использует другое приложение.';
  }

  @override
  String get desktopHidePanel => 'Скрыть боковую панель';

  @override
  String get desktopHintShortcuts =>
      'Нажмите ?, чтобы увидеть сочетания клавиш. Пробел — пуск и пауза, стрелки — перемотка.';

  @override
  String get desktopHintShortcutsAction => 'Сочетания клавиш';

  @override
  String get desktopHintTrayBody =>
      'Воспроизведение продолжается из значка у часов. Чтобы выйти, щёлкните значок правой кнопкой.';

  @override
  String get desktopHintTrayTitle => 'VidHoist всё ещё работает';

  @override
  String get desktopHints => 'Показывать подсказки';

  @override
  String get desktopHintsAgain => 'Показать снова';

  @override
  String get desktopHintsHint =>
      'Две короткие подсказки, каждая один раз: о клавишах — при первом клипе, о значке у часов — при первом закрытии.';

  @override
  String get desktopImportFromPhone =>
      'Импорт резервной копии или расшифровок…';

  @override
  String get desktopImportHint =>
      'Файл резервной копии или расшифровок VidHoist, выбранный здесь или перетащенный на окно. Файл с телефона добавляется к тому, что здесь есть; резервная копия этого компьютера восстанавливается целиком, после подтверждения.';

  @override
  String desktopImportedBackup(int tagged, int lists, int positions) {
    return 'Добавлено с телефона. Метки: $tagged · списки: $lists · позиции: $positions';
  }

  @override
  String get desktopImportedNothing =>
      'Ничего нового: на этом компьютере всё это уже было.';

  @override
  String desktopImportedTranscripts(int count) {
    return 'Добавлено расшифровок: $count';
  }

  @override
  String desktopInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count в вашей медиатеке',
      many: '$count в вашей медиатеке',
      few: '$count в вашей медиатеке',
      one: '$count в вашей медиатеке',
    );
    return '$_temp0';
  }

  @override
  String get desktopKeepAwake =>
      'Не давать компьютеру засыпать во время загрузки';

  @override
  String get desktopKeepAwakeHint =>
      'Чтобы ссылка с телефона или длинный плейлист докачались, а не остановились, когда Windows уходит в сон. Экран при этом гаснет как обычно.';

  @override
  String get desktopKeyAddLink => 'Добавить скопированную ссылку';

  @override
  String get desktopKeyFavorite => 'Добавить в избранное или убрать';

  @override
  String get desktopKeyFullScreen =>
      'Полный экран; для звука — комната прослушивания';

  @override
  String get desktopKeyMenu => 'Меню клипа';

  @override
  String get desktopKeyMini => 'Маленькое окно поверх других и обратно';

  @override
  String get desktopKeyPlayPause => 'Пуск или пауза';

  @override
  String get desktopKeyRepeat => 'Сменить режим повтора';

  @override
  String get desktopKeySearch => 'Поиск по названиям и сказанному';

  @override
  String get desktopKeySeek => 'Назад или вперёд на 10 секунд';

  @override
  String get desktopKeyShortcuts => 'Этот список';

  @override
  String get desktopKeyVolume =>
      'Громче или тише; в Shorts — предыдущий или следующий ролик';

  @override
  String get desktopKeyZoomIn => 'Крупнее интерфейс';

  @override
  String get desktopKeyZoomOut => 'Мельче интерфейс';

  @override
  String get desktopKeyZoomReset => 'Обычный размер интерфейса';

  @override
  String get desktopLanguageSystemHint => 'Как язык Windows.';

  @override
  String desktopLastArrival(String when) {
    return 'Последнее поступление: $when';
  }

  @override
  String get desktopLess => 'Меньше';

  @override
  String get desktopLibraryLoading => 'Загрузка медиатеки…';

  @override
  String get desktopLinkCopied => 'Ссылка скопирована';

  @override
  String get desktopLinkDuplicate => 'Повтор, есть выше';

  @override
  String get desktopLinkInLibrary => 'Уже в вашей медиатеке';

  @override
  String get desktopLinkPlaylist => 'Плейлист: выберите клипы';

  @override
  String get desktopLinkReady => 'Готово';

  @override
  String get desktopLinkUnsupported => 'Незнакомый приложению сайт';

  @override
  String desktopLinksDropped(int count, int limit) {
    return 'Взято только первых ссылок: $limit; пропущено ещё: $count.';
  }

  @override
  String desktopLinksFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ссылки',
      many: '$count ссылок',
      few: '$count ссылки',
      one: '$count ссылка',
    );
    return '$_temp0';
  }

  @override
  String get desktopListeningClose => 'Закрыть комнату прослушивания';

  @override
  String get desktopListeningRoom => 'Комната прослушивания';

  @override
  String get desktopLogsCopied => 'Журнал скопирован, без ссылок и адресов';

  @override
  String get desktopLogsCopy => 'Копировать';

  @override
  String get desktopLogsSave => 'Сохранить в файл';

  @override
  String get desktopMiniRestore => 'Вернуться к полному окну';

  @override
  String get desktopMiniWindow => 'Маленькое окно';

  @override
  String get desktopMore => 'Ещё';

  @override
  String get desktopNarrowSidebar => 'Свернуть боковую панель';

  @override
  String get desktopNoChannelNames =>
      'У клипов в вашей медиатеке не указан канал, поэтому клипы этого канала не выделить. Подпишитесь на него с отдельной папкой, и всё, что туда поступит, появится здесь.';

  @override
  String get desktopNoFavoritesMessage =>
      'Отметьте клип как избранный, и он будет ждать вас здесь.';

  @override
  String get desktopNoFavoritesTitle => 'В избранном пока пусто';

  @override
  String get desktopNoMatchMessage => 'Сбросьте фильтр, чтобы увидеть больше.';

  @override
  String get desktopNoMatchTitle => 'Ничего не подходит под эти фильтры';

  @override
  String get desktopNoTags =>
      'Меток пока нет. Добавьте метку клипу на его странице, и она появится здесь.';

  @override
  String get desktopNoTranscriptMessage =>
      'Она появится здесь, когда субтитры клипа будут скачаны вместе с ним.';

  @override
  String get desktopNoTranscriptTitle => 'У этого клипа нет расшифровки';

  @override
  String get desktopNotABackup =>
      'Это не файл резервной копии или расшифровок VidHoist.';

  @override
  String desktopNotWatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count не просмотрено',
      many: '$count не просмотрено',
      few: '$count не просмотрены',
      one: '$count не просмотрен',
    );
    return '$_temp0';
  }

  @override
  String get desktopNothingPlaying => 'Ничего не воспроизводится';

  @override
  String get desktopNothingPlayingHint =>
      'Включите клип, и здесь появятся его расшифровка, что будет дальше и подробности.';

  @override
  String get desktopNotifyArrivalsHint =>
      'Уведомление Windows, когда скачаны новые клипы с каналов из ваших подписок.';

  @override
  String get desktopOfferCopiedLinks => 'Предлагать скопированные ссылки';

  @override
  String get desktopOfferCopiedLinksHint =>
      'Когда вы копируете ссылку на видео в другом приложении, уведомление предложит её добавить. Проверяются только ссылки, и ничего не сохраняется.';

  @override
  String get desktopOpenBackup => 'Открыть резервную копию';

  @override
  String get desktopOpenChannels => 'Открыть каналы';

  @override
  String get desktopOpenInExplorer => 'Открыть в Проводнике';

  @override
  String get desktopOpenWith => 'Открыть в другом плеере…';

  @override
  String get desktopPaletteClose => 'закрыть';

  @override
  String get desktopPaletteCommands => 'Команды';

  @override
  String get desktopPaletteHint =>
      'Ищите по названиям и сказанному или введите > для команд';

  @override
  String desktopPaletteList(String name) {
    return 'Список: $name';
  }

  @override
  String get desktopPaletteMove => 'перемещение';

  @override
  String get desktopPaletteOpen => 'открыть';

  @override
  String get desktopPaletteSaid => 'Сказано в клипах';

  @override
  String get desktopPaletteSave => 'Сохранить этот поиск';

  @override
  String desktopPaletteSettings(String section) {
    return 'Настройки: $section';
  }

  @override
  String get desktopPaletteTitles => 'Названия';

  @override
  String get desktopPinned => 'Закреплённые';

  @override
  String get desktopPlayNext => 'Воспроизвести следующим';

  @override
  String get desktopPlaysNext => 'Следующий, после этого';

  @override
  String get desktopQueueEnd => 'После этого ничего нет';

  @override
  String desktopQuote(String text, String title, String time, String link) {
    return '«$text»\n— $title, $time\n$link';
  }

  @override
  String get desktopQuoteCopied => 'Скопировано со временем и ссылкой';

  @override
  String get desktopReadingBack => 'Назад к клипу';

  @override
  String get desktopReadingCloseFind => 'Закрыть поиск';

  @override
  String get desktopReadingFind => 'Найти в тексте';

  @override
  String desktopReadingFound(int at, int count) {
    return '$at из $count';
  }

  @override
  String get desktopReadingHint =>
      'Щёлкните предложение, чтобы слушать с него · Ctrl+F ищет слово · выделите, чтобы скопировать со временем';

  @override
  String get desktopReadingNextMatch => 'Следующее совпадение';

  @override
  String get desktopReadingPreviousMatch => 'Предыдущее совпадение';

  @override
  String get desktopReadingRoom => 'Режим чтения';

  @override
  String get desktopRecoverLibrary => 'Клипы, уже лежащие в папке';

  @override
  String get desktopRecoverLibraryAction => 'Поискать в папке';

  @override
  String get desktopRecoverLibraryHint =>
      'После переустановки: возвращает в медиатеку клипы, которые лежат в папке загрузок, но больше не значатся в списке. Сами файлы не затрагиваются.';

  @override
  String desktopRecovered(int count) {
    return 'Возвращено в медиатеку: $count';
  }

  @override
  String get desktopRecoveredNothing =>
      'Нечего добавить: все клипы из папки уже в медиатеке.';

  @override
  String desktopRecoveredSome(int count, int left) {
    return 'Возвращено в медиатеку: $count. Пропущено из-за неизвестной ссылки: $left';
  }

  @override
  String get desktopRemoveFromList => 'Убрать из списка';

  @override
  String get desktopRestore => 'Восстановить';

  @override
  String get desktopRestoreBody =>
      'Медиатека, подписки на каналы, метки, списки и настройки этого компьютера станут такими, как в резервной копии. Скачанные файлы не затрагиваются.';

  @override
  String desktopRestoreOfferBody(String when) {
    return 'В Downloads\\VidHoist\\Backups есть резервная копия этого компьютера: медиатека, подписки на каналы, плейлисты, метки, настройки и сохранённые расшифровки. Последняя сделана $when. Ваши скачанные файлы в любом случае не затрагиваются.';
  }

  @override
  String get desktopRestoreOfferTitle => 'Восстановить резервную копию?';

  @override
  String get desktopRestoreTitle => 'Восстановить эту резервную копию?';

  @override
  String get desktopRestored => 'Резервная копия восстановлена';

  @override
  String get desktopRevealAfterDownload =>
      'Показывать в Проводнике по завершении';

  @override
  String get desktopRevealAfterDownloadHint =>
      'Когда файл скачан на этот компьютер, открывается его папка с выделенным файлом.';

  @override
  String desktopSavedIn(String folder) {
    return 'Сохранено в $folder';
  }

  @override
  String desktopSavedSearchDelete(String name) {
    return 'Удалить сохранённый поиск «$name»? В медиатеке ничего не изменится.';
  }

  @override
  String get desktopSavedSearchName => 'Название поиска';

  @override
  String get desktopSearch => 'Поиск';

  @override
  String get desktopSearchHint => 'Поиск по названиям и сказанному…';

  @override
  String get desktopSearchSaved => 'Сохранено на боковой панели';

  @override
  String get desktopSeekBar => 'Позиция в клипе';

  @override
  String desktopSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выбрано $count',
      many: 'Выбрано $count',
      few: 'Выбрано $count',
      one: 'Выбран $count',
    );
    return '$_temp0';
  }

  @override
  String get desktopSetupChooseFile => 'Выбрать файл…';

  @override
  String get desktopShortcutsApp => 'Приложение';

  @override
  String get desktopShortcutsClip => 'На выбранном клипе';

  @override
  String get desktopShortcutsPlayback => 'Воспроизведение';

  @override
  String get desktopShortcutsTitle => 'Сочетания клавиш';

  @override
  String get desktopShortcutsWindow => 'Окно';

  @override
  String get desktopShortsHint =>
      '↑ ↓ или колесо — следующий ролик · двойной щелчок — в избранное';

  @override
  String get desktopShowInFolder => 'Показать в папке';

  @override
  String get desktopShowPanel => 'Показать боковую панель';

  @override
  String get desktopStartFresh => 'Начать с нуля';

  @override
  String get desktopStartWithWindows => 'Запускать вместе с Windows';

  @override
  String get desktopStartWithWindowsHint =>
      'Открывается при входе в систему: в области уведомлений, если воспроизведение продолжается там, иначе свёрнутым.';

  @override
  String get desktopStartWithWindowsRefused =>
      'Windows не разрешила запускать приложение вместе с системой.';

  @override
  String get desktopStats => 'Статистика медиатеки';

  @override
  String get desktopStatsByChannel => 'По каналам';

  @override
  String get desktopStatsByMonth => 'По месяцу добавления';

  @override
  String get desktopStatsBySite => 'По сайтам';

  @override
  String get desktopStatsClips => 'Клипы';

  @override
  String get desktopStatsHint =>
      'Что есть в медиатеке и на что стоит взглянуть. Отсюда ничего не удаляется.';

  @override
  String desktopStatsHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часа',
      many: '$count часов',
      few: '$count часа',
      one: '$count час',
      zero: 'Меньше часа',
    );
    return '$_temp0';
  }

  @override
  String get desktopStatsLargest => 'Самые большие:';

  @override
  String get desktopStatsLength => 'Общая длительность';

  @override
  String get desktopStatsLink => 'Статистика';

  @override
  String get desktopStatsNeverPlayed => 'Ни разу не воспроизводились здесь';

  @override
  String get desktopStatsNewest => 'Самые новые:';

  @override
  String get desktopStatsOtherChannels => 'Другие каналы';

  @override
  String get desktopStatsRoom => 'Занятое место';

  @override
  String get desktopStatsUnnamed => 'Канал не указан';

  @override
  String get desktopStatsWithText => 'С расшифровкой';

  @override
  String get desktopStatsWithoutText => 'Без расшифровки';

  @override
  String get desktopStatsWorthALook => 'Стоит взглянуть';

  @override
  String get desktopSubtitleOptions => 'Параметры субтитров';

  @override
  String get desktopTheater => 'Кинотеатр';

  @override
  String get desktopTranscriptFirst => 'Сначала получите его расшифровку';

  @override
  String get desktopTranscriptHint =>
      'Следует за воспроизведением · щёлкните строку для перехода';

  @override
  String get desktopTranscriptsDeleteBody =>
      'Они удаляются с этого компьютера и из его резервной копии. Вернуть их сможет только экспортированный вами файл.';

  @override
  String get desktopTranscriptsHelp =>
      'VidHoist сохраняет слова, сказанные в каждом добавленном клипе YouTube, чтобы поиск (Ctrl+K) находил и то, что сказано внутри клипов, а не только их названия. Они остаются на этом компьютере.';

  @override
  String get desktopTranscriptsMove => 'На телефон или с телефона';

  @override
  String get desktopTranscriptsMoveHint =>
      'Расшифровки переносятся вместе с резервной копией: «Экспорт для телефона» забирает их, а «Импорт» на другой стороне добавляет недостающее.';

  @override
  String get desktopTrayOnClose =>
      'Продолжать воспроизведение в области уведомлений после закрытия окна';

  @override
  String get desktopTrayOnCloseHint =>
      'При закрытии окна звук продолжает играть; выйти можно через значок у часов.';

  @override
  String get desktopTrayOpen => 'Открыть VidHoist';

  @override
  String get desktopTrayQuit => 'Выйти';

  @override
  String get desktopUiSize => 'Размер интерфейса';

  @override
  String desktopUiSizeHint(String bigger, String smaller, String reset) {
    return '$bigger и $smaller меняют его из любого места, а $reset возвращает 100%.';
  }

  @override
  String get desktopUiSizeTooLarge => 'Слишком крупно для этого экрана';

  @override
  String get desktopUpdateInstall => 'Установить и перезапустить';

  @override
  String get desktopUpdateRestartHint =>
      'VidHoist закроется, установит обновление и откроется снова. Ваши настройки и медиатека останутся как есть.';

  @override
  String get desktopViewCompact => 'Компактно';

  @override
  String get desktopViewTable => 'Таблица';

  @override
  String get desktopVolume => 'Громкость';

  @override
  String desktopVolumeLevel(int percent) {
    return 'Громкость $percent%';
  }

  @override
  String get desktopWelcomeFetchNow => 'Загрузить сейчас';

  @override
  String get desktopWelcomeHelpers =>
      'ffmpeg (объединяет картинку и звук) и Deno (нужен для YouTube) загрузятся сами при первом скачивании, около 160 МБ. Можно загрузить их сейчас.';

  @override
  String get desktopWelcomeMessage =>
      'Вставьте ссылку с YouTube или другого сайта, и VidHoist скачает её на этот компьютер с помощью yt-dlp.';

  @override
  String get desktopWelcomeStart => 'Начать';

  @override
  String get desktopWelcomeTitle => 'Добро пожаловать в VidHoist';

  @override
  String get desktopWhatsNewAllFeatures => 'Всё, что умеет VidHoist';

  @override
  String get desktopWidenSidebar => 'Развернуть боковую панель';

  @override
  String get desktopWindowClose => 'Закрыть';

  @override
  String get desktopWindowMaximize => 'Развернуть';

  @override
  String get desktopWindowMinimize => 'Свернуть';

  @override
  String get desktopWindowRestore => 'Свернуть в окно';

  @override
  String get desktopZoomChange => 'Изменить';

  @override
  String desktopZoomLowered(String percent) {
    return 'Интерфейс уменьшен до $percent, чтобы поместиться на этом экране.';
  }

  @override
  String get details => 'Подробности';

  @override
  String get developer => 'Разработчик';

  @override
  String get developerName => 'Yasir Sagheer';

  @override
  String get diagnosticLogs => 'Диагностические журналы';

  @override
  String get diagnosticLogsSubtitle =>
      'Просмотр, поиск и отправка журналов приложения (без личных данных)';

  @override
  String get disclaimer => 'Отказ от ответственности';

  @override
  String get disclaimerText =>
      'Это приложение скачивает медиа с помощью yt-dlp. Разработчик не несёт ответственности за то, как пользователи применяют этот инструмент. Соблюдайте законы об авторском праве и условия использования сайтов, с которых вы скачиваете.';

  @override
  String get dismiss => 'Закрыть';

  @override
  String get done => 'Готово';

  @override
  String get download => 'Скачать';

  @override
  String get downloadComplete => 'Загрузка завершена';

  @override
  String get downloadCompleteTitle => 'Завершено';

  @override
  String get downloadDate => 'Дата загрузки';

  @override
  String get downloadFailed => 'Ошибка загрузки';

  @override
  String get downloadFailedTitle => 'Ошибка загрузки';

  @override
  String get downloadNow => 'Скачать';

  @override
  String get downloadStarted => 'Загрузка началась…';

  @override
  String downloadStartedQuality(Object quality) {
    return 'Загрузка началась · $quality';
  }

  @override
  String get downloading => 'Скачивание…';

  @override
  String get downloadingTitle => 'Скачивание';

  @override
  String get downloadsAdvanced => 'Дополнительно';

  @override
  String get editSubscription => 'Изменить';

  @override
  String get embedSubtitles => 'Субтитры также внутри видео';

  @override
  String get embedSubtitlesHelp =>
      'Чтобы их показывали другие плееры. Плеер VidHoist показывает их в любом случае.';

  @override
  String get emptyFilteredMessage =>
      'Сбросьте фильтр выше, чтобы увидеть всю медиатеку.';

  @override
  String get emptyFilteredTitle => 'Ничего не подходит под эти фильтры';

  @override
  String get emptyPlaylist => 'Пустой плейлист';

  @override
  String get emptyPlaylistMessage => 'Добавьте клипы из медиатеки';

  @override
  String engineDownloadingProgress(Object percent) {
    return 'Скачивание · $percent%';
  }

  @override
  String get engineErrDiskFull => 'Недостаточно места для этого файла';

  @override
  String engineErrFailed(Object reason) {
    return 'Ошибка загрузки: $reason';
  }

  @override
  String get engineErrFormat => 'Это качество недоступно для этого видео';

  @override
  String get engineErrGeoBlocked => 'Недоступно в вашей стране';

  @override
  String get engineErrMissing =>
      'Движок загрузки отсутствует или повреждён. Восстановите его в настройках кнопкой «Восстановить движок»';

  @override
  String get engineErrRateLimited =>
      'Сайт ограничивает запросы. Попробуйте позже';

  @override
  String get engineErrUnavailable => 'Видео недоступно, скрыто или удалено';

  @override
  String get engineErrUnsupported => 'Эта ссылка не поддерживается';

  @override
  String get enginePaused => 'Приостановлено';

  @override
  String get enginePostprocessing => 'Завершаем файл…';

  @override
  String get enginePreparing => 'Читаем ссылку…';

  @override
  String get engineRepair => 'Восстановить движок';

  @override
  String get engineRepairBusy =>
      'Дождитесь окончания загрузок, затем восстановите';

  @override
  String get engineRepairHint =>
      'Когда загрузки вдруг перестают работать на разных сайтах, а обновление не помогло: удаляет то, что сохранил yt-dlp, и ставит чистую актуальную копию. Ваши загрузки и настройки останутся как есть.';

  @override
  String get engineRepairPartly =>
      'Восстановлено частично: для остального нужно подключение. Попробуйте снова, когда будете в сети.';

  @override
  String engineRepaired(String version) {
    return 'Восстановлено: yt-dlp $version';
  }

  @override
  String get engineRepairing => 'Восстановление…';

  @override
  String get engineResume => 'Возобновить';

  @override
  String get enterFullscreen => 'Во весь экран';

  @override
  String errClipPastEnd(Object length) {
    return 'Часть начинается после конца видео ($length)';
  }

  @override
  String get errClipPastEndUnknown => 'Часть начинается после конца видео';

  @override
  String get errNetwork => 'Нет связи с сайтом';

  @override
  String get errPlatformBlockedCookies =>
      'Сайт требует входа. Выберите файл cookies в «Настройки › Cookies»';

  @override
  String errorGeneric(Object message) {
    return 'Ошибка: $message';
  }

  @override
  String get every30Minutes => 'Каждые 30 минут';

  @override
  String everyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Каждые $count часа',
      many: 'Каждые $count часов',
      few: 'Каждые $count часа',
      one: 'Каждый $count час',
    );
    return '$_temp0';
  }

  @override
  String get exitFullscreen => 'Выйти из полноэкранного режима';

  @override
  String get exportShare => 'Экспорт и отправка';

  @override
  String get exportShareSubtitle =>
      'Датированная копия, чтобы отправить или хранить в другом месте';

  @override
  String get externalPlayerShort => 'Другой плеер';

  @override
  String get failed => 'Ошибка';

  @override
  String get failedToLoadPlaylist => 'Не удалось загрузить плейлист';

  @override
  String get fastStreams => 'Ускоренные сегментные потоки';

  @override
  String fastStreamsHelp(int count) {
    return 'С сайтов, которые делят видео на части, например X, загружает части параллельно (одновременно: $count). Некоторые сайты замедляют много одновременных запросов.';
  }

  @override
  String get favorites => 'Избранное';

  @override
  String get file => 'Файл';

  @override
  String get fileSize => 'Размер файла';

  @override
  String get filterAll => 'Все';

  @override
  String get filterAudio => 'Аудио';

  @override
  String get filterVideo => 'Видео';

  @override
  String get filtersOn => 'Фильтры включены';

  @override
  String get folder => 'Папка';

  @override
  String get foldersHelp =>
      'Внутри папки загрузок создаётся папка, и клип сохраняется прямо в неё, где его видят Проводник и любые другие приложения. Оставьте «Без папки», и клип попадёт в корень папки загрузок.';

  @override
  String get follow => 'Подписаться';

  @override
  String get followChannel => 'Подписаться на канал';

  @override
  String get format => 'Формат';

  @override
  String framesPerSecond(int count) {
    return '$count к/с';
  }

  @override
  String get helpAboutField => 'Об этом поле';

  @override
  String get inPlaylists => 'В плейлистах';

  @override
  String get invalidUrl => 'Введите правильную ссылку';

  @override
  String get itemOptions => 'Параметры элемента';

  @override
  String get itemUnavailable => 'Больше недоступно';

  @override
  String get jumpToNewest => 'К самым новым';

  @override
  String get justNow => 'только что';

  @override
  String knownVideos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Известно $count видео',
      many: 'Известно $count видео',
      few: 'Известно $count видео',
      one: 'Известно $count видео',
      zero: 'Пока ничего не известно',
    );
    return '$_temp0';
  }

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Системный';

  @override
  String get languageSystemHint => 'Как язык вашего телефона';

  @override
  String lastBackup(String when) {
    return 'Последняя копия: $when';
  }

  @override
  String lastCheckedAt(String when) {
    return 'Последняя проверка: $when';
  }

  @override
  String get latestAdditions => 'Недавно добавленные';

  @override
  String get licensedUnder => 'Лицензия GPL-3.0';

  @override
  String get licenses => 'Лицензии открытого ПО';

  @override
  String get listSeparator => ', ';

  @override
  String get listenInBackground => 'Слушать в фоне';

  @override
  String get lockTouch => 'Заблокировать касания';

  @override
  String get loginDone => 'Готово';

  @override
  String loginKept(String site) {
    return 'Вход выполнен ($site); загрузки будут его использовать';
  }

  @override
  String get loginNotYet =>
      'Вход пока не найден. Завершите вход, затем нажмите «Готово»';

  @override
  String get logsEmpty => 'Журнал пуст';

  @override
  String get logsSanitizedNote =>
      'Перед отправкой удаляются ссылки, адреса и учётные данные';

  @override
  String get manageTags => 'Управление метками';

  @override
  String get mediaAccessBlockedMessage =>
      'Android больше не спросит. Включите доступ к фото и видео для этого приложения в настройках системы и вернитесь.';

  @override
  String get mediaAccessGrant => 'Разрешить';

  @override
  String get mediaAccessMessage =>
      'Ваши загрузки хранятся в папке Download телефона, и Android нужно ваше разрешение, чтобы приложение могло их показать.';

  @override
  String get mediaAccessOpenSettings => 'Открыть настройки';

  @override
  String get mediaAccessTitle => 'Разрешите доступ к медиафайлам';

  @override
  String miniPlayerTab(String title) {
    return 'Плеер: $title. Нажмите, чтобы открыть управление';
  }

  @override
  String get mobileChannelsEmptyBody =>
      'Подпишитесь на канал, и каждое новое видео будет скачиваться само, пока VidHoist открыт или работает в фоне; то, что вышло, пока приложение было закрыто, скачается при открытии. То, что уже есть на канале, не скачивается.';

  @override
  String get mobileChannelsHint =>
      'Новые видео с каналов из подписок скачиваются сами';

  @override
  String get mobileEngineIpv4 => 'Подключаться через IPv4';

  @override
  String get mobileEngineIpv4Help =>
      'Избавляет от долгих зависаний в сетях с неработающим IPv6. Выключайте, только если в вашей сети есть лишь IPv6.';

  @override
  String mobileEngineLastUpdate(String when) {
    return 'Последнее обновление: $when';
  }

  @override
  String get mobileEngineNotReady => 'Подготовка…';

  @override
  String get mobileEngineUpToDate => 'Установлена последняя версия yt-dlp';

  @override
  String get mobileEngineUpdate => 'Обновить yt-dlp';

  @override
  String get mobileEngineUpdateFailed =>
      'Не удалось обновить yt-dlp. Проверьте подключение и попробуйте снова.';

  @override
  String get mobileEngineUpdateMissed => 'Ошибка обновления';

  @override
  String get mobileEngineUpdated => 'Обновлено';

  @override
  String get mobileEngineUpdating => 'Обновление…';

  @override
  String get mobileEngineVersionLabel => 'Версия yt-dlp';

  @override
  String get mobileEngineVersionUnknown =>
      'Версия появится после первого обновления';

  @override
  String get mobileSettingsEngine => 'Движок загрузки';

  @override
  String get mobileSettingsGroupEngine => 'Движок';

  @override
  String get mobileSignInNeeded =>
      'Этот сайт требует входа. Войдите через «Настройки › Аккаунты», затем повторите';

  @override
  String get mobileSubtitleOptions => 'Размер, фон и расшифровка';

  @override
  String get mobileSubtitleStyleHelp =>
      'Также в плеере: удерживайте кнопку CC.';

  @override
  String get mobileSubtitles => 'Скачивать субтитры';

  @override
  String get mobileSubtitlesHelp =>
      'Субтитры на языках ниже, если они есть у видео, сохраняются рядом с ним и показываются в плеере.';

  @override
  String get mobileSubtitlesSizeLarger => 'Крупнее';

  @override
  String get mobileTranscript => 'Расшифровка';

  @override
  String get mobileTranscriptHint =>
      'Нажмите строку, чтобы воспроизвести с неё.';

  @override
  String get mobileTranscriptOpen => 'Читать расшифровку';

  @override
  String get mobileWelcomeBody =>
      'Видео и аудио с ваших сайтов сохраняются прямо на этот телефон. Движок загрузки готовится; это нужно только один раз.';

  @override
  String get mobileWelcomeFailed =>
      'Не удалось запустить движок. Попробуйте снова; если ошибка повторяется, переустановите приложение.';

  @override
  String get mobileWelcomeStart => 'Начать';

  @override
  String get mobileWelcomeTitle => 'Добро пожаловать в VidHoist';

  @override
  String get mobileWelcomeUnpacking => 'Подготовка движка загрузки';

  @override
  String get mobileWelcomeUpdateFailed =>
      'Сейчас обновить не удалось. VidHoist попробует снова перед первой загрузкой.';

  @override
  String get mobileWelcomeUpdating => 'Обновляем yt-dlp до последней версии';

  @override
  String get modeAutoNext => 'Авто';

  @override
  String get modeRepeatAll => 'Повторять все';

  @override
  String get modeRepeatOne => 'Повторять один';

  @override
  String get modeStopAtEnd => 'Остановить в конце';

  @override
  String get navLibrary => 'Медиатека';

  @override
  String get navMyDownloads => 'Мои загрузки';

  @override
  String get navPlaylists => 'Плейлисты';

  @override
  String get navSettings => 'Настройки';

  @override
  String get needsAttention => 'Требует внимания';

  @override
  String get neverChecked => 'Ещё не проверялось';

  @override
  String get newFolder => 'Новая папка…';

  @override
  String get newFolderHint => 'например, ИИ/Уроки';

  @override
  String get newPlaylistAction => 'Новый плейлист';

  @override
  String get newTagHint => 'Новая метка';

  @override
  String newVideosBody(String channels) {
    return '$channels. Они скачаются, когда вы откроете VidHoist.';
  }

  @override
  String newVideosNotice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count нового видео',
      many: '$count новых видео',
      few: '$count новых видео',
      one: '$count новое видео',
    );
    return '$_temp0';
  }

  @override
  String get next => 'Далее';

  @override
  String get noBackupsYet => 'Резервных копий пока нет';

  @override
  String get noDownloads => 'Нет загрузок';

  @override
  String get noDownloadsMessage =>
      'Здесь появятся скачанные клипы.\nПоделитесь ссылкой или нажмите «Добавить ссылку».';

  @override
  String get noExternalPlayer => 'На этом устройстве нет внешнего плеера';

  @override
  String get noFolder => 'Без папки';

  @override
  String get noFolderHint => 'В корне папки загрузок';

  @override
  String get noLogsFound => 'Журналы не найдены';

  @override
  String get noPlayableSource =>
      'У этого элемента нет источника для воспроизведения';

  @override
  String get noPlaylistsMessage => 'Создайте плейлист, чтобы упорядочить клипы';

  @override
  String get noResults => 'Ничего не найдено';

  @override
  String get noResultsMessage => 'Нет элементов, подходящих под запрос.';

  @override
  String get noServerTitle => 'Движок загрузки не готов';

  @override
  String get noticeChannelNewVideos => 'Новые видео';

  @override
  String get noticeChannelUpdates => 'Обновления';

  @override
  String get noVideosFound => 'Ваша медиатека пуста';

  @override
  String get noWarranty =>
      'Предоставляется «как есть», без каких-либо гарантий.';

  @override
  String get notAffiliated =>
      'Не связано с yt-dlp или каким-либо сайтом и не одобрено ими.';

  @override
  String get nothingHereYet => 'Здесь пока пусто';

  @override
  String get notificationClipGone => 'Этого клипа больше нет на телефоне.';

  @override
  String get nowPlaying => 'Сейчас играет';

  @override
  String get nowPlayingCollapse => 'Свернуть панель плеера';

  @override
  String get nowPlayingExpand => 'Показать панель плеера';

  @override
  String get ok => 'ОК';

  @override
  String get onlyNewVideos =>
      'Скачивается только то, что появится с этого момента. Видео, уже размещённые на канале, не скачиваются.';

  @override
  String get openChannel => 'Открыть канал';

  @override
  String get openInExternalPlayer => 'Открыть в другом плеере';

  @override
  String get openOriginalLink => 'Открыть исходную ссылку';

  @override
  String get ownFolder => 'Сохранять в отдельную папку';

  @override
  String get ownFolderNote =>
      'Папка внутри папки загрузок, которую видят и Проводник, и другие приложения. Туда попадает только то, что поступит с этого момента; уже скачанное остаётся на месте.';

  @override
  String get pasteUrlHint => 'Вставьте ссылку сюда…';

  @override
  String get pause => 'Пауза';

  @override
  String get pauseSubscription => 'Приостановить';

  @override
  String get pcAddressLabel => 'Адрес';

  @override
  String get pcBadAddress =>
      'Введите адрес так, как его показывает компьютер, например 192.168.1.24.';

  @override
  String get pcBadQr => 'Это не QR-код привязки VidHoist.';

  @override
  String get pcCertificate => 'Сертификат компьютера';

  @override
  String get pcCodeLabel => 'Код';

  @override
  String get pcConnected => 'Подключено';

  @override
  String get pcCopied =>
      'Скопировано в медиатеку телефона вместе с субтитрами.';

  @override
  String get pcCopyFailed =>
      'Копирование не завершено: компьютер, возможно, выключен или недоступен. Ничего не сохранено.';

  @override
  String get pcCopyStarting => 'Копирование…';

  @override
  String get pcCopyStop => 'Остановить копирование';

  @override
  String get pcCopyToPhone => 'Скопировать на телефон';

  @override
  String pcCopying(int percent) {
    return 'Копирование $percent%';
  }

  @override
  String get pcDelete => 'Удалить с компьютера';

  @override
  String pcDeleteBody(String title) {
    return '«$title» отправится в корзину компьютера, откуда его можно вернуть.';
  }

  @override
  String get pcDeleteFailed =>
      'Компьютер не смог удалить файл. Возможно, он там открыт.';

  @override
  String get pcDeleteMissing => 'Этого клипа больше нет на компьютере.';

  @override
  String get pcDeleteNoBin =>
      'Не удалено: на диске компьютера, где он лежит, нет корзины.';

  @override
  String get pcDeleteNotAllowed =>
      'Компьютер не разрешает телефону удалять. Включите это там в «Настройки › Телефон».';

  @override
  String pcDeleteTitle(String name) {
    return 'Удалить с «$name»?';
  }

  @override
  String pcDeleted(String title) {
    return 'В корзине компьютера: $title';
  }

  @override
  String get pcDestPhone => 'Этот телефон';

  @override
  String pcDoneOnPc(String title) {
    return 'Готово на компьютере: $title';
  }

  @override
  String pcDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count загрузки для компьютера',
      many: '$count загрузок для компьютера',
      few: '$count загрузки для компьютера',
      one: '$count загрузка для компьютера',
    );
    return '$_temp0';
  }

  @override
  String get pcDownloadsSheet => 'Загрузки на компьютере';

  @override
  String get pcEmptyLibrary => 'На компьютере пока нет загрузок.';

  @override
  String get pcErrBad =>
      'Компьютер ответил так, что эта версия не понимает. Обновите оба приложения.';

  @override
  String get pcErrClosed =>
      'На компьютере не показан код или его срок истёк. Нажмите там «Привязать телефон».';

  @override
  String get pcErrDenied =>
      'Привязка отклонена на компьютере или не подтверждена вовремя.';

  @override
  String get pcErrRefused => 'Компьютер не принял эту ссылку.';

  @override
  String get pcErrUnauthorized =>
      'Компьютер больше не знает этот телефон. Привяжите его снова.';

  @override
  String get pcErrUnreachable =>
      'Компьютер не ответил. Он включён, в этой сети или в вашем Tailscale, и включено ли «Получать с телефона»?';

  @override
  String get pcErrWrongCertificate =>
      'По этому адресу ответил не ваш компьютер. Ничего не отправлено.';

  @override
  String get pcErrWrongCode => 'Неверный код.';

  @override
  String get pcFindNone =>
      'Компьютер не найден. Сначала откройте на компьютере «Настройки › Телефон › Привязать телефон», в той же сети Wi-Fi.';

  @override
  String get pcFindOnNetwork => 'Найти в сети';

  @override
  String get pcFirewallAllow => 'Разрешить';

  @override
  String get pcFirewallBlocked =>
      'Брандмауэр Windows блокирует VidHoist, и телефон не может до него достучаться. Разрешите его в домашних (частных) сетях.';

  @override
  String get pcFirewallMissing =>
      'Windows пока не разрешила VidHoist принимать данные с телефона. Разрешите один раз, только для домашних (частных) сетей.';

  @override
  String get pcFirewallPublic =>
      'Windows считает эту сеть общественной и ничего в ней не пропускает. Если это ваша домашняя сеть, сделайте её частной: «Параметры › Сеть и Интернет › Wi-Fi › свойства сети».';

  @override
  String get pcFirewallRefused =>
      'Ничего не изменилось: Windows требуется разрешение администратора.';

  @override
  String get pcFirewallTitle => 'Брандмауэр Windows';

  @override
  String pcFound(String name) {
    return 'Найден $name. Введите код, который он показывает.';
  }

  @override
  String pcFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдено $count',
      many: 'Найдено $count',
      few: 'Найдено $count',
      one: 'Найден $count',
    );
    return '$_temp0';
  }

  @override
  String pcLastContact(String time) {
    return 'Последняя связь: $time';
  }

  @override
  String get pcLibrary => 'Медиатека на компьютере';

  @override
  String get pcLinkAddress => 'Адрес в этой сети';

  @override
  String get pcLinkAddressTailscale => 'Через Tailscale, вне дома';

  @override
  String get pcLinkAllow => 'Разрешить';

  @override
  String get pcLinkAllowDelete => 'Разрешить телефону удалять клипы';

  @override
  String get pcLinkAllowDeleteHint =>
      'Клип, удалённый с телефона, попадает в корзину этого компьютера, откуда его можно вернуть. На диске без корзины он не удаляется.';

  @override
  String get pcLinkCodeHint =>
      'На телефоне: «Настройки › Компьютер › Сканировать QR-код». Или введите там этот адрес и код. Действует один раз, две минуты.';

  @override
  String pcLinkCodeLeft(int seconds) {
    return 'Осталось $seconds с';
  }

  @override
  String get pcLinkCodeTitle => 'Код привязки';

  @override
  String get pcLinkDeny => 'Отклонить';

  @override
  String get pcLinkDevices => 'Привязанные телефоны';

  @override
  String pcLinkFailed(String error) {
    return 'Не удалось запустить: $error';
  }

  @override
  String get pcLinkIntro =>
      'Отправляйте ссылки из VidHoist на телефоне на этот компьютер и смотрите там его загрузки и медиатеку. Работает в домашней сети, а вне её — через Tailscale.';

  @override
  String pcLinkLastSeen(String time) {
    return 'Последний раз на связи: $time';
  }

  @override
  String get pcLinkNoDevices => 'Телефонов пока нет.';

  @override
  String get pcLinkOff => 'Выкл.';

  @override
  String pcLinkOtherAddresses(int count) {
    return 'Другие адреса ($count)';
  }

  @override
  String get pcLinkOtherAddressesHint =>
      'Сетевые адаптеры, добавленные другими программами, например VirtualBox или WSL. Телефону они редко нужны.';

  @override
  String get pcLinkPairPhone => 'Привязать телефон';

  @override
  String pcLinkPairedAt(String time) {
    return 'Привязан $time';
  }

  @override
  String pcLinkPhones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count телефона',
      many: '$count телефонов',
      few: '$count телефона',
      one: '$count телефон',
      zero: 'Нет телефонов',
    );
    return '$_temp0';
  }

  @override
  String get pcLinkQrHint => 'Отсканируйте с телефона';

  @override
  String get pcLinkReceive => 'Получать с телефона';

  @override
  String get pcLinkReceiveHint =>
      'Пока выключено, на этом компьютере не открыт ни один порт. Если Windows спросит, разрешите только частные сети.';

  @override
  String pcLinkRequest(String name) {
    return '$name запрашивает привязку';
  }

  @override
  String get pcLinkRequestHint =>
      'Разрешайте, только если телефон показывает те же четыре цифры.';

  @override
  String get pcLinkRevoke => 'Отвязать';

  @override
  String get pcLinkSecurity =>
      'Телефон связывается с этим компьютером напрямую, в вашей сети или через ваш Tailscale. Привязка выполняется один раз, по коду и с вашего подтверждения здесь; после этого телефон предъявляет свой ключ при каждом запросе, по соединению, зашифрованному только сертификатом этого компьютера. Для всех остальных в сети дверь закрыта.';

  @override
  String get pcLinkStarting => 'Запуск…';

  @override
  String get pcLinkTitle => 'Телефон';

  @override
  String get pcListEmpty =>
      'Ни одного клипа из этого списка на компьютере больше нет.';

  @override
  String get pcListen => 'Слушать';

  @override
  String get pcLists => 'Списки на компьютере';

  @override
  String get pcListsEmpty => 'Ни в одном списке на компьютере нет клипов.';

  @override
  String get pcNow => 'Сейчас на компьютере';

  @override
  String get pcOffline => 'Недоступен';

  @override
  String get pcOfflineMessage =>
      'Компьютер выключен или в другой сети. Ниже показано, что на нём было в прошлый раз.';

  @override
  String get pcOfflineRoute =>
      'Не дома? Выберите Tailscale в «Настройки › Компьютер».';

  @override
  String get pcOnPhone => 'На телефоне';

  @override
  String get pcOrType => 'Или введите адрес и код';

  @override
  String get pcOutboxRefused => 'Компьютер не принял эту ссылку';

  @override
  String pcOutboxTitle(int count) {
    return 'Ожидают отправки ($count)';
  }

  @override
  String get pcPairButton => 'Привязать';

  @override
  String pcPairCheck(String check) {
    return 'Убедитесь, что компьютер показывает $check, и разрешите там этот телефон.';
  }

  @override
  String get pcPairIntro =>
      'Если VidHoist работает на вашем компьютере с Windows, этот телефон может отправлять на него ссылки и показывать его загрузки и медиатеку. На компьютере включите «Настройки › Телефон», нажмите «Привязать телефон» и отсканируйте показанный QR-код.';

  @override
  String pcPaired(String name) {
    return 'Привязано: $name';
  }

  @override
  String get pcPortLabel => 'Порт';

  @override
  String pcQueued(String name) {
    return 'Отправится на $name, когда он снова будет доступен.';
  }

  @override
  String pcQueuedMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count клипа отправятся на $name, когда он снова будет доступен.',
      many: '$count клипов отправятся на $name, когда он снова будет доступен.',
      few: '$count клипа отправятся на $name, когда он снова будет доступен.',
      one: '$count клип отправится на $name, когда он снова будет доступен.',
    );
    return '$_temp0';
  }

  @override
  String get pcRouteHint =>
      'Выбирайте Tailscale, когда вы не дома; он должен работать и на телефоне, и на компьютере.';

  @override
  String get pcRouteHome => 'Домашняя сеть';

  @override
  String get pcRouteOther => 'Другая сеть';

  @override
  String get pcRouteTailscale => 'Tailscale';

  @override
  String get pcRouteTitle => 'Подключаться через';

  @override
  String get pcRouteWaiting =>
      'Другие маршруты компьютера появятся здесь, когда он ответит.';

  @override
  String get pcScanButton => 'Сканировать QR-код';

  @override
  String get pcScanFailed => 'Не удалось открыть камеру.';

  @override
  String get pcScanPrompt => 'Наведите камеру на QR-код на экране компьютера';

  @override
  String get pcSearchHint => 'Поиск в медиатеке компьютера';

  @override
  String get pcSendToPc => 'Отправить на компьютер';

  @override
  String pcSent(String name) {
    return 'Отправлено на $name';
  }

  @override
  String pcSentMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count клипа отправлено на $name',
      many: '$count клипов отправлено на $name',
      few: '$count клипа отправлены на $name',
      one: '$count клип отправлен на $name',
    );
    return '$_temp0';
  }

  @override
  String get pcSettingsHint => 'Отправляйте ссылки на свой компьютер';

  @override
  String get pcTab => 'Компьютер';

  @override
  String pcVia(String route) {
    return 'Через $route';
  }

  @override
  String get pcWatch => 'Смотреть';

  @override
  String get pcWillSend => 'Не в сети: отправится, когда появится';

  @override
  String get pickAnotherFile => 'Из другого файла…';

  @override
  String get pickAnotherFileSubtitle =>
      'Резервная копия с другого телефона или из старой версии';

  @override
  String get pictureInPicture => 'Картинка в картинке';

  @override
  String get pictureInPictureHelp =>
      'Если выйти из приложения во время воспроизведения клипа, он останется в углу экрана';

  @override
  String get pinPlaylist => 'Закрепить вверху';

  @override
  String get platform => 'Сайт';

  @override
  String platformCount(Object name, int count) {
    return '$name · $count';
  }

  @override
  String get platformOther => 'Другое';

  @override
  String get play => 'Воспроизвести';

  @override
  String get playAll => 'Воспроизвести все';

  @override
  String get playModeLabel => 'Режим';

  @override
  String get playbackSpeed => 'Скорость воспроизведения';

  @override
  String get playerError => 'Не удалось воспроизвести файл';

  @override
  String get playingFromDevice => 'Воспроизведение с устройства';

  @override
  String get playlist => 'Плейлист';

  @override
  String get playlistAddClips => 'Добавить клипы';

  @override
  String playlistAddClipsTo(String name) {
    return 'Добавить в «$name»';
  }

  @override
  String playlistAddCount(int count) {
    return 'Добавить ($count)';
  }

  @override
  String get playlistCreated => 'Плейлист создан';

  @override
  String get playlistDeleted => 'Плейлист удалён';

  @override
  String get playlistDetails => 'О плейлисте';

  @override
  String get playlistEditHint =>
      'Удерживайте клип, чтобы переместить. Смахните в сторону, чтобы убрать.';

  @override
  String get playlistName => 'Название плейлиста';

  @override
  String get playlistNameHint => 'Мой плейлист';

  @override
  String playlistOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get playlists => 'Плейлисты';

  @override
  String get previous => 'Предыдущий';

  @override
  String get quality => 'Качество';

  @override
  String get quality1080 => 'До 1080p';

  @override
  String get quality360 => 'До 360p';

  @override
  String get quality480 => 'До 480p';

  @override
  String get quality720 => 'До 720p';

  @override
  String get qualityAudio => 'Аудио';

  @override
  String get qualityBest => 'Лучшее';

  @override
  String get qualityHelper =>
      'Используется быстрой загрузкой, загрузкой целых плейлистов и кнопкой «Скачать» на панели буфера обмена, а также выбрано заранее в окне добавления ссылки. Поэтому оно важно, включена быстрая загрузка или нет.';

  @override
  String get qualityReading => 'Чтение файла…';

  @override
  String get qualityUnavailable => 'Недоступно';

  @override
  String get qualityVideo => 'Видео';

  @override
  String queueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count элемента',
      many: '$count элементов',
      few: '$count элемента',
      one: '$count элемент',
      zero: 'Нет элементов',
    );
    return '$_temp0';
  }

  @override
  String get queueLabel => 'Очередь';

  @override
  String queuePosition(int position) {
    return 'Номер $position в очереди';
  }

  @override
  String get queued => 'В очереди';

  @override
  String get queuedSection => 'Ожидают';

  @override
  String get quickDownload => 'Быстрая загрузка';

  @override
  String get quickDownloadHelp =>
      'Отправленная или вставленная ссылка сразу начинает скачиваться в качестве по умолчанию, без окна выбора. Если на сайте нет такого качества, берётся лучшее из доступных, а «Только аудио» работает на любом сайте.';

  @override
  String get rateLimit => 'Ограничение скорости';

  @override
  String get rateLimitNone => 'Без ограничений';

  @override
  String rateLimitValue(int mb) {
    return '$mb МБ/с';
  }

  @override
  String get reelsEndBack => 'Назад в медиатеку';

  @override
  String get reelsEndContinue => 'Продолжить остаток списка';

  @override
  String get reelsEndReplay => 'Воспроизвести сначала';

  @override
  String get reelsEndTitle => 'Конец ленты Shorts';

  @override
  String get reelsSwipeHint => 'Смахните вверх, чтобы открыть следующий ролик';

  @override
  String get refresh => 'Обновить';

  @override
  String get remove => 'Убрать';

  @override
  String get removeFromFavorites => 'Убрать из избранного';

  @override
  String removeUnavailable(int count) {
    return 'Убрать недоступные ($count)';
  }

  @override
  String get removedFromFavorites => 'Убрано из избранного';

  @override
  String get removedFromPlaylist => 'Убрано из плейлиста';

  @override
  String get rename => 'Переименовать';

  @override
  String get renameTag => 'Переименовать метку';

  @override
  String get reportBug => 'Сообщить об ошибке';

  @override
  String get restoreConfirm =>
      'Восстановить данные из файла резервной копии? Текущие плейлисты, метки и настройки будут перезаписаны.';

  @override
  String get restoreData => 'Восстановить';

  @override
  String get restoreFailed =>
      'Не удалось восстановить: файл резервной копии повреждён';

  @override
  String get restorePickBody =>
      'На этом телефоне есть загрузки VidHoist, но нет настроек, как после переустановки. Если вы сохраняли резервную копию, выберите её: приложение записывает их в Download/VidHoist/backups.';

  @override
  String get restorePickChoose => 'Выбрать резервную копию';

  @override
  String get restorePickTitle => 'Вернуть ваши настройки?';

  @override
  String get restoreSettings => 'Восстановить все данные';

  @override
  String get restoreSuccess => 'Данные успешно восстановлены';

  @override
  String get resumeSubscription => 'Возобновить';

  @override
  String get retry => 'Повторить';

  @override
  String get saveSettings => 'Сохранить настройки';

  @override
  String get searchLogs => 'Поиск в журналах…';

  @override
  String get searchVideos => 'Поиск клипов…';

  @override
  String get seekBackward10 => 'Назад на 10 секунд';

  @override
  String get seekForward10 => 'Вперёд на 10 секунд';

  @override
  String get selectAll => 'Выбрать все';

  @override
  String selected(int count) {
    return 'Выбрано: $count';
  }

  @override
  String selectedCount(int count) {
    return 'Выбрано: $count';
  }

  @override
  String get settings => 'Настройки';

  @override
  String get settingsAccounts => 'Аккаунты';

  @override
  String get settingsBackup => 'Резервная копия';

  @override
  String get settingsDownloads => 'Загрузки';

  @override
  String get settingsGroupApp => 'Приложение';

  @override
  String get settingsGroupData => 'Данные';

  @override
  String get settingsPlayback => 'Воспроизведение';

  @override
  String get settingsTranscripts => 'Расшифровки и субтитры';

  @override
  String settingsValueChannels(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count канала',
      many: '$count каналов',
      few: '$count канала',
      one: '$count канал',
      zero: 'Каналов пока нет',
    );
    return '$_temp0';
  }

  @override
  String get settingsValueCompatOff => 'Лучшая совместимость: выкл.';

  @override
  String get settingsValueCompatOn => 'Лучшая совместимость: вкл.';

  @override
  String get settingsValueNotSet => 'Ещё не настроено';

  @override
  String get settingsValueQuick => 'быстрая';

  @override
  String settingsValueSignedIn(String sites) {
    return 'Вход выполнен: $sites';
  }

  @override
  String get settingsValueWifiOnly => 'Только Wi‑Fi';

  @override
  String get share => 'Поделиться';

  @override
  String get shareLogs => 'Отправить журналы';

  @override
  String get shareOpening => 'Открываем меню «Поделиться»…';

  @override
  String get shareOpeningHint =>
      'Передача большого файла занимает несколько секунд.';

  @override
  String get shareSelected => 'Поделиться выбранным';

  @override
  String get sharedLinksAdd => 'Добавить';

  @override
  String get sharedLinksBody => 'Каждая скачается на этот телефон.';

  @override
  String sharedLinksCapped(int max) {
    return 'Добавлено только первых ссылок: $max.';
  }

  @override
  String sharedLinksTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Добавить $count ссылки?',
      many: 'Добавить $count ссылок?',
      few: 'Добавить $count ссылки?',
      one: 'Добавить $count ссылку?',
    );
    return '$_temp0';
  }

  @override
  String get shortsFilter => 'Shorts';

  @override
  String get shuffle => 'Перемешать';

  @override
  String get signInRequired => 'Требуется вход';

  @override
  String get size => 'Размер';

  @override
  String get smartPlaylists => 'Умные плейлисты';

  @override
  String get sortAndPlatform => 'Сортировка и сайт';

  @override
  String get sortBy => 'Сортировка';

  @override
  String get sortLargest => 'Самые большие';

  @override
  String get sortNameAZ => 'Название А–Я';

  @override
  String get sortNameZA => 'Название Я–А';

  @override
  String get sortNewest => 'Сначала новые';

  @override
  String get sortOldest => 'Сначала старые';

  @override
  String get sortSmallest => 'Самые маленькие';

  @override
  String get sortedByLastPlayed => 'По последнему воспроизведению';

  @override
  String get source => 'Источник';

  @override
  String get sourceCode => 'Исходный код';

  @override
  String get startDownload => 'Начать загрузку';

  @override
  String get status => 'Статус';

  @override
  String get storageCardMissing =>
      'Карта не вставлена, поэтому загрузки сохраняются на телефон';

  @override
  String get storageLocation => 'Куда сохранять';

  @override
  String get storageLocationHelp =>
      'Уже скачанные клипы остаются на месте и по-прежнему видны в медиатеке. Для карты памяти нужен Android 11 или новее.';

  @override
  String get storageNoCard => 'В телефоне нет карты памяти';

  @override
  String get storagePhone => 'Память телефона';

  @override
  String get streamingOnline => 'Воспроизведение по сети';

  @override
  String subscriptionAdded(String name) {
    return 'Вы подписались: $name';
  }

  @override
  String get subscriptionName => 'Название';

  @override
  String get subscriptionPaused => 'Приостановлено';

  @override
  String get subscriptionQuality => 'Качество для этого канала';

  @override
  String get subscriptionQualityHelp =>
      'Качество, в котором скачиваются новые видео этого канала. Его можно изменить позже, отредактировав канал; уже скачанные видео сохранят своё.\n\n«Лучшее» может означать 4K в формате AV1, которое старый компьютер может воспроизводить с рывками: в таком случае выберите 1080p.';

  @override
  String get subscriptionQualityNote =>
      'Применяется к новым видео; уже скачанные сохраняют своё.';

  @override
  String get subscriptions => 'Каналы';

  @override
  String get subscriptionsEmpty => 'Подписок на каналы пока нет';

  @override
  String get subscriptionsEmptyBody =>
      'Подпишитесь на канал, и каждое новое видео будет само скачиваться в вашу медиатеку, пока VidHoist открыт или в области уведомлений. То, что уже есть на канале, не скачивается.';

  @override
  String get subscriptionsSubtitle =>
      'Новые видео с каналов из подписок скачиваются сами';

  @override
  String get subtitleLangs => 'Языки субтитров';

  @override
  String get subtitleLangsHelp =>
      'Загружаются, если они есть у видео. Хотя бы один остаётся выбранным.';

  @override
  String get subtitles => 'Субтитры';

  @override
  String get subtitlesBackground => 'Фон';

  @override
  String get subtitlesBackgroundFaint => 'Лёгкий';

  @override
  String get subtitlesBackgroundHelp =>
      'То, что под текстом. Без фона у каждой буквы остаётся тёмный контур, чтобы её было видно на яркой картинке.';

  @override
  String get subtitlesBackgroundNone => 'Нет';

  @override
  String get subtitlesBackgroundSolid => 'Тёмный';

  @override
  String get subtitlesHide => 'Скрыть субтитры';

  @override
  String get subtitlesLanguage => 'Язык субтитров';

  @override
  String get subtitlesShow => 'Показывать субтитры';

  @override
  String get subtitlesShowHelp =>
      'Поверх видео, для клипов с расшифровкой. То же делает кнопка CC в плеере.';

  @override
  String get subtitlesSize => 'Размер текста';

  @override
  String get subtitlesSizeLarge => 'Крупный';

  @override
  String get subtitlesSizeMedium => 'Средний';

  @override
  String get subtitlesSizeSmall => 'Мелкий';

  @override
  String tagLimitReached(int max) {
    return 'Максимум меток: $max. Удалите одну в «Управление метками», чтобы добавить новую.';
  }

  @override
  String get tags => 'Метки';

  @override
  String get tagsOpenFiltered => 'Открывает медиатеку с фильтром';

  @override
  String get theme => 'Тема';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeSystem => 'Системная';

  @override
  String get titleFilter => 'Скачивать, только если название содержит';

  @override
  String get titleFilterHelp =>
      'Новое видео с этого канала скачивается, только если его название содержит то, что вы здесь напишете.\n\n• Достаточно простого слова: Выпуск\n• Любое из нескольких слов: Выпуск|Часть (символ | означает «или»)\n• Регистр не важен: выпуск совпадёт и с Выпуск.\n\nВидео, пропущенное фильтром, навсегда считается уже увиденным: если потом убрать фильтр, скачается то, что выйдет после, а не пропущенное.';

  @override
  String get titleFilterHelper =>
      'Несколько слов разделяйте символом | . Оставьте пустым, чтобы скачивать всё.';

  @override
  String get titleFilterHint => 'например, Выпуск';

  @override
  String get titleLabel => 'Название';

  @override
  String totalDuration(Object duration) {
    return 'Всего: $duration';
  }

  @override
  String get transcript => 'Расшифровка';

  @override
  String transcriptSaidMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сказано ещё $count раза',
      many: 'Сказано ещё $count раз',
      few: 'Сказано ещё $count раза',
      one: 'Сказано ещё $count раз',
    );
    return '$_temp0';
  }

  @override
  String transcriptsClips(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count клипа',
      many: '$count клипов',
      few: '$count клипа',
      one: '$count клип',
      zero: 'Клипов пока нет',
    );
    return '$_temp0';
  }

  @override
  String get transcriptsDeleteAll => 'Удалить все';

  @override
  String get transcriptsDeleteTitle => 'Удалить все расшифровки?';

  @override
  String get transcriptsSaidInside => 'Сказано в клипах';

  @override
  String get transcriptsSearchHelp =>
      'Сохраняет слова каждого добавленного клипа YouTube, чтобы можно было искать по сказанному.';

  @override
  String get tryAgain => 'Попробовать снова';

  @override
  String get undo => 'Отменить';

  @override
  String get unfollow => 'Отписаться';

  @override
  String unfollowConfirm(String name) {
    return 'Отписаться от «$name»?';
  }

  @override
  String get unfollowConfirmBody =>
      'VidHoist забудет, какие видео этого канала он уже видел. Если позже вы снова подпишетесь, всё, что будет на канале к тому времени, будет считаться увиденным, а пропущенное не докачается. Приостановка сохраняет эту память.';

  @override
  String get unlockTouch => 'Разблокировать';

  @override
  String get unpinPlaylist => 'Открепить';

  @override
  String get updateNoticeBody => 'Откройте VidHoist, чтобы установить.';

  @override
  String get upNext => 'Далее';

  @override
  String upNextIn(String name) {
    return 'Далее в «$name»';
  }

  @override
  String get updateAllowInstallBody =>
      'Android нужно ваше разрешение, чтобы приложение могло устанавливать свои обновления. Дайте его один раз в настройках системы, затем снова нажмите «Установить».';

  @override
  String get updateAllowInstallTitle => 'Разрешите установку обновлений';

  @override
  String get updateAvailable => 'Доступно обновление';

  @override
  String get updateCheckFailed => 'Не удалось проверить обновления';

  @override
  String get updateChecking => 'Проверка…';

  @override
  String get updateDownloadFailed => 'Не удалось скачать обновление';

  @override
  String updateDownloadedMb(String done, String total) {
    return '$done из $total МБ';
  }

  @override
  String get updateDownloading => 'Скачивание обновления…';

  @override
  String get updateFailedToStart => 'Не удалось открыть установщик';

  @override
  String get updateInstall => 'Установить';

  @override
  String get updateLater => 'Позже';

  @override
  String get updateNever => 'Ещё нет';

  @override
  String get updateNow => 'Скачать обновление';

  @override
  String get updateOpenSystemSettings => 'Открыть настройки';

  @override
  String get updateReady => 'Готово к установке';

  @override
  String updateSizeMb(String size) {
    return '$size МБ';
  }

  @override
  String get updateSkipVersion => 'Пропустить эту версию';

  @override
  String get updateUpToDate => 'У вас последняя версия';

  @override
  String updateVersionAvailable(String version) {
    return 'Доступна версия $version';
  }

  @override
  String updateVersionTitle(String version) {
    return 'Версия $version';
  }

  @override
  String get updateWhatsNew => 'Что нового';

  @override
  String get updates => 'Обновления';

  @override
  String get version => 'Версия';

  @override
  String get videoAdded => 'Добавлено в плейлист';

  @override
  String get videoPlayer => 'Видеоплеер';

  @override
  String get viewAll => 'Показать все';

  @override
  String get viewAllInPlaylists => 'Показать все';

  @override
  String get viewCards => 'Карточки';

  @override
  String get viewGrid => 'Сетка';

  @override
  String get viewList => 'Список';

  @override
  String get viewMode => 'Вид';

  @override
  String get waitingForWifi => 'Ожидание Wi-Fi';

  @override
  String get whatsNewGotIt => 'Понятно';

  @override
  String get whatsNewReleasePage => 'Страница выпуска';

  @override
  String get whatsNewThisVersion => 'Что нового в этой версии';

  @override
  String whatsNewTitle(String version) {
    return 'Что нового в $version';
  }

  @override
  String get whatsNewUnavailable =>
      'Изменения в этой версии описаны на странице выпуска.';

  @override
  String get wifiOnly => 'Скачивать только по Wi-Fi';

  @override
  String get wifiOnlyHelp =>
      'По мобильной сети ничего не скачивается. Загрузки ждут Wi-Fi, а начатая загрузка при пропаже Wi-Fi приостанавливается и продолжается сама, когда он вернётся.';

  @override
  String get yourPlaylists => 'Ваши плейлисты';

  @override
  String get yourTags => 'Ваши метки';

  @override
  String get ytdlpCredit => 'Загрузчик, на котором работает VidHoist';
}
