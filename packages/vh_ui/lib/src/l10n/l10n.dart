import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'generated/vh_localizations.dart';

export 'generated/vh_localizations.dart';

/// Registers the relative-time locales; Arabic is registered explicitly.
void initVhL10n() {
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setLocaleMessages('ar_short', timeago.ArShortMessages());
}

/// Shorthand access: `context.vhl.libraryTitle`.
extension VhL10nX on BuildContext {
  VhLocalizations get vhl => VhLocalizations.of(this);
}

/// A relative date in the locale currently in context. Under a minute it
/// says "just now": the Arabic messages count the seconds, and "0 seconds
/// ago" read as a fault on the phone's last contact (2026-11-10).
String vhTimeAgo(BuildContext context, DateTime time, {DateTime? now}) {
  final age = (now ?? DateTime.now()).difference(time);
  if (age < const Duration(minutes: 1) && age > const Duration(seconds: -5)) {
    return context.vhl.justNow;
  }
  return timeago.format(
    time,
    clock: now,
    locale: Localizations.localeOf(context).languageCode,
  );
}

/// A large count as YouTube writes it, "1.23M" or its Arabic, in the
/// locale in context; the number and its word kept on one line.
String vhCompactCount(BuildContext context, int count) =>
    NumberFormat.compact(locale: Localizations.localeOf(context).languageCode)
        .format(count);
