import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFE8C97A);
  static const Color primaryDark = Color(
    0xFFD4A843,
  );
  static const Color background = Color(
    0xFFF5DFA0,
  );
  static const Color cardBg = Color(0xFFEDD98A);
  static const Color accent = Color(0xFF4A7C59);
  static const Color accentLight = Color(
    0xFF6BAB7E,
  );
  static const Color paid = Color(0xFF4A7C59);
  static const Color notPaid = Color(0xFFB85C38);
  static const Color roundBlue = Color(
    0xFF2563EB,
  ); // for current round chip
  static const Color textDark = Color(0xFF2C1F0E);
  static const Color textMid = Color(0xFF5C4A2A);
  static const Color textLight = Color(
    0xFF8C7A5A,
  );
  static const Color white = Color(0xFFFFFFFF);
  static const Color shadow = Color(0x33000000);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryDark,
      secondary: AppColors.accent,
      surface: AppColors.background,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.textDark,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
      iconTheme: IconThemeData(
        color: AppColors.textDark,
      ),
    ),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.white,
          elevation: 4,
        ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 24,
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white.withValues(
        alpha: 0.7,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.primaryDark.withValues(
            alpha: 0.4,
          ),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.primaryDark.withValues(
            alpha: 0.4,
          ),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.accent,
          width: 1.8,
        ),
      ),
      labelStyle: const TextStyle(
        color: AppColors.textMid,
      ),
      hintStyle: TextStyle(
        color: AppColors.textLight,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBg,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: AppColors.shadow,
    ),
  );
}
