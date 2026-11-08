import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

/// The core's classified failures in the user's language, as the phone
/// apps word them. The one place an error becomes a sentence.
String errorText(VhLocalizations l, Object error) => switch (error) {
  NetworkException() => l.errNetwork,
  PlatformBlockedException() => l.errPlatformBlockedCookies,
  EngineFailureException(:final kind, :final detail) => engineErrorText(
    l,
    kind,
    detail,
  ),
  CancelledException() => l.cancel,
  _ => l.errorGeneric(error.toString()),
};

/// What yt-dlp on the device failed at, as a sentence the person can act
/// on. Only an unforeseen failure shows yt-dlp's own reason, its first
/// sentence isolated so its English is not cut and reordered inside an
/// Arabic line.
String engineErrorText(
  VhLocalizations l,
  YtDlpErrorKind kind,
  String? detail,
) => switch (kind) {
  YtDlpErrorKind.unavailable => l.engineErrUnavailable,
  YtDlpErrorKind.geoBlocked => l.engineErrGeoBlocked,
  YtDlpErrorKind.unsupportedUrl => l.engineErrUnsupported,
  YtDlpErrorKind.rateLimited => l.engineErrRateLimited,
  YtDlpErrorKind.formatUnavailable => l.engineErrFormat,
  YtDlpErrorKind.diskFull => l.engineErrDiskFull,
  YtDlpErrorKind.engineMissing => l.engineErrMissing,
  // These two arrive as NetworkException and PlatformBlockedException,
  // and are worded there; here only if a caller passes them directly.
  YtDlpErrorKind.network => l.errNetwork,
  YtDlpErrorKind.signInRequired => l.engineErrFailed(
    vhName(ErrorClassifier.reason(detail ?? '')),
  ),
  YtDlpErrorKind.failed => l.engineErrFailed(
    vhName(ErrorClassifier.reason(detail ?? '')),
  ),
};
