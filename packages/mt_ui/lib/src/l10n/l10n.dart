import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'generated/mt_localizations.dart';

export 'generated/mt_localizations.dart';

/// Registers the relative-time locales; Arabic is registered explicitly.
void initMTL10n() {
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setLocaleMessages('ar_short', timeago.ArShortMessages());
}

/// Shorthand access: `context.mtl.libraryTitle`.
extension MTL10nX on BuildContext {
  MTLocalizations get mtl => MTLocalizations.of(this);
}

/// A relative date in the locale currently in context.
String mtTimeAgo(BuildContext context, DateTime time) =>
    timeago.format(time, locale: Localizations.localeOf(context).languageCode);

/// A large count as YouTube writes it, "1.23M" or its Arabic, in the
/// locale in context; the number and its word kept on one line.
String mtCompactCount(BuildContext context, int count) =>
    NumberFormat.compact(locale: Localizations.localeOf(context).languageCode)
        .format(count);
