import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

/// The platform's name for the interface: a site's own name as it is, and
/// the one platform that has none (anything else) in the user's language,
/// as in the phone app.
String platformLabel(VhLocalizations l10n, MediaPlatform platform) =>
    platform == MediaPlatform.other ? l10n.platformOther : platform.label;
