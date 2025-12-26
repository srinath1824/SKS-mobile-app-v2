@echo off
echo Building optimized APK for SKS Spiritual App...

echo.
echo Step 1: Cleaning previous builds...
call flutter clean

echo.
echo Step 2: Getting dependencies...
call flutter pub get

echo.
echo Step 3: Building release APK with optimizations...
call flutter build apk --release --shrink --obfuscate --split-debug-info=build/debug-info --target-platform android-arm,android-arm64

echo.
echo Step 4: Building App Bundle (recommended for Play Store)...
call flutter build appbundle --release --shrink --obfuscate --split-debug-info=build/debug-info

echo.
echo Build completed successfully!
echo.
echo APK Location: build\app\outputs\flutter-apk\app-release.apk
echo App Bundle Location: build\app\outputs\bundle\release\app-release.aab
echo.
echo For testing on different devices, use the APK file.
echo For Play Store upload, use the App Bundle file.

pause