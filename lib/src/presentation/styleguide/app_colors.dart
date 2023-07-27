import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFF9B51E0);
  static const secondaryColor = Color(0xFF333333);
  static const accentColor = Color(0xFFF2F2F2);
  static const positiveColor = Color(0xFF6BC992);
  static const neutralColor = Color(0xFFFFC107); // Amber color
  static const negativeColor =
      Color(0xFFB71C1C); // Red color for negative content
  static const linearGradientStart = Color(0xFF9D50BB);
  static const linearGradientEnd = Color(0xFF6E48AA);
  static const backgroundGradient =
      LinearGradient(colors: [linearGradientStart, linearGradientEnd]);
}

class AppThemes {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColors.primaryColor,
      background: AppColors.secondaryColor,
      onBackground: AppColors.accentColor,
      error: AppColors.negativeColor,
    ),
  );
}
