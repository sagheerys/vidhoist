import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import 'simple_panes.dart';

/// The browser button: a bookmark whose address is this script, so one
/// click on a video's page opens `vidhoist://add` with the page's link. The
/// installer registers `vidhoist://`, and the link only opens the add
/// dialog, so a page can never add anything by itself.
const browserButtonCode =
    "javascript:location.href='vidhoist://add?url='"
    '+encodeURIComponent(location.href)';

/// **The setup page**, written for the browser: the button ready to drag
/// to the bookmarks bar, three steps, and the code to paste for a browser
/// that will not take a dragged link. In the app's language and colours.
String browserButtonPage(VhLocalizations l, VhPalette p, {required bool rtl}) {
  String text(String value) => const HtmlEscape().convert(value);
  String hex(Color c) =>
      '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  final code = const HtmlEscape(HtmlEscapeMode.attribute)
      .convert(browserButtonCode);
  return '''<!doctype html>
<html lang="${rtl ? 'ar' : 'en'}" dir="${rtl ? 'rtl' : 'ltr'}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${text(l.desktopBrowserPageTitle)}</title>
<style>
body{margin:0;background:${hex(p.bg)};color:${hex(p.ink)};
font:16px/1.7 Tajawal,"Segoe UI",Tahoma,sans-serif}
main{max-width:640px;margin:${VhSpace.xxl * 2}px auto;padding:0 ${VhSpace.lg}px}
h1{font-size:26px;margin:0 0 ${VhSpace.xl}px}
ol{padding-inline-start:${VhSpace.xl}px}li{margin:0 0 ${VhSpace.md}px}
kbd{direction:ltr;unicode-bidi:isolate;border:1px solid ${hex(p.line)};
border-radius:${VhRadius.badge}px;padding:0 ${VhSpace.xxs}px;
background:${hex(p.card)}}
.button{display:inline-block;margin:${VhSpace.xs}px 0 ${VhSpace.xxs}px;
padding:${VhSpace.sm}px ${VhSpace.xl}px;border-radius:999px;
background:${hex(p.accent)};color:${hex(p.onAccent)};
font-weight:700;text-decoration:none;cursor:grab}
.hint{color:${hex(p.ink3)};font-size:14px}
code{display:block;direction:ltr;text-align:left;word-break:break-all;
background:${hex(p.card)};border:1px solid ${hex(p.line)};
border-radius:${VhRadius.thumb}px;padding:${VhSpace.sm}px;
margin-top:${VhSpace.xs}px;user-select:all}
</style>
</head>
<body><main>
<h1>${text(l.desktopBrowserPageTitle)}</h1>
<ol>
<li>${text(l.desktopBrowserPageStep1)} <kbd>Ctrl+Shift+B</kbd></li>
<li>${text(l.desktopBrowserPageStep2)}<br>
<a class="button" href="$code" onclick="return false">${text(l.desktopBrowserButtonName)}</a>
<div class="hint">${text(l.desktopBrowserPageDragHint)}</div></li>
<li>${text(l.desktopBrowserPageStep3)}</li>
</ol>
<p class="hint">${text(l.desktopBrowserPageCopyInstead)}</p>
<code>${text(browserButtonCode)}</code>
</main></body>
</html>
''';
}

/// The settings line for the browser button: open the setup page, or copy
/// the code for a browser where dragging a link does not work.
class BrowserButtonLine extends StatelessWidget {
  const BrowserButtonLine({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    return SettingLine(
      title: l.desktopBrowserButton,
      hint: l.desktopBrowserButtonHint,
      trailing: Wrap(
        alignment: WrapAlignment.end,
        spacing: VhSpace.sm,
        children: [
          VhLinkButton(
            label: l.desktopBrowserButtonOpen,
            onPressed: () => unawaited(_open(context)),
          ),
          VhLinkButton(
            label: l.desktopBrowserButtonCopy,
            onPressed: () => unawaited(_copy(context)),
          ),
        ],
      ),
    );
  }

  static Future<void> _open(BuildContext context) async {
    final l = context.vhl;
    final page = browserButtonPage(
      l,
      VhThemeX.of(context).palette,
      rtl: Directionality.of(context) == TextDirection.rtl,
    );
    try {
      final file = File.fromUri(
        Directory.systemTemp.uri.resolve('vidhoist-browser-button.html'),
      );
      await file.writeAsString(page, flush: true);
      if (await launchUrl(Uri.file(file.path))) return;
    } on Object {
      // Said below, with the way that needs no page.
    }
    if (!context.mounted) return;
    showVhNotice(
      context,
      message: l.desktopBrowserButtonFailed,
      kind: VhNoticeKind.failed,
    );
  }

  static Future<void> _copy(BuildContext context) async {
    final message = context.vhl.desktopBrowserButtonCopied;
    await Clipboard.setData(const ClipboardData(text: browserButtonCode));
    if (context.mounted) showVhNotice(context, message: message);
  }
}
