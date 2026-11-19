"""Writes the installer's license pages from the repository's LICENSE.

Each language gets a short preface in its own words (the terms in plain
language, the privacy line, where the third-party licenses are, who makes
the app), then the GNU GPL v3 itself, in English, which is the text that
binds. RTF rather than text so the Arabic preface reads right to left while
the license under it reads left to right.

Run after changing a preface:
    python tool/make_installer_license.py
A test checks that the pages still carry LICENSE word for word.
"""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / 'apps' / 'vidhoist_desktop' / 'windows' / 'installer'

DEVELOPER = {'en': 'Yasir Sagheer', 'ar': 'ياسر صغير'}
PAGE = 'https://github.com/sagheerys/vidhoist'
SOURCE = 'https://github.com/sagheerys/vidhoist'

def licenses_path(lang: str) -> str:
    """Settings > About > Open-source licenses, in the words the app uses
    in [lang], read from its translation."""
    arb = json.loads((ROOT / f'packages/vh_ui/lib/src/l10n/app_{lang}.arb')
                     .read_text(encoding='utf-8'))
    return ' › '.join(arb[key] for key in ('settings', 'about', 'licenses'))


PREFACE = {
    'en': [
        ('h', 'Terms of use and license'),
        ('p', 'VidHoist is free, open-source software by '
              f'{DEVELOPER["en"]}. It downloads video and audio with yt-dlp, '
              'on this computer.'),
        ('b', 'License: the GNU General Public License, version 3, below. '
              'You may use, copy, change and share the program under its '
              'terms.'),
        ('b', 'No warranty: the program comes as it is, without any '
              'warranty, as sections 15 and 16 of the license say.'),
        ('b', 'Your privacy: the program collects nothing about you and '
              'sends nothing about you anywhere. It talks to the sites your '
              'clips come from (to download them, their pictures and '
              'transcripts) and to GitHub (to check for updates).'),
        ('b', 'Content: you are responsible for what you download, and for '
              "respecting its owners' rights and the terms of the sites it "
              'comes from.'),
        ('b', 'Third-party libraries and their licenses: in the app, under '
              'Settings › About › Open-source licenses.'),
        ('p', f'Developer: {DEVELOPER["en"]}'),
        ('l', f'Project page: {PAGE}'),
        ('l', f'Source and issues: {SOURCE}'),
    ],
    'ar': [
        ('h', 'شروط الاستخدام والرخصة'),
        ('p', 'VidHoist برنامج حرّ مفتوح المصدر من '
              f'{DEVELOPER["ar"]}، ينزّل الفيديو والصوت بـyt-dlp على هذا الكمبيوتر.'),
        ('b', 'الرخصة: رخصة جنو العمومية العامة، الإصدار الثالث (GNU GPL v3)، '
              'ونصها أدناه. لك أن تستعمل البرنامج وتنسخه وتعدّله وتنشره '
              'بشروطها، والنص الإنجليزي هو المعتمد.'),
        ('b', 'بلا ضمان: يُقدَّم البرنامج كما هو، دون أي ضمان، كما تنص '
              'المادتان 15 و16 من الرخصة.'),
        ('b', 'خصوصيتك: لا يجمع البرنامج أي بيانات عنك ولا يرسلها إلى أي '
              'جهة. يتصل بالمواقع التي تأتي منها مقاطعك لتنزيلها وجلب صورها '
              'ونصوصها، وبـGitHub للتحقق من التحديثات.'),
        ('b', 'المحتوى: أنت المسؤول عمّا تنزّله، وعن احترام حقوق أصحابه '
              'وشروط المواقع التي يأتي منها.'),
        ('b', 'مكتبات الطرف الثالث ورخصها: في البرنامج نفسه، من الإعدادات '
              '› عن التطبيق › تراخيص البرمجيات مفتوحة المصدر.'),
        ('p', f'المطوّر: {DEVELOPER["ar"]}'),
        ('l', f'صفحة المشروع: {PAGE}'),
        ('l', f'المصدر والبلاغات: {SOURCE}'),
    ],
    'es': [
        ('h', 'Condiciones de uso y licencia'),
        ('p', 'VidHoist es software libre y de código abierto de '
              f'{DEVELOPER["en"]}. Descarga vídeo y audio con yt-dlp en este '
              'equipo.'),
        ('b', 'Licencia: la Licencia Pública General de GNU, versión 3, que '
              'figura a continuación. Puedes usar, copiar, modificar y '
              'compartir el programa según sus términos; el texto en inglés '
              'es el que tiene validez.'),
        ('b', 'Sin garantía: el programa se ofrece tal cual, sin ninguna '
              'garantía, como indican las secciones 15 y 16 de la licencia.'),
        ('b', 'Tu privacidad: el programa no recopila nada sobre ti ni lo '
              'envía a ningún sitio. Se conecta a los sitios de los que '
              'proceden tus clips (para descargarlos, con sus imágenes y '
              'transcripciones) y a GitHub (para buscar actualizaciones).'),
        ('b', 'Contenido: eres responsable de lo que descargas y de respetar '
              'los derechos de sus propietarios y las condiciones de los '
              'sitios de los que procede.'),
        ('b', 'Bibliotecas de terceros y sus licencias: en la aplicación, en '
              f'{licenses_path("es")}.'),
        ('p', f'Desarrollador: {DEVELOPER["en"]}'),
        ('l', f'Página del proyecto: {PAGE}'),
        ('l', f'Código fuente e incidencias: {SOURCE}'),
    ],
    'pt': [
        ('h', 'Termos de uso e licença'),
        ('p', 'O VidHoist é um software livre e de código aberto de '
              f'{DEVELOPER["en"]}. Ele baixa vídeo e áudio com o yt-dlp neste '
              'computador.'),
        ('b', 'Licença: a Licença Pública Geral GNU, versão 3, reproduzida '
              'abaixo. Você pode usar, copiar, modificar e compartilhar o '
              'programa nos termos dela; o texto em inglês é o que vale.'),
        ('b', 'Sem garantia: o programa é fornecido como está, sem nenhuma '
              'garantia, como dizem as seções 15 e 16 da licença.'),
        ('b', 'Sua privacidade: o programa não coleta nada sobre você nem '
              'envia nada sobre você a lugar nenhum. Ele se conecta aos sites '
              'de onde vêm seus clipes (para baixá-los, com suas imagens e '
              'transcrições) e ao GitHub (para verificar atualizações).'),
        ('b', 'Conteúdo: você é responsável pelo que baixa e por respeitar '
              'os direitos dos donos e os termos dos sites de onde vem.'),
        ('b', 'Bibliotecas de terceiros e suas licenças: no aplicativo, em '
              f'{licenses_path("pt")}.'),
        ('p', f'Desenvolvedor: {DEVELOPER["en"]}'),
        ('l', f'Página do projeto: {PAGE}'),
        ('l', f'Código-fonte e problemas: {SOURCE}'),
    ],
    'fr': [
        ('h', 'Conditions d’utilisation et licence'),
        ('p', 'VidHoist est un logiciel libre et open source de '
              f'{DEVELOPER["en"]}. Il télécharge des vidéos et de l’audio avec '
              'yt-dlp, sur cet ordinateur.'),
        ('b', 'Licence : la Licence publique générale GNU, version 3, '
              'ci-dessous. Vous pouvez utiliser, copier, modifier et partager '
              'le programme selon ses termes ; seul le texte anglais fait foi.'),
        ('b', 'Aucune garantie : le programme est fourni tel quel, sans aucune '
              'garantie, comme le disent les articles 15 et 16 de la licence.'),
        ('b', 'Votre vie privée : le programme ne collecte rien à votre sujet '
              'et n’envoie rien à votre sujet nulle part. Il se connecte aux '
              'sites d’où viennent vos clips (pour les télécharger, avec leurs '
              'images et transcriptions) et à GitHub (pour vérifier les mises '
              'à jour).'),
        ('b', 'Contenu : vous êtes responsable de ce que vous téléchargez, '
              'ainsi que du respect des droits de ses propriétaires et des '
              'conditions des sites d’où il provient.'),
        ('b', 'Bibliothèques tierces et leurs licences : dans l’application, '
              f'sous {licenses_path("fr")}.'),
        ('p', f'Développeur : {DEVELOPER["en"]}'),
        ('l', f'Page du projet : {PAGE}'),
        ('l', f'Code source et signalements : {SOURCE}'),
    ],
    'de': [
        ('h', 'Nutzungsbedingungen und Lizenz'),
        ('p', 'VidHoist ist freie Open-Source-Software von '
              f'{DEVELOPER["en"]}. Es lädt Videos und Audio mit yt-dlp auf '
              'diesen Computer herunter.'),
        ('b', 'Lizenz: die GNU General Public License, Version 3, unten. Du '
              'darfst das Programm nach ihren Bedingungen nutzen, kopieren, '
              'ändern und weitergeben; maßgeblich ist der englische Text.'),
        ('b', 'Keine Gewährleistung: Das Programm wird so bereitgestellt, wie '
              'es ist, ohne jede Gewährleistung, wie es die Abschnitte 15 und '
              '16 der Lizenz sagen.'),
        ('b', 'Deine Privatsphäre: Das Programm sammelt nichts über dich und '
              'sendet nichts über dich irgendwohin. Es verbindet sich mit den '
              'Seiten, von denen deine Clips stammen (um sie mit ihren Bildern '
              'und Transkripten herunterzuladen), und mit GitHub (um nach '
              'Updates zu suchen).'),
        ('b', 'Inhalte: Du bist verantwortlich für das, was du herunterlädst, '
              'und dafür, die Rechte der Eigentümer und die Bedingungen der '
              'Seiten zu achten, von denen es stammt.'),
        ('b', 'Bibliotheken von Drittanbietern und ihre Lizenzen: in der App '
              f'unter {licenses_path("de")}.'),
        ('p', f'Entwickler: {DEVELOPER["en"]}'),
        ('l', f'Projektseite: {PAGE}'),
        ('l', f'Quellcode und Fehlermeldungen: {SOURCE}'),
    ],
    'tr': [
        ('h', 'Kullanım koşulları ve lisans'),
        ('p', f'VidHoist, {DEVELOPER["en"]} tarafından geliştirilen özgür ve '
              'açık kaynaklı bir yazılımdır. Bu bilgisayarda yt-dlp ile video '
              've ses indirir.'),
        ('b', 'Lisans: aşağıdaki GNU Genel Kamu Lisansı, sürüm 3. Programı bu '
              'lisansın koşullarına göre kullanabilir, kopyalayabilir, '
              'değiştirebilir ve paylaşabilirsiniz; geçerli olan İngilizce '
              'metindir.'),
        ('b', 'Garanti yok: Program, lisansın 15. ve 16. bölümlerinde '
              'belirtildiği gibi, hiçbir garanti olmaksızın olduğu gibi sunulur.'),
        ('b', 'Gizliliğiniz: Program sizinle ilgili hiçbir şey toplamaz ve '
              'hiçbir yere göndermez. Yalnızca kliplerinizin geldiği sitelere '
              '(onları resimleri ve dökümleriyle indirmek için) ve GitHub\'a '
              '(güncellemeleri denetlemek için) bağlanır.'),
        ('b', 'İçerik: İndirdiğiniz içerikten, sahiplerinin haklarına ve '
              'geldiği sitelerin koşullarına uymaktan siz sorumlusunuz.'),
        ('b', 'Üçüncü taraf kitaplıklar ve lisansları: uygulamada, '
              f'{licenses_path("tr")} bölümünde.'),
        ('p', f'Geliştirici: {DEVELOPER["en"]}'),
        ('l', f'Proje sayfası: {PAGE}'),
        ('l', f'Kaynak kod ve sorun bildirimleri: {SOURCE}'),
    ],
    'ru': [
        ('h', 'Условия использования и лицензия'),
        ('p', 'VidHoist — свободная программа с открытым исходным кодом от '
              f'{DEVELOPER["en"]}. Она скачивает видео и аудио на этот '
              'компьютер с помощью yt-dlp.'),
        ('b', 'Лицензия: Стандартная общественная лицензия GNU, версия 3, '
              'приведённая ниже. Вы можете использовать, копировать, изменять '
              'и распространять программу на её условиях; юридическую силу '
              'имеет английский текст.'),
        ('b', 'Без гарантий: программа предоставляется «как есть», без '
              'каких-либо гарантий, как сказано в разделах 15 и 16 лицензии.'),
        ('b', 'Ваша конфиденциальность: программа ничего о вас не собирает и '
              'никуда ничего о вас не отправляет. Она обращается к сайтам, с '
              'которых берутся ваши клипы (чтобы скачать их вместе с '
              'изображениями и расшифровками), и к GitHub (чтобы проверить '
              'обновления).'),
        ('b', 'Содержимое: вы отвечаете за то, что скачиваете, а также за '
              'соблюдение прав владельцев и условий сайтов, с которых оно '
              'берётся.'),
        ('b', 'Сторонние библиотеки и их лицензии: в приложении, в разделе '
              f'{licenses_path("ru")}.'),
        ('p', f'Разработчик: {DEVELOPER["en"]}'),
        ('l', f'Страница проекта: {PAGE}'),
        ('l', f'Исходный код и сообщения об ошибках: {SOURCE}'),
    ],
}


