import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

/// What the phone says when a call to the computer fails.
String pcFailureText(VhLocalizations l10n, PcLinkFailure failure) =>
    switch (failure) {
      PcLinkFailure.unreachable => l10n.pcErrUnreachable,
      PcLinkFailure.wrongCertificate => l10n.pcErrWrongCertificate,
      PcLinkFailure.unauthorized => l10n.pcErrUnauthorized,
      PcLinkFailure.pairingClosed => l10n.pcErrClosed,
      PcLinkFailure.wrongCode => l10n.pcErrWrongCode,
      PcLinkFailure.pairingDenied => l10n.pcErrDenied,
      PcLinkFailure.refused => l10n.pcErrRefused,
      PcLinkFailure.badResponse => l10n.pcErrBad,
    };
