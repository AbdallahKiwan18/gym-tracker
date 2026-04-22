import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary dark backgrounds
  static const Color scaffoldBg = Color(0xFF0A0A0F);
  static const Color cardBg = Color(0xFF14141F);
  static const Color cardBgLight = Color(0xFF1C1C2E);
  static const Color surfaceBg = Color(0xFF1E1E30);

  // Accent - Neon Green/Lime
  static const Color accent = Color(0xFF00E676);
  static const Color accentLight = Color(0xFF69F0AE);
  static const Color accentDark = Color(0xFF00C853);
  static const Color accentGlow = Color(0x3300E676);

  // Category Colors
  static const Color pushColor = Color(0xFFFF6B6B);
  static const Color pullColor = Color(0xFF4FC3F7);
  static const Color legColor = Color(0xFFFFD54F);
  static const Color crossfitColor = Color(0xFFFF8A65);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C0);
  static const Color textMuted = Color(0xFF6B6B80);
  static const Color textOnAccent = Color(0xFF0A0A0F);

  // Status
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFD54F);
  static const Color danger = Color(0xFFFF5252);
  static const Color neutral = Color(0xFF78909C);

  // Border & Divider
  static const Color border = Color(0xFF2A2A40);
  static const Color divider = Color(0xFF1E1E30);

  // Gradient
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00BFA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pushGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pullGradient = LinearGradient(
    colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient legGradient = LinearGradient(
    colors: [Color(0xFFFFD54F), Color(0xFFF9A825)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient crossfitGradient = LinearGradient(
    colors: [Color(0xFFFF8A65), Color(0xFFE64A19)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient getGradientForCategory(String category) {
    switch (category) {
      case 'push':
        return pushGradient;
      case 'pull':
        return pullGradient;
      case 'leg':
        return legGradient;
      case 'crossfit':
        return crossfitGradient;
      default:
        return accentGradient;
    }
  }

  static Color getColorForCategory(String category) {
    switch (category) {
      case 'push':
        return pushColor;
      case 'pull':
        return pullColor;
      case 'leg':
        return legColor;
      case 'crossfit':
        return crossfitColor;
      default:
        return accent;
    }
  }
}
