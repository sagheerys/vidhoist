# youtubedl-android: its updater and request classes, and the JSON library
# it reads GitHub's answers with, are reached by name at runtime.
-keep class com.yausername.** { *; }
-keep class com.fasterxml.jackson.** { *; }
-dontwarn com.fasterxml.jackson.**
-keep class org.apache.commons.compress.** { *; }
-dontwarn org.apache.commons.compress.**

# WorkManager, for the channel check while the app is closed: it builds its
# Room database by reflection on the generated class's empty constructor,
# which R8 otherwise removes, and the app then fails before its first frame.
-keep class * extends androidx.room.RoomDatabase { <init>(); }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
