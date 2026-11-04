<div dir="rtl">

# Vidhoist

**حمّل الفيديو والصوت من الإنترنت إلى جهازك مباشرة، بمحرّك yt-dlp داخل
التطبيق.** بلا سيرفر تشغّله، بلا حساب، بلا إعلانات. لأندرويد وويندوز، بالعربية
والإنجليزية، نهاراً وليلاً.

> **الحالة: قيد البناء.** Vidhoist نسخة مشتقّة من
> [vidhoist-mobile](https://github.com/sagheerys/vidhoist-mobile) للمؤلّف نفسه.
> الواجهة والمكتبة المحلية والمشغّلات والنصوص والنسخ الاحتياطي والتحديث الذاتي
> جاءت منه وتعمل اليوم. طبقة التحميل تُنقل من سيرفر Vidhoist إلى yt-dlp يعمل على
> الجهاز؛ وحتى يكتمل ذلك ما زال التطبيقان يتوقّعان سيرفراً. الخطة، بما يتغيّر
> وما يبقى، في [docs/blueprint/REPORT.md](docs/blueprint/REPORT.md).

| | Vidhoist لأندرويد | Vidhoist لويندوز |
|---|---|---|
| المجلد | `apps/vidhoist_mobile` | `apps/vidhoist_desktop` |
| المحرّك | yt-dlp على الجهاز (المخطّط: `youtubedl-android`) | `yt-dlp.exe` وffmpeg بجانب التطبيق |
| المكتبة | مجلد التنزيل، يُمسح محلياً | مكتبة محلية بوسوم وقوائم ونصوص |
| التثبيت | APK من صفحة الإصدارات، يحدّث نفسه | مثبّت Inno Setup، يحدّث نفسه |

## لماذا نسخة مشتقّة

Vidhoist Lite وSuper عميلان لسيرفر تستضيفه بنفسك. كثيرون يريدون التطبيق نفسه بلا
أن يشغّلوا شيئاً: الصق الرابط، اختر الجودة، احتفظ بالملف. Vidhoist هو ذلك
التطبيق: يبقي نظام تصميم «وهج» وكل كود لا علاقة له بالسيرفر، ويستبدل المحرّك
وحده.

## البناء

Flutter 3.47 فما فوق (Dart ^3.13). من جذر المستودع:

</div>

```bash
flutter pub get
cd packages/mt_ui && flutter gen-l10n && cd ../..
flutter analyze --no-pub
cd apps/vidhoist_mobile  && flutter build apk --debug
cd apps/vidhoist_desktop && flutter build windows --debug
```

<div dir="rtl">

الاختبارات: `dart test` في `packages/mt_core` و`packages/mt_transcripts`،
و`flutter test --no-pub` في `packages/mt_media` و`packages/mt_ui`
و`apps/vidhoist_mobile` و`apps/vidhoist_desktop`.

الأيقونات وملفات الهوية تُولَّد ولا تُرسم يدوياً:
`python tool/icons/vidhoist_kit.py` ثم `dart run flutter_launcher_icons` في
تطبيق أندرويد.

## خريطة المستودع

</div>

```
apps/vidhoist_mobile     تطبيق أندرويد
apps/vidhoist_desktop    تطبيق ويندوز
packages/mt_core         Dart خالص: النماذج، التخزين، محرّك التحميل، النسخ الاحتياطي، التحديث
packages/mt_media        المشغّلات والمشغّل المصغّر وجلسة الوسائط
packages/mt_ui           نظام تصميم «وهج»: الرموز، الأيقونات، نصوص EN/AR
packages/mt_transcripts  الترجمات والبحث في النصوص
third_party/             إضافتان معدَّلتان، انظر PATCHES.md في كلٍّ منهما
docs/                    البنية، المخطّط، القرارات (docs/adr)
```

<div dir="rtl">

بادئة الحزم `mt_` أُبقيت من المشروع الأم حتى تبقى الإصلاحات قابلة للنقل بين
الاثنين؛ أما التطبيقان وكل ما يراه المستخدم فيقول Vidhoist.

## الترخيص

GPL-3.0 كالمشروع الذي جاء منه. حقوق النشر © 2025–2026 ياسر صغير. لا صلة لـVidhoist
بمشروع yt-dlp ولا بأي منصة محتوى. احترم حقوق النشر وشروط المواقع التي تحمّل
منها.

</div>
