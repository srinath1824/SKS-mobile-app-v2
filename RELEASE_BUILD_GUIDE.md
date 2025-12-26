# SKS Spiritual App - Release Build Guide

## 📱 **Release Version: 1.0.0**
**Build Date**: December 2024  
**Target Platforms**: Android 5.0+, iOS 12.0+

---

## 🔧 **Build Commands**

### **Android APK (Direct Install)**
```bash
# Debug APK (for testing)
flutter build apk --debug

# Basic Release APK
flutter build apk --release

# Optimized Release APK (recommended)
flutter build apk --release --shrink --obfuscate --split-debug-info=build/debug-info --tree-shake-icons --dart-define=flutter.inspector.structuredErrors=false
```

### **Android App Bundle (Play Store Submission)**
```bash
# Basic Release AAB
flutter build appbundle --release

# Optimized Release AAB (recommended for Play Store)
flutter build appbundle --release --shrink --obfuscate --split-debug-info=build/debug-info --tree-shake-icons --dart-define=flutter.inspector.structuredErrors=false
```

### **iOS Build (Mac Required)**
```bash
# iOS Debug Build
flutter build ios --debug

# iOS Release Build
flutter build ios --release

# iOS App Store Archive
flutter build ipa --release --obfuscate --split-debug-info=build/debug-info
```

---

## 🚀 **Automated Build Scripts**

### **Production Build (Recommended)**
```bash
# Run optimized build script
build_optimized.bat
```

### **Verification Before Build**
```bash
# Verify setup and dependencies
verify_setup.bat
```

### **Manual Complete Build Process**
```bash
# Step-by-step manual build
flutter clean
flutter pub get
flutter analyze
flutter build apk --release --shrink --obfuscate --split-debug-info=build/debug-info --tree-shake-icons
flutter build appbundle --release --shrink --obfuscate --split-debug-info=build/debug-info --tree-shake-icons
```

---

## 📁 **Build Output Locations**

### **Android Files**
- **APK**: `build\app\outputs\flutter-apk\app-release.apk`
- **App Bundle**: `build\app\outputs\bundle\release\app-release.aab`
- **Debug Info**: `build\debug-info\`

### **iOS Files** (Mac Only)
- **iOS App**: `build\ios\Runner.app`
- **IPA Archive**: `build\ios\ipa\Runner.ipa`
- **Debug Symbols**: `build\ios\archive\Runner.xcarchive`

---

## 📊 **Build Specifications**

### **Android Build Config**
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: 34 (Android 14)
- **Compile SDK**: 34
- **Architecture**: ARM64-v8a, ARMv7
- **Obfuscation**: Enabled
- **Shrinking**: Enabled

### **iOS Build Config**
- **Deployment Target**: iOS 12.0
- **Architecture**: ARM64
- **Bitcode**: Disabled
- **Swift Version**: 5.0

### **Optimization Features**
- ✅ Code shrinking and obfuscation
- ✅ Resource shrinking
- ✅ Tree shaking for unused icons
- ✅ Split debug information
- ✅ Multi-architecture support
- ✅ Performance optimizations

---

## 🎯 **Release Targets**

### **For Testing**
```bash
flutter build apk --release
```
**Use**: Internal testing, device installation

### **For Play Store**
```bash
flutter build appbundle --release --shrink --obfuscate
```
**Use**: Google Play Store submission

### **For App Store** (Mac Required)
```bash
flutter build ipa --release --obfuscate
```
**Use**: Apple App Store submission

---

## 📋 **Pre-Build Checklist**

- [ ] All audio files in `assets/audio/` folder
- [ ] All image files in `assets/images/` folder
- [ ] Dependencies updated (`flutter pub get`)
- [ ] No build errors (`flutter analyze`)
- [ ] Version number updated in `pubspec.yaml`
- [ ] Signing keys configured (for production)

---

## 🔄 **Build Process**

### **Step 1: Preparation**
```bash
flutter clean
flutter pub get
flutter analyze
```

### **Step 2: Build**
```bash
# For Play Store
flutter build appbundle --release --shrink --obfuscate

# For Direct Install
flutter build apk --release --shrink --obfuscate
```

### **Step 3: Verification**
- Test APK on multiple devices
- Verify all features work
- Check app size and performance
- Confirm audio/video playback

---

## 📈 **Expected Build Results**

### **APK Size**
- **Optimized**: ~25MB
- **With Audio**: ~100MB total
- **Install Size**: ~60MB

### **Build Time**
- **Clean Build**: 3-5 minutes
- **Incremental**: 30-60 seconds

### **Compatibility**
- **Android**: 5.0+ (API 21-34)
- **iOS**: 12.0+ (Future release)
- **Devices**: All screen sizes and densities

---

## ⚡ **Quick Release Commands**

```bash
# Complete optimized build
build_optimized.bat

# Quick APK for testing
flutter build apk --release

# Play Store ready
flutter build appbundle --release --shrink --obfuscate

# iOS App Store ready (Mac only)
flutter build ipa --release --obfuscate
```

---

**📱 SKS Spiritual App v1.0.0 - Production Ready**  
**🚀 Use `build_optimized.bat` for best results**