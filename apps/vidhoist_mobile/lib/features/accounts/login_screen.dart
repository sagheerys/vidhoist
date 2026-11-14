import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'accounts_state.dart';
import 'login_sites.dart';
import 'session_watch.dart';
import 'sign_in_popups.dart';

/// **A site's own sign-in page, inside the app.** The person signs in as
/// in any browser; the moment the site's session cookie appears, the
/// cookies are kept for yt-dlp and the page closes. It is looked for on
/// each page load, each change of address, and on a clock
/// ([SessionWatch]), since a site may sign in without loading a page.
/// "Done" asks at once, and says so if the session is not there yet.
///
/// Nothing of the sign-in passes through the app: the page talks to the
/// site, and the cookies travel from Android's jar to a file in the app's
/// private folder.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen(this.site, {super.key});

  final LoginSite site;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final WebViewController _web;
  late final _watch = SessionWatch(() => _finish(quiet: true));
  double _progress = 0;
  var _checking = false;
  var _closed = false;

  @override
  void initState() {
    super.initState();
    _web = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            if (mounted) setState(() => _progress = p / 100);
          },
          onPageFinished: (_) => unawaited(_finish(quiet: true)),
          onUrlChange: (_) => unawaited(_finish(quiet: true)),
        ),
      );
    unawaited(_open());
    _watch.start();
  }

  @override
  void dispose() {
    _watch.stop();
    super.dispose();
  }

  Future<void> _open() async {
    // The WebView's own agent names it a WebView, which Google refuses.
    final agent = await _web.getUserAgent();
    await _web.setUserAgent(browserUserAgent(agent ?? ''));
    await SignInPopups.attach(_web);
    await _web.loadRequest(Uri.parse(widget.site.loginUrl));
  }

  /// Keeps the cookies and leaves once the site is signed in. Quiet from a
  /// page load, where "not yet" is the usual answer; spoken from "Done".
  Future<void> _finish({required bool quiet}) async {
    if (_checking || _closed || !mounted) return;
    final accounts = ref.read(accountsProvider);
    if (accounts == null) return;
    _checking = true;
    final l10n = context.vhl;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final kept = await accounts.keep(widget.site);
      if (!mounted || _closed) return;
      if (kept) {
        _closed = true;
        _watch.stop();
        showVhSnackOn(
          messenger,
          l10n.loginKept(widget.site.label),
          type: VhSnackType.success,
        );
        context.pop();
      } else if (!quiet) {
        showVhSnackOn(messenger, l10n.loginNotYet);
      }
    } finally {
      _checking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    return Scaffold(
      appBar: AppBar(
        // The site's name alone: "Sign in to Instagram" did not fit the
        // large title on a phone, and the page below already says sign in.
        title: Text(widget.site.label),
        actions: [
          TextButton(
            onPressed: () => unawaited(_finish(quiet: false)),
            child: Text(l10n.loginDone),
          ),
        ],
        bottom: _progress < 1
            ? PreferredSize(
                preferredSize: const Size.fromHeight(12),
                child: VhProgressBar(value: _progress),
              )
            : null,
      ),
      body: WebViewWidget(controller: _web),
    );
  }
}
