import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'role_theme_extension.dart';
import '../constants/app_typography.dart';
import '../constants/app_radius.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      extensions: const [
        RoleThemeExtension.light,
      ],
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        displaySmall: AppTypography.displaySmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ).apply(
        bodyColor: AppColors.textPrimaryLight,
        displayColor: AppColors.textPrimaryLight,
        fontFamily: AppTypography.fontFamily,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.rMD,
          side: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: BorderSide(color: AppColors.borderLight, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: BorderSide(color: AppColors.borderLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.rMD),
          textStyle: AppTypography.labelLarge,
          elevation: 0,
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      extensions: const [
        RoleThemeExtension.dark,
      ],
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryDark,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        displaySmall: AppTypography.displaySmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ).apply(
        bodyColor: AppColors.textPrimaryDark,
        displayColor: AppColors.textPrimaryDark,
        fontFamily: AppTypography.fontFamily,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.rMD,
          side: BorderSide(color: AppColors.borderDark, width: 1),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: BorderSide(color: AppColors.borderDark, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: BorderSide(color: AppColors.borderDark, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.rMD),
          textStyle: AppTypography.labelLarge,
          elevation: 0,
        ),
      ),
    );
  }

  // Aliases for supplier compatibility
  static ThemeData get lightTheme => light;
  static ThemeData get darkTheme => dark;
}
