import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FinoteColors {
  static const Color primary = Color(0xFF37C8C3);
  static const Color background = Color(0xFF1C1C1C);
  static const Color surface = Color(0xFF2F2F2F);
  static const Color error = Color(0xFFFF5252);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
}

class FinoteTextStyles {
  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: FinoteColors.textPrimary,
      );

  static TextStyle get titleLarge => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: FinoteColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: FinoteColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: FinoteColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: FinoteColors.textSecondary,
      );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: FinoteColors.background,
      primaryColor: FinoteColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: FinoteColors.primary,
        surface: FinoteColors.surface,
        error: FinoteColors.error,
        onPrimary: Colors.black,
        onSurface: FinoteColors.textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: FinoteTextStyles.displayLarge,
        titleLarge: FinoteTextStyles.titleLarge,
        titleMedium: FinoteTextStyles.titleMedium,
        bodyLarge: FinoteTextStyles.bodyLarge,
        bodyMedium: FinoteTextStyles.bodyMedium,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: FinoteColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: FinoteTextStyles.titleLarge,
        iconTheme: const IconThemeData(color: FinoteColors.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FinoteColors.primary,
          foregroundColor: Colors.black,
          textStyle: FinoteTextStyles.titleMedium,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
    );
  }
}
