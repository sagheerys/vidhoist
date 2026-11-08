import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// About: the version, the developer, the project, what it is built on,
/// and the disclaimer.
///
/// **The licence is named here, not only in the repository**: GPL-3.0
/// expects the user to find the copyright notice and the warranty
/// disclaimer **inside the program**, and "all rights reserved" would be
/// its literal opposite.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String _github = 'https://github.com/sagheerys';
  static const String _x = 'https://x.com/Sagheer700';
  static const String _repo = 'https://github.com/sagheerys/vidhoist';
  static const String _issues = '$_repo/issues';
  static const String _ytdlp = 'https://github.com/yt-dlp/yt-dlp';

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.about)),
      body: VhReadableWidth(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            VhSpace.pagePad,
            0,
            VhSpace.pagePad,
            VhSpace.xxl,
          ),
          children: [
            const SizedBox(height: VhSpace.lg),
            Center(
              child: Column(
                children: [
                  // **The app's own icon**, not a generic glyph: the screen
                  // that introduces the app is the first place its face
                  // should appear.
                  Image.asset(
                    'assets/icons/icon.png',
                    width: 76,
                    height: 76,
                    cacheWidth: (76 * MediaQuery.devicePixelRatioOf(context))
                        .round(),
                  ),
                  const SizedBox(height: VhSpace.md),
                  Text(l10n.appTitle, style: text.headlineMedium),
                  const SizedBox(height: VhSpace.xxs),
                  // **Without the build number**: `2.0.0+1` is Flutter's
                  // notation, and `+1` is an internal Android counter that
                  // means nothing to the user (field report).
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) => Text(
                      snapshot.hasData
                          ? '${l10n.version} ${snapshot.data!.version}'
                          : '',
                      style: text.bodySmall!.copyWith(color: p.ink3),
                    ),
                  ),
                  const SizedBox(height: VhSpace.xxs),
                  Text(
                    l10n.licensedUnder,
                    style: text.labelSmall!.copyWith(color: p.ink3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: VhSpace.xxl),
            VhSectionHeader(title: l10n.developer),
            _LinkTile(
              icon: VhIcons.code,
              title: l10n.developerName,
              subtitle: 'github.com/sagheerys',
              url: _github,
            ),
            _LinkTile(
              icon: VhIcons.mail,
              title: 'X',
              subtitle: 'x.com/Sagheer700',
              url: _x,
            ),
            _LinkTile(
              icon: VhIcons.bug,
              title: l10n.reportBug,
              subtitle: 'vidhoist/issues',
              url: _issues,
            ),
            const SizedBox(height: VhSpace.xl),
            VhSectionHeader(title: l10n.sourceCode),
            _LinkTile(
              icon: VhIcons.folder,
              title: l10n.sourceCode,
              subtitle: 'sagheerys/vidhoist',
              url: _repo,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: VhIcon(VhIcons.list, color: p.ink2),
              title: Text(l10n.licenses),
              trailing: const VhIcon(VhIcons.forward, matchTextDirection: true),
              onTap: () => showLicensePage(
                context: context,
                applicationName: l10n.appTitle,
                // The licences page lists the packages alone; the app's own
                // licence is passed here, or it would appear nowhere at all.
                applicationLegalese: '${l10n.copyright}\n${l10n.licensedUnder}',
              ),
            ),
            const SizedBox(height: VhSpace.xl),
            VhSectionHeader(title: l10n.builtWith),
            _LinkTile(
              icon: VhIcons.offline,
              title: 'yt-dlp',
              subtitle: l10n.ytdlpCredit,
              url: _ytdlp,
              ltrSubtitle: false,
            ),
            const SizedBox(height: VhSpace.xl),
            VhSectionHeader(title: l10n.disclaimer),
            const SizedBox(height: VhSpace.sm),
            // The disclaimer of affiliation comes first: the name says what
            // the app connects to, not who made it.
            Text(
              l10n.notAffiliated,
              style: text.bodySmall!.copyWith(
                color: p.ink2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: VhSpace.sm),
            Text(
              l10n.disclaimerText,
              style: text.bodySmall!.copyWith(color: p.ink2),
            ),
            const SizedBox(height: VhSpace.sm),
            Text(
              l10n.noWarranty,
              style: text.bodySmall!.copyWith(color: p.ink3),
            ),
            const SizedBox(height: VhSpace.xl),
            Center(
              child: Text(
                l10n.copyright,
                style: text.labelSmall!.copyWith(color: p.ink3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.url,
    this.ltrSubtitle = true,
  });

  final VhIconData icon;
  final String title;
  final String subtitle;
  final String url;

  /// URLs are isolated as LTR so their parts do not reverse in Arabic,
  /// while a translated description follows the language's direction.
  final bool ltrSubtitle;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: VhIcon(icon, color: p.ink2),
      title: Text(title),
      subtitle: Text(
        subtitle,
        textDirection: ltrSubtitle ? TextDirection.ltr : null,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: const VhIcon(VhIcons.external, size: 17),
      onTap: () =>
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
    );
  }
}
