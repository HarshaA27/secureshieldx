import 'package:flutter/material.dart';

/// SecureShield X Design Token Helpers (Radii, Shadows, Durations)
abstract class AppStyle {
  // Border Radii
  static const double radiusSm = 8.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
  static const double radiusPill = 999.0;

  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderPill = BorderRadius.all(Radius.circular(radiusPill));

  // Soft Ambient Multi-layer Shadows (Light Mode)
  static List<BoxShadow> shadowSoftLight = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF5B3EFE).withValues(alpha: 0.05),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> shadowElevatedLight = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: const Color(0xFF5B3EFE).withValues(alpha: 0.08),
      blurRadius: 36,
      offset: const Offset(0, 18),
    ),
  ];

  // Soft Ambient Multi-layer Shadows (Dark Mode)
  static List<BoxShadow> shadowSoftDark = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.35),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: const Color(0xFF5B3EFE).withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> shadowElevatedDark = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.55),
      blurRadius: 28,
      offset: const Offset(0, 14),
    ),
    BoxShadow(
      color: const Color(0xFF5B3EFE).withValues(alpha: 0.18),
      blurRadius: 40,
      offset: const Offset(0, 20),
    ),
  ];

  // Risk Glow Shadows
  static List<BoxShadow> riskGlow(Color riskColor) {
    return [
      BoxShadow(
        color: riskColor.withValues(alpha: 0.35),
        blurRadius: 14,
        spreadRadius: 1,
        offset: const Offset(0, 4),
      ),
    ];
  }

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationMedium = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
}
