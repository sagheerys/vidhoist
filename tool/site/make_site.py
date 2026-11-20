"""Builds the project page: one template, in English and in Arabic.

The page is made of what the repository already holds: the screenshots and
the download animation in docs/screenshots, the launcher icon, the app's
own fonts, and its icons from packages/vh_ui. Nothing is fetched from
another site when the page opens: no font service, no counter, no script
from elsewhere, as the apps themselves promise. GitHub Pages serves what
this writes:

    python tool/site/make_site.py            # writes build/site/

The workflow `.github/workflows/pages.yml` runs it on every change to main.
"""
import html
import os
import re
import shutil

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
OUT = os.path.join(ROOT, 'build', 'site')
REPO = 'https://github.com/sagheerys/vidhoist'
RELEASES = REPO + '/releases/latest'
# Opens Obtainium on a phone that has it, with this repository filled in.
OBTAINIUM = ('https://apps.obtainium.imranr.dev/redirect'
             '?r=obtainium://add/' + REPO)
PAGE = 'https://sagheerys.github.io/vidhoist/'

SHOTS = [
    'hero', 'desktop', 'more', 'tablet', 'desktop-night',
]
FONTS = [
    'NotoSans-Regular.ttf', 'NotoSans-Medium.ttf', 'NotoSans-Bold.ttf',
    'Tajawal-Regular.ttf', 'Tajawal-Medium.ttf', 'Tajawal-Bold.ttf',
]


def icon(name):
    """An icon of the app's set as inline SVG: its ink follows the text,
    its ember the accent, as in the app."""
    source = open(os.path.join(ROOT, 'packages', 'vh_ui', 'lib', 'src',
                               'icons', 'vh_icons.dart'),
                  encoding='utf-8').read()
    found = re.search(r'static const ' + name +
                      r" = VhIconData\(\s*'[^']+',\s*r'''(<svg.*?</svg>)'''",
                      source, re.S)
    svg = found.group(1)
    svg = re.sub(r'(stroke|fill)="\{ember\}"', r'style="\1:var(--accent)"', svg)
    svg = svg.replace('{ink}', 'currentColor')
    return svg.replace('<svg ', '<svg aria-hidden="true" ', 1)


