import 'package:flutter/material.dart';

// Central place for theme colors
class AppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFFFF9800); // Orange
  static const Color primaryLightColor = Color(0xFFFFE0B2); // Light Orange
  static const Color primaryDarkColor = Color(0xFFF57C00); // Dark Orange

  // Text colors
  static const Color textColor =
      Color(0xFF5D4037); // Brown for better contrast with orange
  static const Color textLightColor = Color(0xFF8D6E63); // Light Brown

  // Accent colors
  static const Color accentColor = Color(0xFF4CAF50); // Green as accent
  static const Color successColor = Color(0xFF4CAF50); // Green for success
  static const Color warningColor =
      Color(0xFFFF5722); // Deep Orange for warnings

  // Background colors
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Color(0xFFFFF3E0); // Very Light Orange

  // Get a ThemeData object for MaterialApp
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: primaryColor,
        backgroundColor: Colors.grey.shade100,
        labelStyle: const TextStyle(color: textColor),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: primaryLightColor,
        thumbColor: primaryColor,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryLightColor;
          }
          return Colors.grey.shade300;
        }),
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        onPrimary: textColor,
      ),
    );
  }
}
