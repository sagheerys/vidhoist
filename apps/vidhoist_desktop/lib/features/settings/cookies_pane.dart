import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';

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
    final l = context.mtl;
    final target = ref.read(cookiesFileTargetProvider);
    if (target == null) return;
    final files = await ref
        .read(desktopFoldersProvider)
        .openFiles(extensions: const ['txt']);
    if (files.isEmpty || !mounted) return;
    final bytes = CookieFiles.merge([for (final f in files) f.$2]);
    if (bytes == null) {
      showMTNotice(
        context,
        message: l.cookiesNotNetscape,
        kind: MTNoticeKind.failed,
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
        showMTNotice(
          context,
          message: sites.isEmpty
              ? l.desktopCookiesKept
              : l.desktopCookiesKeptFor(mtLtrRun(sites.join(' · '))),
          kind: MTNoticeKind.done,
        );
      }
    } on FileSystemException catch (e) {
      if (mounted) {
        showMTNotice(
          context,
          message: l.errorGeneric(e.message),
          kind: MTNoticeKind.failed,
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
    final l = context.mtl;
    final p = MTThemeX.of(context).palette;
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
        const SizedBox(height: MTSpace.sm),
        SettingLine(
          title: l.desktopCookiesFile,
          value: file == null
              ? l.desktopCookiesNone
              : switch (ref.watch(cookieSitesProvider).valueOrNull) {
                  final sites? when sites.isNotEmpty => mtLtrRun(
                    sites.join(' · '),
                  ),
                  _ => l.desktopCookiesKept,
                },
          trailing: Wrap(
            spacing: MTSpace.xs,
            children: [
              MTLinkButton(
                label: l.desktopCookiesChoose,
                icon: MTIcons.cookie,
                onPressed: _busy ? null : () => unawaited(_choose()),
              ),
              if (file != null)
                MTLinkButton(
                  label: l.desktopCookiesRemove,
                  icon: MTIcons.trash,
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
            EmberSegments(
              items: [
                EmberSegment(
                  label: l.desktopCookiesNone,
                  selected: options.cookiesBrowser == null,
                  onTap: () => unawaited(browsers.setCookiesBrowser(null)),
                ),
                for (final browser in cookieBrowsers)
                  EmberSegment(
                    label: _browserNames[browser] ?? browser,
                    selected: options.cookiesBrowser == browser,
                    onTap: () => unawaited(browsers.setCookiesBrowser(browser)),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: MTSpace.sm),
        FoldedText(
          l.desktopCookiesHelp,
          style: text.labelSmall?.copyWith(color: p.ink3),
        ),
      ],
    );
  }
}