# The words of the page, in each language. The order of the features is
# the README's.
WORDS = {
    'en': {
        'dir': 'ltr',
        'title': 'VidHoist: video and audio from the web, kept and searchable',
        'description': ('Download video and audio to your Android phone or '
                        'Windows computer with yt-dlp built in, and find any '
                        'clip by what was said in it. Free, open source, no '
                        'account, no ads, no tracking.'),
        'nav': ['Features', 'Screens', 'Download'],
        'other': ('العربية', 'ar/'),
        'kicker': 'For Android and Windows · free software',
        'headline': 'Keep the video.<br>Find what was <em>said</em>.',
        'lede': ('Paste or share a link, pick a quality, and the file is '
                 'yours: in a library that plays it, shows its subtitles, '
                 'reads its transcript along with you, and finds the clip '
                 'by any word spoken in it.'),
        'cta_android': 'Get it for Android',
        'cta_windows': 'Get it for Windows',
        'promise': 'No account · No server · No ads · No tracking',
        'flow_title': 'A download, start to finish',
        'flow': [
            ('Paste or share', 'From YouTube, TikTok or any app: the add '
             'button notices a link already copied.'),
            ('Pick a quality', 'Best, a ceiling from 1080p down, the sound '
             'alone, or only a part of the video.'),
            ('It is yours', 'Saved with its cover and subtitles, in a library '
             'on your own device.'),
        ],
        'gif_alt': ('A link pasted into VidHoist, Up to 1080p picked, the '
                    'download filling its card, and the clip arriving at '
                    'the top of the library'),
        'features_title': 'Everything in one app, on each device',
        'features': [
            ('search', 'Search by what was said',
             'The library finds a clip by any word spoken in it, lights the '
             'word in each moment, and plays from that second.'),
            ('download', 'Any site yt-dlp knows',
             'At the quality you choose, or the sound alone, or only a part '
             'of the video, with subtitles in the languages you pick.'),
            ('music', 'Players made for reading along',
             'Video with its transcript under it, music that keeps playing '
             'in the background, shorts, picture in picture.'),
            ('monitor', 'Download on the computer',
             'Pair once by QR code; the phone sends links to Windows, watches '
             'them download, and plays the computer\'s library.'),
            ('subscriptions', 'Follow channels',
             'Windows downloads each new video by itself; the phone checks '
             'while closed and tells you what is new.'),
            ('globe', 'Twelve languages',
             'Right-to-left first, by day and by night, on phones, tablets '
             'and Windows, following the device\'s own language.'),
            ('shield', 'Private by design',
             'No account and no server of ours. Sign-ins stay on the phone; '
             'backups move between the phone and the computer.'),
            ('refresh', 'Looks after itself',
             'yt-dlp updates and repairs itself, and the apps update from '
             'this project\'s releases, checked before they install.'),
        ],
        'screens_title': 'See it on every screen',
        'screens': {
            'hero': ('On the phone', 'The library, a video with its subtitles, '
                     'the music player at night with its transcript, and the '
                     'followed channels.'),
            'desktop': ('On Windows', 'A video with its transcript beside it, '
                        'and the library as a grid of covers.'),
            'more': ('The players and the computer', 'The music player by day, '
                     'the paired computer\'s library on the phone, a video at '
                     'night, and the twelve languages.'),
            'tablet': ('On a tablet', 'Sideways, the library with the "Now '
                       'playing" panel beside it; upright, the library at '
                       'night with the rail.'),
            'desktop-night': ('Windows at night', 'A video with its '
                              'transcript, and the music player.'),
        },
        'privacy_title': 'What you download stays between you and the site.',
        'privacy': ('VidHoist talks to the sites you download from, to GitHub '
                    'to check for an update, and to your own computer if you '
                    'pair it. Nothing else: no account, no analytics, no '
                    'server of the project\'s own.'),
        'download_title': 'Download',
        'download_lede': ('From the latest release on GitHub. Both apps check '
                          'for a new release and offer it in place.'),
        'files': [
            ('phone', 'Android', 'arm64-v8a APK',
             'Almost every phone and tablet from the last ten years. '
             'Android 7.0 or later.'),
            ('phone', 'Android (older)', 'armeabi-v7a APK',
             'Older 32-bit devices.'),
            ('monitor', 'Windows', 'x64 installer',
             'Windows 10 and 11, 64-bit.'),
        ],
        'get': 'Latest release',
        'signed': 'The APKs are signed with VidHoist\'s own key. SHA-256:',
        'obtainium': ('On Android, Obtainium can also follow the releases '
                      'here and install each new one.'),
        'obtainium_alt': 'Get it on Obtainium',
        'source': 'Source code',
        'license': ('Free software under the GPL-3.0. VidHoist stands on '
                    'yt-dlp and FFmpeg, and is not affiliated with them or '
                    'with any site. Download only what you have the right '
                    'to.'),
        'made': '© 2026 Yasir Sagheer',
    },
    'ar': {
        'dir': 'rtl',
        'title': 'VidHoist: الفيديو والصوت من الإنترنت، محفوظان وتجدهما بما قيل فيهما',
        'description': ('نزّل الفيديو والصوت إلى جوالك بأندرويد أو كمبيوترك '
                        'بويندوز بمحرّك yt-dlp داخل التطبيق، وجد أي مقطع بما '
                        'قيل فيه. مجاني ومفتوح المصدر، بلا حساب ولا إعلانات '
                        'ولا تتبّع.'),
        'nav': ['المزايا', 'الشاشات', 'التنزيل'],
        'other': ('English', '../'),
        'kicker': 'لأندرويد وويندوز · برنامج حر',
        'headline': 'احتفظ بالمقطع.<br>وجده بما <em>قيل</em> فيه.',
        'lede': ('الصق الرابط أو شاركه، واختر الجودة، فيصير الملف لك: في '
                 'مكتبة تشغّله، وتعرض ترجمته، وتقرأ نصّه معك، وتجد المقطع '
                 'بأي كلمة نُطقت فيه.'),
        'cta_android': 'نزّله لأندرويد',
        'cta_windows': 'نزّله لويندوز',
        'promise': 'بلا حساب · بلا سيرفر · بلا إعلانات · بلا تتبّع',
        'flow_title': 'تنزيل من أوله إلى آخره',
        'flow': [
            ('الصق أو شارك', 'من يوتيوب أو تيك توك أو أي تطبيق، وزر الإضافة '
             'يلتقط الرابط المنسوخ من قبل.'),
            ('اختر الجودة', 'الأفضل، أو حدّ أعلى من 1080p فما دون، أو الصوت '
             'وحده، أو جزء من المقطع فقط.'),
            ('صار لك', 'يُحفظ بغلافه وترجمته، في مكتبة على جهازك أنت.'),
        ],
        'gif_alt': ('رابط يُلصق في VidHoist، واختيار «حتى 1080p»، والتنزيل '
                    'يملأ بطاقته، ثم المقطع في أعلى المكتبة'),
        'features_title': 'كل شيء في تطبيق واحد، على كل جهاز',
        'features': [
            ('search', 'ابحث بما قيل',
             'تجد المكتبة المقطع بأي كلمة نُطقت فيه، وتضيء الكلمة في كل '
             'لحظة، وتشغّل من تلك الثانية.'),
            ('download', 'أي موقع يعرفه yt-dlp',
             'بالجودة التي تختارها، أو الصوت وحده، أو جزء من المقطع، مع '
             'ترجمته باللغات التي تختارها.'),
            ('music', 'مشغّلات للقراءة مع الاستماع',
             'فيديو ونصّه تحته، وموسيقى تستمر في الخلفية، والقِصار، وصورة '
             'داخل صورة.'),
            ('monitor', 'نزّل على الكمبيوتر',
             'اربطهما مرة برمز QR، فيرسل الجوال الروابط إلى ويندوز، ويتابع '
             'تنزيلها، ويشغّل مكتبة الكمبيوتر.'),
            ('subscriptions', 'تابع القنوات',
             'ويندوز ينزّل كل فيديو جديد وحده، والجوال يفحصها وهو مغلق '
             'ويخبرك بالجديد.'),
            ('globe', 'اثنتا عشرة لغة',
             'من اليمين إلى اليسار أولاً، نهاراً وليلاً، على الجوالات '
             'والأجهزة اللوحية وويندوز، ويتبع لغة جهازك.'),
            ('shield', 'الخصوصية من الأساس',
             'بلا حساب ولا سيرفر لنا. تسجيل الدخول يبقى على الجوال، والنسخ '
             'الاحتياطية تنتقل بين الجوال والكمبيوتر.'),
            ('refresh', 'يعتني بنفسه',
             'yt-dlp يحدّث نفسه ويصلحها، والتطبيقان يتحدّثان من إصدارات '
             'المشروع بعد التحقق منها قبل التثبيت.'),
        ],
        'screens_title': 'على كل شاشة',
        'screens': {
            'hero': ('على الجوال', 'المكتبة، ومقطع بترجمته، ومشغّل الموسيقى '
                     'ليلاً بنصّه، والقنوات المتابَعة.'),
            'desktop': ('على ويندوز', 'مقطع ونصّه بجانبه، والمكتبة شبكةً من '
                        'الأغلفة.'),
            'more': ('المشغّلات والكمبيوتر', 'مشغّل الموسيقى نهاراً، ومكتبة '
                     'الكمبيوتر المقترن على الجوال، ومقطع ليلاً، واللغات '
                     'الاثنتا عشرة.'),
            'tablet': ('على جهاز لوحي', 'أفقياً، المكتبة ولوحة «قيد التشغيل» '
                       'بجانبها؛ وعمودياً ليلاً، المكتبة مع الشريط الجانبي.'),
            'desktop-night': ('ويندوز ليلاً', 'مقطع ونصّه، ومشغّل الموسيقى.'),
        },
        'privacy_title': 'ما تنزّله يبقى بينك وبين الموقع.',
        'privacy': ('يتصل VidHoist بالمواقع التي تنزّل منها، وبـ GitHub '
                    'ليفحص التحديث، وبكمبيوترك إن ربطته. لا شيء غير ذلك: بلا '
                    'حساب، بلا إحصاءات، بلا سيرفر للمشروع.'),
        'download_title': 'التنزيل',
        'download_lede': ('من آخر إصدار على GitHub. يفحص التطبيقان الإصدار '
                          'الجديد ويعرضانه في مكانهما.'),
        'files': [
            ('phone', 'أندرويد', 'APK ‏arm64-v8a',
             'كل جوال وجهاز لوحي تقريباً من السنوات العشر الأخيرة. أندرويد '
             '7.0 فما فوق.'),
            ('phone', 'أندرويد (قديم)', 'APK ‏armeabi-v7a',
             'الأجهزة القديمة بنظام 32-بت.'),
            ('monitor', 'ويندوز', 'مثبّت x64', 'ويندوز 10 و11، 64-بت.'),
        ],
        'get': 'آخر إصدار',
        'signed': 'ملفات APK موقّعة بمفتاح VidHoist الخاص. بصمة SHA-256:',
        'obtainium': ('وعلى أندرويد يستطيع Obtainium أيضاً أن يتابع الإصدارات '
                      'هنا ويثبّت كل جديد منها.'),
        'obtainium_alt': 'احصل عليه عبر Obtainium',
        'source': 'الكود المصدري',
        'license': ('برنامج حر برخصة GPL-3.0. يقوم VidHoist على yt-dlp '
                    'وFFmpeg، ولا صلة له بهما ولا بأي موقع. نزّل فقط ما يحق '
                    'لك تنزيله.'),
        'made': '© 2026 ياسر صغير',
    },
}

