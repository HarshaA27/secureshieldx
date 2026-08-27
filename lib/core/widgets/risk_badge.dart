import 'package:flutter/material.dart';
import '../theme/app_style.dart';
import '../theme/risk_theme_extension.dart';

enum RiskLevel { critical, high, medium, safe }
enum RiskBadgeSize { small, medium, large }

class RiskBadge extends StatelessWidget {
  final RiskLevel level;
  final String? customLabel;
  final RiskBadgeSize size;
  final bool showIcon;
  final bool showGlowDot;
  final bool useGradientFill;

  const RiskBadge({
    super.key,
    required this.level,
    this.customLabel,
    this.size = RiskBadgeSize.medium,
    this.showIcon = true,
    this.showGlowDot = true,
    this.useGradientFill = false,
  });

  String get _defaultLabel {
    switch (level) {
      case RiskLevel.critical:
        return 'Critical Risk';
      case RiskLevel.high:
        return 'High Risk';
      case RiskLevel.medium:
        return 'Medium Risk';
      case RiskLevel.safe:
        return 'Safe App';
    }
  }

  IconData get _iconData {
    switch (level) {
      case RiskLevel.critical:
        return Icons.gpp_maybe_rounded;
      case RiskLevel.high:
        return Icons.warning_amber_rounded;
      case RiskLevel.medium:
        return Icons.info_outline_rounded;
      case RiskLevel.safe:
        return Icons.verified_user_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final riskTheme = Theme.of(context).extension<AppRiskTheme>() ?? AppRiskTheme.light;
    final labelText = customLabel ?? _defaultLabel;

    Color badgeColor;
    Color bgColor;
    Color borderColor;
    LinearGradient gradient;

    switch (level) {
      case RiskLevel.critical:
        badgeColor = riskTheme.critical;
        bgColor = riskTheme.criticalBg;
        borderColor = riskTheme.criticalBorder;
        gradient = riskTheme.criticalGradient;
        break;
      case RiskLevel.high:
        badgeColor = riskTheme.high;
        bgColor = riskTheme.highBg;
        borderColor = riskTheme.highBorder;
        gradient = riskTheme.highGradient;
        break;
      case RiskLevel.medium:
        badgeColor = riskTheme.medium;
        bgColor = riskTheme.mediumBg;
        borderColor = riskTheme.mediumBorder;
        gradient = riskTheme.mediumGradient;
        break;
      case RiskLevel.safe:
        badgeColor = riskTheme.safe;
        bgColor = riskTheme.safeBg;
        borderColor = riskTheme.safeBorder;
        gradient = riskTheme.safeGradient;
        break;
    }

    double verticalPadding;
    double horizontalPadding;
    double fontSize;
    double iconSize;
    double dotSize;

    switch (size) {
      case RiskBadgeSize.small:
        verticalPadding = 4;
        horizontalPadding = 10;
        fontSize = 11;
        iconSize = 13;
        dotSize = 6;
        break;
      case RiskBadgeSize.medium:
        verticalPadding = 6;
        horizontalPadding = 14;
        fontSize = 13;
        iconSize = 16;
        dotSize = 8;
        break;
      case RiskBadgeSize.large:
        verticalPadding = 8;
        horizontalPadding = 18;
        fontSize = 14;
        iconSize = 18;
        dotSize = 10;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        color: useGradientFill ? null : bgColor,
        gradient: useGradientFill ? gradient : null,
        borderRadius: AppStyle.borderPill,
        border: useGradientFill ? null : Border.all(color: borderColor.withValues(alpha: 0.8), width: 1.2),
        boxShadow: showGlowDot && !useGradientFill ? AppStyle.riskGlow(badgeColor.withValues(alpha: 0.2)) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showGlowDot) ...[
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: useGradientFill ? Colors.white : badgeColor,
                boxShadow: [
                  BoxShadow(
                    color: (useGradientFill ? Colors.white : badgeColor).withValues(alpha: 0.8),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            SizedBox(width: size == RiskBadgeSize.small ? 6 : 8),
          ],
          if (showIcon) ...[
            Icon(
              _iconData,
              size: iconSize,
              color: useGradientFill ? Colors.white : badgeColor,
            ),
            SizedBox(width: size == RiskBadgeSize.small ? 4 : 6),
          ],
          Text(
            labelText,
            style: TextStyle(
              color: useGradientFill ? Colors.white : badgeColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
