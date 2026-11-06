# Architecture

A map of the repository for someone who has just cloned it. It answers
three questions: what the pieces are, which rules hold them together, and
where a change belongs.

Vidhoist was forked from vidhoist-mobile (ADR 0001), whose apps were clients
of a Vidhoist server. Since phase 1 (2026-11-06) there is no server: both apps
download on the device with yt-dlp. How yt-dlp runs, what was measured, and
the traps are in [ENGINE.md](ENGINE.md).

The Arabic version of this document follows the English one.

---

## 1. Two apps, one repository

| | **Android** (`apps/vidhoist_mobile`) | **Windows** (`apps/vidhoist_desktop`) |
|---|---|---|
| Came from | Vidhoist Lite | Vidhoist Ember |
| yt-dlp runs through | youtubedl-android (`YtDlpBridge.kt`, `ChannelYtDlpBackend`), kept alive by `EngineService.kt` | `yt-dlp.exe` beside the app or in `tools\` (`ProcessYtDlpBackend`, a Job object per run), with ffmpeg and Deno fetched on first need |
| Library | The download folder, scanned (`Download/Vidhoist`) | `LocalHistoryStore` and a watch on the download folder |
| At once | One download | As set in Settings › Engine |
| Exclusive | Wi-Fi only, share sheet, picture in picture | Tags, lists, reading room, browser button, tray; Channels and Sync behind a switch (Settings › Engine) |

They are separate apps, not build flavours, with **one palette**
(`MTPalette`, ADR 0002). They share five packages. Before changing anything
in a shared package, ask: **does this change the other app?**

## 2. Packages and the dependency rule

```
apps/vidhoist_mobile ─┐
                      ├─► packages/mt_media ─► packages/mt_core ─► packages/mt_ytdlp
apps/vidhoist_desktop ┘            │                 ▲
        │                          └─► packages/mt_ui│
        └─► packages/mt_transcripts ─────────────────┘
