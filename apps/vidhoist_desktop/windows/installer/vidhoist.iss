; The Vidhoist installer (Inno Setup 6.7).
;
; Built by tool\build-desktop.ps1, which passes the version and the folder
; of the release build:
;   ISCC.exe /DAppVersion=1.2.3 /DCrtDir=... vidhoist.iss
;
; Installs for the current user only, with no administrator rights:
; %LOCALAPPDATA%\Programs\Vidhoist. The app keeps its data elsewhere
; (%APPDATA%\Vidhoist and %LOCALAPPDATA%\Vidhoist), so an update
; never touches it and the uninstaller asks before removing it.

#ifndef AppVersion
  #error Pass the version: ISCC /DAppVersion=x.y.z vidhoist.iss
#endif

; The values below are fixed for good at the first release: Windows knows
; the installed app by its AppId, and the app finds its Start menu shortcut
; and its data folders by its name (lib/identity.dart). A test holds them
; to the app. They are defines only so that a test build can install beside
; the real one without touching it (with NoRelaunch, so it never opens the
; app, which would use the real data).
#ifndef AppName
  #define AppName "VidHoist"
#endif
#ifndef AppIdGuid
  #define AppIdGuid "E0FBCB9C-889B-404E-AB5A-156466DC8CE4"
#endif
#ifndef Scheme
  #define Scheme "vidhoist"
#endif
#define AppExe "vidhoist_desktop.exe"
; Created by the runner while the app is open (windows/runner/main.cpp).
#define RunningMutex "Vidhoist.Running"
; The firewall rule the app adds when the user lets a phone in
; (lib/data/firewall_data.dart); the installer adds none, having no
; administrator rights.
#define FirewallRule "VidHoist phone link"
#define Developer "Yasir Sagheer"
#define ProjectPage "https://github.com/sagheerys/vidhoist"

#ifndef BuildDir
  #define BuildDir "..\..\build\windows\x64\runner\Release"
#endif
; The Visual C++ runtime the app and its plugins link against, shipped
; beside the app so that a computer without it still starts the app: the
; x64 Microsoft.VC143.CRT folder of Visual Studio's redistributables. Not
; System32, which this 32-bit compiler sees as the 32-bit SysWOW64.
; yt-dlp's folder build, put there by tool\fetch-engine.ps1. ffmpeg and
; Deno are not shipped: the app fetches them on first need.
#ifndef ToolsDir
  #define ToolsDir "..\..\tools"
#endif
#ifndef CrtDir
  #error Pass the x64 runtime folder: ISCC /DCrtDir=...\x64\Microsoft.VC143.CRT
#endif

