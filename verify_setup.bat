@echo off
echo Verifying SKS Spiritual App Setup...

echo.
echo Step 1: Checking Flutter installation...
call flutter doctor

echo.
echo Step 2: Checking dependencies...
call flutter pub get

echo.
echo Step 3: Analyzing code for issues...
call flutter analyze

echo.
echo Step 4: Running tests (if any)...
call flutter test

echo.
echo Step 5: Checking for build issues...
call flutter build apk --debug --verbose

echo.
echo Step 6: Verifying assets...
if exist "assets\audio\Sivoham_Mantra_15min_guided_Meditation.mp4" (
    echo ✓ Meditation audio file found
) else (
    echo ✗ Meditation audio file missing
)

if exist "assets\audio\Gundello_gudi_song.mp4" (
    echo ✓ Bhajan 1 found
) else (
    echo ✗ Bhajan 1 missing
)

if exist "assets\audio\Nirvana_Shatkam_song.mp4" (
    echo ✓ Bhajan 2 found
) else (
    echo ✗ Bhajan 2 missing
)

if exist "assets\audio\Jeeveswara_yogi_taluva_song.mp4" (
    echo ✓ Bhajan 3 found
) else (
    echo ✗ Bhajan 3 missing
)

echo.
echo ========================================
echo VERIFICATION COMPLETED!
echo ========================================
echo.
echo If all checks pass, the app is ready for:
echo - Development testing
echo - Production build
echo - Play Store deployment
echo.
echo To build production APK: build_optimized.bat

pause