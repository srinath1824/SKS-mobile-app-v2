@echo off
echo Building production-ready SKS Spiritual App...

echo.
echo Step 1: Cleaning previous builds...
call flutter clean

echo.
echo Step 2: Getting dependencies...
call flutter pub get

echo.
echo Step 3: Running code generation (if any)...
call flutter packages pub run build_runner build --delete-conflicting-outputs

echo.
echo Step 4: Building optimized release APK...
call flutter build apk --release --shrink --obfuscate --split-debug-info=build/debug-info --target-platform android-arm,android-arm64 --tree-shake-icons --dart-define=flutter.inspector.structuredErrors=false

echo.
echo Step 5: Building App Bundle for Play Store...
call flutter build appbundle --release --shrink --obfuscate --split-debug-info=build/debug-info --tree-shake-icons --dart-define=flutter.inspector.structuredErrors=false

echo.
echo Step 6: Analyzing APK size...
call flutter build apk --analyze-size --target-platform android-arm64

echo.
echo ========================================
echo BUILD COMPLETED SUCCESSFULLY!
echo ========================================
echo.
echo APK Location: build\app\outputs\flutter-apk\
echo App Bundle Location: build\app\outputs\bundle\release\app-release.aab
echo.
echo Optimizations Applied:
echo - Code shrinking and obfuscation
echo - Resource shrinking
echo - Tree shaking for unused icons
echo - Split debug info for crash reporting
echo - Multi-architecture support
echo - Performance optimizations
echo.
echo For Play Store: Use app-release.aab
echo For direct install: Use app-release.apk

pause