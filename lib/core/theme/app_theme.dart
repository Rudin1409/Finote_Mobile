import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class FinoteColors {
  static const Color primary = Color(0xFF37C8C3);
  static const Color background = Color(0xFF1C1C1C);
  static const Color surface = Color(0xFF2F2F2F);
  static const Color error = Color(0xFFFF5252);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
}

class FinoteLightColors {
  static const Color primary = Color(0xFF37C8C3);
  static const Color background = Color(0xFFF5F7FA); // Soft Grey/White
  static const Color surface = Color(0xFFFFFFFF); // Pure White
  static const Color error = Color(0xFFFF5252);
  static const Color textPrimary = Color(0xFF1E1E1E); // Dark Grey
  static const Color textSecondary = Color(0xFF757575); // Medium Grey
}

class FinoteTextStyles {
  // We need to make these adaptable or have separate styles for light/dark
  // For simplicity, let's keep the structure but we might need to override colors in ThemeData

  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get titleLarge => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleMedium => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: FinoteLightColors.background,
      primaryColor: FinoteLightColors.primary,
      colorScheme: const ColorScheme.light(
        primary: FinoteLightColors.primary,
        surface: FinoteLightColors.surface,
        error: FinoteLightColors.error,
        onPrimary: Colors.white,
        onSurface: FinoteLightColors.textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: FinoteTextStyles.displayLarge
            .copyWith(color: FinoteLightColors.textPrimary),
        titleLarge: FinoteTextStyles.titleLarge
            .copyWith(color: FinoteLightColors.textPrimary),
        titleMedium: FinoteTextStyles.titleMedium
            .copyWith(color: FinoteLightColors.textPrimary),
        bodyLarge: FinoteTextStyles.bodyLarge
            .copyWith(color: FinoteLightColors.textPrimary),
        bodyMedium: FinoteTextStyles.bodyMedium
            .copyWith(color: FinoteLightColors.textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: FinoteLightColors.background,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: FinoteTextStyles.titleLarge
            .copyWith(color: FinoteLightColors.textPrimary),
        iconTheme: const IconThemeData(color: FinoteLightColors.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FinoteLightColors.primary,
          foregroundColor: Colors.white,
          textStyle: FinoteTextStyles.titleMedium,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      cardTheme: CardThemeData(
        color: FinoteLightColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

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
        displayLarge: FinoteTextStyles.displayLarge
            .copyWith(color: FinoteColors.textPrimary),
        titleLarge: FinoteTextStyles.titleLarge
            .copyWith(color: FinoteColors.textPrimary),
        titleMedium: FinoteTextStyles.titleMedium
            .copyWith(color: FinoteColors.textPrimary),
        bodyLarge: FinoteTextStyles.bodyLarge
            .copyWith(color: FinoteColors.textPrimary),
        bodyMedium: FinoteTextStyles.bodyMedium
            .copyWith(color: FinoteColors.textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: FinoteColors.background,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: FinoteTextStyles.titleLarge
            .copyWith(color: FinoteColors.textPrimary),
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
