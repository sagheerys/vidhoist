import 'package:flutter/foundation.dart';

/// The interface language for development, `--lab-locale=en`: **debug
/// builds only**, so both languages can be checked in the real window
/// without changing Windows' own. Null follows Windows, as every user's
/// copy does.
String? labLocaleFrom(List<String> args) {
  if (!kDebugMode) return null;
  for (final a in args) {
    if (a.startsWith('--lab-locale=')) return a.substring(13);
  }
  return null;
}

/// The page the window opens on, `--lab-route=/settings/appearance`, and
/// day or night, `--lab-theme=dark`: **debug builds only**, so every page
/// can be photographed in the real window without a click and without
/// touching what the user chose.
String? labRouteFrom(List<String> args) => _labValue(args, '--lab-route=');

String? labThemeFrom(List<String> args) => _labValue(args, '--lab-theme=');

String? _labValue(List<String> args, String prefix) {
  if (!kDebugMode) return null;
  for (final a in args) {
    if (a.startsWith(prefix)) return a.substring(prefix.length);
  }
  return null;
}
