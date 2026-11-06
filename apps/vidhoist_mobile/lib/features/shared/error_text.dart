import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';

/// Turns the core's classified exceptions into translated text (TRD §3.3).
/// **The only place** errors are translated; there are no scattered error
/// strings.
String errorText(MTLocalizations l10n, Object error) => switch (error) {
  AuthFailureException() => l10n.errAuth,
  NotVidhoistServerException() => l10n.errNotVidhoist,
  // Before its parent: a file gone from a working server is not a wrong
  // address.
  FileGoneException() => l10n.errFileGone,
  NoApiException() => l10n.errNoApi,
  NetworkException() => l10n.errNetwork,
  PlatformBlockedException() => l10n.errPlatformBlocked,
  PollTimeoutException() => l10n.errPollTimeout,
  CookiesTooLargeException() => l10n.cookiesTooLarge,
  UnsafeFilenameException() => l10n.errServer('unsafe filename'),
  // The first sentence only, isolated: yt-dlp's multi-line English
  // inside an Arabic line was cut and reordered ("unav [youtube]").
  ServerErrorException(:final detail) => l10n.errServer(
    detail == null ? '؟' : mtName(serverReason(detail)),
  ),
  EngineFailureException(:final kind, :final detail) => engineErrorText(
    l10n,
    kind,
    detail,
  ),
  CancelledException() => l10n.cancel,
  _ => l10n.errorGeneric(error.toString()),
};

/// What yt-dlp on the device failed at, as a sentence the person can act
/// on. Only an unforeseen failure shows yt-dlp's own reason, its first
/// sentence isolated so its English keeps its order inside an Arabic line.
String engineErrorText(
  MTLocalizations l10n,
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
  // These two arrive as NetworkException and PlatformBlockedException,
  // and are worded there; here only if a caller passes them directly.
  YtDlpErrorKind.network => l10n.errNetwork,
  YtDlpErrorKind.signInRequired => l10n.engineErrFailed(
    mtName(serverReason(detail ?? '')),
  ),
  YtDlpErrorKind.failed => l10n.engineErrFailed(
    mtName(serverReason(detail ?? '')),
  ),
};
