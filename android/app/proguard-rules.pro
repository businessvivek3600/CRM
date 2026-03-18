# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Workmanager
-keep class be.tramckrijte.workmanager.** { *; }

# Geolocator
-keep class com.baseflow.geolocator.** { *; }

# Dio
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

# Gson (if used)
-keep class com.google.gson.** { *; }

-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }