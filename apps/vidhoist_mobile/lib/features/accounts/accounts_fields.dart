import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_ui/vh_ui.dart';

import 'accounts_state.dart';
import 'login_sites.dart';

/// The route of a site's sign-in page.
String loginRoute(LoginSite site) => '/settings/login/${site.name}';

/// **Settings › Accounts**: one row per site, signed in or not, with its
/// sign-in or sign-out; and a way to forget every sign-in at once. The
/// sign-in opens the site's own page inside the app ([LoginScreen]); what
/// it leaves behind stays on this phone for yt-dlp alone.
class AccountsFields extends ConsumerWidget {
  const AccountsFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final text = Theme.of(context).textTheme;
    final p = VhThemeX.of(context).palette;
    final accounts = ref.watch(accountsProvider);
    final signedIn = ref.watch(signedInSitesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.accountsHint, style: text.bodySmall?.copyWith(color: p.ink2)),
        const SizedBox(height: VhSpace.sm),
        AccountRiskNote(text: l10n.accountsBanRisk),
        const SizedBox(height: VhSpace.sm),
        for (final site in LoginSite.values)
          _SiteRow(
            site: site,
            signedIn: signedIn.contains(site),
            onSignIn: accounts == null
                ? null
                : () => unawaited(context.push(loginRoute(site))),
            onSignOut: accounts == null
                ? null
                : () => unawaited(_forget(context, ref, site)),
          ),
        if (signedIn.isNotEmpty) ...[
          const SizedBox(height: VhSpace.sm),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: p.err),
              onPressed: () => unawaited(_forgetAll(context, ref)),
              icon: const VhIcon(VhIcons.trash),
              label: Text(l10n.accountsClearAll),
            ),
          ),
        ],
        const SizedBox(height: VhSpace.md),
        Text(l10n.accountsHelp, style: text.bodySmall?.copyWith(color: p.ink3)),
      ],
    );
  }

  Future<void> _forget(
    BuildContext context,
    WidgetRef ref,
    LoginSite site,
  ) async {
    final l10n = context.vhl;
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(accountsProvider)?.forget(site);
    showVhSnackOn(messenger, l10n.accountSignedOutOf(site.label));
  }

  Future<void> _forgetAll(BuildContext context, WidgetRef ref) async {
    final l10n = context.vhl;
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(accountsProvider)?.forgetAll();
    showVhSnackOn(messenger, l10n.accountsCleared);
  }
}

/// The warning that sits before any sign-in: yt-dlp's own guide says an
/// account used with it can be restricted, so the owner should learn it
/// here rather than from a locked account.
class AccountRiskNote extends StatelessWidget {
  const AccountRiskNote({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final style = Theme.of(context).textTheme.bodySmall;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: VhIcon(VhIcons.alert, color: p.err),
        ),
        const SizedBox(width: VhSpace.sm),
        Expanded(child: Text(text, style: style)),
      ],
    );
  }
}

/// One site: its name and state beside the icon, and under them the one
/// action that fits. The button sits under the words rather than beside
/// them so that the largest text on the narrowest phone still fits.
class _SiteRow extends StatelessWidget {
  const _SiteRow({
    required this.site,
    required this.signedIn,
    required this.onSignIn,
    required this.onSignOut,
  });

  final LoginSite site;
  final bool signedIn;
  final VoidCallback? onSignIn;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: VhSpace.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: VhIcon(VhIcons.globe),
          ),
          const SizedBox(width: VhSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  site.label,
                  textDirection: TextDirection.ltr,
                  style: text.bodyMedium,
                ),
                Text(
                  signedIn ? l10n.accountSignedIn : l10n.accountSignedOut,
                  style: text.bodySmall,
                ),
                const SizedBox(height: VhSpace.xs),
                if (signedIn)
                  TextButton(
                    onPressed: onSignOut,
                    child: Text(l10n.accountSignOut),
                  )
                else
                  FilledButton.tonal(
                    onPressed: onSignIn,
                    child: Text(l10n.accountSignIn),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The accounts row's line on the settings home: who is signed in, or
/// what the page is for.
String accountsSummary(VhLocalizations l10n, Set<LoginSite> signedIn) =>
    signedIn.isEmpty
    ? l10n.cookiesSubtitle
    : l10n.settingsValueSignedIn(
        vhLtrRun(
          [
            for (final site in LoginSite.values)
              if (signedIn.contains(site)) site.label,
          ].join(' · '),
        ),
      );
