# Contributing

Thank you for looking. This project has a small number of rules that are
enforced rather than suggested — they exist because each one was learned from a
defect.

Read **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** first: it is the map of
the repository and explains most of what follows.

Issues and pull requests are welcome **in Arabic or English**.

By taking part you agree to the [Code of Conduct](CODE_OF_CONDUCT.md). For a
security problem, do not open an issue — see [SECURITY.md](SECURITY.md).

## The one rule above the others

**What works must not break.** Both apps are in daily use. An addition — however
small — is not worth the cost of breaking something that already works. New
behaviour goes behind a setting or a new path; it does not change an existing
path unless that change is asked for explicitly.

## Before you open a pull request

```bash
cd packages/vh_ui && flutter gen-l10n     # only if you touched an .arb file
flutter analyze --no-pub                  # must be clean
cd packages/vh_core  && dart test
cd packages/vh_media && flutter test --no-pub
cd packages/vh_ui    && flutter test --no-pub
cd packages/vh_transcripts && dart test
cd packages/vh_ytdlp && dart test
cd apps/vidhoist_mobile  && flutter test --no-pub
cd apps/vidhoist_desktop && flutter test --no-pub
```

All seven suites must be green, and the total must not go **down**. A test that
starts failing means either the code is wrong or a contract changed on purpose —
the second case needs saying so in the pull request, not deleting the test.

## Rules that will be checked in review

**Both languages, always.** Every user-facing string lives in `app_en.arb`
**and** `app_ar.arb`, added in the same change, keys in alphabetical order.
There are zero hardcoded strings in the UI, and an automated guard
(`packages/vh_ui/test/arb_parity_test.dart`) fails if the two files drift apart.
Arabic is right-to-left: check numbers, percentages and directional icons in
both directions.

**Both apps.** Anything in `vh_core`, `vh_media` or `vh_ui` touches the
Android and the Windows app at once. Some files are deliberately duplicated per app; a change to one
copy is applied to the other, or the pull request says why not.

**Both themes.** Every colour is read from `VhPalette` through the context —
never a literal. A hardcoded colour works in daylight and breaks at night. Any
new palette field is filled in both palettes (`desktopDay`, `desktopNight`;
the `phone*` names are aliases) with real contrast, not a copied daylight value. Screens
are reviewed in day **and** night.

**Size limits.** 400 lines for a screen, 300 for anything else, counting code
and excluding comments. Over the limit, split before finishing.

**Comments are in English, and they say why.** A comment that restates the code
adds nothing; the ones worth writing record what a defect was, what was measured
and on which device. That is most of what this file is asking you to preserve.

**Device matrix.** Every new screen or sheet passes through `expectNoOverflow`
in `apps/*/test/device_matrix.dart`: five screen sizes and three text scales.
Layout is what breaks on other people's phones and it does not show on yours.

**Layers.** `apps → vh_media → vh_core → vh_ytdlp`. `vh_core` and `vh_ytdlp`
are pure Dart with no Flutter import. `vh_ui` knows no engine and no app. A
yt-dlp command line is built and its output read in `vh_ytdlp` alone; each app
only starts the process.

**The engine.** [`docs/ENGINE.md`](docs/ENGINE.md) is the authority on how
yt-dlp runs on each platform, what was measured, and the traps that are
documented there because they cost real debugging time. Every index is keyed by
the canonical URL yt-dlp reports (`webpage_url`), never by the URL the user
typed.

**Each app keeps its role.** Before changing anything shared, ask whether it
changes the *other* app's behaviour: both run the same `LocalDownloadEngine`.

## Fixing a defect

A fix is not finished until it leaves a test that **fails on the old code**.
Prove it: put the broken code back, watch the test fail, then restore the fix.
The test's comment should say what the defect was, not just what the function
does.

Measure before you conclude. A large part of this codebase exists because a
plausible explanation turned out to be wrong under measurement.

## Translations

The fastest useful contribution. VidHoist speaks twelve languages; all
but English and Arabic are first translations, so a native speaker's
corrections to an existing `app_<code>.arb` are as welcome as a new language.

To add a language, copy `packages/vh_ui/lib/src/l10n/app_en.arb` to
`app_<code>.arb`, translate the values (keep the keys, any `{placeholders}`
and the ICU `plural`/`select` structure exactly), then:

- add the language's name, in its own language, to
  `packages/vh_ui/lib/src/l10n/language_names.dart`;
- register its relative times in `initVhL10n` (`l10n.dart`), if the
  `timeago` package has them;
- if Tajawal lacks letters it needs, give it a Noto face in
  `VhType.bodyFor`/`displayFor` (`tokens.dart`);
- add it to `apps/vidhoist_mobile/android/app/src/main/res/xml/locales_config.xml`
  and translate `res/values/strings.xml` into `res/values-<code>/`;
- add it to the installer if Inno Setup ships a translation for it
  (`[Languages]` in `vidhoist.iss`, and its preface in
  `tool/make_installer_license.py`);
- run `cd packages/vh_ui && flutter gen-l10n`.

Tests fail when any of these is missed.

The settings screen builds its list from `supportedLocales`, so there is no
screen to edit. A translation that misses some keys will be caught by the parity
guard — finish the file, or open a draft pull request and say which keys you
could not translate.

## Licensing of contributions

By contributing you agree that your contribution is licensed under the
[GPL-3.0](LICENSE), like the rest of the project.