[Setup]
AppId={{{#AppIdGuid}}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#Developer}
AppPublisherURL={#ProjectPage}
AppSupportURL=https://github.com/sagheerys/vidhoist/issues
AppUpdatesURL=https://github.com/sagheerys/vidhoist/releases
AppCopyright=Copyright (C) 2026 {#Developer}
VersionInfoVersion={#AppVersion}
VersionInfoDescription={#AppName} Setup
VersionInfoCompany={#Developer}
VersionInfoCopyright=Copyright (C) 2026 {#Developer}
VersionInfoProductName={#AppName}
VersionInfoProductVersion={#AppVersion}
PrivilegesRequired=lowest
DefaultDirName={autopf}\{#AppName}
DisableProgramGroupPage=yes
; No language question, as today's Windows apps do: the wizard speaks
; Windows' language, English when that is neither of its two, the same
; rule the app follows (Settings changes the app's). Then a welcome page
; with the logo and who makes the app, and the terms and license to
; accept.
ShowLanguageDialog=no
LanguageDetectionMethod=uilanguage
DisableWelcomePage=no
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0
UninstallDisplayName={#AppName}
UninstallDisplayIcon={app}\{#AppExe}
SetupIconFile=..\runner\resources\app_icon.ico
; **Windows is told the icons changed** when the install ends. Explorer keeps
; a desktop shortcut's picture in its own cache, keyed by the program's path,
; which an update does not change: after the new mark (2026-11-11) the Start
; menu showed it and the desktop kept the old one until the cache was
; rebuilt by hand.
ChangesAssociations=yes
WizardStyle=modern dynamic
; Drawn by tool/make_icons.py --windows, one size per display scale.
WizardImageFile=wizard_large_*.bmp
WizardSmallImageFile=wizard_small_*.png
; An update closes the running app (it may be hidden in the tray, where it
; ignores a polite close) and opens it again from [Run].
CloseApplications=force
RestartApplications=no
Compression=lzma2/max
SolidCompression=yes
OutputDir=..\..\build\installer
OutputBaseFilename=Vidhoist-{#AppVersion}-windows-x64-setup

[Languages]
; The license pages are written by tool/make_installer_license.py: a
; preface in each language, then the GNU GPL v3 as it stands.
Name: "english"; MessagesFile: "compiler:Default.isl"; LicenseFile: "license_en.rtf"
Name: "arabic"; MessagesFile: "compiler:Languages\Arabic.isl"; LicenseFile: "license_ar.rtf"
; The languages Inno Setup ships a translation of. Persian, Indonesian,
; Hindi and Urdu install in English; the app itself speaks them.
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"; LicenseFile: "license_es.rtf"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"; LicenseFile: "license_pt.rtf"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"; LicenseFile: "license_fr.rtf"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"; LicenseFile: "license_de.rtf"
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"; LicenseFile: "license_tr.rtf"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"; LicenseFile: "license_ru.rtf"

[Messages]
english.WelcomeLabel2=This will install [name/ver] on your computer.%n%n[name] is free, open-source software by {#Developer} that downloads video and audio to this computer with yt-dlp.%n%nIt is recommended that you close all other applications before continuing.
; The pages on the way, in plainer Arabic than the stock translation.
arabic.SelectLanguageTitle=اختر لغة التثبيت
arabic.SelectLanguageLabel=اختر اللغة التي تريدها أثناء التثبيت.
arabic.ClickNext=انقر «التالي» للمتابعة، أو «إلغاء الأمر» للخروج من التثبيت.
arabic.WelcomeLabel1=مرحباً بك في تثبيت [name]
arabic.WelcomeLabel2=سيُثبَّت [name/ver] على هذا الكمبيوتر.%n%n[name] برنامج حرّ مفتوح المصدر من ياسر صغير، يُنزّل الفيديو والصوت إلى هذا الكمبيوتر بأداة yt-dlp.%n%nيُستحسن أن تغلق البرامج الأخرى قبل المتابعة.
arabic.WizardLicense=الشروط والرخصة
arabic.LicenseLabel=اقرأ المعلومات المهمة التالية قبل المتابعة.
arabic.LicenseLabel3=اقرأ الشروط والرخصة التالية، فلا بد من قبولها قبل متابعة التثبيت.
arabic.LicenseAccepted=&أوافق على الشروط والرخصة
arabic.LicenseNotAccepted=&لا أوافق
arabic.ReadyLabel1=كل شيء جاهز لتثبيت [name] على هذا الكمبيوتر.
arabic.ReadyLabel2a=انقر «تثبيت» للمتابعة، أو «السابق» لمراجعة اختياراتك أو تغييرها.
arabic.ReadyLabel2b=انقر «تثبيت» للمتابعة.
arabic.WizardInstalling=جارٍ التثبيت
arabic.InstallingLabel=انتظر قليلاً ريثما يُثبَّت [name] على هذا الكمبيوتر.
arabic.FinishedHeadingLabel=اكتمل تثبيت [name]
arabic.FinishedLabelNoIcons=ثُبِّت [name] على هذا الكمبيوتر.
arabic.FinishedLabel=ثُبِّت [name] على هذا الكمبيوتر، ويمكنك فتحه من اختصاراته.
arabic.ClickFinish=انقر «إنهاء» لإغلاق التثبيت.
; The welcome names the developer in every language, as in English.
spanish.WelcomeLabel2=Se instalará [name/ver] en este equipo.%n%n[name] es software libre y de código abierto de {#Developer} que descarga vídeo y audio en este equipo con yt-dlp.%n%nSe recomienda cerrar las demás aplicaciones antes de continuar.
brazilianportuguese.WelcomeLabel2=O [name/ver] será instalado neste computador.%n%nO [name] é um software livre e de código aberto de {#Developer} que baixa vídeo e áudio neste computador com o yt-dlp.%n%nRecomenda-se fechar os outros aplicativos antes de continuar.
french.WelcomeLabel2=[name/ver] va être installé sur cet ordinateur.%n%n[name] est un logiciel libre et open source de {#Developer} qui télécharge des vidéos et de l’audio sur cet ordinateur avec yt-dlp.%n%nIl est recommandé de fermer les autres applications avant de continuer.
german.WelcomeLabel2=[name/ver] wird auf diesem Computer installiert.%n%n[name] ist freie Open-Source-Software von {#Developer}, die Videos und Audio mit yt-dlp auf diesen Computer herunterlädt.%n%nEs wird empfohlen, alle anderen Anwendungen zu schließen, bevor du fortfährst.
turkish.WelcomeLabel2=[name/ver] bu bilgisayara kurulacak.%n%n[name], {#Developer} tarafından geliştirilen, yt-dlp ile bu bilgisayara video ve ses indiren özgür ve açık kaynaklı bir yazılımdır.%n%nDevam etmeden önce diğer uygulamaları kapatmanız önerilir.
russian.WelcomeLabel2=На этот компьютер будет установлена программа [name/ver].%n%n[name] — свободная программа с открытым исходным кодом от {#Developer}, которая скачивает видео и аудио на этот компьютер с помощью yt-dlp.%n%nПеред продолжением рекомендуется закрыть все другие приложения.

[CustomMessages]
english.AboutLink=About the developer and the project: github.com/sagheerys/vidhoist
arabic.AboutLink=عن المطوّر والمشروع: github.com/sagheerys/vidhoist
english.AppRunning={#AppName} is still running. Close it, including from its icon by the clock, then click OK.
arabic.AppRunning=ما زال {#AppName} يعمل. أغلقه، ومن أيقونته بجانب الساعة أيضاً، ثم انقر «موافق».
english.DeleteData=Also delete what {#AppName} keeps on this computer: the library list, followed channels, tags, playlists, settings and saved transcripts?%n%nYour downloaded files and the backups in the Backups folder beside them stay, so a reinstall can restore everything.
arabic.DeleteData=هل تحذف أيضاً ما يحفظه {#AppName} على هذا الكمبيوتر: قائمة المكتبة والقنوات المتابَعة والوسوم والقوائم والإعدادات والنصوص المحفوظة؟%n%nتبقى ملفاتك المنزَّلة والنسخ الاحتياطية في مجلد Backups بجانبها، فيستعيد التثبيت التالي كل شيء.
spanish.AboutLink=Sobre el desarrollador y el proyecto: github.com/sagheerys/vidhoist
spanish.AppRunning={#AppName} sigue en ejecución. Ciérralo, también desde su icono junto al reloj, y pulsa Aceptar.
spanish.DeleteData=¿Eliminar también lo que {#AppName} guarda en este equipo: la lista de la biblioteca, los canales seguidos, las etiquetas, las listas de reproducción, los ajustes y las transcripciones guardadas?%n%nTus archivos descargados y las copias de seguridad de la carpeta Backups junto a ellos se conservan, para que una reinstalación pueda restaurarlo todo.
brazilianportuguese.AboutLink=Sobre o desenvolvedor e o projeto: github.com/sagheerys/vidhoist
brazilianportuguese.AppRunning=O {#AppName} ainda está em execução. Feche-o, inclusive pelo ícone ao lado do relógio, e clique em OK.
brazilianportuguese.DeleteData=Excluir também o que o {#AppName} guarda neste computador: a lista da biblioteca, os canais seguidos, as tags, as playlists, as configurações e as transcrições salvas?%n%nSeus arquivos baixados e os backups na pasta Backups ao lado deles são mantidos, para que uma reinstalação possa restaurar tudo.
french.AboutLink=À propos du développeur et du projet : github.com/sagheerys/vidhoist
french.AppRunning={#AppName} est toujours en cours d’exécution. Fermez-le, y compris depuis son icône près de l’horloge, puis cliquez sur OK.
french.DeleteData=Supprimer aussi ce que {#AppName} conserve sur cet ordinateur : la liste de la bibliothèque, les chaînes suivies, les étiquettes, les playlists, les réglages et les transcriptions enregistrées ?%n%nVos fichiers téléchargés et les sauvegardes du dossier Backups à côté d’eux sont conservés, pour qu’une réinstallation puisse tout restaurer.
german.AboutLink=Über den Entwickler und das Projekt: github.com/sagheerys/vidhoist
german.AppRunning={#AppName} läuft noch. Schließe es, auch über sein Symbol neben der Uhr, und klicke dann auf OK.
german.DeleteData=Auch löschen, was {#AppName} auf diesem Computer speichert: die Bibliotheksliste, gefolgte Kanäle, Tags, Playlists, Einstellungen und gespeicherte Transkripte?%n%nDeine heruntergeladenen Dateien und die Sicherungen im Ordner Backups daneben bleiben erhalten, sodass eine Neuinstallation alles wiederherstellen kann.
turkish.AboutLink=Geliştirici ve proje hakkında: github.com/sagheerys/vidhoist
turkish.AppRunning={#AppName} hâlâ çalışıyor. Saatin yanındaki simgesinden de kapatın, ardından Tamam düğmesine tıklayın.
turkish.DeleteData={#AppName} uygulamasının bu bilgisayarda sakladıkları da silinsin mi: kitaplık listesi, takip edilen kanallar, etiketler, oynatma listeleri, ayarlar ve kaydedilen dökümler?%n%nİndirdiğiniz dosyalar ve yanlarındaki Backups klasöründeki yedekler korunur; böylece yeniden kurulum her şeyi geri yükleyebilir.
russian.AboutLink=О разработчике и проекте: github.com/sagheerys/vidhoist
russian.AppRunning={#AppName} всё ещё работает. Закройте его, в том числе через значок рядом с часами, и нажмите OK.
russian.DeleteData=Удалить также то, что {#AppName} хранит на этом компьютере: список библиотеки, отслеживаемые каналы, теги, плейлисты, настройки и сохранённые расшифровки?%n%nСкачанные файлы и резервные копии в папке Backups рядом с ними сохранятся, поэтому при повторной установке всё можно восстановить.

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[InstallDelete]
; The previous version's assets, so none of them outlives the update.
Type: filesandordirs; Name: "{app}\data"
; The engine is replaced whole: a stale file left in its _internal folder
; would be loaded by the new yt-dlp.
Type: filesandordirs; Name: "{app}\tools\yt-dlp"

[Files]
Source: "{#BuildDir}\*"; DestDir: "{app}"; Excludes: "*.pdb,*.lib,*.exp"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#CrtDir}\msvcp140.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#CrtDir}\vcruntime140.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#CrtDir}\vcruntime140_1.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#ToolsDir}\yt-dlp\*"; DestDir: "{app}\tools\yt-dlp"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; The name and the AppUserModelID are the ones the app gives itself, so
; Windows names it in notifications and the media flyout, and groups its
; taskbar button with this shortcut.
Name: "{userprograms}\{#AppName}"; Filename: "{app}\{#AppExe}"; AppUserModelID: "{#AppName}"
Name: "{userdesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; AppUserModelID: "{#AppName}"; Tasks: desktopicon

[Registry]
; vidhoist://add?url=... links, as the browser button sends them.
Root: HKCU; Subkey: "Software\Classes\{#Scheme}"; ValueType: string; ValueName: ""; ValueData: "URL:{#AppName}"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\{#Scheme}"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""
Root: HKCU; Subkey: "Software\Classes\{#Scheme}\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: """{app}\{#AppExe}"",0"
Root: HKCU; Subkey: "Software\Classes\{#Scheme}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#AppExe}"" ""%1"""

[Run]
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent
#ifndef NoRelaunch
; A silent run is an update the app started: open it again.
Filename: "{app}\{#AppExe}"; Flags: nowait; Check: WizardSilent
#endif

[Code]
procedure AboutLinkClick(Sender: TObject);
var
  Code: Integer;
begin
  ShellExecAsOriginalUser('open', '{#ProjectPage}', '', '', SW_SHOWNORMAL, ewNoWait, Code);
end;

// Who makes the app, on the welcome page under its text: a link to the
// project page, where the developer, the source and the issues are.
procedure InitializeWizard();
var
  Link: TNewStaticText;
begin
  Link := TNewStaticText.Create(WizardForm);
  Link.Parent := WizardForm.WelcomePage;
  Link.Caption := CustomMessage('AboutLink');
  Link.Left := WizardForm.WelcomeLabel2.Left;
  Link.Top := WizardForm.WelcomeLabel2.Top + WizardForm.WelcomeLabel2.Height + ScaleY(16);
  Link.Font.Color := clHotLight;
  Link.Font.Style := [fsUnderline];
  Link.Cursor := crHand;
  Link.OnClick := @AboutLinkClick;
end;

function InitializeUninstall(): Boolean;
begin
  Result := True;
  while CheckForMutexes('{#RunningMutex}') do
  begin
    if UninstallSilent() or
      (MsgBox(CustomMessage('AppRunning'), mbError, MB_OKCANCEL) = IDCANCEL) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  Code: Integer;
begin
  if CurUninstallStep <> usPostUninstall then
    Exit;
  // The app's firewall rule would outlive it. Removing it takes an
  // administrator, so Windows asks, and only when the rule is there.
  if Exec(ExpandConstant('{sys}\netsh.exe'), 'advfirewall firewall show rule name="{#FirewallRule}"', '', SW_HIDE, ewWaitUntilTerminated, Code) and (Code = 0) then
    ShellExec('runas', ExpandConstant('{sys}\netsh.exe'), 'advfirewall firewall delete rule name="{#FirewallRule}"', '', SW_HIDE, ewWaitUntilTerminated, Code);
  // "Start with Windows" (launch_at_startup) would otherwise point at a
  // program that is gone.
  RegDeleteValue(HKCU, 'Software\Microsoft\Windows\CurrentVersion\Run', '{#AppName}');
  RegDeleteValue(HKCU, 'Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run', '{#AppName}');
  // No is the default: a silent uninstall, or Enter, keeps the data.
  if not UninstallSilent() and
    (MsgBox(CustomMessage('DeleteData'), mbConfirmation, MB_YESNO or MB_DEFBUTTON2) = IDYES) then
  begin
    DelTree(ExpandConstant('{userappdata}\{#AppName}'), True, True, True);
    DelTree(ExpandConstant('{localappdata}\{#AppName}'), True, True, True);
  end;
end;
