import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData createTheme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: isDark
          ? const ColorScheme.dark(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.surfaceDark,
              surfaceContainer: Color.fromARGB(255, 36, 36, 36),
              surfaceContainerLow: Color.fromARGB(255, 54, 54, 54),
              error: AppColors.error,
              onSurface: Color.fromARGB(255, 240, 240, 240),
              outline: Color.fromARGB(255, 89, 89, 89),
            )
          : const ColorScheme.light(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.surface,
              surfaceContainer: Color.fromARGB(255, 255, 255, 255),
              surfaceContainerLow: Color.fromARGB(255, 247, 247, 247),
              error: AppColors.error,
              onSurface: Color.fromARGB(255, 37, 37, 37),
              outline: Color.fromARGB(255, 185, 185, 185),
            ),
      textTheme: const TextTheme(
        displayLarge: AppTypography.h1,
        displayMedium: AppTypography.h2,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        labelLarge: AppTypography.button,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        color: isDark ? Colors.grey[900] : AppColors.grey50,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return isDark ? AppColors.grey700 : AppColors.grey300;
            }
            return AppColors.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return isDark
                  ? AppColors.grey500
                  : const Color.fromARGB(153, 244, 244, 244);
            }
            return Colors.white;
          }),
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return 0;
            }
            return 2;
          }),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
          ),
          minimumSize: WidgetStateProperty.all(const Size(120, 48)),
          textStyle: WidgetStateProperty.all(
            AppTypography.button.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.1)),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
        foregroundColor: isDark ? Colors.white : AppColors.grey700,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.grey700 : AppColors.grey50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: isDark ? AppColors.grey300 : AppColors.grey500,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: isDark ? AppColors.grey300 : AppColors.grey700,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: isDark ? Colors.white : Colors.white,
        ),
        backgroundColor: isDark ? AppColors.grey700 : AppColors.grey900,
      ),
    );
  }

  static ThemeData get light => createTheme(brightness: Brightness.light);
  static ThemeData get dark => createTheme(brightness: Brightness.dark);
}
