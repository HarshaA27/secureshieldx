import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_style.dart';

enum CustomButtonVariant { primary, secondary, outline, ghost, critical }
enum CustomButtonSize { small, medium, large }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final CustomButtonVariant variant;
  final CustomButtonSize size;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.variant = CustomButtonVariant.primary,
    this.size = CustomButtonSize.medium,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  EdgeInsets get _padding {
    switch (widget.size) {
      case CustomButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case CustomButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
      case CustomButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 28, vertical: 18);
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case CustomButtonSize.small:
        return 13;
      case CustomButtonSize.medium:
        return 15;
      case CustomButtonSize.large:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget child = AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: AppStyle.durationFast,
      child: AnimatedContainer(
        duration: AppStyle.durationFast,
        decoration: _buildDecoration(context, isDark),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTapDown: widget.onPressed != null && !widget.isLoading ? (_) => setState(() => _isPressed = true) : null,
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: widget.onPressed != null && !widget.isLoading
                ? () {
                    setState(() => _isPressed = false);
                    widget.onPressed!();
                  }
                : null,
            borderRadius: AppStyle.borderMd,
            child: Padding(
              padding: _padding,
              child: Row(
                mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading) ...[
                    SizedBox(
                      width: _fontSize + 2,
                      height: _fontSize + 2,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(_getTextColor(context, isDark)),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ] else if (widget.icon != null) ...[
                    IconTheme(
                      data: IconThemeData(color: _getTextColor(context, isDark), size: _fontSize + 4),
                      child: widget.icon!,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: _getTextColor(context, isDark),
                      fontSize: _fontSize,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.isFullWidth) {
      return SizedBox(width: double.infinity, child: child);
    }
    return child;
  }

  BoxDecoration _buildDecoration(BuildContext context, bool isDark) {
    if (widget.onPressed == null) {
      return BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
        borderRadius: AppStyle.borderMd,
      );
    }

    switch (widget.variant) {
      case CustomButtonVariant.primary:
        return BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppStyle.borderMd,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.4 : 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        );
      case CustomButtonVariant.critical:
        return BoxDecoration(
          gradient: AppColors.criticalGradient,
          borderRadius: AppStyle.borderMd,
          boxShadow: [
            BoxShadow(
              color: AppColors.riskCritical.withValues(alpha: isDark ? 0.4 : 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        );
      case CustomButtonVariant.secondary:
        return BoxDecoration(
          color: isDark ? AppColors.secondaryDark.withValues(alpha: 0.2) : AppColors.secondary.withValues(alpha: 0.12),
          borderRadius: AppStyle.borderMd,
          border: Border.all(
            color: AppColors.secondary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        );
      case CustomButtonVariant.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: AppStyle.borderMd,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1.5,
          ),
        );
      case CustomButtonVariant.ghost:
        return const BoxDecoration(
          color: Colors.transparent,
        );
    }
  }

  Color _getTextColor(BuildContext context, bool isDark) {
    if (widget.onPressed == null) {
      return isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    }

    switch (widget.variant) {
      case CustomButtonVariant.primary:
      case CustomButtonVariant.critical:
        return Colors.white;
      case CustomButtonVariant.secondary:
        return isDark ? AppColors.secondaryLight : AppColors.primaryDark;
      case CustomButtonVariant.outline:
      case CustomButtonVariant.ghost:
        return isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    }
  }
}
