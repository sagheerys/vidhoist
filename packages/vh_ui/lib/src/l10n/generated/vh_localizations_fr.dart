// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'vh_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class VhLocalizationsFr extends VhLocalizations {
  VhLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get about => 'À propos';

  @override
  String get aboutApp => 'À propos de l\'appli';

  @override
  String get aboutDescriptionPhone =>
      'Une appli légère et rapide qui télécharge la vidéo et l\'audio de nombreux sites avec yt-dlp. Elle a son propre lecteur et ses playlists.';

  @override
  String get accountSignIn => 'Se connecter';

  @override
  String get accountSignOut => 'Se déconnecter';

  @override
  String get accountSignedIn => 'Connecté';

  @override
  String get accountSignedOut => 'Non connecté';

  @override
  String accountSignedOutOf(String site) {
    return 'Déconnecté de $site';
  }

  @override
  String get accountsBanRisk =>
      'Mieux vaut utiliser un compte secondaire : beaucoup de téléchargements peuvent faire restreindre un compte par le site pendant un temps.';

  @override
  String get accountsClearAll => 'Supprimer tous les cookies';

  @override
  String get accountsCleared => 'Cookies supprimés';

  @override
  String get accountsFileHint =>
      'Exporté d\'un navigateur sous forme de fichier cookies.txt (format Netscape), pour n\'importe quel site, y compris ceux qui ne figurent pas ci-dessus. Il s\'ajoute aux connexions déjà présentes et reste sur ce téléphone.';

  @override
  String get accountsFilePick => 'Choisir un fichier de cookies';

  @override
  String get accountsFileTitle => 'Ou importer un fichier de cookies';

  @override
  String get accountsFromFile => 'Depuis un fichier de cookies';

  @override
  String get accountsHelp =>
      'Une connexion expire au bout d\'un moment ; quand un site recommence à refuser, reconnectez-vous. Se déconnecter d\'un site déconnecte aussi le navigateur intégré des autres, dont les téléchargements continuent comme avant. Si un site refuse la connexion ici, importez ci-dessous un fichier de cookies depuis le navigateur de votre ordinateur.';

  @override
  String get accountsHint =>
      'Pour les sites qui refusent un téléchargement sans connexion. Vous vous connectez sur la page du site, dans l\'appli ; ce qu\'il laisse reste sur ce téléphone, où yt-dlp le lit à chaque téléchargement, et ne va nulle part ailleurs.';

  @override
  String get activeDownloads => 'Téléchargements en cours';

  @override
  String activeDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count téléchargements en cours',
      one: '1 téléchargement en cours',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloadsSheet => 'Téléchargements en cours';

  @override
  String get activeNow => 'Actif';

  @override
  String get addLinkFab => 'Ajouter un lien';

  @override
  String get addTo => 'Ajouter à…';

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get addToPlaylist => 'Ajouter à une playlist';

  @override
  String get addUrl => 'Ajouter une URL';

  @override
  String addedNToServer(int count) {
    return '$count ajouté(s) aux téléchargements';
  }

  @override
  String get addedToFavorites => 'Ajouté aux favoris';

  @override
  String addedToPlaylistCount(int count) {
    return '$count ajouté(s) à la playlist';
  }

  @override
  String get allDownloadsFinished => 'Tous les téléchargements sont terminés.';

  @override
  String get allPlatforms => 'Tous les sites';

  @override
  String get alreadyInPlaylist => 'Déjà ajouté';

  @override
  String get alreadySubscribed => 'Vous suivez déjà cette chaîne';

  @override
  String get appTitle => 'VidHoist';

  @override
  String get appearanceAndLanguage => 'Apparence et langue';

  @override
  String audioChannels(int count) {
    return '$count canaux';
  }

  @override
  String get audioFormat => 'Format audio';

  @override
  String get audioFormatM4a => 'M4A : lisible partout';

  @override
  String get audioFormatMp3 =>
      'MP3 : pour les anciens lecteurs et les voitures';

  @override
  String get audioFormatOriginal =>
      'Tel que le site l\'envoie, sans conversion';

  @override
  String get audioMono => 'Mono';

  @override
  String get audioOnly => 'Audio seul';

  @override
  String get audioStereo => 'Stéréo';

  @override
  String get autoBuilt => 'Automatique';

  @override
  String get autoCheckUpdates => 'Vérifier automatiquement';

  @override
  String get autoCheckUpdatesHelp =>
      'Cherche une nouvelle version en arrière-plan environ deux fois par jour.';

  @override
  String get autoRestoreSuccess => 'Données restaurées depuis la sauvegarde.';

  @override
  String get autoRetry => 'Réessayer au retour du réseau';

  @override
  String get autoRetryHelp =>
      'Tout ce qui a échoué à cause d\'une coupure réseau est relancé tout seul à son retour. Ce qu\'un site a refusé n\'est pas relancé : le répéter à l\'identique échouerait encore.';

  @override
  String get backgroundChecks => 'Vérifier quand l\'app est fermée';

  @override
  String get backgroundChecksHelp =>
      'Environ toutes les six heures, quand il y a du réseau et que la batterie n\'est pas faible. Vous êtes seulement prévenu des nouveautés ; les vidéos se téléchargent quand vous ouvrez VidHoist.';

  @override
  String get backgroundDownload =>
      'Téléchargement des fichiers en arrière-plan…';

  @override
  String backgroundLastRun(String when) {
    return 'Dernière vérification app fermée : $when';
  }

  @override
  String get backgroundNotRunYet =>
      'Pas encore de vérification app fermée : Android choisit le moment.';

  @override
  String get backgroundOfferBody =>
      'VidHoist peut consulter vos chaînes environ toutes les six heures et vous signaler les nouveautés. Rien ne se télécharge avant que vous ouvriez l\'app.';

  @override
  String get backgroundOfferNo => 'Pas maintenant';

  @override
  String get backgroundOfferTitle =>
      'Être prévenu des nouvelles vidéos quand VidHoist est fermé ?';

  @override
  String get backgroundOfferYes => 'Activer';

  @override
  String get backupNote =>
      'Comprend la bibliothèque, les playlists, les tags, les chaînes suivies et les réglages. Les connexions et les transcriptions sont conservées à part, et les fichiers multimédias eux-mêmes ne sont pas inclus.';

  @override
  String get backupSettings => 'Sauvegarder toutes les données';

  @override
  String get backupSettingsSubtitle =>
      'Sept copies datées qui se renouvellent seules. Restaurez n\'importe laquelle, ou exportez-en une pour la partager';

  @override
  String backupSuccess(Object path) {
    return 'Sauvegarde enregistrée dans : $path';
  }

  @override
  String backupsKept(int count) {
    return '$count sauvegardes conservées';
  }

  @override
  String get batchDownloadSelected => 'Télécharger la sélection';

  @override
  String get batchLoading => 'Lecture de la playlist…';

  @override
  String get batchNothingSelected => 'Sélectionnez au moins un élément';

  @override
  String batchSelectedOf(int selected, int total) {
    return '$selected sur $total sélectionnés';
  }

  @override
  String get batchThisVideoOnly => 'Télécharger ce clip seulement';

  @override
  String get batchTitle => 'Téléchargement groupé';

  @override
  String get batteryAllow => 'Autoriser';

  @override
  String get batteryFree =>
      'L\'économie de batterie laisse les téléchargements tranquilles, même quand l\'appli n\'est pas affichée.';

  @override
  String get batteryRestricted =>
      'L\'économie de batterie peut arrêter un long téléchargement quand l\'appli n\'est pas affichée.';

  @override
  String get batteryStateFree => 'Autorisé';

  @override
  String get batteryStateLimited => 'Restreint';

  @override
  String get batteryTitle => 'Téléchargements en arrière-plan';

  @override
  String bitrateKbps(String value) {
    return '$value kb/s';
  }

  @override
  String bitrateMbps(String value) {
    return '$value Mb/s';
  }

  @override
  String get builtWith => 'Conçu avec';

  @override
  String get cancel => 'Annuler';

  @override
  String get changeQuality => 'Changer la qualité';

  @override
  String get channelNameFolder => 'Au nom de la chaîne';

  @override
  String channelFollowers(String count) {
    return '$count abonnés';
  }

  @override
  String get channelCheckFailed =>
      'Pas vérifiée cette fois. VidHoist réessaiera tout seul.';

  @override
  String get channelUrl =>
      'Lien vers une chaîne, une playlist ou l\'une de ses vidéos';

  @override
  String get channelUrlHint => 'https://www.youtube.com/@name';

  @override
  String chapterNumber(int number) {
    return 'Chapitre $number';
  }

  @override
  String get chaptersFold => 'Masquer les chapitres';

  @override
  String chaptersFromTranscript(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapitres tirés de la transcription',
      one: '1 chapitre tiré de la transcription',
    );
    return '$_temp0';
  }

  @override
  String get chaptersShowAll => 'Voir tous les chapitres';

  @override
  String get chaptersUnfold => 'Afficher les chapitres';

  @override
  String get checkEvery => 'Fréquence de vérification';

  @override
  String get checkForUpdates => 'Rechercher des mises à jour';

  @override
  String get checkNow => 'Vérifier maintenant';

  @override
  String get checkQueued =>
      'Vérification en cours. Les nouveautés apparaîtront dans la bibliothèque.';

  @override
  String get chooseFolder => 'Choisir un dossier';

  @override
  String get chooseOptions => 'Options';

  @override
  String get clear => 'Effacer';

  @override
  String get clearLogs => 'Effacer les journaux';

  @override
  String get clearLogsConfirm => 'Supprimer tous les journaux de diagnostic ?';

  @override
  String get clipEndAfterStart => 'Après le début';

  @override
  String get clipFrom => 'De';

  @override
  String clipLength(Object length) {
    return 'La vidéo dure $length';
  }

  @override
  String get clipLengthReading => 'Lecture de la durée de la vidéo…';

  @override
  String get clipLengthUnknown =>
      'Le site n\'indique pas la durée de la vidéo, les temps ne sont donc pas vérifiés';

  @override
  String get clipMinuteDown => 'Une minute plus tôt';

  @override
  String get clipMinuteUp => 'Une minute plus tard';

  @override
  String get clipOnly => 'Seulement une partie de la vidéo';

  @override
  String get clipOnlyHelp =>
      'D\'un moment à un autre, sans le reste. Elle est fournie sans sous-titres.';

  @override
  String clipPastEnd(Object length) {
    return 'La vidéo se termine à $length';
  }

  @override
  String get clipTimeHint => 'Chiffres seuls : 130 donne 1:30';

  @override
  String get clipTo => 'À';

  @override
  String get clipboardFound => 'Un lien est prêt dans votre presse-papiers';

  @override
  String get clipboardLinkReady => 'Coller le lien';

  @override
  String get closePlayer => 'Fermer le lecteur';

  @override
  String get columnAdded => 'Ajouté';

  @override
  String get columnChannel => 'Chaîne';

  @override
  String get columnLength => 'Durée';

  @override
  String get compactView => 'Vue compacte';

  @override
  String get compatiblePlayback => 'Meilleure compatibilité de lecture';

  @override
  String get compatiblePlaybackHelp =>
      'Demande du H.264/AAC, que tous les téléphones décodent en matériel. Sans cela, YouTube peut fournir de l\'AV1, que beaucoup d\'appareils affichent en image brouillée. Le désactiver permet la plus haute résolution, au détriment de la compatibilité.';

  @override
  String get completed => 'Terminé';

  @override
  String get continueAsAudio => 'Continuer en audio';

  @override
  String get continueAsAudioBody =>
      'Continuer la lecture en audio à partir de la même seconde ?';

  @override
  String get continueAsAudioNo => 'Non, arrêter';

  @override
  String get continueAsAudioTitle => 'Continuer en arrière-plan ?';

  @override
  String get cookies => 'Cookies';

  @override
  String get cookiesNotNetscape =>
      'Aucun de ces fichiers ne contient de cookies au format Netscape';

  @override
  String get cookiesSubtitle =>
      'Pour les sites qui ne téléchargent pas sans connexion';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get copyright => '© 2026 Yasir Sagheer';

  @override
  String get couldNotLoadPlaylist =>
      'Impossible de charger cette playlist. Vérifiez l\'URL et votre connexion.';

  @override
  String get create => 'Créer';

  @override
  String get createPlaylist => 'Créer une playlist';

  @override
  String get defaultQuality => 'Qualité vidéo par défaut';

  @override
  String get delete => 'Supprimer';

  @override
  String deleteMultipleConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Supprimer $count clips ?\n\nLeurs fichiers seront retirés de votre appareil.',
      one: 'Supprimer 1 clip ?\n\nSon fichier sera retiré de votre appareil.',
    );
    return '$_temp0';
  }

  @override
  String deletePlaylistConfirm(Object name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get deleteRefused =>
      'Non supprimé : Android a besoin de votre autorisation pour supprimer ce fichier, dans la fenêtre qu\'il affiche.';

  @override
  String get deleteSelected => 'Supprimer la sélection';

  @override
  String get deleteTag => 'Supprimer le tag';

  @override
  String deleteTagConfirm(Object tag) {
    return 'Retirer le tag « $tag » de tous les éléments ? Les clips eux-mêmes ne sont pas supprimés.';
  }

  @override
  String get deleteVideo => 'Supprimer le clip';

  @override
  String deleteVideoConfirm(Object title) {
    return 'Supprimer « $title » ?\n\nLe fichier sera retiré de votre appareil.';
  }

  @override
  String deletedCount(Object count) {
    return '$count supprimé(s)';
  }

  @override
  String deletedTitle(Object title) {
    return 'Supprimé : $title';
  }

  @override
  String get deselectAll => 'Tout désélectionner';

  @override
  String desktopAddLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ajouter $count liens',
      one: 'Ajouter 1 lien',
      zero: 'Rien à ajouter',
    );
    return '$_temp0';
  }

  @override
  String get desktopBack => 'Retour';

  @override
  String get desktopBackUpNow => 'Sauvegarder maintenant';

  @override
  String get desktopBackupHint =>
      'Cet ordinateur garde ses sept dernières sauvegardes, à au moins une heure d\'intervalle, dans Downloads\\VidHoist\\Backups, où elles survivent à une désinstallation.';

  @override
  String get desktopBackupsNone => 'Aucune sauvegarde pour l\'instant';

  @override
  String get desktopBrowserButton =>
      'Bouton « Vers VidHoist » dans le navigateur';

  @override
  String get desktopBrowserButtonCopied =>
      'Code copié. Créez un nouveau favori et collez-le comme adresse (URL).';

  @override
  String get desktopBrowserButtonCopy => 'Copier le code';

  @override
  String get desktopBrowserButtonFailed =>
      'La page n\'a pas pu s\'ouvrir ; copiez plutôt le code.';

  @override
  String get desktopBrowserButtonHint =>
      'Un bouton dans votre barre de favoris : un clic sur la page de n\'importe quelle vidéo ouvre ici la fenêtre d\'ajout avec son lien. Rien n\'est envoyé avant que vous appuyiez sur Ajouter.';

  @override
  String get desktopBrowserButtonName => 'Vers VidHoist';

  @override
  String get desktopBrowserButtonOpen => 'Ouvrir la page de configuration';

  @override
  String get desktopBrowserPageCopyInstead =>
      'Si le glisser ne fonctionne pas, créez un nouveau favori et collez ceci comme adresse :';

  @override
  String get desktopBrowserPageDragHint =>
      'Faites-le glisser sur la barre ; un clic ici ne fait rien.';

  @override
  String get desktopBrowserPageStep1 =>
      'Affichez la barre de favoris si elle est masquée :';

  @override
  String get desktopBrowserPageStep2 =>
      'Faites glisser le bouton ci-dessous sur la barre avec la souris.';

  @override
  String get desktopBrowserPageStep3 =>
      'Sur la page de n\'importe quelle vidéo, cliquez dessus : VidHoist ouvre sa fenêtre d\'ajout avec le lien. La première fois, le navigateur demande s\'il faut ouvrir l\'appli ; acceptez.';

  @override
  String get desktopBrowserPageTitle =>
      'Ajoutez le bouton « Vers VidHoist » à votre navigateur';

  @override
  String get desktopChangeFolder => 'Changer…';

  @override
  String get desktopChannel => 'Chaîne';

  @override
  String get desktopChannelClips => 'Dans votre bibliothèque';

  @override
  String get desktopChannels => 'Chaînes';

  @override
  String get desktopChannelsInLibrary => 'Chaînes de votre bibliothèque';

  @override
  String get desktopChannelsLater => 'Nécessite le moteur de téléchargement';

  @override
  String get desktopChannelsLaterBody =>
      'Suivre une chaîne nécessite yt-dlp sur cet ordinateur. Installez-le dans Réglages › Moteur, et vos chaînes apparaîtront ici.';

  @override
  String get desktopChapters => 'Chapitres';

  @override
  String get desktopCheckAll => 'Tout vérifier';

  @override
  String get desktopChooseClip => 'Sélectionner';

  @override
  String get desktopClearFilters => 'Effacer les filtres';

  @override
  String get desktopClearSelection => 'Effacer la sélection';

  @override
  String get desktopCookiesBrowser => 'Depuis un navigateur';

  @override
  String get desktopCookiesBrowserHint =>
      'Lus depuis le navigateur où vous êtes connecté. S\'ils ne peuvent pas être lus, fermez ce navigateur et réessayez.';

  @override
  String get desktopCookiesChoose => 'Choisir un fichier…';

  @override
  String get desktopCookiesFile => 'Fichier de cookies';

  @override
  String get desktopCookiesHelp =>
      'Dans votre navigateur, utilisez une extension qui exporte les cookies au format Netscape (un fichier par site), et choisissez ici les fichiers ensemble. yt-dlp les utilise ensuite pour chaque téléchargement. Les cookies expirent : un téléchargement qui recommence à échouer signifie en général qu\'il faut les exporter à nouveau.';

  @override
  String get desktopCookiesKept => 'Cookies conservés sur cet ordinateur';

  @override
  String desktopCookiesKeptFor(String sites) {
    return 'Cookies conservés pour : $sites';
  }

  @override
  String get desktopCookiesLocalHint =>
      'Pour les sites où il faut être connecté. yt-dlp les lit sur cet ordinateur, et ils ne vont nulle part ailleurs.';

  @override
  String get desktopCookiesNone => 'Aucun';

  @override
  String get desktopCookiesRemove => 'Retirer';

  @override
  String get desktopCopiedLinkAdd => 'Ajouter…';

  @override
  String get desktopCopiedLinkTitle => 'Télécharger ce lien ?';

  @override
  String get desktopCopyFile => 'Copier le fichier';

  @override
  String get desktopCopyFileFailed => 'Le fichier n\'a pas pu être copié';

  @override
  String get desktopCopyLink => 'Copier le lien';

  @override
  String get desktopCopyOneClip => 'La copie se fait un clip à la fois';

  @override
  String get desktopCopyQuote => 'Copier avec le moment et le lien';

  @override
  String get desktopDefaultQualityHint =>
      'Le point de départ de chaque ajout ; vous pouvez encore le changer pour chaque lien.';

  @override
  String desktopDeleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Supprimer $count clips ? Leurs fichiers sur cet ordinateur seront supprimés.',
      one: 'Supprimer 1 clip ? Son fichier sur cet ordinateur sera supprimé.',
    );
    return '$_temp0';
  }

  @override
  String get desktopDesktopSection => 'Windows';

  @override
  String get desktopDiscover => 'Découvrir VidHoist';

  @override
  String get desktopDiscoverAddLink => 'Coller ou déposer un lien';

  @override
  String get desktopDiscoverAddLinkLine =>
      'Ctrl+V n\'importe où, ou déposez un lien sur la fenêtre, pour l\'ajouter.';

  @override
  String get desktopDiscoverAdding => 'Ajouter et partager';

  @override
  String get desktopDiscoverBrowser => 'Depuis le navigateur';

  @override
  String get desktopDiscoverBrowserLine =>
      'Le bouton « Vers VidHoist » de votre barre de favoris ouvre la fenêtre d\'ajout avec la page où vous êtes.';

  @override
  String get desktopDiscoverChapters => 'Chapitres';

  @override
  String get desktopDiscoverChaptersLine =>
      'Les parties d\'un clip, tirées de sa transcription, sur sa page.';

  @override
  String get desktopDiscoverChoose => 'En choisir plusieurs';

  @override
  String get desktopDiscoverChooseLine =>
      'La marque ronde, ou Ctrl ou Shift avec un clic ; puis ajoutez-les à une liste ou supprimez-les ensemble.';

  @override
  String get desktopDiscoverDragOut => 'Faire glisser un clip';

  @override
  String get desktopDiscoverDragOutLine =>
      'Déposez-le sur un dossier ou une autre appli, il y arrive sous forme de fichier.';

  @override
  String get desktopDiscoverExport => 'Exporter une transcription';

  @override
  String get desktopDiscoverExportLine =>
      'En texte, ou en sous-titres SRT pour un autre lecteur.';

  @override
  String get desktopDiscoverHint =>
      'Tout ce que l\'appli sait faire, une ligne chacun, avec ses touches.';

  @override
  String get desktopDiscoverLibrary => 'La bibliothèque';

  @override
  String get desktopDiscoverListening =>
      'Pour le son : une pièce calme avec la pochette en grand, en plein écran.';

  @override
  String get desktopDiscoverMini => 'Petite fenêtre';

  @override
  String get desktopDiscoverMiniLine =>
      'Une petite carte au-dessus de toutes les autres fenêtres, dans le coin inférieur de l\'écran.';

  @override
  String get desktopDiscoverReading =>
      'La transcription comme un article : cliquez sur une phrase pour l\'écouter à partir de là.';

  @override
  String get desktopDiscoverSaid => 'Ce qui a été dit';

  @override
  String get desktopDiscoverSearch => 'Chercher dans ce qui a été dit';

  @override
  String get desktopDiscoverSearchLine =>
      'Trouvez les clips où un mot a été prononcé, pas seulement dans les titres.';

  @override
  String get desktopDiscoverShortcutsLine =>
      'Toutes les touches que la fenêtre comprend, sur une seule page.';

  @override
  String get desktopDiscoverShow => 'Afficher';

  @override
  String get desktopDiscoverStatsLine =>
      'La bibliothèque en chiffres : par site, chaîne et mois.';

  @override
  String get desktopDiscoverSubtitles =>
      'La transcription sur l\'image, le mot prononcé mis en valeur.';

  @override
  String get desktopDiscoverTheater =>
      'Une image plus grande qui prend la place du panneau latéral.';

  @override
  String get desktopDiscoverTry => 'Essayer';

  @override
  String get desktopDiscoverWatching => 'Regarder et écouter';

  @override
  String get desktopDownloadFolder => 'Dossier de téléchargement';

  @override
  String get desktopDownloadFolderHint =>
      'Les téléchargements sont enregistrés ici comme des fichiers ordinaires, à ouvrir, déplacer ou sauvegarder comme n\'importe quels autres.';

  @override
  String get desktopDownloads => 'Téléchargements';

  @override
  String get desktopDownloadsEmpty =>
      'Rien en téléchargement. Ajoutez un lien pour commencer.';

  @override
  String get desktopDownloadsRunning => 'En cours';

  @override
  String get desktopDragToReorder => 'Faites glisser pour réorganiser';

  @override
  String get desktopDropLinks => 'Déposez pour ajouter';

  @override
  String get desktopEmptyLibraryMessage =>
      'Ajoutez un lien, et le clip apparaîtra ici une fois téléchargé.';

  @override
  String get desktopEngine => 'Moteur';

  @override
  String get desktopEngineDenoHint =>
      'Répond à la vérification de YouTube, pour pouvoir télécharger toutes les qualités proposées';

  @override
  String get desktopEngineFetch => 'Récupérer';

  @override
  String get desktopEngineFetchCorrupt =>
      'Le fichier reçu n\'était pas celui publié, il n\'a donc pas été utilisé.';

  @override
  String get desktopEngineFetchFailed =>
      'Récupération impossible. Vérifiez la connexion et réessayez.';

  @override
  String get desktopEngineFetchInUse =>
      'Utilisé par un téléchargement. Réessayez une fois celui-ci terminé.';

  @override
  String desktopEngineFetching(int percent) {
    return 'Récupération · $percent %';
  }

  @override
  String get desktopEngineFfmpegHint =>
      'Assemble l\'image et le son, et convertit l\'audio';

  @override
  String get desktopEngineIpv4 => 'Utiliser IPv4 uniquement';

  @override
  String get desktopEngineIpv4Hint =>
      'Beaucoup plus rapide là où l\'IPv6 ne fonctionne pas, comme sur de nombreux réseaux domestiques. Ne le désactivez que si votre réseau n\'a que l\'IPv6.';

  @override
  String get desktopEngineMissing =>
      'yt-dlp n\'est pas sur cet ordinateur. Réinstallez VidHoist, ou récupérez-le ici.';

  @override
  String get desktopEngineOnFirstUse =>
      'Récupéré au premier téléchargement qui en a besoin';

  @override
  String get desktopEngineUpToDate => 'yt-dlp est à jour';

  @override
  String get desktopEngineUpdate => 'Mettre à jour yt-dlp';

  @override
  String get desktopEngineUpdateFailed =>
      'La mise à jour n\'a pas abouti. Réessayez plus tard.';

  @override
  String get desktopEngineUpdateHint =>
      'Les sites changent souvent ; un yt-dlp ancien cesse de fonctionner en quelques mois.';

  @override
  String desktopEngineUpdated(String version) {
    return 'yt-dlp est maintenant en $version';
  }

  @override
  String get desktopEngineUpdating => 'Mise à jour…';

  @override
  String desktopEngineVersion(String version) {
    return 'Version $version';
  }

  @override
  String get desktopEngineYtDlpHint => 'Lit le lien et le télécharge';

  @override
  String get desktopExport => 'Exporter';

  @override
  String get desktopExportForPhone => 'Exporter pour le téléphone';

  @override
  String get desktopExportForPhoneHint =>
      'Enregistre les tags, listes et points de reprise de cet ordinateur, ainsi que ses transcriptions, en deux fichiers que le téléphone restaure. La restauration sur le téléphone remplace ses propres tags et listes.';

  @override
  String get desktopExportMarkdown => 'Texte (Markdown)';

  @override
  String get desktopExportPdf => 'Document (PDF)';

  @override
  String get desktopExportPhone => 'Pour le téléphone (import VidHoist)';

  @override
  String get desktopExportSrt => 'Sous-titres (SRT)';

  @override
  String desktopExported(String name) {
    return '$name enregistré';
  }

  @override
  String desktopFileReadyToPaste(String name, String size) {
    return 'Prêt à coller : $name · $size';
  }

  @override
  String get desktopFirstLinkKeys =>
      'n\'importe où dans la fenêtre fait la même chose';

  @override
  String get desktopFirstLinkNote =>
      'De YouTube ou de tout autre site. Le clip apparaît ici dès que son téléchargement commence.';

  @override
  String get desktopFirstLinkPaste => 'Coller';

  @override
  String get desktopFirstLinkTitle => 'Collez votre premier lien';

  @override
  String get desktopFolderUnavailable => 'Aucun dossier disponible';

  @override
  String get desktopFolders => 'Dossiers';

  @override
  String get desktopForward => 'Suivant';

  @override
  String get desktopGlobalShortcut =>
      'Lecture et pause depuis n\'importe quelle appli';

  @override
  String desktopGlobalShortcutHint(String keys) {
    return '$keys lance et met en pause la lecture quand la fenêtre est derrière d\'autres applis.';
  }

  @override
  String desktopGlobalShortcutTaken(String keys) {
    return 'Une autre appli utilise déjà $keys.';
  }

  @override
  String get desktopHidePanel => 'Masquer le panneau latéral';

  @override
  String get desktopHintShortcuts =>
      'Appuyez sur ? pour les raccourcis clavier. Espace lance et met en pause ; les flèches avancent et reculent.';

  @override
  String get desktopHintShortcutsAction => 'Raccourcis';

  @override
  String get desktopHintTrayBody =>
      'La lecture continue depuis son icône près de l\'horloge. Pour quitter, faites un clic droit sur l\'icône.';

  @override
  String get desktopHintTrayTitle => 'VidHoist est toujours ouvert';

  @override
  String get desktopHints => 'Afficher les astuces';

  @override
  String get desktopHintsAgain => 'Les afficher à nouveau';

  @override
  String get desktopHintsHint =>
      'Deux courtes astuces, chacune affichée une fois : les raccourcis au premier clip, l\'icône près de l\'horloge à la première fermeture.';

  @override
  String get desktopImportFromPhone =>
      'Importer une sauvegarde ou des transcriptions…';

  @override
  String get desktopImportHint =>
      'Un fichier de sauvegarde ou de transcriptions de VidHoist, choisi ici ou déposé sur la fenêtre. Celui d\'un téléphone s\'ajoute à ce qui est ici ; une sauvegarde de cet ordinateur est restaurée en entier, après confirmation.';

  @override
  String desktopImportedBackup(int tagged, int lists, int positions) {
    return 'Ajouté depuis le téléphone. Tags : $tagged · listes : $lists · points de reprise : $positions';
  }

  @override
  String get desktopImportedNothing =>
      'Rien de nouveau : cet ordinateur avait déjà tout.';

  @override
  String desktopImportedTranscripts(int count) {
    return 'Transcriptions ajoutées : $count';
  }

  @override
  String desktopInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dans votre bibliothèque',
      one: '1 dans votre bibliothèque',
    );
    return '$_temp0';
  }

  @override
  String get desktopKeepAwake =>
      'Garder l\'ordinateur éveillé pendant les téléchargements';

  @override
  String get desktopKeepAwakeHint =>
      'Pour qu\'un lien envoyé depuis le téléphone, ou une longue playlist, aille jusqu\'au bout au lieu de s\'arrêter quand Windows se met en veille. L\'écran s\'éteint quand même comme d\'habitude.';

  @override
  String get desktopKeyAddLink => 'Ajouter le lien copié';

  @override
  String get desktopKeyFavorite => 'Ajouter aux favoris ou retirer';

  @override
  String get desktopKeyFullScreen =>
      'Plein écran ; pour le son, la salle d\'écoute';

  @override
  String get desktopKeyMenu => 'Le menu du clip';

  @override
  String get desktopKeyMini => 'Petite fenêtre au-dessus des autres, et retour';

  @override
  String get desktopKeyPlayPause => 'Lecture ou pause';

  @override
  String get desktopKeyRepeat => 'Changer la répétition';

  @override
  String get desktopKeySearch => 'Chercher dans les titres et ce qui a été dit';

  @override
  String get desktopKeySeek => 'Reculer ou avancer de 10 secondes';

  @override
  String get desktopKeyShortcuts => 'Cette liste';

  @override
  String get desktopKeyVolume =>
      'Plus fort ou moins fort ; dans les Shorts, le précédent ou le suivant';

  @override
  String get desktopKeyZoomIn => 'Agrandir l\'interface';

  @override
  String get desktopKeyZoomOut => 'Réduire l\'interface';

  @override
  String get desktopKeyZoomReset => 'Interface à sa taille habituelle';

  @override
  String get desktopLanguageSystemHint => 'Suit la langue de Windows.';

  @override
  String desktopLastArrival(String when) {
    return 'Dernière arrivée $when';
  }

  @override
  String get desktopLess => 'Moins';

  @override
  String desktopLibraryDownloading(int count) {
    return '$count en téléchargement';
  }

  @override
  String get desktopLibraryLoading => 'Chargement de la bibliothèque…';

  @override
  String get desktopLinkCopied => 'Lien copié';

  @override
  String get desktopLinkDuplicate => 'Déjà plus haut';

  @override
  String get desktopLinkInLibrary => 'Déjà dans votre bibliothèque';

  @override
  String get desktopLinkPlaylist => 'Une playlist : choisissez ses clips';

  @override
  String get desktopLinkReady => 'Prêt';

  @override
  String get desktopLinkUnsupported => 'Un site que l\'appli ne connaît pas';

  @override
  String desktopLinksDropped(int count, int limit) {
    return 'Seuls les $limit premiers liens sont pris ; $count autres ont été laissés de côté.';
  }

  @override
  String desktopLinksFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count liens',
      one: '1 lien',
    );
    return '$_temp0';
  }

  @override
  String get desktopListeningClose => 'Fermer la salle d\'écoute';

  @override
  String get desktopListeningRoom => 'Salle d\'écoute';

  @override
  String get desktopLogsCopied => 'Journal copié, sans liens ni adresses';

  @override
  String get desktopLogsCopy => 'Copier';

  @override
  String get desktopLogsSave => 'Enregistrer dans un fichier';

  @override
  String get desktopMiniRestore => 'Revenir à la fenêtre complète';

  @override
  String get desktopMiniWindow => 'Petite fenêtre';

  @override
  String get desktopMore => 'Plus';

  @override
  String get desktopNarrowSidebar => 'Réduire la barre latérale';

  @override
  String get desktopNoChannelNames =>
      'Les clips de votre bibliothèque n\'indiquent pas leur chaîne, on ne peut donc pas repérer ceux de cette chaîne. Suivez-la avec son propre dossier, et tout ce qui y arrive s\'affichera ici.';

  @override
  String get desktopNoFavoritesMessage =>
      'Mettez un clip en favori et il vous attendra ici.';

  @override
  String get desktopNoFavoritesTitle => 'Aucun favori pour l\'instant';

  @override
  String get desktopNoMatchMessage => 'Retirez un filtre pour en voir plus.';

  @override
  String get desktopNoMatchTitle => 'Rien ne correspond à ces filtres';

  @override
  String get desktopNoTags =>
      'Aucun tag pour l\'instant. Ajoutez un tag à un clip depuis sa page et il apparaîtra ici.';

  @override
  String get desktopNoTranscriptMessage =>
      'Elle s\'affiche ici une fois les sous-titres du clip téléchargés avec lui.';

  @override
  String get desktopNoTranscriptTitle => 'Pas de transcription pour ce clip';

  @override
  String get desktopNotABackup =>
      'Ce fichier n\'est ni une sauvegarde ni un fichier de transcriptions VidHoist.';

  @override
  String desktopNotWatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count non regardés',
      one: '1 non regardé',
    );
    return '$_temp0';
  }

  @override
  String get desktopNothingPlaying => 'Aucune lecture';

  @override
  String get desktopNothingPlayingHint =>
      'Lisez un clip : sa transcription, la suite et ses détails apparaîtront ici.';

  @override
  String get desktopNotifyArrivalsHint =>
      'Une notification Windows quand de nouveaux clips des chaînes que vous suivez sont téléchargés.';

  @override
  String get desktopOfferCopiedLinks => 'Proposer les liens que je copie';

  @override
  String get desktopOfferCopiedLinksHint =>
      'Quand vous copiez un lien vidéo dans une autre appli, une notification propose de l\'ajouter. Seuls les liens sont examinés, et aucun n\'est enregistré.';

  @override
  String get desktopOpenBackup => 'Ouvrir les sauvegardes';

  @override
  String get desktopOpenChannels => 'Ouvrir les chaînes';

  @override
  String get desktopOpenInExplorer => 'Ouvrir dans l\'Explorateur';

  @override
  String get desktopOpenWith => 'Ouvrir dans un autre lecteur…';

  @override
  String get desktopPaletteClose => 'pour fermer';

  @override
  String get desktopPaletteCommands => 'Commandes';

  @override
  String get desktopPaletteHint =>
      'Cherchez dans les titres et ce qui a été dit, ou tapez > pour les commandes';

  @override
  String desktopPaletteList(String name) {
    return 'Liste : $name';
  }

  @override
  String get desktopPaletteMove => 'pour se déplacer';

  @override
  String get desktopPaletteOpen => 'pour ouvrir';

  @override
  String get desktopPaletteRecent => 'Lus récemment';

  @override
  String get desktopPaletteSaid => 'Dit dans les clips';

  @override
  String get desktopPaletteSave => 'Enregistrer cette recherche';

  @override
  String get desktopPaletteSaved => 'Recherches enregistrées';

  @override
  String desktopPaletteSettings(String section) {
    return 'Réglages : $section';
  }

  @override
  String get desktopPaletteTitles => 'Titres';

  @override
  String get desktopPinned => 'Épinglés';

  @override
  String get desktopPlayNext => 'Lire ensuite';

  @override
  String get desktopPlaysNext => 'Lu ensuite, après celui-ci';

  @override
  String get desktopQueueEnd => 'Rien ne vient après celui-ci';

  @override
  String desktopQuote(String text, String title, String time, String link) {
    return '« $text »\n— $title, $time\n$link';
  }

  @override
  String get desktopQuoteCopied => 'Copié avec son moment et son lien';

  @override
  String get desktopReadingBack => 'Retour au clip';

  @override
  String get desktopReadingCloseFind => 'Fermer la recherche';

  @override
  String get desktopReadingFind => 'Chercher dans le texte';

  @override
  String desktopReadingFound(int at, int count) {
    return '$at sur $count';
  }

  @override
  String get desktopReadingHint =>
      'Cliquez sur une phrase pour l\'écouter à partir de là · Ctrl+F cherche un mot · sélectionnez pour copier avec le moment';

  @override
  String get desktopReadingNextMatch => 'Résultat suivant';

  @override
  String get desktopReadingPreviousMatch => 'Résultat précédent';

  @override
  String get desktopReadingRoom => 'Salle de lecture';

  @override
  String get desktopRecoverLibrary => 'Clips déjà dans le dossier';

  @override
  String get desktopRecoverLibraryAction => 'Regarder dans le dossier';

  @override
  String get desktopRecoverLibraryHint =>
      'Après une réinstallation : remet dans la bibliothèque les clips présents dans le dossier de téléchargement mais qui n\'y figurent plus. Les fichiers ne sont pas touchés.';

  @override
  String desktopRecovered(int count) {
    return 'Remis dans la bibliothèque : $count';
  }

  @override
  String get desktopRecoveredNothing =>
      'Rien à ajouter : chaque clip du dossier est dans la bibliothèque.';

  @override
  String desktopRecoveredSome(int count, int left) {
    return 'Remis dans la bibliothèque : $count. Laissés de côté, lien inconnu : $left';
  }

  @override
  String get desktopRemoveFromList => 'Retirer de la liste';

  @override
  String get desktopRestore => 'Restaurer';

  @override
  String get desktopRestoreBody =>
      'La bibliothèque, les chaînes suivies, les tags, les listes et les réglages de cet ordinateur deviennent ceux de la sauvegarde. Les fichiers téléchargés ne sont pas touchés.';

  @override
  String desktopRestoreOfferBody(String when) {
    return 'Downloads\\VidHoist\\Backups contient une sauvegarde de cet ordinateur : sa bibliothèque, ses chaînes suivies, playlists, tags, réglages et transcriptions enregistrées. La plus récente : $when. Vos fichiers téléchargés ne sont pas touchés, quoi que vous choisissiez.';
  }

  @override
  String get desktopRestoreOfferTitle => 'Restaurer votre sauvegarde ?';

  @override
  String get desktopRestoreTitle => 'Restaurer cette sauvegarde ?';

  @override
  String get desktopRestored => 'Sauvegarde restaurée';

  @override
  String get desktopRevealAfterDownload =>
      'Afficher dans l\'Explorateur une fois terminé';

  @override
  String get desktopRevealAfterDownloadHint =>
      'Quand un fichier téléchargé sur cet ordinateur est prêt, son dossier s\'ouvre avec le fichier sélectionné.';

  @override
  String desktopSavedIn(String folder) {
    return 'Enregistré dans $folder';
  }

  @override
  String desktopSavedSearchDelete(String name) {
    return 'Supprimer la recherche enregistrée « $name » ? Rien ne change dans la bibliothèque.';
  }

  @override
  String get desktopSavedSearchName => 'Nom de la recherche';

  @override
  String get desktopSearch => 'Rechercher';

  @override
  String get desktopSearchHint =>
      'Chercher dans les titres et ce qui a été dit…';

  @override
  String get desktopSearchSaved => 'Enregistrée dans la barre latérale';

  @override
  String get desktopSeekBar => 'Position dans le clip';

  @override
  String desktopSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sélectionnés',
      one: '1 sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get desktopSetupChooseFile => 'Choisir un fichier…';

  @override
  String get desktopShortcutsApp => 'Appli';

  @override
  String get desktopShortcutsClip => 'Sur un clip choisi';

  @override
  String get desktopShortcutsPlayback => 'Lecture';

  @override
  String get desktopShortcutsTitle => 'Raccourcis clavier';

  @override
  String get desktopShortcutsWindow => 'Fenêtre';

  @override
  String get desktopShortsHint =>
      '↑ ↓ ou la molette pour le Short suivant · double-clic pour mettre en favori';

  @override
  String get desktopShowInFolder => 'Afficher dans le dossier';

  @override
  String get desktopShowPanel => 'Afficher le panneau latéral';

  @override
  String get desktopStartFresh => 'Repartir de zéro';

  @override
  String get desktopStartWithWindows => 'Démarrer avec Windows';

  @override
  String get desktopStartWithWindowsHint =>
      'S\'ouvre à la connexion : dans la zone de notification si la lecture y continue, sinon réduite.';

  @override
  String get desktopStartWithWindowsRefused =>
      'Windows n\'a pas laissé l\'appli démarrer avec lui.';

  @override
  String get desktopStats => 'Statistiques de la bibliothèque';

  @override
  String get desktopStatsByChannel => 'Par chaîne';

  @override
  String get desktopStatsByMonth => 'Par mois d\'ajout';

  @override
  String get desktopStatsBySite => 'Par site';

  @override
  String get desktopStatsClips => 'Clips';

  @override
  String get desktopStatsHint =>
      'Ce que contient la bibliothèque, et ce qui mérite peut-être un coup d\'œil. Rien n\'est supprimé d\'ici.';

  @override
  String desktopStatsHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count heures',
      one: '1 heure',
      zero: 'Moins d\'une heure',
    );
    return '$_temp0';
  }

  @override
  String get desktopStatsLargest => 'Les plus gros :';

  @override
  String get desktopStatsLength => 'Durée totale';

  @override
  String get desktopStatsLink => 'Statistiques';

  @override
  String get desktopStatsNeverPlayed => 'Jamais lus ici';

  @override
  String get desktopStatsNewest => 'Les plus récents :';

  @override
  String get desktopStatsOtherChannels => 'Autres chaînes';

  @override
  String get desktopStatsRoom => 'Espace occupé';

  @override
  String get desktopStatsUnnamed => 'Aucune chaîne indiquée';

  @override
  String get desktopStatsWithText => 'Avec transcription';

  @override
  String get desktopStatsWithoutText => 'Sans transcription';

  @override
  String get desktopStatsWorthALook => 'À regarder de plus près';

  @override
  String get desktopSubtitleOptions => 'Options des sous-titres';

  @override
  String get desktopTheater => 'Cinéma';

  @override
  String get desktopTranscriptFirst => 'Récupérez d\'abord sa transcription';

  @override
  String get desktopTranscriptHint =>
      'Suit la lecture · cliquez sur une ligne pour y aller';

  @override
  String get desktopTranscriptHintPage =>
      'Transcription de ce clip · cliquez sur une ligne pour lire à partir de là';

  @override
  String get desktopTranscriptsDeleteBody =>
      'Elles sont retirées de cet ordinateur et de sa sauvegarde. Seul un fichier que vous avez exporté peut les ramener.';

  @override
  String get desktopTranscriptsHelp =>
      'VidHoist garde les paroles de chaque clip YouTube que vous ajoutez, pour qu\'une recherche (Ctrl+K) trouve aussi ce qui a été dit dans vos clips, pas seulement leurs titres. Elles restent sur cet ordinateur.';

  @override
  String get desktopTranscriptsMove => 'Vers ou depuis un téléphone';

  @override
  String get desktopTranscriptsMoveHint =>
      'Les transcriptions voyagent avec la sauvegarde : « Exporter pour le téléphone » les emporte, et « Importer » là-bas les ajoute, en complétant ce qui manque ici.';

  @override
  String get desktopTrayOnClose =>
      'Continuer la lecture dans la zone de notification à la fermeture de la fenêtre';

  @override
  String get desktopTrayOnCloseHint =>
      'Fermer la fenêtre laisse le son continuer ; quittez depuis l\'icône près de l\'horloge.';

  @override
  String get desktopTrayOpen => 'Ouvrir VidHoist';

  @override
  String get desktopTrayQuit => 'Quitter';

  @override
  String get desktopUiSize => 'Taille de l\'interface';

  @override
  String desktopUiSizeHint(String bigger, String smaller, String reset) {
    return '$bigger et $smaller la changent depuis n\'importe où, et $reset revient à 100 %.';
  }

  @override
  String get desktopUiSizeTooLarge => 'Trop grande pour cet écran';

  @override
  String get desktopUpdateInstall => 'Installer et redémarrer';

  @override
  String get desktopUpdateRestartHint =>
      'VidHoist se ferme, installe la mise à jour et se rouvre. Vos réglages et votre bibliothèque restent tels quels.';

  @override
  String get desktopViewCompact => 'Compacte';

  @override
  String get desktopViewTable => 'Tableau';

  @override
  String get desktopVolume => 'Volume';

  @override
  String desktopVolumeLevel(int percent) {
    return 'Volume $percent %';
  }

  @override
  String get desktopWelcomeFetchNow => 'Les récupérer maintenant';

  @override
  String get desktopWelcomeHelpers =>
      'ffmpeg (assemble l\'image et le son) et Deno (requis par YouTube) se téléchargent tout seuls au premier téléchargement, environ 160 Mo. Vous pouvez plutôt les récupérer maintenant.';

  @override
  String get desktopWelcomeMessage =>
      'Collez un lien de YouTube ou d\'un autre site, et VidHoist le télécharge sur cet ordinateur avec yt-dlp.';

  @override
  String get desktopWelcomeStart => 'Commencer';

  @override
  String get desktopWelcomeTitle => 'Bienvenue dans VidHoist';

  @override
  String get desktopWhatsNewAllFeatures => 'Tout ce que VidHoist sait faire';

  @override
  String get desktopWidenSidebar => 'Agrandir la barre latérale';

  @override
  String get desktopWindowClose => 'Fermer';

  @override
  String get desktopWindowMaximize => 'Agrandir';

  @override
  String get desktopWindowMinimize => 'Réduire';

  @override
  String get desktopWindowRestore => 'Restaurer';

  @override
  String get desktopZoomChange => 'Changer';

  @override
  String desktopZoomLowered(String percent) {
    return 'L\'interface est maintenant à $percent pour tenir sur cet écran.';
  }

  @override
  String get details => 'Détails';

  @override
  String get developer => 'Développeur';

  @override
  String get developerName => 'Yasir Sagheer';

  @override
  String get diagnosticLogs => 'Journaux de diagnostic';

  @override
  String get diagnosticLogsSubtitle =>
      'Afficher, rechercher et partager les journaux de l\'appli (anonymisés)';

  @override
  String get disclaimer => 'Avertissement';

  @override
  String get disclaimerText =>
      'Cette appli télécharge des médias avec yt-dlp. Le développeur n\'est pas responsable de l\'usage que les utilisateurs font de cet outil. Merci de respecter le droit d\'auteur et les conditions d\'utilisation des sites depuis lesquels vous téléchargez.';

  @override
  String get dismiss => 'Ignorer';

  @override
  String get done => 'Terminé';

  @override
  String get download => 'Télécharger';

  @override
  String get downloadComplete => 'Téléchargement terminé';

  @override
  String get downloadCompleteTitle => 'Terminé';

  @override
  String get downloadDate => 'Date de téléchargement';

  @override
  String get downloadFailed => 'Échec du téléchargement';

  @override
  String get downloadFailedTitle => 'Échec du téléchargement';

  @override
  String get downloadNow => 'Télécharger';

  @override
  String get downloadStarted => 'Téléchargement lancé…';

  @override
  String downloadStartedQuality(Object quality) {
    return 'Téléchargement lancé · $quality';
  }

  @override
  String get downloading => 'Téléchargement…';

  @override
  String get downloadingTitle => 'Téléchargement';

  @override
  String get downloadsAdvanced => 'Avancé';

  @override
  String get editSubscription => 'Modifier';

  @override
  String get embedSubtitles => 'Sous-titres aussi dans la vidéo';

  @override
  String get embedSubtitlesHelp =>
      'Pour que les autres lecteurs les affichent. Le lecteur de VidHoist les affiche dans tous les cas.';

  @override
  String get emptyFilteredMessage =>
      'Retirez un filtre ci-dessus pour voir toute votre bibliothèque.';

  @override
  String get emptyFilteredTitle => 'Rien ne correspond à ces filtres';

  @override
  String get emptyPlaylist => 'Playlist vide';

  @override
  String get emptyPlaylistMessage => 'Ajoutez des clips depuis la bibliothèque';

  @override
  String engineDownloadingProgress(Object percent) {
    return 'Téléchargement · $percent %';
  }

  @override
  String get engineErrDiskFull =>
      'Pas assez d\'espace de stockage pour ce fichier';

  @override
  String engineErrFailed(Object reason) {
    return 'Échec du téléchargement : $reason';
  }

  @override
  String get engineErrFormat =>
      'Cette qualité n\'est pas disponible pour cette vidéo';

  @override
  String get engineErrGeoBlocked => 'Non disponible dans votre pays';

  @override
  String get engineErrMissing =>
      'Le moteur de téléchargement est absent ou incomplet. Réparez-le dans les Réglages avec « Réparer le moteur »';

  @override
  String get engineErrRateLimited =>
      'Le site limite les requêtes. Réessayez dans un moment';

  @override
  String get engineErrUnavailable =>
      'Cette vidéo est indisponible, privée ou supprimée';

  @override
  String get engineErrUnsupported => 'Ce lien n\'est pas pris en charge';

  @override
  String get enginePaused => 'En pause';

  @override
  String get enginePostprocessing => 'Finalisation du fichier…';

  @override
  String get enginePreparing => 'Lecture du lien…';

  @override
  String get engineRepair => 'Réparer le moteur';

  @override
  String get engineRepairBusy =>
      'Attendez la fin des téléchargements, puis réparez';

  @override
  String get engineRepairHint =>
      'Quand les téléchargements échouent sur plusieurs sites alors qu\'ils marchaient avant, et qu\'une mise à jour n\'a pas aidé : efface ce que yt-dlp a enregistré et remet une copie propre et à jour. Vos téléchargements et réglages restent tels quels.';

  @override
  String get engineRepairPartly =>
      'Réparé en partie : le reste nécessite une connexion. Réessayez une fois en ligne.';

  @override
  String engineRepaired(String version) {
    return 'Réparé : yt-dlp $version';
  }

  @override
  String get engineRepairing => 'Réparation…';

  @override
  String get engineResume => 'Reprendre';

  @override
  String get enterFullscreen => 'Plein écran';

  @override
  String errClipPastEnd(Object length) {
    return 'La partie commence après la fin de la vidéo ($length)';
  }

  @override
  String get errClipPastEndUnknown =>
      'La partie commence après la fin de la vidéo';

  @override
  String get errNetwork => 'Pas de connexion au site';

  @override
  String get errPlatformBlockedCookies =>
      'Le site exige une connexion. Choisissez un fichier de cookies dans Réglages › Cookies';

  @override
  String errorGeneric(Object message) {
    return 'Erreur : $message';
  }

  @override
  String get every30Minutes => 'Toutes les 30 minutes';

  @override
  String everyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Toutes les $count heures',
      one: 'Toutes les heures',
    );
    return '$_temp0';
  }

  @override
  String get exitFullscreen => 'Quitter le plein écran';

  @override
  String get exportShare => 'Exporter et partager';

  @override
  String get exportShareSubtitle =>
      'Une copie datée à envoyer ou à garder ailleurs';

  @override
  String get externalPlayerShort => 'Autre lecteur';

  @override
  String get failed => 'Échec';

  @override
  String get failedToLoadPlaylist => 'Échec du chargement de la playlist';

  @override
  String get fastStreams => 'Flux segmentés plus rapides';

  @override
  String fastStreamsHelp(int count) {
    return 'Récupère $count morceaux à la fois sur les sites qui découpent une vidéo en morceaux, comme X. Certains sites ralentissent quand il y a beaucoup de requêtes à la fois.';
  }

  @override
  String get favorites => 'Favoris';

  @override
  String get file => 'Fichier';

  @override
  String get fileSize => 'Taille du fichier';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterAudio => 'Audio';

  @override
  String get filterVideo => 'Vidéo';

  @override
  String get filtersOn => 'Filtres actifs';

  @override
  String get folder => 'Dossier';

  @override
  String get foldersHelp =>
      'Un dossier est créé dans le dossier de téléchargement, et le clip y est enregistré directement, là où l\'Explorateur et toute autre appli le voient. Laissez « Aucun dossier » et le clip va à la racine du dossier de téléchargement.';

  @override
  String get follow => 'Suivre';

  @override
  String get followChannel => 'Suivre une chaîne';

  @override
  String get format => 'Format';

  @override
  String framesPerSecond(int count) {
    return '$count i/s';
  }

  @override
  String get helpAboutField => 'À propos de ce champ';

  @override
  String get inPlaylists => 'Dans les playlists';

  @override
  String get invalidUrl => 'Saisissez un lien valide';

  @override
  String get itemOptions => 'Options de l\'élément';

  @override
  String get itemUnavailable => 'Plus disponible';

  @override
  String get jumpToNewest => 'Aller au plus récent';

  @override
  String get justNow => 'à l\'instant';

  @override
  String knownVideos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vidéos connues',
      one: '1 vidéo connue',
      zero: 'Rien de connu pour l\'instant',
    );
    return '$_temp0';
  }

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Système';

  @override
  String get languageSystemHint => 'Suit la langue de votre téléphone';

  @override
  String lastBackup(String when) {
    return 'Dernière sauvegarde $when';
  }

  @override
  String lastCheckedAt(String when) {
    return 'Dernière vérification $when';
  }

  @override
  String get latestAdditions => 'Derniers ajouts';

  @override
  String get licensedUnder => 'Sous licence GPL-3.0';

  @override
  String get licenses => 'Licences open source';

  @override
  String get listSeparator => ', ';

  @override
  String get listenInBackground => 'Écouter en arrière-plan';

  @override
  String get lockTouch => 'Verrouiller l\'écran tactile';

  @override
  String get loginDone => 'Terminé';

  @override
  String loginKept(String site) {
    return 'Connecté à $site ; les téléchargements l\'utiliseront';
  }

  @override
  String get loginNotYet =>
      'Aucune connexion trouvée pour l\'instant. Terminez la connexion, puis touchez Terminé';

  @override
  String get logsEmpty => 'Le journal est vide';

  @override
  String get logsSanitizedNote =>
      'Les liens, adresses et identifiants sont retirés avant le partage';

  @override
  String get manageTags => 'Gérer les tags';

  @override
  String get mediaAccessBlockedMessage =>
      'Android ne demandera plus. Activez les photos et vidéos pour cette appli dans les paramètres du système, puis revenez.';

  @override
  String get mediaAccessGrant => 'Autoriser';

  @override
  String get mediaAccessMessage =>
      'Vos téléchargements sont conservés dans le dossier Download du téléphone, et Android a besoin de votre autorisation pour que l\'appli puisse les lister.';

  @override
  String get mediaAccessOpenSettings => 'Ouvrir les paramètres';

  @override
  String get mediaAccessTitle => 'Autoriser l\'accès à vos médias';

  @override
  String get mobileChannelsEmptyBody =>
      'Suivez une chaîne et chaque nouvelle vidéo se télécharge toute seule tant que VidHoist est ouvert ou en arrière-plan ; ce qui est arrivé pendant qu\'il était fermé se télécharge à son ouverture. Ce qui est déjà sur la chaîne n\'est pas téléchargé.';

  @override
  String get mobileChannelsHint =>
      'Les nouvelles vidéos des chaînes que vous suivez, téléchargées toutes seules';

  @override
  String get mobileEngineIpv4 => 'Se connecter en IPv4';

  @override
  String get mobileEngineIpv4Help =>
      'Évite un long blocage sur les réseaux dont la route IPv6 est cassée. Ne le désactivez que si votre réseau n\'a que l\'IPv6.';

  @override
  String mobileEngineLastUpdate(String when) {
    return 'Dernière mise à jour $when';
  }

  @override
  String get mobileEngineNotReady => 'Préparation…';

  @override
  String get mobileEngineUpToDate => 'yt-dlp est à jour';

  @override
  String get mobileEngineUpdate => 'Mettre à jour yt-dlp';

  @override
  String get mobileEngineUpdateFailed =>
      'Impossible de mettre à jour yt-dlp. Vérifiez la connexion et réessayez.';

  @override
  String get mobileEngineUpdateMissed => 'Échec de la mise à jour';

  @override
  String get mobileEngineUpdated => 'Mis à jour';

  @override
  String get mobileEngineUpdating => 'Mise à jour…';

  @override
  String get mobileEngineVersionLabel => 'Version de yt-dlp';

  @override
  String get mobileEngineVersionUnknown =>
      'Sa version s\'affiche après la première mise à jour';

  @override
  String get mobileSettingsEngine => 'Moteur de téléchargement';

  @override
  String get mobileSettingsGroupEngine => 'Moteur';

  @override
  String get mobileSignInNeeded =>
      'Ce site veut que vous soyez connecté. Connectez-vous dans Réglages › Comptes, puis réessayez';

  @override
  String get mobileSubtitleOptions => 'Taille, fond et transcription';

  @override
  String get mobileSubtitleStyleHelp =>
      'Aussi dans le lecteur : maintenez le bouton CC.';

  @override
  String get mobileSubtitles => 'Télécharger les sous-titres';

  @override
  String get mobileSubtitlesHelp =>
      'Les sous-titres dans les langues ci-dessous, quand la vidéo en a, enregistrés à côté d\'elle et affichés dans le lecteur.';

  @override
  String get mobileSubtitlesSizeLarger => 'Plus grands';

  @override
  String get mobileTranscript => 'Transcription';

  @override
  String get mobileTranscriptHint =>
      'Touchez une ligne pour lire à partir de là.';

  @override
  String get mobileTranscriptOpen => 'Lire la transcription';

  @override
  String get mobileWelcomeBody =>
      'Les vidéos et l\'audio des sites que vous utilisez, enregistrés directement sur ce téléphone. Le moteur de téléchargement se prépare ; cela n\'arrive qu\'une fois.';

  @override
  String get mobileWelcomeFailed =>
      'Le moteur n\'a pas pu démarrer. Réessayez ; si l\'échec persiste, réinstallez l\'appli.';

  @override
  String get mobileWelcomeStart => 'Commencer';

  @override
  String get mobileWelcomeTitle => 'Bienvenue dans VidHoist';

  @override
  String get mobileWelcomeUnpacking =>
      'Préparation du moteur de téléchargement';

  @override
  String get mobileWelcomeUpdateFailed =>
      'Mise à jour impossible pour l\'instant. VidHoist réessaiera avant votre premier téléchargement.';

  @override
  String get mobileWelcomeUpdating =>
      'Mise à jour de yt-dlp vers sa dernière version';

  @override
  String get modeAutoNext => 'Auto';

  @override
  String get modeRepeatAll => 'Tout répéter';

  @override
  String get modeRepeatOne => 'Répéter un';

  @override
  String get modeStopAtEnd => 'Arrêter à la fin';

  @override
  String get navLibrary => 'Bibliothèque';

  @override
  String get navMyDownloads => 'Mes téléchargements';

  @override
  String get navPlaylists => 'Playlists';

  @override
  String get navSettings => 'Réglages';

  @override
  String get needsAttention => 'Demande votre attention';

  @override
  String get neverChecked => 'Pas encore vérifié';

  @override
  String get newFolder => 'Nouveau dossier…';

  @override
  String get newFolderHint => 'ex. IA/Cours';

  @override
  String get newPlaylistAction => 'Nouvelle playlist';

  @override
  String get newTagHint => 'Nouveau tag';

  @override
  String newVideosBody(String channels) {
    return '$channels. Elles se téléchargent quand vous ouvrez VidHoist.';
  }

  @override
  String newVideosNotice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nouvelles vidéos',
      one: '$count nouvelle vidéo',
    );
    return '$_temp0';
  }

  @override
  String get next => 'Suivant';

  @override
  String get noBackupsYet => 'Aucune sauvegarde pour l\'instant';

  @override
  String get noDownloads => 'Aucun téléchargement';

  @override
  String get noDownloadsMessage =>
      'Les clips téléchargés apparaîtront ici.\nPartagez un lien ou utilisez le bouton Ajouter un lien.';

  @override
  String get noExternalPlayer => 'Aucun lecteur externe sur cet appareil';

  @override
  String get noFolder => 'Aucun dossier';

  @override
  String get noFolderHint => 'À la racine des téléchargements';

  @override
  String get noLogsFound => 'Aucun journal trouvé';

  @override
  String get noPlayableSource => 'Cet élément n\'a aucune source lisible';

  @override
  String get noPlaylistsMessage =>
      'Créez une playlist pour organiser vos clips';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get noResultsMessage =>
      'Aucun élément ne correspond à votre recherche.';

  @override
  String get noServerTitle => 'Le moteur de téléchargement n\'est pas prêt';

  @override
  String get noticeChannelNewVideos => 'Nouvelles vidéos';

  @override
  String get noticeChannelUpdates => 'Mises à jour';

  @override
  String get noVideosFound => 'Votre bibliothèque est vide';

  @override
  String get noWarranty => 'Fourni tel quel, sans aucune garantie.';

  @override
  String get notAffiliated =>
      'Sans lien avec yt-dlp ni avec aucun site, et non approuvé par eux.';

  @override
  String get nothingHereYet => 'Rien ici pour l\'instant';

  @override
  String get notificationClipGone => 'Ce clip n\'est plus sur le téléphone.';

  @override
  String get nowPlaying => 'En cours de lecture';

  @override
  String get nowPlayingCollapse => 'Replier le panneau du lecteur';

  @override
  String get nowPlayingExpand => 'Afficher le panneau du lecteur';

  @override
  String get ok => 'OK';

  @override
  String get onlyNewVideos =>
      'Seul ce qui paraît à partir de maintenant est téléchargé. Les vidéos déjà sur la chaîne restent où elles sont.';

  @override
  String get openChannel => 'Ouvrir la chaîne';

  @override
  String get openInExternalPlayer => 'Ouvrir dans un autre lecteur';

  @override
  String get openOriginalLink => 'Ouvrir le lien d\'origine';

  @override
  String get ownFolder => 'Enregistrer dans son propre dossier';

  @override
  String get ownFolderNote =>
      'Un dossier dans le dossier de téléchargement, que l\'Explorateur et les autres applis voient aussi. Seul ce qui arrive à partir de maintenant y va ; ce qui est déjà téléchargé reste où il est.';

  @override
  String get pasteUrlHint => 'Collez le lien ici…';

  @override
  String get pause => 'Pause';

  @override
  String get pauseSubscription => 'Suspendre';

  @override
  String get pcAddressLabel => 'Adresse';

  @override
  String get pcBadAddress =>
      'Saisissez l\'adresse telle que l\'ordinateur l\'affiche, par exemple 192.168.1.24.';

  @override
  String get pcBadQr => 'Ce n\'est pas un code QR d\'association VidHoist.';

  @override
  String get pcCertificate => 'Certificat de l\'ordinateur';

  @override
  String get pcCodeLabel => 'Code';

  @override
  String get pcConnected => 'Connecté';

  @override
  String get pcCopied =>
      'Copié dans la bibliothèque du téléphone, avec ses sous-titres.';

  @override
  String get pcCopyFailed =>
      'La copie n\'a pas abouti : l\'ordinateur est peut-être éteint ou hors de portée. Rien n\'a été conservé.';

  @override
  String get pcCopyStarting => 'Copie…';

  @override
  String get pcCopyStop => 'Arrêter la copie';

  @override
  String get pcCopyToPhone => 'Copier sur le téléphone';

  @override
  String pcCopying(int percent) {
    return 'Copie $percent %';
  }

  @override
  String get pcDelete => 'Supprimer de l\'ordinateur';

  @override
  String pcDeleteBody(String title) {
    return '« $title » va dans la Corbeille de l\'ordinateur, d\'où il peut être récupéré.';
  }

  @override
  String get pcDeleteFailed =>
      'L\'ordinateur n\'a pas pu le supprimer. Il est peut-être ouvert là-bas.';

  @override
  String get pcDeleteMissing => 'Ce clip n\'est plus sur l\'ordinateur.';

  @override
  String get pcDeleteNoBin =>
      'Non supprimé : son disque sur l\'ordinateur n\'a pas de Corbeille.';

  @override
  String get pcDeleteNotAllowed =>
      'L\'ordinateur ne permet pas au téléphone de supprimer. Activez-le là-bas dans Réglages › Téléphone.';

  @override
  String pcDeleteTitle(String name) {
    return 'Supprimer de $name ?';
  }

  @override
  String pcDeleted(String title) {
    return 'Dans la Corbeille de l\'ordinateur : $title';
  }

  @override
  String get pcDestPhone => 'Ce téléphone';

  @override
  String pcDoneOnPc(String title) {
    return 'Terminé sur l\'ordinateur : $title';
  }

  @override
  String pcDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count téléchargements pour l\'ordinateur',
      one: '1 téléchargement pour l\'ordinateur',
    );
    return '$_temp0';
  }

  @override
  String get pcDownloadsSheet => 'Téléchargements sur l\'ordinateur';

  @override
  String get pcEmptyLibrary =>
      'Aucun téléchargement sur l\'ordinateur pour l\'instant.';

  @override
  String get pcErrBad =>
      'L\'ordinateur a répondu d\'une façon que cette version ne comprend pas. Mettez à jour les deux applis.';

  @override
  String get pcErrClosed =>
      'Aucun code n\'est affiché sur l\'ordinateur, ou il a expiré. Appuyez là-bas sur « Associer un téléphone ».';

  @override
  String get pcErrDenied =>
      'L\'association a été refusée sur l\'ordinateur, ou n\'a pas reçu de réponse à temps.';

  @override
  String get pcErrRefused => 'L\'ordinateur n\'a pas accepté ce lien.';

  @override
  String get pcErrUnauthorized =>
      'L\'ordinateur ne connaît plus ce téléphone. Associez-le à nouveau.';

  @override
  String get pcErrUnreachable =>
      'L\'ordinateur n\'a pas répondu. Est-il allumé, sur ce réseau ou sur votre Tailscale, avec « Recevoir du téléphone » activé ?';

  @override
  String get pcErrWrongCertificate =>
      'Autre chose que votre ordinateur a répondu à cette adresse. Rien n\'a été envoyé.';

  @override
  String get pcErrWrongCode => 'Code incorrect.';

  @override
  String get pcFindNone =>
      'Aucun ordinateur trouvé. Sur l\'ordinateur, ouvrez d\'abord Réglages › Téléphone › Associer un téléphone, sur le même Wi-Fi.';

  @override
  String get pcFindOnNetwork => 'Chercher sur le réseau';

  @override
  String get pcFirewallAllow => 'Autoriser';

  @override
  String get pcFirewallBlocked =>
      'Le pare-feu Windows bloque VidHoist, le téléphone ne peut donc pas l\'atteindre. Autorisez-le sur les réseaux domestiques (privés).';

  @override
  String get pcFirewallMissing =>
      'Windows n\'a pas encore autorisé VidHoist à recevoir du téléphone. Autorisez-le une fois, sur les réseaux domestiques (privés) uniquement.';

  @override
  String get pcFirewallPublic =>
      'Windows considère ce réseau comme public et n\'y laisse rien entrer. Si c\'est votre réseau domestique, rendez-le privé : Paramètres › Réseau et Internet › Wi-Fi › ses propriétés.';

  @override
  String get pcFirewallRefused =>
      'Rien n\'a changé : Windows a besoin de l\'autorisation d\'un administrateur.';

  @override
  String get pcFirewallTitle => 'Pare-feu Windows';

  @override
  String pcFound(String name) {
    return '$name trouvé. Saisissez le code qu\'il affiche.';
  }

  @override
  String pcFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trouvés',
      one: '1 trouvé',
    );
    return '$_temp0';
  }

  @override
  String pcLastContact(String time) {
    return 'Dernier contact $time';
  }

  @override
  String get pcLibrary => 'Bibliothèque de l\'ordinateur';

  @override
  String get pcLinkAddress => 'Adresse sur ce réseau';

  @override
  String get pcLinkAddressTailscale => 'Via Tailscale, hors de chez vous';

  @override
  String get pcLinkAllow => 'Autoriser';

  @override
  String get pcLinkAllowDelete => 'Laisser le téléphone supprimer des clips';

  @override
  String get pcLinkAllowDeleteHint =>
      'Un clip supprimé depuis le téléphone va dans la Corbeille de cet ordinateur, d\'où vous pouvez le récupérer. Sur un disque sans Corbeille, il n\'est pas supprimé.';

  @override
  String get pcLinkCodeHint =>
      'Sur le téléphone : Réglages › Ordinateur › Scanner le code QR. Ou saisissez-y cette adresse et ce code. Il ne marche qu\'une fois, pendant deux minutes.';

  @override
  String pcLinkCodeLeft(int seconds) {
    return '$seconds s restantes';
  }

  @override
  String get pcLinkCodeTitle => 'Code d\'association';

  @override
  String get pcLinkDeny => 'Refuser';

  @override
  String get pcLinkDevices => 'Téléphones associés';

  @override
  String pcLinkFailed(String error) {
    return 'Démarrage impossible : $error';
  }

  @override
  String get pcLinkIntro =>
      'Envoyez des liens depuis VidHoist sur votre téléphone vers cet ordinateur, et voyez-y ses téléchargements et sa bibliothèque. Fonctionne sur votre réseau domestique, et depuis l\'extérieur via Tailscale.';

  @override
  String pcLinkLastSeen(String time) {
    return 'Dernières nouvelles $time';
  }

  @override
  String get pcLinkNoDevices => 'Aucun téléphone pour l\'instant.';

  @override
  String get pcLinkOff => 'Désactivé';

  @override
  String pcLinkOtherAddresses(int count) {
    return 'Autres adresses ($count)';
  }

  @override
  String get pcLinkOtherAddressesHint =>
      'Des cartes réseau ajoutées par d\'autres programmes, comme VirtualBox ou WSL. Le téléphone en a rarement besoin.';

  @override
  String get pcLinkPairPhone => 'Associer un téléphone';

  @override
  String pcLinkPairedAt(String time) {
    return 'Associé $time';
  }

  @override
  String pcLinkPhones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count téléphones',
      one: 'Un téléphone',
      zero: 'Aucun téléphone',
    );
    return '$_temp0';
  }

  @override
  String get pcLinkQrHint => 'Scannez depuis le téléphone';

  @override
  String get pcLinkReceive => 'Recevoir du téléphone';

  @override
  String get pcLinkReceiveHint =>
      'Tant que c\'est désactivé, aucun port n\'est ouvert sur cet ordinateur. Si Windows demande, n\'autorisez que les réseaux privés.';

  @override
  String pcLinkRequest(String name) {
    return '$name demande à s\'associer';
  }

  @override
  String get pcLinkRequestHint =>
      'N\'autorisez que si le téléphone affiche les quatre mêmes chiffres.';

  @override
  String get pcLinkRevoke => 'Dissocier';

  @override
  String get pcLinkSecurity =>
      'Le téléphone parle directement à cet ordinateur, sur votre réseau ou via votre Tailscale. Il s\'associe une fois, avec le code et votre accord ici ; ensuite il présente sa propre clé à chaque requête, sur une connexion chiffrée avec le seul certificat de cet ordinateur. Quiconque d\'autre sur le réseau trouve porte close.';

  @override
  String get pcLinkStarting => 'Démarrage…';

  @override
  String get pcLinkTitle => 'Téléphone';

  @override
  String get pcListEmpty =>
      'Plus aucun des clips de cette liste n\'est sur l\'ordinateur.';

  @override
  String get pcListen => 'Écouter';

  @override
  String get pcLists => 'Listes de l\'ordinateur';

  @override
  String get pcListsEmpty =>
      'Aucune liste de l\'ordinateur ne contient de clips.';

  @override
  String get pcNow => 'Sur l\'ordinateur en ce moment';

  @override
  String get pcOffline => 'Indisponible';

  @override
  String get pcOfflineMessage =>
      'L\'ordinateur est éteint ou sur un autre réseau. Ce qu\'il avait la dernière fois est affiché ci-dessous.';

  @override
  String get pcOfflineRoute =>
      'Pas chez vous ? Choisissez Tailscale dans Réglages › Ordinateur.';

  @override
  String get pcOnPhone => 'Sur le téléphone';

  @override
  String get pcOrType => 'Ou saisissez l\'adresse et le code';

  @override
  String get pcOutboxRefused => 'L\'ordinateur n\'a pas accepté ce lien';

  @override
  String pcOutboxTitle(int count) {
    return 'En attente d\'envoi ($count)';
  }

  @override
  String get pcPairButton => 'Associer';

  @override
  String pcPairCheck(String check) {
    return 'Vérifiez que l\'ordinateur affiche $check, puis autorisez le téléphone là-bas.';
  }

  @override
  String get pcPairIntro =>
      'Si VidHoist tourne sur votre ordinateur Windows, ce téléphone peut lui envoyer des liens et afficher ses téléchargements et sa bibliothèque. Sur l\'ordinateur, activez Réglages › Téléphone et appuyez sur « Associer un téléphone », puis scannez le code QR qu\'il affiche.';

  @override
  String pcPaired(String name) {
    return 'Associé à $name';
  }

  @override
  String get pcPortLabel => 'Port';

  @override
  String pcQueued(String name) {
    return 'Il partira vers $name à son retour.';
  }

  @override
  String pcQueuedMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clips partiront vers $name à son retour.',
      one: '1 clip partira vers $name à son retour.',
    );
    return '$_temp0';
  }

  @override
  String get pcRouteHint =>
      'Choisissez Tailscale quand vous n\'êtes pas chez vous ; il doit tourner sur le téléphone et sur l\'ordinateur.';

  @override
  String get pcRouteHome => 'Réseau domestique';

  @override
  String get pcRouteOther => 'Autre réseau';

  @override
  String get pcRouteTailscale => 'Tailscale';

  @override
  String get pcRouteTitle => 'Se connecter via';

  @override
  String get pcRouteWaiting =>
      'Les autres routes de l\'ordinateur s\'afficheront ici dès qu\'il répondra.';

  @override
  String get pcScanButton => 'Scanner le code QR';

  @override
  String get pcScanFailed => 'L\'appareil photo n\'a pas pu s\'ouvrir.';

  @override
  String get pcScanPrompt =>
      'Pointez l\'appareil photo vers le code QR sur l\'écran de l\'ordinateur';

  @override
  String get pcSearchHint => 'Chercher dans la bibliothèque de l\'ordinateur';

  @override
  String get pcSendToPc => 'Envoyer à l\'ordinateur';

  @override
  String pcSent(String name) {
    return 'Envoyé à $name';
  }

  @override
  String pcSentMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clips envoyés à $name',
      one: '1 clip envoyé à $name',
    );
    return '$_temp0';
  }

  @override
  String get pcSettingsHint => 'Envoyer des liens à votre ordinateur';

  @override
  String get pcTab => 'Ordinateur';

  @override
  String pcVia(String route) {
    return 'Via $route';
  }

  @override
  String get pcWatch => 'Regarder';

  @override
  String get pcWillSend => 'Absent : envoyé à son retour';

  @override
  String get pickAnotherFile => 'Depuis un autre fichier…';

  @override
  String get pickAnotherFileSubtitle =>
      'Une sauvegarde d\'un autre téléphone ou d\'une version plus ancienne';

  @override
  String get pictureInPicture => 'Image dans l\'image';

  @override
  String get pictureInPictureHelp =>
      'Quand vous quittez l\'appli pendant la lecture d\'un clip, il reste dans un coin de l\'écran';

  @override
  String get pinPlaylist => 'Épingler en haut';

  @override
  String get platform => 'Site';

  @override
  String platformCount(Object name, int count) {
    return '$name · $count';
  }

  @override
  String get platformOther => 'Autre';

  @override
  String get play => 'Lire';

  @override
  String get playAll => 'Tout lire';

  @override
  String get playModeLabel => 'Mode';

  @override
  String get playbackSpeed => 'Vitesse de lecture';

  @override
  String get playerError => 'Impossible de lire ce fichier';

  @override
  String get playingFromDevice => 'Lecture depuis votre appareil';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistAddClips => 'Ajouter des clips';

  @override
  String playlistAddClipsTo(String name) {
    return 'Ajouter à « $name »';
  }

  @override
  String playlistAddCount(int count) {
    return 'Ajouter ($count)';
  }

  @override
  String get playlistCreated => 'Playlist créée';

  @override
  String get playlistDeleted => 'Playlist supprimée';

  @override
  String get playlistDetails => 'Détails de la playlist';

  @override
  String get playlistEditHint =>
      'Appuyez longuement sur un clip pour le déplacer. Balayez-le sur le côté pour le retirer.';

  @override
  String get playlistName => 'Nom de la playlist';

  @override
  String get playlistNameHint => 'Ma playlist';

  @override
  String playlistOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get playlists => 'Playlists';

  @override
  String get previous => 'Précédent';

  @override
  String get quality => 'Qualité';

  @override
  String get quality1080 => 'Jusqu\'à 1080p';

  @override
  String get quality360 => 'Jusqu\'à 360p';

  @override
  String get quality480 => 'Jusqu\'à 480p';

  @override
  String get quality720 => 'Jusqu\'à 720p';

  @override
  String get qualityAudio => 'Audio';

  @override
  String get qualityBest => 'Meilleure';

  @override
  String get qualityHelper =>
      'Utilisée par le téléchargement rapide, par les téléchargements de playlists entières et par « Télécharger » dans la barre du presse-papiers, et c\'est l\'option présélectionnée dans le volet d\'ajout de lien. Elle compte donc, que le téléchargement rapide soit activé ou non.';

  @override
  String get qualityReading => 'Lecture du fichier…';

  @override
  String get qualityUnavailable => 'Indisponible';

  @override
  String get qualityVideo => 'Vidéo';

  @override
  String queueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '1 élément',
      zero: 'Aucun élément',
    );
    return '$_temp0';
  }

  @override
  String get queueLabel => 'File d\'attente';

  @override
  String queuePosition(int position) {
    return 'N° $position dans la file';
  }

  @override
  String get queued => 'En attente';

  @override
  String get queuedSection => 'En attente';

  @override
  String get quickDownload => 'Téléchargement rapide';

  @override
  String get quickDownloadHelp =>
      'Un lien partagé ou collé se télécharge aussitôt dans la qualité par défaut, sans volet. Un site qui n\'a pas cette qualité donne sa meilleure, et « Audio seul » marche sur tous les sites.';

  @override
  String get rateLimit => 'Limite de vitesse';

  @override
  String get rateLimitNone => 'Aucune limite';

  @override
  String rateLimitValue(int mb) {
    return '$mb Mo/s';
  }

  @override
  String get reelsEndBack => 'Retour à la bibliothèque';

  @override
  String get reelsEndContinue => 'Continuer le reste de la liste';

  @override
  String get reelsEndReplay => 'Revoir depuis le début';

  @override
  String get reelsEndTitle => 'Fin du fil de Shorts';

  @override
  String get reelsSwipeHint => 'Balayez vers le haut pour le Short suivant';

  @override
  String get refresh => 'Actualiser';

  @override
  String get remove => 'Retirer';

  @override
  String get removeFromFavorites => 'Retirer des favoris';

  @override
  String removeUnavailable(int count) {
    return 'Retirer $count indisponible(s)';
  }

  @override
  String get removedFromFavorites => 'Retiré des favoris';

  @override
  String get removedFromPlaylist => 'Retiré de la playlist';

  @override
  String get rename => 'Renommer';

  @override
  String get renameTag => 'Renommer le tag';

  @override
  String get reportBug => 'Signaler un bug';

  @override
  String get restoreConfirm =>
      'Restaurer les données depuis le fichier de sauvegarde ? Cela remplace les playlists, tags et réglages actuels.';

  @override
  String get restoreData => 'Restaurer';

  @override
  String get restoreFailed =>
      'Échec de la restauration : le fichier de sauvegarde n\'est pas valide';

  @override
  String get restorePickBody =>
      'Ce téléphone a des téléchargements VidHoist mais aucun réglage, comme après une réinstallation. Si vous avez gardé une sauvegarde, choisissez-la : l\'appli les écrit dans Download/VidHoist/backups.';

  @override
  String get restorePickChoose => 'Choisir une sauvegarde';

  @override
  String get restorePickTitle => 'Récupérer vos réglages ?';

  @override
  String get restoreSettings => 'Restaurer toutes les données';

  @override
  String get restoreSuccess => 'Données restaurées';

  @override
  String get resumeSubscription => 'Reprendre';

  @override
  String get retry => 'Réessayer';

  @override
  String get saveSettings => 'Enregistrer les réglages';

  @override
  String get searchLogs => 'Rechercher dans les journaux…';

  @override
  String get searchVideos => 'Rechercher des clips…';

  @override
  String get seekBackward10 => 'Reculer de 10 secondes';

  @override
  String get seekForward10 => 'Avancer de 10 secondes';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String selected(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String selectedCount(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String get settings => 'Réglages';

  @override
  String get settingsAccounts => 'Comptes';

  @override
  String get settingsBackup => 'Sauvegarde';

  @override
  String get settingsDownloads => 'Téléchargements';

  @override
  String get settingsGroupApp => 'Appli';

  @override
  String get settingsGroupData => 'Données';

  @override
  String get settingsPlayback => 'Lecture';

  @override
  String get settingsTranscripts => 'Transcriptions et sous-titres';

  @override
  String settingsValueChannels(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chaînes',
      one: '1 chaîne',
      zero: 'Aucune chaîne pour l\'instant',
    );
    return '$_temp0';
  }

  @override
  String get settingsValueCompatOff => 'Meilleure compatibilité : désactivée';

  @override
  String get settingsValueCompatOn => 'Meilleure compatibilité : activée';

  @override
  String get settingsValueNotSet => 'Pas encore configuré';

  @override
  String get settingsValueQuick => 'rapide';

  @override
  String settingsValueSignedIn(String sites) {
    return 'Connecté : $sites';
  }

  @override
  String get settingsValueWifiOnly => 'Wi‑Fi uniquement';

  @override
  String get share => 'Partager';

  @override
  String get shareLogs => 'Partager les journaux';

  @override
  String get shareOpening => 'Ouverture du menu de partage…';

  @override
  String get shareOpeningHint =>
      'Un gros fichier met quelques secondes à être transmis.';

  @override
  String get shareSelected => 'Partager la sélection';

  @override
  String get sharedLinksAdd => 'Les ajouter';

  @override
  String get sharedLinksBody => 'Chacun se télécharge sur ce téléphone.';

  @override
  String sharedLinksCapped(int max) {
    return 'Seuls les $max premiers liens ont été ajoutés.';
  }

  @override
  String sharedLinksTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ajouter $count liens ?',
      one: 'Ajouter 1 lien ?',
    );
    return '$_temp0';
  }

  @override
  String get shortsFilter => 'Shorts';

  @override
  String get shuffle => 'Aléatoire';

  @override
  String get signInRequired => 'Connexion requise';

  @override
  String get size => 'Taille';

  @override
  String get smartPlaylists => 'Playlists intelligentes';

  @override
  String get sortAndPlatform => 'Tri et site';

  @override
  String get sortBy => 'Trier par';

  @override
  String get sortLargest => 'Les plus gros';

  @override
  String get sortNameAZ => 'Nom A–Z';

  @override
  String get sortNameZA => 'Nom Z–A';

  @override
  String get sortNewest => 'Les plus récents';

  @override
  String get sortOldest => 'Les plus anciens';

  @override
  String get sortSmallest => 'Les plus petits';

  @override
  String get sortedByLastPlayed => 'Par dernière lecture';

  @override
  String get source => 'Source';

  @override
  String get sourceCode => 'Code source';

  @override
  String get starAskBody =>
      'Gratuit et open source, sans publicité ni compte. Une étoile sur GitHub aide d’autres personnes à le trouver.';

  @override
  String get starAskIdeas => 'Proposer une idée ou signaler un problème';

  @override
  String get starAskLater => 'Peut-être plus tard';

  @override
  String get starAskNever => 'Ne plus afficher';

  @override
  String get starAskStar => 'Lui donner une étoile sur GitHub';

  @override
  String get starAskTitle => 'VidHoist vous plaît ?';

  @override
  String get startDownload => 'Lancer le téléchargement';

  @override
  String get status => 'État';

  @override
  String get storageCardMissing =>
      'La carte n\'est pas insérée, les téléchargements vont donc sur le téléphone';

  @override
  String get storageLocation => 'Enregistrer sur';

  @override
  String get storageLocationHelp =>
      'Les clips déjà téléchargés restent où ils sont et s\'affichent toujours dans la bibliothèque. Une carte mémoire nécessite Android 11 ou plus récent.';

  @override
  String get storageNoCard => 'Aucune carte mémoire dans ce téléphone';

  @override
  String get storagePhone => 'Stockage du téléphone';

  @override
  String get streamingOnline => 'Lecture via le réseau';

  @override
  String subscriptionAdded(String name) {
    return 'Vous suivez maintenant $name';
  }

  @override
  String get subscriptionName => 'Nom';

  @override
  String get subscriptionPaused => 'Suspendue';

  @override
  String get subscriptionQuality => 'Qualité pour cette chaîne';

  @override
  String get subscriptionQualityHelp =>
      'La qualité dans laquelle se téléchargent les nouvelles vidéos de cette chaîne. Vous pourrez la changer plus tard en modifiant la chaîne ; les vidéos déjà téléchargées gardent la leur.\n\n« Meilleure » peut signifier de la 4K au format AV1, qu\'un ordinateur ancien peut lire par saccades : choisissez alors 1080p.';

  @override
  String get subscriptionQualityNote =>
      'S\'applique aux nouvelles vidéos ; celles déjà téléchargées gardent la leur.';

  @override
  String get subscriptions => 'Chaînes';

  @override
  String get subscriptionsEmpty => 'Aucune chaîne suivie pour l\'instant';

  @override
  String get subscriptionsEmptyBody =>
      'Suivez une chaîne et chaque nouvelle vidéo se télécharge toute seule dans votre bibliothèque, tant que VidHoist est ouvert ou dans la zone de notification. Ce qui est déjà sur la chaîne n\'est pas téléchargé.';

  @override
  String get subscriptionsSubtitle =>
      'Les nouvelles vidéos des chaînes que vous suivez, téléchargées toutes seules';

  @override
  String get subtitleLangs => 'Langues des sous-titres';

  @override
  String get subtitleLangsHelp =>
      'Récupérés quand la vidéo en a. Au moins une reste choisie.';

  @override
  String get subtitles => 'Sous-titres';

  @override
  String get subtitlesBackground => 'Fond';

  @override
  String get subtitlesBackgroundFaint => 'Léger';

  @override
  String get subtitlesBackgroundHelp =>
      'Ce qui se trouve derrière les mots. Sans fond, chaque lettre garde un contour sombre pour rester lisible sur une image claire.';

  @override
  String get subtitlesBackgroundNone => 'Aucun';

  @override
  String get subtitlesBackgroundSolid => 'Sombre';

  @override
  String get subtitlesHide => 'Masquer les sous-titres';

  @override
  String get subtitlesLanguage => 'Langue des sous-titres';

  @override
  String get subtitlesShow => 'Afficher les sous-titres';

  @override
  String get subtitlesShowHelp =>
      'Sur la vidéo, pour les clips qui ont une transcription. Le bouton CC du lecteur fait la même chose.';

  @override
  String get subtitlesSize => 'Taille du texte';

  @override
  String get subtitlesSizeLarge => 'Grande';

  @override
  String get subtitlesSizeMedium => 'Moyenne';

  @override
  String get subtitlesSizeSmall => 'Petite';

  @override
  String tagLimitReached(int max) {
    return 'Vous pouvez avoir jusqu\'à $max tags. Retirez-en un dans « Gérer les tags » pour en ajouter un autre.';
  }

  @override
  String get tags => 'Tags';

  @override
  String get tagsOpenFiltered => 'Ouvre la bibliothèque filtrée';

  @override
  String get theme => 'Thème';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeSystem => 'Système';

  @override
  String get titleFilter => 'Ne télécharger que les titres contenant';

  @override
  String get titleFilterHelp =>
      'Une nouvelle vidéo de cette chaîne n\'est téléchargée que si son titre contient ce que vous écrivez ici.\n\n• Un simple mot suffit : Épisode\n• L\'un de plusieurs mots : Épisode|Partie (le | veut dire « ou »)\n• Les majuscules ne comptent pas : épisode correspond aussi à Épisode.\n\nUne vidéo écartée par le filtre est considérée comme vue pour de bon : retirer le filtre plus tard télécharge ce qui vient après, pas ce qui a été écarté.';

  @override
  String get titleFilterHelper =>
      'Plusieurs mots : séparez-les par | . Laissez vide pour tout.';

  @override
  String get titleFilterHint => 'ex. Épisode';

  @override
  String get titleLabel => 'Titre';

  @override
  String totalDuration(Object duration) {
    return 'Total : $duration';
  }

  @override
  String get transcript => 'Transcription';

  @override
  String transcriptSaidMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dit encore $count fois',
      one: 'Dit encore une fois',
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
      zero: 'Aucun clip pour l\'instant',
    );
    return '$_temp0';
  }

  @override
  String get transcriptsDeleteAll => 'Tout supprimer';

  @override
  String get transcriptsDeleteTitle => 'Supprimer toutes les transcriptions ?';

  @override
  String get transcriptsSaidInside => 'Dit dans les clips';

  @override
  String get transcriptsSearchHelp =>
      'Garde les paroles de chaque clip YouTube que vous ajoutez, pour pouvoir chercher dans ce qui a été dit.';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get undo => 'Annuler';

  @override
  String get unfollow => 'Ne plus suivre';

  @override
  String unfollowConfirm(String name) {
    return 'Ne plus suivre $name ?';
  }

  @override
  String get unfollowConfirmBody =>
      'VidHoist oublie quelles vidéos il a déjà vues sur cette chaîne. Si vous la suivez à nouveau plus tard, tout ce qui s\'y trouve alors compte comme vu, et ce que vous avez manqué n\'est pas rattrapé. Suspendre garde cette mémoire.';

  @override
  String get unlockTouch => 'Déverrouiller';

  @override
  String get unpinPlaylist => 'Désépingler';

  @override
  String get updateNoticeBody => 'Ouvrez VidHoist pour l\'installer.';

  @override
  String get upNext => 'À suivre';

  @override
  String upNextIn(String name) {
    return 'À suivre dans « $name »';
  }

  @override
  String get updateAllowInstallBody =>
      'Android a besoin de votre autorisation pour que l\'appli puisse installer ses propres mises à jour. Accordez-la une fois dans les paramètres du système, puis touchez à nouveau Installer.';

  @override
  String get updateAllowInstallTitle =>
      'Autoriser l\'installation des mises à jour';

  @override
  String get updateAvailable => 'Mise à jour disponible';

  @override
  String get updateCheckFailed => 'Impossible de rechercher des mises à jour';

  @override
  String get updateChecking => 'Vérification…';

  @override
  String get updateDownloadFailed => 'Impossible de télécharger la mise à jour';

  @override
  String updateDownloadedMb(String done, String total) {
    return '$done sur $total Mo';
  }

  @override
  String get updateDownloading => 'Téléchargement de la mise à jour…';

  @override
  String get updateFailedToStart =>
      'Impossible d\'ouvrir le programme d\'installation';

  @override
  String get updateInstall => 'Installer';

  @override
  String get updateLater => 'Plus tard';

  @override
  String get updateNever => 'Pas encore';

  @override
  String get updateNow => 'Télécharger la mise à jour';

  @override
  String get updateOpenSystemSettings => 'Ouvrir les paramètres';

  @override
  String get updateReady => 'Prête à installer';

  @override
  String updateSizeMb(String size) {
    return '$size Mo';
  }

  @override
  String get updateSkipVersion => 'Ignorer cette version';

  @override
  String get updateUpToDate => 'Vous avez la dernière version';

  @override
  String updateVersionAvailable(String version) {
    return 'La version $version est disponible';
  }

  @override
  String updateVersionTitle(String version) {
    return 'Version $version';
  }

  @override
  String get updateWhatsNew => 'Nouveautés';

  @override
  String get updates => 'Mises à jour';

  @override
  String get version => 'Version';

  @override
  String get videoAdded => 'Ajouté à la playlist';

  @override
  String get videoPlayer => 'Lecteur vidéo';

  @override
  String get viewAll => 'Tout voir';

  @override
  String get viewAllInPlaylists => 'Tout voir';

  @override
  String get viewCards => 'Cartes';

  @override
  String get viewGrid => 'Grille';

  @override
  String get viewList => 'Liste';

  @override
  String get viewMode => 'Affichage';

  @override
  String get waitingForWifi => 'En attente du Wi-Fi';

  @override
  String get whatsNewGotIt => 'Compris';

  @override
  String get whatsNewReleasePage => 'Page de la version';

  @override
  String get whatsNewThisVersion => 'Nouveautés de cette version';

  @override
  String whatsNewTitle(String version) {
    return 'Nouveautés de la $version';
  }

  @override
  String get whatsNewUnavailable =>
      'Les changements de cette version sont sur la page de la version.';

  @override
  String get wifiOnly => 'Télécharger en Wi-Fi uniquement';

  @override
  String get wifiOnlyHelp =>
      'Rien ne se télécharge via les données mobiles. Les téléchargements attendent le Wi-Fi, et celui qui est en cours quand le Wi-Fi se coupe est mis en pause et reprend tout seul à son retour.';

  @override
  String get yourPlaylists => 'Vos playlists';

  @override
  String get yourTags => 'Vos tags';

  @override
  String get ytdlpCredit => 'Le téléchargeur qu\'utilise VidHoist';
}
