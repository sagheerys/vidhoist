// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'vh_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class VhLocalizationsPt extends VhLocalizations {
  VhLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get about => 'Sobre';

  @override
  String get aboutApp => 'Sobre o app';

  @override
  String get aboutDescriptionPhone =>
      'Um app leve e rápido que baixa vídeo e áudio de muitos sites com yt-dlp. Tem seu próprio player e playlists.';

  @override
  String get accountSignIn => 'Entrar';

  @override
  String get accountSignOut => 'Sair';

  @override
  String get accountSignedIn => 'Conectado';

  @override
  String get accountSignedOut => 'Não conectado';

  @override
  String accountSignedOutOf(String site) {
    return 'Você saiu de $site';
  }

  @override
  String get accountsBanRisk =>
      'Melhor usar uma conta secundária: baixar muito pode fazer o site restringir a conta por um tempo.';

  @override
  String get accountsClearAll => 'Apagar todos os cookies';

  @override
  String get accountsCleared => 'Cookies apagados';

  @override
  String get accountsFileHint =>
      'Exportado de um navegador como arquivo cookies.txt (formato Netscape), para qualquer site, inclusive os que não estão listados acima. Ele se junta aos logins que já estão aqui e fica neste celular.';

  @override
  String get accountsFilePick => 'Escolher um arquivo de cookies';

  @override
  String get accountsFileTitle => 'Ou importe um arquivo de cookies';

  @override
  String get accountsFromFile => 'De um arquivo de cookies';

  @override
  String get accountsHelp =>
      'Um login expira depois de um tempo; quando um site voltar a recusar, entre de novo. Sair de um site também desconecta o navegador do app dos outros, cujos downloads continuam como estavam. Se um site não deixar você entrar aqui, importe abaixo um arquivo de cookies do navegador do seu computador.';

  @override
  String get accountsHint =>
      'Para os sites que recusam um download sem login. Você entra na própria página do site dentro do app; o que ela deixa fica neste celular, onde o yt-dlp lê em cada download, e não vai para nenhum outro lugar.';

  @override
  String get activeDownloads => 'Downloads ativos';

  @override
  String activeDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count downloads em andamento',
      one: '1 download em andamento',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloadsSheet => 'Downloads ativos';

  @override
  String get activeNow => 'Ativo agora';

  @override
  String get addLinkFab => 'Adicionar link';

  @override
  String get addTo => 'Adicionar a…';

  @override
  String get addToFavorites => 'Adicionar aos favoritos';

  @override
  String get addToPlaylist => 'Adicionar à playlist';

  @override
  String get addUrl => 'Adicionar URL';

  @override
  String addedNToServer(int count) {
    return '$count adicionados aos downloads';
  }

  @override
  String get addedToFavorites => 'Adicionado aos favoritos';

  @override
  String addedToPlaylistCount(int count) {
    return '$count adicionados à playlist';
  }

  @override
  String get allDownloadsFinished => 'Todos os downloads terminaram.';

  @override
  String get allPlatforms => 'Todos os sites';

  @override
  String get alreadyInPlaylist => 'Já adicionado';

  @override
  String get alreadySubscribed => 'Você já segue este canal';

  @override
  String get appTitle => 'VidHoist';

  @override
  String get appearanceAndLanguage => 'Aparência e idioma';

  @override
  String audioChannels(int count) {
    return '$count canais';
  }

  @override
  String get audioFormat => 'Formato de áudio';

  @override
  String get audioFormatM4a => 'M4A: toca em qualquer lugar';

  @override
  String get audioFormatMp3 => 'MP3: para players antigos e carros';

  @override
  String get audioFormatOriginal => 'Como o site envia, sem converter';

  @override
  String get audioMono => 'Mono';

  @override
  String get audioOnly => 'Só áudio';

  @override
  String get audioStereo => 'Estéreo';

  @override
  String get autoBuilt => 'Automático';

  @override
  String get autoCheckUpdates => 'Verificar automaticamente';

  @override
  String get autoCheckUpdatesHelp =>
      'Procura uma nova versão em segundo plano cerca de duas vezes por dia.';

  @override
  String get autoRestoreSuccess => 'Dados restaurados do backup.';

  @override
  String get autoRetry => 'Tentar de novo quando a rede voltar';

  @override
  String get autoRetryHelp =>
      'O que falhou porque a rede caiu é tentado de novo sozinho quando ela volta. O que um site recusou não é repetido: repetir igual só falha de novo.';

  @override
  String get backgroundChecks => 'Verificar com o app fechado';

  @override
  String get backgroundChecksHelp =>
      'Mais ou menos a cada seis horas, quando há rede e a bateria não está fraca. Só avisa o que há de novo; os vídeos são baixados quando você abre o VidHoist.';

  @override
  String get backgroundDownload => 'Baixando arquivos em segundo plano…';

  @override
  String backgroundLastRun(String when) {
    return 'Última verificação com o app fechado: $when';
  }

  @override
  String get backgroundNotRunYet =>
      'Ainda não houve verificação com o app fechado: o Android escolhe o momento.';

  @override
  String get backgroundOfferBody =>
      'O VidHoist pode olhar seus canais a cada seis horas, mais ou menos, e avisar o que há de novo. Nada é baixado até você abrir o app.';

  @override
  String get backgroundOfferNo => 'Agora não';

  @override
  String get backgroundOfferTitle =>
      'Quer saber dos vídeos novos com o VidHoist fechado?';

  @override
  String get backgroundOfferYes => 'Ativar';

  @override
  String get backupNote =>
      'Inclui a biblioteca, as playlists, as tags, os canais seguidos e as configurações. Logins e transcrições ficam separados, e os arquivos de mídia em si não são incluídos.';

  @override
  String get backupSettings => 'Fazer backup de todos os dados';

  @override
  String get backupSettingsSubtitle =>
      'Sete cópias datadas que se renovam sozinhas. Restaure qualquer uma ou exporte uma para compartilhar';

  @override
  String backupSuccess(Object path) {
    return 'Backup salvo em: $path';
  }

  @override
  String backupsKept(int count) {
    return '$count backups guardados';
  }

  @override
  String get batchDownloadSelected => 'Baixar selecionados';

  @override
  String get batchLoading => 'Lendo a playlist…';

  @override
  String get batchNothingSelected => 'Selecione pelo menos um item';

  @override
  String batchSelectedOf(int selected, int total) {
    return '$selected de $total selecionados';
  }

  @override
  String get batchThisVideoOnly => 'Baixar só este clipe';

  @override
  String get batchTitle => 'Download em lote';

  @override
  String get batteryAllow => 'Permitir';

  @override
  String get batteryFree =>
      'A economia de bateria não mexe nos downloads, mesmo com o app fora de vista.';

  @override
  String get batteryRestricted =>
      'A economia de bateria pode interromper um download longo enquanto o app está fora de vista.';

  @override
  String get batteryStateFree => 'Permitido';

  @override
  String get batteryStateLimited => 'Restrito';

  @override
  String get batteryTitle => 'Downloads em segundo plano';

  @override
  String bitrateKbps(String value) {
    return '$value kb/s';
  }

  @override
  String bitrateMbps(String value) {
    return '$value Mb/s';
  }

  @override
  String get builtWith => 'Feito com';

  @override
  String get cancel => 'Cancelar';

  @override
  String get changeQuality => 'Mudar qualidade';

  @override
  String get channelNameFolder => 'Com o nome do canal';

  @override
  String channelFollowers(String count) {
    return '$count inscritos';
  }

  @override
  String get channelCheckFailed =>
      'Não verificado desta vez. O VidHoist tenta de novo sozinho.';

  @override
  String get channelUrl =>
      'Link de um canal, uma playlist ou um dos seus vídeos';

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
      other: '$count capítulos da transcrição',
      one: '1 capítulo da transcrição',
    );
    return '$_temp0';
  }

  @override
  String get chaptersShowAll => 'Ver todos os capítulos';

  @override
  String get chaptersUnfold => 'Mostrar capítulos';

  @override
  String get checkEvery => 'Com que frequência verificar';

  @override
  String get checkForUpdates => 'Verificar atualizações';

  @override
  String get checkNow => 'Verificar agora';

  @override
  String get checkQueued =>
      'Verificando agora. O que for novo aparece na biblioteca.';

  @override
  String get chooseFolder => 'Escolher uma pasta';

  @override
  String get chooseOptions => 'Opções';

  @override
  String get clear => 'Limpar';

  @override
  String get clearLogs => 'Limpar registros';

  @override
  String get clearLogsConfirm => 'Apagar todos os registros de diagnóstico?';

  @override
  String get clipEndAfterStart => 'Depois do início';

  @override
  String get clipFrom => 'De';

  @override
  String clipLength(Object length) {
    return 'O vídeo tem $length';
  }

  @override
  String get clipLengthReading => 'Lendo a duração do vídeo…';

  @override
  String get clipLengthUnknown =>
      'O site não informa a duração do vídeo, então os tempos não são verificados';

  @override
  String get clipMinuteDown => 'Um minuto antes';

  @override
  String get clipMinuteUp => 'Um minuto depois';

  @override
  String get clipOnly => 'Só uma parte do vídeo';

  @override
  String get clipOnlyHelp =>
      'De um momento a outro, sem o resto. Vem sem legendas.';

  @override
  String clipPastEnd(Object length) {
    return 'O vídeo termina em $length';
  }

  @override
  String get clipTimeHint => 'Só dígitos: 130 é 1:30';

  @override
  String get clipTo => 'Até';

  @override
  String get clipboardFound => 'Há um link pronto na sua área de transferência';

  @override
  String get clipboardLinkReady => 'Colar link';

  @override
  String get closePlayer => 'Fechar player';

  @override
  String get columnAdded => 'Adicionado';

  @override
  String get columnChannel => 'Canal';

  @override
  String get columnLength => 'Duração';

  @override
  String get compactView => 'Visualização compacta';

  @override
  String get compatiblePlayback => 'Máxima compatibilidade de reprodução';

  @override
  String get compatiblePlaybackHelp =>
      'Pede H.264/AAC, que todo celular decodifica por hardware. Sem isso, o YouTube pode entregar AV1, que muitos aparelhos mostram como imagem embaralhada. Desativar permite a maior resolução ao custo da compatibilidade.';

  @override
  String get completed => 'Concluído';

  @override
  String get continueAsAudio => 'Continuar como áudio';

  @override
  String get continueAsAudioBody =>
      'Continuar tocando isto como áudio a partir do mesmo segundo?';

  @override
  String get continueAsAudioNo => 'Não, parar';

  @override
  String get continueAsAudioTitle => 'Continuar em segundo plano?';

  @override
  String get cookies => 'Cookies';

  @override
  String get cookiesNotNetscape =>
      'Nenhum destes arquivos tem cookies no formato Netscape';

  @override
  String get cookiesSubtitle => 'Para os sites que não baixam sem login';

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência';

  @override
  String get copyright => '© 2026 Yasir Sagheer';

  @override
  String get couldNotLoadPlaylist =>
      'Não foi possível carregar esta playlist. Verifique a URL e sua conexão.';

  @override
  String get create => 'Criar';

  @override
  String get createPlaylist => 'Criar playlist';

  @override
  String get defaultQuality => 'Qualidade de vídeo padrão';

  @override
  String get delete => 'Excluir';

  @override
  String deleteMultipleConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Excluir $count clipes?\n\nOs arquivos deles são removidos do seu aparelho.',
      one: 'Excluir 1 clipe?\n\nO arquivo dele é removido do seu aparelho.',
    );
    return '$_temp0';
  }

  @override
  String deletePlaylistConfirm(Object name) {
    return 'Excluir \"$name\"?';
  }

  @override
  String get deleteRefused =>
      'Não excluído: o Android precisa da sua permissão para excluir este arquivo, na caixa que ele mostra.';

  @override
  String get deleteSelected => 'Excluir selecionados';

  @override
  String get deleteTag => 'Excluir tag';

  @override
  String deleteTagConfirm(Object tag) {
    return 'Remover a tag \"$tag\" de todos os itens? Os clipes em si não são excluídos.';
  }

  @override
  String get deleteVideo => 'Excluir clipe';

  @override
  String deleteVideoConfirm(Object title) {
    return 'Excluir \"$title\"?\n\nIsso vai remover o arquivo do seu aparelho.';
  }

  @override
  String deletedCount(Object count) {
    return '$count excluídos';
  }

  @override
  String deletedTitle(Object title) {
    return 'Excluído: $title';
  }

  @override
  String get deselectAll => 'Desmarcar tudo';

  @override
  String desktopAddLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Adicionar $count links',
      one: 'Adicionar 1 link',
      zero: 'Nada para adicionar',
    );
    return '$_temp0';
  }

  @override
  String get desktopBack => 'Voltar';

  @override
  String get desktopBackUpNow => 'Fazer backup agora';

  @override
  String get desktopBackupHint =>
      'Este computador guarda seus últimos sete backups, com pelo menos uma hora de intervalo, em Downloads\\VidHoist\\Backups, onde sobrevivem a uma desinstalação.';

  @override
  String get desktopBackupsNone => 'Nenhum backup ainda';

  @override
  String get desktopBrowserButton => 'Botão “Para o VidHoist” no navegador';

  @override
  String get desktopBrowserButtonCopied =>
      'Código copiado. Crie um novo favorito e cole-o como endereço (URL).';

  @override
  String get desktopBrowserButtonCopy => 'Copiar o código';

  @override
  String get desktopBrowserButtonFailed =>
      'Não foi possível abrir a página; copie o código.';

  @override
  String get desktopBrowserButtonHint =>
      'Um botão na sua barra de favoritos: um clique na página de qualquer vídeo abre aqui a janela de adicionar com o link. Nada é enviado até você tocar em Adicionar.';

  @override
  String get desktopBrowserButtonName => 'Para o VidHoist';

  @override
  String get desktopBrowserButtonOpen => 'Abrir a página de configuração';

  @override
  String get desktopBrowserPageCopyInstead =>
      'Se arrastar não funcionar, crie um novo favorito e cole isto como endereço:';

  @override
  String get desktopBrowserPageDragHint =>
      'Arraste-o para a barra; um clique aqui não faz nada.';

  @override
  String get desktopBrowserPageStep1 =>
      'Mostre a barra de favoritos se estiver oculta:';

  @override
  String get desktopBrowserPageStep2 =>
      'Arraste com o mouse o botão abaixo até a barra.';

  @override
  String get desktopBrowserPageStep3 =>
      'Na página de qualquer vídeo, clique nele: o VidHoist abre a janela de adicionar com o link. Na primeira vez, o navegador pergunta se deve abrir o app; permita.';

  @override
  String get desktopBrowserPageTitle =>
      'Adicione o botão “Para o VidHoist” ao seu navegador';

  @override
  String get desktopChangeFolder => 'Alterar…';

  @override
  String get desktopChannel => 'Canal';

  @override
  String get desktopChannelClips => 'Na sua biblioteca';

  @override
  String get desktopChannels => 'Canais';

  @override
  String get desktopChannelsInLibrary => 'Canais na sua biblioteca';

  @override
  String get desktopChannelsLater => 'Precisa do motor de download';

  @override
  String get desktopChannelsLaterBody =>
      'Seguir um canal precisa do yt-dlp neste computador. Configure em Configurações › Motor, e seus canais aparecem aqui.';

  @override
  String get desktopChapters => 'Capítulos';

  @override
  String get desktopCheckAll => 'Verificar todos';

  @override
  String get desktopChooseClip => 'Selecionar';

  @override
  String get desktopClearFilters => 'Limpar filtros';

  @override
  String get desktopClearSelection => 'Limpar seleção';

  @override
  String get desktopCookiesBrowser => 'De um navegador';

  @override
  String get desktopCookiesBrowserHint =>
      'Lidos do navegador em que você está conectado. Se não puderem ser lidos, feche esse navegador e tente de novo.';

  @override
  String get desktopCookiesChoose => 'Escolher um arquivo…';

  @override
  String get desktopCookiesFile => 'Arquivo de cookies';

  @override
  String get desktopCookiesHelp =>
      'No seu navegador, use uma extensão que exporte cookies no formato Netscape (um arquivo por site) e escolha os arquivos aqui de uma vez. O yt-dlp passa a usá-los em todo download. Cookies expiram, então um download que volta a falhar geralmente significa que é hora de exportar de novo.';

  @override
  String get desktopCookiesKept => 'Cookies guardados neste computador';

  @override
  String desktopCookiesKeptFor(String sites) {
    return 'Cookies guardados para: $sites';
  }

  @override
  String get desktopCookiesLocalHint =>
      'Para sites que exigem login. O yt-dlp os lê neste computador, e eles não vão para nenhum outro lugar.';

  @override
  String get desktopCookiesNone => 'Nenhum';

  @override
  String get desktopCookiesRemove => 'Remover';

  @override
  String get desktopCopiedLinkAdd => 'Adicionar…';

  @override
  String get desktopCopiedLinkTitle => 'Baixar este link?';

  @override
  String get desktopCopyFile => 'Copiar arquivo';

  @override
  String get desktopCopyFileFailed => 'Não foi possível copiar o arquivo';

  @override
  String get desktopCopyLink => 'Copiar link';

  @override
  String get desktopCopyOneClip => 'A cópia é de um clipe por vez';

  @override
  String get desktopCopyQuote => 'Copiar com tempo e link';

  @override
  String get desktopDefaultQualityHint =>
      'Com o que cada adição começa; você ainda pode mudar para cada link.';

  @override
  String desktopDeleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Excluir $count clipes? Os arquivos deles neste computador são apagados.',
      one: 'Excluir 1 clipe? O arquivo dele neste computador é apagado.',
    );
    return '$_temp0';
  }

  @override
  String get desktopDesktopSection => 'Windows';

  @override
  String get desktopDiscover => 'Conheça o VidHoist';

  @override
  String get desktopDiscoverAddLink => 'Cole ou solte um link';

  @override
  String get desktopDiscoverAddLinkLine =>
      'Ctrl+V em qualquer lugar, ou solte um link na janela, para adicioná-lo.';

  @override
  String get desktopDiscoverAdding => 'Adicionar e compartilhar';

  @override
  String get desktopDiscoverBrowser => 'Do navegador';

  @override
  String get desktopDiscoverBrowserLine =>
      'O botão “Para o VidHoist” na sua barra de favoritos abre a janela de adicionar com a página em que você está.';

  @override
  String get desktopDiscoverChapters => 'Capítulos';

  @override
  String get desktopDiscoverChaptersLine =>
      'As partes de um clipe, a partir da transcrição, na página dele.';

  @override
  String get desktopDiscoverChoose => 'Escolher vários';

  @override
  String get desktopDiscoverChooseLine =>
      'A marca redonda, ou Ctrl ou Shift com um clique; depois adicione-os a uma lista ou exclua-os juntos.';

  @override
  String get desktopDiscoverDragOut => 'Arraste um clipe para fora';

  @override
  String get desktopDiscoverDragOutLine =>
      'Solte-o numa pasta ou em outro app, e ele chega lá como arquivo.';

  @override
  String get desktopDiscoverExport => 'Exportar uma transcrição';

  @override
  String get desktopDiscoverExportLine =>
      'Como texto, ou como legendas SRT para outro player.';

  @override
  String get desktopDiscoverHint =>
      'Tudo o que o app faz, uma linha cada, com suas teclas.';

  @override
  String get desktopDiscoverLibrary => 'A biblioteca';

  @override
  String get desktopDiscoverListening =>
      'Para ouvir: uma sala tranquila com a capa grande, em tela cheia.';

  @override
  String get desktopDiscoverMini => 'Janela pequena';

  @override
  String get desktopDiscoverMiniLine =>
      'Um cartão pequeno acima de todas as outras janelas, no canto inferior da tela.';

  @override
  String get desktopDiscoverReading =>
      'A transcrição como artigo: clique numa frase para ouvir a partir dali.';

  @override
  String get desktopDiscoverSaid => 'O que foi dito';

  @override
  String get desktopDiscoverSearch => 'Busque o que foi dito';

  @override
  String get desktopDiscoverSearchLine =>
      'Encontre os clipes em que uma palavra foi falada, não só nos títulos.';

  @override
  String get desktopDiscoverShortcutsLine =>
      'Todas as teclas que a janela atende, numa só folha.';

  @override
  String get desktopDiscoverShow => 'Mostrar';

  @override
  String get desktopDiscoverStatsLine =>
      'A biblioteca em números: por site, canal e mês.';

  @override
  String get desktopDiscoverSubtitles =>
      'A transcrição sobre a imagem, com a palavra falada em destaque.';

  @override
  String get desktopDiscoverTheater =>
      'Uma imagem maior que ocupa o lugar do painel lateral.';

  @override
  String get desktopDiscoverTry => 'Experimente';

  @override
  String get desktopDiscoverWatching => 'Assistir e ouvir';

  @override
  String get desktopDownloadFolder => 'Pasta de downloads';

  @override
  String get desktopDownloadFolderHint =>
      'Os downloads são salvos aqui como arquivos comuns, para abrir, mover ou fazer backup como qualquer outro.';

  @override
  String get desktopDownloads => 'Downloads';

  @override
  String get desktopDownloadsEmpty =>
      'Nada está sendo baixado. Adicione um link para começar.';

  @override
  String get desktopDownloadsRunning => 'Em andamento';

  @override
  String get desktopDragToReorder => 'Arraste para reordenar';

  @override
  String get desktopDropLinks => 'Solte para adicionar';

  @override
  String get desktopEmptyLibraryMessage =>
      'Adicione um link, e o clipe aparece aqui quando for baixado.';

  @override
  String get desktopEngine => 'Motor';

  @override
  String get desktopEngineDenoHint =>
      'Responde à verificação do YouTube, para que toda qualidade oferecida possa ser baixada';

  @override
  String get desktopEngineFetch => 'Obter';

  @override
  String get desktopEngineFetchCorrupt =>
      'O arquivo que chegou não era o publicado, então não foi usado.';

  @override
  String get desktopEngineFetchFailed =>
      'Não foi possível obter. Verifique a conexão e tente de novo.';

  @override
  String get desktopEngineFetchInUse =>
      'Em uso por um download. Tente de novo quando ele terminar.';

  @override
  String desktopEngineFetching(int percent) {
    return 'Obtendo · $percent%';
  }

  @override
  String get desktopEngineFfmpegHint => 'Junta imagem e som, e converte áudio';

  @override
  String get desktopEngineIpv4 => 'Usar só IPv4';

  @override
  String get desktopEngineIpv4Hint =>
      'Bem mais rápido onde o IPv6 não funciona, como em muitas redes domésticas. Desative só se sua rede tiver apenas IPv6.';

  @override
  String get desktopEngineMissing =>
      'O yt-dlp não está neste computador. Reinstale o VidHoist ou obtenha-o aqui.';

  @override
  String get desktopEngineOnFirstUse =>
      'Obtido no primeiro download que precisar dele';

  @override
  String get desktopEngineUpToDate => 'O yt-dlp está atualizado';

  @override
  String get desktopEngineUpdate => 'Atualizar o yt-dlp';

  @override
  String get desktopEngineUpdateFailed =>
      'A atualização não foi concluída. Tente mais tarde.';

  @override
  String get desktopEngineUpdateHint =>
      'Os sites mudam com frequência; um yt-dlp antigo para de funcionar em poucos meses.';

  @override
  String desktopEngineUpdated(String version) {
    return 'O yt-dlp agora é $version';
  }

  @override
  String get desktopEngineUpdating => 'Atualizando…';

  @override
  String desktopEngineVersion(String version) {
    return 'Versão $version';
  }

  @override
  String get desktopEngineYtDlpHint => 'Lê o link e faz o download';

  @override
  String get desktopExport => 'Exportar';

  @override
  String get desktopExportForPhone => 'Exportar para o celular';

  @override
  String get desktopExportForPhoneHint =>
      'Salva as tags, as listas e os pontos de retomada deste computador, e as transcrições dele, em dois arquivos que o celular restaura. Restaurar no celular substitui as tags e listas dele.';

  @override
  String get desktopExportMarkdown => 'Texto (Markdown)';

  @override
  String get desktopExportPdf => 'Documento (PDF)';

  @override
  String get desktopExportPhone => 'Para o celular (importar no VidHoist)';

  @override
  String get desktopExportSrt => 'Legendas (SRT)';

  @override
  String desktopExported(String name) {
    return '$name salvo';
  }

  @override
  String desktopFileReadyToPaste(String name, String size) {
    return 'Pronto para colar: $name · $size';
  }

  @override
  String get desktopFirstLinkKeys => 'em qualquer lugar da janela faz o mesmo';

  @override
  String get desktopFirstLinkNote =>
      'Do YouTube ou de qualquer outro site. O clipe aparece aqui assim que o download começa.';

  @override
  String get desktopFirstLinkPaste => 'Colar';

  @override
  String get desktopFirstLinkTitle => 'Cole seu primeiro link';

  @override
  String get desktopFolderUnavailable => 'Nenhuma pasta disponível';

  @override
  String get desktopFolders => 'Pastas';

  @override
  String get desktopForward => 'Avançar';

  @override
  String get desktopGlobalShortcut => 'Tocar e pausar de qualquer app';

  @override
  String desktopGlobalShortcutHint(String keys) {
    return '$keys toca e pausa mesmo com a janela atrás de outros apps.';
  }

  @override
  String desktopGlobalShortcutTaken(String keys) {
    return 'Outro app já usa $keys.';
  }

  @override
  String get desktopHidePanel => 'Ocultar painel lateral';

  @override
  String get desktopHintShortcuts =>
      'Pressione ? para ver os atalhos de teclado. Espaço toca e pausa; as setas avançam e voltam.';

  @override
  String get desktopHintShortcutsAction => 'Atalhos';

  @override
  String get desktopHintTrayBody =>
      'Ele continua tocando pelo ícone ao lado do relógio. Para sair, clique com o botão direito no ícone.';

  @override
  String get desktopHintTrayTitle => 'O VidHoist continua aberto';

  @override
  String get desktopHints => 'Mostrar dicas';

  @override
  String get desktopHintsAgain => 'Mostrar de novo';

  @override
  String get desktopHintsHint =>
      'Duas dicas curtas, cada uma mostrada uma vez: os atalhos no primeiro clipe, o ícone ao lado do relógio ao fechar pela primeira vez.';

  @override
  String get desktopImportFromPhone => 'Importar um backup ou transcrições…';

  @override
  String get desktopImportHint =>
      'Um arquivo de backup ou de transcrições do VidHoist, escolhido aqui ou solto na janela. O de um celular é somado ao que já está aqui; um backup deste computador é restaurado por inteiro, depois de perguntar.';

  @override
  String desktopImportedBackup(int tagged, int lists, int positions) {
    return 'Adicionado do celular. Tags: $tagged · listas: $lists · pontos de retomada: $positions';
  }

  @override
  String get desktopImportedNothing =>
      'Nada novo: este computador já tinha tudo.';

  @override
  String desktopImportedTranscripts(int count) {
    return 'Transcrições adicionadas: $count';
  }

  @override
  String desktopInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count na sua biblioteca',
      one: '1 na sua biblioteca',
    );
    return '$_temp0';
  }

  @override
  String get desktopKeepAwake => 'Manter o computador ativo durante downloads';

  @override
  String get desktopKeepAwakeHint =>
      'Assim um link enviado do celular, ou uma playlist longa, termina em vez de parar quando o Windows entra em suspensão. A tela continua desligando normalmente.';

  @override
  String get desktopKeyAddLink => 'Adicionar o link que você copiou';

  @override
  String get desktopKeyFavorite => 'Adicionar aos favoritos ou remover';

  @override
  String get desktopKeyFullScreen =>
      'Tela cheia; para áudio, a sala de audição';

  @override
  String get desktopKeyMenu => 'O menu do clipe';

  @override
  String get desktopKeyMini => 'Janela pequena acima das outras, e voltar';

  @override
  String get desktopKeyPlayPause => 'Tocar ou pausar';

  @override
  String get desktopKeyRepeat => 'Mudar repetição';

  @override
  String get desktopKeySearch => 'Buscar títulos e o que foi dito';

  @override
  String get desktopKeySeek => 'Voltar ou avançar 10 segundos';

  @override
  String get desktopKeyShortcuts => 'Esta lista';

  @override
  String get desktopKeyVolume =>
      'Mais alto ou mais baixo; nos Shorts, o anterior ou o próximo';

  @override
  String get desktopKeyZoomIn => 'Interface maior';

  @override
  String get desktopKeyZoomOut => 'Interface menor';

  @override
  String get desktopKeyZoomReset => 'Interface no tamanho normal';

  @override
  String get desktopLanguageSystemHint => 'Segue o idioma do Windows.';

  @override
  String desktopLastArrival(String when) {
    return 'Última chegada $when';
  }

  @override
  String get desktopLess => 'Menos';

  @override
  String desktopLibraryDownloading(int count) {
    return '$count baixando';
  }

  @override
  String get desktopLibraryLoading => 'Carregando a biblioteca…';

  @override
  String get desktopLinkCopied => 'Link copiado';

  @override
  String get desktopLinkDuplicate => 'Repetido acima';

  @override
  String get desktopLinkInLibrary => 'Já está na sua biblioteca';

  @override
  String get desktopLinkPlaylist => 'Uma playlist: escolha os clipes';

  @override
  String get desktopLinkReady => 'Pronto';

  @override
  String get desktopLinkUnsupported => 'Um site que este app não conhece';

  @override
  String desktopLinksDropped(int count, int limit) {
    return 'Só os primeiros $limit links são usados; mais $count ficaram de fora.';
  }

  @override
  String desktopLinksFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count links',
      one: '1 link',
    );
    return '$_temp0';
  }

  @override
  String get desktopListeningClose => 'Fechar a sala de audição';

  @override
  String get desktopListeningRoom => 'Sala de audição';

  @override
  String get desktopLogsCopied => 'Registro copiado, sem links nem endereços';

  @override
  String get desktopLogsCopy => 'Copiar';

  @override
  String get desktopLogsSave => 'Salvar em arquivo';

  @override
  String get desktopMiniRestore => 'Voltar à janela completa';

  @override
  String get desktopMiniWindow => 'Janela pequena';

  @override
  String get desktopMore => 'Mais';

  @override
  String get desktopNarrowSidebar => 'Recolher barra lateral';

  @override
  String get desktopNoChannelNames =>
      'Os clipes da sua biblioteca não informam o canal, então os clipes deste canal não podem ser separados. Siga-o com uma pasta própria, e o que chegar lá aparece aqui.';

  @override
  String get desktopNoFavoritesMessage =>
      'Marque um clipe como favorito e ele espera por você aqui.';

  @override
  String get desktopNoFavoritesTitle => 'Nenhum favorito ainda';

  @override
  String get desktopNoMatchMessage => 'Remova um filtro para ver mais.';

  @override
  String get desktopNoMatchTitle => 'Nada corresponde a estes filtros';

  @override
  String get desktopNoTags =>
      'Nenhuma tag ainda. Adicione uma tag a um clipe na página dele e ela aparece aqui.';

  @override
  String get desktopNoTranscriptMessage =>
      'Aparece aqui quando as legendas do clipe forem baixadas com ele.';

  @override
  String get desktopNoTranscriptTitle => 'Este clipe não tem transcrição';

  @override
  String get desktopNotABackup =>
      'Este arquivo não é um backup nem um arquivo de transcrições do VidHoist.';

  @override
  String desktopNotWatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count não assistidos',
      one: '1 não assistido',
    );
    return '$_temp0';
  }

  @override
  String get desktopNothingPlaying => 'Nada tocando';

  @override
  String get desktopNothingPlayingHint =>
      'Toque um clipe e a transcrição, o que vem a seguir e os detalhes dele aparecem aqui.';

  @override
  String get desktopNotifyArrivalsHint =>
      'Um aviso do Windows quando clipes novos dos canais que você segue forem baixados.';

  @override
  String get desktopOfferCopiedLinks => 'Oferecer os links que eu copiar';

  @override
  String get desktopOfferCopiedLinksHint =>
      'Quando você copia um link de vídeo em outro app, uma notificação oferece adicioná-lo. Só links são verificados, e nenhum é salvo.';

  @override
  String get desktopOpenBackup => 'Abrir backup';

  @override
  String get desktopOpenChannels => 'Abrir canais';

  @override
  String get desktopOpenInExplorer => 'Abrir no Explorador';

  @override
  String get desktopOpenWith => 'Abrir em outro player…';

  @override
  String get desktopPaletteClose => 'para fechar';

  @override
  String get desktopPaletteCommands => 'Comandos';

  @override
  String get desktopPaletteHint =>
      'Busque títulos e o que foi dito, ou digite > para comandos';

  @override
  String desktopPaletteList(String name) {
    return 'Lista: $name';
  }

  @override
  String get desktopPaletteMove => 'para mover';

  @override
  String get desktopPaletteOpen => 'para abrir';

  @override
  String get desktopPaletteRecent => 'Tocados recentemente';

  @override
  String get desktopPaletteSaid => 'Dito dentro dos clipes';

  @override
  String get desktopPaletteSave => 'Salvar esta busca';

  @override
  String get desktopPaletteSaved => 'Buscas salvas';

  @override
  String desktopPaletteSettings(String section) {
    return 'Configurações: $section';
  }

  @override
  String get desktopPaletteTitles => 'Títulos';

  @override
  String get desktopPinned => 'Fixados';

  @override
  String get desktopPlayNext => 'Tocar em seguida';

  @override
  String get desktopPlaysNext => 'Toca em seguida, depois deste';

  @override
  String get desktopQueueEnd => 'Não há nada depois deste';

  @override
  String desktopQuote(String text, String title, String time, String link) {
    return '“$text”\n— $title, $time\n$link';
  }

  @override
  String get desktopQuoteCopied => 'Copiado com o tempo e o link';

  @override
  String get desktopReadingBack => 'Voltar ao clipe';

  @override
  String get desktopReadingCloseFind => 'Fechar a busca';

  @override
  String get desktopReadingFind => 'Buscar no texto';

  @override
  String desktopReadingFound(int at, int count) {
    return '$at de $count';
  }

  @override
  String get desktopReadingHint =>
      'Clique numa frase para ouvir a partir dali · Ctrl+F busca uma palavra · selecione para copiar com o tempo';

  @override
  String get desktopReadingNextMatch => 'Próximo resultado';

  @override
  String get desktopReadingPreviousMatch => 'Resultado anterior';

  @override
  String get desktopReadingRoom => 'Sala de leitura';

  @override
  String get desktopRecoverLibrary => 'Clipes que já estão na pasta';

  @override
  String get desktopRecoverLibraryAction => 'Procurar na pasta';

  @override
  String get desktopRecoverLibraryHint =>
      'Depois de reinstalar: devolve à biblioteca os clipes que estão na pasta de downloads mas não aparecem mais na lista. Os arquivos não são alterados.';

  @override
  String desktopRecovered(int count) {
    return 'Devolvidos à biblioteca: $count';
  }

  @override
  String get desktopRecoveredNothing =>
      'Nada para adicionar: todos os clipes da pasta estão na biblioteca.';

  @override
  String desktopRecoveredSome(int count, int left) {
    return 'Devolvidos à biblioteca: $count. Ficaram de fora, sem link conhecido: $left';
  }

  @override
  String get desktopRemoveFromList => 'Remover da lista';

  @override
  String get desktopRestore => 'Restaurar';

  @override
  String get desktopRestoreBody =>
      'A biblioteca, os canais seguidos, as tags, as listas e as configurações deste computador passam a ser os do backup. Os arquivos baixados não são alterados.';

  @override
  String desktopRestoreOfferBody(String when) {
    return 'Downloads\\VidHoist\\Backups tem um backup deste computador: a biblioteca, os canais seguidos, as playlists, as tags, as configurações e as transcrições salvas. O mais recente foi feito $when. Seus arquivos baixados não são alterados em nenhum caso.';
  }

  @override
  String get desktopRestoreOfferTitle => 'Restaurar seu backup?';

  @override
  String get desktopRestoreTitle => 'Restaurar este backup?';

  @override
  String get desktopRestored => 'Backup restaurado';

  @override
  String get desktopRevealAfterDownload => 'Mostrar no Explorador ao terminar';

  @override
  String get desktopRevealAfterDownloadHint =>
      'Quando um arquivo baixado neste computador termina, a pasta dele abre com o arquivo selecionado.';

  @override
  String desktopSavedIn(String folder) {
    return 'Salvo em $folder';
  }

  @override
  String desktopSavedSearchDelete(String name) {
    return 'Excluir a busca salva “$name”? Nada muda na biblioteca.';
  }

  @override
  String get desktopSavedSearchName => 'Nome da busca';

  @override
  String get desktopSearch => 'Buscar';

  @override
  String get desktopSearchHint => 'Busque títulos e o que foi dito…';

  @override
  String get desktopSearchSaved => 'Salva na barra lateral';

  @override
  String get desktopSeekBar => 'Posição no clipe';

  @override
  String desktopSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selecionados',
      one: '1 selecionado',
    );
    return '$_temp0';
  }

  @override
  String get desktopSetupChooseFile => 'Escolher um arquivo…';

  @override
  String get desktopShortcutsApp => 'App';

  @override
  String get desktopShortcutsClip => 'Num clipe escolhido';

  @override
  String get desktopShortcutsPlayback => 'Reprodução';

  @override
  String get desktopShortcutsTitle => 'Atalhos de teclado';

  @override
  String get desktopShortcutsWindow => 'Janela';

  @override
  String get desktopShortsHint =>
      '↑ ↓ ou a roda para o próximo Short · clique duplo para favoritar';

  @override
  String get desktopShowInFolder => 'Mostrar na pasta';

  @override
  String get desktopShowPanel => 'Mostrar painel lateral';

  @override
  String get desktopStartFresh => 'Começar do zero';

  @override
  String get desktopStartWithWindows => 'Iniciar com o Windows';

  @override
  String get desktopStartWithWindowsHint =>
      'Abre quando você entra: na bandeja se continua tocando lá, senão minimizado.';

  @override
  String get desktopStartWithWindowsRefused =>
      'O Windows não deixou o app iniciar com ele.';

  @override
  String get desktopStats => 'Estatísticas da biblioteca';

  @override
  String get desktopStatsByChannel => 'Por canal';

  @override
  String get desktopStatsByMonth => 'Por mês de adição';

  @override
  String get desktopStatsBySite => 'Por site';

  @override
  String get desktopStatsClips => 'Clipes';

  @override
  String get desktopStatsHint =>
      'O que a biblioteca tem, e o que pode merecer uma olhada. Nada é excluído daqui.';

  @override
  String desktopStatsHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count horas',
      one: '1 hora',
      zero: 'Menos de uma hora',
    );
    return '$_temp0';
  }

  @override
  String get desktopStatsLargest => 'Os maiores:';

  @override
  String get desktopStatsLength => 'Duração total';

  @override
  String get desktopStatsLink => 'Estatísticas';

  @override
  String get desktopStatsNeverPlayed => 'Nunca tocados aqui';

  @override
  String get desktopStatsNewest => 'Os mais recentes:';

  @override
  String get desktopStatsOtherChannels => 'Outros canais';

  @override
  String get desktopStatsRoom => 'Espaço ocupado';

  @override
  String get desktopStatsUnnamed => 'Sem canal informado';

  @override
  String get desktopStatsWithText => 'Com transcrição';

  @override
  String get desktopStatsWithoutText => 'Sem transcrição';

  @override
  String get desktopStatsWorthALook => 'Vale uma olhada';

  @override
  String get desktopSubtitleOptions => 'Opções de legenda';

  @override
  String get desktopTheater => 'Teatro';

  @override
  String get desktopTranscriptFirst => 'Obtenha a transcrição primeiro';

  @override
  String get desktopTranscriptHint =>
      'Acompanha a reprodução · clique numa linha para pular';

  @override
  String get desktopTranscriptHintPage =>
      'Transcrição deste clipe · clique numa linha para tocar a partir dela';

  @override
  String get desktopTranscriptsDeleteBody =>
      'Elas são removidas deste computador e do backup dele. Só um arquivo que você exportou pode trazê-las de volta.';

  @override
  String get desktopTranscriptsHelp =>
      'O VidHoist guarda as palavras ditas em cada clipe do YouTube que você adiciona, então uma busca (Ctrl+K) também encontra o que foi dito dentro dos seus clipes, não só os títulos. Elas ficam neste computador.';

  @override
  String get desktopTranscriptsMove => 'Para ou de um celular';

  @override
  String get desktopTranscriptsMoveHint =>
      'As transcrições vão junto com o backup: Exportar para o celular as inclui, e Importar lá as traz, somando o que falta aqui.';

  @override
  String get desktopTrayOnClose =>
      'Continuar tocando na bandeja ao fechar a janela';

  @override
  String get desktopTrayOnCloseHint =>
      'Fechar a janela mantém o som tocando; saia pelo ícone ao lado do relógio.';

  @override
  String get desktopTrayOpen => 'Abrir o VidHoist';

  @override
  String get desktopTrayQuit => 'Sair';

  @override
  String get desktopUiSize => 'Tamanho da interface';

  @override
  String desktopUiSizeHint(String bigger, String smaller, String reset) {
    return '$bigger e $smaller mudam o tamanho de qualquer lugar, e $reset volta para 100%.';
  }

  @override
  String get desktopUiSizeTooLarge => 'Grande demais para esta tela';

  @override
  String get desktopUpdateInstall => 'Instalar e reiniciar';

  @override
  String get desktopUpdateRestartHint =>
      'O VidHoist fecha, instala a atualização e abre de novo. Suas configurações e sua biblioteca continuam como estão.';

  @override
  String get desktopViewCompact => 'Compacta';

  @override
  String get desktopViewTable => 'Tabela';

  @override
  String get desktopVolume => 'Volume';

  @override
  String desktopVolumeLevel(int percent) {
    return 'Volume $percent%';
  }

  @override
  String get desktopWelcomeFetchNow => 'Obter agora';

  @override
  String get desktopWelcomeHelpers =>
      'ffmpeg (junta imagem e som) e Deno (exigido pelo YouTube) são baixados sozinhos no primeiro download, cerca de 160 MB. Se preferir, você pode obtê-los agora.';

  @override
  String get desktopWelcomeMessage =>
      'Cole um link do YouTube ou de outro site, e o VidHoist baixa neste computador com yt-dlp.';

  @override
  String get desktopWelcomeStart => 'Começar';

  @override
  String get desktopWelcomeTitle => 'Boas-vindas ao VidHoist';

  @override
  String get desktopWhatsNewAllFeatures => 'Tudo o que o VidHoist faz';

  @override
  String get desktopWidenSidebar => 'Expandir barra lateral';

  @override
  String get desktopWindowClose => 'Fechar';

  @override
  String get desktopWindowMaximize => 'Maximizar';

  @override
  String get desktopWindowMinimize => 'Minimizar';

  @override
  String get desktopWindowRestore => 'Restaurar tamanho';

  @override
  String get desktopZoomChange => 'Mudar';

  @override
  String desktopZoomLowered(String percent) {
    return 'A interface agora está em $percent para caber nesta tela.';
  }

  @override
  String get details => 'Detalhes';

  @override
  String get developer => 'Desenvolvedor';

  @override
  String get developerName => 'Yasir Sagheer';

  @override
  String get diagnosticLogs => 'Registros de diagnóstico';

  @override
  String get diagnosticLogsSubtitle =>
      'Ver, buscar e compartilhar os registros do app (sem dados sensíveis)';

  @override
  String get disclaimer => 'Aviso legal';

  @override
  String get disclaimerText =>
      'Este app baixa mídia com yt-dlp. O desenvolvedor não se responsabiliza pelo uso que os usuários fazem desta ferramenta. Respeite as leis de direitos autorais e os termos de serviço dos sites de onde você baixa.';

  @override
  String get dismiss => 'Dispensar';

  @override
  String get done => 'Concluído';

  @override
  String get download => 'Baixar';

  @override
  String get downloadComplete => 'Download concluído';

  @override
  String get downloadCompleteTitle => 'Concluído';

  @override
  String get downloadDate => 'Data do download';

  @override
  String get downloadFailed => 'Falha no download';

  @override
  String get downloadFailedTitle => 'Falha no download';

  @override
  String get downloadNow => 'Baixar';

  @override
  String get downloadStarted => 'Download iniciado…';

  @override
  String downloadStartedQuality(Object quality) {
    return 'Download iniciado · $quality';
  }

  @override
  String get downloading => 'Baixando…';

  @override
  String get downloadingTitle => 'Baixando';

  @override
  String get downloadsAdvanced => 'Avançado';

  @override
  String get editSubscription => 'Editar';

  @override
  String get embedSubtitles => 'Legendas também dentro do vídeo';

  @override
  String get embedSubtitlesHelp =>
      'Para que outros players as mostrem. O player do VidHoist as mostra de qualquer forma.';

  @override
  String get emptyFilteredMessage =>
      'Remova um filtro acima para ver toda a sua biblioteca.';

  @override
  String get emptyFilteredTitle => 'Nada corresponde a estes filtros';

  @override
  String get emptyPlaylist => 'Playlist vazia';

  @override
  String get emptyPlaylistMessage => 'Adicione clipes da biblioteca';

  @override
  String engineDownloadingProgress(Object percent) {
    return 'Baixando · $percent%';
  }

  @override
  String get engineErrDiskFull => 'Não há espaço suficiente para este arquivo';

  @override
  String engineErrFailed(Object reason) {
    return 'Falha no download: $reason';
  }

  @override
  String get engineErrFormat =>
      'Esta qualidade não está disponível para este vídeo';

  @override
  String get engineErrGeoBlocked => 'Indisponível no seu país';

  @override
  String get engineErrMissing =>
      'O motor de download está faltando ou incompleto. Repare em Configurações com Reparar o motor';

  @override
  String get engineErrRateLimited =>
      'O site está limitando as solicitações. Tente de novo daqui a pouco';

  @override
  String get engineErrUnavailable =>
      'Este vídeo está indisponível, é privado ou foi removido';

  @override
  String get engineErrUnsupported => 'Este link não é compatível';

  @override
  String get enginePaused => 'Pausado';

  @override
  String get enginePostprocessing => 'Finalizando o arquivo…';

  @override
  String get enginePreparing => 'Lendo o link…';

  @override
  String get engineRepair => 'Reparar o motor';

  @override
  String get engineRepairBusy =>
      'Espere os downloads terminarem e depois repare';

  @override
  String get engineRepairHint =>
      'Quando os downloads falham em vários sites como antes não acontecia, e atualizar não ajudou: apaga o que o yt-dlp salvou e coloca de volta uma cópia limpa e atual. Seus downloads e configurações continuam como estão.';

  @override
  String get engineRepairPartly =>
      'Reparado em parte: o resto precisa de conexão. Tente de novo quando estiver online.';

  @override
  String engineRepaired(String version) {
    return 'Reparado: yt-dlp $version';
  }

  @override
  String get engineRepairing => 'Reparando…';

  @override
  String get engineResume => 'Retomar';

  @override
  String get enterFullscreen => 'Tela cheia';

  @override
  String errClipPastEnd(Object length) {
    return 'A parte começa depois que o vídeo termina ($length)';
  }

  @override
  String get errClipPastEndUnknown =>
      'A parte começa depois que o vídeo termina';

  @override
  String get errNetwork => 'Sem conexão com o site';

  @override
  String get errPlatformBlockedCookies =>
      'O site exige login. Escolha um arquivo de cookies em Configurações › Cookies';

  @override
  String errorGeneric(Object message) {
    return 'Erro: $message';
  }

  @override
  String get every30Minutes => 'A cada 30 minutos';

  @override
  String everyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A cada $count horas',
      one: 'A cada hora',
    );
    return '$_temp0';
  }

  @override
  String get exitFullscreen => 'Sair da tela cheia';

  @override
  String get exportShare => 'Exportar e compartilhar';

  @override
  String get exportShareSubtitle =>
      'Uma cópia datada para enviar ou guardar em outro lugar';

  @override
  String get externalPlayerShort => 'Outro player';

  @override
  String get failed => 'Falhou';

  @override
  String get failedToLoadPlaylist => 'Falha ao carregar a playlist';

  @override
  String get fastStreams => 'Streams segmentados mais rápidos';

  @override
  String fastStreamsHelp(int count) {
    return 'Baixa $count partes de uma vez dos sites que dividem um vídeo em partes, como o X. Alguns sites ficam lentos com muitas solicitações ao mesmo tempo.';
  }

  @override
  String get favorites => 'Favoritos';

  @override
  String get file => 'Arquivo';

  @override
  String get fileSize => 'Tamanho do arquivo';

  @override
  String get filterAll => 'Tudo';

  @override
  String get filterAudio => 'Áudio';

  @override
  String get filterVideo => 'Vídeo';

  @override
  String get filtersOn => 'Filtros ativos';

  @override
  String get folder => 'Pasta';

  @override
  String get foldersHelp =>
      'Uma pasta é criada dentro da pasta de downloads, e o clipe é salvo direto nela, onde o Explorador e qualquer outro app o veem. Deixe em \"Sem pasta\" e o clipe vai para a raiz da pasta de downloads.';

  @override
  String get follow => 'Seguir';

  @override
  String get followChannel => 'Seguir um canal';

  @override
  String get format => 'Formato';

  @override
  String framesPerSecond(int count) {
    return '$count fps';
  }

  @override
  String get helpAboutField => 'Sobre este campo';

  @override
  String get inPlaylists => 'Em playlists';

  @override
  String get invalidUrl => 'Digite um link válido';

  @override
  String get itemOptions => 'Opções do item';

  @override
  String get itemUnavailable => 'Não está mais disponível';

  @override
  String get jumpToNewest => 'Ir para o mais recente';

  @override
  String get justNow => 'agora mesmo';

  @override
  String knownVideos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vídeos conhecidos',
      one: '1 vídeo conhecido',
      zero: 'Nada conhecido ainda',
    );
    return '$_temp0';
  }

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get languageSystemHint => 'Segue o idioma do seu celular';

  @override
  String lastBackup(String when) {
    return 'Último backup $when';
  }

  @override
  String lastCheckedAt(String when) {
    return 'Última verificação $when';
  }

  @override
  String get latestAdditions => 'Adicionados recentemente';

  @override
  String get licensedUnder => 'Licenciado sob GPL-3.0';

  @override
  String get licenses => 'Licenças de código aberto';

  @override
  String get listSeparator => ',';

  @override
  String get listenInBackground => 'Ouvir em segundo plano';

  @override
  String get lockTouch => 'Bloquear toque';

  @override
  String get loginDone => 'Concluído';

  @override
  String loginKept(String site) {
    return 'Conectado em $site; os downloads vão usar esse login';
  }

  @override
  String get loginNotYet =>
      'Nenhum login encontrado ainda. Termine de entrar e toque em Concluído';

  @override
  String get logsEmpty => 'O registro está vazio';

  @override
  String get logsSanitizedNote =>
      'Links, endereços e credenciais são removidos antes de compartilhar';

  @override
  String get manageTags => 'Gerenciar tags';

  @override
  String get mediaAccessBlockedMessage =>
      'O Android não vai perguntar de novo. Ative fotos e vídeos para este app nas configurações do sistema e depois volte.';

  @override
  String get mediaAccessGrant => 'Permitir';

  @override
  String get mediaAccessMessage =>
      'Seus downloads ficam na pasta Download do celular, e o Android precisa da sua permissão para o app poder listá-los.';

  @override
  String get mediaAccessOpenSettings => 'Abrir configurações';

  @override
  String get mediaAccessTitle => 'Permita o acesso à sua mídia';

  @override
  String get mobileChannelsEmptyBody =>
      'Siga um canal e cada vídeo novo é baixado sozinho enquanto o VidHoist está aberto ou em segundo plano; o que chegou enquanto estava fechado é baixado quando ele abre. O que já está no canal não é baixado.';

  @override
  String get mobileChannelsHint =>
      'Vídeos novos dos canais que você segue, baixados sozinhos';

  @override
  String get mobileEngineIpv4 => 'Conectar por IPv4';

  @override
  String get mobileEngineIpv4Help =>
      'Evita uma longa espera em redes cuja rota IPv6 não funciona. Desative só se sua rede tiver apenas IPv6.';

  @override
  String mobileEngineLastUpdate(String when) {
    return 'Última atualização $when';
  }

  @override
  String get mobileEngineNotReady => 'Preparando…';

  @override
  String get mobileEngineUpToDate => 'O yt-dlp está atualizado';

  @override
  String get mobileEngineUpdate => 'Atualizar o yt-dlp';

  @override
  String get mobileEngineUpdateFailed =>
      'Não foi possível atualizar o yt-dlp. Verifique a conexão e tente de novo.';

  @override
  String get mobileEngineUpdateMissed => 'Falha na atualização';

  @override
  String get mobileEngineUpdated => 'Atualizado';

  @override
  String get mobileEngineUpdating => 'Atualizando…';

  @override
  String get mobileEngineVersionLabel => 'Versão do yt-dlp';

  @override
  String get mobileEngineVersionUnknown =>
      'A versão aparece depois da primeira atualização';

  @override
  String get mobileSettingsEngine => 'Motor de download';

  @override
  String get mobileSettingsGroupEngine => 'Motor';

  @override
  String get mobileSignInNeeded =>
      'Este site quer que você entre. Entre em Configurações › Contas e tente de novo';

  @override
  String get mobileSubtitleOptions => 'Tamanho, fundo e a transcrição';

  @override
  String get mobileSubtitleStyleHelp => 'Também no player: segure o botão CC.';

  @override
  String get mobileSubtitles => 'Baixar legendas';

  @override
  String get mobileSubtitlesHelp =>
      'Legendas nos idiomas abaixo, quando o vídeo tiver, salvas junto dele e mostradas no player.';

  @override
  String get mobileSubtitlesSizeLarger => 'Maior';

  @override
  String get mobileTranscript => 'Transcrição';

  @override
  String get mobileTranscriptHint =>
      'Toque numa linha para tocar a partir dali.';

  @override
  String get mobileTranscriptOpen => 'Ler a transcrição';

  @override
  String get mobileWelcomeBody =>
      'Vídeos e áudios dos sites que você usa, salvos direto neste celular. O motor de download está sendo preparado; isso acontece só uma vez.';

  @override
  String get mobileWelcomeFailed =>
      'O motor não conseguiu iniciar. Tente de novo; se continuar falhando, reinstale o app.';

  @override
  String get mobileWelcomeStart => 'Começar';

  @override
  String get mobileWelcomeTitle => 'Boas-vindas ao VidHoist';

  @override
  String get mobileWelcomeUnpacking => 'Preparando o motor de download';

  @override
  String get mobileWelcomeUpdateFailed =>
      'Não foi possível atualizar agora. O VidHoist tenta de novo antes do seu primeiro download.';

  @override
  String get mobileWelcomeUpdating =>
      'Atualizando o yt-dlp para a versão mais recente';

  @override
  String get modeAutoNext => 'Auto';

  @override
  String get modeRepeatAll => 'Repetir tudo';

  @override
  String get modeRepeatOne => 'Repetir um';

  @override
  String get modeStopAtEnd => 'Parar no fim';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navMyDownloads => 'Meus downloads';

  @override
  String get navPlaylists => 'Playlists';

  @override
  String get navSettings => 'Configurações';

  @override
  String get needsAttention => 'Precisa da sua atenção';

  @override
  String get neverChecked => 'Ainda não verificado';

  @override
  String get newFolder => 'Nova pasta…';

  @override
  String get newFolderHint => 'ex.: IA/Aulas';

  @override
  String get newPlaylistAction => 'Nova playlist';

  @override
  String get newTagHint => 'Nova tag';

  @override
  String newVideosBody(String channels) {
    return '$channels. Eles são baixados quando você abrir o VidHoist.';
  }

  @override
  String newVideosNotice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vídeos novos',
      one: '$count vídeo novo',
    );
    return '$_temp0';
  }

  @override
  String get next => 'Próximo';

  @override
  String get noBackupsYet => 'Nenhum backup ainda';

  @override
  String get noDownloads => 'Nenhum download';

  @override
  String get noDownloadsMessage =>
      'Os clipes baixados aparecem aqui.\nCompartilhe um link ou use o botão Adicionar link.';

  @override
  String get noExternalPlayer => 'Nenhum player externo neste aparelho';

  @override
  String get noFolder => 'Sem pasta';

  @override
  String get noFolderHint => 'Na raiz dos downloads';

  @override
  String get noLogsFound => 'Nenhum registro encontrado';

  @override
  String get noPlayableSource => 'Este item não tem uma fonte reproduzível';

  @override
  String get noPlaylistsMessage =>
      'Crie uma playlist para organizar seus clipes';

  @override
  String get noResults => 'Nenhum resultado';

  @override
  String get noResultsMessage => 'Nenhum item corresponde à sua busca.';

  @override
  String get noServerTitle => 'O motor de download não está pronto';

  @override
  String get noticeChannelNewVideos => 'Vídeos novos';

  @override
  String get noticeChannelUpdates => 'Atualizações';

  @override
  String get noVideosFound => 'Sua biblioteca está vazia';

  @override
  String get noWarranty => 'Fornecido como está, sem nenhuma garantia.';

  @override
  String get notAffiliated =>
      'Sem vínculo com o yt-dlp nem com nenhum site, e sem o endosso deles.';

  @override
  String get nothingHereYet => 'Nada aqui ainda';

  @override
  String get notificationClipGone => 'Este clipe não está mais no celular.';

  @override
  String get nowPlaying => 'Tocando agora';

  @override
  String get nowPlayingCollapse => 'Recolher o painel do player';

  @override
  String get nowPlayingExpand => 'Mostrar o painel do player';

  @override
  String get ok => 'OK';

  @override
  String get onlyNewVideos =>
      'Só o que aparecer a partir de agora é baixado. Os vídeos que já estão no canal ficam onde estão.';

  @override
  String get openChannel => 'Abrir canal';

  @override
  String get openInExternalPlayer => 'Abrir em outro player';

  @override
  String get openOriginalLink => 'Abrir link original';

  @override
  String get ownFolder => 'Salvar em uma pasta própria';

  @override
  String get ownFolderNote =>
      'Uma pasta dentro da pasta de downloads, que o Explorador e outros apps também veem. Só o que chegar a partir de agora vai para lá; o que já foi baixado fica onde está.';

  @override
  String get pasteUrlHint => 'Cole o link aqui…';

  @override
  String get pause => 'Pausar';

  @override
  String get pauseSubscription => 'Pausar';

  @override
  String get pcAddressLabel => 'Endereço';

  @override
  String get pcBadAddress =>
      'Digite o endereço como o computador mostra, por exemplo 192.168.1.24.';

  @override
  String get pcBadQr => 'Este não é um QR code de vinculação do VidHoist.';

  @override
  String get pcCertificate => 'Certificado do computador';

  @override
  String get pcCodeLabel => 'Código';

  @override
  String get pcConnected => 'Conectado';

  @override
  String get pcCopied =>
      'Copiado para a biblioteca do celular, com as legendas.';

  @override
  String get pcCopyFailed =>
      'A cópia não terminou: o computador pode estar desligado ou fora de alcance. Nada foi guardado.';

  @override
  String get pcCopyStarting => 'Copiando…';

  @override
  String get pcCopyStop => 'Parar a cópia';

  @override
  String get pcCopyToPhone => 'Copiar para o celular';

  @override
  String pcCopying(int percent) {
    return 'Copiando $percent%';
  }

  @override
  String get pcDelete => 'Excluir do computador';

  @override
  String pcDeleteBody(String title) {
    return '\"$title\" vai para a Lixeira do computador, de onde pode ser recuperado.';
  }

  @override
  String get pcDeleteFailed =>
      'O computador não conseguiu excluir. Talvez esteja aberto lá.';

  @override
  String get pcDeleteMissing => 'Este clipe não está mais no computador.';

  @override
  String get pcDeleteNoBin =>
      'Não excluído: a unidade dele no computador não tem Lixeira.';

  @override
  String get pcDeleteNotAllowed =>
      'O computador não deixa o celular excluir. Ative isso lá em Configurações › Celular.';

  @override
  String pcDeleteTitle(String name) {
    return 'Excluir de $name?';
  }

  @override
  String pcDeleted(String title) {
    return 'Na Lixeira do computador: $title';
  }

  @override
  String get pcDestPhone => 'Este celular';

  @override
  String pcDoneOnPc(String title) {
    return 'Concluído no computador: $title';
  }

  @override
  String pcDownloadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count downloads para o computador',
      one: '1 download para o computador',
    );
    return '$_temp0';
  }

  @override
  String get pcDownloadsSheet => 'Downloads no computador';

  @override
  String get pcEmptyLibrary => 'Nenhum download no computador ainda.';

  @override
  String get pcErrBad =>
      'O computador respondeu de um jeito que esta versão não entende. Atualize os dois apps.';

  @override
  String get pcErrClosed =>
      'Nenhum código está aparecendo no computador, ou ele expirou. Clique em Vincular um celular lá.';

  @override
  String get pcErrDenied =>
      'A vinculação foi recusada no computador, ou não foi respondida a tempo.';

  @override
  String get pcErrRefused => 'O computador não aceitou este link.';

  @override
  String get pcErrUnauthorized =>
      'O computador não reconhece mais este celular. Vincule de novo.';

  @override
  String get pcErrUnreachable =>
      'O computador não respondeu. Ele está ligado, nesta rede ou no seu Tailscale, com \"Receber do celular\" ativado?';

  @override
  String get pcErrWrongCertificate =>
      'Algo que não é o seu computador respondeu neste endereço. Nada foi enviado.';

  @override
  String get pcErrWrongCode => 'Código errado.';

  @override
  String get pcFindNone =>
      'Nenhum computador encontrado. No computador, abra primeiro Configurações › Celular › Vincular um celular, na mesma rede Wi-Fi.';

  @override
  String get pcFindOnNetwork => 'Procurar na rede';

  @override
  String get pcFirewallAllow => 'Permitir';

  @override
  String get pcFirewallBlocked =>
      'O Firewall do Windows bloqueia o VidHoist, então o celular não consegue alcançá-lo. Permita em redes domésticas (privadas).';

  @override
  String get pcFirewallMissing =>
      'O Windows ainda não deixou o VidHoist receber do celular. Permita uma vez, só em redes domésticas (privadas).';

  @override
  String get pcFirewallPublic =>
      'O Windows chama esta rede de Pública e não deixa nada entrar. Se for sua rede doméstica, torne-a Privada: Configurações › Rede e Internet › Wi-Fi › propriedades dela.';

  @override
  String get pcFirewallRefused =>
      'Nada mudou: o Windows precisa da permissão de um administrador.';

  @override
  String get pcFirewallTitle => 'Firewall do Windows';

  @override
  String pcFound(String name) {
    return '$name encontrado. Digite o código que ele mostra.';
  }

  @override
  String pcFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count encontrados',
      one: '1 encontrado',
    );
    return '$_temp0';
  }

  @override
  String pcLastContact(String time) {
    return 'Último contato $time';
  }

  @override
  String get pcLibrary => 'Biblioteca no computador';

  @override
  String get pcLinkAddress => 'Endereço nesta rede';

  @override
  String get pcLinkAddressTailscale => 'Pelo Tailscale, fora de casa';

  @override
  String get pcLinkAllow => 'Permitir';

  @override
  String get pcLinkAllowDelete => 'Deixar o celular excluir clipes';

  @override
  String get pcLinkAllowDeleteHint =>
      'Um clipe excluído pelo celular vai para a Lixeira deste computador, de onde você pode recuperá-lo. Numa unidade sem Lixeira ele não é excluído.';

  @override
  String get pcLinkCodeHint =>
      'No celular: Configurações › Computador › Ler o QR code. Ou digite lá este endereço e este código. Funciona uma vez, por dois minutos.';

  @override
  String pcLinkCodeLeft(int seconds) {
    return 'Faltam $seconds s';
  }

  @override
  String get pcLinkCodeTitle => 'Código de vinculação';

  @override
  String get pcLinkDeny => 'Recusar';

  @override
  String get pcLinkDevices => 'Celulares vinculados';

  @override
  String pcLinkFailed(String error) {
    return 'Não foi possível iniciar: $error';
  }

  @override
  String get pcLinkIntro =>
      'Envie links do VidHoist no seu celular para este computador, e veja os downloads e a biblioteca dele lá. Funciona dentro da sua rede doméstica, e de fora dela pelo Tailscale.';

  @override
  String pcLinkLastSeen(String time) {
    return 'Último sinal $time';
  }

  @override
  String get pcLinkNoDevices => 'Nenhum celular ainda.';

  @override
  String get pcLinkOff => 'Desativado';

  @override
  String pcLinkOtherAddresses(int count) {
    return 'Outros endereços ($count)';
  }

  @override
  String get pcLinkOtherAddressesHint =>
      'Adaptadores de rede que outros programas adicionam, como VirtualBox ou WSL. O celular raramente precisa deles.';

  @override
  String get pcLinkPairPhone => 'Vincular um celular';

  @override
  String pcLinkPairedAt(String time) {
    return 'Vinculado $time';
  }

  @override
  String pcLinkPhones(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count celulares',
      one: 'Um celular',
      zero: 'Nenhum celular',
    );
    return '$_temp0';
  }

  @override
  String get pcLinkQrHint => 'Leia pelo celular';

  @override
  String get pcLinkReceive => 'Receber do celular';

  @override
  String get pcLinkReceiveHint =>
      'Enquanto estiver desativado, nenhuma porta fica aberta neste computador. Se o Windows perguntar, permita só redes privadas.';

  @override
  String pcLinkRequest(String name) {
    return '$name pede para vincular';
  }

  @override
  String get pcLinkRequestHint =>
      'Permita só se o celular mostrar os mesmos quatro dígitos.';

  @override
  String get pcLinkRevoke => 'Desvincular';

  @override
  String get pcLinkSecurity =>
      'O celular fala direto com este computador, na sua rede ou pelo seu Tailscale. Ele é vinculado uma vez, com o código e a sua aprovação aqui; depois disso apresenta a própria chave em cada solicitação, por uma conexão criptografada só com o certificado deste computador. Qualquer outro na rede encontra a porta fechada.';

  @override
  String get pcLinkStarting => 'Iniciando…';

  @override
  String get pcLinkTitle => 'Celular';

  @override
  String get pcListEmpty =>
      'Nenhum dos clipes desta lista está mais no computador.';

  @override
  String get pcListen => 'Ouvir';

  @override
  String get pcLists => 'Listas no computador';

  @override
  String get pcListsEmpty => 'Nenhuma lista do computador tem clipes.';

  @override
  String get pcNow => 'No computador agora';

  @override
  String get pcOffline => 'Indisponível';

  @override
  String get pcOfflineMessage =>
      'O computador está desligado ou em outra rede. O que ele tinha da última vez aparece abaixo.';

  @override
  String get pcOfflineRoute =>
      'Fora de casa? Escolha Tailscale em Configurações › Computador.';

  @override
  String get pcOnPhone => 'No celular';

  @override
  String get pcOrType => 'Ou digite o endereço e o código';

  @override
  String get pcOutboxRefused => 'O computador não aceitou este link';

  @override
  String pcOutboxTitle(int count) {
    return 'Aguardando envio ($count)';
  }

  @override
  String get pcPairButton => 'Vincular';

  @override
  String pcPairCheck(String check) {
    return 'Confira se o computador mostra $check e depois permita o celular lá.';
  }

  @override
  String get pcPairIntro =>
      'Se o VidHoist roda no seu computador com Windows, este celular pode enviar links para ele e mostrar os downloads e a biblioteca dele. No computador, ative Configurações › Celular e clique em Vincular um celular; depois leia o QR code que ele mostra.';

  @override
  String pcPaired(String name) {
    return 'Vinculado a $name';
  }

  @override
  String get pcPortLabel => 'Porta';

  @override
  String pcQueued(String name) {
    return 'Vai para $name quando ele voltar.';
  }

  @override
  String pcQueuedMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clipes vão para $name quando ele voltar.',
      one: '1 clipe vai para $name quando ele voltar.',
    );
    return '$_temp0';
  }

  @override
  String get pcRouteHint =>
      'Escolha Tailscale quando estiver fora de casa; ele precisa estar ativo no celular e no computador.';

  @override
  String get pcRouteHome => 'Rede doméstica';

  @override
  String get pcRouteOther => 'Outra rede';

  @override
  String get pcRouteTailscale => 'Tailscale';

  @override
  String get pcRouteTitle => 'Conectar por';

  @override
  String get pcRouteWaiting =>
      'As outras rotas do computador aparecem aqui quando ele responder.';

  @override
  String get pcScanButton => 'Ler o QR code';

  @override
  String get pcScanFailed => 'Não foi possível abrir a câmera.';

  @override
  String get pcScanPrompt =>
      'Aponte a câmera para o QR code na tela do computador';

  @override
  String get pcSearchHint => 'Buscar na biblioteca do computador';

  @override
  String get pcSendToPc => 'Enviar para o computador';

  @override
  String pcSent(String name) {
    return 'Enviado para $name';
  }

  @override
  String pcSentMany(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clipes enviados para $name',
      one: '1 clipe enviado para $name',
    );
    return '$_temp0';
  }

  @override
  String get pcSettingsHint => 'Envie links para o seu computador';

  @override
  String get pcTab => 'Computador';

  @override
  String pcVia(String route) {
    return 'Por $route';
  }

  @override
  String get pcWatch => 'Assistir';

  @override
  String get pcWillSend => 'Ausente: enviado quando ele voltar';

  @override
  String get pickAnotherFile => 'De outro arquivo…';

  @override
  String get pickAnotherFileSubtitle =>
      'Um backup de outro celular ou de uma versão anterior';

  @override
  String get pictureInPicture => 'Picture-in-picture';

  @override
  String get pictureInPictureHelp =>
      'Quando você sai do app enquanto um clipe toca, ele fica num canto da tela';

  @override
  String get pinPlaylist => 'Fixar no topo';

  @override
  String get platform => 'Site';

  @override
  String platformCount(Object name, int count) {
    return '$name · $count';
  }

  @override
  String get platformOther => 'Outro';

  @override
  String get play => 'Tocar';

  @override
  String get playAll => 'Tocar tudo';

  @override
  String get playModeLabel => 'Modo';

  @override
  String get playbackSpeed => 'Velocidade de reprodução';

  @override
  String get playerError => 'Não foi possível tocar este arquivo';

  @override
  String get playingFromDevice => 'Tocando do seu aparelho';

  @override
  String get playlist => 'Playlist';

  @override
  String get playlistAddClips => 'Adicionar clipes';

  @override
  String playlistAddClipsTo(String name) {
    return 'Adicionar a “$name”';
  }

  @override
  String playlistAddCount(int count) {
    return 'Adicionar ($count)';
  }

  @override
  String get playlistCreated => 'Playlist criada';

  @override
  String get playlistDeleted => 'Playlist excluída';

  @override
  String get playlistDetails => 'Detalhes da playlist';

  @override
  String get playlistEditHint =>
      'Toque e segure um clipe para movê-lo. Deslize-o para o lado para removê-lo.';

  @override
  String get playlistName => 'Nome da playlist';

  @override
  String get playlistNameHint => 'Minha playlist';

  @override
  String playlistOf(int current, int total) {
    return '$current / $total';
  }

  @override
  String get playlists => 'Playlists';

  @override
  String get previous => 'Anterior';

  @override
  String get quality => 'Qualidade';

  @override
  String get quality1080 => 'Até 1080p';

  @override
  String get quality360 => 'Até 360p';

  @override
  String get quality480 => 'Até 480p';

  @override
  String get quality720 => 'Até 720p';

  @override
  String get qualityAudio => 'Áudio';

  @override
  String get qualityBest => 'Melhor';

  @override
  String get qualityHelper =>
      'Usada pelo download rápido, pelos downloads de playlists inteiras e pelo \"Baixar\" na barra da área de transferência, e é a opção pré-selecionada na folha de adicionar link. Então importa com o download rápido ativado ou não.';

  @override
  String get qualityReading => 'Lendo o arquivo…';

  @override
  String get qualityUnavailable => 'Indisponível';

  @override
  String get qualityVideo => 'Vídeo';

  @override
  String queueItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
      zero: 'Nenhum item',
    );
    return '$_temp0';
  }

  @override
  String get queueLabel => 'Fila';

  @override
  String queuePosition(int position) {
    return 'Número $position na fila';
  }

  @override
  String get queued => 'Na fila';

  @override
  String get queuedSection => 'Aguardando';

  @override
  String get quickDownload => 'Download rápido';

  @override
  String get quickDownloadHelp =>
      'Um link compartilhado ou colado começa a baixar na hora, na qualidade padrão, sem folha. Um site que não tem essa qualidade entrega a melhor que tiver, e \"Só áudio\" funciona em todos os sites.';

  @override
  String get rateLimit => 'Limite de velocidade';

  @override
  String get rateLimitNone => 'Sem limite';

  @override
  String rateLimitValue(int mb) {
    return '$mb MB/s';
  }

  @override
  String get reelsEndBack => 'Voltar à biblioteca';

  @override
  String get reelsEndContinue => 'Continuar o resto da lista';

  @override
  String get reelsEndReplay => 'Repetir do início';

  @override
  String get reelsEndTitle => 'Fim dos Shorts';

  @override
  String get reelsSwipeHint => 'Deslize para cima para o próximo Short';

  @override
  String get refresh => 'Atualizar';

  @override
  String get remove => 'Remover';

  @override
  String get removeFromFavorites => 'Remover dos favoritos';

  @override
  String removeUnavailable(int count) {
    return 'Remover $count indisponíveis';
  }

  @override
  String get removedFromFavorites => 'Removido dos favoritos';

  @override
  String get removedFromPlaylist => 'Removido da playlist';

  @override
  String get rename => 'Renomear';

  @override
  String get renameTag => 'Renomear tag';

  @override
  String get reportBug => 'Relatar um bug';

  @override
  String get restoreConfirm =>
      'Restaurar os dados do arquivo de backup? Isso substitui as playlists, as tags e as configurações atuais.';

  @override
  String get restoreData => 'Restaurar';

  @override
  String get restoreFailed =>
      'Falha ao restaurar: o arquivo de backup não é válido';

  @override
  String get restorePickBody =>
      'Este celular tem downloads do VidHoist mas nenhuma configuração, como depois de reinstalar. Se você guardou um backup, escolha-o: o app os grava em Download/VidHoist/backups.';

  @override
  String get restorePickChoose => 'Escolher um backup';

  @override
  String get restorePickTitle => 'Recuperar suas configurações?';

  @override
  String get restoreSettings => 'Restaurar todos os dados';

  @override
  String get restoreSuccess => 'Dados restaurados com sucesso';

  @override
  String get resumeSubscription => 'Retomar';

  @override
  String get retry => 'Tentar de novo';

  @override
  String get saveSettings => 'Salvar configurações';

  @override
  String get searchLogs => 'Buscar nos registros…';

  @override
  String get searchVideos => 'Buscar clipes…';

  @override
  String get seekBackward10 => 'Voltar 10 segundos';

  @override
  String get seekForward10 => 'Avançar 10 segundos';

  @override
  String get selectAll => 'Selecionar tudo';

  @override
  String selected(int count) {
    return '$count selecionados';
  }

  @override
  String selectedCount(int count) {
    return '$count selecionados';
  }

  @override
  String get settings => 'Configurações';

  @override
  String get settingsAccounts => 'Contas';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get settingsDownloads => 'Downloads';

  @override
  String get settingsGroupApp => 'App';

  @override
  String get settingsGroupData => 'Dados';

  @override
  String get settingsPlayback => 'Reprodução';

  @override
  String get settingsTranscripts => 'Transcrições e legendas';

  @override
  String settingsValueChannels(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canais',
      one: '1 canal',
      zero: 'Nenhum canal ainda',
    );
    return '$_temp0';
  }

  @override
  String get settingsValueCompatOff => 'Máxima compatibilidade: desativada';

  @override
  String get settingsValueCompatOn => 'Máxima compatibilidade: ativada';

  @override
  String get settingsValueNotSet => 'Ainda não configurado';

  @override
  String get settingsValueQuick => 'rápido';

  @override
  String settingsValueSignedIn(String sites) {
    return 'Conectado: $sites';
  }

  @override
  String get settingsValueWifiOnly => 'Só Wi‑Fi';

  @override
  String get share => 'Compartilhar';

  @override
  String get shareLogs => 'Compartilhar registros';

  @override
  String get shareOpening => 'Abrindo o menu de compartilhamento…';

  @override
  String get shareOpeningHint =>
      'Um arquivo grande leva alguns segundos para ser entregue.';

  @override
  String get shareSelected => 'Compartilhar selecionados';

  @override
  String get sharedLinksAdd => 'Adicionar';

  @override
  String get sharedLinksBody => 'Cada um é baixado neste celular.';

  @override
  String sharedLinksCapped(int max) {
    return 'Só os primeiros $max links foram adicionados.';
  }

  @override
  String sharedLinksTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Adicionar $count links?',
      one: 'Adicionar 1 link?',
    );
    return '$_temp0';
  }

  @override
  String get shortsFilter => 'Shorts';

  @override
  String get shuffle => 'Aleatório';

  @override
  String get signInRequired => 'Login necessário';

  @override
  String get size => 'Tamanho';

  @override
  String get smartPlaylists => 'Playlists inteligentes';

  @override
  String get sortAndPlatform => 'Ordem e site';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortLargest => 'Maiores';

  @override
  String get sortNameAZ => 'Nome A–Z';

  @override
  String get sortNameZA => 'Nome Z–A';

  @override
  String get sortNewest => 'Mais recentes';

  @override
  String get sortOldest => 'Mais antigos';

  @override
  String get sortSmallest => 'Menores';

  @override
  String get sortedByLastPlayed => 'Por último tocado';

  @override
  String get source => 'Fonte';

  @override
  String get sourceCode => 'Código-fonte';

  @override
  String get starAskBody =>
      'Gratuito e de código aberto, sem anúncios e sem conta. Uma estrela no GitHub ajuda outras pessoas a encontrá-lo.';

  @override
  String get starAskIdeas => 'Sugerir uma ideia ou relatar um problema';

  @override
  String get starAskLater => 'Talvez depois';

  @override
  String get starAskNever => 'Não mostrar novamente';

  @override
  String get starAskStar => 'Dar uma estrela no GitHub';

  @override
  String get starAskTitle => 'Está gostando do VidHoist?';

  @override
  String get startDownload => 'Iniciar download';

  @override
  String get status => 'Status';

  @override
  String get storageCardMissing =>
      'O cartão não está inserido, então os downloads vão para o celular';

  @override
  String get storageLocation => 'Salvar em';

  @override
  String get storageLocationHelp =>
      'Os clipes já baixados ficam onde estão e continuam aparecendo na biblioteca. Um cartão de memória precisa do Android 11 ou mais recente.';

  @override
  String get storageNoCard => 'Nenhum cartão de memória neste celular';

  @override
  String get storagePhone => 'Armazenamento do celular';

  @override
  String get streamingOnline => 'Tocando pela rede';

  @override
  String subscriptionAdded(String name) {
    return 'Agora você segue $name';
  }

  @override
  String get subscriptionName => 'Nome';

  @override
  String get subscriptionPaused => 'Pausado';

  @override
  String get subscriptionQuality => 'Qualidade para este canal';

  @override
  String get subscriptionQualityHelp =>
      'A qualidade em que os vídeos novos deste canal são baixados. Você pode mudar depois editando o canal; os vídeos já baixados mantêm a deles.\n\n\"Melhor\" pode significar 4K no formato AV1, que um computador mais antigo pode tocar travando: se acontecer, escolha 1080p.';

  @override
  String get subscriptionQualityNote =>
      'Vale para vídeos novos; os já baixados mantêm a deles.';

  @override
  String get subscriptions => 'Canais';

  @override
  String get subscriptionsEmpty => 'Nenhum canal seguido ainda';

  @override
  String get subscriptionsEmptyBody =>
      'Siga um canal e cada vídeo novo é baixado sozinho na sua biblioteca, enquanto o VidHoist está aberto ou na bandeja. O que já está no canal não é baixado.';

  @override
  String get subscriptionsSubtitle =>
      'Vídeos novos dos canais que você segue, baixados sozinhos';

  @override
  String get subtitleLangs => 'Idiomas das legendas';

  @override
  String get subtitleLangsHelp =>
      'Obtidas quando o vídeo tem. Pelo menos um fica escolhido.';

  @override
  String get subtitles => 'Legendas';

  @override
  String get subtitlesBackground => 'Fundo';

  @override
  String get subtitlesBackgroundFaint => 'Leve';

  @override
  String get subtitlesBackgroundHelp =>
      'O que fica atrás das palavras. Sem fundo, cada letra mantém uma borda escura para continuar legível sobre uma imagem clara.';

  @override
  String get subtitlesBackgroundNone => 'Nenhum';

  @override
  String get subtitlesBackgroundSolid => 'Escuro';

  @override
  String get subtitlesHide => 'Ocultar legendas';

  @override
  String get subtitlesLanguage => 'Idioma da legenda';

  @override
  String get subtitlesShow => 'Mostrar legendas';

  @override
  String get subtitlesShowHelp =>
      'Sobre o vídeo, nos clipes que têm transcrição. O botão CC do player faz o mesmo.';

  @override
  String get subtitlesSize => 'Tamanho do texto';

  @override
  String get subtitlesSizeLarge => 'Grande';

  @override
  String get subtitlesSizeMedium => 'Médio';

  @override
  String get subtitlesSizeSmall => 'Pequeno';

  @override
  String tagLimitReached(int max) {
    return 'Você pode ter até $max tags. Remova uma em Gerenciar tags para adicionar outra.';
  }

  @override
  String get tags => 'Tags';

  @override
  String get tagsOpenFiltered => 'Abre a biblioteca filtrada';

  @override
  String get theme => 'Tema';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get titleFilter => 'Só baixar títulos que contenham';

  @override
  String get titleFilterHelp =>
      'Um vídeo novo deste canal só é baixado se o título contiver o que você escrever aqui.\n\n• Uma palavra simples basta: Episódio\n• Qualquer uma de várias palavras: Episódio|Parte (o | significa \"ou\")\n• Maiúsculas não importam: episódio também corresponde a Episódio.\n\nUm vídeo que o filtro pula conta como visto para sempre: remover o filtro depois baixa o que vier, não o que foi pulado.';

  @override
  String get titleFilterHelper =>
      'Várias palavras: separe com | . Deixe vazio para tudo.';

  @override
  String get titleFilterHint => 'ex.: Episódio';

  @override
  String get titleLabel => 'Título';

  @override
  String totalDuration(Object duration) {
    return 'Total: $duration';
  }

  @override
  String get transcript => 'Transcrição';

  @override
  String transcriptSaidMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dito mais $count vezes',
      one: 'Dito mais uma vez',
    );
    return '$_temp0';
  }

  @override
  String transcriptsClips(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clipes',
      one: '1 clipe',
      zero: 'Nenhum clipe ainda',
    );
    return '$_temp0';
  }

  @override
  String get transcriptsDeleteAll => 'Excluir tudo';

  @override
  String get transcriptsDeleteTitle => 'Excluir todas as transcrições?';

  @override
  String get transcriptsSaidInside => 'Dito dentro dos clipes';

  @override
  String get transcriptsSearchHelp =>
      'Guarda as palavras de cada clipe do YouTube que você adiciona, para você buscar o que foi dito.';

  @override
  String get tryAgain => 'Tentar de novo';

  @override
  String get undo => 'Desfazer';

  @override
  String get unfollow => 'Deixar de seguir';

  @override
  String unfollowConfirm(String name) {
    return 'Deixar de seguir $name?';
  }

  @override
  String get unfollowConfirmBody =>
      'O VidHoist esquece quais vídeos já viu neste canal. Se você seguir de novo mais tarde, tudo o que houver nele até lá conta como visto, e o que você perdeu não é preenchido. Pausar mantém essa memória.';

  @override
  String get unlockTouch => 'Desbloquear';

  @override
  String get unpinPlaylist => 'Desafixar';

  @override
  String get updateNoticeBody => 'Abra o VidHoist para instalar.';

  @override
  String get upNext => 'A seguir';

  @override
  String upNextIn(String name) {
    return 'A seguir em «$name»';
  }

  @override
  String get updateAllowInstallBody =>
      'O Android precisa da sua permissão para o app instalar as próprias atualizações. Conceda uma vez nas configurações do sistema e depois toque em Instalar de novo.';

  @override
  String get updateAllowInstallTitle => 'Permitir instalar atualizações';

  @override
  String get updateAvailable => 'Atualização disponível';

  @override
  String get updateCheckFailed => 'Não foi possível verificar atualizações';

  @override
  String get updateChecking => 'Verificando…';

  @override
  String get updateDownloadFailed => 'Não foi possível baixar a atualização';

  @override
  String updateDownloadedMb(String done, String total) {
    return '$done de $total MB';
  }

  @override
  String get updateDownloading => 'Baixando atualização…';

  @override
  String get updateFailedToStart => 'Não foi possível abrir o instalador';

  @override
  String get updateInstall => 'Instalar';

  @override
  String get updateLater => 'Depois';

  @override
  String get updateNever => 'Agora não';

  @override
  String get updateNow => 'Baixar atualização';

  @override
  String get updateOpenSystemSettings => 'Abrir configurações';

  @override
  String get updateReady => 'Pronta para instalar';

  @override
  String updateSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get updateSkipVersion => 'Pular esta versão';

  @override
  String get updateUpToDate => 'Você está na versão mais recente';

  @override
  String updateVersionAvailable(String version) {
    return 'A versão $version está disponível';
  }

  @override
  String updateVersionTitle(String version) {
    return 'Versão $version';
  }

  @override
  String get updateWhatsNew => 'Novidades';

  @override
  String get updates => 'Atualizações';

  @override
  String get version => 'Versão';

  @override
  String get videoAdded => 'Adicionado à playlist';

  @override
  String get videoPlayer => 'Player de vídeo';

  @override
  String get viewAll => 'Ver tudo';

  @override
  String get viewAllInPlaylists => 'Ver tudo';

  @override
  String get viewCards => 'Cartões';

  @override
  String get viewGrid => 'Grade';

  @override
  String get viewList => 'Lista';

  @override
  String get viewMode => 'Visualização';

  @override
  String get waitingForWifi => 'Aguardando Wi-Fi';

  @override
  String get whatsNewGotIt => 'Entendi';

  @override
  String get whatsNewReleasePage => 'Página da versão';

  @override
  String get whatsNewThisVersion => 'Novidades desta versão';

  @override
  String whatsNewTitle(String version) {
    return 'Novidades da $version';
  }

  @override
  String get whatsNewUnavailable =>
      'O que mudou nesta versão está na página da versão.';

  @override
  String get wifiOnly => 'Baixar só pelo Wi-Fi';

  @override
  String get wifiOnlyHelp =>
      'Nada é baixado pelos dados móveis. Os downloads esperam o Wi-Fi, e um em andamento quando o Wi-Fi cai é pausado e continua sozinho quando ele volta.';

  @override
  String get yourPlaylists => 'Suas playlists';

  @override
  String get yourTags => 'Suas tags';

  @override
  String get ytdlpCredit => 'O downloader que o VidHoist usa';
}
