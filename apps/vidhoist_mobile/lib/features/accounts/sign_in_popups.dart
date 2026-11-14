import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

/// Gives a sign-in page real pop-up windows (`SignInPopups.kt`), so that
/// "Continue with Google" on another site can answer the page that opened
/// it instead of replacing it with a blank one.
abstract final class SignInPopups {
  static const methods = MethodChannel('vidhoist/popups');

  /// Whether [web] now opens its pop-ups as windows. False off Android, and
  /// where the app's side is missing (tests); the page then works as
  /// before, its pop-ups loaded in its place.
  static Future<bool> attach(WebViewController web) async {
    final platform = web.platform;
    if (platform is! AndroidWebViewController) return false;
    try {
      return await methods.invokeMethod<bool>('attach', {
            'id': platform.webViewIdentifier,
          }) ??
          false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
