import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Flutter ThemeExtension for Risk Levels (Critical, High, Medium, Safe)
class AppRiskTheme extends ThemeExtension<AppRiskTheme> {
  final Color critical;
  final Color criticalBg;
  final Color criticalBorder;
  final Color high;
  final Color highBg;
  final Color highBorder;
  final Color medium;
  final Color mediumBg;
  final Color mediumBorder;
  final Color safe;
  final Color safeBg;
  final Color safeBorder;

  final LinearGradient criticalGradient;
  final LinearGradient highGradient;
  final LinearGradient mediumGradient;
  final LinearGradient safeGradient;

  const AppRiskTheme({
    required this.critical,
    required this.criticalBg,
    required this.criticalBorder,
    required this.high,
    required this.highBg,
    required this.highBorder,
    required this.medium,
    required this.mediumBg,
    required this.mediumBorder,
    required this.safe,
    required this.safeBg,
    required this.safeBorder,
    required this.criticalGradient,
    required this.highGradient,
    required this.mediumGradient,
    required this.safeGradient,
  });

  static const AppRiskTheme light = AppRiskTheme(
    critical: AppColors.riskCritical,
    criticalBg: AppColors.riskCriticalBgLight,
    criticalBorder: AppColors.riskCriticalBorderLight,
    high: AppColors.riskHigh,
    highBg: AppColors.riskHighBgLight,
    highBorder: AppColors.riskHighBorderLight,
    medium: AppColors.riskMedium,
    mediumBg: AppColors.riskMediumBgLight,
    mediumBorder: AppColors.riskMediumBorderLight,
    safe: AppColors.riskSafe,
    safeBg: AppColors.riskSafeBgLight,
    safeBorder: AppColors.riskSafeBorderLight,
    criticalGradient: LinearGradient(
      colors: [Color(0xFFFF2A55), Color(0xFFFF7043)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    highGradient: LinearGradient(
      colors: [Color(0xFFFF7043), Color(0xFFFFB300)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    mediumGradient: LinearGradient(
      colors: [Color(0xFFD97706), Color(0xFFFBBF24)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    safeGradient: LinearGradient(
      colors: [Color(0xFF00E676), Color(0xFF00D2D3)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const AppRiskTheme dark = AppRiskTheme(
    critical: AppColors.riskCriticalDark,
    criticalBg: AppColors.riskCriticalBgDark,
    criticalBorder: AppColors.riskCriticalBorderDark,
    high: AppColors.riskHighDark,
    highBg: AppColors.riskHighBgDark,
    highBorder: AppColors.riskHighBorderDark,
    medium: AppColors.riskMediumDark,
    mediumBg: AppColors.riskMediumBgDark,
    mediumBorder: AppColors.riskMediumBorderDark,
    safe: AppColors.riskSafeDark,
    safeBg: AppColors.riskSafeBgDark,
    safeBorder: AppColors.riskSafeBorderDark,
    criticalGradient: LinearGradient(
      colors: [Color(0xFFFF4D6D), Color(0xFFFF8A65)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    highGradient: LinearGradient(
      colors: [Color(0xFFFF8A65), Color(0xFFFFD54F)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    mediumGradient: LinearGradient(
      colors: [Color(0xFFFFD54F), Color(0xFFFFE082)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    safeGradient: LinearGradient(
      colors: [Color(0xFF69F0AE), Color(0xFF54E0E1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  @override
  AppRiskTheme copyWith({
    Color? critical,
    Color? criticalBg,
    Color? criticalBorder,
    Color? high,
    Color? highBg,
    Color? highBorder,
    Color? medium,
    Color? mediumBg,
    Color? mediumBorder,
    Color? safe,
    Color? safeBg,
    Color? safeBorder,
    LinearGradient? criticalGradient,
    LinearGradient? highGradient,
    LinearGradient? mediumGradient,
    LinearGradient? safeGradient,
  }) {
    return AppRiskTheme(
      critical: critical ?? this.critical,
      criticalBg: criticalBg ?? this.criticalBg,
      criticalBorder: criticalBorder ?? this.criticalBorder,
      high: high ?? this.high,
      highBg: highBg ?? this.highBg,
      highBorder: highBorder ?? this.highBorder,
      medium: medium ?? this.medium,
      mediumBg: mediumBg ?? this.mediumBg,
      mediumBorder: mediumBorder ?? this.mediumBorder,
      safe: safe ?? this.safe,
      safeBg: safeBg ?? this.safeBg,
      safeBorder: safeBorder ?? this.safeBorder,
      criticalGradient: criticalGradient ?? this.criticalGradient,
      highGradient: highGradient ?? this.highGradient,
      mediumGradient: mediumGradient ?? this.mediumGradient,
      safeGradient: safeGradient ?? this.safeGradient,
    );
  }

  @override
  AppRiskTheme lerp(ThemeExtension<AppRiskTheme>? other, double t) {
    if (other is! AppRiskTheme) return this;
    return AppRiskTheme(
      critical: Color.lerp(critical, other.critical, t)!,
      criticalBg: Color.lerp(criticalBg, other.criticalBg, t)!,
      criticalBorder: Color.lerp(criticalBorder, other.criticalBorder, t)!,
      high: Color.lerp(high, other.high, t)!,
      highBg: Color.lerp(highBg, other.highBg, t)!,
      highBorder: Color.lerp(highBorder, other.highBorder, t)!,
      medium: Color.lerp(medium, other.medium, t)!,
      mediumBg: Color.lerp(mediumBg, other.mediumBg, t)!,
      mediumBorder: Color.lerp(mediumBorder, other.mediumBorder, t)!,
      safe: Color.lerp(safe, other.safe, t)!,
      safeBg: Color.lerp(safeBg, other.safeBg, t)!,
      safeBorder: Color.lerp(safeBorder, other.safeBorder, t)!,
      criticalGradient: LinearGradient.lerp(criticalGradient, other.criticalGradient, t)!,
      highGradient: LinearGradient.lerp(highGradient, other.highGradient, t)!,
      mediumGradient: LinearGradient.lerp(mediumGradient, other.mediumGradient, t)!,
      safeGradient: LinearGradient.lerp(safeGradient, other.safeGradient, t)!,
    );
  }
}
