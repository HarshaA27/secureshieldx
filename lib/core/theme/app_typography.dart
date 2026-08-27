import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// SecureShield X Modern Typography Scale (Material 3)
abstract class AppTypography {
  static TextTheme createTextTheme(Color defaultTextColor) {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return baseTextTheme.copyWith(
      // Display Styles - Large Hero Metrics & Title Banners
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 57,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
        height: 1.12,
        color: defaultTextColor,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.16,
        color: defaultTextColor,
      ),
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: defaultTextColor,
      ),

      // Headline Styles - Main Section Headers & Risk Alerts
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        height: 1.25,
        color: defaultTextColor,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.29,
        color: defaultTextColor,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.0,
        height: 1.33,
        color: defaultTextColor,
      ),

      // Title Styles - Cards, App Bar & Feature Headers
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
        height: 1.35,
        color: defaultTextColor,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.4,
        color: defaultTextColor,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
        color: defaultTextColor,
      ),

      // Body Styles - AI Explanations & Descriptions
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.5,
        color: defaultTextColor,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
        color: defaultTextColor,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
        color: defaultTextColor,
      ),

      // Label Styles - Buttons, Risk Badges, Captions
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
        color: defaultTextColor,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.33,
        color: defaultTextColor,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        height: 1.4,
        color: defaultTextColor,
      ),
    );
  }
}
