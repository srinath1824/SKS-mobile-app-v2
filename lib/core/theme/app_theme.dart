import 'package:flutter/material.dart';

class AppTheme {
  // Premium Color Palette - Spiritual & Modern (Based on Reference Design)
  static const Color primary = Color(0xFFB8860B);        // Dark Golden Rod
  static const Color primaryLight = Color(0xFFE6D7B8);   // Warm Beige
  static const Color primaryDark = Color(0xFF2C3E50);    // Dark Navy
  
  static const Color secondary = Color(0xFFFF8C42);      // Warm Orange
  static const Color secondaryLight = Color(0xFFFFB366); // Light Orange
  static const Color accent = Color(0xFFFFD700);         // Spiritual Gold
  
  // Reference Design Colors
  static const Color warmBeige = Color(0xFFE6D7B8);      // Top gradient beige
  static const Color lightCream = Color(0xFFF5F1E8);     // Card background
  static const Color darkNavy = Color(0xFF2C3E50);       // Main content background
  static const Color cardBackground = Color(0xFFF8F6F0); // Quote card background
  
  // Sophisticated Neutrals
  static const Color surface = Color(0xFFF8F6F0);        // Card Surface
  static const Color surfaceVariant = Color(0xFFE6D7B8); // Beige Variant
  static const Color surfaceContainer = Color(0xFF2C3E50); // Dark Container
  
  // Text Colors with Better Contrast
  static const Color textPrimary = Color(0xFF2C3E50);    // Dark Navy Text
  static const Color textSecondary = Color(0xFF6B4E3D);  // Medium Brown
  static const Color textMuted = Color(0xFF8D7B68);      // Light Brown
  static const Color textOnDark = Color(0xFFFFFFFF);     // White text on dark
  
  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  
  // Legacy colors for backward compatibility
  static const Color saffron = primary;
  static const Color beige = warmBeige;
  static const Color darkBrown = darkNavy;
  static const Color white = surface;
  static const Color gold = accent;
  static const Color lightSaffron = primaryLight;
  static const Color lightOrange = secondaryLight;
  static const Color softGray = surfaceContainer;
  
  // Premium Gradients - Reference Design Inspired
  static const LinearGradient topGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE6D7B8), Color(0xFFF5F1E8)], // Warm beige to light cream
    stops: [0.0, 1.0],
  );
  
  static const LinearGradient spiritualGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE6D7B8), Color(0xFFF5F1E8), Color(0xFF2C3E50)], // Beige to navy
    stops: [0.0, 0.6, 1.0],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFDF7), Color(0xFFF8F6F0)],
  );
  
  static const LinearGradient saffronGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  // Premium Shadows
  static const BoxShadow softShadow = BoxShadow(
    color: Color(0x0A000000),
    offset: Offset(0, 1),
    blurRadius: 8,
    spreadRadius: 0,
  );
  
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x08000000),
    offset: Offset(0, 2),
    blurRadius: 12,
    spreadRadius: 0,
  );
  
  static const BoxShadow glowShadow = BoxShadow(
    color: Color(0x4DFFD700),
    blurRadius: 20,
    spreadRadius: 2,
  );
  
  // Design Tokens - Spacing
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double space2XL = 48.0;
  
  // Design Tokens - Border Radius
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;
  
  // Premium Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Inter', // Modern, clean font
    
    colorScheme: const ColorScheme.light(
      primary: primary,
      primaryContainer: primaryLight,
      secondary: secondary,
      secondaryContainer: secondaryLight,
      surface: surface,
      surfaceVariant: surfaceVariant,
      surfaceContainer: surfaceContainer,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      error: error,
    ),
    
    // Enhanced Typography with Modern Scale
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: textPrimary,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: textPrimary,
        letterSpacing: -0.3,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: textPrimary,
      ),
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: textPrimary,
        letterSpacing: -0.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: textMuted,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: textMuted,
        letterSpacing: 0.2,
      ),
    ),
    
    // Enhanced AppBar Theme
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: surface,
      foregroundColor: textPrimary,
      surfaceTintColor: Colors.transparent,
      shadowColor: Color(0x0A000000),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),
    
    // Enhanced Card Theme
    cardTheme: CardThemeData(
      elevation: 0,
      color: surface,
      surfaceTintColor: Colors.transparent,
      shadowColor: const Color(0x0A000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLG),
        side: BorderSide(
          color: surfaceContainer,
          width: 1,
        ),
      ),
    ),
    
    // Enhanced Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spaceLG,
          vertical: spaceMD,
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Enhanced Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      contentPadding: const EdgeInsets.all(spaceMD),
    ),
    
    // Enhanced Divider Theme
    dividerTheme: const DividerThemeData(
      color: surfaceContainer,
      thickness: 1,
      space: 1,
    ),
    
    scaffoldBackgroundColor: surface,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