FINGERPRINT = ('93:CF:C4:66:1F:3F:42:92:24:F5:85:D3:F8:6A:96:D2:72:06:21:DB:'
               '90:64:A1:A0:13:41:88:F7:2B:A5:3B:F2')


def page(lang):
    w = WORDS[lang]
    up = '../' if lang == 'ar' else ''
    a = up + 'assets/'
    e = html.escape
    features = '\n'.join(
        f'''      <li class="feature">
        <span class="feature-icon">{icon(name)}</span>
        <h3>{e(title)}</h3>
        <p>{e(text)}</p>
      </li>''' for name, title, text in w['features'])
    flow = '\n'.join(
        f'''        <li><span class="step">{i + 1}</span><div><h3>{e(t)}</h3>
          <p>{e(p)}</p></div></li>''' for i, (t, p) in enumerate(w['flow']))
    screens = '\n'.join(
        f'''      <figure class="shot shot-{name}">
        <img src="{a}img/{name}-{lang}.jpg" loading="lazy" alt="{e(w['screens'][name][0] + ': ' + w['screens'][name][1])}">
        <figcaption><strong>{e(w['screens'][name][0])}</strong> {e(w['screens'][name][1])}</figcaption>
      </figure>''' for name in SHOTS)
    files = '\n'.join(
        f'''      <a class="file" href="{RELEASES}">
        <span class="file-icon">{icon(kind)}</span>
        <span class="file-name">{e(name)}</span>
        <span class="file-kind">{e(kind_label)}</span>
        <span class="file-note">{e(note)}</span>
      </a>''' for kind, name, kind_label, note in w['files'])
    nav = w['nav']
    return f'''<!doctype html>
<html lang="{lang}" dir="{w['dir']}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{e(w['title'])}</title>
<meta name="description" content="{e(w['description'])}">
<meta name="theme-color" content="#2457D6">
<meta property="og:type" content="website">
<meta property="og:title" content="VidHoist">
<meta property="og:description" content="{e(w['description'])}">
<meta property="og:image" content="{PAGE}assets/img/hero-{lang}.jpg">
<meta property="og:url" content="{PAGE}{'ar/' if lang == 'ar' else ''}">
<meta name="twitter:card" content="summary_large_image">
<link rel="icon" href="{a}icon.png">
<link rel="alternate" hreflang="en" href="{PAGE}">
<link rel="alternate" hreflang="ar" href="{PAGE}ar/">
<link rel="stylesheet" href="{a}site.css">
</head>
<body>
<header class="bar">
  <div class="wrap bar-in">
    <a class="brand" href="./"><img src="{a}icon.png" width="32" height="32" alt=""><span>VidHoist</span></a>
    <nav>
      <a href="#features">{e(nav[0])}</a>
      <a href="#screens">{e(nav[1])}</a>
      <a href="#download">{e(nav[2])}</a>
      <a class="lang" href="{w['other'][1]}" hreflang="{'en' if lang == 'ar' else 'ar'}">{e(w['other'][0])}</a>
      <a class="gh" href="{REPO}" aria-label="GitHub">{icon('code')}</a>
    </nav>
  </div>
</header>

<main>
<section class="hero">
  <div class="mark" aria-hidden="true"></div>
  <div class="wrap hero-in">
    <div class="hero-text">
      <p class="kicker">{e(w['kicker'])}</p>
      <h1>{w['headline']}</h1>
      <p class="lede">{e(w['lede'])}</p>
      <div class="ctas">
        <a class="btn btn-main" href="{RELEASES}">{icon('download')}{e(w['cta_android'])}</a>
        <a class="btn btn-alt" href="{RELEASES}">{icon('monitor')}{e(w['cta_windows'])}</a>
      </div>
      <p class="promise">{e(w['promise'])}</p>
    </div>
    <div class="hero-gif">
      <img src="{a}img/download-{lang}.gif" width="440" height="886" alt="{e(w['gif_alt'])}">
    </div>
  </div>
</section>

<section class="flow">
  <div class="wrap">
    <h2>{e(w['flow_title'])}</h2>
    <ol class="steps">
{flow}
    </ol>
  </div>
</section>

<section id="features" class="features">
  <div class="wrap">
    <h2>{e(w['features_title'])}</h2>
    <ul class="grid">
{features}
    </ul>
  </div>
</section>

<section id="screens" class="screens">
  <div class="wrap">
    <h2>{e(w['screens_title'])}</h2>
{screens}
  </div>
</section>

<section class="privacy">
  <div class="wrap privacy-in">
    <span class="privacy-icon">{icon('shield')}</span>
    <div>
      <h2>{e(w['privacy_title'])}</h2>
      <p>{e(w['privacy'])}</p>
    </div>
  </div>
</section>

<section id="download" class="download">
  <div class="wrap">
    <h2>{e(w['download_title'])}</h2>
    <p class="lede">{e(w['download_lede'])}</p>
    <div class="files">
{files}
    </div>
    <div class="also">
      <p>{e(w['obtainium'])}</p>
      <a href="{e(OBTAINIUM)}"><img src="{a}img/obtainium.png" width="194" height="75" alt="{e(w['obtainium_alt'])}"></a>
    </div>
    <p class="signed">{e(w['signed'])} <code dir="ltr">{FINGERPRINT}</code></p>
  </div>
</section>
</main>

<footer class="foot">
  <div class="wrap foot-in">
    <a class="brand" href="./"><img src="{a}icon.png" width="28" height="28" alt=""><span>VidHoist</span></a>
    <p>{e(w['license'])}</p>
    <p><a href="{REPO}">{e(w['source'])}</a> · {e(w['made'])}</p>
  </div>
</footer>
</body>
</html>
'''