```

| Package | Contains | Hard rule |
|---|---|---|
| `mt_ytdlp` | yt-dlp's command lines and reading what it prints: format selectors, progress and file lines, the info JSON, errors (`ErrorClassifier`), versions | **Pure Dart, no dependencies, no processes.** Tested on real yt-dlp output (`test/fixtures/`) |
| `mt_core` | `DownloadBackend` (implemented by each app), `LocalDownloadEngine`, `LocalHistoryStore`, `LocalPendingStore`, the models, storage, backup, sync, URL tools, self-update | **Pure Dart. No Flutter import.** Tested with `dart test` |
| `mt_media` | Audio handler, video playback, playback stores, the library model | Plays files on the device |
| `mt_ui` | Design tokens, themes, shared widgets, localisation | Knows no engine and no app |
| `mt_transcripts` | Subtitle parsing, Arabic-aware search, the transcript store, `YtDlpSource` for clips already in the library | **Pure Dart** |
| `apps/*` | Screens, routing, dependency injection, the platform's way of running yt-dlp | May depend on the packages above |

Three consequences worth remembering:

- **One reading of yt-dlp.** A command line is built by `CommandBuilder`
  and what comes back is read by `mt_ytdlp` alone; the apps only start the
  process and hand its lines to `readDownloadRun`. A download and the
  transcript backfill classify an error the same way (`ErrorClassifier`).
- **No hard-coded UI strings.** Every user-visible string lives in
  `packages/mt_ui/lib/src/l10n/app_en.arb` and `app_ar.arb`, and both
  files change in the same commit. A parity test enforces it.
- **No hard-coded colours or spacing.** Both come from
  `packages/mt_ui/lib/src/tokens/`; a literal colour works in daylight and
  breaks at night.

## 3. Where a feature lives

An app feature is a folder under `apps/<app>/lib/features/<name>/`:

```
features/update/
  update_state.dart      # Riverpod providers + the controller
  update_channel.dart    # platform channel wrapper, if any
  update_section.dart    # widget embedded in another screen
  update_sheet.dart      # bottom sheet
  widgets/               # anything larger than a small helper
```

Rules of thumb:

- Logic that does not need Flutter goes to `mt_core` (or `mt_ytdlp`, when
  it is about yt-dlp's text) and gets a `dart test`.
- A widget used by both apps goes to `mt_ui`. A widget used by one app,
  or one that reads app providers, stays in the app.
- Some files are deliberately duplicated between the two apps
  (`error_text.dart`, `about_screen.dart`). When you edit one, edit the
  other or say in the commit why not.
- **Size limits: 400 lines for a screen, 300 for anything else**,
  counting code and excluding comments.

## 4. State and navigation

Riverpod handles dependency injection. `apps/<app>/lib/di.dart` (and the
`data/` folder on Windows) is the wiring: a settings change rebuilds the
engine automatically, with no manual synchronisation.

`apps/<app>/lib/router.dart` holds the whole route table using
`go_router`. There is no direct `Navigator.push` for a screen; sheets and
dialogs are pushed normally.

Storage is `SharedPreferences` behind the `KeyValueStore` interface, so
`mt_core` can be tested with `MemoryKeyValueStore`. **Every
read-modify-write goes through `PrefsMutex`**: two concurrent flows
without the lock read the same value and the slower one erases the
faster one's write. The keys and the backup format are in
[ENGINE.md §Storage](ENGINE.md#what-carried-over-storage-backups-and-keys).

## 5. Running it

```bash
flutter pub get                      # once, at the repository root
flutter analyze --no-pub             # zero issues is the gate
cd packages/mt_core && dart test     # pure Dart core
cd packages/mt_transcripts && dart test
cd packages/mt_ytdlp && dart test
flutter test --no-pub                # in mt_media, mt_ui and both apps
flutter build apk --debug            # in apps/vidhoist_mobile
flutter build windows --debug        # in apps/vidhoist_desktop
```

After editing an `.arb` file, run `cd packages/mt_ui && flutter gen-l10n`.
Skipping it produces an `undefined_getter` at build time rather than at
edit time. On Windows, `tool/fetch-engine.ps1` puts yt-dlp, ffmpeg and
Deno, at pinned versions with their SHA-256, where the build expects them.

## 6. Testing conventions

- **Every fixed bug leaves a guard test** that fails on the old code.
  The proof is to reintroduce the broken code briefly and watch the test
  fall. Tests are never weakened to let a change through.
- **The device matrix.** `apps/*/test/device_matrix.dart` and
  `desktop_matrix.dart` render a widget across screen sizes and text
  scales and catch `RenderFlex overflowed` from the engine. Every new
  screen or sheet passes through `expectNoOverflow`.
- **Localisation parity.** `packages/mt_ui/test/arb_parity_test.dart`
  fails if the two `.arb` files diverge in key count, translation or
  placeholders.
- **Real output.** `packages/mt_ytdlp/test/fixtures/` holds what yt-dlp
  really printed on Windows and Android, with media links, addresses and
  local paths replaced; the models' fixtures in `mt_core` are anonymised
  the same way.

## 7. Deeper references

- [`ENGINE.md`](ENGINE.md): the yt-dlp command line, the measurements on
  both platforms, the traps, and what carried over from the Vidhoist days
  (storage keys, backups, short links).
- [`blueprint/REPORT.md`](blueprint/REPORT.md) and
  [`blueprint/EXECUTION-PLAN.md`](blueprint/EXECUTION-PLAN.md): why the
  server went, and the order the work was done in.
- [`adr/`](adr/): the decisions that are not reopened without a new one.

---

# البنية المعمارية

خريطة المستودع لمن استنسخه للتو: ما القطع، وما القواعد التي تربطها، وأين
يقع أي تغيير.

اشتُقّ Vidhoist من vidhoist-mobile (ADR 0001)، وكان تطبيقاه عميلين لسيرفر
Vidhoist. منذ المرحلة 1 (2026-11-06) لا سيرفر: التطبيقان ينزّلان على الجهاز
نفسه بـyt-dlp. كيف يعمل yt-dlp وما قيس والفخاخ في [ENGINE.md](ENGINE.md).

## ١ · تطبيقان في مستودع واحد

| | **أندرويد** (`apps/vidhoist_mobile`) | **ويندوز** (`apps/vidhoist_desktop`) |
|---|---|---|
| أصله | Vidhoist Lite | Vidhoist Ember |
| yt-dlp يعمل عبر | youtubedl-android (`YtDlpBridge.kt` و`ChannelYtDlpBackend`)، وتبقيه حياً `EngineService.kt` | `yt-dlp.exe` بجانب التطبيق أو في `tools\` (`ProcessYtDlpBackend`، بكائن Job لكل تشغيل)، وffmpeg وDeno يُنزَّلان عند أول حاجة |
| المكتبة | مسح مجلد التنزيل (`Download/Vidhoist`) | `LocalHistoryStore` ومراقبة مجلد التنزيل |
| التزامن | تنزيل واحد | كما يُضبط في الإعدادات › المحرّك |
| الحصري | Wi-Fi فقط، المشاركة إلى التطبيق، الصورة داخل الصورة | الوسوم، القوائم، غرفة القراءة، زر المتصفح، الدرج؛ القنوات والمزامنة خلف مفتاح (الإعدادات › المحرّك) |

تطبيقان مستقلان لا نكهتا بناء، بلوحة ألوان **واحدة** (`MTPalette`، ADR
0002)، ويتقاسمان خمس حزم. وقبل أي تعديل في حزمة مشتركة اسأل: **هل يغيّر
هذا سلوك التطبيق الآخر؟**

## ٢ · الحزم وقاعدة الاعتماد

```
apps/vidhoist_mobile ─┐
                      ├─► packages/mt_media ─► packages/mt_core ─► packages/mt_ytdlp