def escape(text: str) -> str:
    """RTF for plain text: braces and backslashes escaped, anything past
    ASCII as a Unicode escape with a question mark for old readers."""
    out = []
    for ch in text:
        code = ord(ch)
        if ch in '\\{}':
            out.append('\\' + ch)
        elif code > 127:
            out.append(f'\\u{code if code < 32768 else code - 65536}?')
        else:
            out.append(ch)
    return ''.join(out)


def page(lang: str, license_text: str) -> str:
    rtl = lang == 'ar'
    para = r'\pard\rtlpar\qr' if rtl else r'\pard\ltrpar\ql'
    run = r'\rtlch\f1' if rtl else r'\ltrch\f0'
    lines = [
        r'{\rtf1\ansi\ansicpg1252\deff0\uc1'
        r'{\fonttbl{\f0\fswiss\fcharset0 Segoe UI;}'
        r'{\f1\fswiss\fcharset178 Segoe UI;}'
        r'{\f2\fmodern\fcharset0 Consolas;}}',
        r'\viewkind4',
    ]
    for kind, text in PREFACE[lang]:
        body = escape(text)
        if kind == 'h':
            lines.append(f'{para}\\sa160{run}\\fs24\\b {body}\\b0\\par')
        elif kind == 'b':
            lines.append(f'{para}\\sa100{run}\\fs19 \\u8226? {body}\\par')
        elif kind == 'l':
            lines.append(f'{para}\\sa40{run}\\fs19 {body}\\par')
        else:
            lines.append(f'{para}\\sa120{run}\\fs19 {body}\\par')
    lines.append(r'\pard\ltrpar\ql\sa0\ltrch\f0\fs19\par')
    # The license as it is, line for line, left to right whatever the
    # wizard's language.
    for line in license_text.split('\n'):
        lines.append(r'\pard\ltrpar\ql\sa0\ltrch\f2\fs16 ' + escape(line) + r'\par')
    lines.append('}')
    return '\r\n'.join(lines) + '\r\n'


def main() -> None:
    license_text = (ROOT / 'LICENSE').read_text(encoding='utf-8').replace('\r\n', '\n').rstrip('\n')
    for lang in PREFACE:
        target = OUT / f'license_{lang}.rtf'
        target.write_bytes(page(lang, license_text).encode('ascii'))
        print('wrote', target.relative_to(ROOT))


if __name__ == '__main__':
    main()
