import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';

/// The most links one share starts. A share of a whole conversation or a
/// web page can carry hundreds, each a download on this phone.
const int maxSharedLinks = 50;

/// Several links shared at once: asked about first, then started together.
///
/// **Why asked**: a single link opens the add sheet, but a share holding
/// several started every one of them at once, with nothing to stop it.
/// Sharing a chat or a page by mistake was enough to fill the download
/// queue and, behind it, the phone's storage.
/// [capped] says the share held more than [maxSharedLinks], of which
/// [urls] are the first.
Future<void> submitSharedLinks(
  BuildContext context,
  WidgetRef ref,
  List<String> urls, {
  required bool capped,
  required void Function(String step) note,
}) async {
  final engine = ref.read(downloadEngineProvider);
  if (engine == null) return note('share dropped: no engine');
  final l10n = context.vhl;
  final go = await showVhConfirm(
    context,
    title: l10n.sharedLinksTitle(urls.length),
    message: l10n.sharedLinksBody,
    confirmLabel: l10n.sharedLinksAdd,
    cancelLabel: l10n.cancel,
  );
  if (!go || !context.mounted) {
    return note('share of ${urls.length} links declined');
  }
  note('share of ${urls.length} links');
  final quality = ref.read(settingsProvider).quality;
  for (final url in urls) {
    if (PlaylistDetector.isPlaylist(url)) {
      GoRouter.of(context).push('/batch', extra: url);
    } else {
      engine.submit(url, quality, isBatchMember: true);
    }
  }
  showVhSnack(
    context,
    capped ? l10n.sharedLinksCapped(maxSharedLinks) : l10n.downloadStarted,
    type: capped ? VhSnackType.info : VhSnackType.success,
  );
}
