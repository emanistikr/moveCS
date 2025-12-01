import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withOpacity(.3),

        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.secondary,
            ); // icona selezionata
          }
          return IconThemeData(color: AppColors.textGray);
        }),
      ),

      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,

        secondary: AppColors.secondary,
        onSecondary: Colors.white,

        background: AppColors.background,
        onBackground: AppColors.textDark,

        surface: AppColors.surface,
        onSurface: AppColors.textDark,

        shadow: Colors.black12,

        error: AppColors.error,
        onError: Colors.white,

        tertiary: AppColors.textGray,
      ),

      iconTheme: const IconThemeData(color: AppColors.textDark),

      useMaterial3: true,
    );
  }

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: AppColors.primary.withOpacity(.3),

        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.textLight,
            ); // icona selezionata
          }
          return IconThemeData(color: AppColors.textLightGray);
        }),
      ),

      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: AppColors.secondary,

        secondary: AppColors.secondary,
        onSecondary: Colors.white,

        background: AppColors.backgroundDark,
        onBackground: AppColors.textLight,

        surface: AppColors.surfaceDark,
        onSurface: AppColors.textLight,

        shadow: Colors.white12,

        error: AppColors.error,
        onError: Colors.white,

        tertiary: AppColors.darkElements,
      ),

      iconTheme: const IconThemeData(color: AppColors.textLight),

      useMaterial3: true,
    );
  }
}
