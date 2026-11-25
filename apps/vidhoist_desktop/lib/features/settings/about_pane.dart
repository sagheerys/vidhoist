import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/update_data.dart';
import '../../identity.dart';
import '../../shell/desktop_mark.dart';
import '../discover/discover_dialog.dart';
import 'simple_panes.dart';
import 'whats_new.dart';
import '../../shell/folded_text.dart';

/// About: the version, the developer, the code and its licence, what it is
/// built on, and the disclaimer. GPL-3.0 expects the copyright notice and
/// the absence of warranty to be found **inside the program**, not in the
/// repository alone.
class AboutPane extends ConsumerWidget {
  const AboutPane({super.key});

  static const _github = 'https://github.com/sagheerys';
  static const _x = 'https://x.com/Sagheer700';
  static const _telegram = 'https://t.me/vidhoist';
  static const _repo = 'https://github.com/sagheerys/vidhoist';
  static const _ytdlp = 'https://github.com/yt-dlp/yt-dlp';

  static const _markSize = 56.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final version = ref.watch(installedVersionProvider).valueOrNull;
    Widget link(String title, String shown, String url, {String? hint}) =>
        SettingLine(
          title: title,
          hint: hint,
          trailing: VhLinkButton(
            label: shown,
            icon: VhIcons.external,
            onPressed: () => unawaited(
              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
            ),
          ),
        );
    Widget heading(String title) => Padding(
      padding: const EdgeInsets.only(top: VhSpace.lg, bottom: VhSpace.xxs),
      child: Text(title, style: text.titleSmall?.copyWith(color: p.ink)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The app's mark beside its name, as on its icon.
        Row(
          children: [
            const DesktopMark(size: _markSize),
            const SizedBox(width: VhSpace.md),
            Expanded(
              child: SettingLine(
                title: DesktopIdentity.displayName,
                // Without the build number: "+1" is the build tool's counter
                // and means nothing to the reader.
                value: version == null ? null : '${l.version} $version',
                hint: '${l.copyright} · ${l.licensedUnder}',
                trailing: VhLinkButton(
                  label: l.whatsNewThisVersion,
                  onPressed: () => unawaited(showWhatsNewNow(context, ref)),
                ),
              ),
            ),
          ],
        ),
        SettingLine(
          title: l.desktopDiscover,
          hint: l.desktopDiscoverHint,
          trailing: VhLinkButton(
            label: l.desktopDiscoverShow,
            onPressed: () => unawaited(showDiscoverDialog(context)),
          ),
        ),
        heading(l.developer),
        link(l.developerName, 'github.com/sagheerys', _github),
        link('X', 'x.com/Sagheer700', _x),
        link('Telegram', 't.me/vidhoist', _telegram),
        link(l.reportBug, 'vidhoist/issues', '$_repo/issues'),
        heading(l.sourceCode),
        link(l.sourceCode, 'sagheerys/vidhoist', _repo),
        SettingLine(
          title: l.licenses,
          trailing: VhLinkButton(
            label: l.licenses,
            onPressed: () => showLicensePage(
              context: context,
              applicationName: DesktopIdentity.displayName,
              applicationVersion: version,
              // The licences page lists the packages alone; the app's own
              // licence is passed here, or it would appear nowhere.
              applicationLegalese: '${l.copyright}\n${l.licensedUnder}',
            ),
          ),
        ),
        heading(l.builtWith),
        link('yt-dlp', 'yt-dlp/yt-dlp', _ytdlp, hint: l.ytdlpCredit),
        heading(l.disclaimer),
        // The disclaimer of affiliation first, so it is read before the
        // rest.
        Text(
          l.notAffiliated,
          style: text.bodySmall?.copyWith(
            color: p.ink2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: VhSpace.xs),
        FoldedText(
          l.disclaimerText,
          style: text.bodySmall?.copyWith(color: p.ink2),
        ),
      ],
    );
  }
}
