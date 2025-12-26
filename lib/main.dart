import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'dart:async';
import 'core/theme/app_theme.dart';
import 'core/router.dart';
import 'core/utils/performance_utils.dart';
import 'core/services/audio_service.dart';
import 'core/services/playlist_audio_service.dart';

void main() async {
  // Crash prevention - catch all errors
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize audio service for background playback
    try {
      await AudioService.init(
        builder: () => PlaylistAudioService.instance,
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.spiritual.app.channel.audio',
          androidNotificationChannelName: 'SKS Audio',
          androidNotificationOngoing: true,
          androidShowNotificationBadge: true,
        ),
      );
    } catch (e) {
      debugPrint('Audio service init error: $e');
    }
    
    // Error handling for Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        FlutterError.presentError(details);
      } else {
        // Log error in release mode without crashing
        debugPrint('Flutter Error: ${details.exception}');
      }
    };
    
    // Initialize performance optimizations with error handling
    try {
      await PerformanceUtils.initialize();
    } catch (e) {
      debugPrint('Performance init error: $e');
    }
    
    // Performance optimizations
    if (!kDebugMode) {
      debugPrint = (String? message, {int? wrapWidth}) {};
    }
    
    // System UI with error handling
    try {
      PerformanceUtils.optimizeSystemUI();
      
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppTheme.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
      
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } catch (e) {
      debugPrint('System UI error: $e');
    }
    
    runApp(const SpiritualApp());
  }, (error, stack) {
    // Catch any uncaught errors
    debugPrint('Uncaught error: $error');
    if (kDebugMode) {
      debugPrint('Stack trace: $stack');
    }
  });
}

class SpiritualApp extends StatelessWidget {
  const SpiritualApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SKS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      
      // Error handling for widget errors
      builder: (context, child) {
        // Handle errors in widget tree
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return _buildErrorWidget(errorDetails);
        };
        
        if (child == null) {
          return _buildErrorWidget(null);
        }
        
        // Prevent font scaling beyond reasonable limits
        final mediaQueryData = MediaQuery.of(context);
        final constrainedTextScaleFactor = mediaQueryData.textScaleFactor.clamp(0.8, 1.3);
        
        return MediaQuery(
          data: mediaQueryData.copyWith(
            textScaleFactor: constrainedTextScaleFactor,
          ),
          child: child,
        );
      },
    );
  }
  
  Widget _buildErrorWidget(FlutterErrorDetails? errorDetails) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppTheme.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.saffron.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.refresh,
                      size: 40,
                      color: AppTheme.saffron,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Please restart the app to continue your spiritual journey.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.saffron,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Restart App'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
