import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class PerformanceUtils {
  static bool _isLowEndDevice = false;
  static bool _initialized = false;
  
  /// Initialize performance settings based on device capabilities
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      final deviceInfo = DeviceInfoPlugin();
      
      if (Platform.isAndroid) {
        try {
          final androidInfo = await deviceInfo.androidInfo;
          final sdkInt = androidInfo.version.sdkInt;
          _isLowEndDevice = sdkInt < 26;
        } catch (e) {
          _isLowEndDevice = false;
        }
      } else if (Platform.isIOS) {
        try {
          final iosInfo = await deviceInfo.iosInfo;
          final model = iosInfo.model.toLowerCase();
          _isLowEndDevice = model.contains('iphone 6') || 
                           model.contains('iphone 7') ||
                           model.contains('iphone se');
        } catch (e) {
          _isLowEndDevice = false;
        }
      }
    } catch (e) {
      _isLowEndDevice = false;
    }
    
    _initialized = true;
  }
  
  /// Get optimized image cache size based on device
  static int getImageCacheSize() {
    return _isLowEndDevice ? 50 : 100; // MB
  }
  
  /// Get optimized animation duration
  static Duration getAnimationDuration() {
    return _isLowEndDevice 
        ? const Duration(milliseconds: 200)
        : const Duration(milliseconds: 300);
  }
  
  /// Check if device should use reduced animations
  static bool shouldReduceAnimations() {
    return _isLowEndDevice;
  }
  
  /// Get optimized list item extent for better scrolling
  static double getListItemExtent() {
    return _isLowEndDevice ? 60.0 : 80.0;
  }
  
  /// Optimize system UI for performance
  static void optimizeSystemUI() {
    try {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top],
      );
    } catch (e) {
      // Fallback to basic system UI if advanced features fail
      try {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
      } catch (e2) {
        // Ignore if system UI cannot be set
      }
    }
  }
  
  /// Get optimized blur radius for shadows
  static double getBlurRadius() {
    return _isLowEndDevice ? 8.0 : 12.0;
  }
  
  /// Check if device supports advanced graphics
  static bool supportsAdvancedGraphics() {
    return !_isLowEndDevice;
  }
  
  /// Optimize widget rebuilds
  static Widget optimizedBuilder({
    required Widget Function() builder,
    List<Object?>? dependencies,
  }) {
    return Builder(
      builder: (context) {
        // Use RepaintBoundary for expensive widgets on low-end devices
        final child = builder();
        return _isLowEndDevice 
            ? RepaintBoundary(child: child)
            : child;
      },
    );
  }
  
  /// Get optimized cache extent for lists
  static double getCacheExtent() {
    return _isLowEndDevice ? 200.0 : 400.0;
  }
}

/// Custom scroll physics for better performance
class OptimizedScrollPhysics extends ScrollPhysics {
  const OptimizedScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);
  
  @override
  OptimizedScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return OptimizedScrollPhysics(parent: buildParent(ancestor));
  }
  
  @override
  double get minFlingVelocity => PerformanceUtils.shouldReduceAnimations() ? 100.0 : 50.0;
  
  @override
  double get maxFlingVelocity => PerformanceUtils.shouldReduceAnimations() ? 4000.0 : 8000.0;
}