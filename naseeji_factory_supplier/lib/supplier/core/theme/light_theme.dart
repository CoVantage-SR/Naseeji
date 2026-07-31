import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme_colors.dart';
import 'theme_radius.dart';
import 'theme_typography.dart';
import 'theme_extensions.dart';

ThemeData buildLightTheme() {
  const colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 60, 51, 234),
    onPrimary: AppThemeColors.lightOnPrimary,
    primaryContainer: AppThemeColors.lightPrimaryContainer,
    onPrimaryContainer: Color.fromARGB(255, 33, 69, 168),
    secondary: AppThemeColors.lightSecondary,
    onSecondary: AppThemeColors.lightOnSecondary,
    secondaryContainer: AppThemeColors.lightSecondaryContainer,
    onSecondaryContainer: AppThemeColors.lightOnSecondaryContainer,
    error: AppThemeColors.lightError,
    onError: AppThemeColors.lightOnError,
    errorContainer: AppThemeColors.lightErrorContainer,
    surface: AppThemeColors.lightSurface,
    onSurface: AppThemeColors.lightOnSurface,
    onSurfaceVariant: AppThemeColors.lightOnSurfaceVariant,
    outline: AppThemeColors.lightBorder,
    outlineVariant: AppThemeColors.lightDivider,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppThemeColors.lightBackground,
    fontFamily: AppTypography.fontFamily,
    textTheme: AppTypography.createTextTheme(
      AppThemeColors.lightOnSurface,
      AppThemeColors.lightOnSurfaceVariant,
    ),
    extensions: const [
      AppStatusColors.light,
    ],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppThemeColors.lightOnSurface,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    cardTheme: CardThemeData(
      color: AppThemeColors.lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.largeRadius,
        side: const BorderSide(color: AppThemeColors.lightBorder, width: 1),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppThemeColors.lightSurface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
      titleTextStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppThemeColors.lightOnSurface,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 13,
        color: AppThemeColors.lightOnSurfaceVariant,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppThemeColors.lightSurface,
      modalBackgroundColor: AppThemeColors.lightSurface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 51, 72, 234),
        foregroundColor: AppThemeColors.lightOnPrimary,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mediumRadius,
        ),
        textStyle: const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 51, 72, 234),
        side: const BorderSide(color: AppThemeColors.lightBorder, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mediumRadius,
        ),
        textStyle: const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppThemeColors.lightSurface,
      border: OutlineInputBorder(
        borderRadius: AppRadius.mediumRadius,
        borderSide: const BorderSide(color: AppThemeColors.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.mediumRadius,
        borderSide: const BorderSide(color: AppThemeColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.mediumRadius,
        borderSide: const BorderSide(color: Color.fromARGB(255, 51, 75, 234), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.mediumRadius,
        borderSide: const BorderSide(color: AppThemeColors.lightError),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      labelStyle: const TextStyle(color: AppThemeColors.lightOnSurfaceVariant, fontSize: 13),
      hintStyle: const TextStyle(color: AppThemeColors.lightOnSurfaceVariant, fontSize: 13),
    ),
  );
}


