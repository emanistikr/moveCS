import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFontSizes {
  static const double extraLarge = 25.0;
  static const double large = 21.0;
  static const double medium = 18.0;
  static const double small = 16.0;
  static const double extraSmall = 14.0;
}

class AppTheme {
  //costruisce lo stile del testo
  static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      displayLarge: GoogleFonts.openSans(
        fontSize: AppFontSizes.extraLarge,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),

      titleLarge: GoogleFonts.openSans(
        fontSize: AppFontSizes.extraLarge,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),

      titleMedium: GoogleFonts.openSans(
        fontSize: AppFontSizes.large,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),

      bodyLarge: GoogleFonts.openSans(
        fontSize: AppFontSizes.small,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),

      bodyMedium: GoogleFonts.openSans(
        fontSize: AppFontSizes.medium,
        fontWeight: FontWeight.w300,
        color: secondaryColor,
      ),

      labelMedium: GoogleFonts.openSans(
        fontSize: AppFontSizes.small,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),

      labelSmall: GoogleFonts.openSans(
        fontSize: AppFontSizes.extraSmall,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),

      displaySmall: GoogleFonts.pixelifySans(
        fontWeight: FontWeight.w600,
        fontSize: AppFontSizes.large,
        color: Colors.white,
      ),
    );
  }

  // TEMA CHIARO (Light Mode)
  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,

      textTheme: _buildTextTheme(AppColors.textDark, AppColors.textGray),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withOpacity(.3),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.secondary);
          }
          return const IconThemeData(color: AppColors.textGray);
        }),
      ),

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textDark,
        onSurfaceVariant: AppColors.textGray,
        background: AppColors.background,
        onBackground: AppColors.textDark,
        shadow: Colors.black12,
        error: AppColors.error,
        onError: Colors.white,
        tertiary: AppColors.textGray,
      ),

      iconTheme: const IconThemeData(color: AppColors.textDark),
      useMaterial3: true,
    );
  }

  // TEMA SCURO (Dark Mode)
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,

      textTheme: _buildTextTheme(AppColors.textLight, AppColors.textLightGray),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: AppColors.primary.withOpacity(.3),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.textLight);
          }
          return const IconThemeData(color: AppColors.textLightGray);
        }),
      ),

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.secondary,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textLight,
        onSurfaceVariant: AppColors.textLightGray,
        background: AppColors.backgroundDark,
        onBackground: AppColors.textLight,
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
