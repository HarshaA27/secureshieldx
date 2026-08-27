import 'package:flutter/material.dart';

/// SecureShield X Color System (2026 Security & Fintech Palette)
abstract class AppColors {
  // Brand Primary & Secondary Accents
  static const Color primary = Color(0xFF5B3EFE); // Electric Violet
  static const Color primaryLight = Color(0xFF7C66FF);
  static const Color primaryDark = Color(0xFF3F21E5);

  static const Color secondary = Color(0xFF00D2D3); // Cyber Cyan
  static const Color secondaryLight = Color(0xFF54E0E1);
  static const Color secondaryDark = Color(0xFF00B3B4);

  // Neutral Backgrounds & Surfaces - Light Mode
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Neutral Backgrounds & Surfaces - Dark Mode (OLED / Cyber Slate)
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF161B26);
  static const Color darkSurfaceVariant = Color(0xFF1F2636);
  static const Color darkBorder = Color(0xFF2E374A);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Risk Palette - Critical (Neon Crimson Red)
  static const Color riskCritical = Color(0xFFFF2A55);
  static const Color riskCriticalDark = Color(0xFFFF4D6D);
  static const Color riskCriticalBgLight = Color(0xFFFFF0F3);
  static const Color riskCriticalBgDark = Color(0xFF3D0B16);
  static const Color riskCriticalBorderLight = Color(0xFFFFCCD5);
  static const Color riskCriticalBorderDark = Color(0xFF6D1429);

  // Risk Palette - High (Vivid Flame Orange)
  static const Color riskHigh = Color(0xFFFF7043);
  static const Color riskHighDark = Color(0xFFFF8A65);
  static const Color riskHighBgLight = Color(0xFFFFF4EE);
  static const Color riskHighBgDark = Color(0xFF3E1C10);
  static const Color riskHighBorderLight = Color(0xFFFFD7C7);
  static const Color riskHighBorderDark = Color(0xFF6E2C14);

  // Risk Palette - Medium (Warm Solar Amber)
  static const Color riskMedium = Color(0xFFD97706);
  static const Color riskMediumDark = Color(0xFFFFD54F);
  static const Color riskMediumBgLight = Color(0xFFFFFBEB);
  static const Color riskMediumBgDark = Color(0xFF382A05);
  static const Color riskMediumBorderLight = Color(0xFFFDE68A);
  static const Color riskMediumBorderDark = Color(0xFF634A08);

  // Risk Palette - Safe (Mint Emerald Green)
  static const Color riskSafe = Color(0xFF00E676);
  static const Color riskSafeDark = Color(0xFF69F0AE);
  static const Color riskSafeBgLight = Color(0xFFE8FDF2);
  static const Color riskSafeBgDark = Color(0xFF052B19);
  static const Color riskSafeBorderLight = Color(0xFFA7F3D0);
  static const Color riskSafeBorderDark = Color(0xFF0D5432);

  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5B3EFE), Color(0xFF00D2D3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient criticalGradient = LinearGradient(
    colors: [Color(0xFFFF2A55), Color(0xFFFF7043)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient safeGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00D2D3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGlassGradient = LinearGradient(
    colors: [Color(0x20FFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