def main():
    if os.path.isdir(OUT):
        shutil.rmtree(OUT)
    os.makedirs(os.path.join(OUT, 'ar'))
    assets = os.path.join(OUT, 'assets')
    for folder in ('img', 'fonts'):
        os.makedirs(os.path.join(assets, folder))
    shutil.copy(os.path.join(HERE, 'site.css'), assets)
    shutil.copy(os.path.join(ROOT, 'apps', 'vidhoist_mobile', 'assets',
                             'icons', 'icon.png'), assets)
    shutil.copy(os.path.join(ROOT, 'apps', 'vidhoist_desktop', 'brand',
                             'vidhoist-mark.svg'), assets)
    shots = os.path.join(ROOT, 'docs', 'screenshots')
    for lang in WORDS:
        for name in SHOTS:
            shutil.copy(os.path.join(shots, f'{name}-{lang}.jpg'),
                        os.path.join(assets, 'img'))
        shutil.copy(os.path.join(shots, f'download-{lang}.gif'),
                    os.path.join(assets, 'img'))
    shutil.copy(os.path.join(ROOT, 'docs', 'badges', 'obtainium.png'),
                os.path.join(assets, 'img'))
    fonts = os.path.join(ROOT, 'packages', 'vh_ui', 'assets', 'fonts')
    for font in FONTS + ['OFL.txt']:
        shutil.copy(os.path.join(fonts, font), os.path.join(assets, 'fonts'))
    for lang, path in (('en', 'index.html'), ('ar', 'ar/index.html')):
        with open(os.path.join(OUT, path), 'w', encoding='utf-8',
                  newline='\n') as f:
            f.write(page(lang))
    # GitHub Pages would otherwise run the folder through Jekyll.
    open(os.path.join(OUT, '.nojekyll'), 'w').close()
    print('site ->', OUT)


if __name__ == '__main__':
    main()
