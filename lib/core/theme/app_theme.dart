import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    final text = GoogleFonts.plusJakartaSansTextTheme(base.textTheme)
        .apply(bodyColor: AppColors.ink, displayColor: AppColors.ink);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.warmWhite,
      textTheme: text,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blushDeep,
        primary: AppColors.lavenderDeep,
        secondary: AppColors.teal,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.warmWhite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      // FIX: CardTheme → CardThemeData (Flutter 3.22+)
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF4EEF0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lavenderDeep, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lavenderDeep,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF16141A),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blushDeep,
        brightness: Brightness.dark,
        primary: AppColors.lavender,
        secondary: AppColors.teal,
      ),
      cardTheme: const CardThemeData(color: Color(0xFF1E1B24), elevation: 0),
    );
  }
}