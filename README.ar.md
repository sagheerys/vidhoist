<div dir="rtl">

# VidHoist

**نزّل الفيديو والصوت من الإنترنت إلى جهازك مباشرة، بمحرّك yt-dlp داخل
التطبيق.** بلا تسجيل، بلا إعلانات، بلا تتبّع: ما تنزّله يبقى بينك وبين الموقع.
لأندرويد وويندوز، بالعربية والإنجليزية، نهاراً وليلاً.

> **الحالة: الإصدار 1.0.0، تجريبي.** VidHoist نسخة مشتقّة من
> [vidhoist-mobile](https://github.com/sagheerys/vidhoist-mobile) للمؤلّف نفسه، وقد
> مضى في طريقه المستقل. كيف يعمل المحرك على كل منصة في
> [docs/ENGINE.md](docs/ENGINE.md).

| | VidHoist لأندرويد | VidHoist لويندوز |
|---|---|---|
| المجلد | `apps/vidhoist_mobile` | `apps/vidhoist_desktop` |
| المحرّك | yt-dlp وffmpeg داخل التطبيق (`youtubedl-android`) | `yt-dlp.exe` بجانب التطبيق، وffmpeg يُنزَّل عند أول حاجة |
| المكتبة | مجلد التنزيل، بقوائم ووسوم ونصوص | مكتبة محلية بوسوم وقوائم ونصوص |
| التثبيت | APK من صفحة الإصدارات، يحدّث نفسه | مثبّت Inno Setup، يحدّث نفسه |

<p>
  <img src="docs/screenshots/android-subtitles-ar.png" width="200" alt="حجم الترجمة وخلفيتها">
  <img src="docs/screenshots/android-transcript-ar-dark.png" width="200" alt="نص المقطع ليلاً">
  <img src="docs/screenshots/android-add.png" width="200" alt="إضافة رابط واختيار الجودة">
  <img src="docs/screenshots/android-transcript.png" width="200" alt="نص المقطع تحت المشغّل">
</p>

## البناء

Flutter 3.47 فما فوق (Dart ^3.13). من جذر المستودع:

</div>

```bash
flutter pub get
cd packages/vh_ui && flutter gen-l10n && cd ../..
flutter analyze --no-pub
cd apps/vidhoist_mobile  && flutter build apk --debug
cd apps/vidhoist_desktop && flutter build windows --debug
```

<div dir="rtl">

الاختبارات: `dart test` في `packages/vh_core` و`packages/vh_transcripts`
و`packages/vh_ytdlp`،
و`flutter test --no-pub` في `packages/vh_media` و`packages/vh_ui`
و`apps/vidhoist_mobile` و`apps/vidhoist_desktop`.

الأيقونات وملفات الهوية تُولَّد ولا تُرسم يدوياً:
`python tool/icons/vidhoist_kit.py` ثم `dart run flutter_launcher_icons` في
تطبيق أندرويد.

## خريطة المستودع

</div>

```
apps/vidhoist_mobile     تطبيق أندرويد
apps/vidhoist_desktop    تطبيق ويندوز
packages/vh_core         Dart خالص: النماذج، التخزين، محرّك التنزيل، النسخ الاحتياطي، التحديث
packages/vh_media        المشغّلات والمشغّل المصغّر وجلسة الوسائط
packages/vh_ui           نظام التصميم: الرموز، الأيقونات، نصوص EN/AR
packages/vh_transcripts  الترجمات والبحث في النصوص
packages/vh_ytdlp        Dart خالص: أوامر yt-dlp وقراءة مخرجاته
third_party/             ثلاث إضافات معدَّلة، انظر PATCHES.md في كلٍّ منها
docs/                    البنية، المخطّط، القرارات (docs/adr)
```

<div dir="rtl">

## الترخيص

GPL-3.0 كالمشروع الذي جاء منه. حقوق النشر © 2026 ياسر صغير. لا صلة لـVidHoist
بمشروع yt-dlp ولا بأي موقع. احترم حقوق النشر وشروط المواقع التي تنزّل منها.

</div>
