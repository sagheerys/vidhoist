import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import 'accounts_fields.dart';
import 'accounts_state.dart';

/// Reads the chosen file through the system picker, which reaches files
/// in Downloads that the app did not write; null when none was chosen.
Future<List<int>?> pickCookiesFile() async {
  final picked = await FilePicker.platform.pickFiles(withData: true);
  final file = picked?.files.singleOrNull;
  if (file == null) return null;
  if (file.bytes case final bytes?) return bytes;
  final path = file.path;
  return path == null ? null : File(path).readAsBytes();
}

/// The picker the import opens; a test hands its own file instead.
final cookiesPickerProvider = Provider<Future<List<int>?> Function()>(
  (ref) => pickCookiesFile,
);

/// **The other way in: a cookies file exported from a browser**, for
/// someone who would rather not sign in inside the app, or for a site with
/// no row above. It joins the sign-ins in the one file yt-dlp reads, and
/// the sites it brought that have no row are listed here, each removable.
class CookieFileFields extends ConsumerWidget {
  const CookieFileFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final text = Theme.of(context).textTheme;
    final p = VhThemeX.of(context).palette;
    final accounts = ref.watch(accountsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VhSectionHeader(title: l10n.accountsFileTitle),
        const SizedBox(height: VhSpace.sm),
        Text(
          l10n.accountsFileHint,
          style: text.bodySmall?.copyWith(
            color: p.ink2,
            fontSize: VhEmphasis.explain,
          ),
        ),
        const SizedBox(height: VhSpace.sm),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: OutlinedButton.icon(
            onPressed: accounts == null
                ? null
                : () => unawaited(_import(context, ref)),
            icon: const VhIcon(VhIcons.upload),
            label: Text(l10n.accountsFilePick),
          ),
        ),
        for (final site in ref.watch(fileOnlySitesProvider)) ...[
          const Divider(),
          AccountRow(
            label: site,
            state: l10n.accountsFromFile,
            icon: VhIcons.cookie,
            action: TextButton(
              onPressed: () =>
                  unawaited(ref.read(accountsProvider)?.forgetSite(site)),
              child: Text(l10n.remove),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final l10n = context.vhl;
    final messenger = ScaffoldMessenger.of(context);
    final accounts = ref.read(accountsProvider);
    final picked = await ref.read(cookiesPickerProvider)();
    if (picked == null || accounts == null) return;
    try {
      final sites = await accounts.importFile(picked);
      if (sites == null) {
        showVhSnackOn(
          messenger,
          l10n.cookiesNotNetscape,
          type: VhSnackType.error,
        );
        return;
      }
      showVhSnackOn(
        messenger,
        l10n.desktopCookiesKeptFor(vhLtrRun(sites.join(' · '))),
        type: VhSnackType.success,
      );
    } on FileSystemException catch (e) {
      showVhSnackOn(
        messenger,
        l10n.errorGeneric(e.message),
        type: VhSnackType.error,
      );
    }
  }
}
