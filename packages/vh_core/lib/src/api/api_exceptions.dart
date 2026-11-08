import 'package:vh_ytdlp/vh_ytdlp.dart' show YtDlpError, YtDlpErrorKind;

/// Classified error types thrown by the core. The app turns them into
/// translated text at display time: the core holds no interface strings.
sealed class VhApiException implements Exception {
  const VhApiException([this.detail]);

  /// An optional technical detail, the raw message. For logs, not for
  /// direct display.
  final String? detail;

  /// Should this be retried automatically when the network returns?
  ///
  /// **Yes for a broken road, no for a refusal at the destination.** A
  /// dropped connection is an incident the network itself repairs. A
  /// blocked platform or a video gone are decisions by the other side:
  /// repeating them unchanged fails again.
  bool get isRetryable => this is NetworkException;

  @override
  String toString() =>
      detail == null ? runtimeType.toString() : '$runtimeType: $detail';
}

/// Unreachable: a drop, a timeout, DNS, a certificate.
final class NetworkException extends VhApiException {
  const NetworkException([super.detail]);
}

/// The site wants a signed-in session (login, sign in, cookie, bot), so
/// the interface offers cookies.
final class PlatformBlockedException extends VhApiException {
  const PlatformBlockedException([super.detail]);
}

/// A file name failed the path safety guard: a separator, a NUL, or a name
/// that is exactly `.` or `..`.
final class UnsafeFilenameException extends VhApiException {
  const UnsafeFilenameException([super.detail]);
}

/// The task was cancelled by the user. Not an error to display.
final class CancelledException extends VhApiException {
  const CancelledException([super.detail]);
}

/// An unexpected local failure while running the task: filesystem,
/// permissions, space.
///
/// **Its cause (found in the 2026-09-02 audit):** the download worker caught only
/// `VhApiException`, so any `FileSystemException` from renaming the partial
/// file escaped the pump. The task froze and **the whole queue stopped with
/// no message**. Everything unclassified is now wrapped here, so a single
/// task fails and the rest continue.
final class LocalFailureException extends VhApiException {
  const LocalFailureException([super.detail]);
}

/// yt-dlp on the device failed, for the reason in [kind]: the app words
/// each kind its own way, and [detail] keeps the `ERROR:` lines for the
/// log.
///
/// Two reasons have a type of their own: a network failure is a
/// [NetworkException], retried when the network returns, and a site that
/// wants a signed-in session is a [PlatformBlockedException], which offers
/// cookies.
final class EngineFailureException extends VhApiException {
  const EngineFailureException(this.kind, [super.detail]);

  final YtDlpErrorKind kind;

  /// The classified error in the core's terms.
  static VhApiException from(YtDlpError error) => switch (error.kind) {
    YtDlpErrorKind.network => NetworkException(error.message),
    YtDlpErrorKind.signInRequired => PlatformBlockedException(error.message),
    final kind => EngineFailureException(kind, error.message),
  };
}
