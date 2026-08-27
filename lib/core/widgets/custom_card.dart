import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_style.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final LinearGradient? borderGradient;
  final Color? backgroundColor;
  final List<BoxShadow>? customShadows;
  final double borderRadius;
  final bool hasGlassEffect;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderGradient,
    this.backgroundColor,
    this.customShadows,
    this.borderRadius = AppStyle.radiusMd,
    this.hasGlassEffect = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBgColor = backgroundColor ??
        (isDark
            ? (hasGlassEffect ? AppColors.darkSurface.withValues(alpha: 0.7) : AppColors.darkSurface)
            : (hasGlassEffect ? AppColors.lightSurface.withValues(alpha: 0.85) : AppColors.lightSurface));

    final shadows = customShadows ?? (isDark ? AppStyle.shadowSoftDark : AppStyle.shadowSoftLight);

    final borderDecoration = borderGradient != null
        ? BoxDecoration(
            gradient: borderGradient,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: shadows,
          )
        : BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: shadows,
          );

    Widget innerCard = Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(borderGradient != null ? borderRadius - 1.5 : borderRadius),
        border: borderGradient == null
            ? Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20.0),
            child: child,
          ),
        ),
      ),
    );

    if (borderGradient != null) {
      return Container(
        decoration: borderDecoration,
        padding: const EdgeInsets.all(1.5), // Gradient border width
        child: innerCard,
      );
    }

    return Container(
      decoration: borderDecoration,
      child: innerCard,
    );
  }
}