apps/vidhoist_desktop ┘            │                 ▲
        │                          └─► packages/mt_ui│
        └─► packages/mt_transcripts ─────────────────┘
```

| الحزمة | تحتوي | القاعدة الصارمة |
|---|---|---|
| `mt_ytdlp` | أوامر yt-dlp وقراءة ما يطبعه: محدِّدات الصيغ، أسطر التقدّم والملف، ملف info.json، الأخطاء (`ErrorClassifier`)، الإصدارات | **Dart خالص، بلا اعتماديات ولا عمليات**، ويُختبر على مخرجات حقيقية |
| `mt_core` | `DownloadBackend` (يكتبه كل تطبيق)، `LocalDownloadEngine`، `LocalHistoryStore`، `LocalPendingStore`، النماذج، التخزين، النسخ، المزامنة، أدوات الروابط، التحديث الذاتي | **Dart خالص بلا Flutter**، ويُختبر بـ`dart test` |
| `mt_media` | مشغّل الصوت والفيديو ومخازن التشغيل ونموذج المكتبة | يشغّل ملفات الجهاز |
| `mt_ui` | الرموز التصميمية والثيمات والودجات والترجمة | لا يعرف محرّكاً ولا تطبيقاً |
| `mt_transcripts` | قراءة الترجمات، والبحث المراعي للعربية، ومخزن النصوص، و`YtDlpSource` للمقاطع الموجودة في المكتبة | **Dart خالص** |
| `apps/*` | الشاشات والتوجيه وحقن الاعتماديات وطريقة المنصة في تشغيل yt-dlp | يعتمد على الحزم أعلاه |

ثلاث نتائج تستحق الحفظ:

- **قراءة واحدة لـyt-dlp.** الأمر يبنيه `CommandBuilder` وما يعود تقرؤه
  `mt_ytdlp` وحدها؛ التطبيقان يشغّلان العملية ويمرّران أسطرها إلى
  `readDownloadRun` فقط. والتنزيل وجلب النصوص للمقاطع القديمة يصنّفان الخطأ
  بالطريقة نفسها (`ErrorClassifier`).
- **صفر نص واجهة مثبَّت.** كل نص في ملفَّي `.arb`، ويتغيّران في الدفعة
  نفسها، وحارس آلي يفرض ذلك.
- **صفر لون أو مسافة مثبَّتة.** كلاهما من `tokens`، والقيمة المثبتة تعمل
  نهاراً وتنكسر ليلاً.

## ٣ · أين تقع الميزة

الميزة مجلَّد تحت `apps/<app>/lib/features/<name>/`. والقواعد العملية:

- ما لا يحتاج Flutter ينزل إلى `mt_core` (أو `mt_ytdlp` إن كان عن نص
  yt-dlp) ويأخذ `dart test`.
- الودجت الذي يستعمله التطبيقان يذهب إلى `mt_ui`، وما يقرأ مزوّدات التطبيق
  يبقى فيه.
- ملفات مكرَّرة بين التطبيقين بقصد (`error_text.dart`، `about_screen.dart`).
  إن عدّلت إحداها فعدّل أختها أو علّل في الإيداع لماذا لا.
- **الحدّ: 400 سطر للشاشة و300 لغيرها**، كوداً بلا تعليقات.

## ٤ · الحالة والتنقّل

Riverpod يحقن الاعتماديات، و`di.dart` (ومجلد `data/` في ويندوز) هو الربط:
تغيّر الإعدادات يعيد بناء المحرّك تلقائياً بلا تزامن يدوي.

`router.dart` يحمل جدول المسارات كاملاً بـ`go_router`، ولا
`Navigator.push` مباشر لشاشة.

التخزين `SharedPreferences` خلف واجهة `KeyValueStore`، **وكل
قراءة-تعديل-كتابة تمرّ من `PrefsMutex`**. المفاتيح وصيغة النسخ الاحتياطي في
[ENGINE.md](ENGINE.md#what-carried-over-storage-backups-and-keys).

## ٥ · التشغيل

```bash
flutter pub get                      # مرة واحدة من الجذر
flutter analyze --no-pub             # صفر مشاكل هي البوابة
cd packages/mt_core && dart test     # النواة Dart خالص
cd packages/mt_transcripts && dart test
cd packages/mt_ytdlp && dart test
flutter test --no-pub                # في mt_media وmt_ui والتطبيقين
flutter build apk --debug            # في apps/vidhoist_mobile
flutter build windows --debug        # في apps/vidhoist_desktop
```

بعد تعديل أي `.arb`: `cd packages/mt_ui && flutter gen-l10n`. وعلى ويندوز
يضع `tool/fetch-engine.ps1` كلاً من yt-dlp وffmpeg وDeno بإصدارات مثبّتة
وSHA-256 حيث يتوقعها البناء.

## ٦ · أعراف الاختبار

- **كل عطل يُصلَح يترك حارساً** يفشل على الكود القديم، ولا يُضعَّف اختبار
  قائم لتمرير تعديل.
- **مصفوفة الأجهزة** (`device_matrix.dart` و`desktop_matrix.dart`) تلتقط
  تجاوز الإطار عبر المقاسات ومقاييس الخط، وكل شاشة جديدة تمرّ بـ`expectNoOverflow`.
- **تماثل الترجمة**: حارس يفشل إن اختلف الملفان في العدد أو الترجمة أو
  المعاملات.
- **مخرجات حقيقية** في `packages/mt_ytdlp/test/fixtures/`: ما طبعه yt-dlp
  فعلاً على ويندوز وأندرويد، مع استبدال روابط الوسائط والعناوين والمسارات.

## ٧ · المراجع الأعمق

- [`ENGINE.md`](ENGINE.md): أمر yt-dlp، والقياسات على المنصتين، والفخاخ، وما
  بقي من أيام Vidhoist (مفاتيح التخزين، النسخ، الروابط القصيرة).
- [`blueprint/REPORT.md`](blueprint/REPORT.md) و
  [`blueprint/EXECUTION-PLAN.md`](blueprint/EXECUTION-PLAN.md): لماذا ذهب
  السيرفر، وبأي ترتيب جرى العمل.
- [`adr/`](adr/): القرارات التي لا تُفتح إلا بقرار مدوَّن جديد.
