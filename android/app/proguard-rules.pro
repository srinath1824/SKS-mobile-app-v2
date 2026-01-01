# Flutter-specific ProGuard rules for size optimization

# Keep Flutter engine classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# Keep Google Play Core classes
-keep class com.google.android.play.core.** { *; }

# Keep Dart VM classes
-keep class androidx.lifecycle.DefaultLifecycleObserver

# Keep cached_network_image classes
-keep class com.davemorrissey.labs.subscaleview.** { *; }

# Keep URL launcher classes  
-keep class io.flutter.plugins.urllauncher.** { *; }

# Keep go_router classes
-keep class com.example.go_router.** { *; }

# Keep all plugin classes
-keep class io.flutter.plugins.** { *; }
-keep class androidx.** { *; }

# Remove unused resources but be less aggressive
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**
-dontwarn com.google.android.play.core.**

# Less aggressive optimization
-optimizations !code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 2
-dontobfuscate

# Remove debug logging in release builds
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}