import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'generated/vh_localizations.dart';

/// **Which of the app's languages a phone gets**, for `MaterialApp`'s
/// `localeListResolutionCallback` and for [vhLocalizationsFor] alike.
///
/// Flutter's own resolution falls back to the first supported language,
/// which is Arabic here, so a phone in German or French showed the whole
/// app in Arabic. A phone that speaks none of the app's languages now gets
/// English, the one most such readers can follow; a phone that lists one
/// of them anywhere in its preferences still gets that one, as before.
Locale vhLocaleResolution(List<Locale>? preferred, Iterable<Locale> supported) {
  final languages = {for (final locale in supported) locale.languageCode};
  final speaksOne = (preferred ?? const <Locale>[]).any(
    (locale) => languages.contains(locale.languageCode),
  );
  if (!speaksOne) return const Locale('en');
  return basicLocaleListResolution(preferred, supported);
}

/// The language the app shows: the one chosen in its settings, or else the
/// system's as [vhLocaleResolution] settles it. The theme picks its fonts
/// by it.
String vhLanguageOf(String? chosen) =>
    chosen ??
    vhLocaleResolution(
      PlatformDispatcher.instance.locales,
      VhLocalizations.supportedLocales,
    ).languageCode;

/// **The texts for a notification, in the language the app shows.**
///
/// A notification is built outside the widget tree, so it cannot ask the
/// tree which language won. It used to fall back to Arabic whenever the
/// user had left the language on "system", so an English phone got an
/// English app and Arabic notifications.
///
/// [localeCode] is the user's explicit choice, or null for "system". The
/// system case runs [vhLocaleResolution], the same rule the screens use,
/// so the two cannot disagree.
VhLocalizations vhLocalizationsFor(
  String? localeCode, {
  List<Locale>? systemLocales,
}) {
  final locale = localeCode != null
      ? Locale(localeCode)
      : vhLocaleResolution(
          systemLocales ?? PlatformDispatcher.instance.locales,
          VhLocalizations.supportedLocales,
        );
  return lookupVhLocalizations(locale);
}
