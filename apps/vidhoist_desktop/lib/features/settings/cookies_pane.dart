import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/engine_data.dart';
import '../../data/folders_data.dart';
import '../../shell/folded_text.dart';
import 'appearance_pane.dart';
import 'simple_panes.dart';

/// How each browser is named on screen; the key is yt-dlp's own.
const _browserNames = {
  'edge': 'Edge',
  'chrome': 'Chrome',
  'firefox': 'Firefox',
  'brave': 'Brave',
  'opera': 'Opera',
};

/// The sites the kept cookies file signs in to.
final cookieSitesProvider = FutureProvider<List<String>>((ref) async {
  final path = ref.watch(engineOptionsProvider.select((o) => o.cookiesFile));
  if (path == null) return const [];
  try {
    return CookieFiles.sites(await File(path).readAsBytes());
  } on FileSystemException {
    return const [];
  }
});

/// **Cookies for the sites that want a login**, read by yt-dlp on this
/// computer: a file the browser exported (several chosen together are
/// merged into one), kept in the app's local folder and never in a
/// backup; or a browser whose own cookies yt-dlp reads. Nothing is sent
/// anywhere.
class CookiesPane extends ConsumerStatefulWidget {
  const CookiesPane({super.key});

  @override
  ConsumerState<CookiesPane> createState() => _CookiesPaneState();
}

class _CookiesPaneState extends ConsumerState<CookiesPane> {
  var _busy = false;

  Future<void> _choose() async {
    final l = context.vhl;
    final target = ref.read(cookiesFileTargetProvider);
    if (target == null) return;
    final files = await ref
        .read(desktopFoldersProvider)
        .openFiles(extensions: const ['txt']);
    if (files.isEmpty || !mounted) return;
    final bytes = CookieFiles.merge([for (final f in files) f.$2]);
    if (bytes == null) {
      showVhNotice(
        context,
        message: l.cookiesNotNetscape,
        kind: VhNoticeKind.failed,
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final file = File(target);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);
      await ref.read(engineOptionsProvider.notifier).setCookiesFile(target);
      ref.invalidate(cookieSitesProvider);
      final sites = CookieFiles.sites(bytes);
      if (mounted) {
        showVhNotice(
          context,
          message: sites.isEmpty
              ? l.desktopCookiesKept
              : l.desktopCookiesKeptFor(vhLtrRun(sites.join(' · '))),
          kind: VhNoticeKind.done,
        );
      }
    } on FileSystemException catch (e) {
      if (mounted) {
        showVhNotice(
          context,
          message: l.errorGeneric(e.message),
          kind: VhNoticeKind.failed,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove(String path) async {
    try {
      await File(path).delete();
    } on FileSystemException {
      // Already gone: forgetting it is all that is left to do.
    }
    await ref.read(engineOptionsProvider.notifier).setCookiesFile(null);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final options = ref.watch(engineOptionsProvider);
    final file = options.cookiesFile;
    final browsers = ref.read(engineOptionsProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FoldedText(
          l.desktopCookiesLocalHint,
          style: text.bodyMedium?.copyWith(color: p.ink2),
        ),
        const SizedBox(height: VhSpace.sm),
        SettingLine(
          title: l.desktopCookiesFile,
          value: file == null
              ? l.desktopCookiesNone
              : switch (ref.watch(cookieSitesProvider).valueOrNull) {
                  final sites? when sites.isNotEmpty => vhLtrRun(
                    sites.join(' · '),
                  ),
                  _ => l.desktopCookiesKept,
                },
          trailing: Wrap(
            spacing: VhSpace.xs,
            children: [
              VhLinkButton(
                label: l.desktopCookiesChoose,
                icon: VhIcons.cookie,
                onPressed: _busy ? null : () => unawaited(_choose()),
              ),
              if (file != null)
                VhLinkButton(
                  label: l.desktopCookiesRemove,
                  icon: VhIcons.trash,
                  danger: true,
                  onPressed: _busy ? null : () => unawaited(_remove(file)),
                ),
            ],
          ),
        ),
        ChoiceGroup(
          title: l.desktopCookiesBrowser,
          hint: l.desktopCookiesBrowserHint,
          children: [
            DesktopSegments(
              items: [
                DesktopSegment(
                  label: l.desktopCookiesNone,
                  selected: options.cookiesBrowser == null,
                  onTap: () => unawaited(browsers.setCookiesBrowser(null)),
                ),
                for (final browser in cookieBrowsers)
                  DesktopSegment(
                    label: _browserNames[browser] ?? browser,
                    selected: options.cookiesBrowser == browser,
                    onTap: () => unawaited(browsers.setCookiesBrowser(browser)),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: VhSpace.sm),
        FoldedText(
          l.desktopCookiesHelp,
          style: text.labelSmall?.copyWith(color: p.ink3),
        ),
      ],
    );
  }
}
