import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppStyles {
  AppStyles._();

  static TextStyle get heroTitle => GoogleFonts.cairo(
        fontWeight: FontWeight.w900,
        fontSize: 32,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get screenTitle => GoogleFonts.cairo(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: AppColors.textPrimary,
      );

  static TextStyle get sectionTitle => GoogleFonts.cairo(
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: AppColors.textPrimary,
      );

  static TextStyle get cardTitle => GoogleFonts.cairo(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyText => GoogleFonts.cairo(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodyTextBold => GoogleFonts.cairo(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColors.textPrimary,
      );

  static TextStyle get caption => GoogleFonts.cairo(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: AppColors.textMuted,
      );

  static TextStyle get buttonText => GoogleFonts.cairo(
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: AppColors.textOnAccent,
      );

  static TextStyle get numberLarge => GoogleFonts.cairo(
        fontWeight: FontWeight.w800,
        fontSize: 28,
        color: AppColors.accent,
      );

  static TextStyle get numberMedium => GoogleFonts.cairo(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: AppColors.textPrimary,
      );

  static TextStyle get chipText => GoogleFonts.cairo(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: AppColors.textPrimary,
      );

  static List<BoxShadow> get cardShadow => [
        const BoxShadow(
          color: Color(0x40000000),
          blurRadius: 20,
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> glowShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.3),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  static BoxDecoration get glassmorphism => BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: cardShadow,
      );
}
