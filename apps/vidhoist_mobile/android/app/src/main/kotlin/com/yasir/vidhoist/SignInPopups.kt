package com.yasir.vidhoist

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Dialog
import android.content.res.Configuration
import android.graphics.Color
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.Message
import android.view.View
import android.view.ViewGroup
import android.view.WindowInsets
import android.view.WindowInsetsController
import android.webkit.ConsoleMessage
import android.webkit.GeolocationPermissions
import android.webkit.JsPromptResult
import android.webkit.JsResult
import android.webkit.PermissionRequest
import android.webkit.ValueCallback
import android.webkit.WebChromeClient
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.FrameLayout
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.webviewflutter.WebChromeClientProxyApi
import io.flutter.plugins.webviewflutter.WebViewFlutterAndroidExternalApi

/**
 * **Real windows for a sign-in page's pop-ups**, on the `vidhoist/popups`
 * channel.
 *
 * "Continue with Google" on X (and on other sites) opens Google in a window
 * of its own, which hands the answer back to the page that opened it and
 * closes. The WebView plugin loads such a window into the page itself, so
 * the page that asked was gone, Google had no one to answer, and the person
 * was left on a blank page, signed in nowhere. Here the window is a second
 * WebView above the first, still its opener's, and it goes away when the
 * page closes it or the person backs out of it.
 *
 * Everything else the plugin's own client did (the progress bar, alerts,
 * file pickers) is passed on to it untouched.
 */
object SignInPopups {
    private const val CHANNEL = "vidhoist/popups"
    private const val MATCH = ViewGroup.LayoutParams.MATCH_PARENT

