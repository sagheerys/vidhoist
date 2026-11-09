import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing is read from key.properties, which is not in this
// repository. Create your own keystore, or build debug.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.yasir.vidhoist"
    // Pinned explicitly rather than taken from Flutter's default.
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Required by flutter_local_notifications.
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "com.yasir.vidhoist"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = (keystoreProperties["storeFile"] as String?)?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    // youtubedl-android runs Python and ffmpeg from the native library
    // folder, so the libraries must be extracted at install.
    packaging {
        jniLibs.useLegacyPackaging = true
    }

    buildTypes {
        release {
            // The engine's classes are reached by name from its own code;
            // the shrinker must not rename or drop them.
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
            signingConfig = if (keystorePropertiesFile.exists())
                signingConfigs.getByName("release")
            else
                signingConfigs.getByName("debug")
            // **A trap caught on a real device.** The resource shrinker
            // removes every `drawable/audio_service_*`, because nothing
            // references them statically — and `audio_service` looks them up
            // **by name at runtime** (`getIdentifier`). In release builds only,
            // the result is `IllegalArgumentException: You must specify an icon
            // resource id to build a CustomAction` on every play, so there is
            // **no media notification and no lock-screen controls at all**,
            // with nothing visibly wrong in the UI. Proven with `aapt2 dump
            // resources`: zero audio_service resources. Shrinking saves under a
            // megabyte out of 41, which is not worth a silent defect.
            isShrinkResources = false
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    // yt-dlp with its Python and QuickJS, and ffmpeg (docs/ENGINE.md).
    implementation("io.github.junkfood02.youtubedl-android:library:0.18.1")
    implementation("io.github.junkfood02.youtubedl-android:ffmpeg:0.18.1")
    // The computer's pairing QR code (QrScanner): zxing, Apache 2.0, no
    // Google Play services.
    implementation("com.journeyapps:zxing-android-embedded:4.3.0")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
