import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';

/// The core's classified failures in the user's language, as the phone
/// apps word them. The one place an error becomes a sentence.
String errorText(MTLocalizations l, Object error) => switch (error) {
  AuthFailureException() => l.errAuth,
  NotVidhoistServerException() => l.errNotVidhoist,
  // Before its parent: a file gone from a working server is not a wrong
  // address.
  FileGoneException() => l.errFileGone,
  NoApiException() => l.errNoApi,
  NetworkException() => l.errNetwork,
  PlatformBlockedException() => l.errPlatformBlockedCookies,
  PollTimeoutException() => l.errPollTimeout,
  CookiesTooLargeException() => l.cookiesTooLarge,
  UnsafeFilenameException() => l.errServer('unsafe filename'),
  // The first sentence only, isolated, so yt-dlp's English is not cut and
  // reordered inside an Arabic line.
  ServerErrorException(:final detail) => l.errServer(
    detail == null ? '?' : mtName(serverReason(detail)),
  ),
  EngineFailureException(:final kind, :final detail) => engineErrorText(
    l,
    kind,
    detail,
  ),
  CancelledException() => l.cancel,
  _ => l.errorGeneric(error.toString()),
};

/// The server's own answer to a second follow of the same channel, which
/// it gives in English whatever the interface language.
bool isAlreadyFollowed(Object error) =>
    error is ServerErrorException &&
    (error.detail ?? '').toLowerCase().contains('already subscribed');

/// What yt-dlp on the device failed at, as a sentence the person can act
/// on. Only an unforeseen failure shows yt-dlp's own reason, its first
/// sentence isolated so its English keeps its order inside an Arabic line.
String engineErrorText(
  MTLocalizations l,
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
    mtName(serverReason(detail ?? '')),
  ),
  YtDlpErrorKind.failed => l.engineErrFailed(
    mtName(serverReason(detail ?? '')),
  ),
};