    fun register(activity: Activity, engine: FlutterEngine) {
        MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "attach" -> {
                    val id = (call.argument<Number>("id"))?.toLong()
                    @Suppress("DEPRECATION")
                    val web = id?.let { WebViewFlutterAndroidExternalApi.getWebView(engine, it) }
                    // A plugin that changed its WebView must cost the pop-ups
                    // only, never the app: the first try here closed it.
                    val attached = web != null && try {
                        val theirs = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) web.webChromeClient else null
                        web.webChromeClient = Opener(activity, theirs)
                        true
                    } catch (e: Throwable) {
                        false
                    }
                    result.success(attached)
                }
                else -> result.notImplemented()
            }
        }
    }

    /**
     * The sign-in page's client: pop-ups here, the rest to the plugin's.
     * Of the plugin's own kind, as its WebView takes no other.
     */
    private class Opener(
        private val activity: Activity,
        private val theirs: WebChromeClient?,
    ) : WebChromeClientProxyApi.SecureWebChromeClient() {
        @SuppressLint("SetJavaScriptEnabled")
        override fun onCreateWindow(view: WebView, isDialog: Boolean, isUserGesture: Boolean, resultMsg: Message): Boolean {
            val transport = resultMsg.obj as? WebView.WebViewTransport ?: return false
            val popup = WebView(activity)
            popup.settings.apply {
                javaScriptEnabled = true
                domStorageEnabled = true
                javaScriptCanOpenWindowsAutomatically = true
                // Google turns away anything that names itself a WebView;
                // the opener's agent has already been made a browser's.
                userAgentString = view.settings.userAgentString
            }
            val window = Dialog(activity, android.R.style.Theme_Material_Light_NoActionBar)
            popup.webViewClient = WebViewClient()
            popup.webChromeClient = object : WebChromeClient() {
                override fun onCloseWindow(closing: WebView) {
                    window.dismiss()
                }
            }
            // Clear of the status bar and the keyboard: drawn under them,
            // Google's header sat beneath the clock and its fields beneath
            // the keys.
            val frame = FrameLayout(activity)
            frame.addView(popup, FrameLayout.LayoutParams(MATCH, MATCH))
            frame.setOnApplyWindowInsetsListener { v, insets ->
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    val bars = insets.getInsets(WindowInsets.Type.systemBars() or WindowInsets.Type.ime())
                    v.setPadding(bars.left, bars.top, bars.right, bars.bottom)
                } else {
                    @Suppress("DEPRECATION")
                    v.setPadding(
                        insets.systemWindowInsetLeft,
                        insets.systemWindowInsetTop,
                        insets.systemWindowInsetRight,
                        insets.systemWindowInsetBottom,
                    )
                }
                insets
            }
            window.setContentView(frame, ViewGroup.LayoutParams(MATCH, MATCH))
            // The bars over it in the phone's own light or dark, as the
            // sign-in pages follow it: white icons over a white page left
            // the clock unreadable.
            val night = (activity.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK) ==
                Configuration.UI_MODE_NIGHT_YES
            frame.setBackgroundColor(if (night) Color.BLACK else Color.WHITE)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                val light = WindowInsetsController.APPEARANCE_LIGHT_STATUS_BARS or
                    WindowInsetsController.APPEARANCE_LIGHT_NAVIGATION_BARS
                window.window?.insetsController?.setSystemBarsAppearance(if (night) 0 else light, light)
            }
            window.setOnKeyListener { _, keyCode, event ->
                if (keyCode == android.view.KeyEvent.KEYCODE_BACK &&
                    event.action == android.view.KeyEvent.ACTION_UP &&
                    popup.canGoBack()
                ) {
                    popup.goBack()
                    true
                } else {
                    false
                }
            }
            window.setOnDismissListener { popup.destroy() }
            window.show()
            transport.webView = popup
            resultMsg.sendToTarget()
            return true
        }

        override fun onProgressChanged(view: WebView, newProgress: Int) {
            theirs?.onProgressChanged(view, newProgress)
        }

        override fun onReceivedTitle(view: WebView, title: String?) {
            theirs?.onReceivedTitle(view, title)
        }

        override fun onReceivedIcon(view: WebView, icon: Bitmap?) {
            theirs?.onReceivedIcon(view, icon)
        }

        override fun onShowCustomView(view: View, callback: CustomViewCallback) {
            theirs?.onShowCustomView(view, callback) ?: callback.onCustomViewHidden()
        }

        override fun onHideCustomView() {
            theirs?.onHideCustomView()
        }

        override fun onShowFileChooser(
            webView: WebView,
            filePathCallback: ValueCallback<Array<Uri>>,
            fileChooserParams: FileChooserParams,
        ): Boolean = theirs?.onShowFileChooser(webView, filePathCallback, fileChooserParams) ?: false

        override fun onPermissionRequest(request: PermissionRequest) {
            theirs?.onPermissionRequest(request) ?: request.deny()
        }

        override fun onPermissionRequestCanceled(request: PermissionRequest) {
            theirs?.onPermissionRequestCanceled(request)
        }

        override fun onGeolocationPermissionsShowPrompt(origin: String, callback: GeolocationPermissions.Callback) {
            theirs?.onGeolocationPermissionsShowPrompt(origin, callback)
        }

        override fun onGeolocationPermissionsHidePrompt() {
            theirs?.onGeolocationPermissionsHidePrompt()
        }

        override fun onConsoleMessage(consoleMessage: ConsoleMessage): Boolean =
            theirs?.onConsoleMessage(consoleMessage) ?: false

        override fun onJsAlert(view: WebView, url: String?, message: String?, result: JsResult): Boolean =
            theirs?.onJsAlert(view, url, message, result) ?: false

        override fun onJsConfirm(view: WebView, url: String?, message: String?, result: JsResult): Boolean =
            theirs?.onJsConfirm(view, url, message, result) ?: false

        override fun onJsPrompt(
            view: WebView,
            url: String?,
            message: String?,
            defaultValue: String?,
            result: JsPromptResult,
        ): Boolean = theirs?.onJsPrompt(view, url, message, defaultValue, result) ?: false
    }
}
