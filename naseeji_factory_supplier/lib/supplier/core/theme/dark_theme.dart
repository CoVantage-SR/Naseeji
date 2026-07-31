import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme_colors.dart';
import 'theme_radius.dart';
import 'theme_typography.dart';
import 'theme_extensions.dart';

ThemeData buildDarkTheme() {
  const colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromARGB(255, 60, 51, 234),
    onPrimary: AppThemeColors.darkOnPrimary,
    primaryContainer: AppThemeColors.darkPrimaryContainer,
    onPrimaryContainer: AppThemeColors.darkOnPrimaryContainer,
    secondary: AppThemeColors.darkSecondary,
    onSecondary: AppThemeColors.darkOnSecondary,
    secondaryContainer: AppThemeColors.darkSecondaryContainer,
    onSecondaryContainer: AppThemeColors.darkOnSecondaryContainer,
    error: AppThemeColors.darkError,
    onError: AppThemeColors.darkOnError,
    errorContainer: AppThemeColors.darkErrorContainer,
    surface: AppThemeColors.darkSurface,
    onSurface: AppThemeColors.darkOnSurface,
    onSurfaceVariant: AppThemeColors.darkOnSurfaceVariant,
    outline: AppThemeColors.darkBorder,
    outlineVariant: AppThemeColors.darkDivider,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppThemeColors.darkBackground,
    fontFamily: AppTypography.fontFamily,
    textTheme: AppTypography.createTextTheme(
      AppThemeColors.darkOnSurface,
      AppThemeColors.darkOnSurfaceVariant,
    ),
    extensions: const [AppStatusColors.dark],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppThemeColors.darkOnSurface,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    cardTheme: CardThemeData(
      color: AppThemeColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.largeRadius,
        side: const BorderSide(color: AppThemeColors.darkBorder, width: 1),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppThemeColors.darkSurface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
      titleTextStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppThemeColors.darkOnSurface,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 13,
        color: AppThemeColors.darkOnSurfaceVariant,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppThemeColors.darkSurface,
      modalBackgroundColor: AppThemeColors.darkSurface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 132, 144, 252),
        foregroundColor: AppThemeColors.darkOnPrimary,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mediumRadius),
        textStyle: const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppThemeColors.darkPrimary,
        side: const BorderSide(color: AppThemeColors.darkBorder, width: 1),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mediumRadius),
        textStyle: const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppThemeColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: AppRadius.mediumRadius,
        borderSide: const BorderSide(color: AppThemeColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.mediumRadius,
        borderSide: const BorderSide(color: AppThemeColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.mediumRadius,
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 132, 140, 252),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.mediumRadius,
        borderSide: const BorderSide(color: AppThemeColors.darkError),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      labelStyle: const TextStyle(
        color: AppThemeColors.darkOnSurfaceVariant,
        fontSize: 13,
      ),
      hintStyle: const TextStyle(
        color: AppThemeColors.darkOnSurfaceVariant,
        fontSize: 13,
      ),
    ),
  );
}

