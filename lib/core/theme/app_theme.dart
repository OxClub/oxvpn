import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const background = Color(0xFF14151F);
  static const serversBg = Color(0xFF1C1C1E);
  static const card = Color(0xFF1E1E22);
  static const input = Color(0xFF2A2A2E);
  static const accent = Color(0xFFD24034);
  static const accentGreen = Color(0xFF2ECC71);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFF8A8A8E);
  static const premiumStart = Color(0xFFE0685F);
  static const premiumEnd = Color(0xFFCF3E32);
  static const premiumGradient = LinearGradient(
    colors: [premiumStart, premiumEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

ThemeData buildDarkTheme() => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'Roboto',
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    brightness: Brightness.dark,
  ).copyWith(surface: AppColors.background, primary: AppColors.accent),
  cardTheme: const CardTheme(
    color: AppColors.card,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  ),
);

ThemeData buildLightTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent),
  fontFamily: 'Roboto',
);
