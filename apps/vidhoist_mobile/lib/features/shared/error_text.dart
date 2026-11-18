import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

/// Turns the core's classified exceptions into translated text (TRD §3.3).
/// **The only place** errors are translated; there are no scattered error
/// strings.
String errorText(VhLocalizations l10n, Object error) => switch (error) {
  NetworkException() => l10n.errNetwork,
  // The phone has a sign-in page of its own since 2026-11-09, so the
  // sentence can say where it is.
  PlatformBlockedException() => l10n.mobileSignInNeeded,
  EngineFailureException(:final kind, :final detail) => engineErrorText(
    l10n,
    kind,
    detail,
  ),
  ClipPastEndException(length: final length?) => l10n.errClipPastEnd(
    ClipRange.clock(length),
  ),
  ClipPastEndException() => l10n.errClipPastEndUnknown,
  CancelledException() => l10n.cancel,
  _ => l10n.errorGeneric(error.toString()),
};

/// What yt-dlp on the device failed at, as a sentence the person can act
/// on. Only an unforeseen failure shows yt-dlp's own reason, its first
/// sentence isolated so its English keeps its order inside an Arabic line:
/// yt-dlp's multi-line English was cut and reordered there ("unav
/// [youtube]").
String engineErrorText(
  VhLocalizations l10n,
  YtDlpErrorKind kind,
  String? detail,
) => switch (kind) {
  YtDlpErrorKind.unavailable => l10n.engineErrUnavailable,
  YtDlpErrorKind.geoBlocked => l10n.engineErrGeoBlocked,
  YtDlpErrorKind.unsupportedUrl => l10n.engineErrUnsupported,
  YtDlpErrorKind.rateLimited => l10n.engineErrRateLimited,
  YtDlpErrorKind.formatUnavailable => l10n.engineErrFormat,
  YtDlpErrorKind.diskFull => l10n.engineErrDiskFull,
  YtDlpErrorKind.engineMissing => l10n.engineErrMissing,
  // Arrives as ClipPastEndException, worded there.
  YtDlpErrorKind.clipPastEnd => l10n.errClipPastEndUnknown,
  // These two arrive as NetworkException and PlatformBlockedException,
  // and are worded there; here only if a caller passes them directly.
  YtDlpErrorKind.network => l10n.errNetwork,
  YtDlpErrorKind.signInRequired => l10n.engineErrFailed(
    vhName(ErrorClassifier.reason(detail ?? '')),
  ),
  YtDlpErrorKind.failed => l10n.engineErrFailed(
    vhName(ErrorClassifier.reason(detail ?? '')),
  ),
};
