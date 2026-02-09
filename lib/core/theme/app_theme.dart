// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF673AB7);
  static const Color secondaryColor = Color(0xFF9575CD);
  static const Color accentColor = Color(0xFFD4AF37);

  // Softer purple variants for better gradients
  static const Color purpleLight = Color(0xFFBA68C8); // Used in gradient start
  static const Color purpleDeep = Color(0xFF512DA8); // Used in gradient end

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: accentColor,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.12),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black54),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: accentColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      cardColor: const Color(0xFF1A1A2E),
      shadowColor: Colors.black.withOpacity(0.4),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
    );
  }

  /// Updated: More elegant, soft radial gradient background with subtle overlay
  static BoxDecoration get gradientBackground {
    return BoxDecoration(
      gradient: const RadialGradient(
        center: Alignment(
          0.0,
          -0.4,
        ), // Slightly shifted upward for better visual balance
        radius: 1.8, // Larger radius → softer, more spread-out gradient
        colors: [
          purpleLight, // Starts lighter
          secondaryColor,
          primaryColor,
          purpleDeep, // Ends deeper for depth
        ],
        stops: [0.0, 0.35, 0.70, 1.0],
      ),
    );
  }

  /// Gold hub gradient – kept as premium focal point
  static Gradient get hubGradient => const LinearGradient(
    colors: [
      accentColor, // Bright gold
      Color(0xFFB8860B), // Darker gold for depth
      Color(0xFFA67C00), // Even deeper tone
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  // Optional: subtle glow/shimmer color used in animations
  static Color get glowColor => secondaryColor.withOpacity(0.6);
}
