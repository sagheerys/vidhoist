package com.yasir.vidhoist

import android.webkit.CookieManager
import android.webkit.WebStorage
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * The in-app browser's cookies, for Dart's `MethodChannelWebCookieJar`.
 *
 * Android keeps one jar for every WebView of the app, and `getCookie` hands
 * a page's cookies back as the `Cookie:` header the browser would send it,
 * HTTP-only ones included (only a page's JavaScript is kept from those).
 * That header is all yt-dlp needs for a sign-in; Dart writes it in the file
 * format yt-dlp reads. `clear` signs the browser out of everything: the
 * jar and the pages' storage.
 */
object CookieJar {
    private const val CHANNEL = "vidhoist/cookies"

    fun register(messenger: BinaryMessenger) {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "headers" -> {
                    val urls = call.argument<List<String>>("urls").orEmpty()
                    val jar = CookieManager.getInstance()
                    result.success(urls.associateWith { jar.getCookie(it) ?: "" })
                }
                "clear" -> {
                    val jar = CookieManager.getInstance()
                    jar.removeAllCookies {
                        jar.flush()
                        WebStorage.getInstance().deleteAllData()
                        result.success(true)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
