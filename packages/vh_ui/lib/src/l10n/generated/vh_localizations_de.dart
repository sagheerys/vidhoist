// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'vh_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class VhLocalizationsDe extends VhLocalizations {
  VhLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get about => 'Info';

  @override
  String get aboutApp => 'Über die App';

  @override
  String get aboutDescriptionPhone =>
      'Eine leichte, schnelle App, die mit yt-dlp Video und Audio von vielen Seiten herunterlädt. Sie hat einen eigenen Player und eigene Playlists.';

  @override
  String get accountSignIn => 'Anmelden';

  @override
  String get accountSignOut => 'Abmelden';

  @override
  String get accountSignedIn => 'Angemeldet';

  @override
  String get accountSignedOut => 'Nicht angemeldet';

  @override
  String accountSignedOutOf(String site) {
    return 'Von $site abgemeldet';
  }

  @override
  String get accountsBanRisk =>
      'Nimm besser ein Zweitkonto: Viele Downloads können dazu führen, dass die Seite ein Konto eine Zeit lang einschränkt.';

  @override
  String get accountsClearAll => 'Alle Cookies löschen';

  @override
  String get accountsCleared => 'Cookies gelöscht';

  @override
  String get accountsFileHint =>
      'Aus einem Browser als cookies.txt-Datei (Netscape-Format) exportiert, für jede Seite, auch die oben nicht aufgeführten. Sie ergänzt die Anmeldungen, die schon hier sind, und bleibt auf diesem Handy.';

  @override
  String get accountsFilePick => 'Cookie-Datei auswählen';

  @override
  String get accountsFileTitle => 'Oder eine Cookie-Datei importieren';

  @override
  String get accountsFromFile => 'Aus einer Cookie-Datei';

  @override
  String get accountsHelp =>
      'Eine Anmeldung läuft nach einer Weile ab; wenn eine Seite wieder ablehnt, melde dich noch einmal an. Wenn du dich bei einer Seite abmeldest, meldet sich der In-App-Browser auch bei den anderen ab; deren Downloads laufen weiter wie bisher. Wenn dich eine Seite hier nicht anmelden lässt, importiere unten eine Cookie-Datei aus dem Browser deines Computers.';

  @override
  String get accountsHint =>
      'Für Seiten, die einen Download ohne Anmeldung verweigern. Du meldest dich auf der Seite selbst in der App an; was sie hinterlässt, bleibt auf diesem Handy, wo yt-dlp es bei jedem Download liest, und geht nirgendwo anders hin.';

  @override
  String get activeDownloads => 'Aktive Downloads';

  @override
  String activeDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Downloads laufen',
      one: '1 Download läuft',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloadsSheet => 'Aktive Downloads';

  @override
  String get activeNow => 'Gerade aktiv';

  @override
  String get addLinkFab => 'Link hinzufügen';

  @override
  String get addTo => 'Hinzufügen zu…';

  @override
  String get addToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get addToPlaylist => 'Zur Playlist hinzufügen';

  @override
  String get addUrl => 'URL hinzufügen';

  @override
  String addedNToServer(int count) {
    return '$count zu den Downloads hinzugefügt';
  }

  @override
  String get addedToFavorites => 'Zu Favoriten hinzugefügt';

  @override
  String addedToPlaylistCount(int count) {
    return '$count zur Playlist hinzugefügt';
  }

  @override
  String get allDownloadsFinished => 'Alle Downloads abgeschlossen.';

  @override
  String get allPlatforms => 'Alle Seiten';

  @override
  String get alreadyInPlaylist => 'Schon hinzugefügt';

  @override
  String get alreadySubscribed => 'Du folgst diesem Kanal bereits';

  @override
  String get appTitle => 'VidHoist';

  @override
  String get appearanceAndLanguage => 'Aussehen & Sprache';

  @override
  String audioChannels(int count) {
    return '$count Kanäle';
  }

  @override
  String get audioFormat => 'Audioformat';

  @override
  String get audioFormatM4a => 'M4A: läuft überall';

  @override
  String get audioFormatMp3 => 'MP3: für ältere Player und Autos';

  @override
  String get audioFormatOriginal => 'Wie die Seite es sendet, unkonvertiert';

  @override
  String get audioMono => 'Mono';

  @override
  String get audioOnly => 'Nur Audio';

  @override
  String get audioStereo => 'Stereo';

  @override
  String get autoBuilt => 'Automatisch';

  @override
  String get autoCheckUpdates => 'Automatisch prüfen';

  @override
  String get autoCheckUpdatesHelp =>
      'Sucht im Hintergrund etwa zweimal am Tag nach einer neuen Version.';

  @override
  String get autoRestoreSuccess => 'Daten aus dem Backup wiederhergestellt.';

  @override
  String get autoRetry => 'Wiederholen, wenn das Netz zurück ist';

  @override
  String get autoRetryHelp =>
      'Was wegen eines Netzausfalls fehlgeschlagen ist, wird automatisch wiederholt, sobald das Netz zurück ist. Was eine Seite abgelehnt hat, wird nicht wiederholt: Unverändert noch einmal versucht, scheitert es nur wieder.';

  @override
  String get backgroundChecks => 'Prüfen, wenn die App geschlossen ist';

  @override
  String get backgroundChecksHelp =>
      'Etwa alle sechs Stunden, wenn ein Netz da ist und der Akku nicht schwach ist. Du erfährst nur, was neu ist; die Videos werden geladen, wenn du VidHoist öffnest.';

  @override
  String get backgroundDownload =>
      'Dateien werden im Hintergrund heruntergeladen…';

  @override
  String backgroundLastRun(String when) {
    return 'Letzte Prüfung bei geschlossener App: $when';
  }

  @override
  String get backgroundNotRunYet =>
      'Noch keine Prüfung bei geschlossener App: Android wählt den Zeitpunkt.';

  @override
  String get backgroundOfferBody =>
      'VidHoist kann etwa alle sechs Stunden in deine Kanäle schauen und dir sagen, was neu ist. Geladen wird erst, wenn du die App öffnest.';

  @override
  String get backgroundOfferNo => 'Nicht jetzt';

  @override
  String get backgroundOfferTitle =>
      'Über neue Videos informiert werden, wenn VidHoist geschlossen ist?';

  @override
  String get backgroundOfferYes => 'Einschalten';

  @override
  String get backupNote =>
      'Enthält die Bibliothek, Playlists, Tags, gefolgte Kanäle und Einstellungen. Anmeldungen und Transkripte werden getrennt aufbewahrt, und die Mediendateien selbst sind nicht enthalten.';

  @override
  String get backupSettings => 'Alle Daten sichern';

  @override
  String get backupSettingsSubtitle =>
      'Sieben datierte Kopien, die sich selbst erneuern. Stell eine davon wieder her oder exportiere eine zum Teilen';

  @override
  String backupSuccess(Object path) {
    return 'Backup gespeichert unter: $path';
  }

  @override
  String backupsKept(int count) {
    return '$count Backups aufbewahrt';
  }

  @override
  String get batchDownloadSelected => 'Auswahl herunterladen';

  @override
  String get batchLoading => 'Playlist wird gelesen…';

  @override
  String get batchNothingSelected => 'Wähle mindestens ein Element aus';

  @override
  String batchSelectedOf(int selected, int total) {
    return '$selected von $total ausgewählt';
  }

  @override
  String get batchThisVideoOnly => 'Nur diesen Clip herunterladen';

  @override
  String get batchTitle => 'Mehrfach-Download';

  @override
  String get batteryAllow => 'Erlauben';

  @override
  String get batteryFree =>
      'Der Energiesparmodus lässt Downloads in Ruhe, auch wenn die App nicht sichtbar ist.';

  @override
  String get batteryRestricted =>
      'Der Energiesparmodus kann einen langen Download stoppen, wenn die App nicht sichtbar ist.';

  @override
  String get batteryStateFree => 'Erlaubt';

  @override
  String get batteryStateLimited => 'Eingeschränkt';

  @override
  String get batteryTitle => 'Downloads im Hintergrund';

  @override
  String bitrateKbps(String value) {
    return '$value kb/s';
  }

  @override
  String bitrateMbps(String value) {
    return '$value Mb/s';
  }

  @override
  String get builtWith => 'Erstellt mit';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get changeQuality => 'Qualität ändern';

  @override
  String get channelNameFolder => 'Nach dem Kanal benannt';

  @override
  String channelFollowers(String count) {
    return '$count Abonnenten';
  }

  @override
  String get channelCheckFailed =>
      'Diesmal nicht geprüft. VidHoist versucht es von selbst erneut.';

  @override
  String get channelUrl =>
      'Link zu einem Kanal, einer Playlist oder einem ihrer Videos';

  @override
  String get channelUrlHint => 'https://www.youtube.com/@name';

  @override
  String chapterNumber(int number) {
    return 'Kapitel $number';
  }

  @override
  String get chaptersFold => 'Kapitel ausblenden';

  @override
  String chaptersFromTranscript(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kapitel aus dem Transkript',
      one: '1 Kapitel aus dem Transkript',
    );
    return '$_temp0';
  }

  @override
  String get chaptersShowAll => 'Alle Kapitel ansehen';

  @override
  String get chaptersUnfold => 'Kapitel einblenden';

  @override
  String get checkEvery => 'Wie oft prüfen';

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String get checkNow => 'Jetzt prüfen';

  @override
  String get checkQueued =>
      'Wird jetzt geprüft. Neues erscheint in der Bibliothek.';

  @override
  String get chooseFolder => 'Ordner auswählen';

  @override
  String get chooseOptions => 'Optionen';

  @override
  String get clear => 'Leeren';

  @override
  String get clearLogs => 'Protokolle löschen';

  @override
  String get clearLogsConfirm => 'Alle Diagnoseprotokolle löschen?';

  @override
  String get clipEndAfterStart => 'Nach dem Anfang';

  @override
  String get clipFrom => 'Von';

  @override
  String clipLength(Object length) {
    return 'Das Video ist $length lang';
  }

  @override
  String get clipLengthReading => 'Länge des Videos wird gelesen…';

  @override
  String get clipLengthUnknown =>
      'Die Seite gibt die Länge des Videos nicht an, daher werden die Zeiten nicht geprüft';

  @override
  String get clipMinuteDown => 'Eine Minute früher';

  @override
  String get clipMinuteUp => 'Eine Minute später';

  @override
  String get clipOnly => 'Nur einen Teil des Videos';

  @override
  String get clipOnlyHelp =>
      'Von einer Zeit bis zu einer anderen, ohne den Rest. Er kommt ohne Untertitel.';

  @override
  String clipPastEnd(Object length) {
    return 'Das Video endet bei $length';
  }

  @override
  String get clipTimeHint => 'Nur Ziffern: 130 ist 1:30';

  @override
  String get clipTo => 'Bis';

  @override
  String get clipboardFound => 'In deiner Zwischenablage liegt ein Link bereit';

  @override
  String get clipboardLinkReady => 'Link einfügen';

  @override
  String get closePlayer => 'Player schließen';

  @override
  String get columnAdded => 'Hinzugefügt';

  @override
  String get columnChannel => 'Kanal';

  @override
  String get columnLength => 'Länge';

  @override
  String get compactView => 'Kompakte Ansicht';

  @override
  String get compatiblePlayback => 'Beste Wiedergabe-Kompatibilität';

  @override
  String get compatiblePlaybackHelp =>
      'Fordert H.264/AAC an, das jedes Handy per Hardware dekodiert. Ohne diese Option liefert YouTube eventuell AV1, das viele Geräte als verzerrtes Bild darstellen. Ausgeschaltet ist die höchste Auflösung möglich, auf Kosten der Kompatibilität.';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get continueAsAudio => 'Als Audio weiter';

  @override
  String get continueAsAudioBody =>
      'Das hier ab derselben Sekunde als Audio weiterspielen?';

  @override
  String get continueAsAudioNo => 'Nein, stoppen';

  @override
  String get continueAsAudioTitle => 'Im Hintergrund weiter?';

  @override
  String get cookies => 'Cookies';

  @override
  String get cookiesNotNetscape =>
      'Keine dieser Dateien enthält Cookies im Netscape-Format';

  @override
  String get cookiesSubtitle =>
      'Für Seiten, die ohne Anmeldung nicht herunterladen';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get copyright => '© 2026 Yasir Sagheer';

  @override
  String get couldNotLoadPlaylist =>
      'Diese Playlist konnte nicht geladen werden. Prüfe die URL und deine Verbindung.';

  @override
  String get create => 'Erstellen';

  @override
  String get createPlaylist => 'Playlist erstellen';

  @override
  String get defaultQuality => 'Standard-Videoqualität';

  @override
  String get delete => 'Löschen';

  @override
  String deleteMultipleConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Clips löschen?\n\nIhre Dateien werden von deinem Gerät entfernt.',
      one: '1 Clip löschen?\n\nSeine Datei wird von deinem Gerät entfernt.',
    );
    return '$_temp0';
  }

  @override
  String deletePlaylistConfirm(Object name) {
    return '„$name“ löschen?';
  }

  @override
  String get deleteRefused =>
      'Nicht gelöscht: Android braucht deine Erlaubnis, um diese Datei zu löschen, im Dialog, den es anzeigt.';

  @override
  String get deleteSelected => 'Auswahl löschen';

  @override
  String get deleteTag => 'Tag löschen';

  @override
  String deleteTagConfirm(Object tag) {
    return 'Den Tag „$tag“ von allen Elementen entfernen? Die Clips selbst werden nicht gelöscht.';
  }

  @override
  String get deleteVideo => 'Clip löschen';

  @override
  String deleteVideoConfirm(Object title) {
    return '„$title“ löschen?\n\nDie Datei wird von deinem Gerät entfernt.';
  }

  @override
  String deletedCount(Object count) {
    return '$count gelöscht';
  }

  @override
  String deletedTitle(Object title) {
    return 'Gelöscht: $title';
  }

  @override
  String get deselectAll => 'Auswahl aufheben';

  @override
  String desktopAddLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Links hinzufügen',
      one: '1 Link hinzufügen',
      zero: 'Nichts hinzuzufügen',
    );
    return '$_temp0';
  }

  @override
  String get desktopBack => 'Zurück';

  @override
  String get desktopBackUpNow => 'Jetzt sichern';

  @override
  String get desktopBackupHint =>
      'Dieser Computer bewahrt seine letzten sieben Backups, mindestens eine Stunde auseinander, in Downloads\\VidHoist\\Backups auf, wo sie eine Deinstallation überstehen.';

  @override
  String get desktopBackupsNone => 'Noch kein Backup';

  @override
  String get desktopBrowserButton => '„Zu VidHoist“-Button im Browser';

  @override
  String get desktopBrowserButtonCopied =>
      'Code kopiert. Leg ein neues Lesezeichen an und füge ihn als Adresse (URL) ein.';

  @override
  String get desktopBrowserButtonCopy => 'Code kopieren';

  @override
  String get desktopBrowserButtonFailed =>
      'Die Seite ließ sich nicht öffnen; kopiere stattdessen den Code.';

  @override
  String get desktopBrowserButtonHint =>
      'Ein Button in deiner Lesezeichenleiste: Ein Klick auf der Seite eines beliebigen Videos öffnet hier den Hinzufügen-Dialog mit seinem Link. Nichts wird gesendet, bevor du auf Hinzufügen drückst.';

  @override
  String get desktopBrowserButtonName => 'Zu VidHoist';

  @override
  String get desktopBrowserButtonOpen => 'Einrichtungsseite öffnen';

  @override
  String get desktopBrowserPageCopyInstead =>
      'Wenn das Ziehen nicht klappt, leg ein neues Lesezeichen an und füge das hier als Adresse ein:';

  @override
  String get desktopBrowserPageDragHint =>
      'Zieh ihn in die Leiste; ein Klick hier bewirkt nichts.';

  @override
  String get desktopBrowserPageStep1 =>
      'Blende die Lesezeichenleiste ein, falls sie verborgen ist:';

  @override
  String get desktopBrowserPageStep2 =>
      'Zieh den Button unten mit der Maus in die Leiste.';

  @override
  String get desktopBrowserPageStep3 =>
      'Klick ihn auf der Seite eines beliebigen Videos an: VidHoist öffnet den Hinzufügen-Dialog mit dem Link. Beim ersten Mal fragt der Browser, ob er die App öffnen soll; erlaube es.';

  @override
  String get desktopBrowserPageTitle =>
      'Füge den „Zu VidHoist“-Button zu deinem Browser hinzu';

  @override
  String get desktopChangeFolder => 'Ändern…';

  @override
  String get desktopChannel => 'Kanal';

  @override
  String get desktopChannelClips => 'In deiner Bibliothek';

  @override
  String get desktopChannels => 'Kanäle';

  @override
  String get desktopChannelsInLibrary => 'Kanäle in deiner Bibliothek';

  @override
  String get desktopChannelsLater => 'Braucht die Download-Engine';

  @override
  String get desktopChannelsLaterBody =>
      'Um einem Kanal zu folgen, braucht dieser Computer yt-dlp. Richte es unter Einstellungen › Engine ein, dann erscheinen deine Kanäle hier.';

  @override
  String get desktopChapters => 'Kapitel';

  @override
  String get desktopCheckAll => 'Alle prüfen';

  @override
  String get desktopChooseClip => 'Auswählen';

  @override
  String get desktopClearFilters => 'Filter zurücksetzen';

  @override
  String get desktopClearSelection => 'Auswahl aufheben';

  @override
  String get desktopCloseAnyway => 'Schließen';

  @override
  String desktopCloseBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wenn du VidHoist jetzt schließt, halten sie an und machen beim nächsten Öffnen dort weiter, wo sie aufgehört haben.',
      one: 'Wenn du VidHoist jetzt schließt, hält er an und macht beim nächsten Öffnen dort weiter, wo er aufgehört hat.',
    );
    return '$_temp0';
  }

  @override
  String get desktopCloseKeep => 'Weiter herunterladen';

  @override
  String desktopCloseMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'und $count weitere',
      one: 'und 1 weiterer',
    );
    return '$_temp0';
  }

  @override
  String desktopCloseTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Downloads sind nicht fertig',
      one: 'Ein Download ist nicht fertig',
    );
    return '$_temp0';
  }

  @override
  String get desktopCookiesBrowser => 'Aus einem Browser';

  @override
  String get desktopCookiesBrowserHint =>
      'Aus dem Browser gelesen, in dem du angemeldet bist. Wenn sie sich nicht lesen lassen, schließ diesen Browser und versuch es erneut.';

  @override
  String get desktopCookiesChoose => 'Datei auswählen…';

  @override
  String get desktopCookiesFile => 'Cookie-Datei';

  @override
  String get desktopCookiesHelp =>
      'Nutze in deinem Browser eine Erweiterung, die Cookies im Netscape-Format exportiert (eine Datei pro Seite), und wähle die Dateien hier zusammen aus. yt-dlp nutzt sie dann für jeden Download. Cookies laufen ab: Wenn ein Download wieder fehlschlägt, ist meist ein neuer Export fällig.';

  @override
  String get desktopCookiesKept => 'Cookies auf diesem Computer';

  @override
  String desktopCookiesKeptFor(String sites) {
    return 'Cookies gespeichert für: $sites';
  }

  @override
  String get desktopCookiesLocalHint =>
      'Für Seiten, bei denen du angemeldet sein musst. yt-dlp liest sie auf diesem Computer, und sie gehen nirgendwo anders hin.';

  @override
  String get desktopCookiesNone => 'Keine';

  @override
  String get desktopCookiesRemove => 'Entfernen';

  @override
  String get desktopCopiedLinkAdd => 'Hinzufügen…';

  @override
  String get desktopCopiedLinkTitle => 'Diesen Link herunterladen?';

  @override
  String get desktopCopyFile => 'Datei kopieren';

  @override
  String get desktopCopyFileFailed => 'Die Datei konnte nicht kopiert werden';

  @override
  String get desktopCopyLink => 'Link kopieren';

  @override
  String get desktopCopyOneClip =>
      'Kopieren geht nur mit einem Clip auf einmal';

  @override
  String get desktopCopyQuote => 'Mit Zeit und Link kopieren';

  @override
  String get desktopDefaultQualityHint =>
      'Womit jedes Hinzufügen beginnt; du kannst es für jeden Link noch ändern.';

  @override
  String desktopDeleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Clips löschen? Ihre Dateien auf diesem Computer werden gelöscht.',
      one: '1 Clip löschen? Seine Datei auf diesem Computer wird gelöscht.',
    );
    return '$_temp0';
  }

  @override
  String get desktopDesktopSection => 'Windows';

  @override
  String get desktopDiscover => 'VidHoist entdecken';

  @override
  String get desktopDiscoverAddLink => 'Link einfügen oder ablegen';

  @override
  String get desktopDiscoverAddLinkLine =>
      'Ctrl+V irgendwo, oder einen Link auf dem Fenster ablegen, um ihn hinzuzufügen.';

  @override
  String get desktopDiscoverAdding => 'Hinzufügen und teilen';

  @override
  String get desktopDiscoverBrowser => 'Aus dem Browser';

  @override
  String get desktopDiscoverBrowserLine =>
      'Der „Zu VidHoist“-Button in deiner Lesezeichenleiste öffnet den Hinzufügen-Dialog mit der Seite, auf der du bist.';

  @override
  String get desktopDiscoverChapters => 'Kapitel';

  @override
  String get desktopDiscoverChaptersLine =>
      'Die Teile eines Clips, aus seinem Transkript, auf seiner Seite.';

  @override
  String get desktopDiscoverChoose => 'Mehrere auswählen';

  @override
  String get desktopDiscoverChooseLine =>
      'Die runde Markierung, oder Ctrl oder Shift mit einem Klick; dann füg sie zusammen zu einer Liste hinzu oder lösch sie.';

  @override
  String get desktopDiscoverDragOut => 'Clip herausziehen';

  @override
  String get desktopDiscoverDragOutLine =>
      'Leg ihn auf einem Ordner oder in einer anderen App ab, dann kommt er dort als Datei an.';

  @override
  String get desktopDiscoverExport => 'Transkript exportieren';

  @override
  String get desktopDiscoverExportLine =>
      'Als Text oder als SRT-Untertitel für einen anderen Player.';

  @override
  String get desktopDiscoverHint =>
      'Alles, was die App kann, je eine Zeile, mit den Tasten dazu.';

  @override
  String get desktopDiscoverLibrary => 'Die Bibliothek';

  @override
  String get desktopDiscoverListening =>
      'Für Ton: ein ruhiger Raum mit großem Cover, im Vollbild.';

  @override
  String get desktopDiscoverMini => 'Kleines Fenster';

  @override
  String get desktopDiscoverMiniLine =>
      'Eine kleine Karte über allen anderen Fenstern, unten in der Ecke des Bildschirms.';

  @override
  String get desktopDiscoverReading =>
      'Das Transkript als Artikel: Klick einen Satz an, um ab dort zu hören.';

  @override
  String get desktopDiscoverSaid => 'Was gesagt wurde';

  @override
  String get desktopDiscoverSearch => 'Gesagtes durchsuchen';

  @override
  String get desktopDiscoverSearchLine =>
      'Finde die Clips, in denen ein Wort gesprochen wurde, nicht nur in Titeln.';

  @override
  String get desktopDiscoverShortcutsLine =>
      'Jede Taste, auf die das Fenster reagiert, auf einer Seite.';

  @override
  String get desktopDiscoverShow => 'Anzeigen';

  @override
  String get desktopDiscoverStatsLine =>
      'Die Bibliothek in Zahlen: nach Seite, Kanal und Monat.';

  @override
  String get desktopDiscoverSubtitles =>
      'Das Transkript über dem Bild, das gesprochene Wort hervorgehoben.';

  @override
  String get desktopDiscoverTheater =>
      'Ein größeres Bild, das den Platz der Seitenleiste einnimmt.';

  @override
  String get desktopDiscoverTry => 'Ausprobieren';

  @override
  String get desktopDiscoverWatching => 'Ansehen und anhören';

  @override
  String get desktopDownloadFolder => 'Download-Ordner';

  @override
  String get desktopDownloadFolderHint =>
      'Downloads werden hier als normale Dateien gespeichert, die du wie jede andere öffnen, verschieben oder sichern kannst.';

  @override
  String get desktopDownloads => 'Downloads';

  @override
  String get desktopDownloadsEmpty =>
      'Gerade wird nichts heruntergeladen. Füge einen Link hinzu, um zu starten.';

  @override
  String get desktopDownloadsRunning => 'Läuft';

  @override
  String get desktopDragToReorder => 'Ziehen zum Sortieren';

  @override
  String get desktopDropLinks => 'Zum Hinzufügen ablegen';

  @override
  String get desktopEmptyLibraryMessage =>
      'Füge einen Link hinzu, und der Clip erscheint hier, sobald er heruntergeladen ist.';

  @override
  String get desktopEngine => 'Engine';

  @override
  String get desktopEngineDenoHint =>
      'Beantwortet die Prüfung von YouTube, damit jede angebotene Qualität heruntergeladen werden kann';

  @override
  String get desktopEngineFetch => 'Abrufen';

  @override
  String get desktopEngineFetchCorrupt =>
      'Die angekommene Datei war nicht die veröffentlichte und wurde daher nicht verwendet.';

  @override
  String get desktopEngineFetchFailed =>
      'Konnte nicht abgerufen werden. Prüfe die Verbindung und versuch es erneut.';

  @override
  String get desktopEngineFetchInUse =>
      'Wird von einem Download verwendet. Versuch es erneut, wenn er fertig ist.';

  @override
  String desktopEngineFetching(int percent) {
    return 'Wird abgerufen · $percent %';
  }

  @override
  String get desktopEngineFfmpegHint =>
      'Fügt Bild und Ton zusammen und konvertiert Audio';

  @override
  String get desktopEngineIpv4 => 'Nur IPv4 verwenden';

  @override
  String get desktopEngineIpv4Hint =>
      'Viel schneller, wo IPv6 nicht richtig funktioniert, wie in vielen Heimnetzen. Schalte es nur aus, wenn dein Netz ausschließlich IPv6 hat.';

  @override
  String get desktopEngineMissing =>
      'yt-dlp ist nicht auf diesem Computer. Installiere VidHoist neu oder rufe es hier ab.';

  @override
  String get desktopEngineOnFirstUse =>
      'Wird beim ersten Download abgerufen, der es braucht';

  @override
  String get desktopEngineUpToDate => 'yt-dlp ist aktuell';

  @override
  String get desktopEngineUpdate => 'yt-dlp aktualisieren';

  @override
  String get desktopEngineUpdateFailed =>
      'Das Update hat nicht geklappt. Versuch es später erneut.';

  @override
  String get desktopEngineUpdateHint =>
      'Seiten ändern sich oft; ein altes yt-dlp funktioniert nach wenigen Monaten nicht mehr.';

  @override
  String desktopEngineUpdated(String version) {
    return 'yt-dlp ist jetzt $version';
  }

  @override
  String get desktopEngineUpdating => 'Wird aktualisiert…';

  @override
  String desktopEngineVersion(String version) {
    return 'Version $version';
  }

  @override
  String get desktopEngineYtDlpHint => 'Liest den Link und lädt ihn herunter';

  @override
  String get desktopExport => 'Exportieren';

  @override
  String get desktopExportForPhone => 'Für das Handy exportieren';

  @override
  String get desktopExportForPhoneHint =>
      'Speichert die Tags, Listen und Fortsetzungspunkte dieses Computers sowie seine Transkripte als zwei Dateien, die das Handy wiederherstellt. Das Wiederherstellen auf dem Handy ersetzt dessen eigene Tags und Listen.';

  @override
  String get desktopExportMarkdown => 'Text (Markdown)';

  @override
  String get desktopExportPdf => 'Dokument (PDF)';

  @override
  String get desktopExportPhone => 'Für das Handy (VidHoist-Import)';

  @override
  String get desktopExportSrt => 'Untertitel (SRT)';

  @override
  String desktopExported(String name) {
    return '$name gespeichert';
  }

  @override
  String desktopFileReadyToPaste(String name, String size) {
    return 'Bereit zum Einfügen: $name · $size';
  }

  @override
  String get desktopFirstLinkKeys => 'irgendwo im Fenster tut dasselbe';

  @override
  String get desktopFirstLinkNote =>
      'Von YouTube oder einer anderen Seite. Der Clip erscheint hier, sobald sein Download beginnt.';

  @override
  String get desktopFirstLinkPaste => 'Einfügen';

  @override
  String get desktopFirstLinkTitle => 'Füge deinen ersten Link ein';

  @override
  String get desktopFolderUnavailable => 'Kein Ordner verfügbar';

  @override
  String get desktopFolders => 'Ordner';

  @override
  String get desktopForward => 'Vorwärts';

  @override
  String get desktopGlobalShortcut => 'Wiedergabe und Pause aus jeder App';

  @override
  String desktopGlobalShortcutHint(String keys) {
    return '$keys spielt ab und pausiert, auch wenn das Fenster hinter anderen Apps liegt.';
  }

  @override
  String desktopGlobalShortcutTaken(String keys) {
    return 'Eine andere App nutzt $keys bereits.';
  }

  @override
  String get desktopHidePanel => 'Seitenleiste ausblenden';

  @override
  String get desktopHintShortcuts =>
      'Drück ? für die Tastenkürzel. Leertaste spielt ab und pausiert; die Pfeiltasten spulen.';

  @override
  String get desktopHintShortcutsAction => 'Tastenkürzel';

  @override
  String get desktopHintTrayBody =>
      'Die Wiedergabe läuft über das Symbol neben der Uhr weiter. Zum Beenden klick mit rechts auf das Symbol.';

  @override
  String get desktopHintTrayTitle => 'VidHoist läuft noch';

  @override
  String get desktopHints => 'Tipps anzeigen';

  @override
  String get desktopHintsAgain => 'Wieder anzeigen';

  @override
  String get desktopHintsHint =>
      'Zwei kurze Tipps, jeder nur einmal: die Tastenkürzel beim ersten Clip, das Symbol neben der Uhr beim ersten Schließen.';

  @override
  String get desktopImportFromPhone => 'Backup oder Transkripte importieren…';

  @override
  String get desktopImportHint =>
      'Eine Backup- oder Transkript-Datei von VidHoist, hier ausgewählt oder auf das Fenster gezogen. Die eines Handys wird zum Vorhandenen hinzugefügt; ein Backup dieses Computers wird nach Rückfrage komplett wiederhergestellt.';

  @override
  String desktopImportedBackup(int tagged, int lists, int positions) {
    return 'Vom Handy hinzugefügt. Tags: $tagged · Listen: $lists · Fortsetzungspunkte: $positions';
  }

  @override
  String get desktopImportedNothing =>
      'Nichts Neues: Dieser Computer hatte schon alles.';

  @override
  String desktopImportedTranscripts(int count) {
    return 'Transkripte hinzugefügt: $count';
  }

  @override
  String desktopInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count in deiner Bibliothek',
      one: '1 in deiner Bibliothek',
    );
    return '$_temp0';
  }

  @override
  String get desktopKeepAwake => 'Computer beim Herunterladen wach halten';

  @override
  String get desktopKeepAwakeHint =>
      'Damit ein vom Handy gesendeter Link oder eine lange Playlist fertig wird, statt anzuhalten, wenn Windows in den Ruhezustand geht. Der Bildschirm schaltet sich trotzdem wie gewohnt aus.';

  @override
  String get desktopKeyAddLink => 'Kopierten Link hinzufügen';

  @override
  String get desktopKeyFavorite => 'Zu Favoriten hinzufügen oder entfernen';

  @override
  String get desktopKeyFullScreen => 'Vollbild; bei Ton der Hörraum';

  @override
  String get desktopKeyMenu => 'Das Menü des Clips';

  @override
  String get desktopKeyMini => 'Kleines Fenster über den anderen, und zurück';

  @override
  String get desktopKeyPlayPause => 'Abspielen oder pausieren';

  @override
  String get desktopKeyRepeat => 'Wiederholen ändern';

  @override
  String get desktopKeySearch => 'Titel und Gesagtes durchsuchen';

  @override
  String get desktopKeySeek => '10 Sekunden zurück oder vor';

  @override
  String get desktopKeyShortcuts => 'Diese Liste';

  @override
  String get desktopKeyVolume =>
      'Lauter oder leiser; bei Shorts das vorherige oder nächste';

  @override
  String get desktopKeyZoomIn => 'Größere Oberfläche';

  @override
  String get desktopKeyZoomOut => 'Kleinere Oberfläche';

  @override
  String get desktopKeyZoomReset => 'Oberfläche in normaler Größe';

  @override
  String get desktopLanguageSystemHint => 'Folgt der Sprache von Windows.';

  @override
  String desktopLastArrival(String when) {
    return 'Zuletzt angekommen $when';
  }

  @override
  String get desktopLess => 'Weniger';

  @override
  String desktopLibraryDownloading(int count) {
    return '$count im Download';
  }

  @override
  String get desktopLibraryLoading => 'Bibliothek wird geladen…';

  @override
  String get desktopLinkCopied => 'Link kopiert';

  @override
  String get desktopLinkDuplicate => 'Steht schon oben';

  @override
  String get desktopLinkInLibrary => 'Schon in deiner Bibliothek';

  @override
  String get desktopLinkPlaylist => 'Eine Playlist: Wähle ihre Clips aus';

  @override
  String get desktopLinkReady => 'Bereit';

  @override
  String get desktopLinkUnsupported => 'Eine Seite, die die App nicht kennt';

  @override
  String desktopLinksDropped(int count, int limit) {
    return 'Nur die ersten $limit Links werden übernommen; $count weitere wurden ausgelassen.';
  }

  @override
  String desktopLinksFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Links',
      one: '1 Link',
    );
    return '$_temp0';
  }

  @override
  String get desktopListeningClose => 'Hörraum schließen';

  @override
  String get desktopListeningRoom => 'Hörraum';

  @override
  String get desktopLogsCopied => 'Protokoll kopiert, ohne Links oder Adressen';

  @override
  String get desktopLogsCopy => 'Kopieren';

  @override
  String get desktopLogsSave => 'In Datei speichern';

  @override
  String get desktopMiniRestore => 'Zurück zum vollen Fenster';

  @override
  String get desktopMiniWindow => 'Kleines Fenster';

  @override
  String get desktopMore => 'Mehr';

  @override
  String get desktopNarrowSidebar => 'Seitenleiste einklappen';

  @override
  String get desktopNoChannelNames =>
      'Die Clips in deiner Bibliothek nennen ihren Kanal nicht, daher lassen sich die Clips dieses Kanals nicht herausfiltern. Folge ihm mit einem eigenen Ordner, dann erscheint hier alles, was dort ankommt.';

  @override
  String get desktopNoFavoritesMessage =>
      'Markiere einen Clip als Favorit, dann wartet er hier auf dich.';

  @override
  String get desktopNoFavoritesTitle => 'Noch keine Favoriten';

  @override
  String get desktopNoMatchMessage =>
      'Entferne einen Filter, um mehr zu sehen.';

  @override
  String get desktopNoMatchTitle => 'Nichts passt zu diesen Filtern';

  @override
  String get desktopNoTags =>
      'Noch keine Tags. Gib einem Clip auf seiner Seite einen Tag, dann erscheint er hier.';

  @override
  String get desktopNoTranscriptMessage =>
      'Es erscheint hier, sobald die Untertitel des Clips mit ihm heruntergeladen sind.';

  @override
  String get desktopNoTranscriptTitle => 'Kein Transkript für diesen Clip';

  @override
  String get desktopNotABackup =>
      'Diese Datei ist kein VidHoist-Backup und keine Transkript-Datei.';

  @override
  String desktopNotWatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nicht angesehen',
      one: '1 nicht angesehen',
    );
    return '$_temp0';
  }

  @override
  String get desktopNothingPlaying => 'Keine Wiedergabe';

  @override
  String get desktopNothingPlayingHint =>
      'Spiel einen Clip ab, dann erscheinen hier sein Transkript, was als Nächstes kommt, und seine Details.';

  @override
  String get desktopNotifyArrivalsHint =>
      'Eine Windows-Mitteilung, wenn neue Clips der Kanäle, denen du folgst, heruntergeladen sind.';

  @override
  String get desktopOfferCopiedLinks => 'Kopierte Links anbieten';

  @override
  String get desktopOfferCopiedLinksHint =>
      'Wenn du in einer anderen App einen Videolink kopierst, bietet eine Benachrichtigung an, ihn hinzuzufügen. Nur Links werden angesehen, und keiner wird gespeichert.';

  @override
  String get desktopOpenBackup => 'Backups öffnen';

  @override
  String get desktopOpenChannels => 'Kanäle öffnen';

  @override
  String get desktopOpenInExplorer => 'Im Explorer öffnen';

  @override
  String get desktopOpenWith => 'In anderem Player öffnen…';

  @override
  String get desktopPaletteClose => 'zum Schließen';

  @override
  String get desktopPaletteCommands => 'Befehle';

  @override
  String get desktopPaletteHint =>
      'Titel und Gesagtes durchsuchen, oder > für Befehle eingeben';

  @override
  String desktopPaletteList(String name) {
    return 'Liste: $name';
  }

  @override
  String get desktopPaletteMove => 'zum Bewegen';

  @override
  String get desktopPaletteOpen => 'zum Öffnen';

  @override
  String get desktopPaletteRecent => 'Zuletzt abgespielt';

  @override
  String get desktopPaletteSaid => 'In Clips gesagt';

  @override
  String get desktopPaletteSave => 'Diese Suche speichern';

  @override
  String get desktopPaletteSaved => 'Gespeicherte Suchen';

  @override
  String desktopPaletteSettings(String section) {
    return 'Einstellungen: $section';
  }

  @override
  String get desktopPaletteTitles => 'Titel';

  @override
  String get desktopPinned => 'Angeheftet';

  @override
  String get desktopPlayNext => 'Als Nächstes abspielen';

  @override
  String get desktopPlaysNext => 'Kommt als Nächstes, nach diesem';

  @override
  String get desktopQueueEnd => 'Danach kommt nichts mehr';

  @override
  String desktopQuote(String text, String title, String time, String link) {
    return '„$text“\n— $title, $time\n$link';
  }

  @override
  String get desktopQuoteCopied => 'Mit Zeit und Link kopiert';

  @override
  String get desktopReadingBack => 'Zurück zum Clip';

  @override
  String get desktopReadingCloseFind => 'Suche schließen';

  @override
  String get desktopReadingFind => 'Im Text suchen';

  @override
  String desktopReadingFound(int at, int count) {
    return '$at von $count';
  }

  @override
  String get desktopReadingHint =>
      'Klick einen Satz an, um ab dort zu hören · Ctrl+F sucht ein Wort · markieren, um mit Zeit zu kopieren';

  @override
  String get desktopReadingNextMatch => 'Nächster Treffer';

  @override
  String get desktopReadingPreviousMatch => 'Vorheriger Treffer';

  @override
  String get desktopReadingRoom => 'Leseraum';

  @override
  String get desktopRecoverLibrary => 'Clips, die schon im Ordner sind';

  @override
  String get desktopRecoverLibraryAction => 'Im Ordner suchen';

  @override
  String get desktopRecoverLibraryHint =>
      'Nach einer Neuinstallation: Holt die Clips in die Bibliothek zurück, die im Download-Ordner liegen, aber nicht mehr aufgeführt sind. Die Dateien bleiben unberührt.';

  @override
  String desktopRecovered(int count) {
    return 'Zurück in der Bibliothek: $count';
  }

  @override
  String get desktopRecoveredNothing =>
      'Nichts hinzuzufügen: Jeder Clip im Ordner ist in der Bibliothek.';

  @override
  String desktopRecoveredSome(int count, int left) {
    return 'Zurück in der Bibliothek: $count. Ausgelassen, Link unbekannt: $left';
  }

  @override
  String get desktopRemoveFromList => 'Aus der Liste entfernen';

  @override
  String get desktopRestore => 'Wiederherstellen';

  @override
  String get desktopRestoreBody =>
      'Bibliothek, gefolgte Kanäle, Tags, Listen und Einstellungen dieses Computers werden durch den Inhalt des Backups ersetzt. Die heruntergeladenen Dateien bleiben unberührt.';

  @override
  String desktopRestoreOfferBody(String when) {
    return 'Downloads\\VidHoist\\Backups enthält ein Backup dieses Computers: Bibliothek, gefolgte Kanäle, Playlists, Tags, Einstellungen und gespeicherte Transkripte. Das neueste: $when. Deine heruntergeladenen Dateien bleiben so oder so unberührt.';
  }

  @override
  String get desktopRestoreOfferTitle => 'Dein Backup wiederherstellen?';

  @override
  String get desktopRestoreTitle => 'Dieses Backup wiederherstellen?';

  @override
  String get desktopRestored => 'Backup wiederhergestellt';

  @override
  String get desktopRevealAfterDownload => 'Danach im Explorer zeigen';

  @override
  String get desktopRevealAfterDownloadHint =>
      'Wenn eine auf diesen Computer heruntergeladene Datei fertig ist, öffnet sich ihr Ordner mit der Datei markiert.';

  @override
  String desktopSavedIn(String folder) {
    return 'Gespeichert in $folder';
  }

  @override
  String desktopSavedSearchDelete(String name) {
    return 'Die gespeicherte Suche „$name“ löschen? In der Bibliothek ändert sich nichts.';
  }

  @override
  String get desktopSavedSearchName => 'Name der Suche';

  @override
  String get desktopSearch => 'Suchen';

  @override
  String get desktopSearchHint => 'Titel und Gesagtes durchsuchen…';

  @override
  String get desktopSearchSaved => 'In der Seitenleiste gespeichert';

  @override
  String get desktopSeekBar => 'Position im Clip';

  @override
  String desktopSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ausgewählt',
      one: '1 ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get desktopSetupChooseFile => 'Datei auswählen…';

  @override
  String get desktopShortcutsApp => 'App';

  @override
  String get desktopShortcutsClip => 'Bei einem ausgewählten Clip';

  @override
  String get desktopShortcutsPlayback => 'Wiedergabe';

  @override
  String get desktopShortcutsTitle => 'Tastenkürzel';

  @override
  String get desktopShortcutsWindow => 'Fenster';

  @override
  String get desktopShortsHint =>
      '↑ ↓ oder das Mausrad für das nächste Short · Doppelklick für Favorit';

  @override
  String get desktopShowInFolder => 'Im Ordner zeigen';

  @override
  String get desktopShowPanel => 'Seitenleiste einblenden';

  @override
  String get desktopStartFresh => 'Neu beginnen';

  @override
  String get desktopStartWithWindows => 'Mit Windows starten';

  @override
  String get desktopStartWithWindowsHint =>
      'Öffnet sich bei der Anmeldung: im Infobereich, wenn die Wiedergabe dort weiterläuft, sonst minimiert.';

  @override
  String get desktopStartWithWindowsRefused =>
      'Windows hat den Start der App mit Windows nicht erlaubt.';

  @override
  String get desktopStats => 'Bibliotheksstatistik';

  @override
  String get desktopStatsByChannel => 'Nach Kanal';

  @override
  String get desktopStatsByMonth => 'Nach Monat des Hinzufügens';

  @override
  String get desktopStatsBySite => 'Nach Seite';

  @override
  String get desktopStatsClips => 'Clips';

  @override
  String get desktopStatsHint =>
      'Was die Bibliothek enthält und was vielleicht einen Blick wert ist. Von hier wird nichts gelöscht.';

  @override
  String desktopStatsHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stunden',
      one: '1 Stunde',
      zero: 'Unter einer Stunde',
    );
    return '$_temp0';
  }

  @override
  String get desktopStatsLargest => 'Die größten:';

  @override
  String get desktopStatsLength => 'Gesamtdauer';

  @override
  String get desktopStatsLink => 'Statistik';

  @override
  String get desktopStatsNeverPlayed => 'Hier nie abgespielt';

  @override
  String get desktopStatsNewest => 'Die neuesten:';

  @override
  String get desktopStatsOtherChannels => 'Andere Kanäle';

  @override
  String get desktopStatsRoom => 'Belegter Platz';

  @override
  String get desktopStatsUnnamed => 'Kein Kanal angegeben';

  @override
  String get desktopStatsWithText => 'Mit Transkript';

  @override
  String get desktopStatsWithoutText => 'Ohne Transkript';

  @override
  String get desktopStatsWorthALook => 'Einen Blick wert';

  @override
  String get desktopSubtitleOptions => 'Untertitel-Optionen';

  @override
  String get desktopTheater => 'Kino';

  @override
  String get desktopTranscriptFirst => 'Hol zuerst sein Transkript';

  @override
  String get desktopTranscriptHint =>
      'Folgt der Wiedergabe · klick eine Zeile an, um hinzuspringen';

  @override
  String get desktopTranscriptHintPage =>
      'Transkript dieses Clips · klick eine Zeile an, um ab dort abzuspielen';

  @override
  String get desktopTranscriptsDeleteBody =>
      'Sie werden von diesem Computer und aus seinem Backup entfernt. Nur eine Datei, die du exportiert hast, kann sie zurückbringen.';

  @override
  String get desktopTranscriptsHelp =>
      'VidHoist behält das Gesagte jedes YouTube-Clips, den du hinzufügst, damit eine Suche (Ctrl+K) auch findet, was in deinen Clips gesagt wurde, nicht nur ihre Titel. Sie bleiben auf diesem Computer.';

  @override
  String get desktopTranscriptsMove => 'Zu oder von einem Handy';

  @override
  String get desktopTranscriptsMoveHint =>
      'Transkripte reisen mit dem Backup: „Für das Handy exportieren“ nimmt sie mit, und „Importieren“ dort bringt sie hinein und ergänzt, was hier fehlt.';

  @override
  String get desktopTrayOnClose =>
      'Beim Schließen des Fensters im Infobereich weiterspielen';

  @override
  String get desktopTrayOnCloseHint =>
      'Das Schließen des Fensters lässt den Ton weiterlaufen; beende über das Symbol neben der Uhr.';

  @override
  String get desktopTrayOpen => 'VidHoist öffnen';

  @override
  String get desktopTrayQuit => 'Beenden';

  @override
  String get desktopUiSize => 'Größe der Oberfläche';

  @override
  String desktopUiSizeHint(String bigger, String smaller, String reset) {
    return '$bigger und $smaller ändern sie von überall, und $reset stellt 100 % wieder her.';
  }

  @override
  String get desktopUiSizeTooLarge => 'Zu groß für diesen Bildschirm';

  @override
  String get desktopUpdateInstall => 'Installieren und neu starten';

  @override
  String get desktopUpdateRestartHint =>
      'VidHoist schließt sich, installiert das Update und öffnet sich wieder. Deine Einstellungen und deine Bibliothek bleiben, wie sie sind.';

  @override
  String get desktopViewCompact => 'Kompakt';

  @override
  String get desktopViewTable => 'Tabelle';

  @override
  String get desktopVolume => 'Lautstärke';

  @override
  String desktopVolumeLevel(int percent) {
    return 'Lautstärke $percent %';
  }

  @override
  String get desktopWelcomeFetchNow => 'Jetzt abrufen';

  @override
  String get desktopWelcomeHelpers =>
      'ffmpeg (fügt Bild und Ton zusammen) und Deno (von YouTube benötigt) werden beim ersten Download von selbst geladen, etwa 160 MB. Du kannst sie stattdessen jetzt abrufen.';

  @override
  String get desktopWelcomeMessage =>
      'Füge einen Link von YouTube oder einer anderen Seite ein, und VidHoist lädt ihn mit yt-dlp auf diesen Computer herunter.';

  @override
  String get desktopWelcomeStart => 'Starten';

  @override
  String get desktopWelcomeTitle => 'Willkommen bei VidHoist';

  @override
  String get desktopWhatsNewAllFeatures => 'Alles, was VidHoist kann';

  @override
  String get desktopWidenSidebar => 'Seitenleiste ausklappen';

  @override
  String get desktopWindowClose => 'Schließen';

  @override
  String get desktopWindowMaximize => 'Maximieren';

  @override
  String get desktopWindowMinimize => 'Minimieren';

  @override
  String get desktopWindowRestore => 'Verkleinern';

  @override
  String get desktopZoomChange => 'Ändern';

  @override
  String desktopZoomLowered(String percent) {
    return 'Die Oberfläche ist jetzt auf $percent, damit sie auf diesen Bildschirm passt.';
  }

  @override
  String get details => 'Details';

  @override
  String get developer => 'Entwickler';

  @override
  String get developerName => 'Yasir Sagheer';

  @override
  String get diagnosticLogs => 'Diagnoseprotokolle';

  @override
  String get diagnosticLogsSubtitle =>
      'App-Protokolle ansehen, durchsuchen und teilen (bereinigt)';

  @override
  String get disclaimer => 'Haftungsausschluss';

  @override
  String get disclaimerText =>
      'Diese App lädt Medien mit yt-dlp herunter. Der Entwickler ist nicht dafür verantwortlich, wie Nutzer dieses Werkzeug verwenden. Bitte beachte das Urheberrecht und die Nutzungsbedingungen der Seiten, von denen du herunterlädst.';

  @override
  String get dismiss => 'Schließen';

  @override
  String get done => 'Fertig';

  @override
  String get download => 'Herunterladen';

  @override
  String get downloadComplete => 'Download abgeschlossen';

  @override
  String get downloadCompleteTitle => 'Abgeschlossen';

  @override
  String get downloadDate => 'Download-Datum';

  @override
  String get downloadFailed => 'Download fehlgeschlagen';

  @override
  String get downloadFailedTitle => 'Download fehlgeschlagen';

  @override
  String get downloadNow => 'Herunterladen';

  @override
  String get downloadStarted => 'Download gestartet…';

  @override
  String downloadStartedQuality(Object quality) {
    return 'Download gestartet · $quality';
  }

  @override
  String get downloading => 'Wird heruntergeladen…';

  @override
  String get downloadingTitle => 'Wird heruntergeladen';

  @override
  String get downloadsAdvanced => 'Erweitert';

  @override
  String get editSubscription => 'Bearbeiten';

  @override
  String get embedSubtitles => 'Untertitel auch im Video';

  @override
  String get embedSubtitlesHelp =>
      'Damit andere Player sie anzeigen. Der Player von VidHoist zeigt sie in jedem Fall.';

  @override
  String get emptyFilteredMessage =>
      'Entferne oben einen Filter, um deine ganze Bibliothek zu sehen.';

  @override
  String get emptyFilteredTitle => 'Nichts passt zu diesen Filtern';

  @override
  String get emptyPlaylist => 'Leere Playlist';

  @override
  String get emptyPlaylistMessage => 'Füge Clips aus der Bibliothek hinzu';

  @override
  String engineDownloadingProgress(Object percent) {
    return 'Wird heruntergeladen · $percent %';
  }

  @override
  String get engineErrDiskFull => 'Nicht genug Speicherplatz für diese Datei';

  @override
  String engineErrFailed(Object reason) {
    return 'Download fehlgeschlagen: $reason';
  }

  @override
  String get engineErrFormat =>
      'Diese Qualität ist für dieses Video nicht verfügbar';

  @override
  String get engineErrGeoBlocked => 'In deinem Land nicht verfügbar';

  @override
  String get engineErrMissing =>
      'Die Download-Engine fehlt oder ist unvollständig. Repariere sie in den Einstellungen mit „Engine reparieren“';

  @override
  String get engineErrRateLimited =>
      'Die Seite begrenzt die Anfragen. Versuch es in einer Weile erneut';

  @override
  String get engineErrUnavailable =>
      'Dieses Video ist nicht verfügbar, privat oder entfernt';

  @override
  String get engineErrUnsupported => 'Dieser Link wird nicht unterstützt';

  @override
  String get enginePaused => 'Pausiert';

  @override
  String get enginePostprocessing => 'Datei wird fertiggestellt…';

  @override
  String get enginePreparing => 'Link wird gelesen…';

  @override
  String get engineRepair => 'Engine reparieren';

  @override
  String get engineRepairBusy =>
      'Warte, bis die Downloads fertig sind, dann reparieren';

  @override
  String get engineRepairHint =>
      'Wenn Downloads auf mehreren Seiten fehlschlagen, obwohl sie vorher liefen, und ein Update nicht geholfen hat: Löscht, was yt-dlp gespeichert hat, und legt eine saubere, aktuelle Kopie zurück. Deine Downloads und Einstellungen bleiben, wie sie sind.';

  @override
  String get engineRepairPartly =>
      'Teilweise repariert: Der Rest braucht eine Verbindung. Versuch es erneut, sobald du online bist.';

  @override
  String engineRepaired(String version) {
    return 'Repariert: yt-dlp $version';
  }

  @override
  String get engineRepairing => 'Wird repariert…';

  @override
  String get engineResume => 'Fortsetzen';

  @override
  String get enterFullscreen => 'Vollbild';

  @override
  String errClipPastEnd(Object length) {
    return 'Der Teil beginnt nach dem Ende des Videos ($length)';
  }

  @override
  String get errClipPastEndUnknown =>
      'Der Teil beginnt nach dem Ende des Videos';

  @override
  String get errNetwork => 'Keine Verbindung zur Seite';

  @override
  String get errPlatformBlockedCookies =>
      'Die Seite verlangt eine Anmeldung. Wähle eine Cookie-Datei unter Einstellungen › Cookies';

  @override
  String errorGeneric(Object message) {
    return 'Fehler: $message';
  }

  @override
  String get every30Minutes => 'Alle 30 Minuten';

  @override
  String everyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Stunden',
      one: 'Jede Stunde',
    );
    return '$_temp0';
  }

  @override
  String get exitFullscreen => 'Vollbild beenden';

  @override
  String get exportShare => 'Exportieren & teilen';

  @override
  String get exportShareSubtitle =>
      'Eine datierte Kopie zum Senden oder Aufbewahren an anderer Stelle';

  @override
  String get externalPlayerShort => 'Anderer Player';

  @override
  String get failed => 'Fehlgeschlagen';

  @override
  String get failedToLoadPlaylist => 'Playlist konnte nicht geladen werden';

  @override
  String get fastStreams => 'Schnellere segmentierte Streams';

  @override
  String fastStreamsHelp(int count) {
    return 'Lädt $count Teile gleichzeitig von Seiten, die ein Video in Teile zerlegen, etwa X. Manche Seiten bremsen viele gleichzeitige Anfragen.';
  }

  @override
  String get favorites => 'Favoriten';

  @override
  String get file => 'Datei';

  @override
  String get fileSize => 'Dateigröße';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterAudio => 'Audio';

  @override
  String get filterVideo => 'Video';

  @override
  String get filtersOn => 'Filter aktiv';

  @override
  String get folder => 'Ordner';

  @override
  String get foldersHelp =>
      'Im Download-Ordner wird ein Ordner angelegt, und der Clip wird direkt darin gespeichert, wo der Explorer und jede andere App ihn sehen. Lass es bei „Kein Ordner“, dann landet der Clip oben im Download-Ordner.';

  @override
  String get follow => 'Folgen';

  @override
  String get followChannel => 'Einem Kanal folgen';

  @override
  String get format => 'Format';

  @override
  String framesPerSecond(int count) {
    return '$count fps';
  }

  @override
  String get helpAboutField => 'Über dieses Feld';

  @override
  String get inPlaylists => 'In Playlists';

  @override
  String get invalidUrl => 'Gib einen gültigen Link ein';

  @override
  String get itemOptions => 'Optionen für das Element';

  @override
  String get itemUnavailable => 'Nicht mehr verfügbar';

  @override
  String get jumpToNewest => 'Zum Neuesten';

  @override
  String get justNow => 'gerade eben';

  @override
  String knownVideos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Videos bekannt',
      one: '1 Video bekannt',
      zero: 'Noch nichts bekannt',
    );
    return '$_temp0';
  }

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'System';

  @override
  String get languageSystemHint => 'Folgt der Sprache deines Handys';

  @override
  String lastBackup(String when) {
    return 'Letztes Backup $when';
  }

  @override
  String lastCheckedAt(String when) {
    return 'Zuletzt geprüft $when';
  }

  @override
  String get latestAdditions => 'Neu hinzugefügt';

  @override
  String get licensedUnder => 'Lizenziert unter GPL-3.0';

  @override
  String get licenses => 'Open-Source-Lizenzen';

  @override
  String get listSeparator => ', ';

  @override
  String get listenInBackground => 'Im Hintergrund hören';

  @override
  String get lockTouch => 'Touch sperren';

  @override
  String get loginDone => 'Fertig';

  @override
  String loginKept(String site) {
    return 'Bei $site angemeldet; Downloads nutzen diese Anmeldung';
  }

  @override
  String get loginNotYet =>
      'Noch keine Anmeldung gefunden. Schließ die Anmeldung ab und tippe dann auf Fertig';

  @override
  String get logsEmpty => 'Das Protokoll ist leer';

  @override
  String get logsSanitizedNote =>
      'Links, Adressen und Zugangsdaten werden vor dem Teilen entfernt';

  @override
  String get manageTags => 'Tags verwalten';

  @override
  String get mediaAccessBlockedMessage =>
      'Android fragt nicht noch einmal. Schalte Fotos und Videos für diese App in den Systemeinstellungen ein und komm dann zurück.';

  @override
  String get mediaAccessGrant => 'Erlauben';

  @override
  String get mediaAccessMessage =>
      'Deine Downloads liegen im Download-Ordner des Handys, und Android braucht deine Erlaubnis, bevor die App sie auflisten kann.';

  @override
  String get mediaAccessOpenSettings => 'Einstellungen öffnen';

  @override
  String get mediaAccessTitle => 'Zugriff auf deine Medien erlauben';

  @override
  String get mobileChannelsEmptyBody =>
      'Folge einem Kanal, und jedes neue Video lädt sich von selbst herunter, solange VidHoist offen ist oder im Hintergrund läuft; was kam, während es geschlossen war, wird beim Öffnen heruntergeladen. Was schon auf dem Kanal ist, wird nicht heruntergeladen.';

  @override
  String get mobileChannelsHint =>
      'Neue Videos von Kanälen, denen du folgst, von selbst heruntergeladen';

  @override
  String get mobileEngineIpv4 => 'Über IPv4 verbinden';

  @override
  String get mobileEngineIpv4Help =>
      'Vermeidet langes Hängen in Netzen, deren IPv6-Route kaputt ist. Schalte es nur aus, wenn dein Netz ausschließlich IPv6 hat.';

  @override
  String mobileEngineLastUpdate(String when) {
    return 'Zuletzt aktualisiert $when';
  }

  @override
  String get mobileEngineNotReady => 'Wird vorbereitet…';

  @override
  String get mobileEngineUpToDate => 'yt-dlp ist aktuell';

  @override
  String get mobileEngineUpdate => 'yt-dlp aktualisieren';

  @override
  String get mobileEngineUpdateFailed =>
      'yt-dlp konnte nicht aktualisiert werden. Prüfe die Verbindung und versuch es erneut.';

  @override
  String get mobileEngineUpdateMissed => 'Update fehlgeschlagen';

  @override
  String get mobileEngineUpdated => 'Aktualisiert';

  @override
  String get mobileEngineUpdating => 'Wird aktualisiert…';

  @override
  String get mobileEngineVersionLabel => 'yt-dlp-Version';

  @override
  String get mobileEngineVersionUnknown =>
      'Die Version erscheint nach dem ersten Update';

  @override
  String get mobileSettingsEngine => 'Download-Engine';

  @override
  String get mobileSettingsGroupEngine => 'Engine';

  @override
  String get mobileSignInNeeded =>
      'Diese Seite möchte, dass du angemeldet bist. Melde dich unter Einstellungen › Konten an und versuch es dann erneut';

  @override
  String get mobileSubtitleOptions => 'Größe, Hintergrund und Transkript';

  @override
  String get mobileSubtitleStyleHelp =>
      'Auch im Player: Halte die CC-Taste gedrückt.';

  @override
  String get mobileSubtitles => 'Untertitel herunterladen';

  @override
  String get mobileSubtitlesHelp =>
      'Untertitel in den Sprachen unten, wenn das Video welche hat, daneben gespeichert und im Player angezeigt.';

  @override
  String get mobileSubtitlesSizeLarger => 'Größer';

  @override
  String get mobileTranscript => 'Transkript';

  @override
  String get mobileTranscriptHint =>
      'Tippe auf eine Zeile, um ab dort abzuspielen.';

  @override
  String get mobileTranscriptOpen => 'Transkript lesen';

  @override
  String get mobileWelcomeBody =>
      'Videos und Audio von den Seiten, die du nutzt, direkt auf diesem Handy gespeichert. Die Download-Engine wird vorbereitet; das passiert nur einmal.';

  @override
  String get mobileWelcomeFailed =>
      'Die Engine konnte nicht starten. Versuch es erneut; wenn es weiter fehlschlägt, installiere die App neu.';

  @override
  String get mobileWelcomeStart => 'Starten';

  @override
  String get mobileWelcomeTitle => 'Willkommen bei VidHoist';

  @override
  String get mobileWelcomeUnpacking => 'Download-Engine wird vorbereitet';

  @override
  String get mobileWelcomeUpdateFailed =>
      'Update gerade nicht möglich. VidHoist versucht es vor deinem ersten Download erneut.';

  @override
  String get mobileWelcomeUpdating =>
      'yt-dlp wird auf die neueste Version aktualisiert';

  @override
  String get modeAutoNext => 'Auto';

  @override
  String get modeRepeatAll => 'Alle wiederholen';

  @override
  String get modeRepeatOne => 'Eins wiederholen';

  @override
  String get modeStopAtEnd => 'Am Ende stoppen';

  @override
  String get navLibrary => 'Bibliothek';

  @override
  String get navMyDownloads => 'Meine Downloads';

  @override
  String get navPlaylists => 'Playlists';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get needsAttention => 'Braucht deine Aufmerksamkeit';

  @override
  String get neverChecked => 'Noch nicht geprüft';

  @override
  String get newFolder => 'Neuer Ordner…';

  @override
  String get newFolderHint => 'z. B. KI/Lektionen';

  @override
  String get newPlaylistAction => 'Neue Playlist';

  @override
  String get newTagHint => 'Neuer Tag';

  @override
  String newVideosBody(String channels) {
    return '$channels. Sie werden geladen, wenn du VidHoist öffnest.';
  }

  @override
  String newVideosNotice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count neue Videos',
      one: '1 neues Video',
    );
    return '$_temp0';
  }

  @override
  String get next => 'Weiter';

  @override
  String get noBackupsYet => 'Noch keine Backups';

  @override
  String get noDownloads => 'Keine Downloads';

  @override
  String get noDownloadsMessage =>
      'Heruntergeladene Clips erscheinen hier.\nTeile einen Link oder nutze den Button „Link hinzufügen“.';

  @override
  String get noExternalPlayer => 'Kein externer Player auf diesem Gerät';

  @override
  String get noFolder => 'Kein Ordner';

  @override
  String get noFolderHint => 'Oben in den Downloads';

  @override
  String get noLogsFound => 'Keine Protokolle gefunden';

  @override
  String get noPlayableSource => 'Dieses Element hat keine abspielbare Quelle';

  @override
  String get noPlaylistsMessage =>
      'Erstelle eine Playlist, um deine Clips zu ordnen';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get noResultsMessage => 'Keine Elemente passen zu deiner Suche.';

  @override
  String get noServerTitle => 'Die Download-Engine ist nicht bereit';

  @override
  String get noticeChannelNewVideos => 'Neue Videos';

  @override
  String get noticeChannelUpdates => 'Updates';

  @override
  String get noVideosFound => 'Deine Bibliothek ist leer';

  @override
  String get noWarranty =>
      'Bereitgestellt wie besehen, ohne jede Gewährleistung.';

  @override
  String get notAffiliated =>
      'Weder mit yt-dlp noch mit einer Seite verbunden und von ihnen nicht unterstützt.';

  @override
  String get nothingHereYet => 'Hier ist noch nichts';

  @override
  String get notificationClipGone =>
      'Dieser Clip ist nicht mehr auf dem Telefon.';

  @override
  String get nowPlaying => 'Wird abgespielt';

  @override
  String get nowPlayingCollapse => 'Player-Bereich einklappen';

  @override
  String get nowPlayingExpand => 'Player-Bereich anzeigen';

  @override
  String get ok => 'OK';

  @override
  String get onlyNewVideos =>
      'Nur was ab jetzt erscheint, wird heruntergeladen. Die Videos, die schon auf dem Kanal sind, bleiben, wo sie sind.';

  @override
  String get openChannel => 'Kanal öffnen';

  @override
  String get openInExternalPlayer => 'In anderem Player öffnen';

  @override
  String get openOriginalLink => 'Originallink öffnen';

  @override
  String get ownFolder => 'In eigenem Ordner speichern';

  @override
  String get ownFolderNote =>
      'Ein Ordner im Download-Ordner, den auch der Explorer und andere Apps sehen. Nur was ab jetzt ankommt, landet dort; was schon heruntergeladen ist, bleibt, wo es ist.';

  @override
  String get pasteUrlHint => 'Link hier einfügen…';

  @override
  String get pause => 'Pause';

  @override
  String get pauseSubscription => 'Pausieren';

  @override
  String get pcAddressLabel => 'Adresse';

  @override
  String get pcBadAddress =>
      'Gib die Adresse so ein, wie der Computer sie anzeigt, zum Beispiel 192.168.1.24.';

  @override
  String get pcBadQr => 'Das ist kein VidHoist-QR-Code zum Koppeln.';

  @override
  String get pcCertificate => 'Zertifikat des Computers';

  @override
  String get pcCodeLabel => 'Code';

  @override
  String get pcConnected => 'Verbunden';

  @override
  String get pcCopied =>
      'In die Bibliothek des Handys kopiert, mit Untertiteln.';

  @override
  String get pcCopyFailed =>
      'Das Kopieren wurde nicht fertig: Der Computer ist vielleicht aus oder nicht erreichbar. Nichts wurde behalten.';

  @override
  String get pcCopyStarting => 'Wird kopiert…';

  @override
  String get pcCopyStop => 'Kopieren stoppen';

  @override
  String get pcCopyToPhone => 'Aufs Handy kopieren';

  @override
  String pcCopying(int percent) {
    return 'Wird kopiert $percent %';
  }

  @override
  String get pcDelete => 'Vom Computer löschen';

  @override
  String pcDeleteBody(String title) {
    return '„$title“ kommt in den Papierkorb des Computers, wo es wiederhergestellt werden kann.';
  }

  @override
  String get pcDeleteFailed =>
      'Der Computer konnte es nicht löschen. Vielleicht ist es dort geöffnet.';

  @override
  String get pcDeleteMissing => 'Dieser Clip ist nicht mehr auf dem Computer.';

  @override
  String get pcDeleteNoBin =>
      'Nicht gelöscht: Sein Laufwerk auf dem Computer hat keinen Papierkorb.';

  @override
  String get pcDeleteNotAllowed =>
      'Der Computer erlaubt dem Handy kein Löschen. Schalte es dort unter Einstellungen › Handy ein.';

  @override
  String pcDeleteTitle(String name) {
    return 'Von $name löschen?';
  }

  @override
  String pcDeleted(String title) {
    return 'Im Papierkorb des Computers: $title';
  }

  @override
  String get pcDestPhone => 'Dieses Handy';

  @override
  String pcDoneOnPc(String title) {
    return 'Fertig auf dem Computer: $title';
  }

  @override
  String pcDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Downloads für den Computer',
      one: '1 Download für den Computer',
    );
    return '$_temp0';
  }

  @override
  String get pcDownloadsSheet => 'Downloads auf dem Computer';

  @override
  String get pcEmptyLibrary => 'Noch keine Downloads auf dem Computer.';

  @override
  String get pcErrBad =>
      'Der Computer hat auf eine Art geantwortet, die diese Version nicht versteht. Aktualisiere beide Apps.';

  @override
  String get pcErrClosed =>
      'Auf dem Computer wird kein Code angezeigt, oder er ist abgelaufen. Drück dort auf „Handy koppeln“.';

  @override
  String get pcErrDenied =>
      'Das Koppeln wurde auf dem Computer abgelehnt oder nicht rechtzeitig beantwortet.';

  @override
  String get pcErrRefused => 'Der Computer hat diesen Link nicht angenommen.';

  @override
  String get pcErrUnauthorized =>
      'Der Computer kennt dieses Handy nicht mehr. Kopple es erneut.';

  @override
  String get pcErrUnreachable =>
      'Der Computer hat nicht geantwortet. Ist er an, in diesem Netz oder in deinem Tailscale, und ist „Vom Handy empfangen“ eingeschaltet?';

  @override
  String get pcErrWrongCertificate =>
      'Unter dieser Adresse hat etwas anderes als dein Computer geantwortet. Nichts wurde gesendet.';

  @override
  String get pcErrWrongCode => 'Falscher Code.';

  @override
  String get pcFindNone =>
      'Kein Computer gefunden. Öffne auf dem Computer zuerst Einstellungen › Handy › Handy koppeln, im selben WLAN.';

  @override
  String get pcFindOnNetwork => 'Im Netzwerk suchen';

  @override
  String get pcFirewallAllow => 'Erlauben';

  @override
  String get pcFirewallBlocked =>
      'Die Windows-Firewall blockiert VidHoist, daher erreicht das Handy es nicht. Erlaube es in Heimnetzen (privat).';

  @override
  String get pcFirewallMissing =>
      'Windows hat VidHoist noch nicht erlaubt, vom Handy zu empfangen. Erlaube es einmal, nur in Heimnetzen (privat).';

  @override
  String get pcFirewallPublic =>
      'Windows stuft dieses Netz als öffentlich ein und lässt dort nichts herein. Wenn es dein Heimnetz ist, mach es privat: Einstellungen › Netzwerk und Internet › WLAN › seine Eigenschaften.';

  @override
  String get pcFirewallRefused =>
      'Nichts geändert: Windows braucht die Erlaubnis eines Administrators.';

  @override
  String get pcFirewallTitle => 'Windows-Firewall';

  @override
  String pcFound(String name) {
    return '$name gefunden. Gib den Code ein, den er anzeigt.';
  }

  @override
  String pcFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gefunden',
      one: '1 gefunden',
    );
    return '$_temp0';
  }

  @override
  String pcLastContact(String time) {
    return 'Letzter Kontakt $time';
  }

  @override
  String get pcLibrary => 'Bibliothek auf dem Computer';

  @override
  String get pcLinkAddress => 'Adresse in diesem Netz';

  @override
  String get pcLinkAddressTailscale => 'Über Tailscale, von unterwegs';

  @override
  String get pcLinkAllow => 'Erlauben';

  @override
  String get pcLinkAllowDelete => 'Handy darf Clips löschen';

  @override
  String get pcLinkAllowDeleteHint =>
      'Ein vom Handy gelöschter Clip kommt in den Papierkorb dieses Computers, wo du ihn wiederherstellen kannst. Auf einem Laufwerk ohne Papierkorb wird er nicht gelöscht.';

  @override
  String get pcLinkCodeHint =>
      'Auf dem Handy: Einstellungen › Computer › QR-Code scannen. Oder gib dort diese Adresse und diesen Code ein. Es funktioniert einmal, zwei Minuten lang.';

  @override
  String pcLinkCodeLeft(int seconds) {
    return 'Noch $seconds s';
  }

  @override
  String get pcLinkCodeTitle => 'Kopplungscode';

  @override
  String get pcLinkDeny => 'Ablehnen';

  @override
  String get pcLinkDevices => 'Gekoppelte Handys';

  @override
  String pcLinkFailed(String error) {
    return 'Konnte nicht starten: $error';
  }

  @override
  String get pcLinkIntro =>
      'Sende Links von VidHoist auf deinem Handy an diesen Computer und sieh dort seine Downloads und Bibliothek. Funktioniert in deinem Heimnetz und von unterwegs über Tailscale.';

  @override
  String pcLinkLastSeen(String time) {
    return 'Zuletzt gemeldet $time';
  }

  @override
  String get pcLinkNoDevices => 'Noch kein Handy.';

  @override
  String get pcLinkOff => 'Aus';

  @override
  String pcLinkOtherAddresses(int count) {
    return 'Andere Adressen ($count)';
  }

  @override
  String get pcLinkOtherAddressesHint =>
      'Netzwerkadapter, die andere Programme hinzufügen, etwa VirtualBox oder WSL. Das Handy braucht sie selten.';

  @override
  String get pcLinkPairPhone => 'Handy koppeln';

  @override
  String pcLinkPairedAt(String time) {
    return 'Gekoppelt $time';
  }

  @override
  String pcLinkPhones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Handys',
      one: 'Ein Handy',
      zero: 'Kein Handy',
    );
    return '$_temp0';
  }

  @override
  String get pcLinkQrHint => 'Mit dem Handy scannen';

  @override
  String get pcLinkReceive => 'Vom Handy empfangen';

  @override
  String get pcLinkReceiveHint =>
      'Solange es aus ist, ist auf diesem Computer kein Port offen. Wenn Windows fragt, erlaube nur private Netzwerke.';

  @override
  String pcLinkRequest(String name) {
    return '$name möchte koppeln';
  }

  @override
  String get pcLinkRequestHint =>
      'Erlaube es nur, wenn das Handy dieselben vier Ziffern zeigt.';

  @override
  String get pcLinkRevoke => 'Entkoppeln';

  @override
  String get pcLinkSecurity =>
      'Das Handy spricht direkt mit diesem Computer, in deinem Netz oder über dein Tailscale. Es koppelt sich einmal, mit dem Code und deiner Zustimmung hier; danach zeigt es bei jeder Anfrage seinen eigenen Schlüssel vor, über eine Verbindung, die allein mit dem Zertifikat dieses Computers verschlüsselt ist. Alle anderen im Netz stehen vor einer verschlossenen Tür.';

  @override
  String get pcLinkStarting => 'Wird gestartet…';

  @override
  String get pcLinkTitle => 'Handy';

  @override
  String get pcListEmpty =>
      'Keiner der Clips dieser Liste ist noch auf dem Computer.';

  @override
  String get pcListen => 'Anhören';

  @override
  String get pcLists => 'Listen auf dem Computer';

  @override
  String get pcListsEmpty => 'Keine Liste auf dem Computer enthält Clips.';

  @override
  String get pcNow => 'Gerade auf dem Computer';

  @override
  String get pcOffline => 'Nicht verfügbar';

  @override
  String get pcOfflineMessage =>
      'Der Computer ist aus oder in einem anderen Netz. Unten steht, was er beim letzten Mal hatte.';

  @override
  String get pcOfflineRoute =>
      'Unterwegs? Wähle Tailscale unter Einstellungen › Computer.';

  @override
  String get pcOnPhone => 'Auf dem Handy';

  @override
  String get pcOrType => 'Oder gib Adresse und Code ein';

  @override
  String get pcOutboxRefused => 'Der Computer hat diesen Link nicht angenommen';

  @override
  String pcOutboxTitle(int count) {
    return 'Wartet auf Senden ($count)';
  }

  @override
  String get pcPairButton => 'Koppeln';

  @override
  String pcPairCheck(String check) {
    return 'Prüfe, ob der Computer $check anzeigt, und erlaube dann dort das Handy.';
  }

  @override
  String get pcPairIntro =>
      'Wenn VidHoist auf deinem Windows-Computer läuft, kann dieses Handy ihm Links senden und seine Downloads und Bibliothek anzeigen. Schalte auf dem Computer Einstellungen › Handy ein und drück „Handy koppeln“, dann scanne den QR-Code, den er anzeigt.';

  @override
  String pcPaired(String name) {
    return 'Gekoppelt mit $name';
  }

  @override
  String get pcPortLabel => 'Port';

  @override
  String pcQueued(String name) {
    return 'Geht an $name, sobald er wieder da ist.';
  }

  @override
  String pcQueuedMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Clips gehen an $name, sobald er wieder da ist.',
      one: '1 Clip geht an $name, sobald er wieder da ist.',
    );
    return '$_temp0';
  }

  @override
  String get pcRouteHint =>
      'Wähle Tailscale, wenn du unterwegs bist; es muss auf dem Handy und auf dem Computer laufen.';

  @override
  String get pcRouteHome => 'Heimnetz';

  @override
  String get pcRouteOther => 'Anderes Netz';

  @override
  String get pcRouteTailscale => 'Tailscale';

  @override
  String get pcRouteTitle => 'Verbinden über';

  @override
  String get pcRouteWaiting =>
      'Die anderen Routen des Computers erscheinen hier, sobald er antwortet.';

  @override
  String get pcScanButton => 'QR-Code scannen';

  @override
  String get pcScanFailed => 'Die Kamera ließ sich nicht öffnen.';

  @override
  String get pcScanPrompt =>
      'Richte die Kamera auf den QR-Code auf dem Bildschirm des Computers';

  @override
  String get pcSearchHint => 'Bibliothek des Computers durchsuchen';

  @override
  String get pcSendToPc => 'An den Computer senden';

  @override
  String pcSent(String name) {
    return 'An $name gesendet';
  }

  @override
  String pcSentMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Clips an $name gesendet',
      one: '1 Clip an $name gesendet',
    );
    return '$_temp0';
  }

  @override
  String get pcSettingsHint => 'Links an deinen Computer senden';

  @override
  String get pcTab => 'Computer';

  @override
  String pcVia(String route) {
    return 'Über $route';
  }

  @override
  String get pcWatch => 'Ansehen';

  @override
  String get pcWillSend =>
      'Nicht erreichbar: wird gesendet, sobald er zurück ist';

  @override
  String get pickAnotherFile => 'Aus einer anderen Datei…';

  @override
  String get pickAnotherFileSubtitle =>
      'Ein Backup von einem anderen Handy oder einer älteren Version';

  @override
  String get pictureInPicture => 'Bild im Bild';

  @override
  String get pictureInPictureHelp =>
      'Wenn du die App verlässt, während ein Clip läuft, bleibt er in einer Ecke des Bildschirms';

  @override
  String get pinPlaylist => 'Oben anheften';

  @override
  String get platform => 'Seite';

  @override
  String platformCount(Object name, int count) {
    return '$name · $count';
  }

  @override
  String get platformOther => 'Andere';

  @override
  String get play => 'Abspielen';

  @override
  String get playAll => 'Alle abspielen';

  @override
  String get playModeLabel => 'Modus';

  @override
  String get playbackSpeed => 'Wiedergabetempo';

  @override
  String get playerError => 'Diese Datei konnte nicht abgespielt werden';

  @override
  String get playingFromDevice => 'Wiedergabe von deinem Gerät';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistAddClips => 'Clips hinzufügen';

  @override
  String playlistAddClipsTo(String name) {
    return 'Zu „$name“ hinzufügen';
  }

  @override
  String playlistAddCount(int count) {
    return 'Hinzufügen ($count)';
  }

  @override
  String get playlistCreated => 'Playlist erstellt';

  @override
  String get playlistDeleted => 'Playlist gelöscht';

  @override
  String get playlistDetails => 'Playlist-Details';

  @override
  String get playlistEditHint =>
      'Halte einen Clip gedrückt, um ihn zu verschieben. Wisch ihn zur Seite, um ihn zu entfernen.';

  @override
  String get playlistName => 'Name der Playlist';

  @override
  String get playlistNameHint => 'Meine Playlist';

  @override
  String playlistOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get playlists => 'Playlists';

  @override
  String get previous => 'Zurück';

  @override
  String get quality => 'Qualität';

  @override
  String get quality1080 => 'Bis 1080p';

  @override
  String get quality360 => 'Bis 360p';

  @override
  String get quality480 => 'Bis 480p';

  @override
  String get quality720 => 'Bis 720p';

  @override
  String get qualityAudio => 'Audio';

  @override
  String get qualityBest => 'Beste';

  @override
  String get qualityHelper =>
      'Gilt für den Schnell-Download, für Downloads ganzer Playlists und für „Herunterladen“ in der Zwischenablage-Leiste, und sie ist die vorausgewählte Option im Fenster „Link hinzufügen“. Sie zählt also, ob der Schnell-Download an ist oder nicht.';

  @override
  String get qualityReading => 'Datei wird gelesen…';

  @override
  String get qualityUnavailable => 'Nicht verfügbar';

  @override
  String get qualityVideo => 'Video';

  @override
  String queueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Elemente',
      one: '1 Element',
      zero: 'Keine Elemente',
    );
    return '$_temp0';
  }

  @override
  String get queueLabel => 'Warteschlange';

  @override
  String queuePosition(int position) {
    return 'Nr. $position in der Reihe';
  }

  @override
  String get queued => 'In der Warteschlange';

  @override
  String get queuedSection => 'Wartend';

  @override
  String get quickDownload => 'Schnell-Download';

  @override
  String get quickDownloadHelp =>
      'Ein geteilter oder eingefügter Link wird sofort in der Standardqualität heruntergeladen, ohne Fenster. Hat eine Seite diese Qualität nicht, liefert sie ihre beste, und „Nur Audio“ funktioniert auf jeder Seite.';

  @override
  String get rateLimit => 'Tempolimit';

  @override
  String get rateLimitNone => 'Kein Limit';

  @override
  String rateLimitValue(int mb) {
    return '$mb MB/s';
  }

  @override
  String get reelsEndBack => 'Zurück zur Bibliothek';

  @override
  String get reelsEndContinue => 'Mit dem Rest der Liste weiter';

  @override
  String get reelsEndReplay => 'Von vorn abspielen';

  @override
  String get reelsEndTitle => 'Ende der Shorts';

  @override
  String get reelsSwipeHint => 'Wisch nach oben für das nächste Short';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get remove => 'Entfernen';

  @override
  String get removeFromFavorites => 'Aus Favoriten entfernen';

  @override
  String removeUnavailable(int count) {
    return '$count nicht verfügbare entfernen';
  }

  @override
  String get removedFromFavorites => 'Aus Favoriten entfernt';

  @override
  String get removedFromPlaylist => 'Aus der Playlist entfernt';

  @override
  String get rename => 'Umbenennen';

  @override
  String get renameTag => 'Tag umbenennen';

  @override
  String get reportBug => 'Fehler melden';

  @override
  String get restoreConfirm =>
      'Daten aus der Backup-Datei wiederherstellen? Das überschreibt die aktuellen Playlists, Tags und Einstellungen.';

  @override
  String get restoreData => 'Wiederherstellen';

  @override
  String get restoreFailed =>
      'Wiederherstellung fehlgeschlagen: Die Backup-Datei ist ungültig';

  @override
  String get restorePickBody =>
      'Dieses Handy hat VidHoist-Downloads, aber keine Einstellungen, wie nach einer Neuinstallation. Wenn du ein Backup aufbewahrt hast, wähle es aus: Die App legt sie unter Download/VidHoist/backups ab.';

  @override
  String get restorePickChoose => 'Backup auswählen';

  @override
  String get restorePickTitle => 'Einstellungen zurückholen?';

  @override
  String get restoreSettings => 'Alle Daten wiederherstellen';

  @override
  String get restoreSuccess => 'Daten erfolgreich wiederhergestellt';

  @override
  String get resumeSubscription => 'Fortsetzen';

  @override
  String get retry => 'Wiederholen';

  @override
  String get saveSettings => 'Einstellungen speichern';

  @override
  String get searchLogs => 'Protokolle durchsuchen…';

  @override
  String get searchVideos => 'Clips durchsuchen…';

  @override
  String get seekBackward10 => '10 Sekunden zurück';

  @override
  String get seekForward10 => '10 Sekunden vor';

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String selected(int count) {
    return '$count ausgewählt';
  }

  @override
  String selectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get settings => 'Einstellungen';

  @override
  String get settingsAccounts => 'Konten';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get settingsDownloads => 'Downloads';

  @override
  String get settingsGroupApp => 'App';

  @override
  String get settingsGroupData => 'Daten';

  @override
  String get settingsPlayback => 'Wiedergabe';

  @override
  String get settingsTranscripts => 'Transkripte & Untertitel';

  @override
  String settingsValueChannels(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kanäle',
      one: '1 Kanal',
      zero: 'Noch keine Kanäle',
    );
    return '$_temp0';
  }

  @override
  String get settingsValueCompatOff => 'Beste Kompatibilität: aus';

  @override
  String get settingsValueCompatOn => 'Beste Kompatibilität: an';

  @override
  String get settingsValueNotSet => 'Noch nicht eingerichtet';

  @override
  String get settingsValueQuick => 'schnell';

  @override
  String settingsValueSignedIn(String sites) {
    return 'Angemeldet: $sites';
  }

  @override
  String get settingsValueWifiOnly => 'Nur WLAN';

  @override
  String get share => 'Teilen';

  @override
  String get shareLogs => 'Protokolle teilen';

  @override
  String get shareOpening => 'Teilen-Menü wird geöffnet…';

  @override
  String get shareOpeningHint =>
      'Eine große Datei braucht ein paar Sekunden zur Übergabe.';

  @override
  String get shareSelected => 'Auswahl teilen';

  @override
  String get sharedLinksAdd => 'Hinzufügen';

  @override
  String get sharedLinksBody => 'Jeder wird auf dieses Handy heruntergeladen.';

  @override
  String sharedLinksCapped(int max) {
    return 'Nur die ersten $max Links wurden hinzugefügt.';
  }

  @override
  String sharedLinksTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Links hinzufügen?',
      one: '1 Link hinzufügen?',
    );
    return '$_temp0';
  }

  @override
  String get shortsFilter => 'Shorts';

  @override
  String get shuffle => 'Zufällig';

  @override
  String get signInRequired => 'Anmeldung erforderlich';

  @override
  String get size => 'Größe';

  @override
  String get smartPlaylists => 'Intelligente Playlists';

  @override
  String get sortAndPlatform => 'Sortierung und Seite';

  @override
  String get sortBy => 'Sortieren nach';

  @override
  String get sortLargest => 'Größte';

  @override
  String get sortNameAZ => 'Name A–Z';

  @override
  String get sortNameZA => 'Name Z–A';

  @override
  String get sortNewest => 'Neueste';

  @override
  String get sortOldest => 'Älteste';

  @override
  String get sortSmallest => 'Kleinste';

  @override
  String get sortedByLastPlayed => 'Nach zuletzt abgespielt';

  @override
  String get source => 'Quelle';

  @override
  String get sourceCode => 'Quellcode';

  @override
  String get starAskBody =>
      'Kostenlos und quelloffen, ohne Werbung und ohne Konto. Ein Stern auf GitHub hilft anderen, es zu finden.';

  @override
  String get starAskIdeas => 'Eine Idee vorschlagen oder ein Problem melden';

  @override
  String get starAskLater => 'Vielleicht später';

  @override
  String get starAskNever => 'Nicht mehr anzeigen';

  @override
  String get starAskStar => 'Auf GitHub einen Stern geben';

  @override
  String get starAskTitle => 'Gefällt dir VidHoist?';

  @override
  String get startDownload => 'Download starten';

  @override
  String get status => 'Status';

  @override
  String get storageCardMissing =>
      'Die Karte steckt nicht, daher gehen Downloads aufs Handy';

  @override
  String get storageLocation => 'Speichern auf';

  @override
  String get storageLocationHelp =>
      'Bereits heruntergeladene Clips bleiben, wo sie sind, und erscheinen weiter in der Bibliothek. Eine Speicherkarte braucht Android 11 oder neuer.';

  @override
  String get storageNoCard => 'Keine Speicherkarte in diesem Handy';

  @override
  String get storagePhone => 'Handyspeicher';

  @override
  String get streamingOnline => 'Wiedergabe über das Netz';

  @override
  String subscriptionAdded(String name) {
    return 'Du folgst jetzt $name';
  }

  @override
  String get subscriptionName => 'Name';

  @override
  String get subscriptionPaused => 'Pausiert';

  @override
  String get subscriptionQuality => 'Qualität für diesen Kanal';

  @override
  String get subscriptionQualityHelp =>
      'Die Qualität, in der neue Videos dieses Kanals heruntergeladen werden. Du kannst sie später ändern, indem du den Kanal bearbeitest; bereits heruntergeladene Videos behalten ihre.\n\n„Beste“ kann 4K im AV1-Format bedeuten, das ein älterer Computer womöglich ruckelnd abspielt: Wähle dann 1080p.';

  @override
  String get subscriptionQualityNote =>
      'Gilt für neue Videos; bereits heruntergeladene behalten ihre.';

  @override
  String get subscriptions => 'Kanäle';

  @override
  String get subscriptionsEmpty => 'Du folgst noch keinen Kanälen';

  @override
  String get subscriptionsEmptyBody =>
      'Folge einem Kanal, und jedes neue Video landet von selbst in deiner Bibliothek, solange VidHoist offen ist oder im Infobereich läuft. Was schon auf dem Kanal ist, wird nicht heruntergeladen.';

  @override
  String get subscriptionsSubtitle =>
      'Neue Videos von Kanälen, denen du folgst, von selbst heruntergeladen';

  @override
  String get subtitleLangs => 'Untertitelsprachen';

  @override
  String get subtitleLangsHelp =>
      'Werden abgerufen, wenn das Video welche hat. Mindestens eine bleibt ausgewählt.';

  @override
  String get subtitles => 'Untertitel';

  @override
  String get subtitlesBackground => 'Hintergrund';

  @override
  String get subtitlesBackgroundFaint => 'Hell';

  @override
  String get subtitlesBackgroundHelp =>
      'Was hinter den Wörtern liegt. Ohne Hintergrund behält jeder Buchstabe einen dunklen Rand, damit er auch auf hellem Bild lesbar bleibt.';

  @override
  String get subtitlesBackgroundNone => 'Keiner';

  @override
  String get subtitlesBackgroundSolid => 'Dunkel';

  @override
  String get subtitlesHide => 'Untertitel ausblenden';

  @override
  String get subtitlesLanguage => 'Untertitelsprache';

  @override
  String get subtitlesShow => 'Untertitel einblenden';

  @override
  String get subtitlesShowHelp =>
      'Über dem Video, bei Clips mit Transkript. Die CC-Taste im Player macht dasselbe.';

  @override
  String get subtitlesSize => 'Textgröße';

  @override
  String get subtitlesSizeLarge => 'Groß';

  @override
  String get subtitlesSizeMedium => 'Mittel';

  @override
  String get subtitlesSizeSmall => 'Klein';

  @override
  String tagLimitReached(int max) {
    return 'Du kannst bis zu $max Tags haben. Entferne einen unter „Tags verwalten“, um einen weiteren hinzuzufügen.';
  }

  @override
  String get tags => 'Tags';

  @override
  String get tagsOpenFiltered => 'Öffnet die Bibliothek gefiltert';

  @override
  String get theme => 'Design';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeSystem => 'System';

  @override
  String get titleFilter => 'Nur Titel herunterladen, die Folgendes enthalten';

  @override
  String get titleFilterHelp =>
      'Ein neues Video dieses Kanals wird nur heruntergeladen, wenn sein Titel enthält, was du hier schreibst.\n\n• Ein einfaches Wort genügt: Folge\n• Eines von mehreren Wörtern: Folge|Teil (das | bedeutet „oder“)\n• Groß- und Kleinschreibung egal: folge passt auch auf Folge.\n\nEin Video, das der Filter überspringt, gilt für immer als gesehen: Wer den Filter später entfernt, bekommt, was danach kommt, nicht das Übersprungene.';

  @override
  String get titleFilterHelper =>
      'Mehrere Wörter: trenne sie mit | . Leer lassen für alles.';

  @override
  String get titleFilterHint => 'z. B. Folge';

  @override
  String get titleLabel => 'Titel';

  @override
  String totalDuration(Object duration) {
    return 'Gesamt: $duration';
  }

  @override
  String get transcript => 'Transkript';

  @override
  String transcriptSaidMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count-mal gesagt',
      one: 'Noch einmal gesagt',
    );
    return '$_temp0';
  }

  @override
  String transcriptsClips(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Clips',
      one: '1 Clip',
      zero: 'Noch keine Clips',
    );
    return '$_temp0';
  }

  @override
  String get transcriptsDeleteAll => 'Alle löschen';

  @override
  String get transcriptsDeleteTitle => 'Alle Transkripte löschen?';

  @override
  String get transcriptsSaidInside => 'In Clips gesagt';

  @override
  String get transcriptsSearchHelp =>
      'Behält die Wörter jedes YouTube-Clips, den du hinzufügst, damit du das Gesagte durchsuchen kannst.';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get undo => 'Rückgängig';

  @override
  String get unfollow => 'Nicht mehr folgen';

  @override
  String unfollowConfirm(String name) {
    return '$name nicht mehr folgen?';
  }

  @override
  String get unfollowConfirmBody =>
      'VidHoist vergisst, welche Videos es auf diesem Kanal schon gesehen hat. Wenn du ihm später wieder folgst, gilt alles, was dann darauf ist, als gesehen, und Verpasstes wird nicht nachgeholt. Pausieren behält dieses Gedächtnis.';

  @override
  String get unlockTouch => 'Entsperren';

  @override
  String get unpinPlaylist => 'Lösen';

  @override
  String get updateNoticeBody => 'Öffne VidHoist, um es zu installieren.';

  @override
  String get upNext => 'Als Nächstes';

  @override
  String upNextIn(String name) {
    return 'Als Nächstes in „$name“';
  }

  @override
  String get updateAllowInstallBody =>
      'Android braucht deine Erlaubnis, bevor die App ihre eigenen Updates installieren kann. Erteile sie einmal in den Systemeinstellungen und tippe dann noch einmal auf Installieren.';

  @override
  String get updateAllowInstallTitle => 'Installieren von Updates erlauben';

  @override
  String get updateAvailable => 'Update verfügbar';

  @override
  String get updateCheckFailed => 'Suche nach Updates fehlgeschlagen';

  @override
  String get updateChecking => 'Wird geprüft…';

  @override
  String get updateDownloadFailed =>
      'Das Update konnte nicht heruntergeladen werden';

  @override
  String updateDownloadedMb(String done, String total) {
    return '$done von $total MB';
  }

  @override
  String get updateDownloading => 'Update wird heruntergeladen…';

  @override
  String get updateFailedToStart =>
      'Das Installationsprogramm ließ sich nicht öffnen';

  @override
  String get updateInstall => 'Installieren';

  @override
  String get updateLater => 'Später';

  @override
  String get updateNever => 'Noch nicht';

  @override
  String get updateNow => 'Update herunterladen';

  @override
  String get updateOpenSystemSettings => 'Einstellungen öffnen';

  @override
  String get updateReady => 'Bereit zur Installation';

  @override
  String updateSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get updateSkipVersion => 'Diese Version überspringen';

  @override
  String get updateUpToDate => 'Du hast die neueste Version';

  @override
  String updateVersionAvailable(String version) {
    return 'Version $version ist verfügbar';
  }

  @override
  String updateVersionTitle(String version) {
    return 'Version $version';
  }

  @override
  String get updateWhatsNew => 'Neuigkeiten';

  @override
  String get updates => 'Updates';

  @override
  String get version => 'Version';

  @override
  String get videoAdded => 'Zur Playlist hinzugefügt';

  @override
  String get videoPlayer => 'Videoplayer';

  @override
  String get viewAll => 'Alle ansehen';

  @override
  String get viewAllInPlaylists => 'Alle ansehen';

  @override
  String get viewCards => 'Karten';

  @override
  String get viewGrid => 'Raster';

  @override
  String get viewList => 'Liste';

  @override
  String get viewMode => 'Ansicht';

  @override
  String get waitingForWifi => 'Wartet auf WLAN';

  @override
  String get whatsNewGotIt => 'Verstanden';

  @override
  String get whatsNewReleasePage => 'Release-Seite';

  @override
  String get whatsNewThisVersion => 'Neu in dieser Version';

  @override
  String whatsNewTitle(String version) {
    return 'Neu in $version';
  }

  @override
  String get whatsNewUnavailable =>
      'Was sich in dieser Version geändert hat, steht auf der Release-Seite.';

  @override
  String get wifiOnly => 'Nur über WLAN herunterladen';

  @override
  String get wifiOnlyHelp =>
      'Über mobile Daten wird nichts heruntergeladen. Downloads warten auf WLAN, und ein laufender wird pausiert, wenn das WLAN wegfällt, und läuft von selbst weiter, sobald es zurück ist.';

  @override
  String get yourPlaylists => 'Deine Playlists';

  @override
  String get yourTags => 'Deine Tags';

  @override
  String get ytdlpCredit => 'Der Downloader, den VidHoist nutzt';
}
