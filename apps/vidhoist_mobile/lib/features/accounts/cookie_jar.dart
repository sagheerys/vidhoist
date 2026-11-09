import 'package:flutter/services.dart';

/// The in-app browser's cookies, as Android keeps them for every WebView
/// of the app (`CookieJar.kt`).
abstract interface class WebCookieJar {
  /// Each page's cookies as the one `Cookie:` header the browser would
  /// send it (`SID=a; HSID=b`), HTTP-only ones included; a page with none
  /// has an empty string.
  Future<Map<String, String>> headers(List<String> urls);

  /// Signs the browser out of every site: its cookies and storage go.
  Future<void> clear();
}

/// [WebCookieJar] over a method channel.
class MethodChannelWebCookieJar implements WebCookieJar {
  const MethodChannelWebCookieJar();

  static const methods = MethodChannel('vidhoist/cookies');

  @override
  Future<Map<String, String>> headers(List<String> urls) async {
    final answer = await methods.invokeMapMethod<String, String?>('headers', {
      'urls': urls,
    });
    return {
      for (final MapEntry(:key, :value) in (answer ?? const {}).entries)
        key: value ?? '',
    };
  }

  @override
  Future<void> clear() => methods.invokeMethod<void>('clear');
}
