import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppFonts {
  static const String defaultFont = 'OpenSans';
  static const String pixelFont = 'PressStart2p';
}

class AppFontSizes {
  static const double extraLarge = 25.0;
  static const double large = 21.0;
  static const double medium = 18.0;
  static const double small = 16.0;
  static const double extraSmall = 14.0;
}

class AppTextStyles {
  // TITOLI
  static const TextStyle title = TextStyle(
    fontFamily: AppFonts.defaultFont,
    fontSize: AppFontSizes.extraLarge,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle smallTitle = TextStyle(
    fontFamily: AppFonts.defaultFont,
    fontSize: AppFontSizes.large,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // SOTTOTITOLI
  static const TextStyle subtitle = TextStyle(
    fontFamily: AppFonts.defaultFont,
    fontSize: AppFontSizes.extraSmall,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle subtitleWhite = TextStyle(
    fontFamily: AppFonts.defaultFont,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  // BODY
  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.defaultFont,
    fontSize: AppFontSizes.small,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: AppFonts.defaultFont,
    fontSize: AppFontSizes.medium,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
  );

  // PIXEL FONT PER NOMI BUS
  static const TextStyle pixel = TextStyle(
    fontFamily: AppFonts.pixelFont,
    fontWeight: FontWeight.w400,
    fontSize: 35,
    color: Colors.white,
  );
}
