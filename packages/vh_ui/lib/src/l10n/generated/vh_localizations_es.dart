// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'vh_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class VhLocalizationsEs extends VhLocalizations {
  VhLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get about => 'Acerca de';

  @override
  String get aboutApp => 'Acerca de la app';

  @override
  String get aboutDescriptionPhone =>
      'Una app ligera y rápida que descarga video y audio de muchos sitios con yt-dlp. Tiene su propio reproductor y playlists.';

  @override
  String get accountSignIn => 'Iniciar sesión';

  @override
  String get accountSignOut => 'Cerrar sesión';

  @override
  String get accountSignedIn => 'Sesión iniciada';

  @override
  String get accountSignedOut => 'Sin sesión iniciada';

  @override
  String accountSignedOutOf(String site) {
    return 'Sesión cerrada en $site';
  }

  @override
  String get accountsBanRisk =>
      'Mejor usa una cuenta secundaria: descargar mucho puede hacer que el sitio restrinja la cuenta por un tiempo.';

  @override
  String get accountsClearAll => 'Borrar todas las cookies';

  @override
  String get accountsCleared => 'Cookies borradas';

  @override
  String get accountsFileHint =>
      'Exportado desde un navegador como archivo cookies.txt (formato Netscape), para cualquier sitio, incluso los que no aparecen arriba. Se suma a las sesiones que ya hay aquí y se queda en este teléfono.';

  @override
  String get accountsFilePick => 'Elegir un archivo de cookies';

  @override
  String get accountsFileTitle => 'O importa un archivo de cookies';

  @override
  String get accountsFromFile => 'Desde un archivo de cookies';

  @override
  String get accountsHelp =>
      'Una sesión caduca después de un tiempo; cuando un sitio empiece a rechazar otra vez, inicia sesión de nuevo. Cerrar sesión en un sitio también cierra la sesión del navegador de la app en los demás, cuyas descargas siguen como estaban. Si un sitio no te deja iniciar sesión aquí, importa abajo un archivo de cookies desde el navegador de tu computadora.';

  @override
  String get accountsHint =>
      'Para los sitios que rechazan una descarga sin iniciar sesión. Inicias sesión en la propia página del sitio dentro de la app; lo que deja se queda en este teléfono, donde yt-dlp lo lee en cada descarga, y no va a ningún otro lado.';

  @override
  String get activeDownloads => 'Descargas activas';

  @override
  String activeDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count descargas en curso',
      one: '1 descarga en curso',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloadsSheet => 'Descargas activas';

  @override
  String get activeNow => 'Activo ahora';

  @override
  String get addLinkFab => 'Agregar enlace';

  @override
  String get addTo => 'Agregar a…';

  @override
  String get addToFavorites => 'Agregar a favoritos';

  @override
  String get addToPlaylist => 'Agregar a playlist';

  @override
  String get addUrl => 'Agregar URL';

  @override
  String addedNToServer(int count) {
    return '$count agregados a las descargas';
  }

  @override
  String get addedToFavorites => 'Agregado a favoritos';

  @override
  String addedToPlaylistCount(int count) {
    return '$count agregados a la playlist';
  }

  @override
  String get allDownloadsFinished => 'Todas las descargas terminaron.';

  @override
  String get allPlatforms => 'Todos los sitios';

  @override
  String get alreadyInPlaylist => 'Ya agregado';

  @override
  String get alreadySubscribed => 'Ya sigues este canal';

  @override
  String get appTitle => 'VidHoist';

  @override
  String get appearanceAndLanguage => 'Apariencia e idioma';

  @override
  String audioChannels(int count) {
    return '$count canales';
  }

  @override
  String get audioFormat => 'Formato de audio';

  @override
  String get audioFormatM4a => 'M4A: se reproduce en todas partes';

  @override
  String get audioFormatMp3 => 'MP3: para reproductores antiguos y autos';

  @override
  String get audioFormatOriginal => 'Como lo envía el sitio, sin convertir';

  @override
  String get audioMono => 'Mono';

  @override
  String get audioOnly => 'Solo audio';

  @override
  String get audioStereo => 'Estéreo';

  @override
  String get autoBuilt => 'Automático';

  @override
  String get autoCheckUpdates => 'Buscar automáticamente';

  @override
  String get autoCheckUpdatesHelp =>
      'Busca una nueva versión en segundo plano unas dos veces al día.';

  @override
  String get autoRestoreSuccess =>
      'Datos restaurados desde la copia de seguridad.';

  @override
  String get autoRetry => 'Reintentar cuando vuelva la red';

  @override
  String get autoRetryHelp =>
      'Lo que falló porque se cayó la red se reintenta solo cuando vuelve. Lo que un sitio rechazó no se reintenta: repetirlo igual solo vuelve a fallar.';

  @override
  String get backgroundChecks => 'Comprobar con la app cerrada';

  @override
  String get backgroundChecksHelp =>
      'Aproximadamente cada seis horas, cuando hay red y la batería no está baja. Solo te avisa de lo nuevo; los vídeos se descargan cuando abres VidHoist.';

  @override
  String get backgroundDownload => 'Descargando archivos en segundo plano…';

  @override
  String backgroundLastRun(String when) {
    return 'Última comprobación con la app cerrada: $when';
  }

  @override
  String get backgroundNotRunYet =>
      'Aún no se ha comprobado con la app cerrada: Android elige el momento.';

  @override
  String get backgroundOfferBody =>
      'VidHoist puede mirar tus canales cada seis horas aproximadamente y avisarte de lo nuevo. No se descarga nada hasta que abras la app.';

  @override
  String get backgroundOfferNo => 'Ahora no';

  @override
  String get backgroundOfferTitle =>
      '¿Quieres saber de los vídeos nuevos con VidHoist cerrado?';

  @override
  String get backgroundOfferYes => 'Activar';

  @override
  String get backupNote =>
      'Incluye la biblioteca, las playlists, las etiquetas, los canales seguidos y los ajustes. Las sesiones y las transcripciones se guardan aparte, y los archivos multimedia no se incluyen.';

  @override
  String get backupSettings => 'Respaldar todos los datos';

  @override
  String get backupSettingsSubtitle =>
      'Siete copias con fecha que se renuevan solas. Restaura cualquiera o exporta una para compartirla';

  @override
  String backupSuccess(Object path) {
    return 'Copia de seguridad guardada en: $path';
  }

  @override
  String backupsKept(int count) {
    return '$count copias guardadas';
  }

  @override
  String get batchDownloadSelected => 'Descargar selección';

  @override
  String get batchLoading => 'Leyendo la playlist…';

  @override
  String get batchNothingSelected => 'Selecciona al menos un elemento';

  @override
  String batchSelectedOf(int selected, int total) {
    return '$selected de $total seleccionados';
  }

  @override
  String get batchThisVideoOnly => 'Descargar solo este clip';

  @override
  String get batchTitle => 'Descarga por lotes';

  @override
  String get batteryAllow => 'Permitir';

  @override
  String get batteryFree =>
      'El ahorro de batería no toca las descargas, aunque la app no esté a la vista.';

  @override
  String get batteryRestricted =>
      'El ahorro de batería puede detener una descarga larga mientras la app no está a la vista.';

  @override
  String get batteryStateFree => 'Permitido';

  @override
  String get batteryStateLimited => 'Restringido';

  @override
  String get batteryTitle => 'Descargas en segundo plano';

  @override
  String bitrateKbps(String value) {
    return '$value kb/s';
  }

  @override
  String bitrateMbps(String value) {
    return '$value Mb/s';
  }

  @override
  String get builtWith => 'Hecho con';

  @override
  String get cancel => 'Cancelar';

  @override
  String get changeQuality => 'Cambiar calidad';

  @override
  String get channelNameFolder => 'Con el nombre del canal';

  @override
  String channelFollowers(String count) {
    return '$count suscriptores';
  }

  @override
  String get channelCheckFailed =>
      'No se revisó esta vez. VidHoist lo vuelve a intentar solo.';

  @override
  String get channelUrl =>
      'Enlace a un canal, una playlist o uno de sus videos';

  @override
  String get channelUrlHint => 'https://www.youtube.com/@name';

  @override
  String chapterNumber(int number) {
    return 'Capítulo $number';
  }

  @override
  String get chaptersFold => 'Ocultar capítulos';

  @override
  String chaptersFromTranscript(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos de la transcripción',
      one: '1 capítulo de la transcripción',
    );
    return '$_temp0';
  }

  @override
  String get chaptersShowAll => 'Ver todos los capítulos';

  @override
  String get chaptersUnfold => 'Mostrar capítulos';

  @override
  String get checkEvery => 'Cada cuánto revisar';

  @override
  String get checkForUpdates => 'Buscar actualizaciones';

  @override
  String get checkNow => 'Revisar ahora';

  @override
  String get checkQueued =>
      'Revisando ahora. Lo nuevo aparece en la biblioteca.';

  @override
  String get chooseFolder => 'Elegir una carpeta';

  @override
  String get chooseOptions => 'Opciones';

  @override
  String get clear => 'Borrar';

  @override
  String get clearLogs => 'Borrar registros';

  @override
  String get clearLogsConfirm => '¿Borrar todos los registros de diagnóstico?';

  @override
  String get clipEndAfterStart => 'Después del inicio';

  @override
  String get clipFrom => 'Desde';

  @override
  String clipLength(Object length) {
    return 'El video dura $length';
  }

  @override
  String get clipLengthReading => 'Leyendo la duración del video…';

  @override
  String get clipLengthUnknown =>
      'El sitio no indica cuánto dura el video, así que los tiempos no se comprueban';

  @override
  String get clipMinuteDown => 'Un minuto antes';

  @override
  String get clipMinuteUp => 'Un minuto después';

  @override
  String get clipOnly => 'Solo una parte del video';

  @override
  String get clipOnlyHelp =>
      'De un momento a otro, sin el resto. Viene sin subtítulos.';

  @override
  String clipPastEnd(Object length) {
    return 'El video termina en $length';
  }

  @override
  String get clipTimeHint => 'Solo dígitos: 130 es 1:30';

  @override
  String get clipTo => 'Hasta';

  @override
  String get clipboardFound => 'Hay un enlace listo en tu portapapeles';

  @override
  String get clipboardLinkReady => 'Pegar enlace';

  @override
  String get closePlayer => 'Cerrar reproductor';

  @override
  String get columnAdded => 'Agregado';

  @override
  String get columnLength => 'Duración';

  @override
  String get compactView => 'Vista compacta';

  @override
  String get compatiblePlayback => 'Máxima compatibilidad de reproducción';

  @override
  String get compatiblePlaybackHelp =>
      'Pide H.264/AAC, que todos los teléfonos decodifican por hardware. Sin esto, YouTube puede entregar AV1, que muchos dispositivos muestran como una imagen distorsionada. Desactivarlo permite la resolución más alta a costa de la compatibilidad.';

  @override
  String get completed => 'Completado';

  @override
  String get continueAsAudio => 'Seguir como audio';

  @override
  String get continueAsAudioBody =>
      '¿Seguir reproduciendo esto como audio desde el mismo segundo?';

  @override
  String get continueAsAudioNo => 'No, detener';

  @override
  String get continueAsAudioTitle => '¿Seguir en segundo plano?';

  @override
  String get cookies => 'Cookies';

  @override
  String get cookiesNotNetscape =>
      'Ninguno de estos archivos tiene cookies en formato Netscape';

  @override
  String get cookiesSubtitle =>
      'Para los sitios que no descargan sin iniciar sesión';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get copyright => '© 2026 Yasir Sagheer';

  @override
  String get couldNotLoadPlaylist =>
      'No se pudo cargar esta playlist. Revisa la URL y tu conexión.';

  @override
  String get create => 'Crear';

  @override
  String get createPlaylist => 'Crear playlist';

  @override
  String get defaultQuality => 'Calidad de video predeterminada';

  @override
  String get delete => 'Eliminar';

  @override
  String deleteMultipleConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '¿Eliminar $count clips?\n\nSus archivos se borran de tu dispositivo.',
      one: '¿Eliminar 1 clip?\n\nSu archivo se borra de tu dispositivo.',
    );
    return '$_temp0';
  }

  @override
  String deletePlaylistConfirm(Object name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String get deleteRefused =>
      'No se eliminó: Android necesita tu permiso para eliminar este archivo, en el cuadro que muestra.';

  @override
  String get deleteSelected => 'Eliminar selección';

  @override
  String get deleteTag => 'Eliminar etiqueta';

  @override
  String deleteTagConfirm(Object tag) {
    return '¿Quitar la etiqueta \"$tag\" de todos los elementos? Los clips no se eliminan.';
  }

  @override
  String get deleteVideo => 'Eliminar clip';

  @override
  String deleteVideoConfirm(Object title) {
    return '¿Eliminar \"$title\"?\n\nEsto borrará el archivo de tu dispositivo.';
  }

  @override
  String deletedCount(Object count) {
    return '$count eliminados';
  }

  @override
  String deletedTitle(Object title) {
    return 'Eliminado: $title';
  }

  @override
  String get deselectAll => 'Quitar selección';

  @override
  String desktopAddLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Agregar $count enlaces',
      one: 'Agregar 1 enlace',
      zero: 'Nada que agregar',
    );
    return '$_temp0';
  }

  @override
  String get desktopBack => 'Atrás';

  @override
  String get desktopBackUpNow => 'Respaldar ahora';

  @override
  String get desktopBackupHint =>
      'Esta computadora guarda sus últimas siete copias, con al menos una hora entre ellas, en Downloads\\VidHoist\\Backups, donde sobreviven a una desinstalación.';

  @override
  String get desktopBackupsNone => 'Aún no hay copias';

  @override
  String get desktopBrowserButton => 'Botón “A VidHoist” en el navegador';

  @override
  String get desktopBrowserButtonCopied =>
      'Código copiado. Crea un marcador nuevo y pégalo como su dirección (URL).';

  @override
  String get desktopBrowserButtonCopy => 'Copiar el código';

  @override
  String get desktopBrowserButtonFailed =>
      'No se pudo abrir la página; copia el código.';

  @override
  String get desktopBrowserButtonHint =>
      'Un botón en tu barra de marcadores: un clic en la página de cualquier video abre aquí el diálogo para agregar con su enlace. No se envía nada hasta que pulses Agregar.';

  @override
  String get desktopBrowserButtonName => 'A VidHoist';

  @override
  String get desktopBrowserButtonOpen => 'Abrir la página de configuración';

  @override
  String get desktopBrowserPageCopyInstead =>
      'Si arrastrar no funciona, crea un marcador nuevo y pega esto como su dirección:';

  @override
  String get desktopBrowserPageDragHint =>
      'Arrástralo a la barra; un clic aquí no hace nada.';

  @override
  String get desktopBrowserPageStep1 =>
      'Muestra la barra de marcadores si está oculta:';

  @override
  String get desktopBrowserPageStep2 =>
      'Arrastra con el mouse el botón de abajo hasta la barra.';

  @override
  String get desktopBrowserPageStep3 =>
      'En la página de cualquier video, haz clic en él: VidHoist abre su diálogo para agregar con el enlace. La primera vez, el navegador pregunta si abrir la app; permítelo.';

  @override
  String get desktopBrowserPageTitle =>
      'Agrega el botón “A VidHoist” a tu navegador';

  @override
  String get desktopChangeFolder => 'Cambiar…';

  @override
  String get desktopChannel => 'Canal';

  @override
  String get desktopChannelClips => 'En tu biblioteca';

  @override
  String get desktopChannels => 'Canales';

  @override
  String get desktopChannelsInLibrary => 'Canales en tu biblioteca';

  @override
  String get desktopChannelsLater => 'Necesita el motor de descarga';

  @override
  String get desktopChannelsLaterBody =>
      'Seguir un canal necesita yt-dlp en esta computadora. Configúralo en Ajustes › Motor, y tus canales aparecerán aquí.';

  @override
  String get desktopChapters => 'Capítulos';

  @override
  String get desktopCheckAll => 'Revisar todos';

  @override
  String get desktopChooseClip => 'Seleccionar';

  @override
  String get desktopClearFilters => 'Borrar filtros';

  @override
  String get desktopClearSelection => 'Borrar selección';

  @override
  String get desktopCookiesBrowser => 'Desde un navegador';

  @override
  String get desktopCookiesBrowserHint =>
      'Se leen del navegador con el que iniciaste sesión. Si no se pueden leer, cierra ese navegador e inténtalo de nuevo.';

  @override
  String get desktopCookiesChoose => 'Elegir un archivo…';

  @override
  String get desktopCookiesFile => 'Archivo de cookies';

  @override
  String get desktopCookiesHelp =>
      'En tu navegador, usa una extensión que exporte cookies en formato Netscape (un archivo por sitio) y elige aquí los archivos juntos. yt-dlp los usará en cada descarga. Las cookies caducan, así que si una descarga vuelve a fallar, suele ser hora de exportarlas de nuevo.';

  @override
  String get desktopCookiesKept => 'Cookies guardadas en esta computadora';

  @override
  String desktopCookiesKeptFor(String sites) {
    return 'Cookies guardadas para: $sites';
  }

  @override
  String get desktopCookiesLocalHint =>
      'Para los sitios que piden iniciar sesión. yt-dlp las lee en esta computadora, y no van a ningún otro lado.';

  @override
  String get desktopCookiesNone => 'Ninguna';

  @override
  String get desktopCookiesRemove => 'Quitar';

  @override
  String get desktopCopiedLinkAdd => 'Agregar…';

  @override
  String get desktopCopiedLinkTitle => '¿Descargar este enlace?';

  @override
  String get desktopCopyFile => 'Copiar archivo';

  @override
  String get desktopCopyFileFailed => 'No se pudo copiar el archivo';

  @override
  String get desktopCopyLink => 'Copiar enlace';

  @override
  String get desktopCopyOneClip => 'Se copia un clip a la vez';

  @override
  String get desktopCopyQuote => 'Copiar con tiempo y enlace';

  @override
  String get desktopDefaultQualityHint =>
      'Con lo que empieza cada descarga nueva; aún puedes cambiarlo para cada enlace.';

  @override
  String desktopDeleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '¿Eliminar $count clips? Sus archivos en esta computadora se borran.',
      one: '¿Eliminar 1 clip? Su archivo en esta computadora se borra.',
    );
    return '$_temp0';
  }

  @override
  String get desktopDesktopSection => 'Windows';

  @override
  String get desktopDiscover => 'Descubre VidHoist';

  @override
  String get desktopDiscoverAddLink => 'Pega o suelta un enlace';

  @override
  String get desktopDiscoverAddLinkLine =>
      'Ctrl+V en cualquier lugar, o suelta un enlace en la ventana, para agregarlo.';

  @override
  String get desktopDiscoverAdding => 'Agregar y compartir';

  @override
  String get desktopDiscoverBrowser => 'Desde el navegador';

  @override
  String get desktopDiscoverBrowserLine =>
      'El botón “A VidHoist” de tu barra de marcadores abre el diálogo para agregar con la página en la que estás.';

  @override
  String get desktopDiscoverChapters => 'Capítulos';

  @override
  String get desktopDiscoverChaptersLine =>
      'Las partes de un clip, según su transcripción, en su página.';

  @override
  String get desktopDiscoverChoose => 'Elegir varios';

  @override
  String get desktopDiscoverChooseLine =>
      'La marca redonda, o Ctrl o Shift con un clic; luego agrégalos a una lista o elimínalos juntos.';

  @override
  String get desktopDiscoverDragOut => 'Arrastra un clip afuera';

  @override
  String get desktopDiscoverDragOutLine =>
      'Suéltalo en una carpeta u otra app, y llega ahí como archivo.';

  @override
  String get desktopDiscoverExport => 'Exportar una transcripción';

  @override
  String get desktopDiscoverExportLine =>
      'Como texto, o como subtítulos SRT para otro reproductor.';

  @override
  String get desktopDiscoverHint =>
      'Todo lo que la app puede hacer, una línea cada cosa, con sus teclas.';

  @override
  String get desktopDiscoverLibrary => 'La biblioteca';

  @override
  String get desktopDiscoverListening =>
      'Para escuchar: una sala tranquila con la portada grande, en pantalla completa.';

  @override
  String get desktopDiscoverMini => 'Ventana pequeña';

  @override
  String get desktopDiscoverMiniLine =>
      'Una tarjeta pequeña sobre todas las demás ventanas, en la esquina inferior de la pantalla.';

  @override
  String get desktopDiscoverReading =>
      'La transcripción como artículo: haz clic en una frase para escucharla desde ahí.';

  @override
  String get desktopDiscoverSaid => 'Lo que se dijo';

  @override
  String get desktopDiscoverSearch => 'Busca lo que se dijo';

  @override
  String get desktopDiscoverSearchLine =>
      'Encuentra los clips donde se dijo una palabra, no solo en los títulos.';

  @override
  String get desktopDiscoverShortcutsLine =>
      'Todas las teclas que responde la ventana, en una sola hoja.';

  @override
  String get desktopDiscoverShow => 'Mostrar';

  @override
  String get desktopDiscoverStatsLine =>
      'La biblioteca en números: por sitio, canal y mes.';

  @override
  String get desktopDiscoverSubtitles =>
      'La transcripción sobre la imagen, con la palabra dicha resaltada.';

  @override
  String get desktopDiscoverTheater =>
      'Una imagen más grande que ocupa el lugar del panel lateral.';

  @override
  String get desktopDiscoverTry => 'Pruébalo';

  @override
  String get desktopDiscoverWatching => 'Ver y escuchar';

  @override
  String get desktopDownloadFolder => 'Carpeta de descargas';

  @override
  String get desktopDownloadFolderHint =>
      'Las descargas se guardan aquí como archivos normales, para abrir, mover o respaldar como cualquier otro.';

  @override
  String get desktopDownloads => 'Descargas';

  @override
  String get desktopDownloadsEmpty =>
      'No se está descargando nada. Agrega un enlace para empezar.';

  @override
  String get desktopDownloadsRunning => 'En curso';

  @override
  String get desktopDragToReorder => 'Arrastra para reordenar';

  @override
  String get desktopDropLinks => 'Suelta para agregar';

  @override
  String get desktopEmptyLibraryLocal =>
      'Agrega un enlace, y el clip aparecerá aquí cuando se descargue.';

  @override
  String get desktopEmptyLibraryMessage =>
      'Agrega un enlace, y el clip aparecerá aquí cuando se descargue.';

  @override
  String get desktopEngine => 'Motor';

  @override
  String get desktopEngineDenoHint =>
      'Responde a la verificación de YouTube, para poder descargar todas las calidades que ofrece';

  @override
  String get desktopEngineFetch => 'Obtener';

  @override
  String get desktopEngineFetchCorrupt =>
      'El archivo que llegó no era el publicado, así que no se usó.';

  @override
  String get desktopEngineFetchFailed =>
      'No se pudo obtener. Revisa la conexión e inténtalo de nuevo.';

  @override
  String get desktopEngineFetchInUse =>
      'Lo está usando una descarga. Inténtalo de nuevo cuando termine.';

  @override
  String desktopEngineFetching(int percent) {
    return 'Obteniendo · $percent%';
  }

  @override
  String get desktopEngineFfmpegHint =>
      'Une imagen y sonido, y convierte el audio';

  @override
  String get desktopEngineIpv4 => 'Usar solo IPv4';

  @override
  String get desktopEngineIpv4Hint =>
      'Mucho más rápido donde IPv6 falla, como en muchas redes domésticas. Desactívalo solo si tu red tiene únicamente IPv6.';

  @override
  String get desktopEngineMissing =>
      'yt-dlp no está en esta computadora. Reinstala VidHoist u obtenlo aquí.';

  @override
  String get desktopEngineOnFirstUse =>
      'Se obtiene en la primera descarga que lo necesite';

  @override
  String get desktopEngineUpToDate => 'yt-dlp está actualizado';

  @override
  String get desktopEngineUpdate => 'Actualizar yt-dlp';

  @override
  String get desktopEngineUpdateFailed =>
      'La actualización no se completó. Inténtalo más tarde.';

  @override
  String get desktopEngineUpdateHint =>
      'Los sitios cambian a menudo; un yt-dlp viejo deja de funcionar en pocos meses.';

  @override
  String desktopEngineUpdated(String version) {
    return 'yt-dlp ahora es $version';
  }

  @override
  String get desktopEngineUpdating => 'Actualizando…';

  @override
  String desktopEngineVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get desktopEngineYtDlpHint => 'Lee el enlace y lo descarga';

  @override
  String get desktopExport => 'Exportar';

  @override
  String get desktopExportForPhone => 'Exportar para el teléfono';

  @override
  String get desktopExportForPhoneHint =>
      'Guarda las etiquetas, las listas y los puntos de reanudación de esta computadora, y sus transcripciones, en dos archivos que el teléfono restaura. Restaurarlos en el teléfono reemplaza sus propias etiquetas y listas.';

  @override
  String get desktopExportMarkdown => 'Texto (Markdown)';

  @override
  String get desktopExportPdf => 'Documento (PDF)';

  @override
  String get desktopExportPhone => 'Para el teléfono (importar en VidHoist)';

  @override
  String get desktopExportSrt => 'Subtítulos (SRT)';

  @override
  String desktopExported(String name) {
    return 'Se guardó $name';
  }

  @override
  String desktopFileReadyToPaste(String name, String size) {
    return 'Listo para pegar: $name · $size';
  }

  @override
  String get desktopFolderUnavailable => 'No hay ninguna carpeta disponible';

  @override
  String get desktopFolders => 'Carpetas';

  @override
  String get desktopForward => 'Adelante';

  @override
  String get desktopGlobalShortcut => 'Reproducir y pausar desde cualquier app';

  @override
  String desktopGlobalShortcutHint(String keys) {
    return '$keys reproduce y pausa aunque la ventana esté detrás de otras apps.';
  }

  @override
  String desktopGlobalShortcutTaken(String keys) {
    return 'Otra app ya usa $keys.';
  }

  @override
  String get desktopHidePanel => 'Ocultar panel lateral';

  @override
  String get desktopHintShortcuts =>
      'Pulsa ? para ver los atajos de teclado. Espacio reproduce y pausa; las flechas avanzan y retroceden.';

  @override
  String get desktopHintShortcutsAction => 'Atajos';

  @override
  String get desktopHintTrayBody =>
      'Sigue reproduciendo desde su ícono junto al reloj. Para salir, haz clic derecho en el ícono.';

  @override
  String get desktopHintTrayTitle => 'VidHoist sigue abierto';

  @override
  String get desktopHints => 'Mostrar consejos';

  @override
  String get desktopHintsAgain => 'Mostrarlos otra vez';

  @override
  String get desktopHintsHint =>
      'Dos consejos cortos, cada uno se muestra una vez: los atajos en el primer clip, el ícono junto al reloj al cerrar por primera vez.';

  @override
  String get desktopImportFromPhone => 'Importar una copia o transcripciones…';

  @override
  String get desktopImportHint =>
      'Un archivo de copia de seguridad o de transcripciones de VidHoist, elegido aquí o soltado en la ventana. El de un teléfono se suma a lo que hay aquí; una copia de esta computadora se restaura completa, después de preguntar.';

  @override
  String desktopImportedBackup(int tagged, int lists, int positions) {
    return 'Agregado desde el teléfono. Etiquetas: $tagged · listas: $lists · puntos de reanudación: $positions';
  }

  @override
  String get desktopImportedNothing =>
      'Nada nuevo: esta computadora ya lo tenía todo.';

  @override
  String desktopImportedTranscripts(int count) {
    return 'Transcripciones agregadas: $count';
  }

  @override
  String desktopInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count en tu biblioteca',
      one: '1 en tu biblioteca',
    );
    return '$_temp0';
  }

  @override
  String get desktopKeepAwake =>
      'Mantener la computadora activa mientras descarga';

  @override
  String get desktopKeepAwakeHint =>
      'Así un enlace enviado desde el teléfono, o una playlist larga, termina en vez de detenerse cuando Windows entra en suspensión. La pantalla se apaga como siempre.';

  @override
  String get desktopKeyAddLink => 'Agregar el enlace que copiaste';

  @override
  String get desktopKeyFavorite => 'Agregar a favoritos o quitar';

  @override
  String get desktopKeyFullScreen =>
      'Pantalla completa; para audio, la sala de escucha';

  @override
  String get desktopKeyMenu => 'El menú del clip';

  @override
  String get desktopKeyMini => 'Ventana pequeña sobre las demás, y volver';

  @override
  String get desktopKeyPlayPause => 'Reproducir o pausar';

  @override
  String get desktopKeyRepeat => 'Cambiar repetición';

  @override
  String get desktopKeySearch => 'Buscar títulos y lo que se dijo';

  @override
  String get desktopKeySeek => 'Atrás o adelante 10 segundos';

  @override
  String get desktopKeyShortcuts => 'Esta lista';

  @override
  String get desktopKeyVolume =>
      'Más alto o más bajo; en Shorts, el anterior o el siguiente';

  @override
  String get desktopKeyZoomIn => 'Interfaz más grande';

  @override
  String get desktopKeyZoomOut => 'Interfaz más pequeña';

  @override
  String get desktopKeyZoomReset => 'Interfaz a su tamaño normal';

  @override
  String get desktopLanguageSystemHint => 'Sigue el idioma de Windows.';

  @override
  String desktopLastArrival(String when) {
    return 'Última llegada $when';
  }

  @override
  String get desktopLess => 'Menos';

  @override
  String get desktopLibraryLoading => 'Cargando la biblioteca…';

  @override
  String get desktopLinkCopied => 'Enlace copiado';

  @override
  String get desktopLinkDuplicate => 'Repetido arriba';

  @override
  String get desktopLinkInLibrary => 'Ya está en tu biblioteca';

  @override
  String get desktopLinkPlaylist => 'Una playlist: elige sus clips';

  @override
  String get desktopLinkReady => 'Listo';

  @override
  String get desktopLinkUnsupported => 'Un sitio que esta app no conoce';

  @override
  String desktopLinksDropped(int count, int limit) {
    return 'Solo se toman los primeros $limit enlaces; $count más quedaron fuera.';
  }

  @override
  String desktopLinksFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enlaces',
      one: '1 enlace',
    );
    return '$_temp0';
  }

  @override
  String get desktopListeningClose => 'Cerrar la sala de escucha';

  @override
  String get desktopListeningRoom => 'Sala de escucha';

  @override
  String get desktopLogsCopied =>
      'Registro copiado, sin enlaces ni direcciones';

  @override
  String get desktopLogsCopy => 'Copiar';

  @override
  String get desktopLogsSave => 'Guardar en un archivo';

  @override
  String get desktopMiniRestore => 'Volver a la ventana completa';

  @override
  String get desktopMiniWindow => 'Ventana pequeña';

  @override
  String get desktopMore => 'Más';

  @override
  String get desktopNarrowSidebar => 'Contraer barra lateral';

  @override
  String get desktopNoChannelNames =>
      'Los clips de tu biblioteca no indican su canal, así que no se pueden separar los clips de este canal. Síguelo con su propia carpeta, y lo que llegue ahí aparecerá aquí.';

  @override
  String get desktopNoFavoritesMessage =>
      'Marca un clip como favorito y te esperará aquí.';

  @override
  String get desktopNoFavoritesTitle => 'Aún no hay favoritos';

  @override
  String get desktopNoMatchMessage => 'Quita un filtro para ver más.';

  @override
  String get desktopNoMatchTitle => 'Nada coincide con estos filtros';

  @override
  String get desktopNoTags =>
      'Aún no hay etiquetas. Etiqueta un clip desde su página y aparecerá aquí.';

  @override
  String get desktopNoTranscriptMessage =>
      'Aparece aquí cuando los subtítulos del clip se descargan con él.';

  @override
  String get desktopNoTranscriptTitle => 'Este clip no tiene transcripción';

  @override
  String get desktopNotABackup =>
      'Este archivo no es una copia de seguridad ni un archivo de transcripciones de VidHoist.';

  @override
  String desktopNotWatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sin ver',
      one: '1 sin ver',
    );
    return '$_temp0';
  }

  @override
  String get desktopNothingPlaying => 'No se reproduce nada';

  @override
  String get desktopNothingPlayingHint =>
      'Reproduce un clip y aquí aparecerán su transcripción, lo que sigue y sus detalles.';

  @override
  String get desktopNotifyArrivalsHint =>
      'Un aviso de Windows cuando se descargan clips nuevos de los canales que sigues.';

  @override
  String get desktopOfferCopiedLinks => 'Ofrecer los enlaces que copio';

  @override
  String get desktopOfferCopiedLinksHint =>
      'Cuando copias un enlace de video en otra app, una notificación ofrece agregarlo. Solo se revisan los enlaces, y ninguno se guarda.';

  @override
  String get desktopOpenBackup => 'Abrir copia';

  @override
  String get desktopOpenChannels => 'Abrir canales';

  @override
  String get desktopOpenInExplorer => 'Abrir en el Explorador';

  @override
  String get desktopOpenWith => 'Abrir en otro reproductor…';

  @override
  String get desktopPaletteClose => 'para cerrar';

  @override
  String get desktopPaletteCommands => 'Comandos';

  @override
  String get desktopPaletteHint =>
      'Busca títulos y lo que se dijo, o escribe > para comandos';

  @override
  String desktopPaletteList(String name) {
    return 'Lista: $name';
  }

  @override
  String get desktopPaletteMove => 'para moverte';

  @override
  String get desktopPaletteOpen => 'para abrir';

  @override
  String get desktopPaletteSaid => 'Dicho dentro de los clips';

  @override
  String get desktopPaletteSave => 'Guardar esta búsqueda';

  @override
  String desktopPaletteSettings(String section) {
    return 'Ajustes: $section';
  }

  @override
  String get desktopPaletteTitles => 'Títulos';

  @override
  String get desktopPinned => 'Fijados';

  @override
  String get desktopPlayNext => 'Reproducir a continuación';

  @override
  String get desktopPlaysNext => 'Se reproduce a continuación, después de este';

  @override
  String get desktopQueueEnd => 'No hay nada después de este';

  @override
  String desktopQuote(String text, String title, String time, String link) {
    return '“$text”\n— $title, $time\n$link';
  }

  @override
  String get desktopQuoteCopied => 'Copiado con su tiempo y enlace';

  @override
  String get desktopReadingBack => 'Volver al clip';

  @override
  String get desktopReadingCloseFind => 'Cerrar la búsqueda';

  @override
  String get desktopReadingFind => 'Buscar en el texto';

  @override
  String desktopReadingFound(int at, int count) {
    return '$at de $count';
  }

  @override
  String get desktopReadingHint =>
      'Haz clic en una frase para escucharla desde ahí · Ctrl+F busca una palabra · selecciona para copiar con su tiempo';

  @override
  String get desktopReadingNextMatch => 'Siguiente coincidencia';

  @override
  String get desktopReadingPreviousMatch => 'Coincidencia anterior';

  @override
  String get desktopReadingRoom => 'Sala de lectura';

  @override
  String get desktopRecoverLibrary => 'Clips que ya están en la carpeta';

  @override
  String get desktopRecoverLibraryAction => 'Buscar en la carpeta';

  @override
  String get desktopRecoverLibraryHint =>
      'Después de reinstalar: devuelve a la biblioteca los clips que están en la carpeta de descargas pero ya no aparecen en la lista. Los archivos no se tocan.';

  @override
  String desktopRecovered(int count) {
    return 'Devueltos a la biblioteca: $count';
  }

  @override
  String get desktopRecoveredNothing =>
      'Nada que agregar: todos los clips de la carpeta están en la biblioteca.';

  @override
  String desktopRecoveredSome(int count, int left) {
    return 'Devueltos a la biblioteca: $count. Quedaron fuera, sin enlace conocido: $left';
  }

  @override
  String get desktopRemoveFromList => 'Quitar de la lista';

  @override
  String get desktopRestore => 'Restaurar';

  @override
  String get desktopRestoreBody =>
      'La biblioteca, los canales seguidos, las etiquetas, las listas y los ajustes de esta computadora pasan a ser los de la copia. Los archivos descargados no se tocan.';

  @override
  String desktopRestoreOfferBody(String when) {
    return 'Downloads\\VidHoist\\Backups tiene una copia de seguridad de esta computadora: su biblioteca, canales seguidos, playlists, etiquetas, ajustes y transcripciones guardadas. La más reciente se hizo $when. Tus archivos descargados no se tocan en ningún caso.';
  }

  @override
  String get desktopRestoreOfferTitle => '¿Restaurar tu copia de seguridad?';

  @override
  String get desktopRestoreTitle => '¿Restaurar esta copia?';

  @override
  String get desktopRestored => 'Copia restaurada';

  @override
  String get desktopRevealAfterDownload =>
      'Mostrar en el Explorador al terminar';

  @override
  String get desktopRevealAfterDownloadHint =>
      'Cuando termina un archivo descargado en esta computadora, se abre su carpeta con el archivo seleccionado.';

  @override
  String desktopSavedIn(String folder) {
    return 'Guardado en $folder';
  }

  @override
  String desktopSavedSearchDelete(String name) {
    return '¿Eliminar la búsqueda guardada “$name”? Nada cambia en la biblioteca.';
  }

  @override
  String get desktopSavedSearchName => 'Nombre de la búsqueda';

  @override
  String get desktopSearch => 'Buscar';

  @override
  String get desktopSearchHint => 'Busca títulos y lo que se dijo…';

  @override
  String get desktopSearchSaved => 'Guardada en la barra lateral';

  @override
  String get desktopSeekBar => 'Posición en el clip';

  @override
  String desktopSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seleccionados',
      one: '1 seleccionado',
    );
    return '$_temp0';
  }

  @override
  String get desktopSetupChooseFile => 'Elegir un archivo…';

  @override
  String get desktopShortcutsApp => 'App';

  @override
  String get desktopShortcutsClip => 'En un clip elegido';

  @override
  String get desktopShortcutsPlayback => 'Reproducción';

  @override
  String get desktopShortcutsTitle => 'Atajos de teclado';

  @override
  String get desktopShortcutsWindow => 'Ventana';

  @override
  String get desktopShortsHint =>
      '↑ ↓ o la rueda para el siguiente Short · doble clic para marcar como favorito';

  @override
  String get desktopShowInFolder => 'Mostrar en la carpeta';

  @override
  String get desktopShowPanel => 'Mostrar panel lateral';

  @override
  String get desktopStartFresh => 'Empezar de cero';

  @override
  String get desktopStartWithWindows => 'Iniciar con Windows';

  @override
  String get desktopStartWithWindowsHint =>
      'Se abre al iniciar sesión: en la bandeja si sigue reproduciendo ahí, si no, minimizada.';

  @override
  String get desktopStartWithWindowsRefused =>
      'Windows no permitió que la app se inicie con él.';

  @override
  String get desktopStats => 'Estadísticas de la biblioteca';

  @override
  String get desktopStatsByChannel => 'Por canal';

  @override
  String get desktopStatsByMonth => 'Por mes en que se agregó';

  @override
  String get desktopStatsBySite => 'Por sitio';

  @override
  String get desktopStatsClips => 'Clips';

  @override
  String get desktopStatsHint =>
      'Lo que tiene la biblioteca y lo que podría merecer una mirada. Desde aquí no se elimina nada.';

  @override
  String desktopStatsHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count horas',
      one: '1 hora',
      zero: 'Menos de una hora',
    );
    return '$_temp0';
  }

  @override
  String get desktopStatsLargest => 'Los más grandes:';

  @override
  String get desktopStatsLength => 'Duración total';

  @override
  String get desktopStatsLink => 'Estadísticas';

  @override
  String get desktopStatsNeverPlayed => 'Nunca reproducidos aquí';

  @override
  String get desktopStatsNewest => 'Los más recientes:';

  @override
  String get desktopStatsOtherChannels => 'Otros canales';

  @override
  String get desktopStatsRoom => 'Espacio ocupado';

  @override
  String get desktopStatsUnnamed => 'Sin canal indicado';

  @override
  String get desktopStatsWithText => 'Con transcripción';

  @override
  String get desktopStatsWithoutText => 'Sin transcripción';

  @override
  String get desktopStatsWorthALook => 'Para revisar';

  @override
  String get desktopSubtitleOptions => 'Opciones de subtítulos';

  @override
  String get desktopTheater => 'Teatro';

  @override
  String get desktopTranscriptFirst => 'Primero obtén su transcripción';

  @override
  String get desktopTranscriptHint =>
      'Sigue la reproducción · haz clic en una línea para saltar';

  @override
  String get desktopTranscriptsDeleteBody =>
      'Se eliminan de esta computadora y de su copia de seguridad. Solo un archivo que hayas exportado puede recuperarlas.';

  @override
  String get desktopTranscriptsHelp =>
      'VidHoist guarda las palabras dichas en cada clip de YouTube que agregas, así que una búsqueda (Ctrl+K) también encuentra lo que se dijo dentro de tus clips, no solo sus títulos. Se quedan en esta computadora.';

  @override
  String get desktopTranscriptsMove => 'Hacia o desde un teléfono';

  @override
  String get desktopTranscriptsMoveHint =>
      'Las transcripciones viajan con la copia de seguridad: Exportar para el teléfono las incluye, e Importar allá las trae, agregando lo que falte aquí.';

  @override
  String get desktopTrayOnClose =>
      'Seguir reproduciendo en la bandeja al cerrar la ventana';

  @override
  String get desktopTrayOnCloseHint =>
      'Cerrar la ventana mantiene el sonido; sal desde el ícono junto al reloj.';

  @override
  String get desktopTrayOpen => 'Abrir VidHoist';

  @override
  String get desktopTrayQuit => 'Salir';

  @override
  String get desktopUiSize => 'Tamaño de la interfaz';

  @override
  String desktopUiSizeHint(String bigger, String smaller, String reset) {
    return '$bigger y $smaller lo cambian desde cualquier lugar, y $reset vuelve al 100%.';
  }

  @override
  String get desktopUiSizeTooLarge => 'Demasiado grande para esta pantalla';

  @override
  String get desktopUpdateInstall => 'Instalar y reiniciar';

  @override
  String get desktopUpdateRestartHint =>
      'VidHoist se cierra, instala la actualización y se vuelve a abrir. Tus ajustes y tu biblioteca quedan como están.';

  @override
  String get desktopViewCompact => 'Compacta';

  @override
  String get desktopViewTable => 'Tabla';

  @override
  String get desktopVolume => 'Volumen';

  @override
  String desktopVolumeLevel(int percent) {
    return 'Volumen $percent%';
  }

  @override
  String get desktopWelcomeFetchNow => 'Obtenerlos ahora';

  @override
  String get desktopWelcomeHelpers =>
      'ffmpeg (une imagen y sonido) y Deno (necesario para YouTube) se descargan solos en la primera descarga, unos 160 MB. Si prefieres, puedes obtenerlos ahora.';

  @override
  String get desktopWelcomeMessage =>
      'Pega un enlace de YouTube u otro sitio, y VidHoist lo descarga en esta computadora con yt-dlp.';

  @override
  String get desktopWelcomeStart => 'Empezar';

  @override
  String get desktopWelcomeTitle => 'Te damos la bienvenida a VidHoist';

  @override
  String get desktopWhatsNewAllFeatures => 'Todo lo que VidHoist puede hacer';

  @override
  String get desktopWidenSidebar => 'Expandir barra lateral';

  @override
  String get desktopWindowClose => 'Cerrar';

  @override
  String get desktopWindowMaximize => 'Maximizar';

  @override
  String get desktopWindowMinimize => 'Minimizar';

  @override
  String get desktopWindowRestore => 'Restaurar tamaño';

  @override
  String get desktopZoomChange => 'Cambiar';

  @override
  String desktopZoomLowered(String percent) {
    return 'La interfaz ahora está al $percent para que quepa en esta pantalla.';
  }

  @override
  String get details => 'Detalles';

  @override
  String get developer => 'Desarrollador';

  @override
  String get developerName => 'Yasir Sagheer';

  @override
  String get diagnosticLogs => 'Registros de diagnóstico';

  @override
  String get diagnosticLogsSubtitle =>
      'Ver, buscar y compartir los registros de la app (sin datos sensibles)';

  @override
  String get disclaimer => 'Aviso legal';

  @override
  String get disclaimerText =>
      'Esta app descarga contenido multimedia con yt-dlp. El desarrollador no se hace responsable del uso que los usuarios den a esta herramienta. Respeta las leyes de derechos de autor y los términos de servicio de los sitios desde los que descargas.';

  @override
  String get dismiss => 'Descartar';

  @override
  String get done => 'Listo';

  @override
  String get download => 'Descargar';

  @override
  String get downloadComplete => 'Descarga completa';

  @override
  String get downloadCompleteTitle => 'Completa';

  @override
  String get downloadDate => 'Fecha de descarga';

  @override
  String get downloadFailed => 'Falló la descarga';

  @override
  String get downloadFailedTitle => 'Falló la descarga';

  @override
  String get downloadNow => 'Descargar';

  @override
  String get downloadStarted => 'Descarga iniciada…';

  @override
  String downloadStartedQuality(Object quality) {
    return 'Descarga iniciada · $quality';
  }

  @override
  String get downloading => 'Descargando…';

  @override
  String get downloadingTitle => 'Descargando';

  @override
  String get downloadsAdvanced => 'Avanzado';

  @override
  String get editSubscription => 'Editar';

  @override
  String get embedSubtitles => 'Subtítulos también dentro del video';

  @override
  String get embedSubtitlesHelp =>
      'Para que otros reproductores los muestren. El reproductor de VidHoist los muestra de todos modos.';

  @override
  String get emptyFilteredMessage =>
      'Quita un filtro de arriba para ver toda tu biblioteca.';

  @override
  String get emptyFilteredTitle => 'Nada coincide con estos filtros';

  @override
  String get emptyPlaylist => 'Playlist vacía';

  @override
  String get emptyPlaylistMessage => 'Agrega clips desde la biblioteca';

  @override
  String engineDownloadingProgress(Object percent) {
    return 'Descargando · $percent%';
  }

  @override
  String get engineErrDiskFull => 'No hay suficiente espacio para este archivo';

  @override
  String engineErrFailed(Object reason) {
    return 'Falló la descarga: $reason';
  }

  @override
  String get engineErrFormat =>
      'Esta calidad no está disponible para este video';

  @override
  String get engineErrGeoBlocked => 'No disponible en tu país';

  @override
  String get engineErrMissing =>
      'Falta el motor de descarga o está incompleto. Repáralo en Ajustes con Reparar el motor';

  @override
  String get engineErrRateLimited =>
      'El sitio está limitando las solicitudes. Inténtalo de nuevo en un rato';

  @override
  String get engineErrUnavailable =>
      'Este video no está disponible, es privado o se eliminó';

  @override
  String get engineErrUnsupported => 'Este enlace no es compatible';

  @override
  String get enginePaused => 'En pausa';

  @override
  String get enginePostprocessing => 'Terminando el archivo…';

  @override
  String get enginePreparing => 'Leyendo el enlace…';

  @override
  String get engineRepair => 'Reparar el motor';

  @override
  String get engineRepairBusy =>
      'Espera a que terminen las descargas y luego repara';

  @override
  String get engineRepairHint =>
      'Cuando las descargas fallan en varios sitios como antes no pasaba, y actualizar no ayudó: borra lo que guardó yt-dlp y vuelve a poner una copia limpia y actual. Tus descargas y ajustes quedan como están.';

  @override
  String get engineRepairPartly =>
      'Reparado en parte: el resto necesita conexión. Inténtalo de nuevo cuando estés en línea.';

  @override
  String engineRepaired(String version) {
    return 'Reparado: yt-dlp $version';
  }

  @override
  String get engineRepairing => 'Reparando…';

  @override
  String get engineResume => 'Reanudar';

  @override
  String get enterFullscreen => 'Pantalla completa';

  @override
  String errClipPastEnd(Object length) {
    return 'La parte empieza después de que termina el video ($length)';
  }

  @override
  String get errClipPastEndUnknown =>
      'La parte empieza después de que termina el video';

  @override
  String get errNetwork => 'No hay conexión con el sitio';

  @override
  String get errPlatformBlockedCookies =>
      'El sitio pide iniciar sesión. Elige un archivo de cookies en Ajustes › Cookies';

  @override
  String errorGeneric(Object message) {
    return 'Error: $message';
  }

  @override
  String get every30Minutes => 'Cada 30 minutos';

  @override
  String everyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cada $count horas',
      one: 'Cada hora',
    );
    return '$_temp0';
  }

  @override
  String get exitFullscreen => 'Salir de pantalla completa';

  @override
  String get exportShare => 'Exportar y compartir';

  @override
  String get exportShareSubtitle =>
      'Una copia con fecha para enviar o guardar en otro lugar';

  @override
  String get externalPlayerShort => 'Otro reproductor';

  @override
  String get failed => 'Falló';

  @override
  String get failedToLoadPlaylist => 'No se pudo cargar la playlist';

  @override
  String get fastStreams => 'Transmisiones por partes más rápidas';

  @override
  String fastStreamsHelp(int count) {
    return 'Descarga $count partes a la vez de los sitios que dividen un video en partes, como X. Algunos sitios se vuelven lentos con muchas solicitudes a la vez.';
  }

  @override
  String get favorites => 'Favoritos';

  @override
  String get file => 'Archivo';

  @override
  String get fileSize => 'Tamaño del archivo';

  @override
  String get filterAll => 'Todo';

  @override
  String get filterAudio => 'Audio';

  @override
  String get filterVideo => 'Video';

  @override
  String get filtersOn => 'Filtros activos';

  @override
  String get folder => 'Carpeta';

  @override
  String get foldersHelp =>
      'Se crea una carpeta dentro de la carpeta de descargas, y el clip se guarda directamente ahí, donde el Explorador y cualquier otra app lo ven. Déjalo en \"Sin carpeta\" y el clip va a la raíz de la carpeta de descargas.';

  @override
  String get follow => 'Seguir';

  @override
  String get followChannel => 'Seguir un canal';

  @override
  String get format => 'Formato';

  @override
  String framesPerSecond(int count) {
    return '$count fps';
  }

  @override
  String get helpAboutField => 'Acerca de este campo';

  @override
  String get inPlaylists => 'En playlists';

  @override
  String get invalidUrl => 'Escribe un enlace válido';

  @override
  String get itemOptions => 'Opciones del elemento';

  @override
  String get itemUnavailable => 'Ya no está disponible';

  @override
  String get jumpToNewest => 'Ir a lo más reciente';

  @override
  String get justNow => 'justo ahora';

  @override
  String knownVideos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count videos conocidos',
      one: '1 video conocido',
      zero: 'Aún no se conoce nada',
    );
    return '$_temp0';
  }

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get languageSystemHint => 'Sigue el idioma de tu teléfono';

  @override
  String lastBackup(String when) {
    return 'Última copia $when';
  }

  @override
  String lastCheckedAt(String when) {
    return 'Última revisión $when';
  }

  @override
  String get latestAdditions => 'Agregados recientes';

  @override
  String get licensedUnder => 'Con licencia GPL-3.0';

  @override
  String get licenses => 'Licencias de código abierto';

  @override
  String get listSeparator => ',';

  @override
  String get listenInBackground => 'Escuchar en segundo plano';

  @override
  String get lockTouch => 'Bloquear pantalla táctil';

  @override
  String get loginDone => 'Listo';

  @override
  String loginKept(String site) {
    return 'Sesión iniciada en $site; las descargas la usarán';
  }

  @override
  String get loginNotYet =>
      'Aún no se encontró ninguna sesión. Termina de iniciar sesión y toca Listo';

  @override
  String get logsEmpty => 'El registro está vacío';

  @override
  String get logsSanitizedNote =>
      'Los enlaces, direcciones y credenciales se quitan antes de compartir';

  @override
  String get manageTags => 'Administrar etiquetas';

  @override
  String get mediaAccessBlockedMessage =>
      'Android no volverá a preguntar. Activa fotos y videos para esta app en los ajustes del sistema y luego vuelve.';

  @override
  String get mediaAccessGrant => 'Permitir';

  @override
  String get mediaAccessMessage =>
      'Tus descargas se guardan en la carpeta Download del teléfono, y Android necesita tu permiso para que la app pueda listarlas.';

  @override
  String get mediaAccessOpenSettings => 'Abrir ajustes';

  @override
  String get mediaAccessTitle => 'Permite el acceso a tus archivos multimedia';

  @override
  String miniPlayerTab(String title) {
    return 'Reproductor: $title. Toca para ver los controles';
  }

  @override
  String get mobileChannelsEmptyBody =>
      'Sigue un canal y cada video nuevo se descarga solo mientras VidHoist está abierto o en segundo plano; lo que llegó mientras estaba cerrado se descarga cuando se abre. Lo que ya está en el canal no se descarga.';

  @override
  String get mobileChannelsHint =>
      'Videos nuevos de los canales que sigues, descargados solos';

  @override
  String get mobileEngineIpv4 => 'Conectar por IPv4';

  @override
  String get mobileEngineIpv4Help =>
      'Evita una espera larga en redes cuya ruta IPv6 falla. Desactívalo solo si tu red tiene únicamente IPv6.';

  @override
  String mobileEngineLastUpdate(String when) {
    return 'Última actualización $when';
  }

  @override
  String get mobileEngineNotReady => 'Preparando…';

  @override
  String get mobileEngineUpToDate => 'yt-dlp está actualizado';

  @override
  String get mobileEngineUpdate => 'Actualizar yt-dlp';

  @override
  String get mobileEngineUpdateFailed =>
      'No se pudo actualizar yt-dlp. Revisa la conexión e inténtalo de nuevo.';

  @override
  String get mobileEngineUpdateMissed => 'Falló la actualización';

  @override
  String get mobileEngineUpdated => 'Actualizado';

  @override
  String get mobileEngineUpdating => 'Actualizando…';

  @override
  String get mobileEngineVersionLabel => 'Versión de yt-dlp';

  @override
  String get mobileEngineVersionUnknown =>
      'Su versión aparece después de la primera actualización';

  @override
  String get mobileSettingsEngine => 'Motor de descarga';

  @override
  String get mobileSettingsGroupEngine => 'Motor';

  @override
  String get mobileSignInNeeded =>
      'Este sitio pide iniciar sesión. Inicia sesión en Ajustes › Cuentas y vuelve a intentarlo';

  @override
  String get mobileSubtitleOptions => 'Tamaño, fondo y la transcripción';

  @override
  String get mobileSubtitleStyleHelp =>
      'También en el reproductor: mantén pulsado el botón CC.';

  @override
  String get mobileSubtitles => 'Descargar subtítulos';

  @override
  String get mobileSubtitlesHelp =>
      'Subtítulos en los idiomas de abajo, cuando el video los tenga, guardados junto a él y mostrados en el reproductor.';

  @override
  String get mobileSubtitlesSizeLarger => 'Más grande';

  @override
  String get mobileTranscript => 'Transcripción';

  @override
  String get mobileTranscriptHint =>
      'Toca una línea para reproducir desde ahí.';

  @override
  String get mobileTranscriptOpen => 'Leer la transcripción';

  @override
  String get mobileWelcomeBody =>
      'Videos y audio de los sitios que usas, guardados directamente en este teléfono. El motor de descarga se está preparando; esto pasa solo una vez.';

  @override
  String get mobileWelcomeFailed =>
      'El motor no pudo iniciar. Inténtalo de nuevo; si sigue fallando, reinstala la app.';

  @override
  String get mobileWelcomeStart => 'Empezar';

  @override
  String get mobileWelcomeTitle => 'Te damos la bienvenida a VidHoist';

  @override
  String get mobileWelcomeUnpacking => 'Preparando el motor de descarga';

  @override
  String get mobileWelcomeUpdateFailed =>
      'No se pudo actualizar ahora. VidHoist lo intentará otra vez antes de tu primera descarga.';

  @override
  String get mobileWelcomeUpdating => 'Actualizando yt-dlp a su última versión';

  @override
  String get modeAutoNext => 'Auto';

  @override
  String get modeRepeatAll => 'Repetir todo';

  @override
  String get modeRepeatOne => 'Repetir uno';

  @override
  String get modeStopAtEnd => 'Detener al final';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navMyDownloads => 'Mis descargas';

  @override
  String get navPlaylists => 'Playlists';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get needsAttention => 'Requiere tu atención';

  @override
  String get neverChecked => 'Aún no se revisó';

  @override
  String get newFolder => 'Carpeta nueva…';

  @override
  String get newFolderHint => 'p. ej. IA/Clases';

  @override
  String get newPlaylistAction => 'Nueva playlist';

  @override
  String get newTagHint => 'Nueva etiqueta';

  @override
  String newVideosBody(String channels) {
    return '$channels. Se descargan cuando abras VidHoist.';
  }

  @override
  String newVideosNotice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vídeos nuevos',
      one: '1 vídeo nuevo',
    );
    return '$_temp0';
  }

  @override
  String get next => 'Siguiente';

  @override
  String get noBackupsYet => 'Aún no hay copias de seguridad';

  @override
  String get noDownloads => 'No hay descargas';

  @override
  String get noDownloadsMessage =>
      'Los clips descargados aparecerán aquí.\nComparte un enlace o usa el botón Agregar enlace.';

  @override
  String get noExternalPlayer =>
      'No hay ningún reproductor externo en este dispositivo';

  @override
  String get noFolder => 'Sin carpeta';

  @override
  String get noFolderHint => 'En la raíz de las descargas';

  @override
  String get noLogsFound => 'No se encontraron registros';

  @override
  String get noPlayableSource =>
      'Este elemento no tiene una fuente reproducible';

  @override
  String get noPlaylistsMessage => 'Crea una playlist para organizar tus clips';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get noResultsMessage => 'Ningún elemento coincide con tu búsqueda.';

  @override
  String get noServerTitle => 'El motor de descarga no está listo';

  @override
  String get noticeChannelNewVideos => 'Vídeos nuevos';

  @override
  String get noticeChannelUpdates => 'Actualizaciones';

  @override
  String get noVideosFound => 'Tu biblioteca está vacía';

  @override
  String get noWarranty => 'Se ofrece tal cual, sin ninguna garantía.';

  @override
  String get notAffiliated =>
      'Sin afiliación con yt-dlp ni con ningún sitio, y sin su respaldo.';

  @override
  String get nothingHereYet => 'Aún no hay nada aquí';

  @override
  String get notificationClipGone => 'Este clip ya no está en el teléfono.';

  @override
  String get nowPlaying => 'Reproduciendo ahora';

  @override
  String get nowPlayingCollapse => 'Contraer el panel del reproductor';

  @override
  String get nowPlayingExpand => 'Mostrar el panel del reproductor';

  @override
  String get ok => 'Aceptar';

  @override
  String get onlyNewVideos =>
      'Solo se descarga lo que aparezca a partir de ahora. Los videos que ya están en el canal se quedan donde están.';

  @override
  String get openChannel => 'Abrir canal';

  @override
  String get openInExternalPlayer => 'Abrir en otro reproductor';

  @override
  String get openOriginalLink => 'Abrir enlace original';

  @override
  String get ownFolder => 'Guardar en su propia carpeta';

  @override
  String get ownFolderNote =>
      'Una carpeta dentro de la carpeta de descargas, que el Explorador y otras apps también ven. Solo lo que llegue a partir de ahora va ahí; lo ya descargado se queda donde está.';

  @override
  String get pasteUrlHint => 'Pega el enlace aquí…';

  @override
  String get pause => 'Pausar';

  @override
  String get pauseSubscription => 'Pausar';

  @override
  String get pcAddressLabel => 'Dirección';

  @override
  String get pcBadAddress =>
      'Escribe la dirección tal como la muestra la computadora, por ejemplo 192.168.1.24.';

  @override
  String get pcBadQr => 'Este no es un código QR de vinculación de VidHoist.';

  @override
  String get pcCertificate => 'Certificado de la computadora';

  @override
  String get pcCodeLabel => 'Código';

  @override
  String get pcConnected => 'Conectado';

  @override
  String get pcCopied =>
      'Copiado a la biblioteca del teléfono, con sus subtítulos.';

  @override
  String get pcCopyFailed =>
      'La copia no terminó: puede que la computadora esté apagada o fuera de alcance. No se guardó nada.';

  @override
  String get pcCopyStarting => 'Copiando…';

  @override
  String get pcCopyStop => 'Detener la copia';

  @override
  String get pcCopyToPhone => 'Copiar al teléfono';

  @override
  String pcCopying(int percent) {
    return 'Copiando $percent%';
  }

  @override
  String get pcDelete => 'Eliminar de la computadora';

  @override
  String pcDeleteBody(String title) {
    return '\"$title\" va a la Papelera de reciclaje de la computadora, desde donde se puede recuperar.';
  }

  @override
  String get pcDeleteFailed =>
      'La computadora no pudo eliminarlo. Puede que esté abierto allí.';

  @override
  String get pcDeleteMissing => 'Este clip ya no está en la computadora.';

  @override
  String get pcDeleteNoBin =>
      'No se eliminó: su unidad en la computadora no tiene Papelera de reciclaje.';

  @override
  String get pcDeleteNotAllowed =>
      'La computadora no deja que el teléfono elimine. Actívalo allí en Ajustes › Teléfono.';

  @override
  String pcDeleteTitle(String name) {
    return '¿Eliminar de $name?';
  }

  @override
  String pcDeleted(String title) {
    return 'En la Papelera de reciclaje de la computadora: $title';
  }

  @override
  String get pcDestPhone => 'Este teléfono';

  @override
  String pcDoneOnPc(String title) {
    return 'Listo en la computadora: $title';
  }

  @override
  String pcDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count descargas para la computadora',
      one: '1 descarga para la computadora',
    );
    return '$_temp0';
  }

  @override
  String get pcDownloadsSheet => 'Descargas en la computadora';

  @override
  String get pcEmptyLibrary => 'Aún no hay descargas en la computadora.';

  @override
  String get pcErrBad =>
      'La computadora respondió de una forma que esta versión no entiende. Actualiza ambas apps.';

  @override
  String get pcErrClosed =>
      'No se muestra ningún código en la computadora, o caducó. Pulsa Vincular un teléfono allí.';

  @override
  String get pcErrDenied =>
      'La vinculación se rechazó en la computadora, o no se respondió a tiempo.';

  @override
  String get pcErrRefused => 'La computadora no aceptó este enlace.';

  @override
  String get pcErrUnauthorized =>
      'La computadora ya no reconoce este teléfono. Vincúlalo de nuevo.';

  @override
  String get pcErrUnreachable =>
      'La computadora no respondió. ¿Está encendida, en esta red o en tu Tailscale, con \"Recibir del teléfono\" activado?';

  @override
  String get pcErrWrongCertificate =>
      'Algo que no es tu computadora respondió en esta dirección. No se envió nada.';

  @override
  String get pcErrWrongCode => 'Código incorrecto.';

  @override
  String get pcFindNone =>
      'No se encontró ninguna computadora. En la computadora, abre primero Ajustes › Teléfono › Vincular un teléfono, en la misma red Wi-Fi.';

  @override
  String get pcFindOnNetwork => 'Buscar en la red';

  @override
  String get pcFirewallAllow => 'Permitir';

  @override
  String get pcFirewallBlocked =>
      'El Firewall de Windows bloquea VidHoist, así que el teléfono no puede llegar a él. Permítelo en redes domésticas (privadas).';

  @override
  String get pcFirewallMissing =>
      'Windows aún no deja que VidHoist reciba del teléfono. Permítelo una vez, solo en redes domésticas (privadas).';

  @override
  String get pcFirewallPublic =>
      'Windows considera esta red como Pública y no deja entrar nada. Si es tu red doméstica, hazla Privada: Configuración › Red e Internet › Wi-Fi › sus propiedades.';

  @override
  String get pcFirewallRefused =>
      'No cambió nada: Windows necesita el permiso de un administrador.';

  @override
  String get pcFirewallTitle => 'Firewall de Windows';

  @override
  String pcFound(String name) {
    return 'Se encontró $name. Escribe el código que muestra.';
  }

  @override
  String pcFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count encontradas',
      one: '1 encontrada',
    );
    return '$_temp0';
  }

  @override
  String pcLastContact(String time) {
    return 'Último contacto $time';
  }

  @override
  String get pcLibrary => 'Biblioteca en la computadora';

  @override
  String get pcLinkAddress => 'Dirección en esta red';

  @override
  String get pcLinkAddressTailscale => 'Por Tailscale, desde fuera de casa';

  @override
  String get pcLinkAllow => 'Permitir';

  @override
  String get pcLinkAllowDelete => 'Permitir que el teléfono elimine clips';

  @override
  String get pcLinkAllowDeleteHint =>
      'Un clip eliminado desde el teléfono va a la Papelera de reciclaje de esta computadora, desde donde puedes recuperarlo. En una unidad sin Papelera de reciclaje no se elimina.';

  @override
  String get pcLinkCodeHint =>
      'En el teléfono: Ajustes › Computadora › Escanear el código QR. O escribe ahí esta dirección y este código. Funciona una vez, durante dos minutos.';

  @override
  String pcLinkCodeLeft(int seconds) {
    return 'Quedan $seconds s';
  }

  @override
  String get pcLinkCodeTitle => 'Código de vinculación';

  @override
  String get pcLinkDeny => 'Rechazar';

  @override
  String get pcLinkDevices => 'Teléfonos vinculados';

  @override
  String pcLinkFailed(String error) {
    return 'No se pudo iniciar: $error';
  }

  @override
  String get pcLinkIntro =>
      'Envía enlaces desde VidHoist en tu teléfono a esta computadora, y ve sus descargas y su biblioteca allí. Funciona dentro de tu red doméstica, y desde fuera a través de Tailscale.';

  @override
  String pcLinkLastSeen(String time) {
    return 'Última señal $time';
  }

  @override
  String get pcLinkNoDevices => 'Aún no hay ningún teléfono.';

  @override
  String get pcLinkOff => 'Desactivado';

  @override
  String pcLinkOtherAddresses(int count) {
    return 'Otras direcciones ($count)';
  }

  @override
  String get pcLinkOtherAddressesHint =>
      'Adaptadores de red que agregan otros programas, como VirtualBox o WSL. El teléfono casi nunca los necesita.';

  @override
  String get pcLinkPairPhone => 'Vincular un teléfono';

  @override
  String pcLinkPairedAt(String time) {
    return 'Vinculado $time';
  }

  @override
  String pcLinkPhones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count teléfonos',
      one: 'Un teléfono',
      zero: 'Ningún teléfono',
    );
    return '$_temp0';
  }

  @override
  String get pcLinkQrHint => 'Escanea desde el teléfono';

  @override
  String get pcLinkReceive => 'Recibir del teléfono';

  @override
  String get pcLinkReceiveHint =>
      'Mientras está desactivado, no hay ningún puerto abierto en esta computadora. Si Windows pregunta, permite solo redes privadas.';

  @override
  String pcLinkRequest(String name) {
    return '$name pide vincularse';
  }

  @override
  String get pcLinkRequestHint =>
      'Permite solo si el teléfono muestra los mismos cuatro dígitos.';

  @override
  String get pcLinkRevoke => 'Desvincular';

  @override
  String get pcLinkSecurity =>
      'El teléfono habla directamente con esta computadora, en tu red o a través de tu Tailscale. Se vincula una vez, con el código y tu aprobación aquí; después presenta su propia clave en cada solicitud, por una conexión cifrada solo con el certificado de esta computadora. Cualquier otro en la red encuentra la puerta cerrada.';

  @override
  String get pcLinkStarting => 'Iniciando…';

  @override
  String get pcLinkTitle => 'Teléfono';

  @override
  String get pcListEmpty =>
      'Ninguno de los clips de esta lista sigue en la computadora.';

  @override
  String get pcListen => 'Escuchar';

  @override
  String get pcLists => 'Listas en la computadora';

  @override
  String get pcListsEmpty => 'Ninguna lista de la computadora tiene clips.';

  @override
  String get pcNow => 'En la computadora ahora';

  @override
  String get pcOffline => 'No disponible';

  @override
  String get pcOfflineMessage =>
      'La computadora está apagada o en otra red. Abajo se muestra lo que tenía la última vez.';

  @override
  String get pcOfflineRoute =>
      '¿Fuera de casa? Elige Tailscale en Ajustes › Computadora.';

  @override
  String get pcOnPhone => 'En el teléfono';

  @override
  String get pcOrType => 'O escribe la dirección y el código';

  @override
  String get pcOutboxRefused => 'La computadora no aceptó este enlace';

  @override
  String pcOutboxTitle(int count) {
    return 'Esperando para enviar ($count)';
  }

  @override
  String get pcPairButton => 'Vincular';

  @override
  String pcPairCheck(String check) {
    return 'Comprueba que la computadora muestre $check y luego permite el teléfono allí.';
  }

  @override
  String get pcPairIntro =>
      'Si VidHoist está en tu computadora con Windows, este teléfono puede enviarle enlaces y mostrar sus descargas y su biblioteca. En la computadora, activa Ajustes › Teléfono y pulsa Vincular un teléfono; luego escanea el código QR que muestra.';

  @override
  String pcPaired(String name) {
    return 'Vinculado con $name';
  }

  @override
  String get pcPortLabel => 'Puerto';

  @override
  String pcQueued(String name) {
    return 'Irá a $name cuando vuelva a estar disponible.';
  }

  @override
  String pcQueuedMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clips irán a $name cuando vuelva a estar disponible.',
      one: '1 clip irá a $name cuando vuelva a estar disponible.',
    );
    return '$_temp0';
  }

  @override
  String get pcRouteHint =>
      'Elige Tailscale cuando estés fuera de casa; debe estar activo tanto en el teléfono como en la computadora.';

  @override
  String get pcRouteHome => 'Red doméstica';

  @override
  String get pcRouteOther => 'Otra red';

  @override
  String get pcRouteTailscale => 'Tailscale';

  @override
  String get pcRouteTitle => 'Conectar a través de';

  @override
  String get pcRouteWaiting =>
      'Las otras rutas de la computadora aparecen aquí cuando responda.';

  @override
  String get pcScanButton => 'Escanear el código QR';

  @override
  String get pcScanFailed => 'No se pudo abrir la cámara.';

  @override
  String get pcScanPrompt =>
      'Apunta la cámara al código QR de la pantalla de la computadora';

  @override
  String get pcSearchHint => 'Buscar en la biblioteca de la computadora';

  @override
  String get pcSendToPc => 'Enviar a la computadora';

  @override
  String pcSent(String name) {
    return 'Enviado a $name';
  }

  @override
  String pcSentMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clips enviados a $name',
      one: '1 clip enviado a $name',
    );
    return '$_temp0';
  }

  @override
  String get pcSettingsHint => 'Envía enlaces a tu computadora';

  @override
  String get pcTab => 'Computadora';

  @override
  String pcVia(String route) {
    return 'A través de $route';
  }

  @override
  String get pcWatch => 'Ver';

  @override
  String get pcWillSend => 'Ausente: se envía cuando vuelva';

  @override
  String get pickAnotherFile => 'Desde otro archivo…';

  @override
  String get pickAnotherFileSubtitle =>
      'Una copia de otro teléfono o de una versión anterior';

  @override
  String get pictureInPicture => 'Imagen en imagen';

  @override
  String get pictureInPictureHelp =>
      'Si sales de la app mientras se reproduce un clip, queda en una esquina de la pantalla';

  @override
  String get pinPlaylist => 'Fijar arriba';

  @override
  String get platform => 'Sitio';

  @override
  String platformCount(Object name, int count) {
    return '$name · $count';
  }

  @override
  String get platformOther => 'Otro';

  @override
  String get play => 'Reproducir';

  @override
  String get playAll => 'Reproducir todo';

  @override
  String get playModeLabel => 'Modo';

  @override
  String get playbackSpeed => 'Velocidad de reproducción';

  @override
  String get playerError => 'No se pudo reproducir este archivo';

  @override
  String get playingFromDevice => 'Reproduciendo desde tu dispositivo';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistAddClips => 'Añadir clips';

  @override
  String playlistAddClipsTo(String name) {
    return 'Añadir a «$name»';
  }

  @override
  String playlistAddCount(int count) {
    return 'Añadir ($count)';
  }

  @override
  String get playlistCreated => 'Playlist creada';

  @override
  String get playlistDeleted => 'Playlist eliminada';

  @override
  String get playlistDetails => 'Detalles de la playlist';

  @override
  String get playlistEditHint =>
      'Mantén pulsado un clip para moverlo. Deslízalo a un lado para quitarlo.';

  @override
  String get playlistName => 'Nombre de la playlist';

  @override
  String get playlistNameHint => 'Mi playlist';

  @override
  String playlistOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get playlists => 'Playlists';

  @override
  String get previous => 'Anterior';

  @override
  String get quality => 'Calidad';

  @override
  String get quality1080 => 'Hasta 1080p';

  @override
  String get quality360 => 'Hasta 360p';

  @override
  String get quality480 => 'Hasta 480p';

  @override
  String get quality720 => 'Hasta 720p';

  @override
  String get qualityAudio => 'Audio';

  @override
  String get qualityBest => 'La mejor';

  @override
  String get qualityHelper =>
      'La usan la descarga rápida, las descargas de playlists completas y \"Descargar\" en la barra del portapapeles, y es la opción preseleccionada en la hoja para agregar enlaces. Así que importa tanto si la descarga rápida está activada como si no.';

  @override
  String get qualityReading => 'Leyendo el archivo…';

  @override
  String get qualityUnavailable => 'No disponible';

  @override
  String get qualityVideo => 'Video';

  @override
  String queueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
      zero: 'Sin elementos',
    );
    return '$_temp0';
  }

  @override
  String get queueLabel => 'Cola';

  @override
  String queuePosition(int position) {
    return 'Número $position en la cola';
  }

  @override
  String get queued => 'En cola';

  @override
  String get queuedSection => 'En espera';

  @override
  String get quickDownload => 'Descarga rápida';

  @override
  String get quickDownloadHelp =>
      'Un enlace compartido o pegado empieza a descargarse enseguida en la calidad predeterminada, sin hoja. Un sitio que no tenga esa calidad da la mejor que tenga, y \"Solo audio\" funciona en todos los sitios.';

  @override
  String get rateLimit => 'Límite de velocidad';

  @override
  String get rateLimitNone => 'Sin límite';

  @override
  String rateLimitValue(int mb) {
    return '$mb MB/s';
  }

  @override
  String get reelsEndBack => 'Volver a la biblioteca';

  @override
  String get reelsEndContinue => 'Seguir con el resto de la lista';

  @override
  String get reelsEndReplay => 'Repetir desde el inicio';

  @override
  String get reelsEndTitle => 'Fin de los Shorts';

  @override
  String get reelsSwipeHint => 'Desliza hacia arriba para el siguiente Short';

  @override
  String get refresh => 'Actualizar';

  @override
  String get remove => 'Quitar';

  @override
  String get removeFromFavorites => 'Quitar de favoritos';

  @override
  String removeUnavailable(int count) {
    return 'Quitar $count no disponibles';
  }

  @override
  String get removedFromFavorites => 'Quitado de favoritos';

  @override
  String get removedFromPlaylist => 'Quitado de la playlist';

  @override
  String get rename => 'Cambiar nombre';

  @override
  String get renameTag => 'Cambiar nombre de la etiqueta';

  @override
  String get reportBug => 'Reportar un error';

  @override
  String get restoreConfirm =>
      '¿Restaurar los datos desde el archivo de copia? Esto reemplaza las playlists, las etiquetas y los ajustes actuales.';

  @override
  String get restoreData => 'Restaurar';

  @override
  String get restoreFailed =>
      'Falló la restauración: el archivo de copia no es válido';

  @override
  String get restorePickBody =>
      'Este teléfono tiene descargas de VidHoist pero no tiene ajustes, como después de reinstalar. Si guardaste una copia de seguridad, elígela: la app las guarda en Download/VidHoist/backups.';

  @override
  String get restorePickChoose => 'Elegir una copia';

  @override
  String get restorePickTitle => '¿Recuperar tus ajustes?';

  @override
  String get restoreSettings => 'Restaurar todos los datos';

  @override
  String get restoreSuccess => 'Datos restaurados correctamente';

  @override
  String get resumeSubscription => 'Reanudar';

  @override
  String get retry => 'Reintentar';

  @override
  String get saveSettings => 'Guardar ajustes';

  @override
  String get searchLogs => 'Buscar en los registros…';

  @override
  String get searchVideos => 'Buscar clips…';

  @override
  String get seekBackward10 => 'Atrás 10 segundos';

  @override
  String get seekForward10 => 'Adelante 10 segundos';

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String selected(int count) {
    return '$count seleccionados';
  }

  @override
  String selectedCount(int count) {
    return '$count seleccionados';
  }

  @override
  String get settings => 'Ajustes';

  @override
  String get settingsAccounts => 'Cuentas';

  @override
  String get settingsBackup => 'Copia de seguridad';

  @override
  String get settingsDownloads => 'Descargas';

  @override
  String get settingsGroupApp => 'App';

  @override
  String get settingsGroupData => 'Datos';

  @override
  String get settingsPlayback => 'Reproducción';

  @override
  String get settingsTranscripts => 'Transcripciones y subtítulos';

  @override
  String settingsValueChannels(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canales',
      one: '1 canal',
      zero: 'Aún no hay canales',
    );
    return '$_temp0';
  }

  @override
  String get settingsValueCompatOff => 'Máxima compatibilidad: desactivada';

  @override
  String get settingsValueCompatOn => 'Máxima compatibilidad: activada';

  @override
  String get settingsValueNotSet => 'Aún no configurado';

  @override
  String get settingsValueQuick => 'rápida';

  @override
  String settingsValueSignedIn(String sites) {
    return 'Sesión iniciada: $sites';
  }

  @override
  String get settingsValueWifiOnly => 'Solo Wi‑Fi';

  @override
  String get share => 'Compartir';

  @override
  String get shareLogs => 'Compartir registros';

  @override
  String get shareOpening => 'Abriendo el menú para compartir…';

  @override
  String get shareOpeningHint =>
      'Un archivo grande tarda unos segundos en entregarse.';

  @override
  String get shareSelected => 'Compartir selección';

  @override
  String get sharedLinksAdd => 'Agregarlos';

  @override
  String get sharedLinksBody => 'Cada uno se descarga en este teléfono.';

  @override
  String sharedLinksCapped(int max) {
    return 'Solo se agregaron los primeros $max enlaces.';
  }

  @override
  String sharedLinksTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Agregar $count enlaces?',
      one: '¿Agregar 1 enlace?',
    );
    return '$_temp0';
  }

  @override
  String get shortsFilter => 'Shorts';

  @override
  String get shuffle => 'Aleatorio';

  @override
  String get signInRequired => 'Debes iniciar sesión';

  @override
  String get size => 'Tamaño';

  @override
  String get smartPlaylists => 'Playlists inteligentes';

  @override
  String get sortAndPlatform => 'Orden y sitio';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortLargest => 'Más grandes';

  @override
  String get sortNameAZ => 'Nombre A–Z';

  @override
  String get sortNameZA => 'Nombre Z–A';

  @override
  String get sortNewest => 'Más recientes';

  @override
  String get sortOldest => 'Más antiguos';

  @override
  String get sortSmallest => 'Más pequeños';

  @override
  String get sortedByLastPlayed => 'Por última reproducción';

  @override
  String get source => 'Fuente';

  @override
  String get sourceCode => 'Código fuente';

  @override
  String get startDownload => 'Iniciar descarga';

  @override
  String get status => 'Estado';

  @override
  String get storageCardMissing =>
      'La tarjeta no está puesta, así que las descargas van al teléfono';

  @override
  String get storageLocation => 'Guardar en';

  @override
  String get storageLocationHelp =>
      'Los clips ya descargados se quedan donde están y siguen apareciendo en la biblioteca. Una tarjeta de memoria necesita Android 11 o posterior.';

  @override
  String get storageNoCard => 'Este teléfono no tiene tarjeta de memoria';

  @override
  String get storagePhone => 'Almacenamiento del teléfono';

  @override
  String get streamingOnline => 'Reproduciendo por la red';

  @override
  String subscriptionAdded(String name) {
    return 'Ahora sigues a $name';
  }

  @override
  String get subscriptionName => 'Nombre';

  @override
  String get subscriptionPaused => 'En pausa';

  @override
  String get subscriptionQuality => 'Calidad para este canal';

  @override
  String get subscriptionQualityHelp =>
      'La calidad con la que se descargan los videos nuevos de este canal. Puedes cambiarla después editando el canal; los videos ya descargados conservan la suya.\n\n\"La mejor\" puede significar 4K en formato AV1, que una computadora antigua puede reproducir a tirones: si pasa, elige 1080p.';

  @override
  String get subscriptionQualityNote =>
      'Se aplica a los videos nuevos; los ya descargados conservan la suya.';

  @override
  String get subscriptions => 'Canales';

  @override
  String get subscriptionsEmpty => 'Aún no sigues ningún canal';

  @override
  String get subscriptionsEmptyBody =>
      'Sigue un canal y cada video nuevo se descarga solo en tu biblioteca, mientras VidHoist está abierto o en la bandeja. Lo que ya está en el canal no se descarga.';

  @override
  String get subscriptionsSubtitle =>
      'Videos nuevos de los canales que sigues, descargados solos';

  @override
  String get subtitleLangs => 'Idiomas de subtítulos';

  @override
  String get subtitleLangsHelp =>
      'Se obtienen cuando el video los tiene. Al menos uno queda elegido.';

  @override
  String get subtitles => 'Subtítulos';

  @override
  String get subtitlesBackground => 'Fondo';

  @override
  String get subtitlesBackgroundFaint => 'Claro';

  @override
  String get subtitlesBackgroundHelp =>
      'Lo que va detrás de las palabras. Sin fondo, cada letra conserva un borde oscuro para que se lea sobre una imagen clara.';

  @override
  String get subtitlesBackgroundNone => 'Ninguno';

  @override
  String get subtitlesBackgroundSolid => 'Oscuro';

  @override
  String get subtitlesHide => 'Ocultar subtítulos';

  @override
  String get subtitlesLanguage => 'Idioma de subtítulos';

  @override
  String get subtitlesShow => 'Mostrar subtítulos';

  @override
  String get subtitlesShowHelp =>
      'Sobre el video, en los clips que tienen transcripción. El botón CC del reproductor hace lo mismo.';

  @override
  String get subtitlesSize => 'Tamaño del texto';

  @override
  String get subtitlesSizeLarge => 'Grande';

  @override
  String get subtitlesSizeMedium => 'Mediano';

  @override
  String get subtitlesSizeSmall => 'Pequeño';

  @override
  String tagLimitReached(int max) {
    return 'Puedes tener hasta $max etiquetas. Quita una en Administrar etiquetas para agregar otra.';
  }

  @override
  String get tags => 'Etiquetas';

  @override
  String get tagsOpenFiltered => 'Abre la biblioteca filtrada';

  @override
  String get theme => 'Tema';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get titleFilter => 'Solo descargar títulos que contengan';

  @override
  String get titleFilterHelp =>
      'Un video nuevo de este canal solo se descarga si su título contiene lo que escribas aquí.\n\n• Basta con una palabra: Episodio\n• Cualquiera de varias palabras: Episodio|Parte (la | significa \"o\")\n• Las mayúsculas no importan: episodio también coincide con Episodio.\n\nUn video que el filtro omite cuenta como visto para siempre: quitar el filtro después descarga lo que venga, no lo que se omitió.';

  @override
  String get titleFilterHelper =>
      'Varias palabras: sepáralas con | . Déjalo vacío para todo.';

  @override
  String get titleFilterHint => 'p. ej. Episodio';

  @override
  String get titleLabel => 'Título';

  @override
  String totalDuration(Object duration) {
    return 'Total: $duration';
  }

  @override
  String get transcript => 'Transcripción';

  @override
  String transcriptSaidMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dicho $count veces más',
      one: 'Dicho una vez más',
    );
    return '$_temp0';
  }

  @override
  String transcriptsClips(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clips',
      one: '1 clip',
      zero: 'Aún no hay clips',
    );
    return '$_temp0';
  }

  @override
  String get transcriptsDeleteAll => 'Eliminar todo';

  @override
  String get transcriptsDeleteTitle => '¿Eliminar todas las transcripciones?';

  @override
  String get transcriptsSaidInside => 'Dicho dentro de los clips';

  @override
  String get transcriptsSearchHelp =>
      'Guarda las palabras de cada clip de YouTube que agregas, para que puedas buscar lo que se dijo.';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get undo => 'Deshacer';

  @override
  String get unfollow => 'Dejar de seguir';

  @override
  String unfollowConfirm(String name) {
    return '¿Dejar de seguir a $name?';
  }

  @override
  String get unfollowConfirmBody =>
      'VidHoist olvida qué videos ya vio en este canal. Si lo vuelves a seguir más adelante, todo lo que tenga para entonces cuenta como visto, y lo que te perdiste no se completa. Pausar conserva esa memoria.';

  @override
  String get unlockTouch => 'Desbloquear';

  @override
  String get unpinPlaylist => 'No fijar';

  @override
  String get updateNoticeBody => 'Abre VidHoist para instalarla.';

  @override
  String get upNext => 'A continuación';

  @override
  String upNextIn(String name) {
    return 'A continuación en «$name»';
  }

  @override
  String get updateAllowInstallBody =>
      'Android necesita tu permiso para que la app pueda instalar sus propias actualizaciones. Concédelo una vez en los ajustes del sistema y luego toca Instalar otra vez.';

  @override
  String get updateAllowInstallTitle => 'Permitir instalar actualizaciones';

  @override
  String get updateAvailable => 'Actualización disponible';

  @override
  String get updateCheckFailed => 'No se pudo buscar actualizaciones';

  @override
  String get updateChecking => 'Buscando…';

  @override
  String get updateDownloadFailed => 'No se pudo descargar la actualización';

  @override
  String updateDownloadedMb(String done, String total) {
    return '$done de $total MB';
  }

  @override
  String get updateDownloading => 'Descargando actualización…';

  @override
  String get updateFailedToStart => 'No se pudo abrir el instalador';

  @override
  String get updateInstall => 'Instalar';

  @override
  String get updateLater => 'Más tarde';

  @override
  String get updateNever => 'Todavía no';

  @override
  String get updateNow => 'Descargar actualización';

  @override
  String get updateOpenSystemSettings => 'Abrir ajustes';

  @override
  String get updateReady => 'Lista para instalar';

  @override
  String updateSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get updateSkipVersion => 'Omitir esta versión';

  @override
  String get updateUpToDate => 'Tienes la versión más reciente';

  @override
  String updateVersionAvailable(String version) {
    return 'La versión $version está disponible';
  }

  @override
  String updateVersionTitle(String version) {
    return 'Versión $version';
  }

  @override
  String get updateWhatsNew => 'Novedades';

  @override
  String get updates => 'Actualizaciones';

  @override
  String get version => 'Versión';

  @override
  String get videoAdded => 'Agregado a la playlist';

  @override
  String get videoPlayer => 'Reproductor de video';

  @override
  String get viewAll => 'Ver todo';

  @override
  String get viewAllInPlaylists => 'Ver todo';

  @override
  String get viewCards => 'Tarjetas';

  @override
  String get viewGrid => 'Cuadrícula';

  @override
  String get viewList => 'Lista';

  @override
  String get viewMode => 'Vista';

  @override
  String get waitingForWifi => 'Esperando Wi-Fi';

  @override
  String get whatsNewGotIt => 'Entendido';

  @override
  String get whatsNewReleasePage => 'Página de la versión';

  @override
  String get whatsNewThisVersion => 'Novedades de esta versión';

  @override
  String whatsNewTitle(String version) {
    return 'Novedades de $version';
  }

  @override
  String get whatsNewUnavailable =>
      'Lo que cambió en esta versión está en la página de la versión.';

  @override
  String get wifiOnly => 'Descargar solo por Wi-Fi';

  @override
  String get wifiOnlyHelp =>
      'No se descarga nada con datos móviles. Las descargas esperan al Wi-Fi, y una en curso cuando se cae el Wi-Fi se pausa y sigue sola cuando vuelve.';

  @override
  String get yourPlaylists => 'Tus playlists';

  @override
  String get yourTags => 'Tus etiquetas';

  @override
  String get ytdlpCredit => 'El descargador que usa VidHoist';
}
