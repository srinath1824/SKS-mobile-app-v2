import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Spiritual Color Palette
  static const Color saffron = Color(0xFFFF9933);
  static const Color lightSaffron = Color(0xFFFFB366);
  static const Color beige = Color(0xFFF5E6D3);
  static const Color white = Color(0xFFFFFBF5);
  static const Color gold = Color(0xFFD4AF37);
  static const Color darkBrown = Color(0xFF4A3728);
  static const Color softGray = Color(0xFFE8E0D5);
  
  // Cache text styles for better performance
  static late final TextStyle _displayLarge;
  static late final TextStyle _displayMedium;
  static late final TextStyle _headlineMedium;
  static late final TextStyle _titleLarge;
  static late final TextStyle _bodyLarge;
  static late final TextStyle _bodyMedium;
  static late final TextStyle _appBarTitle;
  static late final TextStyle _buttonText;
  
  static bool _initialized = false;
  
  static void _initializeTextStyles() {
    if (_initialized) return;
    
    _displayLarge = GoogleFonts.playfairDisplay(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: darkBrown,
    );
    _displayMedium = GoogleFonts.playfairDisplay(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: darkBrown,
    );
    _headlineMedium = GoogleFonts.lora(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: darkBrown,
    );
    _titleLarge = GoogleFonts.lora(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: darkBrown,
    );
    _bodyLarge = GoogleFonts.openSans(
      fontSize: 16,
      color: darkBrown,
    );
    _bodyMedium = GoogleFonts.openSans(
      fontSize: 14,
      color: darkBrown,
    );
    _appBarTitle = GoogleFonts.lora(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: darkBrown,
    );
    _buttonText = GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    
    _initialized = true;
  }
  
  static ThemeData get lightTheme {
    _initializeTextStyles();
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: saffron,
      scaffoldBackgroundColor: white,
      
      // Performance: Use const color scheme
      colorScheme: const ColorScheme.light(
        primary: saffron,
        secondary: gold,
        surface: white,
        background: beige,
        onPrimary: Colors.white,
        onSecondary: darkBrown,
        onSurface: darkBrown,
      ),
      
      textTheme: TextTheme(
        displayLarge: _displayLarge,
        displayMedium: _displayMedium,
        headlineMedium: _headlineMedium,
        titleLarge: _titleLarge,
        bodyLarge: _bodyLarge,
        bodyMedium: _bodyMedium,
      ),
      
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: darkBrown),
        titleTextStyle: _appBarTitle,
      ),
      
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        color: white,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: saffron,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: _buttonText,
        ),
      ),
      
      // Performance: Reduce unnecessary animations
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
  
  // Cached gradients for better performance
  static const LinearGradient spiritualGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      beige,
      white,
      Color(0x4DE8E0D5), // softGray.withOpacity(0.3)
    ],
  );
  
  static const LinearGradient saffronGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      saffron,
      lightSaffron,
    ],
  );
  
  static const BoxShadow softShadow = BoxShadow(
    color: Color(0x144A3728), // darkBrown.withOpacity(0.08)
    blurRadius: 12,
    offset: Offset(0, 4),
  );
  
  static const BoxShadow glowShadow = BoxShadow(
    color: Color(0x4DD4AF37), // gold.withOpacity(0.3)
    blurRadius: 20,
    spreadRadius: 2,
  );
}
